const $ = id => document.getElementById(id);
const descriptions = {
  fcfs: "Processes run in arrival order. Once a process starts, it runs until completion.",
  sjf: "Among arrived processes, choose the one with the shortest burst time. It runs to completion.",
  srtf: "At each time unit, run the arrived process with the shortest remaining time. A process can be preempted.",
  priority: "Among arrived processes, choose the highest priority (the lowest priority number). Non-preemptive.",
  priorityp: "At each time unit, run the arrived process with the highest priority (lowest number). Preemptive.",
  rr: "Each ready process gets up to the selected time quantum, rotating through the ready queue.",
  hrrn: "Choose the arrived process with the largest response ratio: (waiting time + burst time) / burst time. Non-preemptive.",
  ljf: "Among arrived processes, choose the longest original burst time. Non-preemptive.",
  lrtf: "At each time unit, run the arrived process with the longest remaining time. Ties use arrival order.",
  mlq: "Fixed multilevel queues use the Priority field (1 is highest). The highest-priority non-empty queue runs first; each queue uses Round Robin with the selected quantum.",
  mlfq: "Three feedback queues: Q1 Round Robin quantum 2, Q2 Round Robin quantum 4, Q3 FCFS. Jobs that use their full quantum are demoted; higher-level arrivals preempt lower-level work."
};
const names = {
  fcfs:"FCFS",sjf:"SJF (Non-preemptive)",srtf:"SRTF (Preemptive)",
  priority:"Priority (Non-preemptive)",priorityp:"Priority (Preemptive)",rr:"Round Robin",
  hrrn:"HRRN",ljf:"LJF (Non-preemptive)",lrtf:"LRTF (Preemptive)",
  mlq:"MLQ (RR within fixed queues)",mlfq:"MLFQ (3 queues)"
};
let selected = "fcfs", processes = [], lastResults = null;
const palette = ["#5148d9","#0f9f91","#e58b35","#d45c7a","#4285d4","#7b61a8","#668d42","#c25c39"];
function setAlgorithm(algo){
  selected = algo;
  document.querySelectorAll(".algorithm").forEach(b=>b.classList.toggle("active",b.dataset.algo===algo));
  $("algorithmNote").textContent = descriptions[algo];
  document.querySelectorAll(".priority-field").forEach(e=>e.style.display=["priority","priorityp","mlq"].includes(algo)?"flex":"none");
  document.querySelectorAll(".quantum-field").forEach(e=>e.style.display=["rr","mlq"].includes(algo)?"flex":"none");
  $("resultAlgorithm").textContent = names[algo];
}
document.querySelectorAll(".algorithm").forEach(b=>b.addEventListener("click",()=>setAlgorithm(b.dataset.algo)));
function renderProcesses(){
  $("processRows").innerHTML = processes.map((p,i)=>`<tr><td><span class="pid-pill">${escapeHtml(p.id)}</span></td><td>${p.at}</td><td>${p.bt}</td><td>${p.priority}</td><td><button class="remove" aria-label="Remove ${escapeHtml(p.id)}" data-index="${i}">×</button></td></tr>`).join("");
  $("processCount").textContent = `${processes.length} process${processes.length===1?"":"es"}`;
  document.querySelectorAll(".remove").forEach(b=>b.addEventListener("click",()=>{processes.splice(Number(b.dataset.index),1);renderProcesses()}));
}
function escapeHtml(s){return String(s).replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]))}
$("addBtn").addEventListener("click",()=>{
  $("error").textContent="";
  const id=$("pid").value.trim(), at=Number($("arrival").value), bt=Number($("burst").value), priority=Number($("priority").value);
  if(!id){$("error").textContent="Enter a process ID.";return}
  if(processes.some(p=>p.id.toLowerCase()===id.toLowerCase())){$("error").textContent="Process IDs must be unique.";return}
  if(!Number.isInteger(at)||at<0||!Number.isInteger(bt)||bt<1||!Number.isInteger(priority)||priority<1){$("error").textContent="Use integer arrival ≥ 0, burst ≥ 1, and priority / queue ≥ 1.";return}
  processes.push({id,at,bt,priority,order:processes.length});
  renderProcesses(); $("pid").value=`P${processes.length+1}`; $("pid").focus();
});
$("clearBtn").addEventListener("click",()=>{processes=[];renderProcesses();$("error").textContent="";$("resultContent").hidden=true;$("emptyState").hidden=false;lastResults=null});
$("sampleBtn").addEventListener("click",()=>{processes=[{id:"P1",at:0,bt:5,priority:2,order:0},{id:"P2",at:1,bt:3,priority:1,order:1},{id:"P3",at:2,bt:8,priority:3,order:2},{id:"P4",at:3,bt:6,priority:2,order:3}];renderProcesses();$("error").textContent=""});

function schedule(){
  const ps=processes.map(p=>({...p,remaining:p.bt,firstStart:null,ct:null,level:0,used:0})), segments=[];
  let t=0, completed=0, guard=0;
  const addSegment=(id,start,end)=>{if(end<=start)return;const prev=segments[segments.length-1];if(prev&&prev.id===id&&prev.end===start)prev.end=end;else segments.push({id,start,end})};
  const ready=(time)=>ps.filter(p=>p.at<=time&&p.remaining>0);
  const choose=(arr,sorter)=>arr.slice().sort(sorter)[0];
  if(["fcfs","sjf","priority","hrrn","ljf"].includes(selected)){
    while(completed<ps.length&&guard++<100000){
      let candidates=ready(t);
      if(!candidates.length){const next=Math.min(...ps.filter(p=>p.remaining>0).map(p=>p.at));addSegment("IDLE",t,next);t=next;candidates=ready(t)}
      let p;
      if(selected==="fcfs")p=choose(candidates,(a,b)=>a.at-b.at||a.order-b.order);
      if(selected==="sjf")p=choose(candidates,(a,b)=>a.bt-b.bt||a.at-b.at||a.order-b.order);
      if(selected==="priority")p=choose(candidates,(a,b)=>a.priority-b.priority||a.at-b.at||a.order-b.order);
      if(selected==="hrrn")p=choose(candidates,(a,b)=>((t-a.at+a.bt)/a.bt)-((t-b.at+b.bt)/b.bt)===0?a.at-b.at:((t-b.at+b.bt)/b.bt)-((t-a.at+a.bt)/a.bt));
      if(selected==="ljf")p=choose(candidates,(a,b)=>b.bt-a.bt||a.at-b.at||a.order-b.order);
      if(p.firstStart===null)p.firstStart=t;
      addSegment(p.id,t,t+p.remaining);t+=p.remaining;p.remaining=0;p.ct=t;completed++;
    }
  } else if(selected==="rr"||selected==="mlq"){
    const q=Number($("quantum").value);
    if(!Number.isInteger(q)||q<1)throw Error("Time quantum must be a positive integer.");
    const queue=[];let nextIndex=0;const arrivals=ps.slice().sort((a,b)=>a.at-b.at||a.order-b.order);
    while(completed<ps.length&&guard++<100000){
      while(nextIndex<arrivals.length&&arrivals[nextIndex].at<=t)queue.push(arrivals[nextIndex++]);
      if(!queue.length){const next=arrivals[nextIndex].at;addSegment("IDLE",t,next);t=next;continue}
      let p;
      if(selected==="rr") p=queue.shift();
      else {
        const bestPriority=Math.min(...queue.map(x=>x.priority));
        const idx=queue.findIndex(x=>x.priority===bestPriority);p=queue.splice(idx,1)[0];
      }
      if(p.firstStart===null)p.firstStart=t;
      const run=Math.min(q,p.remaining),end=t+run;addSegment(p.id,t,end);t=end;p.remaining-=run;
      while(nextIndex<arrivals.length&&arrivals[nextIndex].at<=t)queue.push(arrivals[nextIndex++]);
      if(p.remaining>0)queue.push(p);else{p.ct=t;completed++}
    }
  } else if(["srtf","priorityp","lrtf"].includes(selected)){
    while(completed<ps.length&&guard++<100000){
      let candidates=ready(t);
      if(!candidates.length){const next=Math.min(...ps.filter(p=>p.remaining>0).map(p=>p.at));addSegment("IDLE",t,next);t=next;candidates=ready(t)}
      const sorter = selected==="srtf" ? (a,b)=>a.remaining-b.remaining||a.at-b.at||a.order-b.order
        : selected==="priorityp" ? (a,b)=>a.priority-b.priority||a.at-b.at||a.order-b.order
        : (a,b)=>b.remaining-a.remaining||a.at-b.at||a.order-b.order;
      const p=choose(candidates,sorter);
      if(p.firstStart===null)p.firstStart=t;
      addSegment(p.id,t,t+1);p.remaining--;t++;
      if(p.remaining===0){p.ct=t;completed++}
    }
  } else if(selected==="mlfq"){
    // Q1 RR q=2; Q2 RR q=4; Q3 FCFS. A job using its whole quantum is demoted.
    const queues=[[],[],[]], arrivals=ps.slice().sort((a,b)=>a.at-b.at||a.order-b.order);
    let nextIndex=0;
    while(completed<ps.length&&guard++<100000){
      while(nextIndex<arrivals.length&&arrivals[nextIndex].at<=t)queues[0].push(arrivals[nextIndex++]);
      let level=queues.findIndex(q=>q.length>0);
      if(level<0){const next=arrivals[nextIndex].at;addSegment("IDLE",t,next);t=next;continue}
      const p=queues[level].shift(), quantum=[2,4,Number.MAX_SAFE_INTEGER][level];
      if(p.firstStart===null)p.firstStart=t;
      let ran=0;
      while(ran<quantum&&p.remaining>0){
        // Arrivals in higher queue interrupt work from a lower queue at the next time unit.
        addSegment(p.id,t,t+1);p.remaining--;t++;ran++;
        while(nextIndex<arrivals.length&&arrivals[nextIndex].at<=t)queues[0].push(arrivals[nextIndex++]);
        if(queues[0].length>0&&level>0)break;
      }
      if(p.remaining===0){p.ct=t;completed++}
      else if(ran===quantum&&level<2){p.level=level+1;queues[level+1].push(p)}
      else queues[level].unshift(p);
    }
  }
  if(guard>=100000)throw Error("Simulation exceeded safety limit.");
  const rows=ps.map(p=>({...p,tat:p.ct-p.at,wt:p.ct-p.at-p.bt,rt:p.firstStart-p.at}));
  return {segments,rows};
}
function renderResults(result){
  lastResults=result;$("emptyState").hidden=true;$("resultContent").hidden=false;
  const total=result.segments[result.segments.length-1]?.end||1;
  $("gantt").innerHTML=result.segments.map((s,i)=>`<div class="gantt-block ${s.id==="IDLE"?"idle":""}" style="flex:${s.end-s.start} 1 0;background:${s.id==="IDLE"?"#a6adbb":palette[Math.max(0,processes.findIndex(p=>p.id===s.id))%palette.length]}" title="${s.id}: ${s.start}–${s.end}"><span>${escapeHtml(s.id)}</span></div>`).join("");
  $("timeline").innerHTML=Array.from(new Set(result.segments.flatMap(s=>[s.start,s.end]))).sort((a,b)=>a-b).map(t=>`<span class="tick" style="left:${t/total*100}%">${t}</span>`).join("");
  const avgWT=result.rows.reduce((a,p)=>a+p.wt,0)/result.rows.length,avgTAT=result.rows.reduce((a,p)=>a+p.tat,0)/result.rows.length,avgRT=result.rows.reduce((a,p)=>a+p.rt,0)/result.rows.length;
  const makespan=total, busy=result.segments.filter(s=>s.id!=="IDLE").reduce((a,s)=>a+s.end-s.start,0),util=busy/makespan*100;
  $("stats").innerHTML=[["Average waiting time",avgWT.toFixed(2),"time units"],["Average turnaround",avgTAT.toFixed(2),"time units"],["Average response time",avgRT.toFixed(2),"time units"],["CPU utilization",util.toFixed(1)+"%","busy time / total time"]].map(x=>`<div class="stat"><span>${x[0]}</span><b>${x[1]}</b><small>${x[2]}</small></div>`).join("");
  $("resultRows").innerHTML=result.rows.slice().sort((a,b)=>a.order-b.order).map(p=>`<tr><td><span class="pid-pill">${escapeHtml(p.id)}</span></td><td>${p.at}</td><td>${p.bt}</td><td>${p.priority}</td><td>${p.ct}</td><td>${p.tat}</td><td>${p.wt}</td><td>${p.rt}</td></tr>`).join("");
}
$("runBtn").addEventListener("click",()=>{try{$("error").textContent="";if(!processes.length)throw Error("Add at least one process before running the simulation.");renderResults(schedule());$("results").scrollIntoView({behavior:"smooth",block:"start"})}catch(e){$("error").textContent=e.message}});
$("exportBtn").addEventListener("click",()=>{
  if(!lastResults)return;
  const headers=["Process","Arrival Time","Burst Time","Priority / Queue","Completion Time","Turnaround Time","Waiting Time","Response Time"];
  const rows=lastResults.rows.slice().sort((a,b)=>a.order-b.order).map(p=>[p.id,p.at,p.bt,p.priority,p.ct,p.tat,p.wt,p.rt]);
  const csv=[headers,...rows].map(row=>row.map(v=>`"${String(v).replace(/"/g,'""')}"`).join(",")).join("\n");
  const a=document.createElement("a");a.href=URL.createObjectURL(new Blob([csv],{type:"text/csv;charset=utf-8;"}));a.download=`${selected}-scheduling-results.csv`;a.click();URL.revokeObjectURL(a.href);
});
setAlgorithm("fcfs");renderProcesses();
