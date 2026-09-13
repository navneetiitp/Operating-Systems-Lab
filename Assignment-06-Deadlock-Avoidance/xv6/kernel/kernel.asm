
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	4f813103          	ld	sp,1272(sp) # 8000b4f8 <_GLOBAL_OFFSET_TABLE_+0x8>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	042000ef          	jal	80000058 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000024:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | MENVCFG_STCE);
    80000028:	577d                	li	a4,-1
    8000002a:	177e                	slli	a4,a4,0x3f
    8000002c:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002e:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000032:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000036:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    8000003a:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003e:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000042:	000f4737          	lui	a4,0xf4
    80000046:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000004a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004c:	14d79073          	csrw	stimecmp,a5
}
    80000050:	60a2                	ld	ra,8(sp)
    80000052:	6402                	ld	s0,0(sp)
    80000054:	0141                	addi	sp,sp,16
    80000056:	8082                	ret

0000000080000058 <start>:
{
    80000058:	1141                	addi	sp,sp,-16
    8000005a:	e406                	sd	ra,8(sp)
    8000005c:	e022                	sd	s0,0(sp)
    8000005e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000060:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000064:	7779                	lui	a4,0xffffe
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9b6f>
    8000006a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000006c:	6705                	lui	a4,0x1
    8000006e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000078:	00001797          	auipc	a5,0x1
    8000007c:	de678793          	addi	a5,a5,-538 # 80000e5e <main>
    80000080:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000084:	4781                	li	a5,0
    80000086:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000008a:	67c1                	lui	a5,0x10
    8000008c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80000092:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000096:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000009a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000a2:	57fd                	li	a5,-1
    800000a4:	83a9                	srli	a5,a5,0xa
    800000a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000aa:	47bd                	li	a5,15
    800000ac:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    800000b0:	30a027f3          	csrr	a5,0x30a
  w_menvcfg(r_menvcfg() | MENVCFG_ADUE);
    800000b4:	4705                	li	a4,1
    800000b6:	1776                	slli	a4,a4,0x3d
    800000b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    800000ba:	30a79073          	csrw	0x30a,a5
  timerinit();
    800000be:	f5fff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000c2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c6:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000c8:	823e                	mv	tp,a5
  asm volatile("mret");
    800000ca:	30200073          	mret
}
    800000ce:	60a2                	ld	ra,8(sp)
    800000d0:	6402                	ld	s0,0(sp)
    800000d2:	0141                	addi	sp,sp,16
    800000d4:	8082                	ret

00000000800000d6 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d6:	7119                	addi	sp,sp,-128
    800000d8:	fc86                	sd	ra,120(sp)
    800000da:	f8a2                	sd	s0,112(sp)
    800000dc:	f4a6                	sd	s1,104(sp)
    800000de:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000e0:	06c05b63          	blez	a2,80000156 <consolewrite+0x80>
    800000e4:	f0ca                	sd	s2,96(sp)
    800000e6:	ecce                	sd	s3,88(sp)
    800000e8:	e8d2                	sd	s4,80(sp)
    800000ea:	e4d6                	sd	s5,72(sp)
    800000ec:	e0da                	sd	s6,64(sp)
    800000ee:	fc5e                	sd	s7,56(sp)
    800000f0:	f862                	sd	s8,48(sp)
    800000f2:	f466                	sd	s9,40(sp)
    800000f4:	f06a                	sd	s10,32(sp)
    800000f6:	8b2a                	mv	s6,a0
    800000f8:	8bae                	mv	s7,a1
    800000fa:	8a32                	mv	s4,a2
  int i = 0;
    800000fc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000fe:	02000c93          	li	s9,32
    80000102:	02000d13          	li	s10,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000106:	f8040a93          	addi	s5,s0,-128
    8000010a:	5c7d                	li	s8,-1
    8000010c:	a025                	j	80000134 <consolewrite+0x5e>
    if (nn > n - i)
    8000010e:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000112:	86ce                	mv	a3,s3
    80000114:	01748633          	add	a2,s1,s7
    80000118:	85da                	mv	a1,s6
    8000011a:	8556                	mv	a0,s5
    8000011c:	2ae020ef          	jal	800023ca <either_copyin>
    80000120:	03850d63          	beq	a0,s8,8000015a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000124:	85ce                	mv	a1,s3
    80000126:	8556                	mv	a0,s5
    80000128:	7c2000ef          	jal	800008ea <uartwrite>
    i += nn;
    8000012c:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    80000130:	0144d963          	bge	s1,s4,80000142 <consolewrite+0x6c>
    if (nn > n - i)
    80000134:	409a07bb          	subw	a5,s4,s1
    80000138:	893e                	mv	s2,a5
    8000013a:	fcfcdae3          	bge	s9,a5,8000010e <consolewrite+0x38>
    8000013e:	896a                	mv	s2,s10
    80000140:	b7f9                	j	8000010e <consolewrite+0x38>
    80000142:	7906                	ld	s2,96(sp)
    80000144:	69e6                	ld	s3,88(sp)
    80000146:	6a46                	ld	s4,80(sp)
    80000148:	6aa6                	ld	s5,72(sp)
    8000014a:	6b06                	ld	s6,64(sp)
    8000014c:	7be2                	ld	s7,56(sp)
    8000014e:	7c42                	ld	s8,48(sp)
    80000150:	7ca2                	ld	s9,40(sp)
    80000152:	7d02                	ld	s10,32(sp)
    80000154:	a821                	j	8000016c <consolewrite+0x96>
  int i = 0;
    80000156:	4481                	li	s1,0
    80000158:	a811                	j	8000016c <consolewrite+0x96>
    8000015a:	7906                	ld	s2,96(sp)
    8000015c:	69e6                	ld	s3,88(sp)
    8000015e:	6a46                	ld	s4,80(sp)
    80000160:	6aa6                	ld	s5,72(sp)
    80000162:	6b06                	ld	s6,64(sp)
    80000164:	7be2                	ld	s7,56(sp)
    80000166:	7c42                	ld	s8,48(sp)
    80000168:	7ca2                	ld	s9,40(sp)
    8000016a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016c:	8526                	mv	a0,s1
    8000016e:	70e6                	ld	ra,120(sp)
    80000170:	7446                	ld	s0,112(sp)
    80000172:	74a6                	ld	s1,104(sp)
    80000174:	6109                	addi	sp,sp,128
    80000176:	8082                	ret

0000000080000178 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000178:	711d                	addi	sp,sp,-96
    8000017a:	ec86                	sd	ra,88(sp)
    8000017c:	e8a2                	sd	s0,80(sp)
    8000017e:	e4a6                	sd	s1,72(sp)
    80000180:	e0ca                	sd	s2,64(sp)
    80000182:	fc4e                	sd	s3,56(sp)
    80000184:	f852                	sd	s4,48(sp)
    80000186:	f05a                	sd	s6,32(sp)
    80000188:	ec5e                	sd	s7,24(sp)
    8000018a:	1080                	addi	s0,sp,96
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000194:	00013517          	auipc	a0,0x13
    80000198:	3ac50513          	addi	a0,a0,940 # 80013540 <cons>
    8000019c:	24d000ef          	jal	80000be8 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800001a0:	00013497          	auipc	s1,0x13
    800001a4:	3a048493          	addi	s1,s1,928 # 80013540 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep_prepare(&cons.r);
    800001a8:	00013917          	auipc	s2,0x13
    800001ac:	43090913          	addi	s2,s2,1072 # 800135d8 <cons+0x98>
  while (n > 0) {
    800001b0:	0d305263          	blez	s3,80000274 <consoleread+0xfc>
    while (cons.r == cons.w) {
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	0af71763          	bne	a4,a5,8000026a <consoleread+0xf2>
      if (killed(myproc())) {
    800001c0:	768010ef          	jal	80001928 <myproc>
    800001c4:	086020ef          	jal	8000224a <killed>
    800001c8:	e925                	bnez	a0,80000238 <consoleread+0xc0>
      sleep_prepare(&cons.r);
    800001ca:	854a                	mv	a0,s2
    800001cc:	627010ef          	jal	80001ff2 <sleep_prepare>
      release(&cons.lock);
    800001d0:	8526                	mv	a0,s1
    800001d2:	29f000ef          	jal	80000c70 <release>
      sleep();
    800001d6:	659010ef          	jal	8000202e <sleep>
      acquire(&cons.lock);
    800001da:	8526                	mv	a0,s1
    800001dc:	20d000ef          	jal	80000be8 <acquire>
    while (cons.r == cons.w) {
    800001e0:	0984a783          	lw	a5,152(s1)
    800001e4:	09c4a703          	lw	a4,156(s1)
    800001e8:	fcf70ce3          	beq	a4,a5,800001c0 <consoleread+0x48>
    800001ec:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ee:	00013717          	auipc	a4,0x13
    800001f2:	35270713          	addi	a4,a4,850 # 80013540 <cons>
    800001f6:	0017869b          	addiw	a3,a5,1
    800001fa:	08d72c23          	sw	a3,152(a4)
    800001fe:	07f7f693          	andi	a3,a5,127
    80000202:	9736                	add	a4,a4,a3
    80000204:	01874703          	lbu	a4,24(a4)
    80000208:	00070a9b          	sext.w	s5,a4

    if (c == C('D')) { // end-of-file
    8000020c:	4691                	li	a3,4
    8000020e:	04da8663          	beq	s5,a3,8000025a <consoleread+0xe2>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000212:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000216:	4685                	li	a3,1
    80000218:	faf40613          	addi	a2,s0,-81
    8000021c:	85d2                	mv	a1,s4
    8000021e:	855a                	mv	a0,s6
    80000220:	15e020ef          	jal	8000237e <either_copyout>
    80000224:	57fd                	li	a5,-1
    80000226:	04f50663          	beq	a0,a5,80000272 <consoleread+0xfa>
      break;

    dst++;
    8000022a:	0a05                	addi	s4,s4,1
    --n;
    8000022c:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    8000022e:	47a9                	li	a5,10
    80000230:	04fa8b63          	beq	s5,a5,80000286 <consoleread+0x10e>
    80000234:	7aa2                	ld	s5,40(sp)
    80000236:	bfad                	j	800001b0 <consoleread+0x38>
        release(&cons.lock);
    80000238:	00013517          	auipc	a0,0x13
    8000023c:	30850513          	addi	a0,a0,776 # 80013540 <cons>
    80000240:	231000ef          	jal	80000c70 <release>
        return -1;
    80000244:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000246:	60e6                	ld	ra,88(sp)
    80000248:	6446                	ld	s0,80(sp)
    8000024a:	64a6                	ld	s1,72(sp)
    8000024c:	6906                	ld	s2,64(sp)
    8000024e:	79e2                	ld	s3,56(sp)
    80000250:	7a42                	ld	s4,48(sp)
    80000252:	7b02                	ld	s6,32(sp)
    80000254:	6be2                	ld	s7,24(sp)
    80000256:	6125                	addi	sp,sp,96
    80000258:	8082                	ret
      if (n < target) {
    8000025a:	0179fa63          	bgeu	s3,s7,8000026e <consoleread+0xf6>
        cons.r--;
    8000025e:	00013717          	auipc	a4,0x13
    80000262:	36f72d23          	sw	a5,890(a4) # 800135d8 <cons+0x98>
    80000266:	7aa2                	ld	s5,40(sp)
    80000268:	a031                	j	80000274 <consoleread+0xfc>
    8000026a:	f456                	sd	s5,40(sp)
    8000026c:	b749                	j	800001ee <consoleread+0x76>
    8000026e:	7aa2                	ld	s5,40(sp)
    80000270:	a011                	j	80000274 <consoleread+0xfc>
    80000272:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000274:	00013517          	auipc	a0,0x13
    80000278:	2cc50513          	addi	a0,a0,716 # 80013540 <cons>
    8000027c:	1f5000ef          	jal	80000c70 <release>
  return target - n;
    80000280:	413b853b          	subw	a0,s7,s3
    80000284:	b7c9                	j	80000246 <consoleread+0xce>
    80000286:	7aa2                	ld	s5,40(sp)
    80000288:	b7f5                	j	80000274 <consoleread+0xfc>

000000008000028a <consputc>:
{
    8000028a:	1141                	addi	sp,sp,-16
    8000028c:	e406                	sd	ra,8(sp)
    8000028e:	e022                	sd	s0,0(sp)
    80000290:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000292:	10000793          	li	a5,256
    80000296:	00f50863          	beq	a0,a5,800002a6 <consputc+0x1c>
    uartputc_sync(c);
    8000029a:	6d6000ef          	jal	80000970 <uartputc_sync>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	6c8000ef          	jal	80000970 <uartputc_sync>
    uartputc_sync(' ');
    800002ac:	02000513          	li	a0,32
    800002b0:	6c0000ef          	jal	80000970 <uartputc_sync>
    uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	6ba000ef          	jal	80000970 <uartputc_sync>
    800002ba:	b7d5                	j	8000029e <consputc+0x14>

00000000800002bc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002bc:	1101                	addi	sp,sp,-32
    800002be:	ec06                	sd	ra,24(sp)
    800002c0:	e822                	sd	s0,16(sp)
    800002c2:	e426                	sd	s1,8(sp)
    800002c4:	1000                	addi	s0,sp,32
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	00013517          	auipc	a0,0x13
    800002cc:	27850513          	addi	a0,a0,632 # 80013540 <cons>
    800002d0:	119000ef          	jal	80000be8 <acquire>

  switch (c) {
    800002d4:	47d5                	li	a5,21
    800002d6:	08f48d63          	beq	s1,a5,80000370 <consoleintr+0xb4>
    800002da:	0297c563          	blt	a5,s1,80000304 <consoleintr+0x48>
    800002de:	47a1                	li	a5,8
    800002e0:	0ef48263          	beq	s1,a5,800003c4 <consoleintr+0x108>
    800002e4:	47c1                	li	a5,16
    800002e6:	10f49363          	bne	s1,a5,800003ec <consoleintr+0x130>
  case C('P'): // Print process list.
    procdump();
    800002ea:	12c020ef          	jal	80002416 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002ee:	00013517          	auipc	a0,0x13
    800002f2:	25250513          	addi	a0,a0,594 # 80013540 <cons>
    800002f6:	17b000ef          	jal	80000c70 <release>
}
    800002fa:	60e2                	ld	ra,24(sp)
    800002fc:	6442                	ld	s0,16(sp)
    800002fe:	64a2                	ld	s1,8(sp)
    80000300:	6105                	addi	sp,sp,32
    80000302:	8082                	ret
  switch (c) {
    80000304:	07f00793          	li	a5,127
    80000308:	0af48e63          	beq	s1,a5,800003c4 <consoleintr+0x108>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    8000030c:	00013717          	auipc	a4,0x13
    80000310:	23470713          	addi	a4,a4,564 # 80013540 <cons>
    80000314:	0a072783          	lw	a5,160(a4)
    80000318:	09872703          	lw	a4,152(a4)
    8000031c:	9f99                	subw	a5,a5,a4
    8000031e:	07f00713          	li	a4,127
    80000322:	fcf766e3          	bltu	a4,a5,800002ee <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000326:	47b5                	li	a5,13
    80000328:	0cf48563          	beq	s1,a5,800003f2 <consoleintr+0x136>
      consputc(c);
    8000032c:	8526                	mv	a0,s1
    8000032e:	f5dff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000332:	00013717          	auipc	a4,0x13
    80000336:	20e70713          	addi	a4,a4,526 # 80013540 <cons>
    8000033a:	0a072683          	lw	a3,160(a4)
    8000033e:	0016879b          	addiw	a5,a3,1
    80000342:	863e                	mv	a2,a5
    80000344:	0af72023          	sw	a5,160(a4)
    80000348:	07f6f693          	andi	a3,a3,127
    8000034c:	9736                	add	a4,a4,a3
    8000034e:	00970c23          	sb	s1,24(a4)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000352:	ff648713          	addi	a4,s1,-10
    80000356:	c371                	beqz	a4,8000041a <consoleintr+0x15e>
    80000358:	14f1                	addi	s1,s1,-4
    8000035a:	c0e1                	beqz	s1,8000041a <consoleintr+0x15e>
    8000035c:	00013717          	auipc	a4,0x13
    80000360:	27c72703          	lw	a4,636(a4) # 800135d8 <cons+0x98>
    80000364:	9f99                	subw	a5,a5,a4
    80000366:	08000713          	li	a4,128
    8000036a:	f8e792e3          	bne	a5,a4,800002ee <consoleintr+0x32>
    8000036e:	a075                	j	8000041a <consoleintr+0x15e>
    80000370:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    80000372:	00013717          	auipc	a4,0x13
    80000376:	1ce70713          	addi	a4,a4,462 # 80013540 <cons>
    8000037a:	0a072783          	lw	a5,160(a4)
    8000037e:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000382:	00013497          	auipc	s1,0x13
    80000386:	1be48493          	addi	s1,s1,446 # 80013540 <cons>
    while (cons.e != cons.w &&
    8000038a:	4929                	li	s2,10
    8000038c:	02f70863          	beq	a4,a5,800003bc <consoleintr+0x100>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000390:	37fd                	addiw	a5,a5,-1
    80000392:	07f7f713          	andi	a4,a5,127
    80000396:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    80000398:	01874703          	lbu	a4,24(a4)
    8000039c:	03270263          	beq	a4,s2,800003c0 <consoleintr+0x104>
      cons.e--;
    800003a0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003a4:	10000513          	li	a0,256
    800003a8:	ee3ff0ef          	jal	8000028a <consputc>
    while (cons.e != cons.w &&
    800003ac:	0a04a783          	lw	a5,160(s1)
    800003b0:	09c4a703          	lw	a4,156(s1)
    800003b4:	fcf71ee3          	bne	a4,a5,80000390 <consoleintr+0xd4>
    800003b8:	6902                	ld	s2,0(sp)
    800003ba:	bf15                	j	800002ee <consoleintr+0x32>
    800003bc:	6902                	ld	s2,0(sp)
    800003be:	bf05                	j	800002ee <consoleintr+0x32>
    800003c0:	6902                	ld	s2,0(sp)
    800003c2:	b735                	j	800002ee <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003c4:	00013717          	auipc	a4,0x13
    800003c8:	17c70713          	addi	a4,a4,380 # 80013540 <cons>
    800003cc:	0a072783          	lw	a5,160(a4)
    800003d0:	09c72703          	lw	a4,156(a4)
    800003d4:	f0f70de3          	beq	a4,a5,800002ee <consoleintr+0x32>
      cons.e--;
    800003d8:	37fd                	addiw	a5,a5,-1
    800003da:	00013717          	auipc	a4,0x13
    800003de:	20f72323          	sw	a5,518(a4) # 800135e0 <cons+0xa0>
      consputc(BACKSPACE);
    800003e2:	10000513          	li	a0,256
    800003e6:	ea5ff0ef          	jal	8000028a <consputc>
    800003ea:	b711                	j	800002ee <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003ec:	f00481e3          	beqz	s1,800002ee <consoleintr+0x32>
    800003f0:	bf31                	j	8000030c <consoleintr+0x50>
      consputc(c);
    800003f2:	4529                	li	a0,10
    800003f4:	e97ff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003f8:	00013797          	auipc	a5,0x13
    800003fc:	14878793          	addi	a5,a5,328 # 80013540 <cons>
    80000400:	0a07a703          	lw	a4,160(a5)
    80000404:	0017069b          	addiw	a3,a4,1
    80000408:	8636                	mv	a2,a3
    8000040a:	0ad7a023          	sw	a3,160(a5)
    8000040e:	07f77713          	andi	a4,a4,127
    80000412:	97ba                	add	a5,a5,a4
    80000414:	4729                	li	a4,10
    80000416:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000041a:	00013797          	auipc	a5,0x13
    8000041e:	1cc7a123          	sw	a2,450(a5) # 800135dc <cons+0x9c>
        wakeup(&cons.r);
    80000422:	00013517          	auipc	a0,0x13
    80000426:	1b650513          	addi	a0,a0,438 # 800135d8 <cons+0x98>
    8000042a:	435010ef          	jal	8000205e <wakeup>
    8000042e:	b5c1                	j	800002ee <consoleintr+0x32>

0000000080000430 <consoleinit>:

void
consoleinit(void)
{
    80000430:	1141                	addi	sp,sp,-16
    80000432:	e406                	sd	ra,8(sp)
    80000434:	e022                	sd	s0,0(sp)
    80000436:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000438:	00008597          	auipc	a1,0x8
    8000043c:	bc858593          	addi	a1,a1,-1080 # 80008000 <etext>
    80000440:	00013517          	auipc	a0,0x13
    80000444:	10050513          	addi	a0,a0,256 # 80013540 <cons>
    80000448:	720000ef          	jal	80000b68 <initlock>

  uartinit();
    8000044c:	448000ef          	jal	80000894 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000450:	00023797          	auipc	a5,0x23
    80000454:	49078793          	addi	a5,a5,1168 # 800238e0 <devsw>
    80000458:	00000717          	auipc	a4,0x0
    8000045c:	d2070713          	addi	a4,a4,-736 # 80000178 <consoleread>
    80000460:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000462:	00000717          	auipc	a4,0x0
    80000466:	c7470713          	addi	a4,a4,-908 # 800000d6 <consolewrite>
    8000046a:	ef98                	sd	a4,24(a5)
}
    8000046c:	60a2                	ld	ra,8(sp)
    8000046e:	6402                	ld	s0,0(sp)
    80000470:	0141                	addi	sp,sp,16
    80000472:	8082                	ret

0000000080000474 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000474:	7139                	addi	sp,sp,-64
    80000476:	fc06                	sd	ra,56(sp)
    80000478:	f822                	sd	s0,48(sp)
    8000047a:	f04a                	sd	s2,32(sp)
    8000047c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    8000047e:	c219                	beqz	a2,80000484 <printint+0x10>
    80000480:	08054163          	bltz	a0,80000502 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80000484:	4301                	li	t1,0

  i = 0;
    80000486:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000048a:	86ca                	mv	a3,s2
  i = 0;
    8000048c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000048e:	00008817          	auipc	a6,0x8
    80000492:	2d280813          	addi	a6,a6,722 # 80008760 <digits>
    80000496:	88ba                	mv	a7,a4
    80000498:	0017061b          	addiw	a2,a4,1
    8000049c:	8732                	mv	a4,a2
    8000049e:	02b577b3          	remu	a5,a0,a1
    800004a2:	97c2                	add	a5,a5,a6
    800004a4:	0007c783          	lbu	a5,0(a5)
    800004a8:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004ac:	87aa                	mv	a5,a0
    800004ae:	02b55533          	divu	a0,a0,a1
    800004b2:	0685                	addi	a3,a3,1
    800004b4:	feb7f1e3          	bgeu	a5,a1,80000496 <printint+0x22>

  if (sign)
    800004b8:	00030c63          	beqz	t1,800004d0 <printint+0x5c>
    buf[i++] = '-';
    800004bc:	fe060793          	addi	a5,a2,-32
    800004c0:	00878633          	add	a2,a5,s0
    800004c4:	02d00793          	li	a5,45
    800004c8:	fef60423          	sb	a5,-24(a2)
    800004cc:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    800004d0:	02e05463          	blez	a4,800004f8 <printint+0x84>
    800004d4:	f426                	sd	s1,40(sp)
    800004d6:	377d                	addiw	a4,a4,-1
    800004d8:	00e904b3          	add	s1,s2,a4
    800004dc:	197d                	addi	s2,s2,-1
    800004de:	993a                	add	s2,s2,a4
    800004e0:	1702                	slli	a4,a4,0x20
    800004e2:	9301                	srli	a4,a4,0x20
    800004e4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004e8:	0004c503          	lbu	a0,0(s1)
    800004ec:	d9fff0ef          	jal	8000028a <consputc>
  while (--i >= 0)
    800004f0:	14fd                	addi	s1,s1,-1
    800004f2:	ff249be3          	bne	s1,s2,800004e8 <printint+0x74>
    800004f6:	74a2                	ld	s1,40(sp)
}
    800004f8:	70e2                	ld	ra,56(sp)
    800004fa:	7442                	ld	s0,48(sp)
    800004fc:	7902                	ld	s2,32(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
    x = -xx;
    80000502:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    80000506:	4305                	li	t1,1
    x = -xx;
    80000508:	bfbd                	j	80000486 <printint+0x12>

000000008000050a <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    8000050a:	7131                	addi	sp,sp,-192
    8000050c:	fc86                	sd	ra,120(sp)
    8000050e:	f8a2                	sd	s0,112(sp)
    80000510:	f0ca                	sd	s2,96(sp)
    80000512:	0100                	addi	s0,sp,128
    80000514:	892a                	mv	s2,a0
    80000516:	e40c                	sd	a1,8(s0)
    80000518:	e810                	sd	a2,16(s0)
    8000051a:	ec14                	sd	a3,24(s0)
    8000051c:	f018                	sd	a4,32(s0)
    8000051e:	f41c                	sd	a5,40(s0)
    80000520:	03043823          	sd	a6,48(s0)
    80000524:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    80000528:	0000b797          	auipc	a5,0xb
    8000052c:	fec7a783          	lw	a5,-20(a5) # 8000b514 <panicking>
    80000530:	cf9d                	beqz	a5,8000056e <printk+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000532:	00840793          	addi	a5,s0,8
    80000536:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    8000053a:	00094503          	lbu	a0,0(s2)
    8000053e:	22050663          	beqz	a0,8000076a <printk+0x260>
    80000542:	f4a6                	sd	s1,104(sp)
    80000544:	ecce                	sd	s3,88(sp)
    80000546:	e8d2                	sd	s4,80(sp)
    80000548:	e4d6                	sd	s5,72(sp)
    8000054a:	e0da                	sd	s6,64(sp)
    8000054c:	fc5e                	sd	s7,56(sp)
    8000054e:	f862                	sd	s8,48(sp)
    80000550:	f06a                	sd	s10,32(sp)
    80000552:	ec6e                	sd	s11,24(sp)
    80000554:	4a01                	li	s4,0
    if (cx != '%') {
    80000556:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    8000055a:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    8000055e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    80000562:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80000566:	4b29                	li	s6,10
    if (c0 == 'd') {
    80000568:	06400b93          	li	s7,100
    8000056c:	a015                	j	80000590 <printk+0x86>
    acquire(&pr.lock);
    8000056e:	00013517          	auipc	a0,0x13
    80000572:	07a50513          	addi	a0,a0,122 # 800135e8 <pr>
    80000576:	672000ef          	jal	80000be8 <acquire>
    8000057a:	bf65                	j	80000532 <printk+0x28>
      consputc(cx);
    8000057c:	d0fff0ef          	jal	8000028a <consputc>
      continue;
    80000580:	84d2                	mv	s1,s4
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000582:	2485                	addiw	s1,s1,1
    80000584:	8a26                	mv	s4,s1
    80000586:	94ca                	add	s1,s1,s2
    80000588:	0004c503          	lbu	a0,0(s1)
    8000058c:	1c050663          	beqz	a0,80000758 <printk+0x24e>
    if (cx != '%') {
    80000590:	ff3516e3          	bne	a0,s3,8000057c <printk+0x72>
    i++;
    80000594:	001a079b          	addiw	a5,s4,1
    80000598:	84be                	mv	s1,a5
    c0 = fmt[i + 0] & 0xff;
    8000059a:	00f90733          	add	a4,s2,a5
    8000059e:	00074a83          	lbu	s5,0(a4)
    if (c0)
    800005a2:	200a8963          	beqz	s5,800007b4 <printk+0x2aa>
      c1 = fmt[i + 1] & 0xff;
    800005a6:	00174683          	lbu	a3,1(a4)
    if (c1)
    800005aa:	1e068c63          	beqz	a3,800007a2 <printk+0x298>
    if (c0 == 'd') {
    800005ae:	037a8863          	beq	s5,s7,800005de <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800005b2:	f94a8713          	addi	a4,s5,-108
    800005b6:	00173713          	seqz	a4,a4
    800005ba:	f9c68613          	addi	a2,a3,-100
    800005be:	ee05                	bnez	a2,800005f6 <printk+0xec>
    800005c0:	cb1d                	beqz	a4,800005f6 <printk+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800005c2:	f8843783          	ld	a5,-120(s0)
    800005c6:	00878713          	addi	a4,a5,8
    800005ca:	f8e43423          	sd	a4,-120(s0)
    800005ce:	4605                	li	a2,1
    800005d0:	85da                	mv	a1,s6
    800005d2:	6388                	ld	a0,0(a5)
    800005d4:	ea1ff0ef          	jal	80000474 <printint>
      i += 1;
    800005d8:	002a049b          	addiw	s1,s4,2
    800005dc:	b75d                	j	80000582 <printk+0x78>
      printint(va_arg(ap, int), 10, 1);
    800005de:	f8843783          	ld	a5,-120(s0)
    800005e2:	00878713          	addi	a4,a5,8
    800005e6:	f8e43423          	sd	a4,-120(s0)
    800005ea:	4605                	li	a2,1
    800005ec:	85da                	mv	a1,s6
    800005ee:	4388                	lw	a0,0(a5)
    800005f0:	e85ff0ef          	jal	80000474 <printint>
    800005f4:	b779                	j	80000582 <printk+0x78>
      c2 = fmt[i + 2] & 0xff;
    800005f6:	97ca                	add	a5,a5,s2
    800005f8:	8636                	mv	a2,a3
    800005fa:	0027c683          	lbu	a3,2(a5)
    800005fe:	a2c9                	j	800007c0 <printk+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80000600:	f8843783          	ld	a5,-120(s0)
    80000604:	00878713          	addi	a4,a5,8
    80000608:	f8e43423          	sd	a4,-120(s0)
    8000060c:	4605                	li	a2,1
    8000060e:	45a9                	li	a1,10
    80000610:	6388                	ld	a0,0(a5)
    80000612:	e63ff0ef          	jal	80000474 <printint>
      i += 2;
    80000616:	003a049b          	addiw	s1,s4,3
    8000061a:	b7a5                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000061c:	f8843783          	ld	a5,-120(s0)
    80000620:	00878713          	addi	a4,a5,8
    80000624:	f8e43423          	sd	a4,-120(s0)
    80000628:	4601                	li	a2,0
    8000062a:	85da                	mv	a1,s6
    8000062c:	0007e503          	lwu	a0,0(a5)
    80000630:	e45ff0ef          	jal	80000474 <printint>
    80000634:	b7b9                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000636:	f8843783          	ld	a5,-120(s0)
    8000063a:	00878713          	addi	a4,a5,8
    8000063e:	f8e43423          	sd	a4,-120(s0)
    80000642:	4601                	li	a2,0
    80000644:	85da                	mv	a1,s6
    80000646:	6388                	ld	a0,0(a5)
    80000648:	e2dff0ef          	jal	80000474 <printint>
      i += 1;
    8000064c:	002a049b          	addiw	s1,s4,2
    80000650:	bf0d                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4601                	li	a2,0
    80000660:	45a9                	li	a1,10
    80000662:	6388                	ld	a0,0(a5)
    80000664:	e11ff0ef          	jal	80000474 <printint>
      i += 2;
    80000668:	003a049b          	addiw	s1,s4,3
    8000066c:	bf19                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4601                	li	a2,0
    8000067c:	45c1                	li	a1,16
    8000067e:	0007e503          	lwu	a0,0(a5)
    80000682:	df3ff0ef          	jal	80000474 <printint>
    80000686:	bdf5                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000688:	f8843783          	ld	a5,-120(s0)
    8000068c:	00878713          	addi	a4,a5,8
    80000690:	f8e43423          	sd	a4,-120(s0)
    80000694:	45c1                	li	a1,16
    80000696:	6388                	ld	a0,0(a5)
    80000698:	dddff0ef          	jal	80000474 <printint>
      i += 1;
    8000069c:	002a049b          	addiw	s1,s4,2
    800006a0:	b5cd                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4601                	li	a2,0
    800006b0:	45c1                	li	a1,16
    800006b2:	6388                	ld	a0,0(a5)
    800006b4:	dc1ff0ef          	jal	80000474 <printint>
      i += 2;
    800006b8:	003a049b          	addiw	s1,s4,3
    800006bc:	b5d9                	j	80000582 <printk+0x78>
    800006be:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006c0:	f8843783          	ld	a5,-120(s0)
    800006c4:	00878713          	addi	a4,a5,8
    800006c8:	f8e43423          	sd	a4,-120(s0)
    800006cc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006d0:	03000513          	li	a0,48
    800006d4:	bb7ff0ef          	jal	8000028a <consputc>
  consputc('x');
    800006d8:	07800513          	li	a0,120
    800006dc:	bafff0ef          	jal	8000028a <consputc>
    800006e0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006e2:	00008c97          	auipc	s9,0x8
    800006e6:	07ec8c93          	addi	s9,s9,126 # 80008760 <digits>
    800006ea:	03cad793          	srli	a5,s5,0x3c
    800006ee:	97e6                	add	a5,a5,s9
    800006f0:	0007c503          	lbu	a0,0(a5)
    800006f4:	b97ff0ef          	jal	8000028a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006f8:	0a92                	slli	s5,s5,0x4
    800006fa:	3a7d                	addiw	s4,s4,-1
    800006fc:	fe0a17e3          	bnez	s4,800006ea <printk+0x1e0>
    80000700:	7ca2                	ld	s9,40(sp)
    80000702:	b541                	j	80000582 <printk+0x78>
    } else if (c0 == 'c') {
      consputc(va_arg(ap, uint));
    80000704:	f8843783          	ld	a5,-120(s0)
    80000708:	00878713          	addi	a4,a5,8
    8000070c:	f8e43423          	sd	a4,-120(s0)
    80000710:	4388                	lw	a0,0(a5)
    80000712:	b79ff0ef          	jal	8000028a <consputc>
    80000716:	b5b5                	j	80000582 <printk+0x78>
    } else if (c0 == 's') {
      if ((s = va_arg(ap, char *)) == 0)
    80000718:	f8843783          	ld	a5,-120(s0)
    8000071c:	00878713          	addi	a4,a5,8
    80000720:	f8e43423          	sd	a4,-120(s0)
    80000724:	0007ba03          	ld	s4,0(a5)
    80000728:	000a0d63          	beqz	s4,80000742 <printk+0x238>
        s = "(null)";
      for (; *s; s++)
    8000072c:	000a4503          	lbu	a0,0(s4)
    80000730:	e40509e3          	beqz	a0,80000582 <printk+0x78>
        consputc(*s);
    80000734:	b57ff0ef          	jal	8000028a <consputc>
      for (; *s; s++)
    80000738:	0a05                	addi	s4,s4,1
    8000073a:	000a4503          	lbu	a0,0(s4)
    8000073e:	f97d                	bnez	a0,80000734 <printk+0x22a>
    80000740:	b589                	j	80000582 <printk+0x78>
        s = "(null)";
    80000742:	00008a17          	auipc	s4,0x8
    80000746:	8c6a0a13          	addi	s4,s4,-1850 # 80008008 <etext+0x8>
      for (; *s; s++)
    8000074a:	02800513          	li	a0,40
    8000074e:	b7dd                	j	80000734 <printk+0x22a>
    } else if (c0 == '%') {
      consputc('%');
    80000750:	8556                	mv	a0,s5
    80000752:	b39ff0ef          	jal	8000028a <consputc>
    80000756:	b535                	j	80000582 <printk+0x78>
    80000758:	74a6                	ld	s1,104(sp)
    8000075a:	69e6                	ld	s3,88(sp)
    8000075c:	6a46                	ld	s4,80(sp)
    8000075e:	6aa6                	ld	s5,72(sp)
    80000760:	6b06                	ld	s6,64(sp)
    80000762:	7be2                	ld	s7,56(sp)
    80000764:	7c42                	ld	s8,48(sp)
    80000766:	7d02                	ld	s10,32(sp)
    80000768:	6de2                	ld	s11,24(sp)
      consputc(c0);
    }
  }
  va_end(ap);

  if (panicking == 0)
    8000076a:	0000b797          	auipc	a5,0xb
    8000076e:	daa7a783          	lw	a5,-598(a5) # 8000b514 <panicking>
    80000772:	c38d                	beqz	a5,80000794 <printk+0x28a>
    release(&pr.lock);

  return 0;
}
    80000774:	4501                	li	a0,0
    80000776:	70e6                	ld	ra,120(sp)
    80000778:	7446                	ld	s0,112(sp)
    8000077a:	7906                	ld	s2,96(sp)
    8000077c:	6129                	addi	sp,sp,192
    8000077e:	8082                	ret
    80000780:	74a6                	ld	s1,104(sp)
    80000782:	69e6                	ld	s3,88(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	6aa6                	ld	s5,72(sp)
    80000788:	6b06                	ld	s6,64(sp)
    8000078a:	7be2                	ld	s7,56(sp)
    8000078c:	7c42                	ld	s8,48(sp)
    8000078e:	7d02                	ld	s10,32(sp)
    80000790:	6de2                	ld	s11,24(sp)
    80000792:	bfe1                	j	8000076a <printk+0x260>
    release(&pr.lock);
    80000794:	00013517          	auipc	a0,0x13
    80000798:	e5450513          	addi	a0,a0,-428 # 800135e8 <pr>
    8000079c:	4d4000ef          	jal	80000c70 <release>
  return 0;
    800007a0:	bfd1                	j	80000774 <printk+0x26a>
    if (c0 == 'd') {
    800007a2:	e37a8ee3          	beq	s5,s7,800005de <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800007a6:	f94a8713          	addi	a4,s5,-108
    800007aa:	00173713          	seqz	a4,a4
    800007ae:	8636                	mv	a2,a3
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007b0:	4781                	li	a5,0
    800007b2:	a00d                	j	800007d4 <printk+0x2ca>
    } else if (c0 == 'l' && c1 == 'd') {
    800007b4:	f94a8713          	addi	a4,s5,-108
    800007b8:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800007bc:	8656                	mv	a2,s5
    800007be:	86d6                	mv	a3,s5
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007c0:	f9460793          	addi	a5,a2,-108
    800007c4:	0017b793          	seqz	a5,a5
    800007c8:	8ff9                	and	a5,a5,a4
    800007ca:	f9c68593          	addi	a1,a3,-100
    800007ce:	e199                	bnez	a1,800007d4 <printk+0x2ca>
    800007d0:	e20798e3          	bnez	a5,80000600 <printk+0xf6>
    } else if (c0 == 'u') {
    800007d4:	e58a84e3          	beq	s5,s8,8000061c <printk+0x112>
    } else if (c0 == 'l' && c1 == 'u') {
    800007d8:	f8b60593          	addi	a1,a2,-117
    800007dc:	e199                	bnez	a1,800007e2 <printk+0x2d8>
    800007de:	e4071ce3          	bnez	a4,80000636 <printk+0x12c>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    800007e2:	f8b68593          	addi	a1,a3,-117
    800007e6:	e199                	bnez	a1,800007ec <printk+0x2e2>
    800007e8:	e60795e3          	bnez	a5,80000652 <printk+0x148>
    } else if (c0 == 'x') {
    800007ec:	e9aa81e3          	beq	s5,s10,8000066e <printk+0x164>
    } else if (c0 == 'l' && c1 == 'x') {
    800007f0:	f8860613          	addi	a2,a2,-120
    800007f4:	e219                	bnez	a2,800007fa <printk+0x2f0>
    800007f6:	e80719e3          	bnez	a4,80000688 <printk+0x17e>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    800007fa:	f8868693          	addi	a3,a3,-120
    800007fe:	e299                	bnez	a3,80000804 <printk+0x2fa>
    80000800:	ea0791e3          	bnez	a5,800006a2 <printk+0x198>
    } else if (c0 == 'p') {
    80000804:	ebba8de3          	beq	s5,s11,800006be <printk+0x1b4>
    } else if (c0 == 'c') {
    80000808:	06300793          	li	a5,99
    8000080c:	eefa8ce3          	beq	s5,a5,80000704 <printk+0x1fa>
    } else if (c0 == 's') {
    80000810:	07300793          	li	a5,115
    80000814:	f0fa82e3          	beq	s5,a5,80000718 <printk+0x20e>
    } else if (c0 == '%') {
    80000818:	02500793          	li	a5,37
    8000081c:	f2fa8ae3          	beq	s5,a5,80000750 <printk+0x246>
    } else if (c0 == 0) {
    80000820:	f60a80e3          	beqz	s5,80000780 <printk+0x276>
      consputc('%');
    80000824:	02500513          	li	a0,37
    80000828:	a63ff0ef          	jal	8000028a <consputc>
      consputc(c0);
    8000082c:	8556                	mv	a0,s5
    8000082e:	a5dff0ef          	jal	8000028a <consputc>
    80000832:	bb81                	j	80000582 <printk+0x78>

0000000080000834 <panic>:

void
panic(char *s)
{
    80000834:	1101                	addi	sp,sp,-32
    80000836:	ec06                	sd	ra,24(sp)
    80000838:	e822                	sd	s0,16(sp)
    8000083a:	e426                	sd	s1,8(sp)
    8000083c:	e04a                	sd	s2,0(sp)
    8000083e:	1000                	addi	s0,sp,32
    80000840:	892a                	mv	s2,a0
  panicking = 1;
    80000842:	4485                	li	s1,1
    80000844:	0000b797          	auipc	a5,0xb
    80000848:	cc97a823          	sw	s1,-816(a5) # 8000b514 <panicking>
  printk("panic: ");
    8000084c:	00007517          	auipc	a0,0x7
    80000850:	7cc50513          	addi	a0,a0,1996 # 80008018 <etext+0x18>
    80000854:	cb7ff0ef          	jal	8000050a <printk>
  printk("%s\n", s);
    80000858:	85ca                	mv	a1,s2
    8000085a:	00007517          	auipc	a0,0x7
    8000085e:	7c650513          	addi	a0,a0,1990 # 80008020 <etext+0x20>
    80000862:	ca9ff0ef          	jal	8000050a <printk>
  panicked = 1; // freeze uart output from other CPUs
    80000866:	0000b797          	auipc	a5,0xb
    8000086a:	ca97a523          	sw	s1,-854(a5) # 8000b510 <panicked>
  for (;;)
    8000086e:	a001                	j	8000086e <panic+0x3a>

0000000080000870 <printkinit>:
    ;
}

void
printkinit(void)
{
    80000870:	1141                	addi	sp,sp,-16
    80000872:	e406                	sd	ra,8(sp)
    80000874:	e022                	sd	s0,0(sp)
    80000876:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000878:	00007597          	auipc	a1,0x7
    8000087c:	7b058593          	addi	a1,a1,1968 # 80008028 <etext+0x28>
    80000880:	00013517          	auipc	a0,0x13
    80000884:	d6850513          	addi	a0,a0,-664 # 800135e8 <pr>
    80000888:	2e0000ef          	jal	80000b68 <initlock>
}
    8000088c:	60a2                	ld	ra,8(sp)
    8000088e:	6402                	ld	s0,0(sp)
    80000890:	0141                	addi	sp,sp,16
    80000892:	8082                	ret

0000000080000894 <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    80000894:	1141                	addi	sp,sp,-16
    80000896:	e406                	sd	ra,8(sp)
    80000898:	e022                	sd	s0,0(sp)
    8000089a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000089c:	100007b7          	lui	a5,0x10000
    800008a0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800008a4:	10000737          	lui	a4,0x10000
    800008a8:	f8000693          	li	a3,-128
    800008ac:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008b0:	468d                	li	a3,3
    800008b2:	10000637          	lui	a2,0x10000
    800008b6:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008ba:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008be:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008c2:	8732                	mv	a4,a2
    800008c4:	461d                	li	a2,7
    800008c6:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008ca:	00d780a3          	sb	a3,1(a5)

  initsleeplock(&tx_lock, "uart");
    800008ce:	00007597          	auipc	a1,0x7
    800008d2:	76258593          	addi	a1,a1,1890 # 80008030 <etext+0x30>
    800008d6:	00013517          	auipc	a0,0x13
    800008da:	d2a50513          	addi	a0,a0,-726 # 80013600 <tx_lock>
    800008de:	097030ef          	jal	80004174 <initsleeplock>
}
    800008e2:	60a2                	ld	ra,8(sp)
    800008e4:	6402                	ld	s0,0(sp)
    800008e6:	0141                	addi	sp,sp,16
    800008e8:	8082                	ret

00000000800008ea <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008ea:	7139                	addi	sp,sp,-64
    800008ec:	fc06                	sd	ra,56(sp)
    800008ee:	f822                	sd	s0,48(sp)
    800008f0:	f04a                	sd	s2,32(sp)
    800008f2:	e456                	sd	s5,8(sp)
    800008f4:	0080                	addi	s0,sp,64
    800008f6:	8aaa                	mv	s5,a0
    800008f8:	892e                	mv	s2,a1
  acquiresleep(&tx_lock);
    800008fa:	00013517          	auipc	a0,0x13
    800008fe:	d0650513          	addi	a0,a0,-762 # 80013600 <tx_lock>
    80000902:	0a9030ef          	jal	800041aa <acquiresleep>

  int i = 0;
  while (i < n) {
    80000906:	05205963          	blez	s2,80000958 <uartwrite+0x6e>
    8000090a:	f426                	sd	s1,40(sp)
    8000090c:	ec4e                	sd	s3,24(sp)
    8000090e:	e852                	sd	s4,16(sp)
    80000910:	e05a                	sd	s6,0(sp)
  int i = 0;
    80000912:	4481                	li	s1,0
    sleep_prepare(&tx_chan);
    80000914:	0000ba17          	auipc	s4,0xb
    80000918:	c04a0a13          	addi	s4,s4,-1020 # 8000b518 <tx_chan>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    8000091c:	100009b7          	lui	s3,0x10000
    80000920:	0995                	addi	s3,s3,5 # 10000005 <_entry-0x6ffffffb>
      WriteReg(THR, buf[i]);
    80000922:	10000b37          	lui	s6,0x10000
    80000926:	a029                	j	80000930 <uartwrite+0x46>
      i += 1;
    } else {
      sleep();
    80000928:	706010ef          	jal	8000202e <sleep>
  while (i < n) {
    8000092c:	0324d263          	bge	s1,s2,80000950 <uartwrite+0x66>
    sleep_prepare(&tx_chan);
    80000930:	8552                	mv	a0,s4
    80000932:	6c0010ef          	jal	80001ff2 <sleep_prepare>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    80000936:	0009c783          	lbu	a5,0(s3)
    8000093a:	0207f793          	andi	a5,a5,32
    8000093e:	d7ed                	beqz	a5,80000928 <uartwrite+0x3e>
      WriteReg(THR, buf[i]);
    80000940:	009a87b3          	add	a5,s5,s1
    80000944:	0007c783          	lbu	a5,0(a5)
    80000948:	00fb0023          	sb	a5,0(s6) # 10000000 <_entry-0x70000000>
      i += 1;
    8000094c:	2485                	addiw	s1,s1,1
    8000094e:	bff9                	j	8000092c <uartwrite+0x42>
    80000950:	74a2                	ld	s1,40(sp)
    80000952:	69e2                	ld	s3,24(sp)
    80000954:	6a42                	ld	s4,16(sp)
    80000956:	6b02                	ld	s6,0(sp)
    }
  }

  releasesleep(&tx_lock);
    80000958:	00013517          	auipc	a0,0x13
    8000095c:	ca850513          	addi	a0,a0,-856 # 80013600 <tx_lock>
    80000960:	09f030ef          	jal	800041fe <releasesleep>
}
    80000964:	70e2                	ld	ra,56(sp)
    80000966:	7442                	ld	s0,48(sp)
    80000968:	7902                	ld	s2,32(sp)
    8000096a:	6aa2                	ld	s5,8(sp)
    8000096c:	6121                	addi	sp,sp,64
    8000096e:	8082                	ret

0000000080000970 <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000970:	1101                	addi	sp,sp,-32
    80000972:	ec06                	sd	ra,24(sp)
    80000974:	e822                	sd	s0,16(sp)
    80000976:	e426                	sd	s1,8(sp)
    80000978:	1000                	addi	s0,sp,32
    8000097a:	84aa                	mv	s1,a0
  if (panicking == 0)
    8000097c:	0000b797          	auipc	a5,0xb
    80000980:	b987a783          	lw	a5,-1128(a5) # 8000b514 <panicking>
    80000984:	cf95                	beqz	a5,800009c0 <uartputc_sync+0x50>
    push_off();

  if (panicked) {
    80000986:	0000b797          	auipc	a5,0xb
    8000098a:	b8a7a783          	lw	a5,-1142(a5) # 8000b510 <panicked>
    8000098e:	ef85                	bnez	a5,800009c6 <uartputc_sync+0x56>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000990:	10000737          	lui	a4,0x10000
    80000994:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000996:	00074783          	lbu	a5,0(a4)
    8000099a:	0207f793          	andi	a5,a5,32
    8000099e:	dfe5                	beqz	a5,80000996 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    800009a0:	0ff4f513          	zext.b	a0,s1
    800009a4:	100007b7          	lui	a5,0x10000
    800009a8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    800009ac:	0000b797          	auipc	a5,0xb
    800009b0:	b687a783          	lw	a5,-1176(a5) # 8000b514 <panicking>
    800009b4:	cb91                	beqz	a5,800009c8 <uartputc_sync+0x58>
    pop_off();
}
    800009b6:	60e2                	ld	ra,24(sp)
    800009b8:	6442                	ld	s0,16(sp)
    800009ba:	64a2                	ld	s1,8(sp)
    800009bc:	6105                	addi	sp,sp,32
    800009be:	8082                	ret
    push_off();
    800009c0:	1ee000ef          	jal	80000bae <push_off>
    800009c4:	b7c9                	j	80000986 <uartputc_sync+0x16>
    for (;;)
    800009c6:	a001                	j	800009c6 <uartputc_sync+0x56>
    pop_off();
    800009c8:	260000ef          	jal	80000c28 <pop_off>
}
    800009cc:	b7ed                	j	800009b6 <uartputc_sync+0x46>

00000000800009ce <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	e04a                	sd	s2,0(sp)
    800009d8:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009da:	100007b7          	lui	a5,0x10000
    800009de:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  if (ReadReg(LSR) & LSR_TX_IDLE) {
    800009e2:	100007b7          	lui	a5,0x10000
    800009e6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009ea:	0207f793          	andi	a5,a5,32
    800009ee:	ef99                	bnez	a5,80000a0c <uartintr+0x3e>
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009f0:	100004b7          	lui	s1,0x10000
    800009f4:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    800009f6:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009fa:	0004c783          	lbu	a5,0(s1)
    800009fe:	8b85                	andi	a5,a5,1
    80000a00:	cf89                	beqz	a5,80000a1a <uartintr+0x4c>
    return ReadReg(RHR);
    80000a02:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    80000a06:	8b7ff0ef          	jal	800002bc <consoleintr>
  while (1) {
    80000a0a:	bfc5                	j	800009fa <uartintr+0x2c>
    wakeup(&tx_chan);
    80000a0c:	0000b517          	auipc	a0,0xb
    80000a10:	b0c50513          	addi	a0,a0,-1268 # 8000b518 <tx_chan>
    80000a14:	64a010ef          	jal	8000205e <wakeup>
    80000a18:	bfe1                	j	800009f0 <uartintr+0x22>
  }
}
    80000a1a:	60e2                	ld	ra,24(sp)
    80000a1c:	6442                	ld	s0,16(sp)
    80000a1e:	64a2                	ld	s1,8(sp)
    80000a20:	6902                	ld	s2,0(sp)
    80000a22:	6105                	addi	sp,sp,32
    80000a24:	8082                	ret

0000000080000a26 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a26:	1101                	addi	sp,sp,-32
    80000a28:	ec06                	sd	ra,24(sp)
    80000a2a:	e822                	sd	s0,16(sp)
    80000a2c:	e426                	sd	s1,8(sp)
    80000a2e:	e04a                	sd	s2,0(sp)
    80000a30:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a32:	00024797          	auipc	a5,0x24
    80000a36:	25e78793          	addi	a5,a5,606 # 80024c90 <end>
    80000a3a:	00f53733          	sltu	a4,a0,a5
    80000a3e:	47c5                	li	a5,17
    80000a40:	07ee                	slli	a5,a5,0x1b
    80000a42:	17fd                	addi	a5,a5,-1
    80000a44:	00a7b7b3          	sltu	a5,a5,a0
    80000a48:	8fd9                	or	a5,a5,a4
    80000a4a:	ef95                	bnez	a5,80000a86 <kfree+0x60>
    80000a4c:	84aa                	mv	s1,a0
    80000a4e:	03451793          	slli	a5,a0,0x34
    80000a52:	eb95                	bnez	a5,80000a86 <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	4585                	li	a1,1
    80000a58:	250000ef          	jal	80000ca8 <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000a5c:	00013917          	auipc	s2,0x13
    80000a60:	bd490913          	addi	s2,s2,-1068 # 80013630 <kmem>
    80000a64:	854a                	mv	a0,s2
    80000a66:	182000ef          	jal	80000be8 <acquire>
  r->next = kmem.freelist;
    80000a6a:	01893783          	ld	a5,24(s2)
    80000a6e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a70:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a74:	854a                	mv	a0,s2
    80000a76:	1fa000ef          	jal	80000c70 <release>
}
    80000a7a:	60e2                	ld	ra,24(sp)
    80000a7c:	6442                	ld	s0,16(sp)
    80000a7e:	64a2                	ld	s1,8(sp)
    80000a80:	6902                	ld	s2,0(sp)
    80000a82:	6105                	addi	sp,sp,32
    80000a84:	8082                	ret
    panic("kfree");
    80000a86:	00007517          	auipc	a0,0x7
    80000a8a:	5b250513          	addi	a0,a0,1458 # 80008038 <etext+0x38>
    80000a8e:	da7ff0ef          	jal	80000834 <panic>

0000000080000a92 <freerange>:
{
    80000a92:	7179                	addi	sp,sp,-48
    80000a94:	f406                	sd	ra,40(sp)
    80000a96:	f022                	sd	s0,32(sp)
    80000a98:	ec26                	sd	s1,24(sp)
    80000a9a:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000a9c:	6785                	lui	a5,0x1
    80000a9e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000aa2:	00e504b3          	add	s1,a0,a4
    80000aa6:	777d                	lui	a4,0xfffff
    80000aa8:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aaa:	94be                	add	s1,s1,a5
    80000aac:	0295e263          	bltu	a1,s1,80000ad0 <freerange+0x3e>
    80000ab0:	e84a                	sd	s2,16(sp)
    80000ab2:	e44e                	sd	s3,8(sp)
    80000ab4:	e052                	sd	s4,0(sp)
    80000ab6:	892e                	mv	s2,a1
    kfree(p);
    80000ab8:	8a3a                	mv	s4,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aba:	89be                	mv	s3,a5
    kfree(p);
    80000abc:	01448533          	add	a0,s1,s4
    80000ac0:	f67ff0ef          	jal	80000a26 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ac4:	94ce                	add	s1,s1,s3
    80000ac6:	fe997be3          	bgeu	s2,s1,80000abc <freerange+0x2a>
    80000aca:	6942                	ld	s2,16(sp)
    80000acc:	69a2                	ld	s3,8(sp)
    80000ace:	6a02                	ld	s4,0(sp)
}
    80000ad0:	70a2                	ld	ra,40(sp)
    80000ad2:	7402                	ld	s0,32(sp)
    80000ad4:	64e2                	ld	s1,24(sp)
    80000ad6:	6145                	addi	sp,sp,48
    80000ad8:	8082                	ret

0000000080000ada <kinit>:
{
    80000ada:	1141                	addi	sp,sp,-16
    80000adc:	e406                	sd	ra,8(sp)
    80000ade:	e022                	sd	s0,0(sp)
    80000ae0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ae2:	00007597          	auipc	a1,0x7
    80000ae6:	55e58593          	addi	a1,a1,1374 # 80008040 <etext+0x40>
    80000aea:	00013517          	auipc	a0,0x13
    80000aee:	b4650513          	addi	a0,a0,-1210 # 80013630 <kmem>
    80000af2:	076000ef          	jal	80000b68 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000af6:	45c5                	li	a1,17
    80000af8:	05ee                	slli	a1,a1,0x1b
    80000afa:	00024517          	auipc	a0,0x24
    80000afe:	19650513          	addi	a0,a0,406 # 80024c90 <end>
    80000b02:	f91ff0ef          	jal	80000a92 <freerange>
}
    80000b06:	60a2                	ld	ra,8(sp)
    80000b08:	6402                	ld	s0,0(sp)
    80000b0a:	0141                	addi	sp,sp,16
    80000b0c:	8082                	ret

0000000080000b0e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b0e:	1101                	addi	sp,sp,-32
    80000b10:	ec06                	sd	ra,24(sp)
    80000b12:	e822                	sd	s0,16(sp)
    80000b14:	e426                	sd	s1,8(sp)
    80000b16:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b18:	00013517          	auipc	a0,0x13
    80000b1c:	b1850513          	addi	a0,a0,-1256 # 80013630 <kmem>
    80000b20:	0c8000ef          	jal	80000be8 <acquire>
  r = kmem.freelist;
    80000b24:	00013497          	auipc	s1,0x13
    80000b28:	b244b483          	ld	s1,-1244(s1) # 80013648 <kmem+0x18>
  if (r)
    80000b2c:	c49d                	beqz	s1,80000b5a <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b2e:	609c                	ld	a5,0(s1)
    80000b30:	00013717          	auipc	a4,0x13
    80000b34:	b0f73c23          	sd	a5,-1256(a4) # 80013648 <kmem+0x18>
  release(&kmem.lock);
    80000b38:	00013517          	auipc	a0,0x13
    80000b3c:	af850513          	addi	a0,a0,-1288 # 80013630 <kmem>
    80000b40:	130000ef          	jal	80000c70 <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000b44:	6605                	lui	a2,0x1
    80000b46:	4595                	li	a1,5
    80000b48:	8526                	mv	a0,s1
    80000b4a:	15e000ef          	jal	80000ca8 <memset>
  return (void *)r;
}
    80000b4e:	8526                	mv	a0,s1
    80000b50:	60e2                	ld	ra,24(sp)
    80000b52:	6442                	ld	s0,16(sp)
    80000b54:	64a2                	ld	s1,8(sp)
    80000b56:	6105                	addi	sp,sp,32
    80000b58:	8082                	ret
  release(&kmem.lock);
    80000b5a:	00013517          	auipc	a0,0x13
    80000b5e:	ad650513          	addi	a0,a0,-1322 # 80013630 <kmem>
    80000b62:	10e000ef          	jal	80000c70 <release>
  if (r)
    80000b66:	b7e5                	j	80000b4e <kalloc+0x40>

0000000080000b68 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b68:	1141                	addi	sp,sp,-16
    80000b6a:	e406                	sd	ra,8(sp)
    80000b6c:	e022                	sd	s0,0(sp)
    80000b6e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b70:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b72:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b76:	00053823          	sd	zero,16(a0)
}
    80000b7a:	60a2                	ld	ra,8(sp)
    80000b7c:	6402                	ld	s0,0(sp)
    80000b7e:	0141                	addi	sp,sp,16
    80000b80:	8082                	ret

0000000080000b82 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b82:	411c                	lw	a5,0(a0)
    80000b84:	e399                	bnez	a5,80000b8a <holding+0x8>
    80000b86:	4501                	li	a0,0
  return r;
}
    80000b88:	8082                	ret
{
    80000b8a:	1101                	addi	sp,sp,-32
    80000b8c:	ec06                	sd	ra,24(sp)
    80000b8e:	e822                	sd	s0,16(sp)
    80000b90:	e426                	sd	s1,8(sp)
    80000b92:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b94:	691c                	ld	a5,16(a0)
    80000b96:	84be                	mv	s1,a5
    80000b98:	571000ef          	jal	80001908 <mycpu>
    80000b9c:	40a48533          	sub	a0,s1,a0
    80000ba0:	00153513          	seqz	a0,a0
}
    80000ba4:	60e2                	ld	ra,24(sp)
    80000ba6:	6442                	ld	s0,16(sp)
    80000ba8:	64a2                	ld	s1,8(sp)
    80000baa:	6105                	addi	sp,sp,32
    80000bac:	8082                	ret

0000000080000bae <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bae:	1101                	addi	sp,sp,-32
    80000bb0:	ec06                	sd	ra,24(sp)
    80000bb2:	e822                	sd	s0,16(sp)
    80000bb4:	e426                	sd	s1,8(sp)
    80000bb6:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80000bb8:	100177f3          	csrrci	a5,sstatus,2
    80000bbc:	84be                	mv	s1,a5
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000bbe:	54b000ef          	jal	80001908 <mycpu>
    80000bc2:	5d3c                	lw	a5,120(a0)
    80000bc4:	cb99                	beqz	a5,80000bda <push_off+0x2c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bc6:	543000ef          	jal	80001908 <mycpu>
    80000bca:	5d3c                	lw	a5,120(a0)
    80000bcc:	2785                	addiw	a5,a5,1
    80000bce:	dd3c                	sw	a5,120(a0)
}
    80000bd0:	60e2                	ld	ra,24(sp)
    80000bd2:	6442                	ld	s0,16(sp)
    80000bd4:	64a2                	ld	s1,8(sp)
    80000bd6:	6105                	addi	sp,sp,32
    80000bd8:	8082                	ret
    mycpu()->intena = old;
    80000bda:	52f000ef          	jal	80001908 <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000bde:	0014d793          	srli	a5,s1,0x1
    80000be2:	8b85                	andi	a5,a5,1
    mycpu()->intena = old;
    80000be4:	dd7c                	sw	a5,124(a0)
    80000be6:	b7c5                	j	80000bc6 <push_off+0x18>

0000000080000be8 <acquire>:
{
    80000be8:	1101                	addi	sp,sp,-32
    80000bea:	ec06                	sd	ra,24(sp)
    80000bec:	e822                	sd	s0,16(sp)
    80000bee:	e426                	sd	s1,8(sp)
    80000bf0:	1000                	addi	s0,sp,32
    80000bf2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bf4:	fbbff0ef          	jal	80000bae <push_off>
  if (holding(lk))
    80000bf8:	8526                	mv	a0,s1
    80000bfa:	f89ff0ef          	jal	80000b82 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000bfe:	4705                	li	a4,1
  if (holding(lk))
    80000c00:	ed11                	bnez	a0,80000c1c <acquire+0x34>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c02:	87ba                	mv	a5,a4
    80000c04:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c08:	2781                	sext.w	a5,a5
    80000c0a:	ffe5                	bnez	a5,80000c02 <acquire+0x1a>
  lk->cpu = mycpu();
    80000c0c:	4fd000ef          	jal	80001908 <mycpu>
    80000c10:	e888                	sd	a0,16(s1)
}
    80000c12:	60e2                	ld	ra,24(sp)
    80000c14:	6442                	ld	s0,16(sp)
    80000c16:	64a2                	ld	s1,8(sp)
    80000c18:	6105                	addi	sp,sp,32
    80000c1a:	8082                	ret
    panic("acquire");
    80000c1c:	00007517          	auipc	a0,0x7
    80000c20:	42c50513          	addi	a0,a0,1068 # 80008048 <etext+0x48>
    80000c24:	c11ff0ef          	jal	80000834 <panic>

0000000080000c28 <pop_off>:

void
pop_off(void)
{
    80000c28:	1141                	addi	sp,sp,-16
    80000c2a:	e406                	sd	ra,8(sp)
    80000c2c:	e022                	sd	s0,0(sp)
    80000c2e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c30:	4d9000ef          	jal	80001908 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c34:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c38:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000c3a:	ef99                	bnez	a5,80000c58 <pop_off+0x30>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000c3c:	5d3c                	lw	a5,120(a0)
    80000c3e:	02f05363          	blez	a5,80000c64 <pop_off+0x3c>
    panic("pop_off");
  c->noff -= 1;
    80000c42:	37fd                	addiw	a5,a5,-1
    80000c44:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000c46:	e789                	bnez	a5,80000c50 <pop_off+0x28>
    80000c48:	5d7c                	lw	a5,124(a0)
    80000c4a:	c399                	beqz	a5,80000c50 <pop_off+0x28>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80000c4c:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000c50:	60a2                	ld	ra,8(sp)
    80000c52:	6402                	ld	s0,0(sp)
    80000c54:	0141                	addi	sp,sp,16
    80000c56:	8082                	ret
    panic("pop_off - interruptible");
    80000c58:	00007517          	auipc	a0,0x7
    80000c5c:	3f850513          	addi	a0,a0,1016 # 80008050 <etext+0x50>
    80000c60:	bd5ff0ef          	jal	80000834 <panic>
    panic("pop_off");
    80000c64:	00007517          	auipc	a0,0x7
    80000c68:	40450513          	addi	a0,a0,1028 # 80008068 <etext+0x68>
    80000c6c:	bc9ff0ef          	jal	80000834 <panic>

0000000080000c70 <release>:
{
    80000c70:	1101                	addi	sp,sp,-32
    80000c72:	ec06                	sd	ra,24(sp)
    80000c74:	e822                	sd	s0,16(sp)
    80000c76:	e426                	sd	s1,8(sp)
    80000c78:	1000                	addi	s0,sp,32
    80000c7a:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000c7c:	f07ff0ef          	jal	80000b82 <holding>
    80000c80:	cd11                	beqz	a0,80000c9c <release+0x2c>
  lk->cpu = 0;
    80000c82:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000c86:	0310000f          	fence	rw,w
    80000c8a:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000c8e:	f9bff0ef          	jal	80000c28 <pop_off>
}
    80000c92:	60e2                	ld	ra,24(sp)
    80000c94:	6442                	ld	s0,16(sp)
    80000c96:	64a2                	ld	s1,8(sp)
    80000c98:	6105                	addi	sp,sp,32
    80000c9a:	8082                	ret
    panic("release");
    80000c9c:	00007517          	auipc	a0,0x7
    80000ca0:	3d450513          	addi	a0,a0,980 # 80008070 <etext+0x70>
    80000ca4:	b91ff0ef          	jal	80000834 <panic>

0000000080000ca8 <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000ca8:	1141                	addi	sp,sp,-16
    80000caa:	e406                	sd	ra,8(sp)
    80000cac:	e022                	sd	s0,0(sp)
    80000cae:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000cb0:	ca19                	beqz	a2,80000cc6 <memset+0x1e>
    80000cb2:	87aa                	mv	a5,a0
    80000cb4:	1602                	slli	a2,a2,0x20
    80000cb6:	9201                	srli	a2,a2,0x20
    80000cb8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cbc:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000cc0:	0785                	addi	a5,a5,1
    80000cc2:	fee79de3          	bne	a5,a4,80000cbc <memset+0x14>
  }
  return dst;
}
    80000cc6:	60a2                	ld	ra,8(sp)
    80000cc8:	6402                	ld	s0,0(sp)
    80000cca:	0141                	addi	sp,sp,16
    80000ccc:	8082                	ret

0000000080000cce <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cce:	1141                	addi	sp,sp,-16
    80000cd0:	e406                	sd	ra,8(sp)
    80000cd2:	e022                	sd	s0,0(sp)
    80000cd4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000cd6:	c61d                	beqz	a2,80000d04 <memcmp+0x36>
    80000cd8:	1602                	slli	a2,a2,0x20
    80000cda:	9201                	srli	a2,a2,0x20
    80000cdc:	00c506b3          	add	a3,a0,a2
    if (*s1 != *s2)
    80000ce0:	00054783          	lbu	a5,0(a0)
    80000ce4:	0005c703          	lbu	a4,0(a1)
    80000ce8:	00e79863          	bne	a5,a4,80000cf8 <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000cec:	0505                	addi	a0,a0,1
    80000cee:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000cf0:	fed518e3          	bne	a0,a3,80000ce0 <memcmp+0x12>
  }

  return 0;
    80000cf4:	4501                	li	a0,0
    80000cf6:	a019                	j	80000cfc <memcmp+0x2e>
      return *s1 - *s2;
    80000cf8:	40e7853b          	subw	a0,a5,a4
}
    80000cfc:	60a2                	ld	ra,8(sp)
    80000cfe:	6402                	ld	s0,0(sp)
    80000d00:	0141                	addi	sp,sp,16
    80000d02:	8082                	ret
  return 0;
    80000d04:	4501                	li	a0,0
    80000d06:	bfdd                	j	80000cfc <memcmp+0x2e>

0000000080000d08 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000d08:	1141                	addi	sp,sp,-16
    80000d0a:	e406                	sd	ra,8(sp)
    80000d0c:	e022                	sd	s0,0(sp)
    80000d0e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000d10:	c205                	beqz	a2,80000d30 <memmove+0x28>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000d12:	02a5e363          	bltu	a1,a0,80000d38 <memmove+0x30>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000d16:	1602                	slli	a2,a2,0x20
    80000d18:	9201                	srli	a2,a2,0x20
    80000d1a:	00c587b3          	add	a5,a1,a2
{
    80000d1e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d20:	0585                	addi	a1,a1,1
    80000d22:	0705                	addi	a4,a4,1
    80000d24:	fff5c683          	lbu	a3,-1(a1)
    80000d28:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000d2c:	feb79ae3          	bne	a5,a1,80000d20 <memmove+0x18>

  return dst;
}
    80000d30:	60a2                	ld	ra,8(sp)
    80000d32:	6402                	ld	s0,0(sp)
    80000d34:	0141                	addi	sp,sp,16
    80000d36:	8082                	ret
  if (s < d && s + n > d) {
    80000d38:	02061693          	slli	a3,a2,0x20
    80000d3c:	9281                	srli	a3,a3,0x20
    80000d3e:	00d58733          	add	a4,a1,a3
    80000d42:	fce57ae3          	bgeu	a0,a4,80000d16 <memmove+0xe>
    d += n;
    80000d46:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000d48:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d4c:	1782                	slli	a5,a5,0x20
    80000d4e:	9381                	srli	a5,a5,0x20
    80000d50:	fff7c793          	not	a5,a5
    80000d54:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d56:	177d                	addi	a4,a4,-1
    80000d58:	16fd                	addi	a3,a3,-1
    80000d5a:	00074603          	lbu	a2,0(a4)
    80000d5e:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000d62:	fee79ae3          	bne	a5,a4,80000d56 <memmove+0x4e>
    80000d66:	b7e9                	j	80000d30 <memmove+0x28>

0000000080000d68 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000d68:	1141                	addi	sp,sp,-16
    80000d6a:	e406                	sd	ra,8(sp)
    80000d6c:	e022                	sd	s0,0(sp)
    80000d6e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d70:	f99ff0ef          	jal	80000d08 <memmove>
}
    80000d74:	60a2                	ld	ra,8(sp)
    80000d76:	6402                	ld	s0,0(sp)
    80000d78:	0141                	addi	sp,sp,16
    80000d7a:	8082                	ret

0000000080000d7c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d7c:	1141                	addi	sp,sp,-16
    80000d7e:	e406                	sd	ra,8(sp)
    80000d80:	e022                	sd	s0,0(sp)
    80000d82:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000d84:	ce11                	beqz	a2,80000da0 <strncmp+0x24>
    80000d86:	00054783          	lbu	a5,0(a0)
    80000d8a:	cf89                	beqz	a5,80000da4 <strncmp+0x28>
    80000d8c:	0005c703          	lbu	a4,0(a1)
    80000d90:	00f71a63          	bne	a4,a5,80000da4 <strncmp+0x28>
    n--, p++, q++;
    80000d94:	367d                	addiw	a2,a2,-1
    80000d96:	0505                	addi	a0,a0,1
    80000d98:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000d9a:	f675                	bnez	a2,80000d86 <strncmp+0xa>
  if (n == 0)
    return 0;
    80000d9c:	4501                	li	a0,0
    80000d9e:	a801                	j	80000dae <strncmp+0x32>
    80000da0:	4501                	li	a0,0
    80000da2:	a031                	j	80000dae <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000da4:	00054503          	lbu	a0,0(a0)
    80000da8:	0005c783          	lbu	a5,0(a1)
    80000dac:	9d1d                	subw	a0,a0,a5
}
    80000dae:	60a2                	ld	ra,8(sp)
    80000db0:	6402                	ld	s0,0(sp)
    80000db2:	0141                	addi	sp,sp,16
    80000db4:	8082                	ret

0000000080000db6 <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000db6:	1141                	addi	sp,sp,-16
    80000db8:	e406                	sd	ra,8(sp)
    80000dba:	e022                	sd	s0,0(sp)
    80000dbc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000dbe:	87aa                	mv	a5,a0
    80000dc0:	a011                	j	80000dc4 <strncpy+0xe>
    80000dc2:	8636                	mv	a2,a3
    80000dc4:	02c05863          	blez	a2,80000df4 <strncpy+0x3e>
    80000dc8:	fff6069b          	addiw	a3,a2,-1
    80000dcc:	8836                	mv	a6,a3
    80000dce:	0785                	addi	a5,a5,1
    80000dd0:	0005c703          	lbu	a4,0(a1)
    80000dd4:	fee78fa3          	sb	a4,-1(a5)
    80000dd8:	0585                	addi	a1,a1,1
    80000dda:	f765                	bnez	a4,80000dc2 <strncpy+0xc>
    ;
  while (n-- > 0)
    80000ddc:	873e                	mv	a4,a5
    80000dde:	01005b63          	blez	a6,80000df4 <strncpy+0x3e>
    80000de2:	9fb1                	addw	a5,a5,a2
    80000de4:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000de6:	0705                	addi	a4,a4,1
    80000de8:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000dec:	40e786bb          	subw	a3,a5,a4
    80000df0:	fed04be3          	bgtz	a3,80000de6 <strncpy+0x30>
  return os;
}
    80000df4:	60a2                	ld	ra,8(sp)
    80000df6:	6402                	ld	s0,0(sp)
    80000df8:	0141                	addi	sp,sp,16
    80000dfa:	8082                	ret

0000000080000dfc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000dfc:	1141                	addi	sp,sp,-16
    80000dfe:	e406                	sd	ra,8(sp)
    80000e00:	e022                	sd	s0,0(sp)
    80000e02:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000e04:	02c05363          	blez	a2,80000e2a <safestrcpy+0x2e>
    80000e08:	fff6069b          	addiw	a3,a2,-1
    80000e0c:	1682                	slli	a3,a3,0x20
    80000e0e:	9281                	srli	a3,a3,0x20
    80000e10:	96ae                	add	a3,a3,a1
    80000e12:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000e14:	00d58963          	beq	a1,a3,80000e26 <safestrcpy+0x2a>
    80000e18:	0585                	addi	a1,a1,1
    80000e1a:	0785                	addi	a5,a5,1
    80000e1c:	fff5c703          	lbu	a4,-1(a1)
    80000e20:	fee78fa3          	sb	a4,-1(a5)
    80000e24:	fb65                	bnez	a4,80000e14 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e26:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e2a:	60a2                	ld	ra,8(sp)
    80000e2c:	6402                	ld	s0,0(sp)
    80000e2e:	0141                	addi	sp,sp,16
    80000e30:	8082                	ret

0000000080000e32 <strlen>:

int
strlen(const char *s)
{
    80000e32:	1141                	addi	sp,sp,-16
    80000e34:	e406                	sd	ra,8(sp)
    80000e36:	e022                	sd	s0,0(sp)
    80000e38:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000e3a:	00054783          	lbu	a5,0(a0)
    80000e3e:	cf91                	beqz	a5,80000e5a <strlen+0x28>
    80000e40:	00150793          	addi	a5,a0,1
    80000e44:	86be                	mv	a3,a5
    80000e46:	0785                	addi	a5,a5,1
    80000e48:	fff7c703          	lbu	a4,-1(a5)
    80000e4c:	ff65                	bnez	a4,80000e44 <strlen+0x12>
    80000e4e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000e52:	60a2                	ld	ra,8(sp)
    80000e54:	6402                	ld	s0,0(sp)
    80000e56:	0141                	addi	sp,sp,16
    80000e58:	8082                	ret
  for (n = 0; s[n]; n++)
    80000e5a:	4501                	li	a0,0
    80000e5c:	bfdd                	j	80000e52 <strlen+0x20>

0000000080000e5e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e5e:	1141                	addi	sp,sp,-16
    80000e60:	e406                	sd	ra,8(sp)
    80000e62:	e022                	sd	s0,0(sp)
    80000e64:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000e66:	28f000ef          	jal	800018f4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process

    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
  } else {
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000e6a:	0000a717          	auipc	a4,0xa
    80000e6e:	6b270713          	addi	a4,a4,1714 # 8000b51c <started>
  if (cpuid() == 0) {
    80000e72:	c51d                	beqz	a0,80000ea0 <main+0x42>
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000e74:	431c                	lw	a5,0(a4)
    80000e76:	0230000f          	fence	r,rw
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	dfe5                	beqz	a5,80000e74 <main+0x16>
      ;

    printk("hart %d starting\n", cpuid());
    80000e7e:	277000ef          	jal	800018f4 <cpuid>
    80000e82:	85aa                	mv	a1,a0
    80000e84:	00007517          	auipc	a0,0x7
    80000e88:	21450513          	addi	a0,a0,532 # 80008098 <etext+0x98>
    80000e8c:	e7eff0ef          	jal	8000050a <printk>
    kvminithart();  // turn on paging
    80000e90:	086000ef          	jal	80000f16 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000e94:	6b4010ef          	jal	80002548 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000e98:	191040ef          	jal	80005828 <plicinithart>
  }

  scheduler();
    80000e9c:	7bb000ef          	jal	80001e56 <scheduler>
    consoleinit();
    80000ea0:	d90ff0ef          	jal	80000430 <consoleinit>
    printkinit();
    80000ea4:	9cdff0ef          	jal	80000870 <printkinit>
    printk("\n");
    80000ea8:	00007517          	auipc	a0,0x7
    80000eac:	1d050513          	addi	a0,a0,464 # 80008078 <etext+0x78>
    80000eb0:	e5aff0ef          	jal	8000050a <printk>
    printk("xv6 kernel is booting\n");
    80000eb4:	00007517          	auipc	a0,0x7
    80000eb8:	1cc50513          	addi	a0,a0,460 # 80008080 <etext+0x80>
    80000ebc:	e4eff0ef          	jal	8000050a <printk>
    printk("\n");
    80000ec0:	00007517          	auipc	a0,0x7
    80000ec4:	1b850513          	addi	a0,a0,440 # 80008078 <etext+0x78>
    80000ec8:	e42ff0ef          	jal	8000050a <printk>
    kinit();            // physical page allocator
    80000ecc:	c0fff0ef          	jal	80000ada <kinit>
    kvminit();          // create kernel page table
    80000ed0:	2d2000ef          	jal	800011a2 <kvminit>
    kvminithart();      // turn on paging
    80000ed4:	042000ef          	jal	80000f16 <kvminithart>
    procinit();         // process table
    80000ed8:	14b000ef          	jal	80001822 <procinit>
seminit();
    80000edc:	6e5040ef          	jal	80005dc0 <seminit>
    trapinit();         // trap vectors
    80000ee0:	644010ef          	jal	80002524 <trapinit>
    trapinithart();     // install kernel trap vector
    80000ee4:	664010ef          	jal	80002548 <trapinithart>
    plicinit();         // set up interrupt controller
    80000ee8:	127040ef          	jal	8000580e <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000eec:	13d040ef          	jal	80005828 <plicinithart>
    binit();            // buffer cache
    80000ef0:	617010ef          	jal	80002d06 <binit>
    iinit();            // inode table
    80000ef4:	368020ef          	jal	8000325c <iinit>
    fileinit();         // file table
    80000ef8:	388030ef          	jal	80004280 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	21d040ef          	jal	80005918 <virtio_disk_init>
    userinit();         // first user process
    80000f00:	54b000ef          	jal	80001c4a <userinit>
    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
    80000f04:	0000a797          	auipc	a5,0xa
    80000f08:	61878793          	addi	a5,a5,1560 # 8000b51c <started>
    80000f0c:	4705                	li	a4,1
    80000f0e:	0310000f          	fence	rw,w
    80000f12:	c398                	sw	a4,0(a5)
    80000f14:	b761                	j	80000e9c <main+0x3e>

0000000080000f16 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f16:	1141                	addi	sp,sp,-16
    80000f18:	e406                	sd	ra,8(sp)
    80000f1a:	e022                	sd	s0,0(sp)
    80000f1c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f1e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f22:	0000a797          	auipc	a5,0xa
    80000f26:	5fe7b783          	ld	a5,1534(a5) # 8000b520 <kernel_pagetable>
    80000f2a:	83b1                	srli	a5,a5,0xc
    80000f2c:	577d                	li	a4,-1
    80000f2e:	177e                	slli	a4,a4,0x3f
    80000f30:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000f32:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f36:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f3a:	60a2                	ld	ra,8(sp)
    80000f3c:	6402                	ld	s0,0(sp)
    80000f3e:	0141                	addi	sp,sp,16
    80000f40:	8082                	ret

0000000080000f42 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f42:	7139                	addi	sp,sp,-64
    80000f44:	fc06                	sd	ra,56(sp)
    80000f46:	f822                	sd	s0,48(sp)
    80000f48:	f426                	sd	s1,40(sp)
    80000f4a:	f04a                	sd	s2,32(sp)
    80000f4c:	ec4e                	sd	s3,24(sp)
    80000f4e:	e852                	sd	s4,16(sp)
    80000f50:	e456                	sd	s5,8(sp)
    80000f52:	e05a                	sd	s6,0(sp)
    80000f54:	0080                	addi	s0,sp,64
    80000f56:	84aa                	mv	s1,a0
    80000f58:	89ae                	mv	s3,a1
    80000f5a:	8b32                	mv	s6,a2
  if (va >= MAXVA)
    80000f5c:	57fd                	li	a5,-1
    80000f5e:	83e9                	srli	a5,a5,0x1a
    80000f60:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000f62:	4ab1                	li	s5,12
  if (va >= MAXVA)
    80000f64:	04b7e263          	bltu	a5,a1,80000fa8 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f68:	0149d933          	srl	s2,s3,s4
    80000f6c:	1ff97913          	andi	s2,s2,511
    80000f70:	090e                	slli	s2,s2,0x3
    80000f72:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000f74:	00093483          	ld	s1,0(s2)
    80000f78:	0014f793          	andi	a5,s1,1
    80000f7c:	cf85                	beqz	a5,80000fb4 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f7e:	80a9                	srli	s1,s1,0xa
    80000f80:	04b2                	slli	s1,s1,0xc
  for (int level = 2; level > 0; level--) {
    80000f82:	3a5d                	addiw	s4,s4,-9
    80000f84:	ff5a12e3          	bne	s4,s5,80000f68 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000f88:	00c9d513          	srli	a0,s3,0xc
    80000f8c:	1ff57513          	andi	a0,a0,511
    80000f90:	050e                	slli	a0,a0,0x3
    80000f92:	9526                	add	a0,a0,s1
}
    80000f94:	70e2                	ld	ra,56(sp)
    80000f96:	7442                	ld	s0,48(sp)
    80000f98:	74a2                	ld	s1,40(sp)
    80000f9a:	7902                	ld	s2,32(sp)
    80000f9c:	69e2                	ld	s3,24(sp)
    80000f9e:	6a42                	ld	s4,16(sp)
    80000fa0:	6aa2                	ld	s5,8(sp)
    80000fa2:	6b02                	ld	s6,0(sp)
    80000fa4:	6121                	addi	sp,sp,64
    80000fa6:	8082                	ret
    panic("walk");
    80000fa8:	00007517          	auipc	a0,0x7
    80000fac:	10850513          	addi	a0,a0,264 # 800080b0 <etext+0xb0>
    80000fb0:	885ff0ef          	jal	80000834 <panic>
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000fb4:	020b0263          	beqz	s6,80000fd8 <walk+0x96>
    80000fb8:	b57ff0ef          	jal	80000b0e <kalloc>
    80000fbc:	84aa                	mv	s1,a0
    80000fbe:	d979                	beqz	a0,80000f94 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000fc0:	6605                	lui	a2,0x1
    80000fc2:	4581                	li	a1,0
    80000fc4:	ce5ff0ef          	jal	80000ca8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fc8:	00c4d793          	srli	a5,s1,0xc
    80000fcc:	07aa                	slli	a5,a5,0xa
    80000fce:	0017e793          	ori	a5,a5,1
    80000fd2:	00f93023          	sd	a5,0(s2)
    80000fd6:	b775                	j	80000f82 <walk+0x40>
        return 0;
    80000fd8:	4501                	li	a0,0
    80000fda:	bf6d                	j	80000f94 <walk+0x52>

0000000080000fdc <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000fdc:	57fd                	li	a5,-1
    80000fde:	83e9                	srli	a5,a5,0x1a
    80000fe0:	00b7f463          	bgeu	a5,a1,80000fe8 <walkaddr+0xc>
    return 0;
    80000fe4:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe6:	8082                	ret
{
    80000fe8:	1141                	addi	sp,sp,-16
    80000fea:	e406                	sd	ra,8(sp)
    80000fec:	e022                	sd	s0,0(sp)
    80000fee:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000ff0:	4601                	li	a2,0
    80000ff2:	f51ff0ef          	jal	80000f42 <walk>
  if (pte == 0)
    80000ff6:	c901                	beqz	a0,80001006 <walkaddr+0x2a>
  if ((*pte & PTE_V) == 0)
    80000ff8:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000ffa:	0117f693          	andi	a3,a5,17
    80000ffe:	4745                	li	a4,17
    return 0;
    80001000:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80001002:	00e68663          	beq	a3,a4,8000100e <walkaddr+0x32>
}
    80001006:	60a2                	ld	ra,8(sp)
    80001008:	6402                	ld	s0,0(sp)
    8000100a:	0141                	addi	sp,sp,16
    8000100c:	8082                	ret
  pa = PTE2PA(*pte);
    8000100e:	83a9                	srli	a5,a5,0xa
    80001010:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001014:	bfcd                	j	80001006 <walkaddr+0x2a>

0000000080001016 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001016:	715d                	addi	sp,sp,-80
    80001018:	e486                	sd	ra,72(sp)
    8000101a:	e0a2                	sd	s0,64(sp)
    8000101c:	fc26                	sd	s1,56(sp)
    8000101e:	f84a                	sd	s2,48(sp)
    80001020:	f44e                	sd	s3,40(sp)
    80001022:	f052                	sd	s4,32(sp)
    80001024:	ec56                	sd	s5,24(sp)
    80001026:	e85a                	sd	s6,16(sp)
    80001028:	e45e                	sd	s7,8(sp)
    8000102a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    8000102c:	03459793          	slli	a5,a1,0x34
    80001030:	eba1                	bnez	a5,80001080 <mappages+0x6a>
    80001032:	8a2a                	mv	s4,a0
    80001034:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80001036:	03461793          	slli	a5,a2,0x34
    8000103a:	eba9                	bnez	a5,8000108c <mappages+0x76>
    panic("mappages: size not aligned");

  if (size == 0)
    8000103c:	ce31                	beqz	a2,80001098 <mappages+0x82>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    8000103e:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80001042:	80060613          	addi	a2,a2,-2048
    80001046:	00b60933          	add	s2,a2,a1
  a = va;
    8000104a:	84ae                	mv	s1,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000104c:	4b05                	li	s6,1
    8000104e:	40b689b3          	sub	s3,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80001052:	6b85                	lui	s7,0x1
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001054:	865a                	mv	a2,s6
    80001056:	85a6                	mv	a1,s1
    80001058:	8552                	mv	a0,s4
    8000105a:	ee9ff0ef          	jal	80000f42 <walk>
    8000105e:	c929                	beqz	a0,800010b0 <mappages+0x9a>
    if (*pte & PTE_V)
    80001060:	611c                	ld	a5,0(a0)
    80001062:	8b85                	andi	a5,a5,1
    80001064:	e3a1                	bnez	a5,800010a4 <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001066:	013487b3          	add	a5,s1,s3
    8000106a:	83b1                	srli	a5,a5,0xc
    8000106c:	07aa                	slli	a5,a5,0xa
    8000106e:	0157e7b3          	or	a5,a5,s5
    80001072:	0017e793          	ori	a5,a5,1
    80001076:	e11c                	sd	a5,0(a0)
    if (a == last)
    80001078:	05248863          	beq	s1,s2,800010c8 <mappages+0xb2>
    a += PGSIZE;
    8000107c:	94de                	add	s1,s1,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000107e:	bfd9                	j	80001054 <mappages+0x3e>
    panic("mappages: va not aligned");
    80001080:	00007517          	auipc	a0,0x7
    80001084:	03850513          	addi	a0,a0,56 # 800080b8 <etext+0xb8>
    80001088:	facff0ef          	jal	80000834 <panic>
    panic("mappages: size not aligned");
    8000108c:	00007517          	auipc	a0,0x7
    80001090:	04c50513          	addi	a0,a0,76 # 800080d8 <etext+0xd8>
    80001094:	fa0ff0ef          	jal	80000834 <panic>
    panic("mappages: size");
    80001098:	00007517          	auipc	a0,0x7
    8000109c:	06050513          	addi	a0,a0,96 # 800080f8 <etext+0xf8>
    800010a0:	f94ff0ef          	jal	80000834 <panic>
      panic("mappages: remap");
    800010a4:	00007517          	auipc	a0,0x7
    800010a8:	06450513          	addi	a0,a0,100 # 80008108 <etext+0x108>
    800010ac:	f88ff0ef          	jal	80000834 <panic>
      return -1;
    800010b0:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010b2:	60a6                	ld	ra,72(sp)
    800010b4:	6406                	ld	s0,64(sp)
    800010b6:	74e2                	ld	s1,56(sp)
    800010b8:	7942                	ld	s2,48(sp)
    800010ba:	79a2                	ld	s3,40(sp)
    800010bc:	7a02                	ld	s4,32(sp)
    800010be:	6ae2                	ld	s5,24(sp)
    800010c0:	6b42                	ld	s6,16(sp)
    800010c2:	6ba2                	ld	s7,8(sp)
    800010c4:	6161                	addi	sp,sp,80
    800010c6:	8082                	ret
  return 0;
    800010c8:	4501                	li	a0,0
    800010ca:	b7e5                	j	800010b2 <mappages+0x9c>

00000000800010cc <kvmmap>:
{
    800010cc:	1141                	addi	sp,sp,-16
    800010ce:	e406                	sd	ra,8(sp)
    800010d0:	e022                	sd	s0,0(sp)
    800010d2:	0800                	addi	s0,sp,16
    800010d4:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010d6:	86b2                	mv	a3,a2
    800010d8:	863e                	mv	a2,a5
    800010da:	f3dff0ef          	jal	80001016 <mappages>
    800010de:	e509                	bnez	a0,800010e8 <kvmmap+0x1c>
}
    800010e0:	60a2                	ld	ra,8(sp)
    800010e2:	6402                	ld	s0,0(sp)
    800010e4:	0141                	addi	sp,sp,16
    800010e6:	8082                	ret
    panic("kvmmap");
    800010e8:	00007517          	auipc	a0,0x7
    800010ec:	03050513          	addi	a0,a0,48 # 80008118 <etext+0x118>
    800010f0:	f44ff0ef          	jal	80000834 <panic>

00000000800010f4 <kvmmake>:
{
    800010f4:	1101                	addi	sp,sp,-32
    800010f6:	ec06                	sd	ra,24(sp)
    800010f8:	e822                	sd	s0,16(sp)
    800010fa:	e426                	sd	s1,8(sp)
    800010fc:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    800010fe:	a11ff0ef          	jal	80000b0e <kalloc>
    80001102:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001104:	6605                	lui	a2,0x1
    80001106:	4581                	li	a1,0
    80001108:	ba1ff0ef          	jal	80000ca8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000110c:	4719                	li	a4,6
    8000110e:	6685                	lui	a3,0x1
    80001110:	10000637          	lui	a2,0x10000
    80001114:	85b2                	mv	a1,a2
    80001116:	8526                	mv	a0,s1
    80001118:	fb5ff0ef          	jal	800010cc <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000111c:	4719                	li	a4,6
    8000111e:	6685                	lui	a3,0x1
    80001120:	10001637          	lui	a2,0x10001
    80001124:	85b2                	mv	a1,a2
    80001126:	8526                	mv	a0,s1
    80001128:	fa5ff0ef          	jal	800010cc <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000112c:	4719                	li	a4,6
    8000112e:	040006b7          	lui	a3,0x4000
    80001132:	0c000637          	lui	a2,0xc000
    80001136:	85b2                	mv	a1,a2
    80001138:	8526                	mv	a0,s1
    8000113a:	f93ff0ef          	jal	800010cc <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000113e:	4729                	li	a4,10
    80001140:	80007697          	auipc	a3,0x80007
    80001144:	ec068693          	addi	a3,a3,-320 # 8000 <_entry-0x7fff8000>
    80001148:	4605                	li	a2,1
    8000114a:	067e                	slli	a2,a2,0x1f
    8000114c:	85b2                	mv	a1,a2
    8000114e:	8526                	mv	a0,s1
    80001150:	f7dff0ef          	jal	800010cc <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80001154:	4719                	li	a4,6
    80001156:	00007697          	auipc	a3,0x7
    8000115a:	eaa68693          	addi	a3,a3,-342 # 80008000 <etext>
    8000115e:	47c5                	li	a5,17
    80001160:	07ee                	slli	a5,a5,0x1b
    80001162:	40d786b3          	sub	a3,a5,a3
    80001166:	00007617          	auipc	a2,0x7
    8000116a:	e9a60613          	addi	a2,a2,-358 # 80008000 <etext>
    8000116e:	85b2                	mv	a1,a2
    80001170:	8526                	mv	a0,s1
    80001172:	f5bff0ef          	jal	800010cc <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001176:	4729                	li	a4,10
    80001178:	6685                	lui	a3,0x1
    8000117a:	00006617          	auipc	a2,0x6
    8000117e:	e8660613          	addi	a2,a2,-378 # 80007000 <_trampoline>
    80001182:	040005b7          	lui	a1,0x4000
    80001186:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001188:	05b2                	slli	a1,a1,0xc
    8000118a:	8526                	mv	a0,s1
    8000118c:	f41ff0ef          	jal	800010cc <kvmmap>
  proc_mapstacks(kpgtbl);
    80001190:	8526                	mv	a0,s1
    80001192:	5ec000ef          	jal	8000177e <proc_mapstacks>
}
    80001196:	8526                	mv	a0,s1
    80001198:	60e2                	ld	ra,24(sp)
    8000119a:	6442                	ld	s0,16(sp)
    8000119c:	64a2                	ld	s1,8(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret

00000000800011a2 <kvminit>:
{
    800011a2:	1141                	addi	sp,sp,-16
    800011a4:	e406                	sd	ra,8(sp)
    800011a6:	e022                	sd	s0,0(sp)
    800011a8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011aa:	f4bff0ef          	jal	800010f4 <kvmmake>
    800011ae:	0000a797          	auipc	a5,0xa
    800011b2:	36a7b923          	sd	a0,882(a5) # 8000b520 <kernel_pagetable>
}
    800011b6:	60a2                	ld	ra,8(sp)
    800011b8:	6402                	ld	s0,0(sp)
    800011ba:	0141                	addi	sp,sp,16
    800011bc:	8082                	ret

00000000800011be <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011be:	1101                	addi	sp,sp,-32
    800011c0:	ec06                	sd	ra,24(sp)
    800011c2:	e822                	sd	s0,16(sp)
    800011c4:	e426                	sd	s1,8(sp)
    800011c6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800011c8:	947ff0ef          	jal	80000b0e <kalloc>
    800011cc:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800011ce:	c509                	beqz	a0,800011d8 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011d0:	6605                	lui	a2,0x1
    800011d2:	4581                	li	a1,0
    800011d4:	ad5ff0ef          	jal	80000ca8 <memset>
  return pagetable;
}
    800011d8:	8526                	mv	a0,s1
    800011da:	60e2                	ld	ra,24(sp)
    800011dc:	6442                	ld	s0,16(sp)
    800011de:	64a2                	ld	s1,8(sp)
    800011e0:	6105                	addi	sp,sp,32
    800011e2:	8082                	ret

00000000800011e4 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011e4:	7139                	addi	sp,sp,-64
    800011e6:	fc06                	sd	ra,56(sp)
    800011e8:	f822                	sd	s0,48(sp)
    800011ea:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800011ec:	03459793          	slli	a5,a1,0x34
    800011f0:	e38d                	bnez	a5,80001212 <uvmunmap+0x2e>
    800011f2:	f04a                	sd	s2,32(sp)
    800011f4:	ec4e                	sd	s3,24(sp)
    800011f6:	e852                	sd	s4,16(sp)
    800011f8:	e456                	sd	s5,8(sp)
    800011fa:	e05a                	sd	s6,0(sp)
    800011fc:	8a2a                	mv	s4,a0
    800011fe:	892e                	mv	s2,a1
    80001200:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001202:	0632                	slli	a2,a2,0xc
    80001204:	00b609b3          	add	s3,a2,a1
    80001208:	6b05                	lui	s6,0x1
    8000120a:	0535f963          	bgeu	a1,s3,8000125c <uvmunmap+0x78>
    8000120e:	f426                	sd	s1,40(sp)
    80001210:	a015                	j	80001234 <uvmunmap+0x50>
    80001212:	f426                	sd	s1,40(sp)
    80001214:	f04a                	sd	s2,32(sp)
    80001216:	ec4e                	sd	s3,24(sp)
    80001218:	e852                	sd	s4,16(sp)
    8000121a:	e456                	sd	s5,8(sp)
    8000121c:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    8000121e:	00007517          	auipc	a0,0x7
    80001222:	f0250513          	addi	a0,a0,-254 # 80008120 <etext+0x120>
    80001226:	e0eff0ef          	jal	80000834 <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    8000122a:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000122e:	995a                	add	s2,s2,s6
    80001230:	03397563          	bgeu	s2,s3,8000125a <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001234:	4601                	li	a2,0
    80001236:	85ca                	mv	a1,s2
    80001238:	8552                	mv	a0,s4
    8000123a:	d09ff0ef          	jal	80000f42 <walk>
    8000123e:	84aa                	mv	s1,a0
    80001240:	d57d                	beqz	a0,8000122e <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    80001242:	611c                	ld	a5,0(a0)
    80001244:	0017f713          	andi	a4,a5,1
    80001248:	d37d                	beqz	a4,8000122e <uvmunmap+0x4a>
    if (do_free) {
    8000124a:	fe0a80e3          	beqz	s5,8000122a <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    8000124e:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    80001250:	00c79513          	slli	a0,a5,0xc
    80001254:	fd2ff0ef          	jal	80000a26 <kfree>
    80001258:	bfc9                	j	8000122a <uvmunmap+0x46>
    8000125a:	74a2                	ld	s1,40(sp)
    8000125c:	7902                	ld	s2,32(sp)
    8000125e:	69e2                	ld	s3,24(sp)
    80001260:	6a42                	ld	s4,16(sp)
    80001262:	6aa2                	ld	s5,8(sp)
    80001264:	6b02                	ld	s6,0(sp)
  }
}
    80001266:	70e2                	ld	ra,56(sp)
    80001268:	7442                	ld	s0,48(sp)
    8000126a:	6121                	addi	sp,sp,64
    8000126c:	8082                	ret

000000008000126e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000126e:	1101                	addi	sp,sp,-32
    80001270:	ec06                	sd	ra,24(sp)
    80001272:	e822                	sd	s0,16(sp)
    80001274:	e426                	sd	s1,8(sp)
    80001276:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80001278:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    8000127a:	00b67d63          	bgeu	a2,a1,80001294 <uvmdealloc+0x26>
    8000127e:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80001280:	6785                	lui	a5,0x1
    80001282:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001284:	00f60733          	add	a4,a2,a5
    80001288:	76fd                	lui	a3,0xfffff
    8000128a:	8f75                	and	a4,a4,a3
    8000128c:	97ae                	add	a5,a5,a1
    8000128e:	8ff5                	and	a5,a5,a3
    80001290:	00f76863          	bltu	a4,a5,800012a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001294:	8526                	mv	a0,s1
    80001296:	60e2                	ld	ra,24(sp)
    80001298:	6442                	ld	s0,16(sp)
    8000129a:	64a2                	ld	s1,8(sp)
    8000129c:	6105                	addi	sp,sp,32
    8000129e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012a0:	8f99                	sub	a5,a5,a4
    800012a2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012a4:	4685                	li	a3,1
    800012a6:	0007861b          	sext.w	a2,a5
    800012aa:	85ba                	mv	a1,a4
    800012ac:	f39ff0ef          	jal	800011e4 <uvmunmap>
    800012b0:	b7d5                	j	80001294 <uvmdealloc+0x26>

00000000800012b2 <uvmalloc>:
  if (newsz < oldsz)
    800012b2:	0ab66163          	bltu	a2,a1,80001354 <uvmalloc+0xa2>
{
    800012b6:	715d                	addi	sp,sp,-80
    800012b8:	e486                	sd	ra,72(sp)
    800012ba:	e0a2                	sd	s0,64(sp)
    800012bc:	f84a                	sd	s2,48(sp)
    800012be:	f052                	sd	s4,32(sp)
    800012c0:	ec56                	sd	s5,24(sp)
    800012c2:	e45e                	sd	s7,8(sp)
    800012c4:	0880                	addi	s0,sp,80
    800012c6:	8aaa                	mv	s5,a0
    800012c8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012ca:	6785                	lui	a5,0x1
    800012cc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012ce:	95be                	add	a1,a1,a5
    800012d0:	77fd                	lui	a5,0xfffff
    800012d2:	00f5f933          	and	s2,a1,a5
    800012d6:	8bca                	mv	s7,s2
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800012d8:	08c97063          	bgeu	s2,a2,80001358 <uvmalloc+0xa6>
    800012dc:	fc26                	sd	s1,56(sp)
    800012de:	f44e                	sd	s3,40(sp)
    800012e0:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    800012e2:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012e4:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800012e8:	827ff0ef          	jal	80000b0e <kalloc>
    800012ec:	84aa                	mv	s1,a0
    if (mem == 0) {
    800012ee:	c50d                	beqz	a0,80001318 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    800012f0:	864e                	mv	a2,s3
    800012f2:	4581                	li	a1,0
    800012f4:	9b5ff0ef          	jal	80000ca8 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012f8:	875a                	mv	a4,s6
    800012fa:	86a6                	mv	a3,s1
    800012fc:	864e                	mv	a2,s3
    800012fe:	85ca                	mv	a1,s2
    80001300:	8556                	mv	a0,s5
    80001302:	d15ff0ef          	jal	80001016 <mappages>
    80001306:	e915                	bnez	a0,8000133a <uvmalloc+0x88>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80001308:	994e                	add	s2,s2,s3
    8000130a:	fd496fe3          	bltu	s2,s4,800012e8 <uvmalloc+0x36>
  return newsz;
    8000130e:	8552                	mv	a0,s4
    80001310:	74e2                	ld	s1,56(sp)
    80001312:	79a2                	ld	s3,40(sp)
    80001314:	6b42                	ld	s6,16(sp)
    80001316:	a811                	j	8000132a <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80001318:	865e                	mv	a2,s7
    8000131a:	85ca                	mv	a1,s2
    8000131c:	8556                	mv	a0,s5
    8000131e:	f51ff0ef          	jal	8000126e <uvmdealloc>
      return 0;
    80001322:	4501                	li	a0,0
    80001324:	74e2                	ld	s1,56(sp)
    80001326:	79a2                	ld	s3,40(sp)
    80001328:	6b42                	ld	s6,16(sp)
}
    8000132a:	60a6                	ld	ra,72(sp)
    8000132c:	6406                	ld	s0,64(sp)
    8000132e:	7942                	ld	s2,48(sp)
    80001330:	7a02                	ld	s4,32(sp)
    80001332:	6ae2                	ld	s5,24(sp)
    80001334:	6ba2                	ld	s7,8(sp)
    80001336:	6161                	addi	sp,sp,80
    80001338:	8082                	ret
      kfree(mem);
    8000133a:	8526                	mv	a0,s1
    8000133c:	eeaff0ef          	jal	80000a26 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001340:	865e                	mv	a2,s7
    80001342:	85ca                	mv	a1,s2
    80001344:	8556                	mv	a0,s5
    80001346:	f29ff0ef          	jal	8000126e <uvmdealloc>
      return 0;
    8000134a:	4501                	li	a0,0
    8000134c:	74e2                	ld	s1,56(sp)
    8000134e:	79a2                	ld	s3,40(sp)
    80001350:	6b42                	ld	s6,16(sp)
    80001352:	bfe1                	j	8000132a <uvmalloc+0x78>
    return oldsz;
    80001354:	852e                	mv	a0,a1
}
    80001356:	8082                	ret
  return newsz;
    80001358:	8532                	mv	a0,a2
    8000135a:	bfc1                	j	8000132a <uvmalloc+0x78>

000000008000135c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000135c:	7179                	addi	sp,sp,-48
    8000135e:	f406                	sd	ra,40(sp)
    80001360:	f022                	sd	s0,32(sp)
    80001362:	ec26                	sd	s1,24(sp)
    80001364:	e84a                	sd	s2,16(sp)
    80001366:	e44e                	sd	s3,8(sp)
    80001368:	1800                	addi	s0,sp,48
    8000136a:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    8000136c:	84aa                	mv	s1,a0
    8000136e:	6905                	lui	s2,0x1
    80001370:	992a                	add	s2,s2,a0
    80001372:	a811                	j	80001386 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      panic("freewalk: leaf");
    80001374:	00007517          	auipc	a0,0x7
    80001378:	dc450513          	addi	a0,a0,-572 # 80008138 <etext+0x138>
    8000137c:	cb8ff0ef          	jal	80000834 <panic>
  for (int i = 0; i < 512; i++) {
    80001380:	04a1                	addi	s1,s1,8
    80001382:	03248163          	beq	s1,s2,800013a4 <freewalk+0x48>
    pte_t pte = pagetable[i];
    80001386:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001388:	0017f713          	andi	a4,a5,1
    8000138c:	db75                	beqz	a4,80001380 <freewalk+0x24>
    8000138e:	00e7f713          	andi	a4,a5,14
    80001392:	f36d                	bnez	a4,80001374 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    80001394:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001396:	00c79513          	slli	a0,a5,0xc
    8000139a:	fc3ff0ef          	jal	8000135c <freewalk>
      pagetable[i] = 0;
    8000139e:	0004b023          	sd	zero,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800013a2:	bff9                	j	80001380 <freewalk+0x24>
    }
  }
  kfree((void *)pagetable);
    800013a4:	854e                	mv	a0,s3
    800013a6:	e80ff0ef          	jal	80000a26 <kfree>
}
    800013aa:	70a2                	ld	ra,40(sp)
    800013ac:	7402                	ld	s0,32(sp)
    800013ae:	64e2                	ld	s1,24(sp)
    800013b0:	6942                	ld	s2,16(sp)
    800013b2:	69a2                	ld	s3,8(sp)
    800013b4:	6145                	addi	sp,sp,48
    800013b6:	8082                	ret

00000000800013b8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013b8:	1101                	addi	sp,sp,-32
    800013ba:	ec06                	sd	ra,24(sp)
    800013bc:	e822                	sd	s0,16(sp)
    800013be:	e426                	sd	s1,8(sp)
    800013c0:	1000                	addi	s0,sp,32
    800013c2:	84aa                	mv	s1,a0
  if (sz > 0)
    800013c4:	e989                	bnez	a1,800013d6 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800013c6:	8526                	mv	a0,s1
    800013c8:	f95ff0ef          	jal	8000135c <freewalk>
}
    800013cc:	60e2                	ld	ra,24(sp)
    800013ce:	6442                	ld	s0,16(sp)
    800013d0:	64a2                	ld	s1,8(sp)
    800013d2:	6105                	addi	sp,sp,32
    800013d4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800013d6:	6785                	lui	a5,0x1
    800013d8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013da:	95be                	add	a1,a1,a5
    800013dc:	4685                	li	a3,1
    800013de:	00c5d613          	srli	a2,a1,0xc
    800013e2:	4581                	li	a1,0
    800013e4:	e01ff0ef          	jal	800011e4 <uvmunmap>
    800013e8:	bff9                	j	800013c6 <uvmfree+0xe>

00000000800013ea <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    800013ea:	ca59                	beqz	a2,80001480 <uvmcopy+0x96>
{
    800013ec:	715d                	addi	sp,sp,-80
    800013ee:	e486                	sd	ra,72(sp)
    800013f0:	e0a2                	sd	s0,64(sp)
    800013f2:	fc26                	sd	s1,56(sp)
    800013f4:	f84a                	sd	s2,48(sp)
    800013f6:	f44e                	sd	s3,40(sp)
    800013f8:	f052                	sd	s4,32(sp)
    800013fa:	ec56                	sd	s5,24(sp)
    800013fc:	e85a                	sd	s6,16(sp)
    800013fe:	e45e                	sd	s7,8(sp)
    80001400:	0880                	addi	s0,sp,80
    80001402:	8b2a                	mv	s6,a0
    80001404:	8bae                	mv	s7,a1
    80001406:	8ab2                	mv	s5,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80001408:	4481                	li	s1,0
      continue; // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    8000140a:	6a05                	lui	s4,0x1
    8000140c:	a021                	j	80001414 <uvmcopy+0x2a>
  for (i = 0; i < sz; i += PGSIZE) {
    8000140e:	94d2                	add	s1,s1,s4
    80001410:	0554fc63          	bgeu	s1,s5,80001468 <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0)
    80001414:	4601                	li	a2,0
    80001416:	85a6                	mv	a1,s1
    80001418:	855a                	mv	a0,s6
    8000141a:	b29ff0ef          	jal	80000f42 <walk>
    8000141e:	d965                	beqz	a0,8000140e <uvmcopy+0x24>
    if ((*pte & PTE_V) == 0)
    80001420:	00053983          	ld	s3,0(a0)
    80001424:	0019f793          	andi	a5,s3,1
    80001428:	d3fd                	beqz	a5,8000140e <uvmcopy+0x24>
    if ((mem = kalloc()) == 0)
    8000142a:	ee4ff0ef          	jal	80000b0e <kalloc>
    8000142e:	892a                	mv	s2,a0
    80001430:	c11d                	beqz	a0,80001456 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    80001432:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char *)pa, PGSIZE);
    80001436:	8652                	mv	a2,s4
    80001438:	05b2                	slli	a1,a1,0xc
    8000143a:	8cfff0ef          	jal	80000d08 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    8000143e:	3ff9f713          	andi	a4,s3,1023
    80001442:	86ca                	mv	a3,s2
    80001444:	8652                	mv	a2,s4
    80001446:	85a6                	mv	a1,s1
    80001448:	855e                	mv	a0,s7
    8000144a:	bcdff0ef          	jal	80001016 <mappages>
    8000144e:	d161                	beqz	a0,8000140e <uvmcopy+0x24>
      kfree(mem);
    80001450:	854a                	mv	a0,s2
    80001452:	dd4ff0ef          	jal	80000a26 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001456:	4685                	li	a3,1
    80001458:	00c4d613          	srli	a2,s1,0xc
    8000145c:	4581                	li	a1,0
    8000145e:	855e                	mv	a0,s7
    80001460:	d85ff0ef          	jal	800011e4 <uvmunmap>
  return -1;
    80001464:	557d                	li	a0,-1
    80001466:	a011                	j	8000146a <uvmcopy+0x80>
  return 0;
    80001468:	4501                	li	a0,0
}
    8000146a:	60a6                	ld	ra,72(sp)
    8000146c:	6406                	ld	s0,64(sp)
    8000146e:	74e2                	ld	s1,56(sp)
    80001470:	7942                	ld	s2,48(sp)
    80001472:	79a2                	ld	s3,40(sp)
    80001474:	7a02                	ld	s4,32(sp)
    80001476:	6ae2                	ld	s5,24(sp)
    80001478:	6b42                	ld	s6,16(sp)
    8000147a:	6ba2                	ld	s7,8(sp)
    8000147c:	6161                	addi	sp,sp,80
    8000147e:	8082                	ret
  return 0;
    80001480:	4501                	li	a0,0
}
    80001482:	8082                	ret

0000000080001484 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001484:	1141                	addi	sp,sp,-16
    80001486:	e406                	sd	ra,8(sp)
    80001488:	e022                	sd	s0,0(sp)
    8000148a:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    8000148c:	4601                	li	a2,0
    8000148e:	ab5ff0ef          	jal	80000f42 <walk>
  if (pte == 0)
    80001492:	c901                	beqz	a0,800014a2 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001494:	611c                	ld	a5,0(a0)
    80001496:	9bbd                	andi	a5,a5,-17
    80001498:	e11c                	sd	a5,0(a0)
}
    8000149a:	60a2                	ld	ra,8(sp)
    8000149c:	6402                	ld	s0,0(sp)
    8000149e:	0141                	addi	sp,sp,16
    800014a0:	8082                	ret
    panic("uvmclear");
    800014a2:	00007517          	auipc	a0,0x7
    800014a6:	ca650513          	addi	a0,a0,-858 # 80008148 <etext+0x148>
    800014aa:	b8aff0ef          	jal	80000834 <panic>

00000000800014ae <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800014ae:	1141                	addi	sp,sp,-16
    800014b0:	e406                	sd	ra,8(sp)
    800014b2:	e022                	sd	s0,0(sp)
    800014b4:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800014b6:	4601                	li	a2,0
    800014b8:	a8bff0ef          	jal	80000f42 <walk>
  if (pte == 0) {
    800014bc:	c119                	beqz	a0,800014c2 <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V) {
    800014be:	6108                	ld	a0,0(a0)
    800014c0:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800014c2:	60a2                	ld	ra,8(sp)
    800014c4:	6402                	ld	s0,0(sp)
    800014c6:	0141                	addi	sp,sp,16
    800014c8:	8082                	ret

00000000800014ca <vmfault>:
{
    800014ca:	7179                	addi	sp,sp,-48
    800014cc:	f406                	sd	ra,40(sp)
    800014ce:	f022                	sd	s0,32(sp)
    800014d0:	e052                	sd	s4,0(sp)
    800014d2:	1800                	addi	s0,sp,48
    return 0;
    800014d4:	4a01                	li	s4,0
  if (va >= psz)
    800014d6:	00b66863          	bltu	a2,a1,800014e6 <vmfault+0x1c>
}
    800014da:	8552                	mv	a0,s4
    800014dc:	70a2                	ld	ra,40(sp)
    800014de:	7402                	ld	s0,32(sp)
    800014e0:	6a02                	ld	s4,0(sp)
    800014e2:	6145                	addi	sp,sp,48
    800014e4:	8082                	ret
    800014e6:	ec26                	sd	s1,24(sp)
    800014e8:	e44e                	sd	s3,8(sp)
    800014ea:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    800014ec:	77fd                	lui	a5,0xfffff
    800014ee:	00f679b3          	and	s3,a2,a5
  if (ismapped(pagetable, va)) {
    800014f2:	85ce                	mv	a1,s3
    800014f4:	fbbff0ef          	jal	800014ae <ismapped>
    return 0;
    800014f8:	4a01                	li	s4,0
  if (ismapped(pagetable, va)) {
    800014fa:	c501                	beqz	a0,80001502 <vmfault+0x38>
    800014fc:	64e2                	ld	s1,24(sp)
    800014fe:	69a2                	ld	s3,8(sp)
    80001500:	bfe9                	j	800014da <vmfault+0x10>
    80001502:	e84a                	sd	s2,16(sp)
  mem = (uint64)kalloc();
    80001504:	e0aff0ef          	jal	80000b0e <kalloc>
    80001508:	892a                	mv	s2,a0
  if (mem == 0)
    8000150a:	c915                	beqz	a0,8000153e <vmfault+0x74>
  mem = (uint64)kalloc();
    8000150c:	8a2a                	mv	s4,a0
  memset((void *)mem, 0, PGSIZE);
    8000150e:	6605                	lui	a2,0x1
    80001510:	4581                	li	a1,0
    80001512:	f96ff0ef          	jal	80000ca8 <memset>
  if (mappages(pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    80001516:	4759                	li	a4,22
    80001518:	86ca                	mv	a3,s2
    8000151a:	6605                	lui	a2,0x1
    8000151c:	85ce                	mv	a1,s3
    8000151e:	8526                	mv	a0,s1
    80001520:	af7ff0ef          	jal	80001016 <mappages>
    80001524:	e509                	bnez	a0,8000152e <vmfault+0x64>
    80001526:	64e2                	ld	s1,24(sp)
    80001528:	6942                	ld	s2,16(sp)
    8000152a:	69a2                	ld	s3,8(sp)
    8000152c:	b77d                	j	800014da <vmfault+0x10>
    kfree((void *)mem);
    8000152e:	854a                	mv	a0,s2
    80001530:	cf6ff0ef          	jal	80000a26 <kfree>
    return 0;
    80001534:	4a01                	li	s4,0
    80001536:	64e2                	ld	s1,24(sp)
    80001538:	6942                	ld	s2,16(sp)
    8000153a:	69a2                	ld	s3,8(sp)
    8000153c:	bf79                	j	800014da <vmfault+0x10>
    8000153e:	64e2                	ld	s1,24(sp)
    80001540:	6942                	ld	s2,16(sp)
    80001542:	69a2                	ld	s3,8(sp)
    80001544:	bf59                	j	800014da <vmfault+0x10>

0000000080001546 <copyout>:
  while (len > 0) {
    80001546:	cf49                	beqz	a4,800015e0 <copyout+0x9a>
{
    80001548:	7159                	addi	sp,sp,-112
    8000154a:	f486                	sd	ra,104(sp)
    8000154c:	f0a2                	sd	s0,96(sp)
    8000154e:	eca6                	sd	s1,88(sp)
    80001550:	e8ca                	sd	s2,80(sp)
    80001552:	e4ce                	sd	s3,72(sp)
    80001554:	e0d2                	sd	s4,64(sp)
    80001556:	fc56                	sd	s5,56(sp)
    80001558:	f85a                	sd	s6,48(sp)
    8000155a:	f45e                	sd	s7,40(sp)
    8000155c:	f062                	sd	s8,32(sp)
    8000155e:	ec66                	sd	s9,24(sp)
    80001560:	e86a                	sd	s10,16(sp)
    80001562:	e46e                	sd	s11,8(sp)
    80001564:	1880                	addi	s0,sp,112
    80001566:	8baa                	mv	s7,a0
    80001568:	8dae                	mv	s11,a1
    8000156a:	8a32                	mv	s4,a2
    8000156c:	8b36                	mv	s6,a3
    8000156e:	8aba                	mv	s5,a4
    va0 = PGROUNDDOWN(dstva);
    80001570:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    80001572:	5cfd                	li	s9,-1
    80001574:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80001578:	6c05                	lui	s8,0x1
    8000157a:	a005                	j	8000159a <copyout+0x54>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000157c:	409a0533          	sub	a0,s4,s1
    80001580:	0009061b          	sext.w	a2,s2
    80001584:	85da                	mv	a1,s6
    80001586:	954e                	add	a0,a0,s3
    80001588:	f80ff0ef          	jal	80000d08 <memmove>
    len -= n;
    8000158c:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80001590:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80001592:	01848a33          	add	s4,s1,s8
  while (len > 0) {
    80001596:	040a8363          	beqz	s5,800015dc <copyout+0x96>
    va0 = PGROUNDDOWN(dstva);
    8000159a:	01aa74b3          	and	s1,s4,s10
    if (va0 >= MAXVA)
    8000159e:	049ce363          	bltu	s9,s1,800015e4 <copyout+0x9e>
    pa0 = walkaddr(pagetable, va0);
    800015a2:	85a6                	mv	a1,s1
    800015a4:	855e                	mv	a0,s7
    800015a6:	a37ff0ef          	jal	80000fdc <walkaddr>
    800015aa:	89aa                	mv	s3,a0
    if (pa0 == 0) {
    800015ac:	e909                	bnez	a0,800015be <copyout+0x78>
      if ((pa0 = vmfault(pagetable, psz, va0, 0)) == 0) {
    800015ae:	4681                	li	a3,0
    800015b0:	8626                	mv	a2,s1
    800015b2:	85ee                	mv	a1,s11
    800015b4:	855e                	mv	a0,s7
    800015b6:	f15ff0ef          	jal	800014ca <vmfault>
    800015ba:	89aa                	mv	s3,a0
    800015bc:	c521                	beqz	a0,80001604 <copyout+0xbe>
    pte = walk(pagetable, va0, 0);
    800015be:	4601                	li	a2,0
    800015c0:	85a6                	mv	a1,s1
    800015c2:	855e                	mv	a0,s7
    800015c4:	97fff0ef          	jal	80000f42 <walk>
    if ((*pte & PTE_W) == 0)
    800015c8:	611c                	ld	a5,0(a0)
    800015ca:	8b91                	andi	a5,a5,4
    800015cc:	cf95                	beqz	a5,80001608 <copyout+0xc2>
    n = PGSIZE - (dstva - va0);
    800015ce:	41448933          	sub	s2,s1,s4
    800015d2:	9962                	add	s2,s2,s8
    if (n > len)
    800015d4:	fb2af4e3          	bgeu	s5,s2,8000157c <copyout+0x36>
    800015d8:	8956                	mv	s2,s5
    800015da:	b74d                	j	8000157c <copyout+0x36>
  return 0;
    800015dc:	4501                	li	a0,0
    800015de:	a021                	j	800015e6 <copyout+0xa0>
    800015e0:	4501                	li	a0,0
}
    800015e2:	8082                	ret
      return -1;
    800015e4:	557d                	li	a0,-1
}
    800015e6:	70a6                	ld	ra,104(sp)
    800015e8:	7406                	ld	s0,96(sp)
    800015ea:	64e6                	ld	s1,88(sp)
    800015ec:	6946                	ld	s2,80(sp)
    800015ee:	69a6                	ld	s3,72(sp)
    800015f0:	6a06                	ld	s4,64(sp)
    800015f2:	7ae2                	ld	s5,56(sp)
    800015f4:	7b42                	ld	s6,48(sp)
    800015f6:	7ba2                	ld	s7,40(sp)
    800015f8:	7c02                	ld	s8,32(sp)
    800015fa:	6ce2                	ld	s9,24(sp)
    800015fc:	6d42                	ld	s10,16(sp)
    800015fe:	6da2                	ld	s11,8(sp)
    80001600:	6165                	addi	sp,sp,112
    80001602:	8082                	ret
        return -1;
    80001604:	557d                	li	a0,-1
    80001606:	b7c5                	j	800015e6 <copyout+0xa0>
      return -1;
    80001608:	557d                	li	a0,-1
    8000160a:	bff1                	j	800015e6 <copyout+0xa0>

000000008000160c <copyin>:
  while (len > 0) {
    8000160c:	cf41                	beqz	a4,800016a4 <copyin+0x98>
{
    8000160e:	711d                	addi	sp,sp,-96
    80001610:	ec86                	sd	ra,88(sp)
    80001612:	e8a2                	sd	s0,80(sp)
    80001614:	e4a6                	sd	s1,72(sp)
    80001616:	e0ca                	sd	s2,64(sp)
    80001618:	fc4e                	sd	s3,56(sp)
    8000161a:	f852                	sd	s4,48(sp)
    8000161c:	f456                	sd	s5,40(sp)
    8000161e:	f05a                	sd	s6,32(sp)
    80001620:	ec5e                	sd	s7,24(sp)
    80001622:	e862                	sd	s8,16(sp)
    80001624:	e466                	sd	s9,8(sp)
    80001626:	e06a                	sd	s10,0(sp)
    80001628:	1080                	addi	s0,sp,96
    8000162a:	8baa                	mv	s7,a0
    8000162c:	8cae                	mv	s9,a1
    8000162e:	8ab2                	mv	s5,a2
    80001630:	8936                	mv	s2,a3
    80001632:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    80001634:	7c7d                	lui	s8,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001636:	4d05                	li	s10,1
    n = PGSIZE - (srcva - va0);
    80001638:	6b05                	lui	s6,0x1
    8000163a:	a035                	j	80001666 <copyin+0x5a>
    8000163c:	412984b3          	sub	s1,s3,s2
    80001640:	94da                	add	s1,s1,s6
    if (n > len)
    80001642:	009a7363          	bgeu	s4,s1,80001648 <copyin+0x3c>
    80001646:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001648:	413905b3          	sub	a1,s2,s3
    8000164c:	0004861b          	sext.w	a2,s1
    80001650:	95aa                	add	a1,a1,a0
    80001652:	8556                	mv	a0,s5
    80001654:	eb4ff0ef          	jal	80000d08 <memmove>
    len -= n;
    80001658:	409a0a33          	sub	s4,s4,s1
    dst += n;
    8000165c:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    8000165e:	01698933          	add	s2,s3,s6
  while (len > 0) {
    80001662:	020a0263          	beqz	s4,80001686 <copyin+0x7a>
    va0 = PGROUNDDOWN(srcva);
    80001666:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    8000166a:	85ce                	mv	a1,s3
    8000166c:	855e                	mv	a0,s7
    8000166e:	96fff0ef          	jal	80000fdc <walkaddr>
    if (pa0 == 0) {
    80001672:	f569                	bnez	a0,8000163c <copyin+0x30>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001674:	86ea                	mv	a3,s10
    80001676:	864e                	mv	a2,s3
    80001678:	85e6                	mv	a1,s9
    8000167a:	855e                	mv	a0,s7
    8000167c:	e4fff0ef          	jal	800014ca <vmfault>
    80001680:	fd55                	bnez	a0,8000163c <copyin+0x30>
        return -1;
    80001682:	557d                	li	a0,-1
    80001684:	a011                	j	80001688 <copyin+0x7c>
  return 0;
    80001686:	4501                	li	a0,0
}
    80001688:	60e6                	ld	ra,88(sp)
    8000168a:	6446                	ld	s0,80(sp)
    8000168c:	64a6                	ld	s1,72(sp)
    8000168e:	6906                	ld	s2,64(sp)
    80001690:	79e2                	ld	s3,56(sp)
    80001692:	7a42                	ld	s4,48(sp)
    80001694:	7aa2                	ld	s5,40(sp)
    80001696:	7b02                	ld	s6,32(sp)
    80001698:	6be2                	ld	s7,24(sp)
    8000169a:	6c42                	ld	s8,16(sp)
    8000169c:	6ca2                	ld	s9,8(sp)
    8000169e:	6d02                	ld	s10,0(sp)
    800016a0:	6125                	addi	sp,sp,96
    800016a2:	8082                	ret
  return 0;
    800016a4:	4501                	li	a0,0
}
    800016a6:	8082                	ret

00000000800016a8 <copyinstr>:
  while (got_null == 0 && max > 0) {
    800016a8:	c769                	beqz	a4,80001772 <copyinstr+0xca>
{
    800016aa:	711d                	addi	sp,sp,-96
    800016ac:	ec86                	sd	ra,88(sp)
    800016ae:	e8a2                	sd	s0,80(sp)
    800016b0:	e4a6                	sd	s1,72(sp)
    800016b2:	e0ca                	sd	s2,64(sp)
    800016b4:	fc4e                	sd	s3,56(sp)
    800016b6:	f852                	sd	s4,48(sp)
    800016b8:	f456                	sd	s5,40(sp)
    800016ba:	f05a                	sd	s6,32(sp)
    800016bc:	ec5e                	sd	s7,24(sp)
    800016be:	e862                	sd	s8,16(sp)
    800016c0:	e466                	sd	s9,8(sp)
    800016c2:	1080                	addi	s0,sp,96
    800016c4:	8b2a                	mv	s6,a0
    800016c6:	8c2e                	mv	s8,a1
    800016c8:	89b2                	mv	s3,a2
    800016ca:	84b6                	mv	s1,a3
    800016cc:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    800016ce:	7bfd                	lui	s7,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016d0:	4c85                	li	s9,1
    n = PGSIZE - (srcva - va0);
    800016d2:	6a85                	lui	s5,0x1
    800016d4:	a881                	j	80001724 <copyinstr+0x7c>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016d6:	86e6                	mv	a3,s9
    800016d8:	864a                	mv	a2,s2
    800016da:	85e2                	mv	a1,s8
    800016dc:	855a                	mv	a0,s6
    800016de:	dedff0ef          	jal	800014ca <vmfault>
    800016e2:	e921                	bnez	a0,80001732 <copyinstr+0x8a>
        return -1;
    800016e4:	557d                	li	a0,-1
    800016e6:	a801                	j	800016f6 <copyinstr+0x4e>
        *dst = '\0';
    800016e8:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffda370>
        got_null = 1;
    800016ec:	4785                	li	a5,1
  if (got_null) {
    800016ee:	0017c793          	xori	a5,a5,1
    800016f2:	40f0053b          	negw	a0,a5
}
    800016f6:	60e6                	ld	ra,88(sp)
    800016f8:	6446                	ld	s0,80(sp)
    800016fa:	64a6                	ld	s1,72(sp)
    800016fc:	6906                	ld	s2,64(sp)
    800016fe:	79e2                	ld	s3,56(sp)
    80001700:	7a42                	ld	s4,48(sp)
    80001702:	7aa2                	ld	s5,40(sp)
    80001704:	7b02                	ld	s6,32(sp)
    80001706:	6be2                	ld	s7,24(sp)
    80001708:	6c42                	ld	s8,16(sp)
    8000170a:	6ca2                	ld	s9,8(sp)
    8000170c:	6125                	addi	sp,sp,96
    8000170e:	8082                	ret
    80001710:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80001714:	974e                	add	a4,a4,s3
      --max;
    80001716:	40b70a33          	sub	s4,a4,a1
    srcva = va0 + PGSIZE;
    8000171a:	015904b3          	add	s1,s2,s5
  while (got_null == 0 && max > 0) {
    8000171e:	04e58463          	beq	a1,a4,80001766 <copyinstr+0xbe>
{
    80001722:	89be                	mv	s3,a5
    va0 = PGROUNDDOWN(srcva);
    80001724:	0174f933          	and	s2,s1,s7
    pa0 = walkaddr(pagetable, va0);
    80001728:	85ca                	mv	a1,s2
    8000172a:	855a                	mv	a0,s6
    8000172c:	8b1ff0ef          	jal	80000fdc <walkaddr>
    if (pa0 == 0) {
    80001730:	d15d                	beqz	a0,800016d6 <copyinstr+0x2e>
    n = PGSIZE - (srcva - va0);
    80001732:	40990633          	sub	a2,s2,s1
    80001736:	9656                	add	a2,a2,s5
    if (n > max)
    80001738:	00ca7363          	bgeu	s4,a2,8000173e <copyinstr+0x96>
    8000173c:	8652                	mv	a2,s4
    while (n > 0) {
    8000173e:	c615                	beqz	a2,8000176a <copyinstr+0xc2>
    char *p = (char *)(pa0 + (srcva - va0));
    80001740:	412484b3          	sub	s1,s1,s2
    80001744:	94aa                	add	s1,s1,a0
    80001746:	87ce                	mv	a5,s3
      if (*p == '\0') {
    80001748:	413484b3          	sub	s1,s1,s3
    while (n > 0) {
    8000174c:	964e                	add	a2,a2,s3
    8000174e:	85be                	mv	a1,a5
      if (*p == '\0') {
    80001750:	00f48733          	add	a4,s1,a5
    80001754:	00074683          	lbu	a3,0(a4)
    80001758:	dac1                	beqz	a3,800016e8 <copyinstr+0x40>
        *dst = *p;
    8000175a:	00d78023          	sb	a3,0(a5)
      dst++;
    8000175e:	0785                	addi	a5,a5,1
    while (n > 0) {
    80001760:	fec797e3          	bne	a5,a2,8000174e <copyinstr+0xa6>
    80001764:	b775                	j	80001710 <copyinstr+0x68>
    80001766:	4781                	li	a5,0
    80001768:	b759                	j	800016ee <copyinstr+0x46>
    srcva = va0 + PGSIZE;
    8000176a:	6485                	lui	s1,0x1
    8000176c:	94ca                	add	s1,s1,s2
    8000176e:	87ce                	mv	a5,s3
    80001770:	bf4d                	j	80001722 <copyinstr+0x7a>
  int got_null = 0;
    80001772:	4781                	li	a5,0
  if (got_null) {
    80001774:	0017c793          	xori	a5,a5,1
    80001778:	40f0053b          	negw	a0,a5
}
    8000177c:	8082                	ret

000000008000177e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000177e:	715d                	addi	sp,sp,-80
    80001780:	e486                	sd	ra,72(sp)
    80001782:	e0a2                	sd	s0,64(sp)
    80001784:	fc26                	sd	s1,56(sp)
    80001786:	f84a                	sd	s2,48(sp)
    80001788:	f44e                	sd	s3,40(sp)
    8000178a:	f052                	sd	s4,32(sp)
    8000178c:	ec56                	sd	s5,24(sp)
    8000178e:	e85a                	sd	s6,16(sp)
    80001790:	e45e                	sd	s7,8(sp)
    80001792:	e062                	sd	s8,0(sp)
    80001794:	0880                	addi	s0,sp,80
    80001796:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001798:	00012497          	auipc	s1,0x12
    8000179c:	30048493          	addi	s1,s1,768 # 80013a98 <proc>
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    800017a0:	8c26                	mv	s8,s1
    800017a2:	ff4df937          	lui	s2,0xff4df
    800017a6:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9d2d>
    800017aa:	0936                	slli	s2,s2,0xd
    800017ac:	6f590913          	addi	s2,s2,1781
    800017b0:	0936                	slli	s2,s2,0xd
    800017b2:	bd390913          	addi	s2,s2,-1069
    800017b6:	0932                	slli	s2,s2,0xc
    800017b8:	7a790913          	addi	s2,s2,1959
    800017bc:	040009b7          	lui	s3,0x4000
    800017c0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017c2:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017c4:	4b99                	li	s7,6
    800017c6:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    800017c8:	00018a97          	auipc	s5,0x18
    800017cc:	ed0a8a93          	addi	s5,s5,-304 # 80019698 <tickslock>
    char *pa = kalloc();
    800017d0:	b3eff0ef          	jal	80000b0e <kalloc>
    800017d4:	862a                	mv	a2,a0
    if (pa == 0)
    800017d6:	c121                	beqz	a0,80001816 <proc_mapstacks+0x98>
    uint64 va = KSTACK((int)(p - proc));
    800017d8:	418485b3          	sub	a1,s1,s8
    800017dc:	8591                	srai	a1,a1,0x4
    800017de:	032585b3          	mul	a1,a1,s2
    800017e2:	05b6                	slli	a1,a1,0xd
    800017e4:	6789                	lui	a5,0x2
    800017e6:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017e8:	875e                	mv	a4,s7
    800017ea:	86da                	mv	a3,s6
    800017ec:	40b985b3          	sub	a1,s3,a1
    800017f0:	8552                	mv	a0,s4
    800017f2:	8dbff0ef          	jal	800010cc <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017f6:	17048493          	addi	s1,s1,368
    800017fa:	fd549be3          	bne	s1,s5,800017d0 <proc_mapstacks+0x52>
  }
}
    800017fe:	60a6                	ld	ra,72(sp)
    80001800:	6406                	ld	s0,64(sp)
    80001802:	74e2                	ld	s1,56(sp)
    80001804:	7942                	ld	s2,48(sp)
    80001806:	79a2                	ld	s3,40(sp)
    80001808:	7a02                	ld	s4,32(sp)
    8000180a:	6ae2                	ld	s5,24(sp)
    8000180c:	6b42                	ld	s6,16(sp)
    8000180e:	6ba2                	ld	s7,8(sp)
    80001810:	6c02                	ld	s8,0(sp)
    80001812:	6161                	addi	sp,sp,80
    80001814:	8082                	ret
      panic("kalloc");
    80001816:	00007517          	auipc	a0,0x7
    8000181a:	94250513          	addi	a0,a0,-1726 # 80008158 <etext+0x158>
    8000181e:	816ff0ef          	jal	80000834 <panic>

0000000080001822 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001822:	7139                	addi	sp,sp,-64
    80001824:	fc06                	sd	ra,56(sp)
    80001826:	f822                	sd	s0,48(sp)
    80001828:	f426                	sd	s1,40(sp)
    8000182a:	f04a                	sd	s2,32(sp)
    8000182c:	ec4e                	sd	s3,24(sp)
    8000182e:	e852                	sd	s4,16(sp)
    80001830:	e456                	sd	s5,8(sp)
    80001832:	e05a                	sd	s6,0(sp)
    80001834:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001836:	00007597          	auipc	a1,0x7
    8000183a:	92a58593          	addi	a1,a1,-1750 # 80008160 <etext+0x160>
    8000183e:	00012517          	auipc	a0,0x12
    80001842:	e1250513          	addi	a0,a0,-494 # 80013650 <pid_lock>
    80001846:	b22ff0ef          	jal	80000b68 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000184a:	00007597          	auipc	a1,0x7
    8000184e:	91e58593          	addi	a1,a1,-1762 # 80008168 <etext+0x168>
    80001852:	00012517          	auipc	a0,0x12
    80001856:	e1650513          	addi	a0,a0,-490 # 80013668 <wait_lock>
    8000185a:	b0eff0ef          	jal	80000b68 <initlock>
  initlock(&shm_lock, "shm_lock");
    8000185e:	00007597          	auipc	a1,0x7
    80001862:	91a58593          	addi	a1,a1,-1766 # 80008178 <etext+0x178>
    80001866:	00012517          	auipc	a0,0x12
    8000186a:	e1a50513          	addi	a0,a0,-486 # 80013680 <shm_lock>
    8000186e:	afaff0ef          	jal	80000b68 <initlock>
  shm_refcnt = 0;
    80001872:	0000a797          	auipc	a5,0xa
    80001876:	ca07ab23          	sw	zero,-842(a5) # 8000b528 <shm_refcnt>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000187a:	00012497          	auipc	s1,0x12
    8000187e:	21e48493          	addi	s1,s1,542 # 80013a98 <proc>
    initlock(&p->lock, "proc");
    80001882:	00007b17          	auipc	s6,0x7
    80001886:	906b0b13          	addi	s6,s6,-1786 # 80008188 <etext+0x188>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    8000188a:	8aa6                	mv	s5,s1
    8000188c:	ff4df937          	lui	s2,0xff4df
    80001890:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9d2d>
    80001894:	0936                	slli	s2,s2,0xd
    80001896:	6f590913          	addi	s2,s2,1781
    8000189a:	0936                	slli	s2,s2,0xd
    8000189c:	bd390913          	addi	s2,s2,-1069
    800018a0:	0932                	slli	s2,s2,0xc
    800018a2:	7a790913          	addi	s2,s2,1959
    800018a6:	040009b7          	lui	s3,0x4000
    800018aa:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800018ac:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    800018ae:	00018a17          	auipc	s4,0x18
    800018b2:	deaa0a13          	addi	s4,s4,-534 # 80019698 <tickslock>
    initlock(&p->lock, "proc");
    800018b6:	85da                	mv	a1,s6
    800018b8:	8526                	mv	a0,s1
    800018ba:	aaeff0ef          	jal	80000b68 <initlock>
    p->state = UNUSED;
    800018be:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    800018c2:	415487b3          	sub	a5,s1,s5
    800018c6:	8791                	srai	a5,a5,0x4
    800018c8:	032787b3          	mul	a5,a5,s2
    800018cc:	07b6                	slli	a5,a5,0xd
    800018ce:	6709                	lui	a4,0x2
    800018d0:	9fb9                	addw	a5,a5,a4
    800018d2:	40f987b3          	sub	a5,s3,a5
    800018d6:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    800018d8:	17048493          	addi	s1,s1,368
    800018dc:	fd449de3          	bne	s1,s4,800018b6 <procinit+0x94>
  }
}
    800018e0:	70e2                	ld	ra,56(sp)
    800018e2:	7442                	ld	s0,48(sp)
    800018e4:	74a2                	ld	s1,40(sp)
    800018e6:	7902                	ld	s2,32(sp)
    800018e8:	69e2                	ld	s3,24(sp)
    800018ea:	6a42                	ld	s4,16(sp)
    800018ec:	6aa2                	ld	s5,8(sp)
    800018ee:	6b02                	ld	s6,0(sp)
    800018f0:	6121                	addi	sp,sp,64
    800018f2:	8082                	ret

00000000800018f4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018f4:	1141                	addi	sp,sp,-16
    800018f6:	e406                	sd	ra,8(sp)
    800018f8:	e022                	sd	s0,0(sp)
    800018fa:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800018fc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018fe:	2501                	sext.w	a0,a0
    80001900:	60a2                	ld	ra,8(sp)
    80001902:	6402                	ld	s0,0(sp)
    80001904:	0141                	addi	sp,sp,16
    80001906:	8082                	ret

0000000080001908 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001908:	1141                	addi	sp,sp,-16
    8000190a:	e406                	sd	ra,8(sp)
    8000190c:	e022                	sd	s0,0(sp)
    8000190e:	0800                	addi	s0,sp,16
    80001910:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001912:	2781                	sext.w	a5,a5
    80001914:	079e                	slli	a5,a5,0x7
  return c;
}
    80001916:	00012517          	auipc	a0,0x12
    8000191a:	d8250513          	addi	a0,a0,-638 # 80013698 <cpus>
    8000191e:	953e                	add	a0,a0,a5
    80001920:	60a2                	ld	ra,8(sp)
    80001922:	6402                	ld	s0,0(sp)
    80001924:	0141                	addi	sp,sp,16
    80001926:	8082                	ret

0000000080001928 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001928:	1101                	addi	sp,sp,-32
    8000192a:	ec06                	sd	ra,24(sp)
    8000192c:	e822                	sd	s0,16(sp)
    8000192e:	e426                	sd	s1,8(sp)
    80001930:	1000                	addi	s0,sp,32
  push_off();
    80001932:	a7cff0ef          	jal	80000bae <push_off>
    80001936:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001938:	2781                	sext.w	a5,a5
    8000193a:	079e                	slli	a5,a5,0x7
    8000193c:	00012717          	auipc	a4,0x12
    80001940:	d1470713          	addi	a4,a4,-748 # 80013650 <pid_lock>
    80001944:	97ba                	add	a5,a5,a4
    80001946:	67bc                	ld	a5,72(a5)
    80001948:	84be                	mv	s1,a5
  pop_off();
    8000194a:	adeff0ef          	jal	80000c28 <pop_off>
  return p;
}
    8000194e:	8526                	mv	a0,s1
    80001950:	60e2                	ld	ra,24(sp)
    80001952:	6442                	ld	s0,16(sp)
    80001954:	64a2                	ld	s1,8(sp)
    80001956:	6105                	addi	sp,sp,32
    80001958:	8082                	ret

000000008000195a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000195a:	7179                	addi	sp,sp,-48
    8000195c:	f406                	sd	ra,40(sp)
    8000195e:	f022                	sd	s0,32(sp)
    80001960:	ec26                	sd	s1,24(sp)
    80001962:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001964:	fc5ff0ef          	jal	80001928 <myproc>
    80001968:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    8000196a:	b06ff0ef          	jal	80000c70 <release>

  if (__atomic_load_n(&first, __ATOMIC_ACQUIRE)) {
    8000196e:	0000a797          	auipc	a5,0xa
    80001972:	b7278793          	addi	a5,a5,-1166 # 8000b4e0 <first.1>
    80001976:	439c                	lw	a5,0(a5)
    80001978:	0230000f          	fence	r,rw
    8000197c:	2781                	sext.w	a5,a5
    8000197e:	c3a1                	beqz	a5,800019be <forkret+0x64>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001980:	4505                	li	a0,1
    80001982:	5df010ef          	jal	80003760 <fsinit>

    // ensure other cores see first=0.
    __atomic_store_n(&first, 0, __ATOMIC_RELEASE);
    80001986:	0000a797          	auipc	a5,0xa
    8000198a:	b5a78793          	addi	a5,a5,-1190 # 8000b4e0 <first.1>
    8000198e:	0310000f          	fence	rw,w
    80001992:	0007a023          	sw	zero,0(a5)

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    80001996:	00006797          	auipc	a5,0x6
    8000199a:	7fa78793          	addi	a5,a5,2042 # 80008190 <etext+0x190>
    8000199e:	fcf43823          	sd	a5,-48(s0)
    800019a2:	fc043c23          	sd	zero,-40(s0)
    800019a6:	fd040593          	addi	a1,s0,-48
    800019aa:	853e                	mv	a0,a5
    800019ac:	036030ef          	jal	800049e2 <kexec>
    800019b0:	70bc                	ld	a5,96(s1)
    800019b2:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    800019b4:	70bc                	ld	a5,96(s1)
    800019b6:	7bb8                	ld	a4,112(a5)
    800019b8:	57fd                	li	a5,-1
    800019ba:	02f70d63          	beq	a4,a5,800019f4 <forkret+0x9a>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800019be:	3a7000ef          	jal	80002564 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800019c2:	6ca8                	ld	a0,88(s1)
    800019c4:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019c6:	04000737          	lui	a4,0x4000
    800019ca:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019cc:	0732                	slli	a4,a4,0xc
    800019ce:	00005797          	auipc	a5,0x5
    800019d2:	6ce78793          	addi	a5,a5,1742 # 8000709c <userret>
    800019d6:	00005697          	auipc	a3,0x5
    800019da:	62a68693          	addi	a3,a3,1578 # 80007000 <_trampoline>
    800019de:	8f95                	sub	a5,a5,a3
    800019e0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019e2:	577d                	li	a4,-1
    800019e4:	177e                	slli	a4,a4,0x3f
    800019e6:	8d59                	or	a0,a0,a4
    800019e8:	9782                	jalr	a5
}
    800019ea:	70a2                	ld	ra,40(sp)
    800019ec:	7402                	ld	s0,32(sp)
    800019ee:	64e2                	ld	s1,24(sp)
    800019f0:	6145                	addi	sp,sp,48
    800019f2:	8082                	ret
      panic("exec");
    800019f4:	00006517          	auipc	a0,0x6
    800019f8:	7a450513          	addi	a0,a0,1956 # 80008198 <etext+0x198>
    800019fc:	e39fe0ef          	jal	80000834 <panic>

0000000080001a00 <allocpid>:
{
    80001a00:	1101                	addi	sp,sp,-32
    80001a02:	ec06                	sd	ra,24(sp)
    80001a04:	e822                	sd	s0,16(sp)
    80001a06:	e426                	sd	s1,8(sp)
    80001a08:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a0a:	00012517          	auipc	a0,0x12
    80001a0e:	c4650513          	addi	a0,a0,-954 # 80013650 <pid_lock>
    80001a12:	9d6ff0ef          	jal	80000be8 <acquire>
  pid = nextpid;
    80001a16:	0000a797          	auipc	a5,0xa
    80001a1a:	ace78793          	addi	a5,a5,-1330 # 8000b4e4 <nextpid>
    80001a1e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a20:	0014871b          	addiw	a4,s1,1
    80001a24:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a26:	00012517          	auipc	a0,0x12
    80001a2a:	c2a50513          	addi	a0,a0,-982 # 80013650 <pid_lock>
    80001a2e:	a42ff0ef          	jal	80000c70 <release>
}
    80001a32:	8526                	mv	a0,s1
    80001a34:	60e2                	ld	ra,24(sp)
    80001a36:	6442                	ld	s0,16(sp)
    80001a38:	64a2                	ld	s1,8(sp)
    80001a3a:	6105                	addi	sp,sp,32
    80001a3c:	8082                	ret

0000000080001a3e <proc_pagetable>:
{
    80001a3e:	1101                	addi	sp,sp,-32
    80001a40:	ec06                	sd	ra,24(sp)
    80001a42:	e822                	sd	s0,16(sp)
    80001a44:	e426                	sd	s1,8(sp)
    80001a46:	e04a                	sd	s2,0(sp)
    80001a48:	1000                	addi	s0,sp,32
    80001a4a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a4c:	f72ff0ef          	jal	800011be <uvmcreate>
    80001a50:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001a52:	cd05                	beqz	a0,80001a8a <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001a54:	4729                	li	a4,10
    80001a56:	00005697          	auipc	a3,0x5
    80001a5a:	5aa68693          	addi	a3,a3,1450 # 80007000 <_trampoline>
    80001a5e:	6605                	lui	a2,0x1
    80001a60:	040005b7          	lui	a1,0x4000
    80001a64:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a66:	05b2                	slli	a1,a1,0xc
    80001a68:	daeff0ef          	jal	80001016 <mappages>
    80001a6c:	02054663          	bltz	a0,80001a98 <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001a70:	4719                	li	a4,6
    80001a72:	06093683          	ld	a3,96(s2)
    80001a76:	6605                	lui	a2,0x1
    80001a78:	020005b7          	lui	a1,0x2000
    80001a7c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a7e:	05b6                	slli	a1,a1,0xd
    80001a80:	8526                	mv	a0,s1
    80001a82:	d94ff0ef          	jal	80001016 <mappages>
    80001a86:	00054f63          	bltz	a0,80001aa4 <proc_pagetable+0x66>
}
    80001a8a:	8526                	mv	a0,s1
    80001a8c:	60e2                	ld	ra,24(sp)
    80001a8e:	6442                	ld	s0,16(sp)
    80001a90:	64a2                	ld	s1,8(sp)
    80001a92:	6902                	ld	s2,0(sp)
    80001a94:	6105                	addi	sp,sp,32
    80001a96:	8082                	ret
    uvmfree(pagetable, 0);
    80001a98:	4581                	li	a1,0
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	91dff0ef          	jal	800013b8 <uvmfree>
    return 0;
    80001aa0:	4481                	li	s1,0
    80001aa2:	b7e5                	j	80001a8a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001aa4:	4681                	li	a3,0
    80001aa6:	4605                	li	a2,1
    80001aa8:	040005b7          	lui	a1,0x4000
    80001aac:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001aae:	05b2                	slli	a1,a1,0xc
    80001ab0:	8526                	mv	a0,s1
    80001ab2:	f32ff0ef          	jal	800011e4 <uvmunmap>
    uvmfree(pagetable, 0);
    80001ab6:	4581                	li	a1,0
    80001ab8:	8526                	mv	a0,s1
    80001aba:	8ffff0ef          	jal	800013b8 <uvmfree>
    return 0;
    80001abe:	4481                	li	s1,0
    80001ac0:	b7e9                	j	80001a8a <proc_pagetable+0x4c>

0000000080001ac2 <proc_freepagetable>:
{
    80001ac2:	1101                	addi	sp,sp,-32
    80001ac4:	ec06                	sd	ra,24(sp)
    80001ac6:	e822                	sd	s0,16(sp)
    80001ac8:	e426                	sd	s1,8(sp)
    80001aca:	e04a                	sd	s2,0(sp)
    80001acc:	1000                	addi	s0,sp,32
    80001ace:	84aa                	mv	s1,a0
    80001ad0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ad2:	4681                	li	a3,0
    80001ad4:	4605                	li	a2,1
    80001ad6:	040005b7          	lui	a1,0x4000
    80001ada:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001adc:	05b2                	slli	a1,a1,0xc
    80001ade:	f06ff0ef          	jal	800011e4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ae2:	4681                	li	a3,0
    80001ae4:	4605                	li	a2,1
    80001ae6:	020005b7          	lui	a1,0x2000
    80001aea:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aec:	05b6                	slli	a1,a1,0xd
    80001aee:	8526                	mv	a0,s1
    80001af0:	ef4ff0ef          	jal	800011e4 <uvmunmap>
  uvmfree(pagetable, sz);
    80001af4:	85ca                	mv	a1,s2
    80001af6:	8526                	mv	a0,s1
    80001af8:	8c1ff0ef          	jal	800013b8 <uvmfree>
}
    80001afc:	60e2                	ld	ra,24(sp)
    80001afe:	6442                	ld	s0,16(sp)
    80001b00:	64a2                	ld	s1,8(sp)
    80001b02:	6902                	ld	s2,0(sp)
    80001b04:	6105                	addi	sp,sp,32
    80001b06:	8082                	ret

0000000080001b08 <freeproc>:
{
    80001b08:	1101                	addi	sp,sp,-32
    80001b0a:	ec06                	sd	ra,24(sp)
    80001b0c:	e822                	sd	s0,16(sp)
    80001b0e:	e426                	sd	s1,8(sp)
    80001b10:	1000                	addi	s0,sp,32
    80001b12:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001b14:	7128                	ld	a0,96(a0)
    80001b16:	c119                	beqz	a0,80001b1c <freeproc+0x14>
    kfree((void *)p->trapframe);
    80001b18:	f0ffe0ef          	jal	80000a26 <kfree>
  p->trapframe = 0;
    80001b1c:	0604b023          	sd	zero,96(s1)
if(p->shm_pa){
    80001b20:	68bc                	ld	a5,80(s1)
    80001b22:	eb9d                	bnez	a5,80001b58 <freeproc+0x50>
if (p->pagetable)
    80001b24:	6ca8                	ld	a0,88(s1)
    80001b26:	c501                	beqz	a0,80001b2e <freeproc+0x26>
    proc_freepagetable(p->pagetable, p->sz);
    80001b28:	64ac                	ld	a1,72(s1)
    80001b2a:	f99ff0ef          	jal	80001ac2 <proc_freepagetable>
  p->pagetable = 0;
    80001b2e:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001b32:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b36:	0204a823          	sw	zero,48(s1)
  p->name[0] = 0;
    80001b3a:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001b3e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b42:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b46:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b4a:	0004ac23          	sw	zero,24(s1)
}
    80001b4e:	60e2                	ld	ra,24(sp)
    80001b50:	6442                	ld	s0,16(sp)
    80001b52:	64a2                	ld	s1,8(sp)
    80001b54:	6105                	addi	sp,sp,32
    80001b56:	8082                	ret
  uvmunmap(p->pagetable, SHM_BASE, 1, 0);
    80001b58:	4681                	li	a3,0
    80001b5a:	4605                	li	a2,1
    80001b5c:	040005b7          	lui	a1,0x4000
    80001b60:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001b62:	05b2                	slli	a1,a1,0xc
    80001b64:	6ca8                	ld	a0,88(s1)
    80001b66:	e7eff0ef          	jal	800011e4 <uvmunmap>
  acquire(&shm_lock);
    80001b6a:	00012517          	auipc	a0,0x12
    80001b6e:	b1650513          	addi	a0,a0,-1258 # 80013680 <shm_lock>
    80001b72:	876ff0ef          	jal	80000be8 <acquire>
  shm_refcnt--;
    80001b76:	0000a717          	auipc	a4,0xa
    80001b7a:	9b270713          	addi	a4,a4,-1614 # 8000b528 <shm_refcnt>
    80001b7e:	431c                	lw	a5,0(a4)
    80001b80:	37fd                	addiw	a5,a5,-1
    80001b82:	c31c                	sw	a5,0(a4)
  if(shm_refcnt == 0)
    80001b84:	cb91                	beqz	a5,80001b98 <freeproc+0x90>
  release(&shm_lock);
    80001b86:	00012517          	auipc	a0,0x12
    80001b8a:	afa50513          	addi	a0,a0,-1286 # 80013680 <shm_lock>
    80001b8e:	8e2ff0ef          	jal	80000c70 <release>
  p->shm_pa = 0;
    80001b92:	0404b823          	sd	zero,80(s1)
    80001b96:	b779                	j	80001b24 <freeproc+0x1c>
    kfree((void*)p->shm_pa);
    80001b98:	68a8                	ld	a0,80(s1)
    80001b9a:	e8dfe0ef          	jal	80000a26 <kfree>
    80001b9e:	b7e5                	j	80001b86 <freeproc+0x7e>

0000000080001ba0 <allocproc>:
{
    80001ba0:	1101                	addi	sp,sp,-32
    80001ba2:	ec06                	sd	ra,24(sp)
    80001ba4:	e822                	sd	s0,16(sp)
    80001ba6:	e426                	sd	s1,8(sp)
    80001ba8:	e04a                	sd	s2,0(sp)
    80001baa:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001bac:	00012497          	auipc	s1,0x12
    80001bb0:	eec48493          	addi	s1,s1,-276 # 80013a98 <proc>
    80001bb4:	00018917          	auipc	s2,0x18
    80001bb8:	ae490913          	addi	s2,s2,-1308 # 80019698 <tickslock>
    acquire(&p->lock);
    80001bbc:	8526                	mv	a0,s1
    80001bbe:	82aff0ef          	jal	80000be8 <acquire>
    if (p->state == UNUSED) {
    80001bc2:	4c9c                	lw	a5,24(s1)
    80001bc4:	cb91                	beqz	a5,80001bd8 <allocproc+0x38>
      release(&p->lock);
    80001bc6:	8526                	mv	a0,s1
    80001bc8:	8a8ff0ef          	jal	80000c70 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001bcc:	17048493          	addi	s1,s1,368
    80001bd0:	ff2496e3          	bne	s1,s2,80001bbc <allocproc+0x1c>
  return 0;
    80001bd4:	4481                	li	s1,0
    80001bd6:	a099                	j	80001c1c <allocproc+0x7c>
  p->pid = allocpid();
    80001bd8:	e29ff0ef          	jal	80001a00 <allocpid>
    80001bdc:	d888                	sw	a0,48(s1)
p->shm_pa = 0;
    80001bde:	0404b823          	sd	zero,80(s1)
  p->state = USED;
    80001be2:	4785                	li	a5,1
    80001be4:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001be6:	f29fe0ef          	jal	80000b0e <kalloc>
    80001bea:	892a                	mv	s2,a0
    80001bec:	f0a8                	sd	a0,96(s1)
    80001bee:	cd15                	beqz	a0,80001c2a <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80001bf0:	8526                	mv	a0,s1
    80001bf2:	e4dff0ef          	jal	80001a3e <proc_pagetable>
    80001bf6:	892a                	mv	s2,a0
    80001bf8:	eca8                	sd	a0,88(s1)
  if (p->pagetable == 0) {
    80001bfa:	c121                	beqz	a0,80001c3a <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80001bfc:	07000613          	li	a2,112
    80001c00:	4581                	li	a1,0
    80001c02:	06848513          	addi	a0,s1,104
    80001c06:	8a2ff0ef          	jal	80000ca8 <memset>
  p->context.ra = (uint64)forkret;
    80001c0a:	00000797          	auipc	a5,0x0
    80001c0e:	d5078793          	addi	a5,a5,-688 # 8000195a <forkret>
    80001c12:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c14:	60bc                	ld	a5,64(s1)
    80001c16:	6705                	lui	a4,0x1
    80001c18:	97ba                	add	a5,a5,a4
    80001c1a:	f8bc                	sd	a5,112(s1)
}
    80001c1c:	8526                	mv	a0,s1
    80001c1e:	60e2                	ld	ra,24(sp)
    80001c20:	6442                	ld	s0,16(sp)
    80001c22:	64a2                	ld	s1,8(sp)
    80001c24:	6902                	ld	s2,0(sp)
    80001c26:	6105                	addi	sp,sp,32
    80001c28:	8082                	ret
    freeproc(p);
    80001c2a:	8526                	mv	a0,s1
    80001c2c:	eddff0ef          	jal	80001b08 <freeproc>
    release(&p->lock);
    80001c30:	8526                	mv	a0,s1
    80001c32:	83eff0ef          	jal	80000c70 <release>
    return 0;
    80001c36:	84ca                	mv	s1,s2
    80001c38:	b7d5                	j	80001c1c <allocproc+0x7c>
    freeproc(p);
    80001c3a:	8526                	mv	a0,s1
    80001c3c:	ecdff0ef          	jal	80001b08 <freeproc>
    release(&p->lock);
    80001c40:	8526                	mv	a0,s1
    80001c42:	82eff0ef          	jal	80000c70 <release>
    return 0;
    80001c46:	84ca                	mv	s1,s2
    80001c48:	bfd1                	j	80001c1c <allocproc+0x7c>

0000000080001c4a <userinit>:
{
    80001c4a:	1101                	addi	sp,sp,-32
    80001c4c:	ec06                	sd	ra,24(sp)
    80001c4e:	e822                	sd	s0,16(sp)
    80001c50:	e426                	sd	s1,8(sp)
    80001c52:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c54:	f4dff0ef          	jal	80001ba0 <allocproc>
    80001c58:	84aa                	mv	s1,a0
  initproc = p;
    80001c5a:	0000a797          	auipc	a5,0xa
    80001c5e:	8ca7bb23          	sd	a0,-1834(a5) # 8000b530 <initproc>
  p->cwd = namei("/");
    80001c62:	00006517          	auipc	a0,0x6
    80001c66:	53e50513          	addi	a0,a0,1342 # 800081a0 <etext+0x1a0>
    80001c6a:	046020ef          	jal	80003cb0 <namei>
    80001c6e:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001c72:	478d                	li	a5,3
    80001c74:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c76:	8526                	mv	a0,s1
    80001c78:	ff9fe0ef          	jal	80000c70 <release>
}
    80001c7c:	60e2                	ld	ra,24(sp)
    80001c7e:	6442                	ld	s0,16(sp)
    80001c80:	64a2                	ld	s1,8(sp)
    80001c82:	6105                	addi	sp,sp,32
    80001c84:	8082                	ret

0000000080001c86 <growproc>:
{
    80001c86:	1101                	addi	sp,sp,-32
    80001c88:	ec06                	sd	ra,24(sp)
    80001c8a:	e822                	sd	s0,16(sp)
    80001c8c:	e426                	sd	s1,8(sp)
    80001c8e:	e04a                	sd	s2,0(sp)
    80001c90:	1000                	addi	s0,sp,32
    80001c92:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c94:	c95ff0ef          	jal	80001928 <myproc>
    80001c98:	892a                	mv	s2,a0
  sz = p->sz;
    80001c9a:	652c                	ld	a1,72(a0)
  if (n > 0) {
    80001c9c:	02905963          	blez	s1,80001cce <growproc+0x48>
    if (sz + n > TRAPFRAME) {
    80001ca0:	00b48633          	add	a2,s1,a1
    80001ca4:	020007b7          	lui	a5,0x2000
    80001ca8:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001caa:	07b6                	slli	a5,a5,0xd
    80001cac:	02c7ea63          	bltu	a5,a2,80001ce0 <growproc+0x5a>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001cb0:	4691                	li	a3,4
    80001cb2:	6d28                	ld	a0,88(a0)
    80001cb4:	dfeff0ef          	jal	800012b2 <uvmalloc>
    80001cb8:	85aa                	mv	a1,a0
    80001cba:	c50d                	beqz	a0,80001ce4 <growproc+0x5e>
  p->sz = sz;
    80001cbc:	04b93423          	sd	a1,72(s2)
  return 0;
    80001cc0:	4501                	li	a0,0
}
    80001cc2:	60e2                	ld	ra,24(sp)
    80001cc4:	6442                	ld	s0,16(sp)
    80001cc6:	64a2                	ld	s1,8(sp)
    80001cc8:	6902                	ld	s2,0(sp)
    80001cca:	6105                	addi	sp,sp,32
    80001ccc:	8082                	ret
  } else if (n < 0) {
    80001cce:	fe04d7e3          	bgez	s1,80001cbc <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001cd2:	00b48633          	add	a2,s1,a1
    80001cd6:	6d28                	ld	a0,88(a0)
    80001cd8:	d96ff0ef          	jal	8000126e <uvmdealloc>
    80001cdc:	85aa                	mv	a1,a0
    80001cde:	bff9                	j	80001cbc <growproc+0x36>
      return -1;
    80001ce0:	557d                	li	a0,-1
    80001ce2:	b7c5                	j	80001cc2 <growproc+0x3c>
      return -1;
    80001ce4:	557d                	li	a0,-1
    80001ce6:	bff1                	j	80001cc2 <growproc+0x3c>

0000000080001ce8 <kfork>:
{
    80001ce8:	7139                	addi	sp,sp,-64
    80001cea:	fc06                	sd	ra,56(sp)
    80001cec:	f822                	sd	s0,48(sp)
    80001cee:	f426                	sd	s1,40(sp)
    80001cf0:	e456                	sd	s5,8(sp)
    80001cf2:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001cf4:	c35ff0ef          	jal	80001928 <myproc>
    80001cf8:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001cfa:	ea7ff0ef          	jal	80001ba0 <allocproc>
    80001cfe:	14050a63          	beqz	a0,80001e52 <kfork+0x16a>
    80001d02:	ec4e                	sd	s3,24(sp)
    80001d04:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001d06:	048ab603          	ld	a2,72(s5)
    80001d0a:	6d2c                	ld	a1,88(a0)
    80001d0c:	058ab503          	ld	a0,88(s5)
    80001d10:	edaff0ef          	jal	800013ea <uvmcopy>
    80001d14:	08054d63          	bltz	a0,80001dae <kfork+0xc6>
    80001d18:	f04a                	sd	s2,32(sp)
    80001d1a:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001d1c:	048ab783          	ld	a5,72(s5)
    80001d20:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001d24:	060ab683          	ld	a3,96(s5)
    80001d28:	87b6                	mv	a5,a3
    80001d2a:	0609b703          	ld	a4,96(s3)
    80001d2e:	12068693          	addi	a3,a3,288
    80001d32:	6388                	ld	a0,0(a5)
    80001d34:	678c                	ld	a1,8(a5)
    80001d36:	6b90                	ld	a2,16(a5)
    80001d38:	e308                	sd	a0,0(a4)
    80001d3a:	e70c                	sd	a1,8(a4)
    80001d3c:	eb10                	sd	a2,16(a4)
    80001d3e:	6f90                	ld	a2,24(a5)
    80001d40:	ef10                	sd	a2,24(a4)
    80001d42:	02078793          	addi	a5,a5,32
    80001d46:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001d4a:	fed794e3          	bne	a5,a3,80001d32 <kfork+0x4a>
if(p->shm_pa){
    80001d4e:	050ab683          	ld	a3,80(s5)
    80001d52:	c2b9                	beqz	a3,80001d98 <kfork+0xb0>
  if(mappages(np->pagetable, SHM_BASE, PGSIZE,
    80001d54:	4759                	li	a4,22
    80001d56:	6605                	lui	a2,0x1
    80001d58:	040005b7          	lui	a1,0x4000
    80001d5c:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001d5e:	05b2                	slli	a1,a1,0xc
    80001d60:	0589b503          	ld	a0,88(s3)
    80001d64:	ab2ff0ef          	jal	80001016 <mappages>
    80001d68:	ed21                	bnez	a0,80001dc0 <kfork+0xd8>
  np->shm_pa = p->shm_pa;
    80001d6a:	050ab783          	ld	a5,80(s5)
    80001d6e:	04f9b823          	sd	a5,80(s3)
  acquire(&shm_lock);
    80001d72:	00012517          	auipc	a0,0x12
    80001d76:	90e50513          	addi	a0,a0,-1778 # 80013680 <shm_lock>
    80001d7a:	e6ffe0ef          	jal	80000be8 <acquire>
  shm_refcnt++;
    80001d7e:	00009717          	auipc	a4,0x9
    80001d82:	7aa70713          	addi	a4,a4,1962 # 8000b528 <shm_refcnt>
    80001d86:	431c                	lw	a5,0(a4)
    80001d88:	2785                	addiw	a5,a5,1
    80001d8a:	c31c                	sw	a5,0(a4)
  release(&shm_lock);
    80001d8c:	00012517          	auipc	a0,0x12
    80001d90:	8f450513          	addi	a0,a0,-1804 # 80013680 <shm_lock>
    80001d94:	eddfe0ef          	jal	80000c70 <release>
  np->trapframe->a0 = 0;
    80001d98:	0609b783          	ld	a5,96(s3)
    80001d9c:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001da0:	0d8a8493          	addi	s1,s5,216
    80001da4:	0d898913          	addi	s2,s3,216
    80001da8:	158a8a13          	addi	s4,s5,344
    80001dac:	a80d                	j	80001dde <kfork+0xf6>
    freeproc(np);
    80001dae:	854e                	mv	a0,s3
    80001db0:	d59ff0ef          	jal	80001b08 <freeproc>
    release(&np->lock);
    80001db4:	854e                	mv	a0,s3
    80001db6:	ebbfe0ef          	jal	80000c70 <release>
    return -1;
    80001dba:	54fd                	li	s1,-1
    80001dbc:	69e2                	ld	s3,24(sp)
    80001dbe:	a059                	j	80001e44 <kfork+0x15c>
    freeproc(np);
    80001dc0:	854e                	mv	a0,s3
    80001dc2:	d47ff0ef          	jal	80001b08 <freeproc>
    release(&np->lock);
    80001dc6:	854e                	mv	a0,s3
    80001dc8:	ea9fe0ef          	jal	80000c70 <release>
    return -1;
    80001dcc:	54fd                	li	s1,-1
    80001dce:	7902                	ld	s2,32(sp)
    80001dd0:	69e2                	ld	s3,24(sp)
    80001dd2:	6a42                	ld	s4,16(sp)
    80001dd4:	a885                	j	80001e44 <kfork+0x15c>
  for (i = 0; i < NOFILE; i++)
    80001dd6:	04a1                	addi	s1,s1,8
    80001dd8:	0921                	addi	s2,s2,8
    80001dda:	01448963          	beq	s1,s4,80001dec <kfork+0x104>
    if (p->ofile[i])
    80001dde:	6088                	ld	a0,0(s1)
    80001de0:	d97d                	beqz	a0,80001dd6 <kfork+0xee>
      np->ofile[i] = filedup(p->ofile[i]);
    80001de2:	520020ef          	jal	80004302 <filedup>
    80001de6:	00a93023          	sd	a0,0(s2)
    80001dea:	b7f5                	j	80001dd6 <kfork+0xee>
  np->cwd = idup(p->cwd);
    80001dec:	158ab503          	ld	a0,344(s5)
    80001df0:	5fe010ef          	jal	800033ee <idup>
    80001df4:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001df8:	4641                	li	a2,16
    80001dfa:	160a8593          	addi	a1,s5,352
    80001dfe:	16098513          	addi	a0,s3,352
    80001e02:	ffbfe0ef          	jal	80000dfc <safestrcpy>
  pid = np->pid;
    80001e06:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80001e0a:	854e                	mv	a0,s3
    80001e0c:	e65fe0ef          	jal	80000c70 <release>
  acquire(&wait_lock);
    80001e10:	00012517          	auipc	a0,0x12
    80001e14:	85850513          	addi	a0,a0,-1960 # 80013668 <wait_lock>
    80001e18:	dd1fe0ef          	jal	80000be8 <acquire>
  np->parent = p;
    80001e1c:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001e20:	00012517          	auipc	a0,0x12
    80001e24:	84850513          	addi	a0,a0,-1976 # 80013668 <wait_lock>
    80001e28:	e49fe0ef          	jal	80000c70 <release>
  acquire(&np->lock);
    80001e2c:	854e                	mv	a0,s3
    80001e2e:	dbbfe0ef          	jal	80000be8 <acquire>
  np->state = RUNNABLE;
    80001e32:	478d                	li	a5,3
    80001e34:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001e38:	854e                	mv	a0,s3
    80001e3a:	e37fe0ef          	jal	80000c70 <release>
  return pid;
    80001e3e:	7902                	ld	s2,32(sp)
    80001e40:	69e2                	ld	s3,24(sp)
    80001e42:	6a42                	ld	s4,16(sp)
}
    80001e44:	8526                	mv	a0,s1
    80001e46:	70e2                	ld	ra,56(sp)
    80001e48:	7442                	ld	s0,48(sp)
    80001e4a:	74a2                	ld	s1,40(sp)
    80001e4c:	6aa2                	ld	s5,8(sp)
    80001e4e:	6121                	addi	sp,sp,64
    80001e50:	8082                	ret
    return -1;
    80001e52:	54fd                	li	s1,-1
    80001e54:	bfc5                	j	80001e44 <kfork+0x15c>

0000000080001e56 <scheduler>:
{
    80001e56:	711d                	addi	sp,sp,-96
    80001e58:	ec86                	sd	ra,88(sp)
    80001e5a:	e8a2                	sd	s0,80(sp)
    80001e5c:	e4a6                	sd	s1,72(sp)
    80001e5e:	e0ca                	sd	s2,64(sp)
    80001e60:	fc4e                	sd	s3,56(sp)
    80001e62:	f852                	sd	s4,48(sp)
    80001e64:	f456                	sd	s5,40(sp)
    80001e66:	f05a                	sd	s6,32(sp)
    80001e68:	ec5e                	sd	s7,24(sp)
    80001e6a:	e862                	sd	s8,16(sp)
    80001e6c:	e466                	sd	s9,8(sp)
    80001e6e:	1080                	addi	s0,sp,96
    80001e70:	8792                	mv	a5,tp
  int id = r_tp();
    80001e72:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001e74:	00779a93          	slli	s5,a5,0x7
    80001e78:	00011717          	auipc	a4,0x11
    80001e7c:	7d870713          	addi	a4,a4,2008 # 80013650 <pid_lock>
    80001e80:	9756                	add	a4,a4,s5
    80001e82:	04073423          	sd	zero,72(a4)
        swtch(&c->context, &p->context);
    80001e86:	00012717          	auipc	a4,0x12
    80001e8a:	81a70713          	addi	a4,a4,-2022 # 800136a0 <cpus+0x8>
    80001e8e:	9aba                	add	s5,s5,a4
        p->state = RUNNING;
    80001e90:	4c11                	li	s8,4
        c->proc = p;
    80001e92:	00011b17          	auipc	s6,0x11
    80001e96:	7beb0b13          	addi	s6,s6,1982 # 80013650 <pid_lock>
    80001e9a:	079e                	slli	a5,a5,0x7
    80001e9c:	00fb0a33          	add	s4,s6,a5
        found = 1;
    80001ea0:	4b85                	li	s7,1
    80001ea2:	a0a9                	j	80001eec <scheduler+0x96>
      release(&p->lock);
    80001ea4:	8526                	mv	a0,s1
    80001ea6:	dcbfe0ef          	jal	80000c70 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001eaa:	17048493          	addi	s1,s1,368
    80001eae:	03248b63          	beq	s1,s2,80001ee4 <scheduler+0x8e>
      acquire(&p->lock);
    80001eb2:	8526                	mv	a0,s1
    80001eb4:	d35fe0ef          	jal	80000be8 <acquire>
      if (p->state == RUNNABLE) {
    80001eb8:	4c9c                	lw	a5,24(s1)
    80001eba:	ff3795e3          	bne	a5,s3,80001ea4 <scheduler+0x4e>
        p->state = RUNNING;
    80001ebe:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001ec2:	049a3423          	sd	s1,72(s4)
        swtch(&c->context, &p->context);
    80001ec6:	06848593          	addi	a1,s1,104
    80001eca:	8556                	mv	a0,s5
    80001ecc:	5ee000ef          	jal	800024ba <swtch>
    80001ed0:	8792                	mv	a5,tp
        mycpu()->intena = 0;
    80001ed2:	2781                	sext.w	a5,a5
    80001ed4:	079e                	slli	a5,a5,0x7
    80001ed6:	97da                	add	a5,a5,s6
    80001ed8:	0c07a223          	sw	zero,196(a5)
        c->proc = 0;
    80001edc:	040a3423          	sd	zero,72(s4)
        found = 1;
    80001ee0:	8cde                	mv	s9,s7
    80001ee2:	b7c9                	j	80001ea4 <scheduler+0x4e>
    if (found == 0) {
    80001ee4:	000c9463          	bnez	s9,80001eec <scheduler+0x96>
      asm volatile("wfi");
    80001ee8:	10500073          	wfi
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80001eec:	10016073          	csrsi	sstatus,2
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80001ef0:	10017073          	csrci	sstatus,2
    int found = 0;
    80001ef4:	4c81                	li	s9,0
    for (p = proc; p < &proc[NPROC]; p++) {
    80001ef6:	00012497          	auipc	s1,0x12
    80001efa:	ba248493          	addi	s1,s1,-1118 # 80013a98 <proc>
      if (p->state == RUNNABLE) {
    80001efe:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80001f00:	00017917          	auipc	s2,0x17
    80001f04:	79890913          	addi	s2,s2,1944 # 80019698 <tickslock>
    80001f08:	b76d                	j	80001eb2 <scheduler+0x5c>

0000000080001f0a <sched>:
{
    80001f0a:	7179                	addi	sp,sp,-48
    80001f0c:	f406                	sd	ra,40(sp)
    80001f0e:	f022                	sd	s0,32(sp)
    80001f10:	ec26                	sd	s1,24(sp)
    80001f12:	e84a                	sd	s2,16(sp)
    80001f14:	e44e                	sd	s3,8(sp)
    80001f16:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f18:	a11ff0ef          	jal	80001928 <myproc>
    80001f1c:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001f1e:	c65fe0ef          	jal	80000b82 <holding>
    80001f22:	c935                	beqz	a0,80001f96 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r"(x));
    80001f24:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001f26:	2781                	sext.w	a5,a5
    80001f28:	079e                	slli	a5,a5,0x7
    80001f2a:	00011717          	auipc	a4,0x11
    80001f2e:	72670713          	addi	a4,a4,1830 # 80013650 <pid_lock>
    80001f32:	97ba                	add	a5,a5,a4
    80001f34:	0c07a703          	lw	a4,192(a5)
    80001f38:	4785                	li	a5,1
    80001f3a:	06f71463          	bne	a4,a5,80001fa2 <sched+0x98>
  if (p->state == RUNNING)
    80001f3e:	4c98                	lw	a4,24(s1)
    80001f40:	4791                	li	a5,4
    80001f42:	06f70663          	beq	a4,a5,80001fae <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001f46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f4a:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001f4c:	e7bd                	bnez	a5,80001fba <sched+0xb0>
  asm volatile("mv %0, tp" : "=r"(x));
    80001f4e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f50:	00011917          	auipc	s2,0x11
    80001f54:	70090913          	addi	s2,s2,1792 # 80013650 <pid_lock>
    80001f58:	2781                	sext.w	a5,a5
    80001f5a:	079e                	slli	a5,a5,0x7
    80001f5c:	97ca                	add	a5,a5,s2
    80001f5e:	0c47a983          	lw	s3,196(a5)
    80001f62:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001f64:	2781                	sext.w	a5,a5
    80001f66:	079e                	slli	a5,a5,0x7
    80001f68:	07a1                	addi	a5,a5,8
    80001f6a:	00011597          	auipc	a1,0x11
    80001f6e:	72e58593          	addi	a1,a1,1838 # 80013698 <cpus>
    80001f72:	95be                	add	a1,a1,a5
    80001f74:	06848513          	addi	a0,s1,104
    80001f78:	542000ef          	jal	800024ba <swtch>
    80001f7c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001f7e:	2781                	sext.w	a5,a5
    80001f80:	079e                	slli	a5,a5,0x7
    80001f82:	993e                	add	s2,s2,a5
    80001f84:	0d392223          	sw	s3,196(s2)
}
    80001f88:	70a2                	ld	ra,40(sp)
    80001f8a:	7402                	ld	s0,32(sp)
    80001f8c:	64e2                	ld	s1,24(sp)
    80001f8e:	6942                	ld	s2,16(sp)
    80001f90:	69a2                	ld	s3,8(sp)
    80001f92:	6145                	addi	sp,sp,48
    80001f94:	8082                	ret
    panic("sched p->lock");
    80001f96:	00006517          	auipc	a0,0x6
    80001f9a:	21250513          	addi	a0,a0,530 # 800081a8 <etext+0x1a8>
    80001f9e:	897fe0ef          	jal	80000834 <panic>
    panic("sched locks");
    80001fa2:	00006517          	auipc	a0,0x6
    80001fa6:	21650513          	addi	a0,a0,534 # 800081b8 <etext+0x1b8>
    80001faa:	88bfe0ef          	jal	80000834 <panic>
    panic("sched RUNNING");
    80001fae:	00006517          	auipc	a0,0x6
    80001fb2:	21a50513          	addi	a0,a0,538 # 800081c8 <etext+0x1c8>
    80001fb6:	87ffe0ef          	jal	80000834 <panic>
    panic("sched interruptible");
    80001fba:	00006517          	auipc	a0,0x6
    80001fbe:	21e50513          	addi	a0,a0,542 # 800081d8 <etext+0x1d8>
    80001fc2:	873fe0ef          	jal	80000834 <panic>

0000000080001fc6 <yield>:
{
    80001fc6:	1101                	addi	sp,sp,-32
    80001fc8:	ec06                	sd	ra,24(sp)
    80001fca:	e822                	sd	s0,16(sp)
    80001fcc:	e426                	sd	s1,8(sp)
    80001fce:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001fd0:	959ff0ef          	jal	80001928 <myproc>
    80001fd4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001fd6:	c13fe0ef          	jal	80000be8 <acquire>
  p->state = RUNNABLE;
    80001fda:	478d                	li	a5,3
    80001fdc:	cc9c                	sw	a5,24(s1)
  sched();
    80001fde:	f2dff0ef          	jal	80001f0a <sched>
  release(&p->lock);
    80001fe2:	8526                	mv	a0,s1
    80001fe4:	c8dfe0ef          	jal	80000c70 <release>
}
    80001fe8:	60e2                	ld	ra,24(sp)
    80001fea:	6442                	ld	s0,16(sp)
    80001fec:	64a2                	ld	s1,8(sp)
    80001fee:	6105                	addi	sp,sp,32
    80001ff0:	8082                	ret

0000000080001ff2 <sleep_prepare>:

// Register current process as waiting for wakeups on chan.
void
sleep_prepare(void *chan)
{
    80001ff2:	1101                	addi	sp,sp,-32
    80001ff4:	ec06                	sd	ra,24(sp)
    80001ff6:	e822                	sd	s0,16(sp)
    80001ff8:	e426                	sd	s1,8(sp)
    80001ffa:	e04a                	sd	s2,0(sp)
    80001ffc:	1000                	addi	s0,sp,32
    80001ffe:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002000:	929ff0ef          	jal	80001928 <myproc>
    80002004:	892a                	mv	s2,a0

  acquire(&p->lock);
    80002006:	be3fe0ef          	jal	80000be8 <acquire>
  if (chan == 0)
    8000200a:	cc81                	beqz	s1,80002022 <sleep_prepare+0x30>
    panic("sleep_prepare: zero chan");
  p->chan = chan;
    8000200c:	02993023          	sd	s1,32(s2)
  release(&p->lock);
    80002010:	854a                	mv	a0,s2
    80002012:	c5ffe0ef          	jal	80000c70 <release>
}
    80002016:	60e2                	ld	ra,24(sp)
    80002018:	6442                	ld	s0,16(sp)
    8000201a:	64a2                	ld	s1,8(sp)
    8000201c:	6902                	ld	s2,0(sp)
    8000201e:	6105                	addi	sp,sp,32
    80002020:	8082                	ret
    panic("sleep_prepare: zero chan");
    80002022:	00006517          	auipc	a0,0x6
    80002026:	1ce50513          	addi	a0,a0,462 # 800081f0 <etext+0x1f0>
    8000202a:	80bfe0ef          	jal	80000834 <panic>

000000008000202e <sleep>:
// Put the thread to sleep.  Assumes sleep_prepare() was called before.
// If the channel registered by sleep_prepare() has been woken up in
// the meantime, do not go to sleep, and instead return immediately.
void
sleep(void)
{
    8000202e:	1101                	addi	sp,sp,-32
    80002030:	ec06                	sd	ra,24(sp)
    80002032:	e822                	sd	s0,16(sp)
    80002034:	e426                	sd	s1,8(sp)
    80002036:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002038:	8f1ff0ef          	jal	80001928 <myproc>
    8000203c:	84aa                	mv	s1,a0

  acquire(&p->lock);
    8000203e:	babfe0ef          	jal	80000be8 <acquire>
  if (p->chan != 0) {
    80002042:	709c                	ld	a5,32(s1)
    80002044:	c789                	beqz	a5,8000204e <sleep+0x20>
    p->state = SLEEPING;
    80002046:	4789                	li	a5,2
    80002048:	cc9c                	sw	a5,24(s1)
    sched();
    8000204a:	ec1ff0ef          	jal	80001f0a <sched>
  }
  release(&p->lock);
    8000204e:	8526                	mv	a0,s1
    80002050:	c21fe0ef          	jal	80000c70 <release>
}
    80002054:	60e2                	ld	ra,24(sp)
    80002056:	6442                	ld	s0,16(sp)
    80002058:	64a2                	ld	s1,8(sp)
    8000205a:	6105                	addi	sp,sp,32
    8000205c:	8082                	ret

000000008000205e <wakeup>:

// Wake up all processes sleeping on channel chan.
void
wakeup(void *chan)
{
    8000205e:	7139                	addi	sp,sp,-64
    80002060:	fc06                	sd	ra,56(sp)
    80002062:	f822                	sd	s0,48(sp)
    80002064:	f426                	sd	s1,40(sp)
    80002066:	f04a                	sd	s2,32(sp)
    80002068:	ec4e                	sd	s3,24(sp)
    8000206a:	e852                	sd	s4,16(sp)
    8000206c:	e456                	sd	s5,8(sp)
    8000206e:	0080                	addi	s0,sp,64
    80002070:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80002072:	00012497          	auipc	s1,0x12
    80002076:	a2648493          	addi	s1,s1,-1498 # 80013a98 <proc>
      // signal that the wakeup happened by clearing p->chan.
      p->chan = 0;

      // If this waiting process has gotten so far as to actually
      // go to sleep, also set it back to RUNNING.
      if (p->state == SLEEPING) {
    8000207a:	4a09                	li	s4,2
        p->state = RUNNABLE;
    8000207c:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    8000207e:	00017997          	auipc	s3,0x17
    80002082:	61a98993          	addi	s3,s3,1562 # 80019698 <tickslock>
    80002086:	a801                	j	80002096 <wakeup+0x38>
      }
    }
    release(&p->lock);
    80002088:	8526                	mv	a0,s1
    8000208a:	be7fe0ef          	jal	80000c70 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000208e:	17048493          	addi	s1,s1,368
    80002092:	03348063          	beq	s1,s3,800020b2 <wakeup+0x54>
    acquire(&p->lock);
    80002096:	8526                	mv	a0,s1
    80002098:	b51fe0ef          	jal	80000be8 <acquire>
    if (p->chan == chan) {
    8000209c:	709c                	ld	a5,32(s1)
    8000209e:	ff2795e3          	bne	a5,s2,80002088 <wakeup+0x2a>
      p->chan = 0;
    800020a2:	0204b023          	sd	zero,32(s1)
      if (p->state == SLEEPING) {
    800020a6:	4c9c                	lw	a5,24(s1)
    800020a8:	ff4790e3          	bne	a5,s4,80002088 <wakeup+0x2a>
        p->state = RUNNABLE;
    800020ac:	0154ac23          	sw	s5,24(s1)
    800020b0:	bfe1                	j	80002088 <wakeup+0x2a>
  }
}
    800020b2:	70e2                	ld	ra,56(sp)
    800020b4:	7442                	ld	s0,48(sp)
    800020b6:	74a2                	ld	s1,40(sp)
    800020b8:	7902                	ld	s2,32(sp)
    800020ba:	69e2                	ld	s3,24(sp)
    800020bc:	6a42                	ld	s4,16(sp)
    800020be:	6aa2                	ld	s5,8(sp)
    800020c0:	6121                	addi	sp,sp,64
    800020c2:	8082                	ret

00000000800020c4 <reparent>:
{
    800020c4:	7179                	addi	sp,sp,-48
    800020c6:	f406                	sd	ra,40(sp)
    800020c8:	f022                	sd	s0,32(sp)
    800020ca:	ec26                	sd	s1,24(sp)
    800020cc:	e84a                	sd	s2,16(sp)
    800020ce:	e44e                	sd	s3,8(sp)
    800020d0:	e052                	sd	s4,0(sp)
    800020d2:	1800                	addi	s0,sp,48
    800020d4:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800020d6:	00012497          	auipc	s1,0x12
    800020da:	9c248493          	addi	s1,s1,-1598 # 80013a98 <proc>
      pp->parent = initproc;
    800020de:	00009a17          	auipc	s4,0x9
    800020e2:	452a0a13          	addi	s4,s4,1106 # 8000b530 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800020e6:	00017997          	auipc	s3,0x17
    800020ea:	5b298993          	addi	s3,s3,1458 # 80019698 <tickslock>
    800020ee:	a029                	j	800020f8 <reparent+0x34>
    800020f0:	17048493          	addi	s1,s1,368
    800020f4:	01348b63          	beq	s1,s3,8000210a <reparent+0x46>
    if (pp->parent == p) {
    800020f8:	7c9c                	ld	a5,56(s1)
    800020fa:	ff279be3          	bne	a5,s2,800020f0 <reparent+0x2c>
      pp->parent = initproc;
    800020fe:	000a3503          	ld	a0,0(s4)
    80002102:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002104:	f5bff0ef          	jal	8000205e <wakeup>
    80002108:	b7e5                	j	800020f0 <reparent+0x2c>
}
    8000210a:	70a2                	ld	ra,40(sp)
    8000210c:	7402                	ld	s0,32(sp)
    8000210e:	64e2                	ld	s1,24(sp)
    80002110:	6942                	ld	s2,16(sp)
    80002112:	69a2                	ld	s3,8(sp)
    80002114:	6a02                	ld	s4,0(sp)
    80002116:	6145                	addi	sp,sp,48
    80002118:	8082                	ret

000000008000211a <kexit>:
{
    8000211a:	7179                	addi	sp,sp,-48
    8000211c:	f406                	sd	ra,40(sp)
    8000211e:	f022                	sd	s0,32(sp)
    80002120:	ec26                	sd	s1,24(sp)
    80002122:	e84a                	sd	s2,16(sp)
    80002124:	e44e                	sd	s3,8(sp)
    80002126:	e052                	sd	s4,0(sp)
    80002128:	1800                	addi	s0,sp,48
    8000212a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000212c:	ffcff0ef          	jal	80001928 <myproc>
    80002130:	89aa                	mv	s3,a0
  if (p == initproc)
    80002132:	00009797          	auipc	a5,0x9
    80002136:	3fe7b783          	ld	a5,1022(a5) # 8000b530 <initproc>
    8000213a:	0d850493          	addi	s1,a0,216
    8000213e:	15850913          	addi	s2,a0,344
    80002142:	00a79b63          	bne	a5,a0,80002158 <kexit+0x3e>
    panic("init exiting");
    80002146:	00006517          	auipc	a0,0x6
    8000214a:	0ca50513          	addi	a0,a0,202 # 80008210 <etext+0x210>
    8000214e:	ee6fe0ef          	jal	80000834 <panic>
  for (int fd = 0; fd < NOFILE; fd++) {
    80002152:	04a1                	addi	s1,s1,8
    80002154:	01248963          	beq	s1,s2,80002166 <kexit+0x4c>
    if (p->ofile[fd]) {
    80002158:	6088                	ld	a0,0(s1)
    8000215a:	dd65                	beqz	a0,80002152 <kexit+0x38>
      fileclose(f);
    8000215c:	1ec020ef          	jal	80004348 <fileclose>
      p->ofile[fd] = 0;
    80002160:	0004b023          	sd	zero,0(s1)
    80002164:	b7fd                	j	80002152 <kexit+0x38>
  begin_op();
    80002166:	529010ef          	jal	80003e8e <begin_op>
  iput(p->cwd);
    8000216a:	1589b503          	ld	a0,344(s3)
    8000216e:	438010ef          	jal	800035a6 <iput>
  end_op();
    80002172:	5a9010ef          	jal	80003f1a <end_op>
  p->cwd = 0;
    80002176:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    8000217a:	00011517          	auipc	a0,0x11
    8000217e:	4ee50513          	addi	a0,a0,1262 # 80013668 <wait_lock>
    80002182:	a67fe0ef          	jal	80000be8 <acquire>
  reparent(p);
    80002186:	854e                	mv	a0,s3
    80002188:	f3dff0ef          	jal	800020c4 <reparent>
  wakeup(p->parent);
    8000218c:	0389b503          	ld	a0,56(s3)
    80002190:	ecfff0ef          	jal	8000205e <wakeup>
  acquire(&p->lock);
    80002194:	854e                	mv	a0,s3
    80002196:	a53fe0ef          	jal	80000be8 <acquire>
  p->xstate = status;
    8000219a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000219e:	4795                	li	a5,5
    800021a0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800021a4:	00011517          	auipc	a0,0x11
    800021a8:	4c450513          	addi	a0,a0,1220 # 80013668 <wait_lock>
    800021ac:	ac5fe0ef          	jal	80000c70 <release>
  sched();
    800021b0:	d5bff0ef          	jal	80001f0a <sched>
  panic("zombie exit");
    800021b4:	00006517          	auipc	a0,0x6
    800021b8:	06c50513          	addi	a0,a0,108 # 80008220 <etext+0x220>
    800021bc:	e78fe0ef          	jal	80000834 <panic>

00000000800021c0 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800021c0:	7179                	addi	sp,sp,-48
    800021c2:	f406                	sd	ra,40(sp)
    800021c4:	f022                	sd	s0,32(sp)
    800021c6:	ec26                	sd	s1,24(sp)
    800021c8:	e84a                	sd	s2,16(sp)
    800021ca:	e44e                	sd	s3,8(sp)
    800021cc:	1800                	addi	s0,sp,48
    800021ce:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800021d0:	00012497          	auipc	s1,0x12
    800021d4:	8c848493          	addi	s1,s1,-1848 # 80013a98 <proc>
    800021d8:	00017997          	auipc	s3,0x17
    800021dc:	4c098993          	addi	s3,s3,1216 # 80019698 <tickslock>
    acquire(&p->lock);
    800021e0:	8526                	mv	a0,s1
    800021e2:	a07fe0ef          	jal	80000be8 <acquire>
    if (p->pid == pid) {
    800021e6:	589c                	lw	a5,48(s1)
    800021e8:	01278b63          	beq	a5,s2,800021fe <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800021ec:	8526                	mv	a0,s1
    800021ee:	a83fe0ef          	jal	80000c70 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800021f2:	17048493          	addi	s1,s1,368
    800021f6:	ff3495e3          	bne	s1,s3,800021e0 <kkill+0x20>
  }
  return -1;
    800021fa:	557d                	li	a0,-1
    800021fc:	a819                	j	80002212 <kkill+0x52>
      p->killed = 1;
    800021fe:	4785                	li	a5,1
    80002200:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80002202:	4c98                	lw	a4,24(s1)
    80002204:	4789                	li	a5,2
    80002206:	00f70d63          	beq	a4,a5,80002220 <kkill+0x60>
      release(&p->lock);
    8000220a:	8526                	mv	a0,s1
    8000220c:	a65fe0ef          	jal	80000c70 <release>
      return 0;
    80002210:	4501                	li	a0,0
}
    80002212:	70a2                	ld	ra,40(sp)
    80002214:	7402                	ld	s0,32(sp)
    80002216:	64e2                	ld	s1,24(sp)
    80002218:	6942                	ld	s2,16(sp)
    8000221a:	69a2                	ld	s3,8(sp)
    8000221c:	6145                	addi	sp,sp,48
    8000221e:	8082                	ret
        p->state = RUNNABLE;
    80002220:	478d                	li	a5,3
    80002222:	cc9c                	sw	a5,24(s1)
    80002224:	b7dd                	j	8000220a <kkill+0x4a>

0000000080002226 <setkilled>:

void
setkilled(struct proc *p)
{
    80002226:	1101                	addi	sp,sp,-32
    80002228:	ec06                	sd	ra,24(sp)
    8000222a:	e822                	sd	s0,16(sp)
    8000222c:	e426                	sd	s1,8(sp)
    8000222e:	1000                	addi	s0,sp,32
    80002230:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002232:	9b7fe0ef          	jal	80000be8 <acquire>
  p->killed = 1;
    80002236:	4785                	li	a5,1
    80002238:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000223a:	8526                	mv	a0,s1
    8000223c:	a35fe0ef          	jal	80000c70 <release>
}
    80002240:	60e2                	ld	ra,24(sp)
    80002242:	6442                	ld	s0,16(sp)
    80002244:	64a2                	ld	s1,8(sp)
    80002246:	6105                	addi	sp,sp,32
    80002248:	8082                	ret

000000008000224a <killed>:

int
killed(struct proc *p)
{
    8000224a:	1101                	addi	sp,sp,-32
    8000224c:	ec06                	sd	ra,24(sp)
    8000224e:	e822                	sd	s0,16(sp)
    80002250:	e426                	sd	s1,8(sp)
    80002252:	e04a                	sd	s2,0(sp)
    80002254:	1000                	addi	s0,sp,32
    80002256:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002258:	991fe0ef          	jal	80000be8 <acquire>
  k = p->killed;
    8000225c:	549c                	lw	a5,40(s1)
    8000225e:	893e                	mv	s2,a5
  release(&p->lock);
    80002260:	8526                	mv	a0,s1
    80002262:	a0ffe0ef          	jal	80000c70 <release>
  return k;
}
    80002266:	854a                	mv	a0,s2
    80002268:	60e2                	ld	ra,24(sp)
    8000226a:	6442                	ld	s0,16(sp)
    8000226c:	64a2                	ld	s1,8(sp)
    8000226e:	6902                	ld	s2,0(sp)
    80002270:	6105                	addi	sp,sp,32
    80002272:	8082                	ret

0000000080002274 <kwait>:
{
    80002274:	715d                	addi	sp,sp,-80
    80002276:	e486                	sd	ra,72(sp)
    80002278:	e0a2                	sd	s0,64(sp)
    8000227a:	fc26                	sd	s1,56(sp)
    8000227c:	f84a                	sd	s2,48(sp)
    8000227e:	f44e                	sd	s3,40(sp)
    80002280:	f052                	sd	s4,32(sp)
    80002282:	ec56                	sd	s5,24(sp)
    80002284:	e85a                	sd	s6,16(sp)
    80002286:	e45e                	sd	s7,8(sp)
    80002288:	0880                	addi	s0,sp,80
    8000228a:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000228c:	e9cff0ef          	jal	80001928 <myproc>
    80002290:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002292:	00011517          	auipc	a0,0x11
    80002296:	3d650513          	addi	a0,a0,982 # 80013668 <wait_lock>
    8000229a:	94ffe0ef          	jal	80000be8 <acquire>
        if (pp->state == ZOMBIE) {
    8000229e:	4a15                	li	s4,5
        havekids = 1;
    800022a0:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800022a2:	00017997          	auipc	s3,0x17
    800022a6:	3f698993          	addi	s3,s3,1014 # 80019698 <tickslock>
    release(&wait_lock);
    800022aa:	00011b17          	auipc	s6,0x11
    800022ae:	3beb0b13          	addi	s6,s6,958 # 80013668 <wait_lock>
    800022b2:	a845                	j	80002362 <kwait+0xee>
          pid = pp->pid;
    800022b4:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    800022b8:	000b8e63          	beqz	s7,800022d4 <kwait+0x60>
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    800022bc:	4711                	li	a4,4
    800022be:	02c48693          	addi	a3,s1,44
    800022c2:	865e                	mv	a2,s7
    800022c4:	04893583          	ld	a1,72(s2)
    800022c8:	05893503          	ld	a0,88(s2)
    800022cc:	a7aff0ef          	jal	80001546 <copyout>
          if (addr != 0 &&
    800022d0:	02054c63          	bltz	a0,80002308 <kwait+0x94>
          pp->parent = 0;
    800022d4:	0204bc23          	sd	zero,56(s1)
          freeproc(pp);
    800022d8:	8526                	mv	a0,s1
    800022da:	82fff0ef          	jal	80001b08 <freeproc>
          release(&pp->lock);
    800022de:	8526                	mv	a0,s1
    800022e0:	991fe0ef          	jal	80000c70 <release>
          release(&wait_lock);
    800022e4:	00011517          	auipc	a0,0x11
    800022e8:	38450513          	addi	a0,a0,900 # 80013668 <wait_lock>
    800022ec:	985fe0ef          	jal	80000c70 <release>
}
    800022f0:	854e                	mv	a0,s3
    800022f2:	60a6                	ld	ra,72(sp)
    800022f4:	6406                	ld	s0,64(sp)
    800022f6:	74e2                	ld	s1,56(sp)
    800022f8:	7942                	ld	s2,48(sp)
    800022fa:	79a2                	ld	s3,40(sp)
    800022fc:	7a02                	ld	s4,32(sp)
    800022fe:	6ae2                	ld	s5,24(sp)
    80002300:	6b42                	ld	s6,16(sp)
    80002302:	6ba2                	ld	s7,8(sp)
    80002304:	6161                	addi	sp,sp,80
    80002306:	8082                	ret
            release(&pp->lock);
    80002308:	8526                	mv	a0,s1
    8000230a:	967fe0ef          	jal	80000c70 <release>
            release(&wait_lock);
    8000230e:	00011517          	auipc	a0,0x11
    80002312:	35a50513          	addi	a0,a0,858 # 80013668 <wait_lock>
    80002316:	95bfe0ef          	jal	80000c70 <release>
            return -1;
    8000231a:	59fd                	li	s3,-1
    8000231c:	bfd1                	j	800022f0 <kwait+0x7c>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000231e:	17048493          	addi	s1,s1,368
    80002322:	03348063          	beq	s1,s3,80002342 <kwait+0xce>
      if (pp->parent == p) {
    80002326:	7c9c                	ld	a5,56(s1)
    80002328:	ff279be3          	bne	a5,s2,8000231e <kwait+0xaa>
        acquire(&pp->lock);
    8000232c:	8526                	mv	a0,s1
    8000232e:	8bbfe0ef          	jal	80000be8 <acquire>
        if (pp->state == ZOMBIE) {
    80002332:	4c9c                	lw	a5,24(s1)
    80002334:	f94780e3          	beq	a5,s4,800022b4 <kwait+0x40>
        release(&pp->lock);
    80002338:	8526                	mv	a0,s1
    8000233a:	937fe0ef          	jal	80000c70 <release>
        havekids = 1;
    8000233e:	8756                	mv	a4,s5
    80002340:	bff9                	j	8000231e <kwait+0xaa>
    if (!havekids || killed(p)) {
    80002342:	c715                	beqz	a4,8000236e <kwait+0xfa>
    80002344:	854a                	mv	a0,s2
    80002346:	f05ff0ef          	jal	8000224a <killed>
    8000234a:	e115                	bnez	a0,8000236e <kwait+0xfa>
    sleep_prepare(p); //DOC: wait-sleep
    8000234c:	854a                	mv	a0,s2
    8000234e:	ca5ff0ef          	jal	80001ff2 <sleep_prepare>
    release(&wait_lock);
    80002352:	855a                	mv	a0,s6
    80002354:	91dfe0ef          	jal	80000c70 <release>
    sleep();
    80002358:	cd7ff0ef          	jal	8000202e <sleep>
    acquire(&wait_lock);
    8000235c:	855a                	mv	a0,s6
    8000235e:	88bfe0ef          	jal	80000be8 <acquire>
    havekids = 0;
    80002362:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002364:	00011497          	auipc	s1,0x11
    80002368:	73448493          	addi	s1,s1,1844 # 80013a98 <proc>
    8000236c:	bf6d                	j	80002326 <kwait+0xb2>
      release(&wait_lock);
    8000236e:	00011517          	auipc	a0,0x11
    80002372:	2fa50513          	addi	a0,a0,762 # 80013668 <wait_lock>
    80002376:	8fbfe0ef          	jal	80000c70 <release>
      return -1;
    8000237a:	59fd                	li	s3,-1
    8000237c:	bf95                	j	800022f0 <kwait+0x7c>

000000008000237e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000237e:	7179                	addi	sp,sp,-48
    80002380:	f406                	sd	ra,40(sp)
    80002382:	f022                	sd	s0,32(sp)
    80002384:	ec26                	sd	s1,24(sp)
    80002386:	e84a                	sd	s2,16(sp)
    80002388:	e44e                	sd	s3,8(sp)
    8000238a:	e052                	sd	s4,0(sp)
    8000238c:	1800                	addi	s0,sp,48
    8000238e:	84aa                	mv	s1,a0
    80002390:	8a2e                	mv	s4,a1
    80002392:	89b2                	mv	s3,a2
    80002394:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002396:	d92ff0ef          	jal	80001928 <myproc>
  if (user_dst) {
    8000239a:	c085                	beqz	s1,800023ba <either_copyout+0x3c>
    return copyout(p->pagetable, p->sz, dst, src, len);
    8000239c:	874a                	mv	a4,s2
    8000239e:	86ce                	mv	a3,s3
    800023a0:	8652                	mv	a2,s4
    800023a2:	652c                	ld	a1,72(a0)
    800023a4:	6d28                	ld	a0,88(a0)
    800023a6:	9a0ff0ef          	jal	80001546 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800023aa:	70a2                	ld	ra,40(sp)
    800023ac:	7402                	ld	s0,32(sp)
    800023ae:	64e2                	ld	s1,24(sp)
    800023b0:	6942                	ld	s2,16(sp)
    800023b2:	69a2                	ld	s3,8(sp)
    800023b4:	6a02                	ld	s4,0(sp)
    800023b6:	6145                	addi	sp,sp,48
    800023b8:	8082                	ret
    memmove((char *)dst, src, len);
    800023ba:	0009061b          	sext.w	a2,s2
    800023be:	85ce                	mv	a1,s3
    800023c0:	8552                	mv	a0,s4
    800023c2:	947fe0ef          	jal	80000d08 <memmove>
    return 0;
    800023c6:	8526                	mv	a0,s1
    800023c8:	b7cd                	j	800023aa <either_copyout+0x2c>

00000000800023ca <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800023ca:	7179                	addi	sp,sp,-48
    800023cc:	f406                	sd	ra,40(sp)
    800023ce:	f022                	sd	s0,32(sp)
    800023d0:	ec26                	sd	s1,24(sp)
    800023d2:	e84a                	sd	s2,16(sp)
    800023d4:	e44e                	sd	s3,8(sp)
    800023d6:	e052                	sd	s4,0(sp)
    800023d8:	1800                	addi	s0,sp,48
    800023da:	8a2a                	mv	s4,a0
    800023dc:	84ae                	mv	s1,a1
    800023de:	89b2                	mv	s3,a2
    800023e0:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800023e2:	d46ff0ef          	jal	80001928 <myproc>
  if (user_src) {
    800023e6:	c085                	beqz	s1,80002406 <either_copyin+0x3c>
    return copyin(p->pagetable, p->sz, dst, src, len);
    800023e8:	874a                	mv	a4,s2
    800023ea:	86ce                	mv	a3,s3
    800023ec:	8652                	mv	a2,s4
    800023ee:	652c                	ld	a1,72(a0)
    800023f0:	6d28                	ld	a0,88(a0)
    800023f2:	a1aff0ef          	jal	8000160c <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800023f6:	70a2                	ld	ra,40(sp)
    800023f8:	7402                	ld	s0,32(sp)
    800023fa:	64e2                	ld	s1,24(sp)
    800023fc:	6942                	ld	s2,16(sp)
    800023fe:	69a2                	ld	s3,8(sp)
    80002400:	6a02                	ld	s4,0(sp)
    80002402:	6145                	addi	sp,sp,48
    80002404:	8082                	ret
    memmove(dst, (char *)src, len);
    80002406:	0009061b          	sext.w	a2,s2
    8000240a:	85ce                	mv	a1,s3
    8000240c:	8552                	mv	a0,s4
    8000240e:	8fbfe0ef          	jal	80000d08 <memmove>
    return 0;
    80002412:	8526                	mv	a0,s1
    80002414:	b7cd                	j	800023f6 <either_copyin+0x2c>

0000000080002416 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002416:	715d                	addi	sp,sp,-80
    80002418:	e486                	sd	ra,72(sp)
    8000241a:	e0a2                	sd	s0,64(sp)
    8000241c:	fc26                	sd	s1,56(sp)
    8000241e:	f84a                	sd	s2,48(sp)
    80002420:	f44e                	sd	s3,40(sp)
    80002422:	f052                	sd	s4,32(sp)
    80002424:	ec56                	sd	s5,24(sp)
    80002426:	e85a                	sd	s6,16(sp)
    80002428:	e45e                	sd	s7,8(sp)
    8000242a:	0880                	addi	s0,sp,80
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    8000242c:	00006517          	auipc	a0,0x6
    80002430:	c4c50513          	addi	a0,a0,-948 # 80008078 <etext+0x78>
    80002434:	8d6fe0ef          	jal	8000050a <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002438:	00011497          	auipc	s1,0x11
    8000243c:	7c048493          	addi	s1,s1,1984 # 80013bf8 <proc+0x160>
    80002440:	00017917          	auipc	s2,0x17
    80002444:	3b890913          	addi	s2,s2,952 # 800197f8 <bcache+0x148>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002448:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000244a:	00006997          	auipc	s3,0x6
    8000244e:	de698993          	addi	s3,s3,-538 # 80008230 <etext+0x230>
    printk("%d %s %s", p->pid, state, p->name);
    80002452:	00006a97          	auipc	s5,0x6
    80002456:	de6a8a93          	addi	s5,s5,-538 # 80008238 <etext+0x238>
    printk("\n");
    8000245a:	00006a17          	auipc	s4,0x6
    8000245e:	c1ea0a13          	addi	s4,s4,-994 # 80008078 <etext+0x78>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002462:	00006b97          	auipc	s7,0x6
    80002466:	316b8b93          	addi	s7,s7,790 # 80008778 <states.0>
    8000246a:	a829                	j	80002484 <procdump+0x6e>
    printk("%d %s %s", p->pid, state, p->name);
    8000246c:	ed06a583          	lw	a1,-304(a3)
    80002470:	8556                	mv	a0,s5
    80002472:	898fe0ef          	jal	8000050a <printk>
    printk("\n");
    80002476:	8552                	mv	a0,s4
    80002478:	892fe0ef          	jal	8000050a <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000247c:	17048493          	addi	s1,s1,368
    80002480:	03248263          	beq	s1,s2,800024a4 <procdump+0x8e>
    if (p->state == UNUSED)
    80002484:	86a6                	mv	a3,s1
    80002486:	eb84a783          	lw	a5,-328(s1)
    8000248a:	dbed                	beqz	a5,8000247c <procdump+0x66>
      state = "???";
    8000248c:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000248e:	fcfb6fe3          	bltu	s6,a5,8000246c <procdump+0x56>
    80002492:	02079713          	slli	a4,a5,0x20
    80002496:	01d75793          	srli	a5,a4,0x1d
    8000249a:	97de                	add	a5,a5,s7
    8000249c:	6390                	ld	a2,0(a5)
    8000249e:	f679                	bnez	a2,8000246c <procdump+0x56>
      state = "???";
    800024a0:	864e                	mv	a2,s3
    800024a2:	b7e9                	j	8000246c <procdump+0x56>
  }
}
    800024a4:	60a6                	ld	ra,72(sp)
    800024a6:	6406                	ld	s0,64(sp)
    800024a8:	74e2                	ld	s1,56(sp)
    800024aa:	7942                	ld	s2,48(sp)
    800024ac:	79a2                	ld	s3,40(sp)
    800024ae:	7a02                	ld	s4,32(sp)
    800024b0:	6ae2                	ld	s5,24(sp)
    800024b2:	6b42                	ld	s6,16(sp)
    800024b4:	6ba2                	ld	s7,8(sp)
    800024b6:	6161                	addi	sp,sp,80
    800024b8:	8082                	ret

00000000800024ba <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800024ba:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800024be:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800024c2:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800024c4:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800024c6:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800024ca:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800024ce:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800024d2:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800024d6:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800024da:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800024de:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800024e2:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800024e6:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800024ea:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800024ee:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800024f2:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800024f6:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800024f8:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800024fa:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800024fe:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002502:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002506:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000250a:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000250e:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002512:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002516:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000251a:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000251e:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002522:	8082                	ret

0000000080002524 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002524:	1141                	addi	sp,sp,-16
    80002526:	e406                	sd	ra,8(sp)
    80002528:	e022                	sd	s0,0(sp)
    8000252a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000252c:	00006597          	auipc	a1,0x6
    80002530:	d4c58593          	addi	a1,a1,-692 # 80008278 <etext+0x278>
    80002534:	00017517          	auipc	a0,0x17
    80002538:	16450513          	addi	a0,a0,356 # 80019698 <tickslock>
    8000253c:	e2cfe0ef          	jal	80000b68 <initlock>
}
    80002540:	60a2                	ld	ra,8(sp)
    80002542:	6402                	ld	s0,0(sp)
    80002544:	0141                	addi	sp,sp,16
    80002546:	8082                	ret

0000000080002548 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002548:	1141                	addi	sp,sp,-16
    8000254a:	e406                	sd	ra,8(sp)
    8000254c:	e022                	sd	s0,0(sp)
    8000254e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002550:	00003797          	auipc	a5,0x3
    80002554:	26078793          	addi	a5,a5,608 # 800057b0 <kernelvec>
    80002558:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000255c:	60a2                	ld	ra,8(sp)
    8000255e:	6402                	ld	s0,0(sp)
    80002560:	0141                	addi	sp,sp,16
    80002562:	8082                	ret

0000000080002564 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002564:	1141                	addi	sp,sp,-16
    80002566:	e406                	sd	ra,8(sp)
    80002568:	e022                	sd	s0,0(sp)
    8000256a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000256c:	bbcff0ef          	jal	80001928 <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80002570:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002574:	04000737          	lui	a4,0x4000
    80002578:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    8000257a:	0732                	slli	a4,a4,0xc
    8000257c:	00005797          	auipc	a5,0x5
    80002580:	a8478793          	addi	a5,a5,-1404 # 80007000 <_trampoline>
    80002584:	00005697          	auipc	a3,0x5
    80002588:	a7c68693          	addi	a3,a3,-1412 # 80007000 <_trampoline>
    8000258c:	8f95                	sub	a5,a5,a3
    8000258e:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002590:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002594:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002596:	18002773          	csrr	a4,satp
    8000259a:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000259c:	7138                	ld	a4,96(a0)
    8000259e:	613c                	ld	a5,64(a0)
    800025a0:	6685                	lui	a3,0x1
    800025a2:	97b6                	add	a5,a5,a3
    800025a4:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800025a6:	713c                	ld	a5,96(a0)
    800025a8:	00000717          	auipc	a4,0x0
    800025ac:	0fc70713          	addi	a4,a4,252 # 800026a4 <usertrap>
    800025b0:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    800025b2:	713c                	ld	a5,96(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    800025b4:	8712                	mv	a4,tp
    800025b6:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800025b8:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800025bc:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800025c0:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800025c4:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800025c8:	713c                	ld	a5,96(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    800025ca:	6f9c                	ld	a5,24(a5)
    800025cc:	14179073          	csrw	sepc,a5
}
    800025d0:	60a2                	ld	ra,8(sp)
    800025d2:	6402                	ld	s0,0(sp)
    800025d4:	0141                	addi	sp,sp,16
    800025d6:	8082                	ret

00000000800025d8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800025d8:	1141                	addi	sp,sp,-16
    800025da:	e406                	sd	ra,8(sp)
    800025dc:	e022                	sd	s0,0(sp)
    800025de:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    800025e0:	b14ff0ef          	jal	800018f4 <cpuid>
    800025e4:	cd11                	beqz	a0,80002600 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    800025e6:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800025ea:	000f4737          	lui	a4,0xf4
    800025ee:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800025f2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    800025f4:	14d79073          	csrw	stimecmp,a5
}
    800025f8:	60a2                	ld	ra,8(sp)
    800025fa:	6402                	ld	s0,0(sp)
    800025fc:	0141                	addi	sp,sp,16
    800025fe:	8082                	ret
    acquire(&tickslock);
    80002600:	00017517          	auipc	a0,0x17
    80002604:	09850513          	addi	a0,a0,152 # 80019698 <tickslock>
    80002608:	de0fe0ef          	jal	80000be8 <acquire>
    ticks++;
    8000260c:	00009717          	auipc	a4,0x9
    80002610:	f2c70713          	addi	a4,a4,-212 # 8000b538 <ticks>
    80002614:	431c                	lw	a5,0(a4)
    80002616:	2785                	addiw	a5,a5,1
    80002618:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    8000261a:	853a                	mv	a0,a4
    8000261c:	a43ff0ef          	jal	8000205e <wakeup>
    release(&tickslock);
    80002620:	00017517          	auipc	a0,0x17
    80002624:	07850513          	addi	a0,a0,120 # 80019698 <tickslock>
    80002628:	e48fe0ef          	jal	80000c70 <release>
    8000262c:	bf6d                	j	800025e6 <clockintr+0xe>

000000008000262e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000262e:	1101                	addi	sp,sp,-32
    80002630:	ec06                	sd	ra,24(sp)
    80002632:	e822                	sd	s0,16(sp)
    80002634:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002636:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    8000263a:	57fd                	li	a5,-1
    8000263c:	17fe                	slli	a5,a5,0x3f
    8000263e:	07a5                	addi	a5,a5,9
    80002640:	00f70c63          	beq	a4,a5,80002658 <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    80002644:	57fd                	li	a5,-1
    80002646:	17fe                	slli	a5,a5,0x3f
    80002648:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000264a:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    8000264c:	04f70863          	beq	a4,a5,8000269c <devintr+0x6e>
  }
}
    80002650:	60e2                	ld	ra,24(sp)
    80002652:	6442                	ld	s0,16(sp)
    80002654:	6105                	addi	sp,sp,32
    80002656:	8082                	ret
    80002658:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000265a:	202030ef          	jal	8000585c <plic_claim>
    8000265e:	872a                	mv	a4,a0
    80002660:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002662:	47a9                	li	a5,10
    80002664:	00f50963          	beq	a0,a5,80002676 <devintr+0x48>
    } else if (irq == VIRTIO0_IRQ) {
    80002668:	4785                	li	a5,1
    8000266a:	00f50963          	beq	a0,a5,8000267c <devintr+0x4e>
    return 1;
    8000266e:	4505                	li	a0,1
    } else if (irq) {
    80002670:	eb09                	bnez	a4,80002682 <devintr+0x54>
    80002672:	64a2                	ld	s1,8(sp)
    80002674:	bff1                	j	80002650 <devintr+0x22>
      uartintr();
    80002676:	b58fe0ef          	jal	800009ce <uartintr>
    if (irq)
    8000267a:	a819                	j	80002690 <devintr+0x62>
      virtio_disk_intr();
    8000267c:	698030ef          	jal	80005d14 <virtio_disk_intr>
    if (irq)
    80002680:	a801                	j	80002690 <devintr+0x62>
      printk("unexpected interrupt irq=%d\n", irq);
    80002682:	85ba                	mv	a1,a4
    80002684:	00006517          	auipc	a0,0x6
    80002688:	bfc50513          	addi	a0,a0,-1028 # 80008280 <etext+0x280>
    8000268c:	e7ffd0ef          	jal	8000050a <printk>
      plic_complete(irq);
    80002690:	8526                	mv	a0,s1
    80002692:	1ea030ef          	jal	8000587c <plic_complete>
    return 1;
    80002696:	4505                	li	a0,1
    80002698:	64a2                	ld	s1,8(sp)
    8000269a:	bf5d                	j	80002650 <devintr+0x22>
    clockintr();
    8000269c:	f3dff0ef          	jal	800025d8 <clockintr>
    return 2;
    800026a0:	4509                	li	a0,2
    800026a2:	b77d                	j	80002650 <devintr+0x22>

00000000800026a4 <usertrap>:
{
    800026a4:	1101                	addi	sp,sp,-32
    800026a6:	ec06                	sd	ra,24(sp)
    800026a8:	e822                	sd	s0,16(sp)
    800026aa:	e426                	sd	s1,8(sp)
    800026ac:	e04a                	sd	s2,0(sp)
    800026ae:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026b0:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    800026b4:	1007f793          	andi	a5,a5,256
    800026b8:	eba5                	bnez	a5,80002728 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    800026ba:	00003797          	auipc	a5,0x3
    800026be:	0f678793          	addi	a5,a5,246 # 800057b0 <kernelvec>
    800026c2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800026c6:	a62ff0ef          	jal	80001928 <myproc>
    800026ca:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800026cc:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    800026ce:	14102773          	csrr	a4,sepc
    800026d2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    800026d4:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    800026d8:	47a1                	li	a5,8
    800026da:	04f70d63          	beq	a4,a5,80002734 <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    800026de:	f51ff0ef          	jal	8000262e <devintr>
    800026e2:	892a                	mv	s2,a0
    800026e4:	e54d                	bnez	a0,8000278e <usertrap+0xea>
    800026e6:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    800026ea:	47bd                	li	a5,15
    800026ec:	08f70463          	beq	a4,a5,80002774 <usertrap+0xd0>
    800026f0:	14202773          	csrr	a4,scause
    800026f4:	47b5                	li	a5,13
    800026f6:	06f70f63          	beq	a4,a5,80002774 <usertrap+0xd0>
    800026fa:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800026fe:	5890                	lw	a2,48(s1)
    80002700:	00006517          	auipc	a0,0x6
    80002704:	bc050513          	addi	a0,a0,-1088 # 800082c0 <etext+0x2c0>
    80002708:	e03fd0ef          	jal	8000050a <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000270c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002710:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002714:	00006517          	auipc	a0,0x6
    80002718:	bdc50513          	addi	a0,a0,-1060 # 800082f0 <etext+0x2f0>
    8000271c:	deffd0ef          	jal	8000050a <printk>
    setkilled(p);
    80002720:	8526                	mv	a0,s1
    80002722:	b05ff0ef          	jal	80002226 <setkilled>
    80002726:	a015                	j	8000274a <usertrap+0xa6>
    panic("usertrap: not from user mode");
    80002728:	00006517          	auipc	a0,0x6
    8000272c:	b7850513          	addi	a0,a0,-1160 # 800082a0 <etext+0x2a0>
    80002730:	904fe0ef          	jal	80000834 <panic>
    if (killed(p))
    80002734:	b17ff0ef          	jal	8000224a <killed>
    80002738:	e915                	bnez	a0,8000276c <usertrap+0xc8>
    p->trapframe->epc += 4;
    8000273a:	70b8                	ld	a4,96(s1)
    8000273c:	6f1c                	ld	a5,24(a4)
    8000273e:	0791                	addi	a5,a5,4
    80002740:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80002742:	10016073          	csrsi	sstatus,2
    syscall();
    80002746:	244000ef          	jal	8000298a <syscall>
  if (killed(p))
    8000274a:	8526                	mv	a0,s1
    8000274c:	affff0ef          	jal	8000224a <killed>
    80002750:	e521                	bnez	a0,80002798 <usertrap+0xf4>
  prepare_return();
    80002752:	e13ff0ef          	jal	80002564 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002756:	6ca8                	ld	a0,88(s1)
    80002758:	8131                	srli	a0,a0,0xc
    8000275a:	57fd                	li	a5,-1
    8000275c:	17fe                	slli	a5,a5,0x3f
    8000275e:	8d5d                	or	a0,a0,a5
}
    80002760:	60e2                	ld	ra,24(sp)
    80002762:	6442                	ld	s0,16(sp)
    80002764:	64a2                	ld	s1,8(sp)
    80002766:	6902                	ld	s2,0(sp)
    80002768:	6105                	addi	sp,sp,32
    8000276a:	8082                	ret
      kexit(-1);
    8000276c:	557d                	li	a0,-1
    8000276e:	9adff0ef          	jal	8000211a <kexit>
    80002772:	b7e1                	j	8000273a <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002774:	14302673          	csrr	a2,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    80002778:	142026f3          	csrr	a3,scause
             vmfault(p->pagetable, p->sz, r_stval(),
    8000277c:	16cd                	addi	a3,a3,-13 # ff3 <_entry-0x7ffff00d>
    8000277e:	0016b693          	seqz	a3,a3
    80002782:	64ac                	ld	a1,72(s1)
    80002784:	6ca8                	ld	a0,88(s1)
    80002786:	d45fe0ef          	jal	800014ca <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    8000278a:	f161                	bnez	a0,8000274a <usertrap+0xa6>
    8000278c:	b7bd                	j	800026fa <usertrap+0x56>
  if (killed(p))
    8000278e:	8526                	mv	a0,s1
    80002790:	abbff0ef          	jal	8000224a <killed>
    80002794:	c511                	beqz	a0,800027a0 <usertrap+0xfc>
    80002796:	a011                	j	8000279a <usertrap+0xf6>
    80002798:	4901                	li	s2,0
    kexit(-1);
    8000279a:	557d                	li	a0,-1
    8000279c:	97fff0ef          	jal	8000211a <kexit>
  if (which_dev == 2)
    800027a0:	4789                	li	a5,2
    800027a2:	faf918e3          	bne	s2,a5,80002752 <usertrap+0xae>
    yield();
    800027a6:	821ff0ef          	jal	80001fc6 <yield>
    800027aa:	b765                	j	80002752 <usertrap+0xae>

00000000800027ac <kerneltrap>:
{
    800027ac:	7179                	addi	sp,sp,-48
    800027ae:	f406                	sd	ra,40(sp)
    800027b0:	f022                	sd	s0,32(sp)
    800027b2:	ec26                	sd	s1,24(sp)
    800027b4:	e84a                	sd	s2,16(sp)
    800027b6:	e44e                	sd	s3,8(sp)
    800027b8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    800027ba:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800027be:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    800027c2:	142027f3          	csrr	a5,scause
    800027c6:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    800027c8:	1004f793          	andi	a5,s1,256
    800027cc:	c795                	beqz	a5,800027f8 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800027ce:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800027d2:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    800027d4:	eb85                	bnez	a5,80002804 <kerneltrap+0x58>
  if ((which_dev = devintr()) == 0) {
    800027d6:	e59ff0ef          	jal	8000262e <devintr>
    800027da:	c91d                	beqz	a0,80002810 <kerneltrap+0x64>
  if (which_dev == 2 && myproc() != 0)
    800027dc:	4789                	li	a5,2
    800027de:	04f50a63          	beq	a0,a5,80002832 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r"(x));
    800027e2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800027e6:	10049073          	csrw	sstatus,s1
}
    800027ea:	70a2                	ld	ra,40(sp)
    800027ec:	7402                	ld	s0,32(sp)
    800027ee:	64e2                	ld	s1,24(sp)
    800027f0:	6942                	ld	s2,16(sp)
    800027f2:	69a2                	ld	s3,8(sp)
    800027f4:	6145                	addi	sp,sp,48
    800027f6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800027f8:	00006517          	auipc	a0,0x6
    800027fc:	b2050513          	addi	a0,a0,-1248 # 80008318 <etext+0x318>
    80002800:	834fe0ef          	jal	80000834 <panic>
    panic("kerneltrap: interrupts enabled");
    80002804:	00006517          	auipc	a0,0x6
    80002808:	b3c50513          	addi	a0,a0,-1220 # 80008340 <etext+0x340>
    8000280c:	828fe0ef          	jal	80000834 <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002810:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002814:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    80002818:	85ce                	mv	a1,s3
    8000281a:	00006517          	auipc	a0,0x6
    8000281e:	b4650513          	addi	a0,a0,-1210 # 80008360 <etext+0x360>
    80002822:	ce9fd0ef          	jal	8000050a <printk>
    panic("kerneltrap");
    80002826:	00006517          	auipc	a0,0x6
    8000282a:	b6250513          	addi	a0,a0,-1182 # 80008388 <etext+0x388>
    8000282e:	806fe0ef          	jal	80000834 <panic>
  if (which_dev == 2 && myproc() != 0)
    80002832:	8f6ff0ef          	jal	80001928 <myproc>
    80002836:	d555                	beqz	a0,800027e2 <kerneltrap+0x36>
    yield();
    80002838:	f8eff0ef          	jal	80001fc6 <yield>
    8000283c:	b75d                	j	800027e2 <kerneltrap+0x36>

000000008000283e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000283e:	1101                	addi	sp,sp,-32
    80002840:	ec06                	sd	ra,24(sp)
    80002842:	e822                	sd	s0,16(sp)
    80002844:	e426                	sd	s1,8(sp)
    80002846:	1000                	addi	s0,sp,32
    80002848:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000284a:	8deff0ef          	jal	80001928 <myproc>
  switch (n) {
    8000284e:	4795                	li	a5,5
    80002850:	0497e163          	bltu	a5,s1,80002892 <argraw+0x54>
    80002854:	048a                	slli	s1,s1,0x2
    80002856:	00006717          	auipc	a4,0x6
    8000285a:	f5270713          	addi	a4,a4,-174 # 800087a8 <states.0+0x30>
    8000285e:	94ba                	add	s1,s1,a4
    80002860:	409c                	lw	a5,0(s1)
    80002862:	97ba                	add	a5,a5,a4
    80002864:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002866:	713c                	ld	a5,96(a0)
    80002868:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000286a:	60e2                	ld	ra,24(sp)
    8000286c:	6442                	ld	s0,16(sp)
    8000286e:	64a2                	ld	s1,8(sp)
    80002870:	6105                	addi	sp,sp,32
    80002872:	8082                	ret
    return p->trapframe->a1;
    80002874:	713c                	ld	a5,96(a0)
    80002876:	7fa8                	ld	a0,120(a5)
    80002878:	bfcd                	j	8000286a <argraw+0x2c>
    return p->trapframe->a2;
    8000287a:	713c                	ld	a5,96(a0)
    8000287c:	63c8                	ld	a0,128(a5)
    8000287e:	b7f5                	j	8000286a <argraw+0x2c>
    return p->trapframe->a3;
    80002880:	713c                	ld	a5,96(a0)
    80002882:	67c8                	ld	a0,136(a5)
    80002884:	b7dd                	j	8000286a <argraw+0x2c>
    return p->trapframe->a4;
    80002886:	713c                	ld	a5,96(a0)
    80002888:	6bc8                	ld	a0,144(a5)
    8000288a:	b7c5                	j	8000286a <argraw+0x2c>
    return p->trapframe->a5;
    8000288c:	713c                	ld	a5,96(a0)
    8000288e:	6fc8                	ld	a0,152(a5)
    80002890:	bfe9                	j	8000286a <argraw+0x2c>
  panic("argraw");
    80002892:	00006517          	auipc	a0,0x6
    80002896:	b0650513          	addi	a0,a0,-1274 # 80008398 <etext+0x398>
    8000289a:	f9bfd0ef          	jal	80000834 <panic>

000000008000289e <fetchaddr>:
{
    8000289e:	1101                	addi	sp,sp,-32
    800028a0:	ec06                	sd	ra,24(sp)
    800028a2:	e822                	sd	s0,16(sp)
    800028a4:	e426                	sd	s1,8(sp)
    800028a6:	e04a                	sd	s2,0(sp)
    800028a8:	1000                	addi	s0,sp,32
    800028aa:	84aa                	mv	s1,a0
    800028ac:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800028ae:	87aff0ef          	jal	80001928 <myproc>
  if (addr >= p->sz ||
    800028b2:	652c                	ld	a1,72(a0)
    800028b4:	02b4f663          	bgeu	s1,a1,800028e0 <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800028b8:	00848793          	addi	a5,s1,8
  if (addr >= p->sz ||
    800028bc:	02f5e463          	bltu	a1,a5,800028e4 <fetchaddr+0x46>
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    800028c0:	4721                	li	a4,8
    800028c2:	86a6                	mv	a3,s1
    800028c4:	864a                	mv	a2,s2
    800028c6:	6d28                	ld	a0,88(a0)
    800028c8:	d45fe0ef          	jal	8000160c <copyin>
    800028cc:	00a03533          	snez	a0,a0
    800028d0:	40a0053b          	negw	a0,a0
}
    800028d4:	60e2                	ld	ra,24(sp)
    800028d6:	6442                	ld	s0,16(sp)
    800028d8:	64a2                	ld	s1,8(sp)
    800028da:	6902                	ld	s2,0(sp)
    800028dc:	6105                	addi	sp,sp,32
    800028de:	8082                	ret
    return -1;
    800028e0:	557d                	li	a0,-1
    800028e2:	bfcd                	j	800028d4 <fetchaddr+0x36>
    800028e4:	557d                	li	a0,-1
    800028e6:	b7fd                	j	800028d4 <fetchaddr+0x36>

00000000800028e8 <fetchstr>:
{
    800028e8:	7179                	addi	sp,sp,-48
    800028ea:	f406                	sd	ra,40(sp)
    800028ec:	f022                	sd	s0,32(sp)
    800028ee:	ec26                	sd	s1,24(sp)
    800028f0:	e84a                	sd	s2,16(sp)
    800028f2:	e44e                	sd	s3,8(sp)
    800028f4:	1800                	addi	s0,sp,48
    800028f6:	89aa                	mv	s3,a0
    800028f8:	84ae                	mv	s1,a1
    800028fa:	8932                	mv	s2,a2
  struct proc *p = myproc();
    800028fc:	82cff0ef          	jal	80001928 <myproc>
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    80002900:	874a                	mv	a4,s2
    80002902:	86ce                	mv	a3,s3
    80002904:	8626                	mv	a2,s1
    80002906:	652c                	ld	a1,72(a0)
    80002908:	6d28                	ld	a0,88(a0)
    8000290a:	d9ffe0ef          	jal	800016a8 <copyinstr>
    8000290e:	00054c63          	bltz	a0,80002926 <fetchstr+0x3e>
  return strlen(buf);
    80002912:	8526                	mv	a0,s1
    80002914:	d1efe0ef          	jal	80000e32 <strlen>
}
    80002918:	70a2                	ld	ra,40(sp)
    8000291a:	7402                	ld	s0,32(sp)
    8000291c:	64e2                	ld	s1,24(sp)
    8000291e:	6942                	ld	s2,16(sp)
    80002920:	69a2                	ld	s3,8(sp)
    80002922:	6145                	addi	sp,sp,48
    80002924:	8082                	ret
    return -1;
    80002926:	557d                	li	a0,-1
    80002928:	bfc5                	j	80002918 <fetchstr+0x30>

000000008000292a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000292a:	1101                	addi	sp,sp,-32
    8000292c:	ec06                	sd	ra,24(sp)
    8000292e:	e822                	sd	s0,16(sp)
    80002930:	e426                	sd	s1,8(sp)
    80002932:	1000                	addi	s0,sp,32
    80002934:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002936:	f09ff0ef          	jal	8000283e <argraw>
    8000293a:	c088                	sw	a0,0(s1)
}
    8000293c:	60e2                	ld	ra,24(sp)
    8000293e:	6442                	ld	s0,16(sp)
    80002940:	64a2                	ld	s1,8(sp)
    80002942:	6105                	addi	sp,sp,32
    80002944:	8082                	ret

0000000080002946 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002946:	1101                	addi	sp,sp,-32
    80002948:	ec06                	sd	ra,24(sp)
    8000294a:	e822                	sd	s0,16(sp)
    8000294c:	e426                	sd	s1,8(sp)
    8000294e:	1000                	addi	s0,sp,32
    80002950:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002952:	eedff0ef          	jal	8000283e <argraw>
    80002956:	e088                	sd	a0,0(s1)
}
    80002958:	60e2                	ld	ra,24(sp)
    8000295a:	6442                	ld	s0,16(sp)
    8000295c:	64a2                	ld	s1,8(sp)
    8000295e:	6105                	addi	sp,sp,32
    80002960:	8082                	ret

0000000080002962 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002962:	1101                	addi	sp,sp,-32
    80002964:	ec06                	sd	ra,24(sp)
    80002966:	e822                	sd	s0,16(sp)
    80002968:	e426                	sd	s1,8(sp)
    8000296a:	e04a                	sd	s2,0(sp)
    8000296c:	1000                	addi	s0,sp,32
    8000296e:	892e                	mv	s2,a1
    80002970:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002972:	ecdff0ef          	jal	8000283e <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002976:	8626                	mv	a2,s1
    80002978:	85ca                	mv	a1,s2
    8000297a:	f6fff0ef          	jal	800028e8 <fetchstr>
}
    8000297e:	60e2                	ld	ra,24(sp)
    80002980:	6442                	ld	s0,16(sp)
    80002982:	64a2                	ld	s1,8(sp)
    80002984:	6902                	ld	s2,0(sp)
    80002986:	6105                	addi	sp,sp,32
    80002988:	8082                	ret

000000008000298a <syscall>:
  // clang-format on
};

void
syscall(void)
{
    8000298a:	1101                	addi	sp,sp,-32
    8000298c:	ec06                	sd	ra,24(sp)
    8000298e:	e822                	sd	s0,16(sp)
    80002990:	e426                	sd	s1,8(sp)
    80002992:	e04a                	sd	s2,0(sp)
    80002994:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002996:	f93fe0ef          	jal	80001928 <myproc>
    8000299a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000299c:	06053903          	ld	s2,96(a0)
    800029a0:	0a893783          	ld	a5,168(s2)
    800029a4:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800029a8:	37fd                	addiw	a5,a5,-1
    800029aa:	4769                	li	a4,26
    800029ac:	00f76f63          	bltu	a4,a5,800029ca <syscall+0x40>
    800029b0:	00369713          	slli	a4,a3,0x3
    800029b4:	00006797          	auipc	a5,0x6
    800029b8:	e0c78793          	addi	a5,a5,-500 # 800087c0 <syscalls>
    800029bc:	97ba                	add	a5,a5,a4
    800029be:	639c                	ld	a5,0(a5)
    800029c0:	c789                	beqz	a5,800029ca <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800029c2:	9782                	jalr	a5
    800029c4:	06a93823          	sd	a0,112(s2)
    800029c8:	a829                	j	800029e2 <syscall+0x58>
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800029ca:	16048613          	addi	a2,s1,352
    800029ce:	588c                	lw	a1,48(s1)
    800029d0:	00006517          	auipc	a0,0x6
    800029d4:	9d050513          	addi	a0,a0,-1584 # 800083a0 <etext+0x3a0>
    800029d8:	b33fd0ef          	jal	8000050a <printk>
    p->trapframe->a0 = -1;
    800029dc:	70bc                	ld	a5,96(s1)
    800029de:	577d                	li	a4,-1
    800029e0:	fbb8                	sd	a4,112(a5)
  }
}
    800029e2:	60e2                	ld	ra,24(sp)
    800029e4:	6442                	ld	s0,16(sp)
    800029e6:	64a2                	ld	s1,8(sp)
    800029e8:	6902                	ld	s2,0(sp)
    800029ea:	6105                	addi	sp,sp,32
    800029ec:	8082                	ret

00000000800029ee <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    800029ee:	1101                	addi	sp,sp,-32
    800029f0:	ec06                	sd	ra,24(sp)
    800029f2:	e822                	sd	s0,16(sp)
    800029f4:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800029f6:	fec40593          	addi	a1,s0,-20
    800029fa:	4501                	li	a0,0
    800029fc:	f2fff0ef          	jal	8000292a <argint>
  kexit(n);
    80002a00:	fec42503          	lw	a0,-20(s0)
    80002a04:	f16ff0ef          	jal	8000211a <kexit>
  return 0; // not reached
}
    80002a08:	4501                	li	a0,0
    80002a0a:	60e2                	ld	ra,24(sp)
    80002a0c:	6442                	ld	s0,16(sp)
    80002a0e:	6105                	addi	sp,sp,32
    80002a10:	8082                	ret

0000000080002a12 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002a12:	1141                	addi	sp,sp,-16
    80002a14:	e406                	sd	ra,8(sp)
    80002a16:	e022                	sd	s0,0(sp)
    80002a18:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002a1a:	f0ffe0ef          	jal	80001928 <myproc>
}
    80002a1e:	5908                	lw	a0,48(a0)
    80002a20:	60a2                	ld	ra,8(sp)
    80002a22:	6402                	ld	s0,0(sp)
    80002a24:	0141                	addi	sp,sp,16
    80002a26:	8082                	ret

0000000080002a28 <sys_fork>:

uint64
sys_fork(void)
{
    80002a28:	1141                	addi	sp,sp,-16
    80002a2a:	e406                	sd	ra,8(sp)
    80002a2c:	e022                	sd	s0,0(sp)
    80002a2e:	0800                	addi	s0,sp,16
  return kfork();
    80002a30:	ab8ff0ef          	jal	80001ce8 <kfork>
}
    80002a34:	60a2                	ld	ra,8(sp)
    80002a36:	6402                	ld	s0,0(sp)
    80002a38:	0141                	addi	sp,sp,16
    80002a3a:	8082                	ret

0000000080002a3c <sys_wait>:

uint64
sys_wait(void)
{
    80002a3c:	1101                	addi	sp,sp,-32
    80002a3e:	ec06                	sd	ra,24(sp)
    80002a40:	e822                	sd	s0,16(sp)
    80002a42:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002a44:	fe840593          	addi	a1,s0,-24
    80002a48:	4501                	li	a0,0
    80002a4a:	efdff0ef          	jal	80002946 <argaddr>
  return kwait(p);
    80002a4e:	fe843503          	ld	a0,-24(s0)
    80002a52:	823ff0ef          	jal	80002274 <kwait>
}
    80002a56:	60e2                	ld	ra,24(sp)
    80002a58:	6442                	ld	s0,16(sp)
    80002a5a:	6105                	addi	sp,sp,32
    80002a5c:	8082                	ret

0000000080002a5e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a5e:	7179                	addi	sp,sp,-48
    80002a60:	f406                	sd	ra,40(sp)
    80002a62:	f022                	sd	s0,32(sp)
    80002a64:	ec26                	sd	s1,24(sp)
    80002a66:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002a68:	fd840593          	addi	a1,s0,-40
    80002a6c:	4501                	li	a0,0
    80002a6e:	ebdff0ef          	jal	8000292a <argint>
  argint(1, &t);
    80002a72:	fdc40593          	addi	a1,s0,-36
    80002a76:	4505                	li	a0,1
    80002a78:	eb3ff0ef          	jal	8000292a <argint>
  addr = myproc()->sz;
    80002a7c:	eadfe0ef          	jal	80001928 <myproc>
    80002a80:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0) {
    80002a82:	fdc42703          	lw	a4,-36(s0)
    80002a86:	4785                	li	a5,1
    80002a88:	02f70763          	beq	a4,a5,80002ab6 <sys_sbrk+0x58>
    80002a8c:	fd842783          	lw	a5,-40(s0)
    80002a90:	0207c363          	bltz	a5,80002ab6 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    80002a94:	97a6                	add	a5,a5,s1
      return -1;
    if (addr + n > TRAPFRAME)
    80002a96:	02000737          	lui	a4,0x2000
    80002a9a:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    80002a9c:	0736                	slli	a4,a4,0xd
    80002a9e:	02f76a63          	bltu	a4,a5,80002ad2 <sys_sbrk+0x74>
    80002aa2:	0297e863          	bltu	a5,s1,80002ad2 <sys_sbrk+0x74>
      return -1;
    myproc()->sz += n;
    80002aa6:	e83fe0ef          	jal	80001928 <myproc>
    80002aaa:	fd842703          	lw	a4,-40(s0)
    80002aae:	653c                	ld	a5,72(a0)
    80002ab0:	97ba                	add	a5,a5,a4
    80002ab2:	e53c                	sd	a5,72(a0)
    80002ab4:	a039                	j	80002ac2 <sys_sbrk+0x64>
    if (growproc(n) < 0) {
    80002ab6:	fd842503          	lw	a0,-40(s0)
    80002aba:	9ccff0ef          	jal	80001c86 <growproc>
    80002abe:	00054863          	bltz	a0,80002ace <sys_sbrk+0x70>
  }
  return addr;
}
    80002ac2:	8526                	mv	a0,s1
    80002ac4:	70a2                	ld	ra,40(sp)
    80002ac6:	7402                	ld	s0,32(sp)
    80002ac8:	64e2                	ld	s1,24(sp)
    80002aca:	6145                	addi	sp,sp,48
    80002acc:	8082                	ret
      return -1;
    80002ace:	54fd                	li	s1,-1
    80002ad0:	bfcd                	j	80002ac2 <sys_sbrk+0x64>
      return -1;
    80002ad2:	54fd                	li	s1,-1
    80002ad4:	b7fd                	j	80002ac2 <sys_sbrk+0x64>

0000000080002ad6 <sys_pause>:

uint64
sys_pause(void)
{
    80002ad6:	7139                	addi	sp,sp,-64
    80002ad8:	fc06                	sd	ra,56(sp)
    80002ada:	f822                	sd	s0,48(sp)
    80002adc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002ade:	fcc40593          	addi	a1,s0,-52
    80002ae2:	4501                	li	a0,0
    80002ae4:	e47ff0ef          	jal	8000292a <argint>
  if (n < 0)
    80002ae8:	fcc42783          	lw	a5,-52(s0)
    80002aec:	0807c063          	bltz	a5,80002b6c <sys_pause+0x96>
    n = 0;
  acquire(&tickslock);
    80002af0:	00017517          	auipc	a0,0x17
    80002af4:	ba850513          	addi	a0,a0,-1112 # 80019698 <tickslock>
    80002af8:	8f0fe0ef          	jal	80000be8 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    80002afc:	fcc42783          	lw	a5,-52(s0)
    80002b00:	cbb9                	beqz	a5,80002b56 <sys_pause+0x80>
    80002b02:	f426                	sd	s1,40(sp)
    80002b04:	f04a                	sd	s2,32(sp)
    80002b06:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002b08:	00009997          	auipc	s3,0x9
    80002b0c:	a309a983          	lw	s3,-1488(s3) # 8000b538 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    80002b10:	00009917          	auipc	s2,0x9
    80002b14:	a2890913          	addi	s2,s2,-1496 # 8000b538 <ticks>
    release(&tickslock);
    80002b18:	00017497          	auipc	s1,0x17
    80002b1c:	b8048493          	addi	s1,s1,-1152 # 80019698 <tickslock>
    if (killed(myproc())) {
    80002b20:	e09fe0ef          	jal	80001928 <myproc>
    80002b24:	f26ff0ef          	jal	8000224a <killed>
    80002b28:	e529                	bnez	a0,80002b72 <sys_pause+0x9c>
    sleep_prepare(&ticks);
    80002b2a:	854a                	mv	a0,s2
    80002b2c:	cc6ff0ef          	jal	80001ff2 <sleep_prepare>
    release(&tickslock);
    80002b30:	8526                	mv	a0,s1
    80002b32:	93efe0ef          	jal	80000c70 <release>
    sleep();
    80002b36:	cf8ff0ef          	jal	8000202e <sleep>
    acquire(&tickslock);
    80002b3a:	8526                	mv	a0,s1
    80002b3c:	8acfe0ef          	jal	80000be8 <acquire>
  while (ticks - ticks0 < n) {
    80002b40:	00092783          	lw	a5,0(s2)
    80002b44:	413787bb          	subw	a5,a5,s3
    80002b48:	fcc42703          	lw	a4,-52(s0)
    80002b4c:	fce7eae3          	bltu	a5,a4,80002b20 <sys_pause+0x4a>
    80002b50:	74a2                	ld	s1,40(sp)
    80002b52:	7902                	ld	s2,32(sp)
    80002b54:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002b56:	00017517          	auipc	a0,0x17
    80002b5a:	b4250513          	addi	a0,a0,-1214 # 80019698 <tickslock>
    80002b5e:	912fe0ef          	jal	80000c70 <release>
  return 0;
    80002b62:	4501                	li	a0,0
}
    80002b64:	70e2                	ld	ra,56(sp)
    80002b66:	7442                	ld	s0,48(sp)
    80002b68:	6121                	addi	sp,sp,64
    80002b6a:	8082                	ret
    n = 0;
    80002b6c:	fc042623          	sw	zero,-52(s0)
    80002b70:	b741                	j	80002af0 <sys_pause+0x1a>
      release(&tickslock);
    80002b72:	00017517          	auipc	a0,0x17
    80002b76:	b2650513          	addi	a0,a0,-1242 # 80019698 <tickslock>
    80002b7a:	8f6fe0ef          	jal	80000c70 <release>
      return -1;
    80002b7e:	557d                	li	a0,-1
    80002b80:	74a2                	ld	s1,40(sp)
    80002b82:	7902                	ld	s2,32(sp)
    80002b84:	69e2                	ld	s3,24(sp)
    80002b86:	bff9                	j	80002b64 <sys_pause+0x8e>

0000000080002b88 <sys_kill>:

uint64
sys_kill(void)
{
    80002b88:	1101                	addi	sp,sp,-32
    80002b8a:	ec06                	sd	ra,24(sp)
    80002b8c:	e822                	sd	s0,16(sp)
    80002b8e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002b90:	fec40593          	addi	a1,s0,-20
    80002b94:	4501                	li	a0,0
    80002b96:	d95ff0ef          	jal	8000292a <argint>
  return kkill(pid);
    80002b9a:	fec42503          	lw	a0,-20(s0)
    80002b9e:	e22ff0ef          	jal	800021c0 <kkill>
}
    80002ba2:	60e2                	ld	ra,24(sp)
    80002ba4:	6442                	ld	s0,16(sp)
    80002ba6:	6105                	addi	sp,sp,32
    80002ba8:	8082                	ret

0000000080002baa <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002baa:	1101                	addi	sp,sp,-32
    80002bac:	ec06                	sd	ra,24(sp)
    80002bae:	e822                	sd	s0,16(sp)
    80002bb0:	e426                	sd	s1,8(sp)
    80002bb2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002bb4:	00017517          	auipc	a0,0x17
    80002bb8:	ae450513          	addi	a0,a0,-1308 # 80019698 <tickslock>
    80002bbc:	82cfe0ef          	jal	80000be8 <acquire>
  xticks = ticks;
    80002bc0:	00009797          	auipc	a5,0x9
    80002bc4:	9787a783          	lw	a5,-1672(a5) # 8000b538 <ticks>
    80002bc8:	84be                	mv	s1,a5
  release(&tickslock);
    80002bca:	00017517          	auipc	a0,0x17
    80002bce:	ace50513          	addi	a0,a0,-1330 # 80019698 <tickslock>
    80002bd2:	89efe0ef          	jal	80000c70 <release>
  return xticks;
}
    80002bd6:	02049513          	slli	a0,s1,0x20
    80002bda:	9101                	srli	a0,a0,0x20
    80002bdc:	60e2                	ld	ra,24(sp)
    80002bde:	6442                	ld	s0,16(sp)
    80002be0:	64a2                	ld	s1,8(sp)
    80002be2:	6105                	addi	sp,sp,32
    80002be4:	8082                	ret

0000000080002be6 <sys_shm_get>:
uint64
sys_shm_get(void)
{
    80002be6:	1101                	addi	sp,sp,-32
    80002be8:	ec06                	sd	ra,24(sp)
    80002bea:	e822                	sd	s0,16(sp)
    80002bec:	e426                	sd	s1,8(sp)
    80002bee:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002bf0:	d39fe0ef          	jal	80001928 <myproc>
    80002bf4:	84aa                	mv	s1,a0
  char *mem;

  if(p->shm_pa != 0)
    80002bf6:	6938                	ld	a4,80(a0)
    return SHM_BASE;
    80002bf8:	040007b7          	lui	a5,0x4000
    80002bfc:	17f5                	addi	a5,a5,-3 # 3fffffd <_entry-0x7c000003>
    80002bfe:	00c79513          	slli	a0,a5,0xc
  if(p->shm_pa != 0)
    80002c02:	c711                	beqz	a4,80002c0e <sys_shm_get+0x28>
  acquire(&shm_lock);
  shm_refcnt = 1;
  release(&shm_lock);

  return SHM_BASE;
}
    80002c04:	60e2                	ld	ra,24(sp)
    80002c06:	6442                	ld	s0,16(sp)
    80002c08:	64a2                	ld	s1,8(sp)
    80002c0a:	6105                	addi	sp,sp,32
    80002c0c:	8082                	ret
    80002c0e:	e04a                	sd	s2,0(sp)
  mem = kalloc();
    80002c10:	efffd0ef          	jal	80000b0e <kalloc>
    80002c14:	87aa                	mv	a5,a0
    80002c16:	892a                	mv	s2,a0
    return -1;
    80002c18:	557d                	li	a0,-1
  if(mem == 0)
    80002c1a:	c3a5                	beqz	a5,80002c7a <sys_shm_get+0x94>
  memset(mem, 0, PGSIZE);
    80002c1c:	6605                	lui	a2,0x1
    80002c1e:	4581                	li	a1,0
    80002c20:	853e                	mv	a0,a5
    80002c22:	886fe0ef          	jal	80000ca8 <memset>
  if(mappages(p->pagetable, SHM_BASE, PGSIZE,
    80002c26:	4759                	li	a4,22
    80002c28:	86ca                	mv	a3,s2
    80002c2a:	6605                	lui	a2,0x1
    80002c2c:	040005b7          	lui	a1,0x4000
    80002c30:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80002c32:	05b2                	slli	a1,a1,0xc
    80002c34:	6ca8                	ld	a0,88(s1)
    80002c36:	be0fe0ef          	jal	80001016 <mappages>
    80002c3a:	e915                	bnez	a0,80002c6e <sys_shm_get+0x88>
  p->shm_pa = (uint64)mem;
    80002c3c:	0524b823          	sd	s2,80(s1)
  acquire(&shm_lock);
    80002c40:	00011517          	auipc	a0,0x11
    80002c44:	a4050513          	addi	a0,a0,-1472 # 80013680 <shm_lock>
    80002c48:	fa1fd0ef          	jal	80000be8 <acquire>
  shm_refcnt = 1;
    80002c4c:	4785                	li	a5,1
    80002c4e:	00009717          	auipc	a4,0x9
    80002c52:	8cf72d23          	sw	a5,-1830(a4) # 8000b528 <shm_refcnt>
  release(&shm_lock);
    80002c56:	00011517          	auipc	a0,0x11
    80002c5a:	a2a50513          	addi	a0,a0,-1494 # 80013680 <shm_lock>
    80002c5e:	812fe0ef          	jal	80000c70 <release>
  return SHM_BASE;
    80002c62:	04000537          	lui	a0,0x4000
    80002c66:	1575                	addi	a0,a0,-3 # 3fffffd <_entry-0x7c000003>
    80002c68:	0532                	slli	a0,a0,0xc
    80002c6a:	6902                	ld	s2,0(sp)
    80002c6c:	bf61                	j	80002c04 <sys_shm_get+0x1e>
    kfree(mem);
    80002c6e:	854a                	mv	a0,s2
    80002c70:	db7fd0ef          	jal	80000a26 <kfree>
    return -1;
    80002c74:	557d                	li	a0,-1
    80002c76:	6902                	ld	s2,0(sp)
    80002c78:	b771                	j	80002c04 <sys_shm_get+0x1e>
    80002c7a:	6902                	ld	s2,0(sp)
    80002c7c:	b761                	j	80002c04 <sys_shm_get+0x1e>

0000000080002c7e <sys_sem_create>:

uint64
sys_sem_create(void)
{
    80002c7e:	1101                	addi	sp,sp,-32
    80002c80:	ec06                	sd	ra,24(sp)
    80002c82:	e822                	sd	s0,16(sp)
    80002c84:	1000                	addi	s0,sp,32
  int value;

  argint(0, &value);
    80002c86:	fec40593          	addi	a1,s0,-20
    80002c8a:	4501                	li	a0,0
    80002c8c:	c9fff0ef          	jal	8000292a <argint>
  return sem_create(value);
    80002c90:	fec42503          	lw	a0,-20(s0)
    80002c94:	18c030ef          	jal	80005e20 <sem_create>
}
    80002c98:	60e2                	ld	ra,24(sp)
    80002c9a:	6442                	ld	s0,16(sp)
    80002c9c:	6105                	addi	sp,sp,32
    80002c9e:	8082                	ret

0000000080002ca0 <sys_sem_wait>:

uint64
sys_sem_wait(void)
{
    80002ca0:	1101                	addi	sp,sp,-32
    80002ca2:	ec06                	sd	ra,24(sp)
    80002ca4:	e822                	sd	s0,16(sp)
    80002ca6:	1000                	addi	s0,sp,32
  int id;

  argint(0, &id);
    80002ca8:	fec40593          	addi	a1,s0,-20
    80002cac:	4501                	li	a0,0
    80002cae:	c7dff0ef          	jal	8000292a <argint>
  return sem_wait(id);
    80002cb2:	fec42503          	lw	a0,-20(s0)
    80002cb6:	1ec030ef          	jal	80005ea2 <sem_wait>
}
    80002cba:	60e2                	ld	ra,24(sp)
    80002cbc:	6442                	ld	s0,16(sp)
    80002cbe:	6105                	addi	sp,sp,32
    80002cc0:	8082                	ret

0000000080002cc2 <sys_sem_signal>:

uint64
sys_sem_signal(void)
{
    80002cc2:	1101                	addi	sp,sp,-32
    80002cc4:	ec06                	sd	ra,24(sp)
    80002cc6:	e822                	sd	s0,16(sp)
    80002cc8:	1000                	addi	s0,sp,32
  int id;

  argint(0, &id);
    80002cca:	fec40593          	addi	a1,s0,-20
    80002cce:	4501                	li	a0,0
    80002cd0:	c5bff0ef          	jal	8000292a <argint>
  return sem_signal(id);
    80002cd4:	fec42503          	lw	a0,-20(s0)
    80002cd8:	262030ef          	jal	80005f3a <sem_signal>
}
    80002cdc:	60e2                	ld	ra,24(sp)
    80002cde:	6442                	ld	s0,16(sp)
    80002ce0:	6105                	addi	sp,sp,32
    80002ce2:	8082                	ret

0000000080002ce4 <sys_sem_free>:

uint64
sys_sem_free(void)
{
    80002ce4:	1101                	addi	sp,sp,-32
    80002ce6:	ec06                	sd	ra,24(sp)
    80002ce8:	e822                	sd	s0,16(sp)
    80002cea:	1000                	addi	s0,sp,32
  int id;

  argint(0, &id);
    80002cec:	fec40593          	addi	a1,s0,-20
    80002cf0:	4501                	li	a0,0
    80002cf2:	c39ff0ef          	jal	8000292a <argint>
  return sem_free(id);
    80002cf6:	fec42503          	lw	a0,-20(s0)
    80002cfa:	29e030ef          	jal	80005f98 <sem_free>
}
    80002cfe:	60e2                	ld	ra,24(sp)
    80002d00:	6442                	ld	s0,16(sp)
    80002d02:	6105                	addi	sp,sp,32
    80002d04:	8082                	ret

0000000080002d06 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d06:	7179                	addi	sp,sp,-48
    80002d08:	f406                	sd	ra,40(sp)
    80002d0a:	f022                	sd	s0,32(sp)
    80002d0c:	ec26                	sd	s1,24(sp)
    80002d0e:	e84a                	sd	s2,16(sp)
    80002d10:	e44e                	sd	s3,8(sp)
    80002d12:	e052                	sd	s4,0(sp)
    80002d14:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d16:	00005597          	auipc	a1,0x5
    80002d1a:	6aa58593          	addi	a1,a1,1706 # 800083c0 <etext+0x3c0>
    80002d1e:	00017517          	auipc	a0,0x17
    80002d22:	99250513          	addi	a0,a0,-1646 # 800196b0 <bcache>
    80002d26:	e43fd0ef          	jal	80000b68 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d2a:	0001f797          	auipc	a5,0x1f
    80002d2e:	98678793          	addi	a5,a5,-1658 # 800216b0 <bcache+0x8000>
    80002d32:	0001f717          	auipc	a4,0x1f
    80002d36:	be670713          	addi	a4,a4,-1050 # 80021918 <bcache+0x8268>
    80002d3a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002d3e:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002d42:	00017497          	auipc	s1,0x17
    80002d46:	98648493          	addi	s1,s1,-1658 # 800196c8 <bcache+0x18>
    b->next = bcache.head.next;
    80002d4a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002d4c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002d4e:	00005a17          	auipc	s4,0x5
    80002d52:	67aa0a13          	addi	s4,s4,1658 # 800083c8 <etext+0x3c8>
    b->next = bcache.head.next;
    80002d56:	2b893783          	ld	a5,696(s2)
    80002d5a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002d5c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002d60:	85d2                	mv	a1,s4
    80002d62:	01048513          	addi	a0,s1,16
    80002d66:	40e010ef          	jal	80004174 <initsleeplock>
    bcache.head.next->prev = b;
    80002d6a:	2b893783          	ld	a5,696(s2)
    80002d6e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002d70:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002d74:	45848493          	addi	s1,s1,1112
    80002d78:	fd349fe3          	bne	s1,s3,80002d56 <binit+0x50>
  }
}
    80002d7c:	70a2                	ld	ra,40(sp)
    80002d7e:	7402                	ld	s0,32(sp)
    80002d80:	64e2                	ld	s1,24(sp)
    80002d82:	6942                	ld	s2,16(sp)
    80002d84:	69a2                	ld	s3,8(sp)
    80002d86:	6a02                	ld	s4,0(sp)
    80002d88:	6145                	addi	sp,sp,48
    80002d8a:	8082                	ret

0000000080002d8c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80002d8c:	7179                	addi	sp,sp,-48
    80002d8e:	f406                	sd	ra,40(sp)
    80002d90:	f022                	sd	s0,32(sp)
    80002d92:	ec26                	sd	s1,24(sp)
    80002d94:	e84a                	sd	s2,16(sp)
    80002d96:	e44e                	sd	s3,8(sp)
    80002d98:	1800                	addi	s0,sp,48
    80002d9a:	892a                	mv	s2,a0
    80002d9c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002d9e:	00017517          	auipc	a0,0x17
    80002da2:	91250513          	addi	a0,a0,-1774 # 800196b0 <bcache>
    80002da6:	e43fd0ef          	jal	80000be8 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002daa:	0001f497          	auipc	s1,0x1f
    80002dae:	bbe4b483          	ld	s1,-1090(s1) # 80021968 <bcache+0x82b8>
    80002db2:	0001f797          	auipc	a5,0x1f
    80002db6:	b6678793          	addi	a5,a5,-1178 # 80021918 <bcache+0x8268>
    80002dba:	02f48b63          	beq	s1,a5,80002df0 <bread+0x64>
    80002dbe:	873e                	mv	a4,a5
    80002dc0:	a021                	j	80002dc8 <bread+0x3c>
    80002dc2:	68a4                	ld	s1,80(s1)
    80002dc4:	02e48663          	beq	s1,a4,80002df0 <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002dc8:	449c                	lw	a5,8(s1)
    80002dca:	ff279ce3          	bne	a5,s2,80002dc2 <bread+0x36>
    80002dce:	44dc                	lw	a5,12(s1)
    80002dd0:	ff3799e3          	bne	a5,s3,80002dc2 <bread+0x36>
      b->refcnt++;
    80002dd4:	40bc                	lw	a5,64(s1)
    80002dd6:	2785                	addiw	a5,a5,1
    80002dd8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002dda:	00017517          	auipc	a0,0x17
    80002dde:	8d650513          	addi	a0,a0,-1834 # 800196b0 <bcache>
    80002de2:	e8ffd0ef          	jal	80000c70 <release>
      acquiresleep(&b->lock);
    80002de6:	01048513          	addi	a0,s1,16
    80002dea:	3c0010ef          	jal	800041aa <acquiresleep>
      return b;
    80002dee:	a889                	j	80002e40 <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002df0:	0001f497          	auipc	s1,0x1f
    80002df4:	b704b483          	ld	s1,-1168(s1) # 80021960 <bcache+0x82b0>
    80002df8:	0001f797          	auipc	a5,0x1f
    80002dfc:	b2078793          	addi	a5,a5,-1248 # 80021918 <bcache+0x8268>
    80002e00:	00f48863          	beq	s1,a5,80002e10 <bread+0x84>
    80002e04:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002e06:	40bc                	lw	a5,64(s1)
    80002e08:	cb91                	beqz	a5,80002e1c <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002e0a:	64a4                	ld	s1,72(s1)
    80002e0c:	fee49de3          	bne	s1,a4,80002e06 <bread+0x7a>
  panic("bget: no buffers");
    80002e10:	00005517          	auipc	a0,0x5
    80002e14:	5c050513          	addi	a0,a0,1472 # 800083d0 <etext+0x3d0>
    80002e18:	a1dfd0ef          	jal	80000834 <panic>
      b->dev = dev;
    80002e1c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e20:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002e24:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002e28:	4785                	li	a5,1
    80002e2a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e2c:	00017517          	auipc	a0,0x17
    80002e30:	88450513          	addi	a0,a0,-1916 # 800196b0 <bcache>
    80002e34:	e3dfd0ef          	jal	80000c70 <release>
      acquiresleep(&b->lock);
    80002e38:	01048513          	addi	a0,s1,16
    80002e3c:	36e010ef          	jal	800041aa <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002e40:	409c                	lw	a5,0(s1)
    80002e42:	cb89                	beqz	a5,80002e54 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002e44:	8526                	mv	a0,s1
    80002e46:	70a2                	ld	ra,40(sp)
    80002e48:	7402                	ld	s0,32(sp)
    80002e4a:	64e2                	ld	s1,24(sp)
    80002e4c:	6942                	ld	s2,16(sp)
    80002e4e:	69a2                	ld	s3,8(sp)
    80002e50:	6145                	addi	sp,sp,48
    80002e52:	8082                	ret
    virtio_disk_rw(b, 0);
    80002e54:	4581                	li	a1,0
    80002e56:	8526                	mv	a0,s1
    80002e58:	489020ef          	jal	80005ae0 <virtio_disk_rw>
    b->valid = 1;
    80002e5c:	4785                	li	a5,1
    80002e5e:	c09c                	sw	a5,0(s1)
  return b;
    80002e60:	b7d5                	j	80002e44 <bread+0xb8>

0000000080002e62 <bwrite>:

// Write b's contents to disk.  Must be locked.
// Only the log calls bwrite.
void
bwrite(struct buf *b)
{
    80002e62:	1101                	addi	sp,sp,-32
    80002e64:	ec06                	sd	ra,24(sp)
    80002e66:	e822                	sd	s0,16(sp)
    80002e68:	e426                	sd	s1,8(sp)
    80002e6a:	1000                	addi	s0,sp,32
    80002e6c:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002e6e:	0541                	addi	a0,a0,16
    80002e70:	3c6010ef          	jal	80004236 <holdingsleep>
    80002e74:	c911                	beqz	a0,80002e88 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002e76:	4585                	li	a1,1
    80002e78:	8526                	mv	a0,s1
    80002e7a:	467020ef          	jal	80005ae0 <virtio_disk_rw>
}
    80002e7e:	60e2                	ld	ra,24(sp)
    80002e80:	6442                	ld	s0,16(sp)
    80002e82:	64a2                	ld	s1,8(sp)
    80002e84:	6105                	addi	sp,sp,32
    80002e86:	8082                	ret
    panic("bwrite");
    80002e88:	00005517          	auipc	a0,0x5
    80002e8c:	56050513          	addi	a0,a0,1376 # 800083e8 <etext+0x3e8>
    80002e90:	9a5fd0ef          	jal	80000834 <panic>

0000000080002e94 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002e94:	1101                	addi	sp,sp,-32
    80002e96:	ec06                	sd	ra,24(sp)
    80002e98:	e822                	sd	s0,16(sp)
    80002e9a:	e426                	sd	s1,8(sp)
    80002e9c:	e04a                	sd	s2,0(sp)
    80002e9e:	1000                	addi	s0,sp,32
    80002ea0:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002ea2:	01050913          	addi	s2,a0,16
    80002ea6:	854a                	mv	a0,s2
    80002ea8:	38e010ef          	jal	80004236 <holdingsleep>
    80002eac:	c125                	beqz	a0,80002f0c <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002eae:	854a                	mv	a0,s2
    80002eb0:	34e010ef          	jal	800041fe <releasesleep>

  acquire(&bcache.lock);
    80002eb4:	00016517          	auipc	a0,0x16
    80002eb8:	7fc50513          	addi	a0,a0,2044 # 800196b0 <bcache>
    80002ebc:	d2dfd0ef          	jal	80000be8 <acquire>
  b->refcnt--;
    80002ec0:	40bc                	lw	a5,64(s1)
    80002ec2:	37fd                	addiw	a5,a5,-1
    80002ec4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002ec6:	e79d                	bnez	a5,80002ef4 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002ec8:	68b8                	ld	a4,80(s1)
    80002eca:	64bc                	ld	a5,72(s1)
    80002ecc:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002ece:	68b8                	ld	a4,80(s1)
    80002ed0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002ed2:	0001e797          	auipc	a5,0x1e
    80002ed6:	7de78793          	addi	a5,a5,2014 # 800216b0 <bcache+0x8000>
    80002eda:	2b87b703          	ld	a4,696(a5)
    80002ede:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002ee0:	0001f717          	auipc	a4,0x1f
    80002ee4:	a3870713          	addi	a4,a4,-1480 # 80021918 <bcache+0x8268>
    80002ee8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002eea:	2b87b703          	ld	a4,696(a5)
    80002eee:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002ef0:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002ef4:	00016517          	auipc	a0,0x16
    80002ef8:	7bc50513          	addi	a0,a0,1980 # 800196b0 <bcache>
    80002efc:	d75fd0ef          	jal	80000c70 <release>
}
    80002f00:	60e2                	ld	ra,24(sp)
    80002f02:	6442                	ld	s0,16(sp)
    80002f04:	64a2                	ld	s1,8(sp)
    80002f06:	6902                	ld	s2,0(sp)
    80002f08:	6105                	addi	sp,sp,32
    80002f0a:	8082                	ret
    panic("brelse");
    80002f0c:	00005517          	auipc	a0,0x5
    80002f10:	4e450513          	addi	a0,a0,1252 # 800083f0 <etext+0x3f0>
    80002f14:	921fd0ef          	jal	80000834 <panic>

0000000080002f18 <bpin>:

void
bpin(struct buf *b)
{
    80002f18:	1101                	addi	sp,sp,-32
    80002f1a:	ec06                	sd	ra,24(sp)
    80002f1c:	e822                	sd	s0,16(sp)
    80002f1e:	e426                	sd	s1,8(sp)
    80002f20:	1000                	addi	s0,sp,32
    80002f22:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002f24:	00016517          	auipc	a0,0x16
    80002f28:	78c50513          	addi	a0,a0,1932 # 800196b0 <bcache>
    80002f2c:	cbdfd0ef          	jal	80000be8 <acquire>
  b->refcnt++;
    80002f30:	40bc                	lw	a5,64(s1)
    80002f32:	2785                	addiw	a5,a5,1
    80002f34:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002f36:	00016517          	auipc	a0,0x16
    80002f3a:	77a50513          	addi	a0,a0,1914 # 800196b0 <bcache>
    80002f3e:	d33fd0ef          	jal	80000c70 <release>
}
    80002f42:	60e2                	ld	ra,24(sp)
    80002f44:	6442                	ld	s0,16(sp)
    80002f46:	64a2                	ld	s1,8(sp)
    80002f48:	6105                	addi	sp,sp,32
    80002f4a:	8082                	ret

0000000080002f4c <bunpin>:

void
bunpin(struct buf *b)
{
    80002f4c:	1101                	addi	sp,sp,-32
    80002f4e:	ec06                	sd	ra,24(sp)
    80002f50:	e822                	sd	s0,16(sp)
    80002f52:	e426                	sd	s1,8(sp)
    80002f54:	1000                	addi	s0,sp,32
    80002f56:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002f58:	00016517          	auipc	a0,0x16
    80002f5c:	75850513          	addi	a0,a0,1880 # 800196b0 <bcache>
    80002f60:	c89fd0ef          	jal	80000be8 <acquire>
  b->refcnt--;
    80002f64:	40bc                	lw	a5,64(s1)
    80002f66:	37fd                	addiw	a5,a5,-1
    80002f68:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002f6a:	00016517          	auipc	a0,0x16
    80002f6e:	74650513          	addi	a0,a0,1862 # 800196b0 <bcache>
    80002f72:	cfffd0ef          	jal	80000c70 <release>
}
    80002f76:	60e2                	ld	ra,24(sp)
    80002f78:	6442                	ld	s0,16(sp)
    80002f7a:	64a2                	ld	s1,8(sp)
    80002f7c:	6105                	addi	sp,sp,32
    80002f7e:	8082                	ret

0000000080002f80 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002f80:	1101                	addi	sp,sp,-32
    80002f82:	ec06                	sd	ra,24(sp)
    80002f84:	e822                	sd	s0,16(sp)
    80002f86:	e426                	sd	s1,8(sp)
    80002f88:	e04a                	sd	s2,0(sp)
    80002f8a:	1000                	addi	s0,sp,32
    80002f8c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002f8e:	00d5d79b          	srliw	a5,a1,0xd
    80002f92:	0001f597          	auipc	a1,0x1f
    80002f96:	dfa5a583          	lw	a1,-518(a1) # 80021d8c <sb+0x1c>
    80002f9a:	9dbd                	addw	a1,a1,a5
    80002f9c:	df1ff0ef          	jal	80002d8c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002fa0:	0074f713          	andi	a4,s1,7
    80002fa4:	4785                	li	a5,1
    80002fa6:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002faa:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    80002fac:	90d9                	srli	s1,s1,0x36
    80002fae:	00950733          	add	a4,a0,s1
    80002fb2:	05874703          	lbu	a4,88(a4)
    80002fb6:	00e7f6b3          	and	a3,a5,a4
    80002fba:	c29d                	beqz	a3,80002fe0 <bfree+0x60>
    80002fbc:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80002fbe:	94aa                	add	s1,s1,a0
    80002fc0:	fff7c793          	not	a5,a5
    80002fc4:	8f7d                	and	a4,a4,a5
    80002fc6:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002fca:	072010ef          	jal	8000403c <log_write>
  brelse(bp);
    80002fce:	854a                	mv	a0,s2
    80002fd0:	ec5ff0ef          	jal	80002e94 <brelse>
}
    80002fd4:	60e2                	ld	ra,24(sp)
    80002fd6:	6442                	ld	s0,16(sp)
    80002fd8:	64a2                	ld	s1,8(sp)
    80002fda:	6902                	ld	s2,0(sp)
    80002fdc:	6105                	addi	sp,sp,32
    80002fde:	8082                	ret
    panic("freeing free block");
    80002fe0:	00005517          	auipc	a0,0x5
    80002fe4:	41850513          	addi	a0,a0,1048 # 800083f8 <etext+0x3f8>
    80002fe8:	84dfd0ef          	jal	80000834 <panic>

0000000080002fec <balloc>:
{
    80002fec:	715d                	addi	sp,sp,-80
    80002fee:	e486                	sd	ra,72(sp)
    80002ff0:	e0a2                	sd	s0,64(sp)
    80002ff2:	fc26                	sd	s1,56(sp)
    80002ff4:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    80002ff6:	0001f797          	auipc	a5,0x1f
    80002ffa:	d7e7a783          	lw	a5,-642(a5) # 80021d74 <sb+0x4>
    80002ffe:	0e078263          	beqz	a5,800030e2 <balloc+0xf6>
    80003002:	f84a                	sd	s2,48(sp)
    80003004:	f44e                	sd	s3,40(sp)
    80003006:	f052                	sd	s4,32(sp)
    80003008:	ec56                	sd	s5,24(sp)
    8000300a:	e85a                	sd	s6,16(sp)
    8000300c:	e45e                	sd	s7,8(sp)
    8000300e:	e062                	sd	s8,0(sp)
    80003010:	8baa                	mv	s7,a0
    80003012:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003014:	0001fb17          	auipc	s6,0x1f
    80003018:	d5cb0b13          	addi	s6,s6,-676 # 80021d70 <sb>
      m = 1 << (bi % 8);
    8000301c:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000301e:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80003020:	6c09                	lui	s8,0x2
    80003022:	a09d                	j	80003088 <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80003024:	97ca                	add	a5,a5,s2
    80003026:	8e55                	or	a2,a2,a3
    80003028:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000302c:	854a                	mv	a0,s2
    8000302e:	00e010ef          	jal	8000403c <log_write>
        brelse(bp);
    80003032:	854a                	mv	a0,s2
    80003034:	e61ff0ef          	jal	80002e94 <brelse>
  bp = bread(dev, bno);
    80003038:	85a6                	mv	a1,s1
    8000303a:	855e                	mv	a0,s7
    8000303c:	d51ff0ef          	jal	80002d8c <bread>
    80003040:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003042:	40000613          	li	a2,1024
    80003046:	4581                	li	a1,0
    80003048:	05850513          	addi	a0,a0,88
    8000304c:	c5dfd0ef          	jal	80000ca8 <memset>
  log_write(bp);
    80003050:	854a                	mv	a0,s2
    80003052:	7eb000ef          	jal	8000403c <log_write>
  brelse(bp);
    80003056:	854a                	mv	a0,s2
    80003058:	e3dff0ef          	jal	80002e94 <brelse>
}
    8000305c:	7942                	ld	s2,48(sp)
    8000305e:	79a2                	ld	s3,40(sp)
    80003060:	7a02                	ld	s4,32(sp)
    80003062:	6ae2                	ld	s5,24(sp)
    80003064:	6b42                	ld	s6,16(sp)
    80003066:	6ba2                	ld	s7,8(sp)
    80003068:	6c02                	ld	s8,0(sp)
}
    8000306a:	8526                	mv	a0,s1
    8000306c:	60a6                	ld	ra,72(sp)
    8000306e:	6406                	ld	s0,64(sp)
    80003070:	74e2                	ld	s1,56(sp)
    80003072:	6161                	addi	sp,sp,80
    80003074:	8082                	ret
    brelse(bp);
    80003076:	854a                	mv	a0,s2
    80003078:	e1dff0ef          	jal	80002e94 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    8000307c:	015c0abb          	addw	s5,s8,s5
    80003080:	004b2783          	lw	a5,4(s6)
    80003084:	04faf863          	bgeu	s5,a5,800030d4 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80003088:	40dad59b          	sraiw	a1,s5,0xd
    8000308c:	01cb2783          	lw	a5,28(s6)
    80003090:	9dbd                	addw	a1,a1,a5
    80003092:	855e                	mv	a0,s7
    80003094:	cf9ff0ef          	jal	80002d8c <bread>
    80003098:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000309a:	004b2503          	lw	a0,4(s6)
    8000309e:	84d6                	mv	s1,s5
    800030a0:	4701                	li	a4,0
    800030a2:	fca4fae3          	bgeu	s1,a0,80003076 <balloc+0x8a>
      m = 1 << (bi % 8);
    800030a6:	00777693          	andi	a3,a4,7
    800030aa:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    800030ae:	41f7579b          	sraiw	a5,a4,0x1f
    800030b2:	01d7d79b          	srliw	a5,a5,0x1d
    800030b6:	9fb9                	addw	a5,a5,a4
    800030b8:	4037d79b          	sraiw	a5,a5,0x3
    800030bc:	00f90633          	add	a2,s2,a5
    800030c0:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800030c4:	00c6f5b3          	and	a1,a3,a2
    800030c8:	ddb1                	beqz	a1,80003024 <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800030ca:	2705                	addiw	a4,a4,1
    800030cc:	2485                	addiw	s1,s1,1
    800030ce:	fd471ae3          	bne	a4,s4,800030a2 <balloc+0xb6>
    800030d2:	b755                	j	80003076 <balloc+0x8a>
    800030d4:	7942                	ld	s2,48(sp)
    800030d6:	79a2                	ld	s3,40(sp)
    800030d8:	7a02                	ld	s4,32(sp)
    800030da:	6ae2                	ld	s5,24(sp)
    800030dc:	6b42                	ld	s6,16(sp)
    800030de:	6ba2                	ld	s7,8(sp)
    800030e0:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    800030e2:	00005517          	auipc	a0,0x5
    800030e6:	32e50513          	addi	a0,a0,814 # 80008410 <etext+0x410>
    800030ea:	c20fd0ef          	jal	8000050a <printk>
  return 0;
    800030ee:	4481                	li	s1,0
    800030f0:	bfad                	j	8000306a <balloc+0x7e>

00000000800030f2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800030f2:	7179                	addi	sp,sp,-48
    800030f4:	f406                	sd	ra,40(sp)
    800030f6:	f022                	sd	s0,32(sp)
    800030f8:	ec26                	sd	s1,24(sp)
    800030fa:	e84a                	sd	s2,16(sp)
    800030fc:	e44e                	sd	s3,8(sp)
    800030fe:	1800                	addi	s0,sp,48
    80003100:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80003102:	47ad                	li	a5,11
    80003104:	02b7e363          	bltu	a5,a1,8000312a <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    80003108:	02059793          	slli	a5,a1,0x20
    8000310c:	01e7d593          	srli	a1,a5,0x1e
    80003110:	00b509b3          	add	s3,a0,a1
    80003114:	0509a483          	lw	s1,80(s3)
    80003118:	e0b5                	bnez	s1,8000317c <bmap+0x8a>
      addr = balloc(ip->dev);
    8000311a:	4108                	lw	a0,0(a0)
    8000311c:	ed1ff0ef          	jal	80002fec <balloc>
    80003120:	84aa                	mv	s1,a0
      if (addr == 0)
    80003122:	cd29                	beqz	a0,8000317c <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80003124:	04a9a823          	sw	a0,80(s3)
    80003128:	a891                	j	8000317c <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000312a:	ff45879b          	addiw	a5,a1,-12
    8000312e:	873e                	mv	a4,a5
    80003130:	89be                	mv	s3,a5

  if (bn < NINDIRECT) {
    80003132:	0ff00793          	li	a5,255
    80003136:	06e7e763          	bltu	a5,a4,800031a4 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    8000313a:	08052483          	lw	s1,128(a0)
    8000313e:	e891                	bnez	s1,80003152 <bmap+0x60>
      addr = balloc(ip->dev);
    80003140:	4108                	lw	a0,0(a0)
    80003142:	eabff0ef          	jal	80002fec <balloc>
    80003146:	84aa                	mv	s1,a0
      if (addr == 0)
    80003148:	c915                	beqz	a0,8000317c <bmap+0x8a>
    8000314a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000314c:	08a92023          	sw	a0,128(s2)
    80003150:	a011                	j	80003154 <bmap+0x62>
    80003152:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003154:	85a6                	mv	a1,s1
    80003156:	00092503          	lw	a0,0(s2)
    8000315a:	c33ff0ef          	jal	80002d8c <bread>
    8000315e:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80003160:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80003164:	02099713          	slli	a4,s3,0x20
    80003168:	01e75593          	srli	a1,a4,0x1e
    8000316c:	97ae                	add	a5,a5,a1
    8000316e:	89be                	mv	s3,a5
    80003170:	4384                	lw	s1,0(a5)
    80003172:	cc89                	beqz	s1,8000318c <bmap+0x9a>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003174:	8552                	mv	a0,s4
    80003176:	d1fff0ef          	jal	80002e94 <brelse>
    return addr;
    8000317a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000317c:	8526                	mv	a0,s1
    8000317e:	70a2                	ld	ra,40(sp)
    80003180:	7402                	ld	s0,32(sp)
    80003182:	64e2                	ld	s1,24(sp)
    80003184:	6942                	ld	s2,16(sp)
    80003186:	69a2                	ld	s3,8(sp)
    80003188:	6145                	addi	sp,sp,48
    8000318a:	8082                	ret
      addr = balloc(ip->dev);
    8000318c:	00092503          	lw	a0,0(s2)
    80003190:	e5dff0ef          	jal	80002fec <balloc>
    80003194:	84aa                	mv	s1,a0
      if (addr) {
    80003196:	dd79                	beqz	a0,80003174 <bmap+0x82>
        a[bn] = addr;
    80003198:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    8000319c:	8552                	mv	a0,s4
    8000319e:	69f000ef          	jal	8000403c <log_write>
    800031a2:	bfc9                	j	80003174 <bmap+0x82>
    800031a4:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800031a6:	00005517          	auipc	a0,0x5
    800031aa:	28250513          	addi	a0,a0,642 # 80008428 <etext+0x428>
    800031ae:	e86fd0ef          	jal	80000834 <panic>

00000000800031b2 <iget>:
{
    800031b2:	7179                	addi	sp,sp,-48
    800031b4:	f406                	sd	ra,40(sp)
    800031b6:	f022                	sd	s0,32(sp)
    800031b8:	ec26                	sd	s1,24(sp)
    800031ba:	e84a                	sd	s2,16(sp)
    800031bc:	e44e                	sd	s3,8(sp)
    800031be:	e052                	sd	s4,0(sp)
    800031c0:	1800                	addi	s0,sp,48
    800031c2:	892a                	mv	s2,a0
    800031c4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800031c6:	0001f517          	auipc	a0,0x1f
    800031ca:	bca50513          	addi	a0,a0,-1078 # 80021d90 <itable>
    800031ce:	a1bfd0ef          	jal	80000be8 <acquire>
  empty = 0;
    800031d2:	4981                	li	s3,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800031d4:	0001f497          	auipc	s1,0x1f
    800031d8:	bd448493          	addi	s1,s1,-1068 # 80021da8 <itable+0x18>
    800031dc:	00020697          	auipc	a3,0x20
    800031e0:	65c68693          	addi	a3,a3,1628 # 80023838 <log>
    800031e4:	a809                	j	800031f6 <iget+0x44>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800031e6:	e781                	bnez	a5,800031ee <iget+0x3c>
    800031e8:	00099363          	bnez	s3,800031ee <iget+0x3c>
      empty = ip;
    800031ec:	89a6                	mv	s3,s1
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800031ee:	08848493          	addi	s1,s1,136
    800031f2:	02d48563          	beq	s1,a3,8000321c <iget+0x6a>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    800031f6:	449c                	lw	a5,8(s1)
    800031f8:	fef057e3          	blez	a5,800031e6 <iget+0x34>
    800031fc:	4098                	lw	a4,0(s1)
    800031fe:	ff2718e3          	bne	a4,s2,800031ee <iget+0x3c>
    80003202:	40d8                	lw	a4,4(s1)
    80003204:	ff4715e3          	bne	a4,s4,800031ee <iget+0x3c>
      ip->ref++;
    80003208:	2785                	addiw	a5,a5,1
    8000320a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000320c:	0001f517          	auipc	a0,0x1f
    80003210:	b8450513          	addi	a0,a0,-1148 # 80021d90 <itable>
    80003214:	a5dfd0ef          	jal	80000c70 <release>
      return ip;
    80003218:	89a6                	mv	s3,s1
    8000321a:	a015                	j	8000323e <iget+0x8c>
  if (empty == 0)
    8000321c:	02098a63          	beqz	s3,80003250 <iget+0x9e>
  ip->dev = dev;
    80003220:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003224:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003228:	4785                	li	a5,1
    8000322a:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    8000322e:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80003232:	0001f517          	auipc	a0,0x1f
    80003236:	b5e50513          	addi	a0,a0,-1186 # 80021d90 <itable>
    8000323a:	a37fd0ef          	jal	80000c70 <release>
}
    8000323e:	854e                	mv	a0,s3
    80003240:	70a2                	ld	ra,40(sp)
    80003242:	7402                	ld	s0,32(sp)
    80003244:	64e2                	ld	s1,24(sp)
    80003246:	6942                	ld	s2,16(sp)
    80003248:	69a2                	ld	s3,8(sp)
    8000324a:	6a02                	ld	s4,0(sp)
    8000324c:	6145                	addi	sp,sp,48
    8000324e:	8082                	ret
    panic("iget: no inodes");
    80003250:	00005517          	auipc	a0,0x5
    80003254:	1f050513          	addi	a0,a0,496 # 80008440 <etext+0x440>
    80003258:	ddcfd0ef          	jal	80000834 <panic>

000000008000325c <iinit>:
{
    8000325c:	7179                	addi	sp,sp,-48
    8000325e:	f406                	sd	ra,40(sp)
    80003260:	f022                	sd	s0,32(sp)
    80003262:	ec26                	sd	s1,24(sp)
    80003264:	e84a                	sd	s2,16(sp)
    80003266:	e44e                	sd	s3,8(sp)
    80003268:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000326a:	00005597          	auipc	a1,0x5
    8000326e:	1e658593          	addi	a1,a1,486 # 80008450 <etext+0x450>
    80003272:	0001f517          	auipc	a0,0x1f
    80003276:	b1e50513          	addi	a0,a0,-1250 # 80021d90 <itable>
    8000327a:	8effd0ef          	jal	80000b68 <initlock>
  for (i = 0; i < NINODE; i++) {
    8000327e:	0001f497          	auipc	s1,0x1f
    80003282:	b3a48493          	addi	s1,s1,-1222 # 80021db8 <itable+0x28>
    80003286:	00020997          	auipc	s3,0x20
    8000328a:	5c298993          	addi	s3,s3,1474 # 80023848 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000328e:	00005917          	auipc	s2,0x5
    80003292:	1ca90913          	addi	s2,s2,458 # 80008458 <etext+0x458>
    80003296:	85ca                	mv	a1,s2
    80003298:	8526                	mv	a0,s1
    8000329a:	6db000ef          	jal	80004174 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    8000329e:	08848493          	addi	s1,s1,136
    800032a2:	ff349ae3          	bne	s1,s3,80003296 <iinit+0x3a>
}
    800032a6:	70a2                	ld	ra,40(sp)
    800032a8:	7402                	ld	s0,32(sp)
    800032aa:	64e2                	ld	s1,24(sp)
    800032ac:	6942                	ld	s2,16(sp)
    800032ae:	69a2                	ld	s3,8(sp)
    800032b0:	6145                	addi	sp,sp,48
    800032b2:	8082                	ret

00000000800032b4 <ialloc>:
{
    800032b4:	7139                	addi	sp,sp,-64
    800032b6:	fc06                	sd	ra,56(sp)
    800032b8:	f822                	sd	s0,48(sp)
    800032ba:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    800032bc:	0001f717          	auipc	a4,0x1f
    800032c0:	ac072703          	lw	a4,-1344(a4) # 80021d7c <sb+0xc>
    800032c4:	4785                	li	a5,1
    800032c6:	06e7f063          	bgeu	a5,a4,80003326 <ialloc+0x72>
    800032ca:	f426                	sd	s1,40(sp)
    800032cc:	f04a                	sd	s2,32(sp)
    800032ce:	ec4e                	sd	s3,24(sp)
    800032d0:	e852                	sd	s4,16(sp)
    800032d2:	e456                	sd	s5,8(sp)
    800032d4:	e05a                	sd	s6,0(sp)
    800032d6:	8aaa                	mv	s5,a0
    800032d8:	8b2e                	mv	s6,a1
    800032da:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800032dc:	0001fa17          	auipc	s4,0x1f
    800032e0:	a94a0a13          	addi	s4,s4,-1388 # 80021d70 <sb>
    800032e4:	00495593          	srli	a1,s2,0x4
    800032e8:	018a2783          	lw	a5,24(s4)
    800032ec:	9dbd                	addw	a1,a1,a5
    800032ee:	8556                	mv	a0,s5
    800032f0:	a9dff0ef          	jal	80002d8c <bread>
    800032f4:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    800032f6:	05850993          	addi	s3,a0,88
    800032fa:	00f97793          	andi	a5,s2,15
    800032fe:	079a                	slli	a5,a5,0x6
    80003300:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    80003302:	00099783          	lh	a5,0(s3)
    80003306:	cb9d                	beqz	a5,8000333c <ialloc+0x88>
    brelse(bp);
    80003308:	b8dff0ef          	jal	80002e94 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    8000330c:	0905                	addi	s2,s2,1
    8000330e:	00ca2703          	lw	a4,12(s4)
    80003312:	0009079b          	sext.w	a5,s2
    80003316:	fce7e7e3          	bltu	a5,a4,800032e4 <ialloc+0x30>
    8000331a:	74a2                	ld	s1,40(sp)
    8000331c:	7902                	ld	s2,32(sp)
    8000331e:	69e2                	ld	s3,24(sp)
    80003320:	6a42                	ld	s4,16(sp)
    80003322:	6aa2                	ld	s5,8(sp)
    80003324:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    80003326:	00005517          	auipc	a0,0x5
    8000332a:	13a50513          	addi	a0,a0,314 # 80008460 <etext+0x460>
    8000332e:	9dcfd0ef          	jal	8000050a <printk>
  return 0;
    80003332:	4501                	li	a0,0
}
    80003334:	70e2                	ld	ra,56(sp)
    80003336:	7442                	ld	s0,48(sp)
    80003338:	6121                	addi	sp,sp,64
    8000333a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000333c:	04000613          	li	a2,64
    80003340:	4581                	li	a1,0
    80003342:	854e                	mv	a0,s3
    80003344:	965fd0ef          	jal	80000ca8 <memset>
      dip->type = type;
    80003348:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    8000334c:	8526                	mv	a0,s1
    8000334e:	4ef000ef          	jal	8000403c <log_write>
      brelse(bp);
    80003352:	8526                	mv	a0,s1
    80003354:	b41ff0ef          	jal	80002e94 <brelse>
      return iget(dev, inum);
    80003358:	0009059b          	sext.w	a1,s2
    8000335c:	8556                	mv	a0,s5
    8000335e:	e55ff0ef          	jal	800031b2 <iget>
    80003362:	74a2                	ld	s1,40(sp)
    80003364:	7902                	ld	s2,32(sp)
    80003366:	69e2                	ld	s3,24(sp)
    80003368:	6a42                	ld	s4,16(sp)
    8000336a:	6aa2                	ld	s5,8(sp)
    8000336c:	6b02                	ld	s6,0(sp)
    8000336e:	b7d9                	j	80003334 <ialloc+0x80>

0000000080003370 <iupdate>:
{
    80003370:	1101                	addi	sp,sp,-32
    80003372:	ec06                	sd	ra,24(sp)
    80003374:	e822                	sd	s0,16(sp)
    80003376:	e426                	sd	s1,8(sp)
    80003378:	e04a                	sd	s2,0(sp)
    8000337a:	1000                	addi	s0,sp,32
    8000337c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000337e:	415c                	lw	a5,4(a0)
    80003380:	0047d79b          	srliw	a5,a5,0x4
    80003384:	0001f597          	auipc	a1,0x1f
    80003388:	a045a583          	lw	a1,-1532(a1) # 80021d88 <sb+0x18>
    8000338c:	9dbd                	addw	a1,a1,a5
    8000338e:	4108                	lw	a0,0(a0)
    80003390:	9fdff0ef          	jal	80002d8c <bread>
    80003394:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003396:	05850793          	addi	a5,a0,88
    8000339a:	40d8                	lw	a4,4(s1)
    8000339c:	8b3d                	andi	a4,a4,15
    8000339e:	071a                	slli	a4,a4,0x6
    800033a0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800033a2:	04449703          	lh	a4,68(s1)
    800033a6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800033aa:	04649703          	lh	a4,70(s1)
    800033ae:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800033b2:	04849703          	lh	a4,72(s1)
    800033b6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800033ba:	04a49703          	lh	a4,74(s1)
    800033be:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800033c2:	44f8                	lw	a4,76(s1)
    800033c4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800033c6:	03400613          	li	a2,52
    800033ca:	05048593          	addi	a1,s1,80
    800033ce:	00c78513          	addi	a0,a5,12
    800033d2:	937fd0ef          	jal	80000d08 <memmove>
  log_write(bp);
    800033d6:	854a                	mv	a0,s2
    800033d8:	465000ef          	jal	8000403c <log_write>
  brelse(bp);
    800033dc:	854a                	mv	a0,s2
    800033de:	ab7ff0ef          	jal	80002e94 <brelse>
}
    800033e2:	60e2                	ld	ra,24(sp)
    800033e4:	6442                	ld	s0,16(sp)
    800033e6:	64a2                	ld	s1,8(sp)
    800033e8:	6902                	ld	s2,0(sp)
    800033ea:	6105                	addi	sp,sp,32
    800033ec:	8082                	ret

00000000800033ee <idup>:
{
    800033ee:	1101                	addi	sp,sp,-32
    800033f0:	ec06                	sd	ra,24(sp)
    800033f2:	e822                	sd	s0,16(sp)
    800033f4:	e426                	sd	s1,8(sp)
    800033f6:	1000                	addi	s0,sp,32
    800033f8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800033fa:	0001f517          	auipc	a0,0x1f
    800033fe:	99650513          	addi	a0,a0,-1642 # 80021d90 <itable>
    80003402:	fe6fd0ef          	jal	80000be8 <acquire>
  ip->ref++;
    80003406:	449c                	lw	a5,8(s1)
    80003408:	2785                	addiw	a5,a5,1
    8000340a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000340c:	0001f517          	auipc	a0,0x1f
    80003410:	98450513          	addi	a0,a0,-1660 # 80021d90 <itable>
    80003414:	85dfd0ef          	jal	80000c70 <release>
}
    80003418:	8526                	mv	a0,s1
    8000341a:	60e2                	ld	ra,24(sp)
    8000341c:	6442                	ld	s0,16(sp)
    8000341e:	64a2                	ld	s1,8(sp)
    80003420:	6105                	addi	sp,sp,32
    80003422:	8082                	ret

0000000080003424 <ilock>:
{
    80003424:	1101                	addi	sp,sp,-32
    80003426:	ec06                	sd	ra,24(sp)
    80003428:	e822                	sd	s0,16(sp)
    8000342a:	e426                	sd	s1,8(sp)
    8000342c:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    8000342e:	cd19                	beqz	a0,8000344c <ilock+0x28>
    80003430:	84aa                	mv	s1,a0
    80003432:	451c                	lw	a5,8(a0)
    80003434:	00f05c63          	blez	a5,8000344c <ilock+0x28>
  acquiresleep(&ip->lock);
    80003438:	0541                	addi	a0,a0,16
    8000343a:	571000ef          	jal	800041aa <acquiresleep>
  if (ip->valid == 0) {
    8000343e:	40bc                	lw	a5,64(s1)
    80003440:	cf89                	beqz	a5,8000345a <ilock+0x36>
}
    80003442:	60e2                	ld	ra,24(sp)
    80003444:	6442                	ld	s0,16(sp)
    80003446:	64a2                	ld	s1,8(sp)
    80003448:	6105                	addi	sp,sp,32
    8000344a:	8082                	ret
    8000344c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000344e:	00005517          	auipc	a0,0x5
    80003452:	02a50513          	addi	a0,a0,42 # 80008478 <etext+0x478>
    80003456:	bdefd0ef          	jal	80000834 <panic>
    8000345a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000345c:	40dc                	lw	a5,4(s1)
    8000345e:	0047d79b          	srliw	a5,a5,0x4
    80003462:	0001f597          	auipc	a1,0x1f
    80003466:	9265a583          	lw	a1,-1754(a1) # 80021d88 <sb+0x18>
    8000346a:	9dbd                	addw	a1,a1,a5
    8000346c:	4088                	lw	a0,0(s1)
    8000346e:	91fff0ef          	jal	80002d8c <bread>
    80003472:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003474:	05850593          	addi	a1,a0,88
    80003478:	40dc                	lw	a5,4(s1)
    8000347a:	8bbd                	andi	a5,a5,15
    8000347c:	079a                	slli	a5,a5,0x6
    8000347e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003480:	00059783          	lh	a5,0(a1)
    80003484:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003488:	00259783          	lh	a5,2(a1)
    8000348c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003490:	00459783          	lh	a5,4(a1)
    80003494:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003498:	00659783          	lh	a5,6(a1)
    8000349c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800034a0:	459c                	lw	a5,8(a1)
    800034a2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800034a4:	03400613          	li	a2,52
    800034a8:	05b1                	addi	a1,a1,12
    800034aa:	05048513          	addi	a0,s1,80
    800034ae:	85bfd0ef          	jal	80000d08 <memmove>
    brelse(bp);
    800034b2:	854a                	mv	a0,s2
    800034b4:	9e1ff0ef          	jal	80002e94 <brelse>
    ip->valid = 1;
    800034b8:	4785                	li	a5,1
    800034ba:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    800034bc:	04449783          	lh	a5,68(s1)
    800034c0:	c399                	beqz	a5,800034c6 <ilock+0xa2>
    800034c2:	6902                	ld	s2,0(sp)
    800034c4:	bfbd                	j	80003442 <ilock+0x1e>
      panic("ilock: no type");
    800034c6:	00005517          	auipc	a0,0x5
    800034ca:	fba50513          	addi	a0,a0,-70 # 80008480 <etext+0x480>
    800034ce:	b66fd0ef          	jal	80000834 <panic>

00000000800034d2 <iunlock>:
{
    800034d2:	1101                	addi	sp,sp,-32
    800034d4:	ec06                	sd	ra,24(sp)
    800034d6:	e822                	sd	s0,16(sp)
    800034d8:	e426                	sd	s1,8(sp)
    800034da:	e04a                	sd	s2,0(sp)
    800034dc:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800034de:	c505                	beqz	a0,80003506 <iunlock+0x34>
    800034e0:	84aa                	mv	s1,a0
    800034e2:	01050913          	addi	s2,a0,16
    800034e6:	854a                	mv	a0,s2
    800034e8:	54f000ef          	jal	80004236 <holdingsleep>
    800034ec:	cd09                	beqz	a0,80003506 <iunlock+0x34>
    800034ee:	449c                	lw	a5,8(s1)
    800034f0:	00f05b63          	blez	a5,80003506 <iunlock+0x34>
  releasesleep(&ip->lock);
    800034f4:	854a                	mv	a0,s2
    800034f6:	509000ef          	jal	800041fe <releasesleep>
}
    800034fa:	60e2                	ld	ra,24(sp)
    800034fc:	6442                	ld	s0,16(sp)
    800034fe:	64a2                	ld	s1,8(sp)
    80003500:	6902                	ld	s2,0(sp)
    80003502:	6105                	addi	sp,sp,32
    80003504:	8082                	ret
    panic("iunlock");
    80003506:	00005517          	auipc	a0,0x5
    8000350a:	f8a50513          	addi	a0,a0,-118 # 80008490 <etext+0x490>
    8000350e:	b26fd0ef          	jal	80000834 <panic>

0000000080003512 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003512:	7179                	addi	sp,sp,-48
    80003514:	f406                	sd	ra,40(sp)
    80003516:	f022                	sd	s0,32(sp)
    80003518:	ec26                	sd	s1,24(sp)
    8000351a:	e84a                	sd	s2,16(sp)
    8000351c:	e44e                	sd	s3,8(sp)
    8000351e:	1800                	addi	s0,sp,48
    80003520:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80003522:	05050493          	addi	s1,a0,80
    80003526:	08050913          	addi	s2,a0,128
    8000352a:	a021                	j	80003532 <itrunc+0x20>
    8000352c:	0491                	addi	s1,s1,4
    8000352e:	01248b63          	beq	s1,s2,80003544 <itrunc+0x32>
    if (ip->addrs[i]) {
    80003532:	408c                	lw	a1,0(s1)
    80003534:	dde5                	beqz	a1,8000352c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003536:	0009a503          	lw	a0,0(s3)
    8000353a:	a47ff0ef          	jal	80002f80 <bfree>
      ip->addrs[i] = 0;
    8000353e:	0004a023          	sw	zero,0(s1)
    80003542:	b7ed                	j	8000352c <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80003544:	0809a583          	lw	a1,128(s3)
    80003548:	ed89                	bnez	a1,80003562 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000354a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000354e:	854e                	mv	a0,s3
    80003550:	e21ff0ef          	jal	80003370 <iupdate>
}
    80003554:	70a2                	ld	ra,40(sp)
    80003556:	7402                	ld	s0,32(sp)
    80003558:	64e2                	ld	s1,24(sp)
    8000355a:	6942                	ld	s2,16(sp)
    8000355c:	69a2                	ld	s3,8(sp)
    8000355e:	6145                	addi	sp,sp,48
    80003560:	8082                	ret
    80003562:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003564:	0009a503          	lw	a0,0(s3)
    80003568:	825ff0ef          	jal	80002d8c <bread>
    8000356c:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    8000356e:	05850493          	addi	s1,a0,88
    80003572:	45850913          	addi	s2,a0,1112
    80003576:	a021                	j	8000357e <itrunc+0x6c>
    80003578:	0491                	addi	s1,s1,4
    8000357a:	01248963          	beq	s1,s2,8000358c <itrunc+0x7a>
      if (a[j])
    8000357e:	408c                	lw	a1,0(s1)
    80003580:	dde5                	beqz	a1,80003578 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003582:	0009a503          	lw	a0,0(s3)
    80003586:	9fbff0ef          	jal	80002f80 <bfree>
    8000358a:	b7fd                	j	80003578 <itrunc+0x66>
    brelse(bp);
    8000358c:	8552                	mv	a0,s4
    8000358e:	907ff0ef          	jal	80002e94 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003592:	0809a583          	lw	a1,128(s3)
    80003596:	0009a503          	lw	a0,0(s3)
    8000359a:	9e7ff0ef          	jal	80002f80 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000359e:	0809a023          	sw	zero,128(s3)
    800035a2:	6a02                	ld	s4,0(sp)
    800035a4:	b75d                	j	8000354a <itrunc+0x38>

00000000800035a6 <iput>:
{
    800035a6:	7179                	addi	sp,sp,-48
    800035a8:	f406                	sd	ra,40(sp)
    800035aa:	f022                	sd	s0,32(sp)
    800035ac:	ec26                	sd	s1,24(sp)
    800035ae:	1800                	addi	s0,sp,48
    800035b0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800035b2:	0001e517          	auipc	a0,0x1e
    800035b6:	7de50513          	addi	a0,a0,2014 # 80021d90 <itable>
    800035ba:	e2efd0ef          	jal	80000be8 <acquire>
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    800035be:	449c                	lw	a5,8(s1)
    800035c0:	4705                	li	a4,1
    800035c2:	00e78f63          	beq	a5,a4,800035e0 <iput+0x3a>
  ip->ref--;
    800035c6:	37fd                	addiw	a5,a5,-1
    800035c8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800035ca:	0001e517          	auipc	a0,0x1e
    800035ce:	7c650513          	addi	a0,a0,1990 # 80021d90 <itable>
    800035d2:	e9efd0ef          	jal	80000c70 <release>
}
    800035d6:	70a2                	ld	ra,40(sp)
    800035d8:	7402                	ld	s0,32(sp)
    800035da:	64e2                	ld	s1,24(sp)
    800035dc:	6145                	addi	sp,sp,48
    800035de:	8082                	ret
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    800035e0:	40b8                	lw	a4,64(s1)
    800035e2:	d375                	beqz	a4,800035c6 <iput+0x20>
    800035e4:	e84a                	sd	s2,16(sp)
    800035e6:	e052                	sd	s4,0(sp)
  uint dev = ip->dev, inum = ip->inum;
    800035e8:	0004aa03          	lw	s4,0(s1)
    800035ec:	0044a903          	lw	s2,4(s1)
  if (last) {
    800035f0:	04a49703          	lh	a4,74(s1)
    800035f4:	ef3d                	bnez	a4,80003672 <iput+0xcc>
    800035f6:	e44e                	sd	s3,8(sp)
    acquiresleep(&ip->lock);
    800035f8:	01048793          	addi	a5,s1,16
    800035fc:	89be                	mv	s3,a5
    800035fe:	853e                	mv	a0,a5
    80003600:	3ab000ef          	jal	800041aa <acquiresleep>
    release(&itable.lock);
    80003604:	0001e517          	auipc	a0,0x1e
    80003608:	78c50513          	addi	a0,a0,1932 # 80021d90 <itable>
    8000360c:	e64fd0ef          	jal	80000c70 <release>
    itrunc(ip); // free the data blocks (type stays nonzero on disk)
    80003610:	8526                	mv	a0,s1
    80003612:	f01ff0ef          	jal	80003512 <itrunc>
    ip->valid = 0;
    80003616:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000361a:	854e                	mv	a0,s3
    8000361c:	3e3000ef          	jal	800041fe <releasesleep>
    acquire(&itable.lock);
    80003620:	0001e517          	auipc	a0,0x1e
    80003624:	77050513          	addi	a0,a0,1904 # 80021d90 <itable>
    80003628:	dc0fd0ef          	jal	80000be8 <acquire>
  ip->ref--;
    8000362c:	449c                	lw	a5,8(s1)
    8000362e:	37fd                	addiw	a5,a5,-1
    80003630:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003632:	0001e517          	auipc	a0,0x1e
    80003636:	75e50513          	addi	a0,a0,1886 # 80021d90 <itable>
    8000363a:	e36fd0ef          	jal	80000c70 <release>
  struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000363e:	0049579b          	srliw	a5,s2,0x4
    80003642:	0001e597          	auipc	a1,0x1e
    80003646:	7465a583          	lw	a1,1862(a1) # 80021d88 <sb+0x18>
    8000364a:	9dbd                	addw	a1,a1,a5
    8000364c:	8552                	mv	a0,s4
    8000364e:	f3eff0ef          	jal	80002d8c <bread>
    80003652:	84aa                	mv	s1,a0
  struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003654:	00f97793          	andi	a5,s2,15
  dip->type = 0;
    80003658:	079a                	slli	a5,a5,0x6
    8000365a:	97aa                	add	a5,a5,a0
    8000365c:	04079c23          	sh	zero,88(a5)
  log_write(bp);
    80003660:	1dd000ef          	jal	8000403c <log_write>
  brelse(bp);
    80003664:	8526                	mv	a0,s1
    80003666:	82fff0ef          	jal	80002e94 <brelse>
}
    8000366a:	6942                	ld	s2,16(sp)
    8000366c:	69a2                	ld	s3,8(sp)
    8000366e:	6a02                	ld	s4,0(sp)
    80003670:	b79d                	j	800035d6 <iput+0x30>
    80003672:	6942                	ld	s2,16(sp)
    80003674:	6a02                	ld	s4,0(sp)
    80003676:	bf81                	j	800035c6 <iput+0x20>

0000000080003678 <iunlockput>:
{
    80003678:	1101                	addi	sp,sp,-32
    8000367a:	ec06                	sd	ra,24(sp)
    8000367c:	e822                	sd	s0,16(sp)
    8000367e:	e426                	sd	s1,8(sp)
    80003680:	1000                	addi	s0,sp,32
    80003682:	84aa                	mv	s1,a0
  iunlock(ip);
    80003684:	e4fff0ef          	jal	800034d2 <iunlock>
  iput(ip);
    80003688:	8526                	mv	a0,s1
    8000368a:	f1dff0ef          	jal	800035a6 <iput>
}
    8000368e:	60e2                	ld	ra,24(sp)
    80003690:	6442                	ld	s0,16(sp)
    80003692:	64a2                	ld	s1,8(sp)
    80003694:	6105                	addi	sp,sp,32
    80003696:	8082                	ret

0000000080003698 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003698:	0001e717          	auipc	a4,0x1e
    8000369c:	6e472703          	lw	a4,1764(a4) # 80021d7c <sb+0xc>
    800036a0:	4785                	li	a5,1
    800036a2:	0ae7fe63          	bgeu	a5,a4,8000375e <ireclaim+0xc6>
{
    800036a6:	7139                	addi	sp,sp,-64
    800036a8:	fc06                	sd	ra,56(sp)
    800036aa:	f822                	sd	s0,48(sp)
    800036ac:	f426                	sd	s1,40(sp)
    800036ae:	f04a                	sd	s2,32(sp)
    800036b0:	ec4e                	sd	s3,24(sp)
    800036b2:	e852                	sd	s4,16(sp)
    800036b4:	e456                	sd	s5,8(sp)
    800036b6:	e05a                	sd	s6,0(sp)
    800036b8:	0080                	addi	s0,sp,64
    800036ba:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800036bc:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800036be:	0001ea17          	auipc	s4,0x1e
    800036c2:	6b2a0a13          	addi	s4,s4,1714 # 80021d70 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    800036c6:	00005b17          	auipc	s6,0x5
    800036ca:	dd2b0b13          	addi	s6,s6,-558 # 80008498 <etext+0x498>
    800036ce:	a099                	j	80003714 <ireclaim+0x7c>
    800036d0:	85ce                	mv	a1,s3
    800036d2:	855a                	mv	a0,s6
    800036d4:	e37fc0ef          	jal	8000050a <printk>
      ip = iget(dev, inum);
    800036d8:	85ce                	mv	a1,s3
    800036da:	8556                	mv	a0,s5
    800036dc:	ad7ff0ef          	jal	800031b2 <iget>
    800036e0:	89aa                	mv	s3,a0
    brelse(bp);
    800036e2:	854a                	mv	a0,s2
    800036e4:	fb0ff0ef          	jal	80002e94 <brelse>
    if (ip) {
    800036e8:	00098f63          	beqz	s3,80003706 <ireclaim+0x6e>
      begin_op();
    800036ec:	7a2000ef          	jal	80003e8e <begin_op>
      ilock(ip);
    800036f0:	854e                	mv	a0,s3
    800036f2:	d33ff0ef          	jal	80003424 <ilock>
      iunlock(ip);
    800036f6:	854e                	mv	a0,s3
    800036f8:	ddbff0ef          	jal	800034d2 <iunlock>
      iput(ip);
    800036fc:	854e                	mv	a0,s3
    800036fe:	ea9ff0ef          	jal	800035a6 <iput>
      end_op();
    80003702:	019000ef          	jal	80003f1a <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003706:	0485                	addi	s1,s1,1
    80003708:	00ca2703          	lw	a4,12(s4)
    8000370c:	0004879b          	sext.w	a5,s1
    80003710:	02e7fd63          	bgeu	a5,a4,8000374a <ireclaim+0xb2>
    80003714:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003718:	0044d593          	srli	a1,s1,0x4
    8000371c:	018a2783          	lw	a5,24(s4)
    80003720:	9dbd                	addw	a1,a1,a5
    80003722:	8556                	mv	a0,s5
    80003724:	e68ff0ef          	jal	80002d8c <bread>
    80003728:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8000372a:	05850793          	addi	a5,a0,88
    8000372e:	00f9f713          	andi	a4,s3,15
    80003732:	071a                	slli	a4,a4,0x6
    80003734:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    80003736:	00079703          	lh	a4,0(a5)
    8000373a:	c701                	beqz	a4,80003742 <ireclaim+0xaa>
    8000373c:	00679783          	lh	a5,6(a5)
    80003740:	dbc1                	beqz	a5,800036d0 <ireclaim+0x38>
    brelse(bp);
    80003742:	854a                	mv	a0,s2
    80003744:	f50ff0ef          	jal	80002e94 <brelse>
    if (ip) {
    80003748:	bf7d                	j	80003706 <ireclaim+0x6e>
}
    8000374a:	70e2                	ld	ra,56(sp)
    8000374c:	7442                	ld	s0,48(sp)
    8000374e:	74a2                	ld	s1,40(sp)
    80003750:	7902                	ld	s2,32(sp)
    80003752:	69e2                	ld	s3,24(sp)
    80003754:	6a42                	ld	s4,16(sp)
    80003756:	6aa2                	ld	s5,8(sp)
    80003758:	6b02                	ld	s6,0(sp)
    8000375a:	6121                	addi	sp,sp,64
    8000375c:	8082                	ret
    8000375e:	8082                	ret

0000000080003760 <fsinit>:
{
    80003760:	1101                	addi	sp,sp,-32
    80003762:	ec06                	sd	ra,24(sp)
    80003764:	e822                	sd	s0,16(sp)
    80003766:	e426                	sd	s1,8(sp)
    80003768:	e04a                	sd	s2,0(sp)
    8000376a:	1000                	addi	s0,sp,32
    8000376c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000376e:	4585                	li	a1,1
    80003770:	e1cff0ef          	jal	80002d8c <bread>
    80003774:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003776:	02000613          	li	a2,32
    8000377a:	05850593          	addi	a1,a0,88
    8000377e:	0001e517          	auipc	a0,0x1e
    80003782:	5f250513          	addi	a0,a0,1522 # 80021d70 <sb>
    80003786:	d82fd0ef          	jal	80000d08 <memmove>
  brelse(bp);
    8000378a:	8526                	mv	a0,s1
    8000378c:	f08ff0ef          	jal	80002e94 <brelse>
  if (sb.magic != FSMAGIC)
    80003790:	0001e717          	auipc	a4,0x1e
    80003794:	5e072703          	lw	a4,1504(a4) # 80021d70 <sb>
    80003798:	102037b7          	lui	a5,0x10203
    8000379c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800037a0:	02f71263          	bne	a4,a5,800037c4 <fsinit+0x64>
  initlog(dev, &sb);
    800037a4:	0001e597          	auipc	a1,0x1e
    800037a8:	5cc58593          	addi	a1,a1,1484 # 80021d70 <sb>
    800037ac:	854a                	mv	a0,s2
    800037ae:	65e000ef          	jal	80003e0c <initlog>
  ireclaim(dev);
    800037b2:	854a                	mv	a0,s2
    800037b4:	ee5ff0ef          	jal	80003698 <ireclaim>
}
    800037b8:	60e2                	ld	ra,24(sp)
    800037ba:	6442                	ld	s0,16(sp)
    800037bc:	64a2                	ld	s1,8(sp)
    800037be:	6902                	ld	s2,0(sp)
    800037c0:	6105                	addi	sp,sp,32
    800037c2:	8082                	ret
    panic("invalid file system");
    800037c4:	00005517          	auipc	a0,0x5
    800037c8:	cf450513          	addi	a0,a0,-780 # 800084b8 <etext+0x4b8>
    800037cc:	868fd0ef          	jal	80000834 <panic>

00000000800037d0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800037d0:	1141                	addi	sp,sp,-16
    800037d2:	e406                	sd	ra,8(sp)
    800037d4:	e022                	sd	s0,0(sp)
    800037d6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800037d8:	411c                	lw	a5,0(a0)
    800037da:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800037dc:	415c                	lw	a5,4(a0)
    800037de:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800037e0:	04451783          	lh	a5,68(a0)
    800037e4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800037e8:	04a51783          	lh	a5,74(a0)
    800037ec:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800037f0:	04c56783          	lwu	a5,76(a0)
    800037f4:	e99c                	sd	a5,16(a1)
}
    800037f6:	60a2                	ld	ra,8(sp)
    800037f8:	6402                	ld	s0,0(sp)
    800037fa:	0141                	addi	sp,sp,16
    800037fc:	8082                	ret

00000000800037fe <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800037fe:	457c                	lw	a5,76(a0)
    80003800:	0ed7e663          	bltu	a5,a3,800038ec <readi+0xee>
{
    80003804:	7159                	addi	sp,sp,-112
    80003806:	f486                	sd	ra,104(sp)
    80003808:	f0a2                	sd	s0,96(sp)
    8000380a:	eca6                	sd	s1,88(sp)
    8000380c:	e0d2                	sd	s4,64(sp)
    8000380e:	fc56                	sd	s5,56(sp)
    80003810:	f85a                	sd	s6,48(sp)
    80003812:	f45e                	sd	s7,40(sp)
    80003814:	1880                	addi	s0,sp,112
    80003816:	8b2a                	mv	s6,a0
    80003818:	8bae                	mv	s7,a1
    8000381a:	8a32                	mv	s4,a2
    8000381c:	84b6                	mv	s1,a3
    8000381e:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    80003820:	9f35                	addw	a4,a4,a3
    return 0;
    80003822:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80003824:	0ad76b63          	bltu	a4,a3,800038da <readi+0xdc>
    80003828:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    8000382a:	00e7f463          	bgeu	a5,a4,80003832 <readi+0x34>
    n = ip->size - off;
    8000382e:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003832:	080a8b63          	beqz	s5,800038c8 <readi+0xca>
    80003836:	e8ca                	sd	s2,80(sp)
    80003838:	f062                	sd	s8,32(sp)
    8000383a:	ec66                	sd	s9,24(sp)
    8000383c:	e86a                	sd	s10,16(sp)
    8000383e:	e46e                	sd	s11,8(sp)
    80003840:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003842:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003846:	5c7d                	li	s8,-1
    80003848:	a80d                	j	8000387a <readi+0x7c>
    8000384a:	020d1d93          	slli	s11,s10,0x20
    8000384e:	020ddd93          	srli	s11,s11,0x20
    80003852:	05890613          	addi	a2,s2,88
    80003856:	86ee                	mv	a3,s11
    80003858:	963e                	add	a2,a2,a5
    8000385a:	85d2                	mv	a1,s4
    8000385c:	855e                	mv	a0,s7
    8000385e:	b21fe0ef          	jal	8000237e <either_copyout>
    80003862:	05850363          	beq	a0,s8,800038a8 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003866:	854a                	mv	a0,s2
    80003868:	e2cff0ef          	jal	80002e94 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000386c:	013d09bb          	addw	s3,s10,s3
    80003870:	009d04bb          	addw	s1,s10,s1
    80003874:	9a6e                	add	s4,s4,s11
    80003876:	0559f363          	bgeu	s3,s5,800038bc <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    8000387a:	00a4d59b          	srliw	a1,s1,0xa
    8000387e:	855a                	mv	a0,s6
    80003880:	873ff0ef          	jal	800030f2 <bmap>
    80003884:	85aa                	mv	a1,a0
    if (addr == 0)
    80003886:	c139                	beqz	a0,800038cc <readi+0xce>
    bp = bread(ip->dev, addr);
    80003888:	000b2503          	lw	a0,0(s6)
    8000388c:	d00ff0ef          	jal	80002d8c <bread>
    80003890:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003892:	3ff4f793          	andi	a5,s1,1023
    80003896:	40fc873b          	subw	a4,s9,a5
    8000389a:	413a86bb          	subw	a3,s5,s3
    8000389e:	8d3a                	mv	s10,a4
    800038a0:	fae6f5e3          	bgeu	a3,a4,8000384a <readi+0x4c>
    800038a4:	8d36                	mv	s10,a3
    800038a6:	b755                	j	8000384a <readi+0x4c>
      brelse(bp);
    800038a8:	854a                	mv	a0,s2
    800038aa:	deaff0ef          	jal	80002e94 <brelse>
      tot = -1;
    800038ae:	59fd                	li	s3,-1
      break;
    800038b0:	6946                	ld	s2,80(sp)
    800038b2:	7c02                	ld	s8,32(sp)
    800038b4:	6ce2                	ld	s9,24(sp)
    800038b6:	6d42                	ld	s10,16(sp)
    800038b8:	6da2                	ld	s11,8(sp)
    800038ba:	a831                	j	800038d6 <readi+0xd8>
    800038bc:	6946                	ld	s2,80(sp)
    800038be:	7c02                	ld	s8,32(sp)
    800038c0:	6ce2                	ld	s9,24(sp)
    800038c2:	6d42                	ld	s10,16(sp)
    800038c4:	6da2                	ld	s11,8(sp)
    800038c6:	a801                	j	800038d6 <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800038c8:	89d6                	mv	s3,s5
    800038ca:	a031                	j	800038d6 <readi+0xd8>
    800038cc:	6946                	ld	s2,80(sp)
    800038ce:	7c02                	ld	s8,32(sp)
    800038d0:	6ce2                	ld	s9,24(sp)
    800038d2:	6d42                	ld	s10,16(sp)
    800038d4:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800038d6:	854e                	mv	a0,s3
    800038d8:	69a6                	ld	s3,72(sp)
}
    800038da:	70a6                	ld	ra,104(sp)
    800038dc:	7406                	ld	s0,96(sp)
    800038de:	64e6                	ld	s1,88(sp)
    800038e0:	6a06                	ld	s4,64(sp)
    800038e2:	7ae2                	ld	s5,56(sp)
    800038e4:	7b42                	ld	s6,48(sp)
    800038e6:	7ba2                	ld	s7,40(sp)
    800038e8:	6165                	addi	sp,sp,112
    800038ea:	8082                	ret
    return 0;
    800038ec:	4501                	li	a0,0
}
    800038ee:	8082                	ret

00000000800038f0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800038f0:	457c                	lw	a5,76(a0)
    800038f2:	0ed7ee63          	bltu	a5,a3,800039ee <writei+0xfe>
{
    800038f6:	7159                	addi	sp,sp,-112
    800038f8:	f486                	sd	ra,104(sp)
    800038fa:	f0a2                	sd	s0,96(sp)
    800038fc:	e8ca                	sd	s2,80(sp)
    800038fe:	e0d2                	sd	s4,64(sp)
    80003900:	fc56                	sd	s5,56(sp)
    80003902:	f85a                	sd	s6,48(sp)
    80003904:	f45e                	sd	s7,40(sp)
    80003906:	1880                	addi	s0,sp,112
    80003908:	8aaa                	mv	s5,a0
    8000390a:	8bae                	mv	s7,a1
    8000390c:	8a32                	mv	s4,a2
    8000390e:	8936                	mv	s2,a3
    80003910:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80003912:	00e687bb          	addw	a5,a3,a4
    return -1;
  if (off + n > MAXFILE * BSIZE)
    80003916:	00043737          	lui	a4,0x43
    8000391a:	0cf76c63          	bltu	a4,a5,800039f2 <writei+0x102>
    8000391e:	0cd7ea63          	bltu	a5,a3,800039f2 <writei+0x102>
    80003922:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003924:	0a0b0d63          	beqz	s6,800039de <writei+0xee>
    80003928:	eca6                	sd	s1,88(sp)
    8000392a:	f062                	sd	s8,32(sp)
    8000392c:	ec66                	sd	s9,24(sp)
    8000392e:	e86a                	sd	s10,16(sp)
    80003930:	e46e                	sd	s11,8(sp)
    80003932:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003934:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003938:	5c7d                	li	s8,-1
    8000393a:	a825                	j	80003972 <writei+0x82>
    8000393c:	020d1d93          	slli	s11,s10,0x20
    80003940:	020ddd93          	srli	s11,s11,0x20
    80003944:	05848513          	addi	a0,s1,88
    80003948:	86ee                	mv	a3,s11
    8000394a:	8652                	mv	a2,s4
    8000394c:	85de                	mv	a1,s7
    8000394e:	953e                	add	a0,a0,a5
    80003950:	a7bfe0ef          	jal	800023ca <either_copyin>
    80003954:	05850663          	beq	a0,s8,800039a0 <writei+0xb0>
      // Might have partially updated the block, so we need to log it.
      log_write(bp);
      brelse(bp);
      break;
    }
    log_write(bp);
    80003958:	8526                	mv	a0,s1
    8000395a:	6e2000ef          	jal	8000403c <log_write>
    brelse(bp);
    8000395e:	8526                	mv	a0,s1
    80003960:	d34ff0ef          	jal	80002e94 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003964:	013d09bb          	addw	s3,s10,s3
    80003968:	012d093b          	addw	s2,s10,s2
    8000396c:	9a6e                	add	s4,s4,s11
    8000396e:	0369ff63          	bgeu	s3,s6,800039ac <writei+0xbc>
    uint addr = bmap(ip, off / BSIZE);
    80003972:	00a9559b          	srliw	a1,s2,0xa
    80003976:	8556                	mv	a0,s5
    80003978:	f7aff0ef          	jal	800030f2 <bmap>
    8000397c:	85aa                	mv	a1,a0
    if (addr == 0)
    8000397e:	c51d                	beqz	a0,800039ac <writei+0xbc>
    bp = bread(ip->dev, addr);
    80003980:	000aa503          	lw	a0,0(s5)
    80003984:	c08ff0ef          	jal	80002d8c <bread>
    80003988:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000398a:	3ff97793          	andi	a5,s2,1023
    8000398e:	40fc873b          	subw	a4,s9,a5
    80003992:	413b06bb          	subw	a3,s6,s3
    80003996:	8d3a                	mv	s10,a4
    80003998:	fae6f2e3          	bgeu	a3,a4,8000393c <writei+0x4c>
    8000399c:	8d36                	mv	s10,a3
    8000399e:	bf79                	j	8000393c <writei+0x4c>
      log_write(bp);
    800039a0:	8526                	mv	a0,s1
    800039a2:	69a000ef          	jal	8000403c <log_write>
      brelse(bp);
    800039a6:	8526                	mv	a0,s1
    800039a8:	cecff0ef          	jal	80002e94 <brelse>
  }

  if (off > ip->size)
    800039ac:	04caa783          	lw	a5,76(s5)
    800039b0:	0327f963          	bgeu	a5,s2,800039e2 <writei+0xf2>
    ip->size = off;
    800039b4:	052aa623          	sw	s2,76(s5)
    800039b8:	64e6                	ld	s1,88(sp)
    800039ba:	7c02                	ld	s8,32(sp)
    800039bc:	6ce2                	ld	s9,24(sp)
    800039be:	6d42                	ld	s10,16(sp)
    800039c0:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800039c2:	8556                	mv	a0,s5
    800039c4:	9adff0ef          	jal	80003370 <iupdate>

  return tot;
    800039c8:	854e                	mv	a0,s3
    800039ca:	69a6                	ld	s3,72(sp)
}
    800039cc:	70a6                	ld	ra,104(sp)
    800039ce:	7406                	ld	s0,96(sp)
    800039d0:	6946                	ld	s2,80(sp)
    800039d2:	6a06                	ld	s4,64(sp)
    800039d4:	7ae2                	ld	s5,56(sp)
    800039d6:	7b42                	ld	s6,48(sp)
    800039d8:	7ba2                	ld	s7,40(sp)
    800039da:	6165                	addi	sp,sp,112
    800039dc:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800039de:	89da                	mv	s3,s6
    800039e0:	b7cd                	j	800039c2 <writei+0xd2>
    800039e2:	64e6                	ld	s1,88(sp)
    800039e4:	7c02                	ld	s8,32(sp)
    800039e6:	6ce2                	ld	s9,24(sp)
    800039e8:	6d42                	ld	s10,16(sp)
    800039ea:	6da2                	ld	s11,8(sp)
    800039ec:	bfd9                	j	800039c2 <writei+0xd2>
    return -1;
    800039ee:	557d                	li	a0,-1
}
    800039f0:	8082                	ret
    return -1;
    800039f2:	557d                	li	a0,-1
    800039f4:	bfe1                	j	800039cc <writei+0xdc>

00000000800039f6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800039f6:	1141                	addi	sp,sp,-16
    800039f8:	e406                	sd	ra,8(sp)
    800039fa:	e022                	sd	s0,0(sp)
    800039fc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800039fe:	4639                	li	a2,14
    80003a00:	b7cfd0ef          	jal	80000d7c <strncmp>
}
    80003a04:	60a2                	ld	ra,8(sp)
    80003a06:	6402                	ld	s0,0(sp)
    80003a08:	0141                	addi	sp,sp,16
    80003a0a:	8082                	ret

0000000080003a0c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003a0c:	711d                	addi	sp,sp,-96
    80003a0e:	ec86                	sd	ra,88(sp)
    80003a10:	e8a2                	sd	s0,80(sp)
    80003a12:	e4a6                	sd	s1,72(sp)
    80003a14:	e0ca                	sd	s2,64(sp)
    80003a16:	fc4e                	sd	s3,56(sp)
    80003a18:	f852                	sd	s4,48(sp)
    80003a1a:	f456                	sd	s5,40(sp)
    80003a1c:	f05a                	sd	s6,32(sp)
    80003a1e:	ec5e                	sd	s7,24(sp)
    80003a20:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80003a22:	04451703          	lh	a4,68(a0)
    80003a26:	4785                	li	a5,1
    80003a28:	00f71f63          	bne	a4,a5,80003a46 <dirlookup+0x3a>
    80003a2c:	892a                	mv	s2,a0
    80003a2e:	8aae                	mv	s5,a1
    80003a30:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a32:	457c                	lw	a5,76(a0)
    80003a34:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a36:	fa040a13          	addi	s4,s0,-96
    80003a3a:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    80003a3c:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003a40:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a42:	e39d                	bnez	a5,80003a68 <dirlookup+0x5c>
    80003a44:	a8b9                	j	80003aa2 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003a46:	00005517          	auipc	a0,0x5
    80003a4a:	a8a50513          	addi	a0,a0,-1398 # 800084d0 <etext+0x4d0>
    80003a4e:	de7fc0ef          	jal	80000834 <panic>
      panic("dirlookup read");
    80003a52:	00005517          	auipc	a0,0x5
    80003a56:	a9650513          	addi	a0,a0,-1386 # 800084e8 <etext+0x4e8>
    80003a5a:	ddbfc0ef          	jal	80000834 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a5e:	24c1                	addiw	s1,s1,16
    80003a60:	04c92783          	lw	a5,76(s2)
    80003a64:	02f4fe63          	bgeu	s1,a5,80003aa0 <dirlookup+0x94>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a68:	874e                	mv	a4,s3
    80003a6a:	86a6                	mv	a3,s1
    80003a6c:	8652                	mv	a2,s4
    80003a6e:	4581                	li	a1,0
    80003a70:	854a                	mv	a0,s2
    80003a72:	d8dff0ef          	jal	800037fe <readi>
    80003a76:	fd351ee3          	bne	a0,s3,80003a52 <dirlookup+0x46>
    if (de.inum == 0)
    80003a7a:	fa045783          	lhu	a5,-96(s0)
    80003a7e:	d3e5                	beqz	a5,80003a5e <dirlookup+0x52>
    if (namecmp(name, de.name) == 0) {
    80003a80:	85da                	mv	a1,s6
    80003a82:	8556                	mv	a0,s5
    80003a84:	f73ff0ef          	jal	800039f6 <namecmp>
    80003a88:	f979                	bnez	a0,80003a5e <dirlookup+0x52>
      if (poff)
    80003a8a:	000b8463          	beqz	s7,80003a92 <dirlookup+0x86>
        *poff = off;
    80003a8e:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003a92:	fa045583          	lhu	a1,-96(s0)
    80003a96:	00092503          	lw	a0,0(s2)
    80003a9a:	f18ff0ef          	jal	800031b2 <iget>
    80003a9e:	a011                	j	80003aa2 <dirlookup+0x96>
  return 0;
    80003aa0:	4501                	li	a0,0
}
    80003aa2:	60e6                	ld	ra,88(sp)
    80003aa4:	6446                	ld	s0,80(sp)
    80003aa6:	64a6                	ld	s1,72(sp)
    80003aa8:	6906                	ld	s2,64(sp)
    80003aaa:	79e2                	ld	s3,56(sp)
    80003aac:	7a42                	ld	s4,48(sp)
    80003aae:	7aa2                	ld	s5,40(sp)
    80003ab0:	7b02                	ld	s6,32(sp)
    80003ab2:	6be2                	ld	s7,24(sp)
    80003ab4:	6125                	addi	sp,sp,96
    80003ab6:	8082                	ret

0000000080003ab8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003ab8:	711d                	addi	sp,sp,-96
    80003aba:	ec86                	sd	ra,88(sp)
    80003abc:	e8a2                	sd	s0,80(sp)
    80003abe:	e4a6                	sd	s1,72(sp)
    80003ac0:	e0ca                	sd	s2,64(sp)
    80003ac2:	fc4e                	sd	s3,56(sp)
    80003ac4:	f852                	sd	s4,48(sp)
    80003ac6:	f456                	sd	s5,40(sp)
    80003ac8:	f05a                	sd	s6,32(sp)
    80003aca:	ec5e                	sd	s7,24(sp)
    80003acc:	e862                	sd	s8,16(sp)
    80003ace:	e466                	sd	s9,8(sp)
    80003ad0:	e06a                	sd	s10,0(sp)
    80003ad2:	1080                	addi	s0,sp,96
    80003ad4:	84aa                	mv	s1,a0
    80003ad6:	8b2e                	mv	s6,a1
    80003ad8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003ada:	00054703          	lbu	a4,0(a0)
    80003ade:	02f00793          	li	a5,47
    80003ae2:	00f70f63          	beq	a4,a5,80003b00 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003ae6:	e43fd0ef          	jal	80001928 <myproc>
    80003aea:	15853503          	ld	a0,344(a0)
    80003aee:	901ff0ef          	jal	800033ee <idup>
    80003af2:	8a2a                	mv	s4,a0
  while (*path == '/')
    80003af4:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    80003af8:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003afa:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003afc:	4b85                	li	s7,1
    80003afe:	a07d                	j	80003bac <namex+0xf4>
    ip = iget(ROOTDEV, ROOTINO);
    80003b00:	4585                	li	a1,1
    80003b02:	852e                	mv	a0,a1
    80003b04:	eaeff0ef          	jal	800031b2 <iget>
    80003b08:	8a2a                	mv	s4,a0
    80003b0a:	b7ed                	j	80003af4 <namex+0x3c>
      iunlockput(ip);
    80003b0c:	8552                	mv	a0,s4
    80003b0e:	b6bff0ef          	jal	80003678 <iunlockput>
      return 0;
    80003b12:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80003b14:	8552                	mv	a0,s4
    80003b16:	60e6                	ld	ra,88(sp)
    80003b18:	6446                	ld	s0,80(sp)
    80003b1a:	64a6                	ld	s1,72(sp)
    80003b1c:	6906                	ld	s2,64(sp)
    80003b1e:	79e2                	ld	s3,56(sp)
    80003b20:	7a42                	ld	s4,48(sp)
    80003b22:	7aa2                	ld	s5,40(sp)
    80003b24:	7b02                	ld	s6,32(sp)
    80003b26:	6be2                	ld	s7,24(sp)
    80003b28:	6c42                	ld	s8,16(sp)
    80003b2a:	6ca2                	ld	s9,8(sp)
    80003b2c:	6d02                	ld	s10,0(sp)
    80003b2e:	6125                	addi	sp,sp,96
    80003b30:	8082                	ret
      iunlockput(ip);
    80003b32:	8552                	mv	a0,s4
    80003b34:	b45ff0ef          	jal	80003678 <iunlockput>
      return 0;
    80003b38:	4a01                	li	s4,0
    80003b3a:	bfe9                	j	80003b14 <namex+0x5c>
      iunlock(ip);
    80003b3c:	8552                	mv	a0,s4
    80003b3e:	995ff0ef          	jal	800034d2 <iunlock>
      return ip;
    80003b42:	bfc9                	j	80003b14 <namex+0x5c>
      iunlockput(ip);
    80003b44:	8552                	mv	a0,s4
    80003b46:	b33ff0ef          	jal	80003678 <iunlockput>
      return 0;
    80003b4a:	8a4a                	mv	s4,s2
    80003b4c:	b7e1                	j	80003b14 <namex+0x5c>
  len = path - s;
    80003b4e:	40990633          	sub	a2,s2,s1
    80003b52:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80003b56:	09ac5763          	bge	s8,s10,80003be4 <namex+0x12c>
    memmove(name, s, DIRSIZ);
    80003b5a:	8666                	mv	a2,s9
    80003b5c:	85a6                	mv	a1,s1
    80003b5e:	8556                	mv	a0,s5
    80003b60:	9a8fd0ef          	jal	80000d08 <memmove>
    80003b64:	84ca                	mv	s1,s2
  while (*path == '/')
    80003b66:	0004c783          	lbu	a5,0(s1)
    80003b6a:	01379763          	bne	a5,s3,80003b78 <namex+0xc0>
    path++;
    80003b6e:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003b70:	0004c783          	lbu	a5,0(s1)
    80003b74:	ff378de3          	beq	a5,s3,80003b6e <namex+0xb6>
    ilock(ip);
    80003b78:	8552                	mv	a0,s4
    80003b7a:	8abff0ef          	jal	80003424 <ilock>
    if (ip->type != T_DIR) {
    80003b7e:	044a1783          	lh	a5,68(s4)
    80003b82:	f97795e3          	bne	a5,s7,80003b0c <namex+0x54>
    if (ip->nlink == 0) {
    80003b86:	04aa1783          	lh	a5,74(s4)
    80003b8a:	d7c5                	beqz	a5,80003b32 <namex+0x7a>
    if (nameiparent && *path == '\0') {
    80003b8c:	000b0563          	beqz	s6,80003b96 <namex+0xde>
    80003b90:	0004c783          	lbu	a5,0(s1)
    80003b94:	d7c5                	beqz	a5,80003b3c <namex+0x84>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003b96:	4601                	li	a2,0
    80003b98:	85d6                	mv	a1,s5
    80003b9a:	8552                	mv	a0,s4
    80003b9c:	e71ff0ef          	jal	80003a0c <dirlookup>
    80003ba0:	892a                	mv	s2,a0
    80003ba2:	d14d                	beqz	a0,80003b44 <namex+0x8c>
    iunlockput(ip);
    80003ba4:	8552                	mv	a0,s4
    80003ba6:	ad3ff0ef          	jal	80003678 <iunlockput>
    ip = next;
    80003baa:	8a4a                	mv	s4,s2
  while (*path == '/')
    80003bac:	0004c783          	lbu	a5,0(s1)
    80003bb0:	01379763          	bne	a5,s3,80003bbe <namex+0x106>
    path++;
    80003bb4:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003bb6:	0004c783          	lbu	a5,0(s1)
    80003bba:	ff378de3          	beq	a5,s3,80003bb4 <namex+0xfc>
  if (*path == 0)
    80003bbe:	cf8d                	beqz	a5,80003bf8 <namex+0x140>
  while (*path != '/' && *path != 0)
    80003bc0:	0004c783          	lbu	a5,0(s1)
    80003bc4:	fd178713          	addi	a4,a5,-47
    80003bc8:	cb19                	beqz	a4,80003bde <namex+0x126>
    80003bca:	cb91                	beqz	a5,80003bde <namex+0x126>
    80003bcc:	8926                	mv	s2,s1
    path++;
    80003bce:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    80003bd0:	00094783          	lbu	a5,0(s2)
    80003bd4:	fd178713          	addi	a4,a5,-47
    80003bd8:	db3d                	beqz	a4,80003b4e <namex+0x96>
    80003bda:	fbf5                	bnez	a5,80003bce <namex+0x116>
    80003bdc:	bf8d                	j	80003b4e <namex+0x96>
    80003bde:	8926                	mv	s2,s1
  len = path - s;
    80003be0:	4d01                	li	s10,0
    80003be2:	4601                	li	a2,0
    memmove(name, s, len);
    80003be4:	2601                	sext.w	a2,a2
    80003be6:	85a6                	mv	a1,s1
    80003be8:	8556                	mv	a0,s5
    80003bea:	91efd0ef          	jal	80000d08 <memmove>
    name[len] = 0;
    80003bee:	9d56                	add	s10,s10,s5
    80003bf0:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffda370>
    80003bf4:	84ca                	mv	s1,s2
    80003bf6:	bf85                	j	80003b66 <namex+0xae>
  if (nameiparent) {
    80003bf8:	f00b0ee3          	beqz	s6,80003b14 <namex+0x5c>
    iput(ip);
    80003bfc:	8552                	mv	a0,s4
    80003bfe:	9a9ff0ef          	jal	800035a6 <iput>
    return 0;
    80003c02:	4a01                	li	s4,0
    80003c04:	bf01                	j	80003b14 <namex+0x5c>

0000000080003c06 <dirlink>:
{
    80003c06:	715d                	addi	sp,sp,-80
    80003c08:	e486                	sd	ra,72(sp)
    80003c0a:	e0a2                	sd	s0,64(sp)
    80003c0c:	f84a                	sd	s2,48(sp)
    80003c0e:	ec56                	sd	s5,24(sp)
    80003c10:	e85a                	sd	s6,16(sp)
    80003c12:	0880                	addi	s0,sp,80
    80003c14:	892a                	mv	s2,a0
    80003c16:	8aae                	mv	s5,a1
    80003c18:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003c1a:	4601                	li	a2,0
    80003c1c:	df1ff0ef          	jal	80003a0c <dirlookup>
    80003c20:	ed1d                	bnez	a0,80003c5e <dirlink+0x58>
    80003c22:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003c24:	04c92483          	lw	s1,76(s2)
    80003c28:	c4b9                	beqz	s1,80003c76 <dirlink+0x70>
    80003c2a:	f44e                	sd	s3,40(sp)
    80003c2c:	f052                	sd	s4,32(sp)
    80003c2e:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c30:	fb040a13          	addi	s4,s0,-80
    80003c34:	49c1                	li	s3,16
    80003c36:	874e                	mv	a4,s3
    80003c38:	86a6                	mv	a3,s1
    80003c3a:	8652                	mv	a2,s4
    80003c3c:	4581                	li	a1,0
    80003c3e:	854a                	mv	a0,s2
    80003c40:	bbfff0ef          	jal	800037fe <readi>
    80003c44:	03351163          	bne	a0,s3,80003c66 <dirlink+0x60>
    if (de.inum == 0)
    80003c48:	fb045783          	lhu	a5,-80(s0)
    80003c4c:	c39d                	beqz	a5,80003c72 <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003c4e:	24c1                	addiw	s1,s1,16
    80003c50:	04c92783          	lw	a5,76(s2)
    80003c54:	fef4e1e3          	bltu	s1,a5,80003c36 <dirlink+0x30>
    80003c58:	79a2                	ld	s3,40(sp)
    80003c5a:	7a02                	ld	s4,32(sp)
    80003c5c:	a829                	j	80003c76 <dirlink+0x70>
    iput(ip);
    80003c5e:	949ff0ef          	jal	800035a6 <iput>
    return -1;
    80003c62:	557d                	li	a0,-1
    80003c64:	a83d                	j	80003ca2 <dirlink+0x9c>
      panic("dirlink read");
    80003c66:	00005517          	auipc	a0,0x5
    80003c6a:	89250513          	addi	a0,a0,-1902 # 800084f8 <etext+0x4f8>
    80003c6e:	bc7fc0ef          	jal	80000834 <panic>
    80003c72:	79a2                	ld	s3,40(sp)
    80003c74:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003c76:	4639                	li	a2,14
    80003c78:	85d6                	mv	a1,s5
    80003c7a:	fb240513          	addi	a0,s0,-78
    80003c7e:	938fd0ef          	jal	80000db6 <strncpy>
  de.inum = inum;
    80003c82:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c86:	4741                	li	a4,16
    80003c88:	86a6                	mv	a3,s1
    80003c8a:	fb040613          	addi	a2,s0,-80
    80003c8e:	4581                	li	a1,0
    80003c90:	854a                	mv	a0,s2
    80003c92:	c5fff0ef          	jal	800038f0 <writei>
    80003c96:	1541                	addi	a0,a0,-16
    80003c98:	00a03533          	snez	a0,a0
    80003c9c:	40a0053b          	negw	a0,a0
    80003ca0:	74e2                	ld	s1,56(sp)
}
    80003ca2:	60a6                	ld	ra,72(sp)
    80003ca4:	6406                	ld	s0,64(sp)
    80003ca6:	7942                	ld	s2,48(sp)
    80003ca8:	6ae2                	ld	s5,24(sp)
    80003caa:	6b42                	ld	s6,16(sp)
    80003cac:	6161                	addi	sp,sp,80
    80003cae:	8082                	ret

0000000080003cb0 <namei>:

struct inode *
namei(char *path)
{
    80003cb0:	1101                	addi	sp,sp,-32
    80003cb2:	ec06                	sd	ra,24(sp)
    80003cb4:	e822                	sd	s0,16(sp)
    80003cb6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003cb8:	fe040613          	addi	a2,s0,-32
    80003cbc:	4581                	li	a1,0
    80003cbe:	dfbff0ef          	jal	80003ab8 <namex>
}
    80003cc2:	60e2                	ld	ra,24(sp)
    80003cc4:	6442                	ld	s0,16(sp)
    80003cc6:	6105                	addi	sp,sp,32
    80003cc8:	8082                	ret

0000000080003cca <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003cca:	1141                	addi	sp,sp,-16
    80003ccc:	e406                	sd	ra,8(sp)
    80003cce:	e022                	sd	s0,0(sp)
    80003cd0:	0800                	addi	s0,sp,16
    80003cd2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003cd4:	4585                	li	a1,1
    80003cd6:	de3ff0ef          	jal	80003ab8 <namex>
}
    80003cda:	60a2                	ld	ra,8(sp)
    80003cdc:	6402                	ld	s0,0(sp)
    80003cde:	0141                	addi	sp,sp,16
    80003ce0:	8082                	ret

0000000080003ce2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003ce2:	1101                	addi	sp,sp,-32
    80003ce4:	ec06                	sd	ra,24(sp)
    80003ce6:	e822                	sd	s0,16(sp)
    80003ce8:	e426                	sd	s1,8(sp)
    80003cea:	e04a                	sd	s2,0(sp)
    80003cec:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003cee:	00020917          	auipc	s2,0x20
    80003cf2:	b4a90913          	addi	s2,s2,-1206 # 80023838 <log>
    80003cf6:	01892583          	lw	a1,24(s2)
    80003cfa:	02492503          	lw	a0,36(s2)
    80003cfe:	88eff0ef          	jal	80002d8c <bread>
    80003d02:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003d04:	02c92603          	lw	a2,44(s2)
    80003d08:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003d0a:	00c05f63          	blez	a2,80003d28 <write_head+0x46>
    80003d0e:	00020717          	auipc	a4,0x20
    80003d12:	b5a70713          	addi	a4,a4,-1190 # 80023868 <log+0x30>
    80003d16:	87aa                	mv	a5,a0
    80003d18:	060a                	slli	a2,a2,0x2
    80003d1a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003d1c:	4314                	lw	a3,0(a4)
    80003d1e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003d20:	0711                	addi	a4,a4,4
    80003d22:	0791                	addi	a5,a5,4
    80003d24:	fec79ce3          	bne	a5,a2,80003d1c <write_head+0x3a>
  }
  bwrite(buf);
    80003d28:	8526                	mv	a0,s1
    80003d2a:	938ff0ef          	jal	80002e62 <bwrite>
  brelse(buf);
    80003d2e:	8526                	mv	a0,s1
    80003d30:	964ff0ef          	jal	80002e94 <brelse>
}
    80003d34:	60e2                	ld	ra,24(sp)
    80003d36:	6442                	ld	s0,16(sp)
    80003d38:	64a2                	ld	s1,8(sp)
    80003d3a:	6902                	ld	s2,0(sp)
    80003d3c:	6105                	addi	sp,sp,32
    80003d3e:	8082                	ret

0000000080003d40 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d40:	00020797          	auipc	a5,0x20
    80003d44:	b247a783          	lw	a5,-1244(a5) # 80023864 <log+0x2c>
    80003d48:	0cf05163          	blez	a5,80003e0a <install_trans+0xca>
{
    80003d4c:	715d                	addi	sp,sp,-80
    80003d4e:	e486                	sd	ra,72(sp)
    80003d50:	e0a2                	sd	s0,64(sp)
    80003d52:	fc26                	sd	s1,56(sp)
    80003d54:	f84a                	sd	s2,48(sp)
    80003d56:	f44e                	sd	s3,40(sp)
    80003d58:	f052                	sd	s4,32(sp)
    80003d5a:	ec56                	sd	s5,24(sp)
    80003d5c:	e85a                	sd	s6,16(sp)
    80003d5e:	e45e                	sd	s7,8(sp)
    80003d60:	e062                	sd	s8,0(sp)
    80003d62:	0880                	addi	s0,sp,80
    80003d64:	8b2a                	mv	s6,a0
    80003d66:	00020a97          	auipc	s5,0x20
    80003d6a:	b02a8a93          	addi	s5,s5,-1278 # 80023868 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d6e:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003d70:	00004c17          	auipc	s8,0x4
    80003d74:	798c0c13          	addi	s8,s8,1944 # 80008508 <etext+0x508>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003d78:	00020a17          	auipc	s4,0x20
    80003d7c:	ac0a0a13          	addi	s4,s4,-1344 # 80023838 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003d80:	40000b93          	li	s7,1024
    80003d84:	a025                	j	80003dac <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003d86:	000aa603          	lw	a2,0(s5)
    80003d8a:	85ce                	mv	a1,s3
    80003d8c:	8562                	mv	a0,s8
    80003d8e:	f7cfc0ef          	jal	8000050a <printk>
    80003d92:	a839                	j	80003db0 <install_trans+0x70>
    brelse(lbuf);
    80003d94:	854a                	mv	a0,s2
    80003d96:	8feff0ef          	jal	80002e94 <brelse>
    brelse(dbuf);
    80003d9a:	8526                	mv	a0,s1
    80003d9c:	8f8ff0ef          	jal	80002e94 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003da0:	2985                	addiw	s3,s3,1
    80003da2:	0a91                	addi	s5,s5,4
    80003da4:	02ca2783          	lw	a5,44(s4)
    80003da8:	04f9d563          	bge	s3,a5,80003df2 <install_trans+0xb2>
    if (recovering) {
    80003dac:	fc0b1de3          	bnez	s6,80003d86 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003db0:	018a2583          	lw	a1,24(s4)
    80003db4:	013585bb          	addw	a1,a1,s3
    80003db8:	2585                	addiw	a1,a1,1
    80003dba:	024a2503          	lw	a0,36(s4)
    80003dbe:	fcffe0ef          	jal	80002d8c <bread>
    80003dc2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003dc4:	000aa583          	lw	a1,0(s5)
    80003dc8:	024a2503          	lw	a0,36(s4)
    80003dcc:	fc1fe0ef          	jal	80002d8c <bread>
    80003dd0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003dd2:	865e                	mv	a2,s7
    80003dd4:	05890593          	addi	a1,s2,88
    80003dd8:	05850513          	addi	a0,a0,88
    80003ddc:	f2dfc0ef          	jal	80000d08 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80003de0:	8526                	mv	a0,s1
    80003de2:	880ff0ef          	jal	80002e62 <bwrite>
    if (recovering == 0)
    80003de6:	fa0b17e3          	bnez	s6,80003d94 <install_trans+0x54>
      bunpin(dbuf);
    80003dea:	8526                	mv	a0,s1
    80003dec:	960ff0ef          	jal	80002f4c <bunpin>
    80003df0:	b755                	j	80003d94 <install_trans+0x54>
}
    80003df2:	60a6                	ld	ra,72(sp)
    80003df4:	6406                	ld	s0,64(sp)
    80003df6:	74e2                	ld	s1,56(sp)
    80003df8:	7942                	ld	s2,48(sp)
    80003dfa:	79a2                	ld	s3,40(sp)
    80003dfc:	7a02                	ld	s4,32(sp)
    80003dfe:	6ae2                	ld	s5,24(sp)
    80003e00:	6b42                	ld	s6,16(sp)
    80003e02:	6ba2                	ld	s7,8(sp)
    80003e04:	6c02                	ld	s8,0(sp)
    80003e06:	6161                	addi	sp,sp,80
    80003e08:	8082                	ret
    80003e0a:	8082                	ret

0000000080003e0c <initlog>:
{
    80003e0c:	7179                	addi	sp,sp,-48
    80003e0e:	f406                	sd	ra,40(sp)
    80003e10:	f022                	sd	s0,32(sp)
    80003e12:	ec26                	sd	s1,24(sp)
    80003e14:	e84a                	sd	s2,16(sp)
    80003e16:	e44e                	sd	s3,8(sp)
    80003e18:	1800                	addi	s0,sp,48
    80003e1a:	84aa                	mv	s1,a0
    80003e1c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003e1e:	00020917          	auipc	s2,0x20
    80003e22:	a1a90913          	addi	s2,s2,-1510 # 80023838 <log>
    80003e26:	00004597          	auipc	a1,0x4
    80003e2a:	70258593          	addi	a1,a1,1794 # 80008528 <etext+0x528>
    80003e2e:	854a                	mv	a0,s2
    80003e30:	d39fc0ef          	jal	80000b68 <initlock>
  log.start = sb->logstart;
    80003e34:	0149a583          	lw	a1,20(s3)
    80003e38:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003e3c:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003e40:	8526                	mv	a0,s1
    80003e42:	f4bfe0ef          	jal	80002d8c <bread>
  log.lh.n = lh->n;
    80003e46:	4d30                	lw	a2,88(a0)
    80003e48:	02c92623          	sw	a2,44(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003e4c:	00c05f63          	blez	a2,80003e6a <initlog+0x5e>
    80003e50:	87aa                	mv	a5,a0
    80003e52:	00020717          	auipc	a4,0x20
    80003e56:	a1670713          	addi	a4,a4,-1514 # 80023868 <log+0x30>
    80003e5a:	060a                	slli	a2,a2,0x2
    80003e5c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003e5e:	4ff4                	lw	a3,92(a5)
    80003e60:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003e62:	0791                	addi	a5,a5,4
    80003e64:	0711                	addi	a4,a4,4
    80003e66:	fec79ce3          	bne	a5,a2,80003e5e <initlog+0x52>
  brelse(buf);
    80003e6a:	82aff0ef          	jal	80002e94 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003e6e:	4505                	li	a0,1
    80003e70:	ed1ff0ef          	jal	80003d40 <install_trans>
  log.lh.n = 0;
    80003e74:	00020797          	auipc	a5,0x20
    80003e78:	9e07a823          	sw	zero,-1552(a5) # 80023864 <log+0x2c>
  write_head(); // clear the log
    80003e7c:	e67ff0ef          	jal	80003ce2 <write_head>
}
    80003e80:	70a2                	ld	ra,40(sp)
    80003e82:	7402                	ld	s0,32(sp)
    80003e84:	64e2                	ld	s1,24(sp)
    80003e86:	6942                	ld	s2,16(sp)
    80003e88:	69a2                	ld	s3,8(sp)
    80003e8a:	6145                	addi	sp,sp,48
    80003e8c:	8082                	ret

0000000080003e8e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003e8e:	1101                	addi	sp,sp,-32
    80003e90:	ec06                	sd	ra,24(sp)
    80003e92:	e822                	sd	s0,16(sp)
    80003e94:	e426                	sd	s1,8(sp)
    80003e96:	e04a                	sd	s2,0(sp)
    80003e98:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003e9a:	00020517          	auipc	a0,0x20
    80003e9e:	99e50513          	addi	a0,a0,-1634 # 80023838 <log>
    80003ea2:	d47fc0ef          	jal	80000be8 <acquire>
  while (1) {
    if (log.committing) {
    80003ea6:	00020497          	auipc	s1,0x20
    80003eaa:	99248493          	addi	s1,s1,-1646 # 80023838 <log>
      sleep_prepare(&log);
      release(&log.lock);
      sleep();
      acquire(&log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003eae:	4979                	li	s2,30
    80003eb0:	a821                	j	80003ec8 <begin_op+0x3a>
      sleep_prepare(&log);
    80003eb2:	8526                	mv	a0,s1
    80003eb4:	93efe0ef          	jal	80001ff2 <sleep_prepare>
      release(&log.lock);
    80003eb8:	8526                	mv	a0,s1
    80003eba:	db7fc0ef          	jal	80000c70 <release>
      sleep();
    80003ebe:	970fe0ef          	jal	8000202e <sleep>
      acquire(&log.lock);
    80003ec2:	8526                	mv	a0,s1
    80003ec4:	d25fc0ef          	jal	80000be8 <acquire>
    if (log.committing) {
    80003ec8:	509c                	lw	a5,32(s1)
    80003eca:	f7e5                	bnez	a5,80003eb2 <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003ecc:	4cd8                	lw	a4,28(s1)
    80003ece:	2705                	addiw	a4,a4,1
    80003ed0:	0027179b          	slliw	a5,a4,0x2
    80003ed4:	9fb9                	addw	a5,a5,a4
    80003ed6:	0017979b          	slliw	a5,a5,0x1
    80003eda:	54d4                	lw	a3,44(s1)
    80003edc:	9fb5                	addw	a5,a5,a3
    80003ede:	00f95e63          	bge	s2,a5,80003efa <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep_prepare(&log);
    80003ee2:	8526                	mv	a0,s1
    80003ee4:	90efe0ef          	jal	80001ff2 <sleep_prepare>
      release(&log.lock);
    80003ee8:	8526                	mv	a0,s1
    80003eea:	d87fc0ef          	jal	80000c70 <release>
      sleep();
    80003eee:	940fe0ef          	jal	8000202e <sleep>
      acquire(&log.lock);
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	cf5fc0ef          	jal	80000be8 <acquire>
    80003ef8:	bfc1                	j	80003ec8 <begin_op+0x3a>
    } else {
      log.outstanding += 1;
    80003efa:	00020797          	auipc	a5,0x20
    80003efe:	94e7ad23          	sw	a4,-1702(a5) # 80023854 <log+0x1c>
      release(&log.lock);
    80003f02:	00020517          	auipc	a0,0x20
    80003f06:	93650513          	addi	a0,a0,-1738 # 80023838 <log>
    80003f0a:	d67fc0ef          	jal	80000c70 <release>
      break;
    }
  }
}
    80003f0e:	60e2                	ld	ra,24(sp)
    80003f10:	6442                	ld	s0,16(sp)
    80003f12:	64a2                	ld	s1,8(sp)
    80003f14:	6902                	ld	s2,0(sp)
    80003f16:	6105                	addi	sp,sp,32
    80003f18:	8082                	ret

0000000080003f1a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003f1a:	7139                	addi	sp,sp,-64
    80003f1c:	fc06                	sd	ra,56(sp)
    80003f1e:	f822                	sd	s0,48(sp)
    80003f20:	f426                	sd	s1,40(sp)
    80003f22:	f04a                	sd	s2,32(sp)
    80003f24:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003f26:	00020497          	auipc	s1,0x20
    80003f2a:	91248493          	addi	s1,s1,-1774 # 80023838 <log>
    80003f2e:	8526                	mv	a0,s1
    80003f30:	cb9fc0ef          	jal	80000be8 <acquire>
  log.outstanding -= 1;
    80003f34:	4cdc                	lw	a5,28(s1)
    80003f36:	37fd                	addiw	a5,a5,-1
    80003f38:	893e                	mv	s2,a5
    80003f3a:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    80003f3c:	509c                	lw	a5,32(s1)
    80003f3e:	e3b1                	bnez	a5,80003f82 <end_op+0x68>
    panic("log.committing");
  if (log.outstanding == 0) {
    80003f40:	04091a63          	bnez	s2,80003f94 <end_op+0x7a>
    do_commit = 1;
    log.committing = 1;
    80003f44:	00020497          	auipc	s1,0x20
    80003f48:	8f448493          	addi	s1,s1,-1804 # 80023838 <log>
    80003f4c:	4785                	li	a5,1
    80003f4e:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003f50:	8526                	mv	a0,s1
    80003f52:	d1ffc0ef          	jal	80000c70 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003f56:	54dc                	lw	a5,44(s1)
    80003f58:	06f04063          	bgtz	a5,80003fb8 <end_op+0x9e>
    acquire(&log.lock);
    80003f5c:	00020497          	auipc	s1,0x20
    80003f60:	8dc48493          	addi	s1,s1,-1828 # 80023838 <log>
    80003f64:	8526                	mv	a0,s1
    80003f66:	c83fc0ef          	jal	80000be8 <acquire>
    log.committing = 0;
    80003f6a:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    80003f6e:	549c                	lw	a5,40(s1)
    80003f70:	2785                	addiw	a5,a5,1
    80003f72:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80003f74:	8526                	mv	a0,s1
    80003f76:	8e8fe0ef          	jal	8000205e <wakeup>
    release(&log.lock);
    80003f7a:	8526                	mv	a0,s1
    80003f7c:	cf5fc0ef          	jal	80000c70 <release>
}
    80003f80:	a035                	j	80003fac <end_op+0x92>
    80003f82:	ec4e                	sd	s3,24(sp)
    80003f84:	e852                	sd	s4,16(sp)
    80003f86:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003f88:	00004517          	auipc	a0,0x4
    80003f8c:	5a850513          	addi	a0,a0,1448 # 80008530 <etext+0x530>
    80003f90:	8a5fc0ef          	jal	80000834 <panic>
    wakeup(&log);
    80003f94:	00020517          	auipc	a0,0x20
    80003f98:	8a450513          	addi	a0,a0,-1884 # 80023838 <log>
    80003f9c:	8c2fe0ef          	jal	8000205e <wakeup>
  release(&log.lock);
    80003fa0:	00020517          	auipc	a0,0x20
    80003fa4:	89850513          	addi	a0,a0,-1896 # 80023838 <log>
    80003fa8:	cc9fc0ef          	jal	80000c70 <release>
}
    80003fac:	70e2                	ld	ra,56(sp)
    80003fae:	7442                	ld	s0,48(sp)
    80003fb0:	74a2                	ld	s1,40(sp)
    80003fb2:	7902                	ld	s2,32(sp)
    80003fb4:	6121                	addi	sp,sp,64
    80003fb6:	8082                	ret
    80003fb8:	ec4e                	sd	s3,24(sp)
    80003fba:	e852                	sd	s4,16(sp)
    80003fbc:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fbe:	00020a97          	auipc	s5,0x20
    80003fc2:	8aaa8a93          	addi	s5,s5,-1878 # 80023868 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80003fc6:	00020a17          	auipc	s4,0x20
    80003fca:	872a0a13          	addi	s4,s4,-1934 # 80023838 <log>
    80003fce:	018a2583          	lw	a1,24(s4)
    80003fd2:	012585bb          	addw	a1,a1,s2
    80003fd6:	2585                	addiw	a1,a1,1
    80003fd8:	024a2503          	lw	a0,36(s4)
    80003fdc:	db1fe0ef          	jal	80002d8c <bread>
    80003fe0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003fe2:	000aa583          	lw	a1,0(s5)
    80003fe6:	024a2503          	lw	a0,36(s4)
    80003fea:	da3fe0ef          	jal	80002d8c <bread>
    80003fee:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003ff0:	40000613          	li	a2,1024
    80003ff4:	05850593          	addi	a1,a0,88
    80003ff8:	05848513          	addi	a0,s1,88
    80003ffc:	d0dfc0ef          	jal	80000d08 <memmove>
    bwrite(to); // write the log
    80004000:	8526                	mv	a0,s1
    80004002:	e61fe0ef          	jal	80002e62 <bwrite>
    brelse(from);
    80004006:	854e                	mv	a0,s3
    80004008:	e8dfe0ef          	jal	80002e94 <brelse>
    brelse(to);
    8000400c:	8526                	mv	a0,s1
    8000400e:	e87fe0ef          	jal	80002e94 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004012:	2905                	addiw	s2,s2,1
    80004014:	0a91                	addi	s5,s5,4
    80004016:	02ca2783          	lw	a5,44(s4)
    8000401a:	faf94ae3          	blt	s2,a5,80003fce <end_op+0xb4>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    8000401e:	cc5ff0ef          	jal	80003ce2 <write_head>
    install_trans(0); // Now install writes to home locations
    80004022:	4501                	li	a0,0
    80004024:	d1dff0ef          	jal	80003d40 <install_trans>
    log.lh.n = 0;
    80004028:	00020797          	auipc	a5,0x20
    8000402c:	8207ae23          	sw	zero,-1988(a5) # 80023864 <log+0x2c>
    write_head(); // Erase the transaction from the log
    80004030:	cb3ff0ef          	jal	80003ce2 <write_head>
    80004034:	69e2                	ld	s3,24(sp)
    80004036:	6a42                	ld	s4,16(sp)
    80004038:	6aa2                	ld	s5,8(sp)
    8000403a:	b70d                	j	80003f5c <end_op+0x42>

000000008000403c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000403c:	1101                	addi	sp,sp,-32
    8000403e:	ec06                	sd	ra,24(sp)
    80004040:	e822                	sd	s0,16(sp)
    80004042:	e426                	sd	s1,8(sp)
    80004044:	1000                	addi	s0,sp,32
    80004046:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004048:	0001f517          	auipc	a0,0x1f
    8000404c:	7f050513          	addi	a0,a0,2032 # 80023838 <log>
    80004050:	b99fc0ef          	jal	80000be8 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80004054:	00020617          	auipc	a2,0x20
    80004058:	81062603          	lw	a2,-2032(a2) # 80023864 <log+0x2c>
    8000405c:	47f5                	li	a5,29
    8000405e:	04c7cd63          	blt	a5,a2,800040b8 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004062:	0001f797          	auipc	a5,0x1f
    80004066:	7f27a783          	lw	a5,2034(a5) # 80023854 <log+0x1c>
    8000406a:	04f05d63          	blez	a5,800040c4 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000406e:	4781                	li	a5,0
    80004070:	06c05063          	blez	a2,800040d0 <log_write+0x94>
    if (log.lh.block[i] == b->blockno) // log absorption
    80004074:	44cc                	lw	a1,12(s1)
    80004076:	0001f717          	auipc	a4,0x1f
    8000407a:	7f270713          	addi	a4,a4,2034 # 80023868 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000407e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80004080:	4314                	lw	a3,0(a4)
    80004082:	04b68763          	beq	a3,a1,800040d0 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80004086:	2785                	addiw	a5,a5,1
    80004088:	0711                	addi	a4,a4,4
    8000408a:	fef61be3          	bne	a2,a5,80004080 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000408e:	060a                	slli	a2,a2,0x2
    80004090:	02060613          	addi	a2,a2,32
    80004094:	0001f797          	auipc	a5,0x1f
    80004098:	7a478793          	addi	a5,a5,1956 # 80023838 <log>
    8000409c:	97b2                	add	a5,a5,a2
    8000409e:	44d8                	lw	a4,12(s1)
    800040a0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    800040a2:	8526                	mv	a0,s1
    800040a4:	e75fe0ef          	jal	80002f18 <bpin>
    log.lh.n++;
    800040a8:	0001f717          	auipc	a4,0x1f
    800040ac:	79070713          	addi	a4,a4,1936 # 80023838 <log>
    800040b0:	575c                	lw	a5,44(a4)
    800040b2:	2785                	addiw	a5,a5,1
    800040b4:	d75c                	sw	a5,44(a4)
    800040b6:	a815                	j	800040ea <log_write+0xae>
    panic("too big a transaction");
    800040b8:	00004517          	auipc	a0,0x4
    800040bc:	48850513          	addi	a0,a0,1160 # 80008540 <etext+0x540>
    800040c0:	f74fc0ef          	jal	80000834 <panic>
    panic("log_write outside of trans");
    800040c4:	00004517          	auipc	a0,0x4
    800040c8:	49450513          	addi	a0,a0,1172 # 80008558 <etext+0x558>
    800040cc:	f68fc0ef          	jal	80000834 <panic>
  log.lh.block[i] = b->blockno;
    800040d0:	00279693          	slli	a3,a5,0x2
    800040d4:	02068693          	addi	a3,a3,32
    800040d8:	0001f717          	auipc	a4,0x1f
    800040dc:	76070713          	addi	a4,a4,1888 # 80023838 <log>
    800040e0:	9736                	add	a4,a4,a3
    800040e2:	44d4                	lw	a3,12(s1)
    800040e4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    800040e6:	faf60ee3          	beq	a2,a5,800040a2 <log_write+0x66>
  }
  release(&log.lock);
    800040ea:	0001f517          	auipc	a0,0x1f
    800040ee:	74e50513          	addi	a0,a0,1870 # 80023838 <log>
    800040f2:	b7ffc0ef          	jal	80000c70 <release>
}
    800040f6:	60e2                	ld	ra,24(sp)
    800040f8:	6442                	ld	s0,16(sp)
    800040fa:	64a2                	ld	s1,8(sp)
    800040fc:	6105                	addi	sp,sp,32
    800040fe:	8082                	ret

0000000080004100 <sys_sync>:

uint64
sys_sync(void)
{
    80004100:	1101                	addi	sp,sp,-32
    80004102:	ec06                	sd	ra,24(sp)
    80004104:	e822                	sd	s0,16(sp)
    80004106:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004108:	0001f517          	auipc	a0,0x1f
    8000410c:	73050513          	addi	a0,a0,1840 # 80023838 <log>
    80004110:	ad9fc0ef          	jal	80000be8 <acquire>
  if (log.committing || log.outstanding > 0) {
    80004114:	0001f797          	auipc	a5,0x1f
    80004118:	7447a783          	lw	a5,1860(a5) # 80023858 <log+0x20>
    8000411c:	e799                	bnez	a5,8000412a <sys_sync+0x2a>
    8000411e:	0001f797          	auipc	a5,0x1f
    80004122:	7367a783          	lw	a5,1846(a5) # 80023854 <log+0x1c>
    80004126:	02f05c63          	blez	a5,8000415e <sys_sync+0x5e>
    8000412a:	e426                	sd	s1,8(sp)
    8000412c:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    8000412e:	0001f917          	auipc	s2,0x1f
    80004132:	73292903          	lw	s2,1842(s2) # 80023860 <log+0x28>
    while (log.ncommit < n) {
      sleep_prepare(&log);
    80004136:	0001f497          	auipc	s1,0x1f
    8000413a:	70248493          	addi	s1,s1,1794 # 80023838 <log>
    8000413e:	8526                	mv	a0,s1
    80004140:	eb3fd0ef          	jal	80001ff2 <sleep_prepare>
      release(&log.lock);
    80004144:	8526                	mv	a0,s1
    80004146:	b2bfc0ef          	jal	80000c70 <release>
      sleep();
    8000414a:	ee5fd0ef          	jal	8000202e <sleep>
      acquire(&log.lock);
    8000414e:	8526                	mv	a0,s1
    80004150:	a99fc0ef          	jal	80000be8 <acquire>
    while (log.ncommit < n) {
    80004154:	549c                	lw	a5,40(s1)
    80004156:	fef954e3          	bge	s2,a5,8000413e <sys_sync+0x3e>
    8000415a:	64a2                	ld	s1,8(sp)
    8000415c:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    8000415e:	0001f517          	auipc	a0,0x1f
    80004162:	6da50513          	addi	a0,a0,1754 # 80023838 <log>
    80004166:	b0bfc0ef          	jal	80000c70 <release>
  return 0;
}
    8000416a:	4501                	li	a0,0
    8000416c:	60e2                	ld	ra,24(sp)
    8000416e:	6442                	ld	s0,16(sp)
    80004170:	6105                	addi	sp,sp,32
    80004172:	8082                	ret

0000000080004174 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004174:	1101                	addi	sp,sp,-32
    80004176:	ec06                	sd	ra,24(sp)
    80004178:	e822                	sd	s0,16(sp)
    8000417a:	e426                	sd	s1,8(sp)
    8000417c:	e04a                	sd	s2,0(sp)
    8000417e:	1000                	addi	s0,sp,32
    80004180:	84aa                	mv	s1,a0
    80004182:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004184:	00004597          	auipc	a1,0x4
    80004188:	3f458593          	addi	a1,a1,1012 # 80008578 <etext+0x578>
    8000418c:	0521                	addi	a0,a0,8
    8000418e:	9dbfc0ef          	jal	80000b68 <initlock>
  lk->name = name;
    80004192:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004196:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000419a:	0204a423          	sw	zero,40(s1)
}
    8000419e:	60e2                	ld	ra,24(sp)
    800041a0:	6442                	ld	s0,16(sp)
    800041a2:	64a2                	ld	s1,8(sp)
    800041a4:	6902                	ld	s2,0(sp)
    800041a6:	6105                	addi	sp,sp,32
    800041a8:	8082                	ret

00000000800041aa <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800041aa:	1101                	addi	sp,sp,-32
    800041ac:	ec06                	sd	ra,24(sp)
    800041ae:	e822                	sd	s0,16(sp)
    800041b0:	e426                	sd	s1,8(sp)
    800041b2:	e04a                	sd	s2,0(sp)
    800041b4:	1000                	addi	s0,sp,32
    800041b6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800041b8:	00850913          	addi	s2,a0,8
    800041bc:	854a                	mv	a0,s2
    800041be:	a2bfc0ef          	jal	80000be8 <acquire>
  while (lk->locked) {
    800041c2:	409c                	lw	a5,0(s1)
    800041c4:	cf91                	beqz	a5,800041e0 <acquiresleep+0x36>
    sleep_prepare(lk);
    800041c6:	8526                	mv	a0,s1
    800041c8:	e2bfd0ef          	jal	80001ff2 <sleep_prepare>
    release(&lk->lk);
    800041cc:	854a                	mv	a0,s2
    800041ce:	aa3fc0ef          	jal	80000c70 <release>
    sleep();
    800041d2:	e5dfd0ef          	jal	8000202e <sleep>
    acquire(&lk->lk);
    800041d6:	854a                	mv	a0,s2
    800041d8:	a11fc0ef          	jal	80000be8 <acquire>
  while (lk->locked) {
    800041dc:	409c                	lw	a5,0(s1)
    800041de:	f7e5                	bnez	a5,800041c6 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800041e0:	4785                	li	a5,1
    800041e2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800041e4:	f44fd0ef          	jal	80001928 <myproc>
    800041e8:	591c                	lw	a5,48(a0)
    800041ea:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800041ec:	854a                	mv	a0,s2
    800041ee:	a83fc0ef          	jal	80000c70 <release>
}
    800041f2:	60e2                	ld	ra,24(sp)
    800041f4:	6442                	ld	s0,16(sp)
    800041f6:	64a2                	ld	s1,8(sp)
    800041f8:	6902                	ld	s2,0(sp)
    800041fa:	6105                	addi	sp,sp,32
    800041fc:	8082                	ret

00000000800041fe <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800041fe:	1101                	addi	sp,sp,-32
    80004200:	ec06                	sd	ra,24(sp)
    80004202:	e822                	sd	s0,16(sp)
    80004204:	e426                	sd	s1,8(sp)
    80004206:	e04a                	sd	s2,0(sp)
    80004208:	1000                	addi	s0,sp,32
    8000420a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000420c:	00850913          	addi	s2,a0,8
    80004210:	854a                	mv	a0,s2
    80004212:	9d7fc0ef          	jal	80000be8 <acquire>
  lk->locked = 0;
    80004216:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000421a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000421e:	8526                	mv	a0,s1
    80004220:	e3ffd0ef          	jal	8000205e <wakeup>
  release(&lk->lk);
    80004224:	854a                	mv	a0,s2
    80004226:	a4bfc0ef          	jal	80000c70 <release>
}
    8000422a:	60e2                	ld	ra,24(sp)
    8000422c:	6442                	ld	s0,16(sp)
    8000422e:	64a2                	ld	s1,8(sp)
    80004230:	6902                	ld	s2,0(sp)
    80004232:	6105                	addi	sp,sp,32
    80004234:	8082                	ret

0000000080004236 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004236:	7179                	addi	sp,sp,-48
    80004238:	f406                	sd	ra,40(sp)
    8000423a:	f022                	sd	s0,32(sp)
    8000423c:	ec26                	sd	s1,24(sp)
    8000423e:	e84a                	sd	s2,16(sp)
    80004240:	1800                	addi	s0,sp,48
    80004242:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80004244:	00850913          	addi	s2,a0,8
    80004248:	854a                	mv	a0,s2
    8000424a:	99ffc0ef          	jal	80000be8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000424e:	409c                	lw	a5,0(s1)
    80004250:	ef81                	bnez	a5,80004268 <holdingsleep+0x32>
    80004252:	4481                	li	s1,0
  release(&lk->lk);
    80004254:	854a                	mv	a0,s2
    80004256:	a1bfc0ef          	jal	80000c70 <release>
  return r;
}
    8000425a:	8526                	mv	a0,s1
    8000425c:	70a2                	ld	ra,40(sp)
    8000425e:	7402                	ld	s0,32(sp)
    80004260:	64e2                	ld	s1,24(sp)
    80004262:	6942                	ld	s2,16(sp)
    80004264:	6145                	addi	sp,sp,48
    80004266:	8082                	ret
    80004268:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000426a:	0284a983          	lw	s3,40(s1)
    8000426e:	ebafd0ef          	jal	80001928 <myproc>
    80004272:	5904                	lw	s1,48(a0)
    80004274:	413484b3          	sub	s1,s1,s3
    80004278:	0014b493          	seqz	s1,s1
    8000427c:	69a2                	ld	s3,8(sp)
    8000427e:	bfd9                	j	80004254 <holdingsleep+0x1e>

0000000080004280 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004280:	1141                	addi	sp,sp,-16
    80004282:	e406                	sd	ra,8(sp)
    80004284:	e022                	sd	s0,0(sp)
    80004286:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004288:	00004597          	auipc	a1,0x4
    8000428c:	30058593          	addi	a1,a1,768 # 80008588 <etext+0x588>
    80004290:	0001f517          	auipc	a0,0x1f
    80004294:	6f050513          	addi	a0,a0,1776 # 80023980 <ftable>
    80004298:	8d1fc0ef          	jal	80000b68 <initlock>
}
    8000429c:	60a2                	ld	ra,8(sp)
    8000429e:	6402                	ld	s0,0(sp)
    800042a0:	0141                	addi	sp,sp,16
    800042a2:	8082                	ret

00000000800042a4 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    800042a4:	1101                	addi	sp,sp,-32
    800042a6:	ec06                	sd	ra,24(sp)
    800042a8:	e822                	sd	s0,16(sp)
    800042aa:	e426                	sd	s1,8(sp)
    800042ac:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800042ae:	0001f517          	auipc	a0,0x1f
    800042b2:	6d250513          	addi	a0,a0,1746 # 80023980 <ftable>
    800042b6:	933fc0ef          	jal	80000be8 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800042ba:	0001f497          	auipc	s1,0x1f
    800042be:	6de48493          	addi	s1,s1,1758 # 80023998 <ftable+0x18>
    800042c2:	00020717          	auipc	a4,0x20
    800042c6:	67670713          	addi	a4,a4,1654 # 80024938 <disk>
    if (f->ref == 0) {
    800042ca:	40dc                	lw	a5,4(s1)
    800042cc:	cf89                	beqz	a5,800042e6 <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800042ce:	02848493          	addi	s1,s1,40
    800042d2:	fee49ce3          	bne	s1,a4,800042ca <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800042d6:	0001f517          	auipc	a0,0x1f
    800042da:	6aa50513          	addi	a0,a0,1706 # 80023980 <ftable>
    800042de:	993fc0ef          	jal	80000c70 <release>
  return 0;
    800042e2:	4481                	li	s1,0
    800042e4:	a809                	j	800042f6 <filealloc+0x52>
      f->ref = 1;
    800042e6:	4785                	li	a5,1
    800042e8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800042ea:	0001f517          	auipc	a0,0x1f
    800042ee:	69650513          	addi	a0,a0,1686 # 80023980 <ftable>
    800042f2:	97ffc0ef          	jal	80000c70 <release>
}
    800042f6:	8526                	mv	a0,s1
    800042f8:	60e2                	ld	ra,24(sp)
    800042fa:	6442                	ld	s0,16(sp)
    800042fc:	64a2                	ld	s1,8(sp)
    800042fe:	6105                	addi	sp,sp,32
    80004300:	8082                	ret

0000000080004302 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80004302:	1101                	addi	sp,sp,-32
    80004304:	ec06                	sd	ra,24(sp)
    80004306:	e822                	sd	s0,16(sp)
    80004308:	e426                	sd	s1,8(sp)
    8000430a:	1000                	addi	s0,sp,32
    8000430c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000430e:	0001f517          	auipc	a0,0x1f
    80004312:	67250513          	addi	a0,a0,1650 # 80023980 <ftable>
    80004316:	8d3fc0ef          	jal	80000be8 <acquire>
  if (f->ref < 1)
    8000431a:	40dc                	lw	a5,4(s1)
    8000431c:	02f05063          	blez	a5,8000433c <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004320:	2785                	addiw	a5,a5,1
    80004322:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004324:	0001f517          	auipc	a0,0x1f
    80004328:	65c50513          	addi	a0,a0,1628 # 80023980 <ftable>
    8000432c:	945fc0ef          	jal	80000c70 <release>
  return f;
}
    80004330:	8526                	mv	a0,s1
    80004332:	60e2                	ld	ra,24(sp)
    80004334:	6442                	ld	s0,16(sp)
    80004336:	64a2                	ld	s1,8(sp)
    80004338:	6105                	addi	sp,sp,32
    8000433a:	8082                	ret
    panic("filedup");
    8000433c:	00004517          	auipc	a0,0x4
    80004340:	25450513          	addi	a0,a0,596 # 80008590 <etext+0x590>
    80004344:	cf0fc0ef          	jal	80000834 <panic>

0000000080004348 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004348:	7139                	addi	sp,sp,-64
    8000434a:	fc06                	sd	ra,56(sp)
    8000434c:	f822                	sd	s0,48(sp)
    8000434e:	f426                	sd	s1,40(sp)
    80004350:	0080                	addi	s0,sp,64
    80004352:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004354:	0001f517          	auipc	a0,0x1f
    80004358:	62c50513          	addi	a0,a0,1580 # 80023980 <ftable>
    8000435c:	88dfc0ef          	jal	80000be8 <acquire>
  if (f->ref < 1)
    80004360:	40dc                	lw	a5,4(s1)
    80004362:	04f05a63          	blez	a5,800043b6 <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    80004366:	37fd                	addiw	a5,a5,-1
    80004368:	c0dc                	sw	a5,4(s1)
    8000436a:	06f04063          	bgtz	a5,800043ca <fileclose+0x82>
    8000436e:	f04a                	sd	s2,32(sp)
    80004370:	ec4e                	sd	s3,24(sp)
    80004372:	e852                	sd	s4,16(sp)
    80004374:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004376:	0004a903          	lw	s2,0(s1)
    8000437a:	0094c783          	lbu	a5,9(s1)
    8000437e:	89be                	mv	s3,a5
    80004380:	689c                	ld	a5,16(s1)
    80004382:	8a3e                	mv	s4,a5
    80004384:	6c9c                	ld	a5,24(s1)
    80004386:	8abe                	mv	s5,a5
  f->ref = 0;
    80004388:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000438c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004390:	0001f517          	auipc	a0,0x1f
    80004394:	5f050513          	addi	a0,a0,1520 # 80023980 <ftable>
    80004398:	8d9fc0ef          	jal	80000c70 <release>

  if (ff.type == FD_PIPE) {
    8000439c:	4785                	li	a5,1
    8000439e:	04f90163          	beq	s2,a5,800043e0 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    800043a2:	ffe9079b          	addiw	a5,s2,-2
    800043a6:	4705                	li	a4,1
    800043a8:	04f77563          	bgeu	a4,a5,800043f2 <fileclose+0xaa>
    800043ac:	7902                	ld	s2,32(sp)
    800043ae:	69e2                	ld	s3,24(sp)
    800043b0:	6a42                	ld	s4,16(sp)
    800043b2:	6aa2                	ld	s5,8(sp)
    800043b4:	a00d                	j	800043d6 <fileclose+0x8e>
    800043b6:	f04a                	sd	s2,32(sp)
    800043b8:	ec4e                	sd	s3,24(sp)
    800043ba:	e852                	sd	s4,16(sp)
    800043bc:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800043be:	00004517          	auipc	a0,0x4
    800043c2:	1da50513          	addi	a0,a0,474 # 80008598 <etext+0x598>
    800043c6:	c6efc0ef          	jal	80000834 <panic>
    release(&ftable.lock);
    800043ca:	0001f517          	auipc	a0,0x1f
    800043ce:	5b650513          	addi	a0,a0,1462 # 80023980 <ftable>
    800043d2:	89ffc0ef          	jal	80000c70 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800043d6:	70e2                	ld	ra,56(sp)
    800043d8:	7442                	ld	s0,48(sp)
    800043da:	74a2                	ld	s1,40(sp)
    800043dc:	6121                	addi	sp,sp,64
    800043de:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800043e0:	85ce                	mv	a1,s3
    800043e2:	8552                	mv	a0,s4
    800043e4:	360000ef          	jal	80004744 <pipeclose>
    800043e8:	7902                	ld	s2,32(sp)
    800043ea:	69e2                	ld	s3,24(sp)
    800043ec:	6a42                	ld	s4,16(sp)
    800043ee:	6aa2                	ld	s5,8(sp)
    800043f0:	b7dd                	j	800043d6 <fileclose+0x8e>
    begin_op();
    800043f2:	a9dff0ef          	jal	80003e8e <begin_op>
    iput(ff.ip);
    800043f6:	8556                	mv	a0,s5
    800043f8:	9aeff0ef          	jal	800035a6 <iput>
    end_op();
    800043fc:	b1fff0ef          	jal	80003f1a <end_op>
    80004400:	7902                	ld	s2,32(sp)
    80004402:	69e2                	ld	s3,24(sp)
    80004404:	6a42                	ld	s4,16(sp)
    80004406:	6aa2                	ld	s5,8(sp)
    80004408:	b7f9                	j	800043d6 <fileclose+0x8e>

000000008000440a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000440a:	715d                	addi	sp,sp,-80
    8000440c:	e486                	sd	ra,72(sp)
    8000440e:	e0a2                	sd	s0,64(sp)
    80004410:	fc26                	sd	s1,56(sp)
    80004412:	f052                	sd	s4,32(sp)
    80004414:	0880                	addi	s0,sp,80
    80004416:	84aa                	mv	s1,a0
    80004418:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    8000441a:	d0efd0ef          	jal	80001928 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    8000441e:	409c                	lw	a5,0(s1)
    80004420:	37f9                	addiw	a5,a5,-2
    80004422:	4705                	li	a4,1
    80004424:	04f76463          	bltu	a4,a5,8000446c <filestat+0x62>
    80004428:	f84a                	sd	s2,48(sp)
    8000442a:	f44e                	sd	s3,40(sp)
    8000442c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000442e:	6c88                	ld	a0,24(s1)
    80004430:	ff5fe0ef          	jal	80003424 <ilock>
    stati(f->ip, &st);
    80004434:	fb840993          	addi	s3,s0,-72
    80004438:	85ce                	mv	a1,s3
    8000443a:	6c88                	ld	a0,24(s1)
    8000443c:	b94ff0ef          	jal	800037d0 <stati>
    iunlock(f->ip);
    80004440:	6c88                	ld	a0,24(s1)
    80004442:	890ff0ef          	jal	800034d2 <iunlock>
    if (copyout(p->pagetable, p->sz, addr, (char *)&st, sizeof(st)) < 0)
    80004446:	4761                	li	a4,24
    80004448:	86ce                	mv	a3,s3
    8000444a:	8652                	mv	a2,s4
    8000444c:	04893583          	ld	a1,72(s2)
    80004450:	05893503          	ld	a0,88(s2)
    80004454:	8f2fd0ef          	jal	80001546 <copyout>
    80004458:	41f5551b          	sraiw	a0,a0,0x1f
    8000445c:	7942                	ld	s2,48(sp)
    8000445e:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004460:	60a6                	ld	ra,72(sp)
    80004462:	6406                	ld	s0,64(sp)
    80004464:	74e2                	ld	s1,56(sp)
    80004466:	7a02                	ld	s4,32(sp)
    80004468:	6161                	addi	sp,sp,80
    8000446a:	8082                	ret
  return -1;
    8000446c:	557d                	li	a0,-1
    8000446e:	bfcd                	j	80004460 <filestat+0x56>

0000000080004470 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004470:	7179                	addi	sp,sp,-48
    80004472:	f406                	sd	ra,40(sp)
    80004474:	f022                	sd	s0,32(sp)
    80004476:	e84a                	sd	s2,16(sp)
    80004478:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0 || n < 0)
    8000447a:	00854783          	lbu	a5,8(a0)
    8000447e:	c3dd                	beqz	a5,80004524 <fileread+0xb4>
    80004480:	ec26                	sd	s1,24(sp)
    80004482:	e44e                	sd	s3,8(sp)
    80004484:	84aa                	mv	s1,a0
    80004486:	892e                	mv	s2,a1
    80004488:	89b2                	mv	s3,a2
    8000448a:	01f6579b          	srliw	a5,a2,0x1f
    8000448e:	ebc9                	bnez	a5,80004520 <fileread+0xb0>
    return -1;

  if (f->type == FD_PIPE) {
    80004490:	411c                	lw	a5,0(a0)
    80004492:	4705                	li	a4,1
    80004494:	04e78363          	beq	a5,a4,800044da <fileread+0x6a>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004498:	470d                	li	a4,3
    8000449a:	04e78763          	beq	a5,a4,800044e8 <fileread+0x78>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    8000449e:	4709                	li	a4,2
    800044a0:	06e79a63          	bne	a5,a4,80004514 <fileread+0xa4>
    ilock(f->ip);
    800044a4:	6d08                	ld	a0,24(a0)
    800044a6:	f7ffe0ef          	jal	80003424 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800044aa:	874e                	mv	a4,s3
    800044ac:	5094                	lw	a3,32(s1)
    800044ae:	864a                	mv	a2,s2
    800044b0:	4585                	li	a1,1
    800044b2:	6c88                	ld	a0,24(s1)
    800044b4:	b4aff0ef          	jal	800037fe <readi>
    800044b8:	892a                	mv	s2,a0
    800044ba:	00a05563          	blez	a0,800044c4 <fileread+0x54>
      f->off += r;
    800044be:	509c                	lw	a5,32(s1)
    800044c0:	9fa9                	addw	a5,a5,a0
    800044c2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800044c4:	6c88                	ld	a0,24(s1)
    800044c6:	80cff0ef          	jal	800034d2 <iunlock>
    800044ca:	64e2                	ld	s1,24(sp)
    800044cc:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800044ce:	854a                	mv	a0,s2
    800044d0:	70a2                	ld	ra,40(sp)
    800044d2:	7402                	ld	s0,32(sp)
    800044d4:	6942                	ld	s2,16(sp)
    800044d6:	6145                	addi	sp,sp,48
    800044d8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800044da:	6908                	ld	a0,16(a0)
    800044dc:	3e2000ef          	jal	800048be <piperead>
    800044e0:	892a                	mv	s2,a0
    800044e2:	64e2                	ld	s1,24(sp)
    800044e4:	69a2                	ld	s3,8(sp)
    800044e6:	b7e5                	j	800044ce <fileread+0x5e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800044e8:	02451783          	lh	a5,36(a0)
    800044ec:	03079693          	slli	a3,a5,0x30
    800044f0:	92c1                	srli	a3,a3,0x30
    800044f2:	4725                	li	a4,9
    800044f4:	02d76b63          	bltu	a4,a3,8000452a <fileread+0xba>
    800044f8:	0792                	slli	a5,a5,0x4
    800044fa:	0001f717          	auipc	a4,0x1f
    800044fe:	3e670713          	addi	a4,a4,998 # 800238e0 <devsw>
    80004502:	97ba                	add	a5,a5,a4
    80004504:	639c                	ld	a5,0(a5)
    80004506:	c79d                	beqz	a5,80004534 <fileread+0xc4>
    r = devsw[f->major].read(1, addr, n);
    80004508:	4505                	li	a0,1
    8000450a:	9782                	jalr	a5
    8000450c:	892a                	mv	s2,a0
    8000450e:	64e2                	ld	s1,24(sp)
    80004510:	69a2                	ld	s3,8(sp)
    80004512:	bf75                	j	800044ce <fileread+0x5e>
    panic("fileread");
    80004514:	00004517          	auipc	a0,0x4
    80004518:	09450513          	addi	a0,a0,148 # 800085a8 <etext+0x5a8>
    8000451c:	b18fc0ef          	jal	80000834 <panic>
    80004520:	64e2                	ld	s1,24(sp)
    80004522:	69a2                	ld	s3,8(sp)
    return -1;
    80004524:	57fd                	li	a5,-1
    80004526:	893e                	mv	s2,a5
    80004528:	b75d                	j	800044ce <fileread+0x5e>
      return -1;
    8000452a:	57fd                	li	a5,-1
    8000452c:	893e                	mv	s2,a5
    8000452e:	64e2                	ld	s1,24(sp)
    80004530:	69a2                	ld	s3,8(sp)
    80004532:	bf71                	j	800044ce <fileread+0x5e>
    80004534:	57fd                	li	a5,-1
    80004536:	893e                	mv	s2,a5
    80004538:	64e2                	ld	s1,24(sp)
    8000453a:	69a2                	ld	s3,8(sp)
    8000453c:	bf49                	j	800044ce <fileread+0x5e>

000000008000453e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0 || n < 0)
    8000453e:	00954783          	lbu	a5,9(a0)
    80004542:	12078b63          	beqz	a5,80004678 <filewrite+0x13a>
{
    80004546:	711d                	addi	sp,sp,-96
    80004548:	ec86                	sd	ra,88(sp)
    8000454a:	e8a2                	sd	s0,80(sp)
    8000454c:	e0ca                	sd	s2,64(sp)
    8000454e:	f456                	sd	s5,40(sp)
    80004550:	f05a                	sd	s6,32(sp)
    80004552:	1080                	addi	s0,sp,96
    80004554:	892a                	mv	s2,a0
    80004556:	8b2e                	mv	s6,a1
    80004558:	8ab2                	mv	s5,a2
  if (f->writable == 0 || n < 0)
    8000455a:	01f6579b          	srliw	a5,a2,0x1f
    8000455e:	0e079d63          	bnez	a5,80004658 <filewrite+0x11a>
    return -1;

  if (f->type == FD_PIPE) {
    80004562:	411c                	lw	a5,0(a0)
    80004564:	4705                	li	a4,1
    80004566:	02e78a63          	beq	a5,a4,8000459a <filewrite+0x5c>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    8000456a:	470d                	li	a4,3
    8000456c:	02e78b63          	beq	a5,a4,800045a2 <filewrite+0x64>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80004570:	4709                	li	a4,2
    80004572:	0ce79763          	bne	a5,a4,80004640 <filewrite+0x102>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80004576:	0ec05763          	blez	a2,80004664 <filewrite+0x126>
    8000457a:	e4a6                	sd	s1,72(sp)
    8000457c:	fc4e                	sd	s3,56(sp)
    8000457e:	f852                	sd	s4,48(sp)
    80004580:	ec5e                	sd	s7,24(sp)
    80004582:	e862                	sd	s8,16(sp)
    80004584:	e466                	sd	s9,8(sp)
    int i = 0;
    80004586:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    80004588:	6b85                	lui	s7,0x1
    8000458a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000458e:	6785                	lui	a5,0x1
    80004590:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80004594:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004596:	4c05                	li	s8,1
    80004598:	a8ad                	j	80004612 <filewrite+0xd4>
    ret = pipewrite(f->pipe, addr, n);
    8000459a:	6908                	ld	a0,16(a0)
    8000459c:	206000ef          	jal	800047a2 <pipewrite>
    800045a0:	a849                	j	80004632 <filewrite+0xf4>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800045a2:	02451783          	lh	a5,36(a0)
    800045a6:	03079693          	slli	a3,a5,0x30
    800045aa:	92c1                	srli	a3,a3,0x30
    800045ac:	4725                	li	a4,9
    800045ae:	0ad76763          	bltu	a4,a3,8000465c <filewrite+0x11e>
    800045b2:	0792                	slli	a5,a5,0x4
    800045b4:	0001f717          	auipc	a4,0x1f
    800045b8:	32c70713          	addi	a4,a4,812 # 800238e0 <devsw>
    800045bc:	97ba                	add	a5,a5,a4
    800045be:	679c                	ld	a5,8(a5)
    800045c0:	c3c5                	beqz	a5,80004660 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800045c2:	4505                	li	a0,1
    800045c4:	9782                	jalr	a5
    800045c6:	a0b5                	j	80004632 <filewrite+0xf4>
      if (n1 > max)
    800045c8:	2981                	sext.w	s3,s3
      begin_op();
    800045ca:	8c5ff0ef          	jal	80003e8e <begin_op>
      ilock(f->ip);
    800045ce:	01893503          	ld	a0,24(s2)
    800045d2:	e53fe0ef          	jal	80003424 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800045d6:	874e                	mv	a4,s3
    800045d8:	02092683          	lw	a3,32(s2)
    800045dc:	016a0633          	add	a2,s4,s6
    800045e0:	85e2                	mv	a1,s8
    800045e2:	01893503          	ld	a0,24(s2)
    800045e6:	b0aff0ef          	jal	800038f0 <writei>
    800045ea:	84aa                	mv	s1,a0
    800045ec:	00a05763          	blez	a0,800045fa <filewrite+0xbc>
        f->off += r;
    800045f0:	02092783          	lw	a5,32(s2)
    800045f4:	9fa9                	addw	a5,a5,a0
    800045f6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800045fa:	01893503          	ld	a0,24(s2)
    800045fe:	ed5fe0ef          	jal	800034d2 <iunlock>
      end_op();
    80004602:	919ff0ef          	jal	80003f1a <end_op>

      if (r != n1) {
    80004606:	00999d63          	bne	s3,s1,80004620 <filewrite+0xe2>
        // error from writei
        break;
      }
      i += r;
    8000460a:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    8000460e:	015a5963          	bge	s4,s5,80004620 <filewrite+0xe2>
      int n1 = n - i;
    80004612:	414a87bb          	subw	a5,s5,s4
    80004616:	89be                	mv	s3,a5
      if (n1 > max)
    80004618:	fafbd8e3          	bge	s7,a5,800045c8 <filewrite+0x8a>
    8000461c:	89e6                	mv	s3,s9
    8000461e:	b76d                	j	800045c8 <filewrite+0x8a>
    }
    ret = (i == n ? n : -1);
    80004620:	054a9463          	bne	s5,s4,80004668 <filewrite+0x12a>
    80004624:	8556                	mv	a0,s5
    80004626:	64a6                	ld	s1,72(sp)
    80004628:	79e2                	ld	s3,56(sp)
    8000462a:	7a42                	ld	s4,48(sp)
    8000462c:	6be2                	ld	s7,24(sp)
    8000462e:	6c42                	ld	s8,16(sp)
    80004630:	6ca2                	ld	s9,8(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004632:	60e6                	ld	ra,88(sp)
    80004634:	6446                	ld	s0,80(sp)
    80004636:	6906                	ld	s2,64(sp)
    80004638:	7aa2                	ld	s5,40(sp)
    8000463a:	7b02                	ld	s6,32(sp)
    8000463c:	6125                	addi	sp,sp,96
    8000463e:	8082                	ret
    80004640:	e4a6                	sd	s1,72(sp)
    80004642:	fc4e                	sd	s3,56(sp)
    80004644:	f852                	sd	s4,48(sp)
    80004646:	ec5e                	sd	s7,24(sp)
    80004648:	e862                	sd	s8,16(sp)
    8000464a:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000464c:	00004517          	auipc	a0,0x4
    80004650:	f6c50513          	addi	a0,a0,-148 # 800085b8 <etext+0x5b8>
    80004654:	9e0fc0ef          	jal	80000834 <panic>
    return -1;
    80004658:	557d                	li	a0,-1
    8000465a:	bfe1                	j	80004632 <filewrite+0xf4>
      return -1;
    8000465c:	557d                	li	a0,-1
    8000465e:	bfd1                	j	80004632 <filewrite+0xf4>
    80004660:	557d                	li	a0,-1
    80004662:	bfc1                	j	80004632 <filewrite+0xf4>
    ret = (i == n ? n : -1);
    80004664:	8532                	mv	a0,a2
    80004666:	b7f1                	j	80004632 <filewrite+0xf4>
    80004668:	557d                	li	a0,-1
    8000466a:	64a6                	ld	s1,72(sp)
    8000466c:	79e2                	ld	s3,56(sp)
    8000466e:	7a42                	ld	s4,48(sp)
    80004670:	6be2                	ld	s7,24(sp)
    80004672:	6c42                	ld	s8,16(sp)
    80004674:	6ca2                	ld	s9,8(sp)
    80004676:	bf75                	j	80004632 <filewrite+0xf4>
    return -1;
    80004678:	557d                	li	a0,-1
}
    8000467a:	8082                	ret

000000008000467c <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000467c:	7179                	addi	sp,sp,-48
    8000467e:	f406                	sd	ra,40(sp)
    80004680:	f022                	sd	s0,32(sp)
    80004682:	ec26                	sd	s1,24(sp)
    80004684:	e052                	sd	s4,0(sp)
    80004686:	1800                	addi	s0,sp,48
    80004688:	84aa                	mv	s1,a0
    8000468a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000468c:	0005b023          	sd	zero,0(a1)
    80004690:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004694:	c11ff0ef          	jal	800042a4 <filealloc>
    80004698:	e088                	sd	a0,0(s1)
    8000469a:	c549                	beqz	a0,80004724 <pipealloc+0xa8>
    8000469c:	c09ff0ef          	jal	800042a4 <filealloc>
    800046a0:	00aa3023          	sd	a0,0(s4)
    800046a4:	cd25                	beqz	a0,8000471c <pipealloc+0xa0>
    800046a6:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    800046a8:	c66fc0ef          	jal	80000b0e <kalloc>
    800046ac:	892a                	mv	s2,a0
    800046ae:	c12d                	beqz	a0,80004710 <pipealloc+0x94>
    800046b0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800046b2:	4985                	li	s3,1
    800046b4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800046b8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800046bc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800046c0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800046c4:	00004597          	auipc	a1,0x4
    800046c8:	f0458593          	addi	a1,a1,-252 # 800085c8 <etext+0x5c8>
    800046cc:	c9cfc0ef          	jal	80000b68 <initlock>
  (*f0)->type = FD_PIPE;
    800046d0:	609c                	ld	a5,0(s1)
    800046d2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800046d6:	609c                	ld	a5,0(s1)
    800046d8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800046dc:	609c                	ld	a5,0(s1)
    800046de:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800046e2:	609c                	ld	a5,0(s1)
    800046e4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800046e8:	000a3783          	ld	a5,0(s4)
    800046ec:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800046f0:	000a3783          	ld	a5,0(s4)
    800046f4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800046f8:	000a3783          	ld	a5,0(s4)
    800046fc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004700:	000a3783          	ld	a5,0(s4)
    80004704:	0127b823          	sd	s2,16(a5)
  return 0;
    80004708:	4501                	li	a0,0
    8000470a:	6942                	ld	s2,16(sp)
    8000470c:	69a2                	ld	s3,8(sp)
    8000470e:	a01d                	j	80004734 <pipealloc+0xb8>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    80004710:	6088                	ld	a0,0(s1)
    80004712:	c119                	beqz	a0,80004718 <pipealloc+0x9c>
    80004714:	6942                	ld	s2,16(sp)
    80004716:	a029                	j	80004720 <pipealloc+0xa4>
    80004718:	6942                	ld	s2,16(sp)
    8000471a:	a029                	j	80004724 <pipealloc+0xa8>
    8000471c:	6088                	ld	a0,0(s1)
    8000471e:	c10d                	beqz	a0,80004740 <pipealloc+0xc4>
    fileclose(*f0);
    80004720:	c29ff0ef          	jal	80004348 <fileclose>
  if (*f1)
    80004724:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004728:	557d                	li	a0,-1
  if (*f1)
    8000472a:	c789                	beqz	a5,80004734 <pipealloc+0xb8>
    fileclose(*f1);
    8000472c:	853e                	mv	a0,a5
    8000472e:	c1bff0ef          	jal	80004348 <fileclose>
  return -1;
    80004732:	557d                	li	a0,-1
}
    80004734:	70a2                	ld	ra,40(sp)
    80004736:	7402                	ld	s0,32(sp)
    80004738:	64e2                	ld	s1,24(sp)
    8000473a:	6a02                	ld	s4,0(sp)
    8000473c:	6145                	addi	sp,sp,48
    8000473e:	8082                	ret
  return -1;
    80004740:	557d                	li	a0,-1
    80004742:	bfcd                	j	80004734 <pipealloc+0xb8>

0000000080004744 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004744:	1101                	addi	sp,sp,-32
    80004746:	ec06                	sd	ra,24(sp)
    80004748:	e822                	sd	s0,16(sp)
    8000474a:	e426                	sd	s1,8(sp)
    8000474c:	e04a                	sd	s2,0(sp)
    8000474e:	1000                	addi	s0,sp,32
    80004750:	84aa                	mv	s1,a0
    80004752:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004754:	c94fc0ef          	jal	80000be8 <acquire>
  if (writable) {
    80004758:	02090763          	beqz	s2,80004786 <pipeclose+0x42>
    pi->writeopen = 0;
    8000475c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004760:	21848513          	addi	a0,s1,536
    80004764:	8fbfd0ef          	jal	8000205e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80004768:	2204a783          	lw	a5,544(s1)
    8000476c:	e781                	bnez	a5,80004774 <pipeclose+0x30>
    8000476e:	2244a783          	lw	a5,548(s1)
    80004772:	c38d                	beqz	a5,80004794 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
    80004774:	8526                	mv	a0,s1
    80004776:	cfafc0ef          	jal	80000c70 <release>
}
    8000477a:	60e2                	ld	ra,24(sp)
    8000477c:	6442                	ld	s0,16(sp)
    8000477e:	64a2                	ld	s1,8(sp)
    80004780:	6902                	ld	s2,0(sp)
    80004782:	6105                	addi	sp,sp,32
    80004784:	8082                	ret
    pi->readopen = 0;
    80004786:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000478a:	21c48513          	addi	a0,s1,540
    8000478e:	8d1fd0ef          	jal	8000205e <wakeup>
    80004792:	bfd9                	j	80004768 <pipeclose+0x24>
    release(&pi->lock);
    80004794:	8526                	mv	a0,s1
    80004796:	cdafc0ef          	jal	80000c70 <release>
    kfree((char *)pi);
    8000479a:	8526                	mv	a0,s1
    8000479c:	a8afc0ef          	jal	80000a26 <kfree>
    800047a0:	bfe9                	j	8000477a <pipeclose+0x36>

00000000800047a2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800047a2:	7159                	addi	sp,sp,-112
    800047a4:	f486                	sd	ra,104(sp)
    800047a6:	f0a2                	sd	s0,96(sp)
    800047a8:	eca6                	sd	s1,88(sp)
    800047aa:	e8ca                	sd	s2,80(sp)
    800047ac:	e4ce                	sd	s3,72(sp)
    800047ae:	e0d2                	sd	s4,64(sp)
    800047b0:	fc56                	sd	s5,56(sp)
    800047b2:	1880                	addi	s0,sp,112
    800047b4:	84aa                	mv	s1,a0
    800047b6:	8aae                	mv	s5,a1
    800047b8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800047ba:	96efd0ef          	jal	80001928 <myproc>
    800047be:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800047c0:	8526                	mv	a0,s1
    800047c2:	c26fc0ef          	jal	80000be8 <acquire>
  while (i < n) {
    800047c6:	0f405a63          	blez	s4,800048ba <pipewrite+0x118>
    800047ca:	f85a                	sd	s6,48(sp)
    800047cc:	f45e                	sd	s7,40(sp)
    800047ce:	f062                	sd	s8,32(sp)
    800047d0:	ec66                	sd	s9,24(sp)
    800047d2:	e86a                	sd	s10,16(sp)
  int i = 0;
    800047d4:	4901                	li	s2,0
      release(&pi->lock);
      sleep();
      acquire(&pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    800047d6:	f9f40c13          	addi	s8,s0,-97
    800047da:	4b85                	li	s7,1
    800047dc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800047de:	21848d13          	addi	s10,s1,536
      sleep_prepare(&pi->nwrite);
    800047e2:	21c48c93          	addi	s9,s1,540
    800047e6:	a0a1                	j	8000482e <pipewrite+0x8c>
      release(&pi->lock);
    800047e8:	8526                	mv	a0,s1
    800047ea:	c86fc0ef          	jal	80000c70 <release>
      return -1;
    800047ee:	597d                	li	s2,-1
    800047f0:	7b42                	ld	s6,48(sp)
    800047f2:	7ba2                	ld	s7,40(sp)
    800047f4:	7c02                	ld	s8,32(sp)
    800047f6:	6ce2                	ld	s9,24(sp)
    800047f8:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800047fa:	854a                	mv	a0,s2
    800047fc:	70a6                	ld	ra,104(sp)
    800047fe:	7406                	ld	s0,96(sp)
    80004800:	64e6                	ld	s1,88(sp)
    80004802:	6946                	ld	s2,80(sp)
    80004804:	69a6                	ld	s3,72(sp)
    80004806:	6a06                	ld	s4,64(sp)
    80004808:	7ae2                	ld	s5,56(sp)
    8000480a:	6165                	addi	sp,sp,112
    8000480c:	8082                	ret
      wakeup(&pi->nread);
    8000480e:	856a                	mv	a0,s10
    80004810:	84ffd0ef          	jal	8000205e <wakeup>
      sleep_prepare(&pi->nwrite);
    80004814:	8566                	mv	a0,s9
    80004816:	fdcfd0ef          	jal	80001ff2 <sleep_prepare>
      release(&pi->lock);
    8000481a:	8526                	mv	a0,s1
    8000481c:	c54fc0ef          	jal	80000c70 <release>
      sleep();
    80004820:	80ffd0ef          	jal	8000202e <sleep>
      acquire(&pi->lock);
    80004824:	8526                	mv	a0,s1
    80004826:	bc2fc0ef          	jal	80000be8 <acquire>
  while (i < n) {
    8000482a:	07495b63          	bge	s2,s4,800048a0 <pipewrite+0xfe>
    if (pi->readopen == 0 || killed(pr)) {
    8000482e:	2204a783          	lw	a5,544(s1)
    80004832:	dbdd                	beqz	a5,800047e8 <pipewrite+0x46>
    80004834:	854e                	mv	a0,s3
    80004836:	a15fd0ef          	jal	8000224a <killed>
    8000483a:	f55d                	bnez	a0,800047e8 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    8000483c:	2184a783          	lw	a5,536(s1)
    80004840:	21c4a703          	lw	a4,540(s1)
    80004844:	2007879b          	addiw	a5,a5,512
    80004848:	fcf703e3          	beq	a4,a5,8000480e <pipewrite+0x6c>
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    8000484c:	875e                	mv	a4,s7
    8000484e:	015906b3          	add	a3,s2,s5
    80004852:	8662                	mv	a2,s8
    80004854:	0489b583          	ld	a1,72(s3)
    80004858:	0589b503          	ld	a0,88(s3)
    8000485c:	db1fc0ef          	jal	8000160c <copyin>
    80004860:	03650163          	beq	a0,s6,80004882 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004864:	21c4a783          	lw	a5,540(s1)
    80004868:	0017871b          	addiw	a4,a5,1
    8000486c:	20e4ae23          	sw	a4,540(s1)
    80004870:	1ff7f793          	andi	a5,a5,511
    80004874:	97a6                	add	a5,a5,s1
    80004876:	f9f44703          	lbu	a4,-97(s0)
    8000487a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000487e:	2905                	addiw	s2,s2,1
    80004880:	b76d                	j	8000482a <pipewrite+0x88>
        if (i == 0)
    80004882:	00090863          	beqz	s2,80004892 <pipewrite+0xf0>
    80004886:	7b42                	ld	s6,48(sp)
    80004888:	7ba2                	ld	s7,40(sp)
    8000488a:	7c02                	ld	s8,32(sp)
    8000488c:	6ce2                	ld	s9,24(sp)
    8000488e:	6d42                	ld	s10,16(sp)
    80004890:	a829                	j	800048aa <pipewrite+0x108>
          i = -1;
    80004892:	892a                	mv	s2,a0
        break;
    80004894:	7b42                	ld	s6,48(sp)
    80004896:	7ba2                	ld	s7,40(sp)
    80004898:	7c02                	ld	s8,32(sp)
    8000489a:	6ce2                	ld	s9,24(sp)
    8000489c:	6d42                	ld	s10,16(sp)
    8000489e:	a031                	j	800048aa <pipewrite+0x108>
    800048a0:	7b42                	ld	s6,48(sp)
    800048a2:	7ba2                	ld	s7,40(sp)
    800048a4:	7c02                	ld	s8,32(sp)
    800048a6:	6ce2                	ld	s9,24(sp)
    800048a8:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800048aa:	21848513          	addi	a0,s1,536
    800048ae:	fb0fd0ef          	jal	8000205e <wakeup>
  release(&pi->lock);
    800048b2:	8526                	mv	a0,s1
    800048b4:	bbcfc0ef          	jal	80000c70 <release>
  return i;
    800048b8:	b789                	j	800047fa <pipewrite+0x58>
  int i = 0;
    800048ba:	4901                	li	s2,0
    800048bc:	b7fd                	j	800048aa <pipewrite+0x108>

00000000800048be <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800048be:	711d                	addi	sp,sp,-96
    800048c0:	ec86                	sd	ra,88(sp)
    800048c2:	e8a2                	sd	s0,80(sp)
    800048c4:	e4a6                	sd	s1,72(sp)
    800048c6:	e0ca                	sd	s2,64(sp)
    800048c8:	fc4e                	sd	s3,56(sp)
    800048ca:	f852                	sd	s4,48(sp)
    800048cc:	f456                	sd	s5,40(sp)
    800048ce:	1080                	addi	s0,sp,96
    800048d0:	84aa                	mv	s1,a0
    800048d2:	89ae                	mv	s3,a1
    800048d4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800048d6:	852fd0ef          	jal	80001928 <myproc>
    800048da:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    800048dc:	8526                	mv	a0,s1
    800048de:	b0afc0ef          	jal	80000be8 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800048e2:	2184a703          	lw	a4,536(s1)
    800048e6:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    800048ea:	21848a13          	addi	s4,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800048ee:	02f71e63          	bne	a4,a5,8000492a <piperead+0x6c>
    800048f2:	2244a783          	lw	a5,548(s1)
    800048f6:	c3b9                	beqz	a5,8000493c <piperead+0x7e>
    if (killed(pr)) {
    800048f8:	854a                	mv	a0,s2
    800048fa:	951fd0ef          	jal	8000224a <killed>
    800048fe:	e915                	bnez	a0,80004932 <piperead+0x74>
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    80004900:	8552                	mv	a0,s4
    80004902:	ef0fd0ef          	jal	80001ff2 <sleep_prepare>
    release(&pi->lock);
    80004906:	8526                	mv	a0,s1
    80004908:	b68fc0ef          	jal	80000c70 <release>
    sleep();
    8000490c:	f22fd0ef          	jal	8000202e <sleep>
    acquire(&pi->lock);
    80004910:	8526                	mv	a0,s1
    80004912:	ad6fc0ef          	jal	80000be8 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004916:	2184a703          	lw	a4,536(s1)
    8000491a:	21c4a783          	lw	a5,540(s1)
    8000491e:	fcf70ae3          	beq	a4,a5,800048f2 <piperead+0x34>
    80004922:	f05a                	sd	s6,32(sp)
    80004924:	ec5e                	sd	s7,24(sp)
    80004926:	e862                	sd	s8,16(sp)
    80004928:	a829                	j	80004942 <piperead+0x84>
    8000492a:	f05a                	sd	s6,32(sp)
    8000492c:	ec5e                	sd	s7,24(sp)
    8000492e:	e862                	sd	s8,16(sp)
    80004930:	a809                	j	80004942 <piperead+0x84>
      release(&pi->lock);
    80004932:	8526                	mv	a0,s1
    80004934:	b3cfc0ef          	jal	80000c70 <release>
      return -1;
    80004938:	5a7d                	li	s4,-1
    8000493a:	a0b5                	j	800049a6 <piperead+0xe8>
    8000493c:	f05a                	sd	s6,32(sp)
    8000493e:	ec5e                	sd	s7,24(sp)
    80004940:	e862                	sd	s8,16(sp)
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004942:	4a01                	li	s4,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80004944:	faf40c13          	addi	s8,s0,-81
    80004948:	4b85                	li	s7,1
    8000494a:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    8000494c:	05505363          	blez	s5,80004992 <piperead+0xd4>
    if (pi->nread == pi->nwrite)
    80004950:	2184a783          	lw	a5,536(s1)
    80004954:	21c4a703          	lw	a4,540(s1)
    80004958:	02f70d63          	beq	a4,a5,80004992 <piperead+0xd4>
    ch = pi->data[pi->nread % PIPESIZE];
    8000495c:	1ff7f793          	andi	a5,a5,511
    80004960:	97a6                	add	a5,a5,s1
    80004962:	0187c783          	lbu	a5,24(a5)
    80004966:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    8000496a:	875e                	mv	a4,s7
    8000496c:	86e2                	mv	a3,s8
    8000496e:	864e                	mv	a2,s3
    80004970:	04893583          	ld	a1,72(s2)
    80004974:	05893503          	ld	a0,88(s2)
    80004978:	bcffc0ef          	jal	80001546 <copyout>
    8000497c:	03650f63          	beq	a0,s6,800049ba <piperead+0xfc>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80004980:	2184a783          	lw	a5,536(s1)
    80004984:	2785                	addiw	a5,a5,1
    80004986:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    8000498a:	2a05                	addiw	s4,s4,1
    8000498c:	0985                	addi	s3,s3,1
    8000498e:	fd4a91e3          	bne	s5,s4,80004950 <piperead+0x92>
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    80004992:	21c48513          	addi	a0,s1,540
    80004996:	ec8fd0ef          	jal	8000205e <wakeup>
  release(&pi->lock);
    8000499a:	8526                	mv	a0,s1
    8000499c:	ad4fc0ef          	jal	80000c70 <release>
    800049a0:	7b02                	ld	s6,32(sp)
    800049a2:	6be2                	ld	s7,24(sp)
    800049a4:	6c42                	ld	s8,16(sp)
  return i;
}
    800049a6:	8552                	mv	a0,s4
    800049a8:	60e6                	ld	ra,88(sp)
    800049aa:	6446                	ld	s0,80(sp)
    800049ac:	64a6                	ld	s1,72(sp)
    800049ae:	6906                	ld	s2,64(sp)
    800049b0:	79e2                	ld	s3,56(sp)
    800049b2:	7a42                	ld	s4,48(sp)
    800049b4:	7aa2                	ld	s5,40(sp)
    800049b6:	6125                	addi	sp,sp,96
    800049b8:	8082                	ret
      if (i == 0)
    800049ba:	fc0a1ce3          	bnez	s4,80004992 <piperead+0xd4>
        i = -1;
    800049be:	8a2a                	mv	s4,a0
    800049c0:	bfc9                	j	80004992 <piperead+0xd4>

00000000800049c2 <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    800049c2:	1141                	addi	sp,sp,-16
    800049c4:	e406                	sd	ra,8(sp)
    800049c6:	e022                	sd	s0,0(sp)
    800049c8:	0800                	addi	s0,sp,16
    800049ca:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    800049cc:	0035151b          	slliw	a0,a0,0x3
    800049d0:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    800049d2:	8b89                	andi	a5,a5,2
    800049d4:	c399                	beqz	a5,800049da <flags2perm+0x18>
    perm |= PTE_W;
    800049d6:	00456513          	ori	a0,a0,4
  return perm;
}
    800049da:	60a2                	ld	ra,8(sp)
    800049dc:	6402                	ld	s0,0(sp)
    800049de:	0141                	addi	sp,sp,16
    800049e0:	8082                	ret

00000000800049e2 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800049e2:	de010113          	addi	sp,sp,-544
    800049e6:	20113c23          	sd	ra,536(sp)
    800049ea:	20813823          	sd	s0,528(sp)
    800049ee:	20913423          	sd	s1,520(sp)
    800049f2:	21213023          	sd	s2,512(sp)
    800049f6:	1400                	addi	s0,sp,544
    800049f8:	892a                	mv	s2,a0
    800049fa:	dea43823          	sd	a0,-528(s0)
    800049fe:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004a02:	f27fc0ef          	jal	80001928 <myproc>
    80004a06:	84aa                	mv	s1,a0

  begin_op();
    80004a08:	c86ff0ef          	jal	80003e8e <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    80004a0c:	854a                	mv	a0,s2
    80004a0e:	aa2ff0ef          	jal	80003cb0 <namei>
    80004a12:	cd21                	beqz	a0,80004a6a <kexec+0x88>
    80004a14:	fbd2                	sd	s4,496(sp)
    80004a16:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004a18:	a0dfe0ef          	jal	80003424 <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004a1c:	04000713          	li	a4,64
    80004a20:	4681                	li	a3,0
    80004a22:	e5040613          	addi	a2,s0,-432
    80004a26:	4581                	li	a1,0
    80004a28:	8552                	mv	a0,s4
    80004a2a:	dd5fe0ef          	jal	800037fe <readi>
    80004a2e:	04000793          	li	a5,64
    80004a32:	00f51a63          	bne	a0,a5,80004a46 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    80004a36:	e5042703          	lw	a4,-432(s0)
    80004a3a:	464c47b7          	lui	a5,0x464c4
    80004a3e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004a42:	02f70863          	beq	a4,a5,80004a72 <kexec+0x90>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80004a46:	8552                	mv	a0,s4
    80004a48:	c31fe0ef          	jal	80003678 <iunlockput>
    end_op();
    80004a4c:	cceff0ef          	jal	80003f1a <end_op>
  }
  return -1;
    80004a50:	557d                	li	a0,-1
    80004a52:	7a5e                	ld	s4,496(sp)
}
    80004a54:	21813083          	ld	ra,536(sp)
    80004a58:	21013403          	ld	s0,528(sp)
    80004a5c:	20813483          	ld	s1,520(sp)
    80004a60:	20013903          	ld	s2,512(sp)
    80004a64:	22010113          	addi	sp,sp,544
    80004a68:	8082                	ret
    end_op();
    80004a6a:	cb0ff0ef          	jal	80003f1a <end_op>
    return -1;
    80004a6e:	557d                	li	a0,-1
    80004a70:	b7d5                	j	80004a54 <kexec+0x72>
    80004a72:	f3da                	sd	s6,480(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    80004a74:	8526                	mv	a0,s1
    80004a76:	fc9fc0ef          	jal	80001a3e <proc_pagetable>
    80004a7a:	8b2a                	mv	s6,a0
    80004a7c:	26050e63          	beqz	a0,80004cf8 <kexec+0x316>
    80004a80:	ffce                	sd	s3,504(sp)
    80004a82:	f7d6                	sd	s5,488(sp)
    80004a84:	efde                	sd	s7,472(sp)
    80004a86:	ebe2                	sd	s8,464(sp)
    80004a88:	e7e6                	sd	s9,456(sp)
    80004a8a:	e3ea                	sd	s10,448(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004a8c:	e8845783          	lhu	a5,-376(s0)
    80004a90:	14078263          	beqz	a5,80004bd4 <kexec+0x1f2>
    80004a94:	ff6e                	sd	s11,440(sp)
    80004a96:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004a9a:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004a9c:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004a9e:	03800d93          	li	s11,56
    if (ph.vaddr % PGSIZE != 0)
    80004aa2:	6c85                	lui	s9,0x1
    80004aa4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004aa8:	def43423          	sd	a5,-536(s0)

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    80004aac:	6a85                	lui	s5,0x1
    80004aae:	a085                	j	80004b0e <kexec+0x12c>
      panic("loadseg: address should exist");
    80004ab0:	00004517          	auipc	a0,0x4
    80004ab4:	b2050513          	addi	a0,a0,-1248 # 800085d0 <etext+0x5d0>
    80004ab8:	d7dfb0ef          	jal	80000834 <panic>
    if (sz - i < PGSIZE)
    80004abc:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004abe:	874a                	mv	a4,s2
    80004ac0:	009b86bb          	addw	a3,s7,s1
    80004ac4:	4581                	li	a1,0
    80004ac6:	8552                	mv	a0,s4
    80004ac8:	d37fe0ef          	jal	800037fe <readi>
    80004acc:	22a91a63          	bne	s2,a0,80004d00 <kexec+0x31e>
  for (i = 0; i < sz; i += PGSIZE) {
    80004ad0:	009a84bb          	addw	s1,s5,s1
    80004ad4:	0334f263          	bgeu	s1,s3,80004af8 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80004ad8:	02049593          	slli	a1,s1,0x20
    80004adc:	9181                	srli	a1,a1,0x20
    80004ade:	95e2                	add	a1,a1,s8
    80004ae0:	855a                	mv	a0,s6
    80004ae2:	cfafc0ef          	jal	80000fdc <walkaddr>
    80004ae6:	862a                	mv	a2,a0
    if (pa == 0)
    80004ae8:	d561                	beqz	a0,80004ab0 <kexec+0xce>
    if (sz - i < PGSIZE)
    80004aea:	409987bb          	subw	a5,s3,s1
    80004aee:	893e                	mv	s2,a5
    80004af0:	fcfcf6e3          	bgeu	s9,a5,80004abc <kexec+0xda>
    80004af4:	8956                	mv	s2,s5
    80004af6:	b7d9                	j	80004abc <kexec+0xda>
    sz = sz1;
    80004af8:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004afc:	2d05                	addiw	s10,s10,1
    80004afe:	e0843783          	ld	a5,-504(s0)
    80004b02:	0387869b          	addiw	a3,a5,56
    80004b06:	e8845783          	lhu	a5,-376(s0)
    80004b0a:	06fd5d63          	bge	s10,a5,80004b84 <kexec+0x1a2>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004b0e:	e0d43423          	sd	a3,-504(s0)
    80004b12:	876e                	mv	a4,s11
    80004b14:	e1840613          	addi	a2,s0,-488
    80004b18:	4581                	li	a1,0
    80004b1a:	8552                	mv	a0,s4
    80004b1c:	ce3fe0ef          	jal	800037fe <readi>
    80004b20:	1db51e63          	bne	a0,s11,80004cfc <kexec+0x31a>
    if (ph.type != ELF_PROG_LOAD)
    80004b24:	e1842783          	lw	a5,-488(s0)
    80004b28:	4705                	li	a4,1
    80004b2a:	fce799e3          	bne	a5,a4,80004afc <kexec+0x11a>
    if (ph.memsz < ph.filesz)
    80004b2e:	e4043483          	ld	s1,-448(s0)
    80004b32:	e3843783          	ld	a5,-456(s0)
    80004b36:	1ef4e363          	bltu	s1,a5,80004d1c <kexec+0x33a>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80004b3a:	e2843783          	ld	a5,-472(s0)
    80004b3e:	94be                	add	s1,s1,a5
    80004b40:	1ef4e163          	bltu	s1,a5,80004d22 <kexec+0x340>
    if (ph.vaddr % PGSIZE != 0)
    80004b44:	de843703          	ld	a4,-536(s0)
    80004b48:	8ff9                	and	a5,a5,a4
    80004b4a:	1c079f63          	bnez	a5,80004d28 <kexec+0x346>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004b4e:	e1c42503          	lw	a0,-484(s0)
    80004b52:	e71ff0ef          	jal	800049c2 <flags2perm>
    80004b56:	86aa                	mv	a3,a0
    80004b58:	8626                	mv	a2,s1
    80004b5a:	85ca                	mv	a1,s2
    80004b5c:	855a                	mv	a0,s6
    80004b5e:	f54fc0ef          	jal	800012b2 <uvmalloc>
    80004b62:	dea43c23          	sd	a0,-520(s0)
    80004b66:	1c050463          	beqz	a0,80004d2e <kexec+0x34c>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004b6a:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004b6e:	00098863          	beqz	s3,80004b7e <kexec+0x19c>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004b72:	e2843c03          	ld	s8,-472(s0)
    80004b76:	e2042b83          	lw	s7,-480(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004b7a:	4481                	li	s1,0
    80004b7c:	bfb1                	j	80004ad8 <kexec+0xf6>
    sz = sz1;
    80004b7e:	df843903          	ld	s2,-520(s0)
    80004b82:	bfad                	j	80004afc <kexec+0x11a>
    80004b84:	7dfa                	ld	s11,440(sp)
  iunlockput(ip);
    80004b86:	8552                	mv	a0,s4
    80004b88:	af1fe0ef          	jal	80003678 <iunlockput>
  end_op();
    80004b8c:	b8eff0ef          	jal	80003f1a <end_op>
  p = myproc();
    80004b90:	d99fc0ef          	jal	80001928 <myproc>
    80004b94:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    80004b96:	04853a83          	ld	s5,72(a0)
  sz = PGROUNDUP(sz);
    80004b9a:	6c05                	lui	s8,0x1
    80004b9c:	1c7d                	addi	s8,s8,-1 # fff <_entry-0x7ffff001>
    80004b9e:	9c4a                	add	s8,s8,s2
    80004ba0:	77fd                	lui	a5,0xfffff
    80004ba2:	00fc7c33          	and	s8,s8,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    80004ba6:	4691                	li	a3,4
    80004ba8:	6609                	lui	a2,0x2
    80004baa:	9662                	add	a2,a2,s8
    80004bac:	85e2                	mv	a1,s8
    80004bae:	855a                	mv	a0,s6
    80004bb0:	f02fc0ef          	jal	800012b2 <uvmalloc>
    80004bb4:	892a                	mv	s2,a0
    80004bb6:	e10d                	bnez	a0,80004bd8 <kexec+0x1f6>
    proc_freepagetable(pagetable, sz);
    80004bb8:	85e2                	mv	a1,s8
    80004bba:	855a                	mv	a0,s6
    80004bbc:	f07fc0ef          	jal	80001ac2 <proc_freepagetable>
  return -1;
    80004bc0:	557d                	li	a0,-1
    80004bc2:	79fe                	ld	s3,504(sp)
    80004bc4:	7a5e                	ld	s4,496(sp)
    80004bc6:	7abe                	ld	s5,488(sp)
    80004bc8:	7b1e                	ld	s6,480(sp)
    80004bca:	6bfe                	ld	s7,472(sp)
    80004bcc:	6c5e                	ld	s8,464(sp)
    80004bce:	6cbe                	ld	s9,456(sp)
    80004bd0:	6d1e                	ld	s10,448(sp)
    80004bd2:	b549                	j	80004a54 <kexec+0x72>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004bd4:	4901                	li	s2,0
    80004bd6:	bf45                	j	80004b86 <kexec+0x1a4>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    80004bd8:	75f9                	lui	a1,0xffffe
    80004bda:	95aa                	add	a1,a1,a0
    80004bdc:	855a                	mv	a0,s6
    80004bde:	8a7fc0ef          	jal	80001484 <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    80004be2:	80090a13          	addi	s4,s2,-2048
    80004be6:	800a0a13          	addi	s4,s4,-2048
  for (argc = 0; argv[argc]; argc++) {
    80004bea:	e0043783          	ld	a5,-512(s0)
    80004bee:	6388                	ld	a0,0(a5)
    80004bf0:	c545                	beqz	a0,80004c98 <kexec+0x2b6>
  sp = sz;
    80004bf2:	8c4a                	mv	s8,s2
  for (argc = 0; argv[argc]; argc++) {
    80004bf4:	4481                	li	s1,0
    ustack[argc] = sp;
    80004bf6:	e9040b93          	addi	s7,s0,-368
    sp -= strlen(argv[argc]) + 1;
    80004bfa:	a38fc0ef          	jal	80000e32 <strlen>
    80004bfe:	0015079b          	addiw	a5,a0,1
    80004c02:	40fc07b3          	sub	a5,s8,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004c06:	ff07fc13          	andi	s8,a5,-16
    if (sp < stackbase)
    80004c0a:	134c6563          	bltu	s8,s4,80004d34 <kexec+0x352>
    if (copyout(pagetable, sz, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004c0e:	e0043d03          	ld	s10,-512(s0)
    80004c12:	000d3c83          	ld	s9,0(s10)
    80004c16:	8566                	mv	a0,s9
    80004c18:	a1afc0ef          	jal	80000e32 <strlen>
    80004c1c:	0015071b          	addiw	a4,a0,1
    80004c20:	86e6                	mv	a3,s9
    80004c22:	8662                	mv	a2,s8
    80004c24:	85ca                	mv	a1,s2
    80004c26:	855a                	mv	a0,s6
    80004c28:	91ffc0ef          	jal	80001546 <copyout>
    80004c2c:	10054663          	bltz	a0,80004d38 <kexec+0x356>
    ustack[argc] = sp;
    80004c30:	00349793          	slli	a5,s1,0x3
    80004c34:	97de                	add	a5,a5,s7
    80004c36:	0187b023          	sd	s8,0(a5) # fffffffffffff000 <end+0xffffffff7ffda370>
  for (argc = 0; argv[argc]; argc++) {
    80004c3a:	0485                	addi	s1,s1,1
    80004c3c:	008d0793          	addi	a5,s10,8
    80004c40:	e0f43023          	sd	a5,-512(s0)
    80004c44:	008d3503          	ld	a0,8(s10)
    80004c48:	f94d                	bnez	a0,80004bfa <kexec+0x218>
  ustack[argc] = 0;
    80004c4a:	00349793          	slli	a5,s1,0x3
    80004c4e:	f9078793          	addi	a5,a5,-112
    80004c52:	97a2                	add	a5,a5,s0
    80004c54:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004c58:	00349713          	slli	a4,s1,0x3
    80004c5c:	0721                	addi	a4,a4,8
    80004c5e:	40ec0bb3          	sub	s7,s8,a4
  sp -= sp % 16;
    80004c62:	ff0bfb93          	andi	s7,s7,-16
  sz = sz1;
    80004c66:	8c4a                	mv	s8,s2
  if (sp < stackbase)
    80004c68:	f54be8e3          	bltu	s7,s4,80004bb8 <kexec+0x1d6>
  if (copyout(pagetable, sz, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) <
    80004c6c:	e9040693          	addi	a3,s0,-368
    80004c70:	865e                	mv	a2,s7
    80004c72:	85ca                	mv	a1,s2
    80004c74:	855a                	mv	a0,s6
    80004c76:	8d1fc0ef          	jal	80001546 <copyout>
    80004c7a:	f2054fe3          	bltz	a0,80004bb8 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80004c7e:	0609b783          	ld	a5,96(s3)
    80004c82:	0777bc23          	sd	s7,120(a5)
  for (last = s = path; *s; s++)
    80004c86:	df043783          	ld	a5,-528(s0)
    80004c8a:	0007c703          	lbu	a4,0(a5)
    80004c8e:	c30d                	beqz	a4,80004cb0 <kexec+0x2ce>
    80004c90:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004c92:	02f00693          	li	a3,47
    80004c96:	a801                	j	80004ca6 <kexec+0x2c4>
  sp = sz;
    80004c98:	8c4a                	mv	s8,s2
  for (argc = 0; argv[argc]; argc++) {
    80004c9a:	4481                	li	s1,0
    80004c9c:	b77d                	j	80004c4a <kexec+0x268>
  for (last = s = path; *s; s++)
    80004c9e:	0785                	addi	a5,a5,1
    80004ca0:	fff7c703          	lbu	a4,-1(a5)
    80004ca4:	c711                	beqz	a4,80004cb0 <kexec+0x2ce>
    if (*s == '/')
    80004ca6:	fed71ce3          	bne	a4,a3,80004c9e <kexec+0x2bc>
      last = s + 1;
    80004caa:	def43823          	sd	a5,-528(s0)
    80004cae:	bfc5                	j	80004c9e <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80004cb0:	4641                	li	a2,16
    80004cb2:	df043583          	ld	a1,-528(s0)
    80004cb6:	16098513          	addi	a0,s3,352
    80004cba:	942fc0ef          	jal	80000dfc <safestrcpy>
  oldpagetable = p->pagetable;
    80004cbe:	0589b503          	ld	a0,88(s3)
  p->pagetable = pagetable;
    80004cc2:	0569bc23          	sd	s6,88(s3)
  p->sz = sz;
    80004cc6:	0529b423          	sd	s2,72(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80004cca:	0609b783          	ld	a5,96(s3)
    80004cce:	e6843703          	ld	a4,-408(s0)
    80004cd2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004cd4:	0609b783          	ld	a5,96(s3)
    80004cd8:	0377b823          	sd	s7,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004cdc:	85d6                	mv	a1,s5
    80004cde:	de5fc0ef          	jal	80001ac2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004ce2:	0004851b          	sext.w	a0,s1
    80004ce6:	79fe                	ld	s3,504(sp)
    80004ce8:	7a5e                	ld	s4,496(sp)
    80004cea:	7abe                	ld	s5,488(sp)
    80004cec:	7b1e                	ld	s6,480(sp)
    80004cee:	6bfe                	ld	s7,472(sp)
    80004cf0:	6c5e                	ld	s8,464(sp)
    80004cf2:	6cbe                	ld	s9,456(sp)
    80004cf4:	6d1e                	ld	s10,448(sp)
    80004cf6:	bbb9                	j	80004a54 <kexec+0x72>
    80004cf8:	7b1e                	ld	s6,480(sp)
    80004cfa:	b3b1                	j	80004a46 <kexec+0x64>
    80004cfc:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004d00:	df843583          	ld	a1,-520(s0)
    80004d04:	855a                	mv	a0,s6
    80004d06:	dbdfc0ef          	jal	80001ac2 <proc_freepagetable>
  if (ip) {
    80004d0a:	79fe                	ld	s3,504(sp)
    80004d0c:	7abe                	ld	s5,488(sp)
    80004d0e:	7b1e                	ld	s6,480(sp)
    80004d10:	6bfe                	ld	s7,472(sp)
    80004d12:	6c5e                	ld	s8,464(sp)
    80004d14:	6cbe                	ld	s9,456(sp)
    80004d16:	6d1e                	ld	s10,448(sp)
    80004d18:	7dfa                	ld	s11,440(sp)
    80004d1a:	b335                	j	80004a46 <kexec+0x64>
    80004d1c:	df243c23          	sd	s2,-520(s0)
    80004d20:	b7c5                	j	80004d00 <kexec+0x31e>
    80004d22:	df243c23          	sd	s2,-520(s0)
    80004d26:	bfe9                	j	80004d00 <kexec+0x31e>
    80004d28:	df243c23          	sd	s2,-520(s0)
    80004d2c:	bfd1                	j	80004d00 <kexec+0x31e>
    80004d2e:	df243c23          	sd	s2,-520(s0)
    80004d32:	b7f9                	j	80004d00 <kexec+0x31e>
  sz = sz1;
    80004d34:	8c4a                	mv	s8,s2
    80004d36:	b549                	j	80004bb8 <kexec+0x1d6>
    80004d38:	8c4a                	mv	s8,s2
    80004d3a:	bdbd                	j	80004bb8 <kexec+0x1d6>

0000000080004d3c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004d3c:	7179                	addi	sp,sp,-48
    80004d3e:	f406                	sd	ra,40(sp)
    80004d40:	f022                	sd	s0,32(sp)
    80004d42:	ec26                	sd	s1,24(sp)
    80004d44:	e84a                	sd	s2,16(sp)
    80004d46:	1800                	addi	s0,sp,48
    80004d48:	892e                	mv	s2,a1
    80004d4a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004d4c:	fdc40593          	addi	a1,s0,-36
    80004d50:	bdbfd0ef          	jal	8000292a <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004d54:	fdc42703          	lw	a4,-36(s0)
    80004d58:	47bd                	li	a5,15
    80004d5a:	02e7ea63          	bltu	a5,a4,80004d8e <argfd+0x52>
    80004d5e:	bcbfc0ef          	jal	80001928 <myproc>
    80004d62:	fdc42703          	lw	a4,-36(s0)
    80004d66:	00371793          	slli	a5,a4,0x3
    80004d6a:	0d078793          	addi	a5,a5,208
    80004d6e:	953e                	add	a0,a0,a5
    80004d70:	651c                	ld	a5,8(a0)
    80004d72:	c385                	beqz	a5,80004d92 <argfd+0x56>
    return -1;
  if (pfd)
    80004d74:	00090463          	beqz	s2,80004d7c <argfd+0x40>
    *pfd = fd;
    80004d78:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80004d7c:	4501                	li	a0,0
  if (pf)
    80004d7e:	c091                	beqz	s1,80004d82 <argfd+0x46>
    *pf = f;
    80004d80:	e09c                	sd	a5,0(s1)
}
    80004d82:	70a2                	ld	ra,40(sp)
    80004d84:	7402                	ld	s0,32(sp)
    80004d86:	64e2                	ld	s1,24(sp)
    80004d88:	6942                	ld	s2,16(sp)
    80004d8a:	6145                	addi	sp,sp,48
    80004d8c:	8082                	ret
    return -1;
    80004d8e:	557d                	li	a0,-1
    80004d90:	bfcd                	j	80004d82 <argfd+0x46>
    80004d92:	557d                	li	a0,-1
    80004d94:	b7fd                	j	80004d82 <argfd+0x46>

0000000080004d96 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004d96:	1101                	addi	sp,sp,-32
    80004d98:	ec06                	sd	ra,24(sp)
    80004d9a:	e822                	sd	s0,16(sp)
    80004d9c:	e426                	sd	s1,8(sp)
    80004d9e:	1000                	addi	s0,sp,32
    80004da0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004da2:	b87fc0ef          	jal	80001928 <myproc>
    80004da6:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004da8:	0d850793          	addi	a5,a0,216
    80004dac:	4501                	li	a0,0
    80004dae:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004db0:	6398                	ld	a4,0(a5)
    80004db2:	cb19                	beqz	a4,80004dc8 <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004db4:	2505                	addiw	a0,a0,1
    80004db6:	07a1                	addi	a5,a5,8
    80004db8:	fed51ce3          	bne	a0,a3,80004db0 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004dbc:	557d                	li	a0,-1
}
    80004dbe:	60e2                	ld	ra,24(sp)
    80004dc0:	6442                	ld	s0,16(sp)
    80004dc2:	64a2                	ld	s1,8(sp)
    80004dc4:	6105                	addi	sp,sp,32
    80004dc6:	8082                	ret
      p->ofile[fd] = f;
    80004dc8:	00351793          	slli	a5,a0,0x3
    80004dcc:	0d078793          	addi	a5,a5,208
    80004dd0:	963e                	add	a2,a2,a5
    80004dd2:	e604                	sd	s1,8(a2)
      return fd;
    80004dd4:	b7ed                	j	80004dbe <fdalloc+0x28>

0000000080004dd6 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004dd6:	715d                	addi	sp,sp,-80
    80004dd8:	e486                	sd	ra,72(sp)
    80004dda:	e0a2                	sd	s0,64(sp)
    80004ddc:	fc26                	sd	s1,56(sp)
    80004dde:	f84a                	sd	s2,48(sp)
    80004de0:	f052                	sd	s4,32(sp)
    80004de2:	ec56                	sd	s5,24(sp)
    80004de4:	e85a                	sd	s6,16(sp)
    80004de6:	0880                	addi	s0,sp,80
    80004de8:	8a2e                	mv	s4,a1
    80004dea:	8ab2                	mv	s5,a2
    80004dec:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004dee:	fb040593          	addi	a1,s0,-80
    80004df2:	ed9fe0ef          	jal	80003cca <nameiparent>
    80004df6:	84aa                	mv	s1,a0
    80004df8:	12050f63          	beqz	a0,80004f36 <create+0x160>
    return 0;

  ilock(dp);
    80004dfc:	e28fe0ef          	jal	80003424 <ilock>

  if (dp->nlink == 0) {
    80004e00:	04a49783          	lh	a5,74(s1)
    80004e04:	cbb9                	beqz	a5,80004e5a <create+0x84>
    iunlockput(dp);
    return 0;
  }

  // a new directory's ".." would push dp->nlink past its maximum
  if (type == T_DIR && dp->nlink >= NLINK_MAX) {
    80004e06:	7761                	lui	a4,0xffff8
    80004e08:	0705                	addi	a4,a4,1 # ffffffffffff8001 <end+0xffffffff7ffd3371>
    80004e0a:	97ba                	add	a5,a5,a4
    80004e0c:	e781                	bnez	a5,80004e14 <create+0x3e>
    80004e0e:	fffa0793          	addi	a5,s4,-1
    80004e12:	cba9                	beqz	a5,80004e64 <create+0x8e>
    iunlockput(dp);
    return 0;
  }

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004e14:	4601                	li	a2,0
    80004e16:	fb040593          	addi	a1,s0,-80
    80004e1a:	8526                	mv	a0,s1
    80004e1c:	bf1fe0ef          	jal	80003a0c <dirlookup>
    80004e20:	892a                	mv	s2,a0
    80004e22:	c939                	beqz	a0,80004e78 <create+0xa2>
    iunlockput(dp);
    80004e24:	8526                	mv	a0,s1
    80004e26:	853fe0ef          	jal	80003678 <iunlockput>
    ilock(ip);
    80004e2a:	854a                	mv	a0,s2
    80004e2c:	df8fe0ef          	jal	80003424 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004e30:	4789                	li	a5,2
    80004e32:	02fa1e63          	bne	s4,a5,80004e6e <create+0x98>
    80004e36:	04495783          	lhu	a5,68(s2)
    80004e3a:	37f9                	addiw	a5,a5,-2
    80004e3c:	17c2                	slli	a5,a5,0x30
    80004e3e:	93c1                	srli	a5,a5,0x30
    80004e40:	4705                	li	a4,1
    80004e42:	02f76663          	bltu	a4,a5,80004e6e <create+0x98>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004e46:	854a                	mv	a0,s2
    80004e48:	60a6                	ld	ra,72(sp)
    80004e4a:	6406                	ld	s0,64(sp)
    80004e4c:	74e2                	ld	s1,56(sp)
    80004e4e:	7942                	ld	s2,48(sp)
    80004e50:	7a02                	ld	s4,32(sp)
    80004e52:	6ae2                	ld	s5,24(sp)
    80004e54:	6b42                	ld	s6,16(sp)
    80004e56:	6161                	addi	sp,sp,80
    80004e58:	8082                	ret
    iunlockput(dp);
    80004e5a:	8526                	mv	a0,s1
    80004e5c:	81dfe0ef          	jal	80003678 <iunlockput>
    return 0;
    80004e60:	4901                	li	s2,0
    80004e62:	b7d5                	j	80004e46 <create+0x70>
    iunlockput(dp);
    80004e64:	8526                	mv	a0,s1
    80004e66:	813fe0ef          	jal	80003678 <iunlockput>
    return 0;
    80004e6a:	4901                	li	s2,0
    80004e6c:	bfe9                	j	80004e46 <create+0x70>
    iunlockput(ip);
    80004e6e:	854a                	mv	a0,s2
    80004e70:	809fe0ef          	jal	80003678 <iunlockput>
    return 0;
    80004e74:	4901                	li	s2,0
    80004e76:	bfc1                	j	80004e46 <create+0x70>
    80004e78:	f44e                	sd	s3,40(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004e7a:	85d2                	mv	a1,s4
    80004e7c:	4088                	lw	a0,0(s1)
    80004e7e:	c36fe0ef          	jal	800032b4 <ialloc>
    80004e82:	89aa                	mv	s3,a0
    80004e84:	cd1d                	beqz	a0,80004ec2 <create+0xec>
  ilock(ip);
    80004e86:	d9efe0ef          	jal	80003424 <ilock>
  ip->major = major;
    80004e8a:	05599323          	sh	s5,70(s3)
  ip->minor = minor;
    80004e8e:	05699423          	sh	s6,72(s3)
  ip->nlink = 1;
    80004e92:	4705                	li	a4,1
    80004e94:	04e99523          	sh	a4,74(s3)
  iupdate(ip);
    80004e98:	854e                	mv	a0,s3
    80004e9a:	cd6fe0ef          	jal	80003370 <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80004e9e:	4705                	li	a4,1
    80004ea0:	02ea0763          	beq	s4,a4,80004ece <create+0xf8>
  if (dirlink(dp, name, ip->inum) < 0)
    80004ea4:	0049a603          	lw	a2,4(s3)
    80004ea8:	fb040593          	addi	a1,s0,-80
    80004eac:	8526                	mv	a0,s1
    80004eae:	d59fe0ef          	jal	80003c06 <dirlink>
    80004eb2:	06054563          	bltz	a0,80004f1c <create+0x146>
  iunlockput(dp);
    80004eb6:	8526                	mv	a0,s1
    80004eb8:	fc0fe0ef          	jal	80003678 <iunlockput>
  return ip;
    80004ebc:	894e                	mv	s2,s3
    80004ebe:	79a2                	ld	s3,40(sp)
    80004ec0:	b759                	j	80004e46 <create+0x70>
    iunlockput(dp);
    80004ec2:	8526                	mv	a0,s1
    80004ec4:	fb4fe0ef          	jal	80003678 <iunlockput>
    return 0;
    80004ec8:	894e                	mv	s2,s3
    80004eca:	79a2                	ld	s3,40(sp)
    80004ecc:	bfad                	j	80004e46 <create+0x70>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004ece:	0049a603          	lw	a2,4(s3)
    80004ed2:	00003597          	auipc	a1,0x3
    80004ed6:	71e58593          	addi	a1,a1,1822 # 800085f0 <etext+0x5f0>
    80004eda:	854e                	mv	a0,s3
    80004edc:	d2bfe0ef          	jal	80003c06 <dirlink>
    80004ee0:	02054e63          	bltz	a0,80004f1c <create+0x146>
    80004ee4:	40d0                	lw	a2,4(s1)
    80004ee6:	00003597          	auipc	a1,0x3
    80004eea:	71258593          	addi	a1,a1,1810 # 800085f8 <etext+0x5f8>
    80004eee:	854e                	mv	a0,s3
    80004ef0:	d17fe0ef          	jal	80003c06 <dirlink>
    80004ef4:	02054463          	bltz	a0,80004f1c <create+0x146>
  if (dirlink(dp, name, ip->inum) < 0)
    80004ef8:	0049a603          	lw	a2,4(s3)
    80004efc:	fb040593          	addi	a1,s0,-80
    80004f00:	8526                	mv	a0,s1
    80004f02:	d05fe0ef          	jal	80003c06 <dirlink>
    80004f06:	00054b63          	bltz	a0,80004f1c <create+0x146>
    dp->nlink++; // for ".."
    80004f0a:	04a4d783          	lhu	a5,74(s1)
    80004f0e:	2785                	addiw	a5,a5,1
    80004f10:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004f14:	8526                	mv	a0,s1
    80004f16:	c5afe0ef          	jal	80003370 <iupdate>
    80004f1a:	bf71                	j	80004eb6 <create+0xe0>
  ip->nlink = 0;
    80004f1c:	04099523          	sh	zero,74(s3)
  iupdate(ip);
    80004f20:	854e                	mv	a0,s3
    80004f22:	c4efe0ef          	jal	80003370 <iupdate>
  iunlockput(ip);
    80004f26:	854e                	mv	a0,s3
    80004f28:	f50fe0ef          	jal	80003678 <iunlockput>
  iunlockput(dp);
    80004f2c:	8526                	mv	a0,s1
    80004f2e:	f4afe0ef          	jal	80003678 <iunlockput>
  return 0;
    80004f32:	79a2                	ld	s3,40(sp)
    80004f34:	bf09                	j	80004e46 <create+0x70>
    return 0;
    80004f36:	892a                	mv	s2,a0
    80004f38:	b739                	j	80004e46 <create+0x70>

0000000080004f3a <sys_dup>:
{
    80004f3a:	7179                	addi	sp,sp,-48
    80004f3c:	f406                	sd	ra,40(sp)
    80004f3e:	f022                	sd	s0,32(sp)
    80004f40:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004f42:	fd840613          	addi	a2,s0,-40
    80004f46:	4581                	li	a1,0
    80004f48:	4501                	li	a0,0
    80004f4a:	df3ff0ef          	jal	80004d3c <argfd>
    return -1;
    80004f4e:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80004f50:	02054363          	bltz	a0,80004f76 <sys_dup+0x3c>
    80004f54:	ec26                	sd	s1,24(sp)
    80004f56:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80004f58:	fd843483          	ld	s1,-40(s0)
    80004f5c:	8526                	mv	a0,s1
    80004f5e:	e39ff0ef          	jal	80004d96 <fdalloc>
    80004f62:	892a                	mv	s2,a0
    return -1;
    80004f64:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80004f66:	00054d63          	bltz	a0,80004f80 <sys_dup+0x46>
  filedup(f);
    80004f6a:	8526                	mv	a0,s1
    80004f6c:	b96ff0ef          	jal	80004302 <filedup>
  return fd;
    80004f70:	87ca                	mv	a5,s2
    80004f72:	64e2                	ld	s1,24(sp)
    80004f74:	6942                	ld	s2,16(sp)
}
    80004f76:	853e                	mv	a0,a5
    80004f78:	70a2                	ld	ra,40(sp)
    80004f7a:	7402                	ld	s0,32(sp)
    80004f7c:	6145                	addi	sp,sp,48
    80004f7e:	8082                	ret
    80004f80:	64e2                	ld	s1,24(sp)
    80004f82:	6942                	ld	s2,16(sp)
    80004f84:	bfcd                	j	80004f76 <sys_dup+0x3c>

0000000080004f86 <sys_read>:
{
    80004f86:	7179                	addi	sp,sp,-48
    80004f88:	f406                	sd	ra,40(sp)
    80004f8a:	f022                	sd	s0,32(sp)
    80004f8c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004f8e:	fd840593          	addi	a1,s0,-40
    80004f92:	4505                	li	a0,1
    80004f94:	9b3fd0ef          	jal	80002946 <argaddr>
  argint(2, &n);
    80004f98:	fe440593          	addi	a1,s0,-28
    80004f9c:	4509                	li	a0,2
    80004f9e:	98dfd0ef          	jal	8000292a <argint>
  if (argfd(0, 0, &f) < 0)
    80004fa2:	fe840613          	addi	a2,s0,-24
    80004fa6:	4581                	li	a1,0
    80004fa8:	4501                	li	a0,0
    80004faa:	d93ff0ef          	jal	80004d3c <argfd>
    80004fae:	87aa                	mv	a5,a0
    return -1;
    80004fb0:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004fb2:	0007ca63          	bltz	a5,80004fc6 <sys_read+0x40>
  return fileread(f, p, n);
    80004fb6:	fe442603          	lw	a2,-28(s0)
    80004fba:	fd843583          	ld	a1,-40(s0)
    80004fbe:	fe843503          	ld	a0,-24(s0)
    80004fc2:	caeff0ef          	jal	80004470 <fileread>
}
    80004fc6:	70a2                	ld	ra,40(sp)
    80004fc8:	7402                	ld	s0,32(sp)
    80004fca:	6145                	addi	sp,sp,48
    80004fcc:	8082                	ret

0000000080004fce <sys_write>:
{
    80004fce:	7179                	addi	sp,sp,-48
    80004fd0:	f406                	sd	ra,40(sp)
    80004fd2:	f022                	sd	s0,32(sp)
    80004fd4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004fd6:	fd840593          	addi	a1,s0,-40
    80004fda:	4505                	li	a0,1
    80004fdc:	96bfd0ef          	jal	80002946 <argaddr>
  argint(2, &n);
    80004fe0:	fe440593          	addi	a1,s0,-28
    80004fe4:	4509                	li	a0,2
    80004fe6:	945fd0ef          	jal	8000292a <argint>
  if (argfd(0, 0, &f) < 0)
    80004fea:	fe840613          	addi	a2,s0,-24
    80004fee:	4581                	li	a1,0
    80004ff0:	4501                	li	a0,0
    80004ff2:	d4bff0ef          	jal	80004d3c <argfd>
    80004ff6:	87aa                	mv	a5,a0
    return -1;
    80004ff8:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004ffa:	0007ca63          	bltz	a5,8000500e <sys_write+0x40>
  return filewrite(f, p, n);
    80004ffe:	fe442603          	lw	a2,-28(s0)
    80005002:	fd843583          	ld	a1,-40(s0)
    80005006:	fe843503          	ld	a0,-24(s0)
    8000500a:	d34ff0ef          	jal	8000453e <filewrite>
}
    8000500e:	70a2                	ld	ra,40(sp)
    80005010:	7402                	ld	s0,32(sp)
    80005012:	6145                	addi	sp,sp,48
    80005014:	8082                	ret

0000000080005016 <sys_close>:
{
    80005016:	1101                	addi	sp,sp,-32
    80005018:	ec06                	sd	ra,24(sp)
    8000501a:	e822                	sd	s0,16(sp)
    8000501c:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    8000501e:	fe040613          	addi	a2,s0,-32
    80005022:	fec40593          	addi	a1,s0,-20
    80005026:	4501                	li	a0,0
    80005028:	d15ff0ef          	jal	80004d3c <argfd>
    return -1;
    8000502c:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    8000502e:	02054163          	bltz	a0,80005050 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80005032:	8f7fc0ef          	jal	80001928 <myproc>
    80005036:	fec42783          	lw	a5,-20(s0)
    8000503a:	078e                	slli	a5,a5,0x3
    8000503c:	0d078793          	addi	a5,a5,208
    80005040:	953e                	add	a0,a0,a5
    80005042:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80005046:	fe043503          	ld	a0,-32(s0)
    8000504a:	afeff0ef          	jal	80004348 <fileclose>
  return 0;
    8000504e:	4781                	li	a5,0
}
    80005050:	853e                	mv	a0,a5
    80005052:	60e2                	ld	ra,24(sp)
    80005054:	6442                	ld	s0,16(sp)
    80005056:	6105                	addi	sp,sp,32
    80005058:	8082                	ret

000000008000505a <sys_fstat>:
{
    8000505a:	1101                	addi	sp,sp,-32
    8000505c:	ec06                	sd	ra,24(sp)
    8000505e:	e822                	sd	s0,16(sp)
    80005060:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005062:	fe040593          	addi	a1,s0,-32
    80005066:	4505                	li	a0,1
    80005068:	8dffd0ef          	jal	80002946 <argaddr>
  if (argfd(0, 0, &f) < 0)
    8000506c:	fe840613          	addi	a2,s0,-24
    80005070:	4581                	li	a1,0
    80005072:	4501                	li	a0,0
    80005074:	cc9ff0ef          	jal	80004d3c <argfd>
    80005078:	87aa                	mv	a5,a0
    return -1;
    8000507a:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    8000507c:	0007c863          	bltz	a5,8000508c <sys_fstat+0x32>
  return filestat(f, st);
    80005080:	fe043583          	ld	a1,-32(s0)
    80005084:	fe843503          	ld	a0,-24(s0)
    80005088:	b82ff0ef          	jal	8000440a <filestat>
}
    8000508c:	60e2                	ld	ra,24(sp)
    8000508e:	6442                	ld	s0,16(sp)
    80005090:	6105                	addi	sp,sp,32
    80005092:	8082                	ret

0000000080005094 <sys_link>:
{
    80005094:	7169                	addi	sp,sp,-304
    80005096:	f606                	sd	ra,296(sp)
    80005098:	f222                	sd	s0,288(sp)
    8000509a:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000509c:	08000613          	li	a2,128
    800050a0:	ed040593          	addi	a1,s0,-304
    800050a4:	4501                	li	a0,0
    800050a6:	8bdfd0ef          	jal	80002962 <argstr>
    return -1;
    800050aa:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800050ac:	10054163          	bltz	a0,800051ae <sys_link+0x11a>
    800050b0:	08000613          	li	a2,128
    800050b4:	f5040593          	addi	a1,s0,-176
    800050b8:	4505                	li	a0,1
    800050ba:	8a9fd0ef          	jal	80002962 <argstr>
    return -1;
    800050be:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800050c0:	0e054763          	bltz	a0,800051ae <sys_link+0x11a>
    800050c4:	ee26                	sd	s1,280(sp)
  begin_op();
    800050c6:	dc9fe0ef          	jal	80003e8e <begin_op>
  if ((ip = namei(old)) == 0) {
    800050ca:	ed040513          	addi	a0,s0,-304
    800050ce:	be3fe0ef          	jal	80003cb0 <namei>
    800050d2:	84aa                	mv	s1,a0
    800050d4:	cd35                	beqz	a0,80005150 <sys_link+0xbc>
  ilock(ip);
    800050d6:	b4efe0ef          	jal	80003424 <ilock>
  if (ip->type == T_DIR) {
    800050da:	04449703          	lh	a4,68(s1)
    800050de:	4785                	li	a5,1
    800050e0:	06f70d63          	beq	a4,a5,8000515a <sys_link+0xc6>
  if (ip->nlink >= NLINK_MAX) {
    800050e4:	04a49783          	lh	a5,74(s1)
    800050e8:	6721                	lui	a4,0x8
    800050ea:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    800050ec:	06e78f63          	beq	a5,a4,8000516a <sys_link+0xd6>
    800050f0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800050f2:	2785                	addiw	a5,a5,1
    800050f4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800050f8:	8526                	mv	a0,s1
    800050fa:	a76fe0ef          	jal	80003370 <iupdate>
  iunlock(ip);
    800050fe:	8526                	mv	a0,s1
    80005100:	bd2fe0ef          	jal	800034d2 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80005104:	fd040593          	addi	a1,s0,-48
    80005108:	f5040513          	addi	a0,s0,-176
    8000510c:	bbffe0ef          	jal	80003cca <nameiparent>
    80005110:	892a                	mv	s2,a0
    80005112:	c93d                	beqz	a0,80005188 <sys_link+0xf4>
  ilock(dp);
    80005114:	b10fe0ef          	jal	80003424 <ilock>
  if (dp->nlink == 0) {
    80005118:	04a91783          	lh	a5,74(s2)
    8000511c:	cfb9                	beqz	a5,8000517a <sys_link+0xe6>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    8000511e:	854a                	mv	a0,s2
    80005120:	00092703          	lw	a4,0(s2)
    80005124:	409c                	lw	a5,0(s1)
    80005126:	04f71e63          	bne	a4,a5,80005182 <sys_link+0xee>
    8000512a:	40d0                	lw	a2,4(s1)
    8000512c:	fd040593          	addi	a1,s0,-48
    80005130:	ad7fe0ef          	jal	80003c06 <dirlink>
    80005134:	04054763          	bltz	a0,80005182 <sys_link+0xee>
  iunlockput(dp);
    80005138:	854a                	mv	a0,s2
    8000513a:	d3efe0ef          	jal	80003678 <iunlockput>
  iput(ip);
    8000513e:	8526                	mv	a0,s1
    80005140:	c66fe0ef          	jal	800035a6 <iput>
  end_op();
    80005144:	dd7fe0ef          	jal	80003f1a <end_op>
  return 0;
    80005148:	4781                	li	a5,0
    8000514a:	64f2                	ld	s1,280(sp)
    8000514c:	6952                	ld	s2,272(sp)
    8000514e:	a085                	j	800051ae <sys_link+0x11a>
    end_op();
    80005150:	dcbfe0ef          	jal	80003f1a <end_op>
    return -1;
    80005154:	57fd                	li	a5,-1
    80005156:	64f2                	ld	s1,280(sp)
    80005158:	a899                	j	800051ae <sys_link+0x11a>
    iunlockput(ip);
    8000515a:	8526                	mv	a0,s1
    8000515c:	d1cfe0ef          	jal	80003678 <iunlockput>
    end_op();
    80005160:	dbbfe0ef          	jal	80003f1a <end_op>
    return -1;
    80005164:	57fd                	li	a5,-1
    80005166:	64f2                	ld	s1,280(sp)
    80005168:	a099                	j	800051ae <sys_link+0x11a>
    iunlockput(ip);
    8000516a:	8526                	mv	a0,s1
    8000516c:	d0cfe0ef          	jal	80003678 <iunlockput>
    end_op();
    80005170:	dabfe0ef          	jal	80003f1a <end_op>
    return -1;
    80005174:	57fd                	li	a5,-1
    80005176:	64f2                	ld	s1,280(sp)
    80005178:	a81d                	j	800051ae <sys_link+0x11a>
    iunlockput(dp);
    8000517a:	854a                	mv	a0,s2
    8000517c:	cfcfe0ef          	jal	80003678 <iunlockput>
    goto bad;
    80005180:	a021                	j	80005188 <sys_link+0xf4>
    iunlockput(dp);
    80005182:	854a                	mv	a0,s2
    80005184:	cf4fe0ef          	jal	80003678 <iunlockput>
  ilock(ip);
    80005188:	8526                	mv	a0,s1
    8000518a:	a9afe0ef          	jal	80003424 <ilock>
  ip->nlink--;
    8000518e:	04a4d783          	lhu	a5,74(s1)
    80005192:	37fd                	addiw	a5,a5,-1
    80005194:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005198:	8526                	mv	a0,s1
    8000519a:	9d6fe0ef          	jal	80003370 <iupdate>
  iunlockput(ip);
    8000519e:	8526                	mv	a0,s1
    800051a0:	cd8fe0ef          	jal	80003678 <iunlockput>
  end_op();
    800051a4:	d77fe0ef          	jal	80003f1a <end_op>
  return -1;
    800051a8:	57fd                	li	a5,-1
    800051aa:	64f2                	ld	s1,280(sp)
    800051ac:	6952                	ld	s2,272(sp)
}
    800051ae:	853e                	mv	a0,a5
    800051b0:	70b2                	ld	ra,296(sp)
    800051b2:	7412                	ld	s0,288(sp)
    800051b4:	6155                	addi	sp,sp,304
    800051b6:	8082                	ret

00000000800051b8 <sys_unlink>:
{
    800051b8:	7151                	addi	sp,sp,-240
    800051ba:	f586                	sd	ra,232(sp)
    800051bc:	f1a2                	sd	s0,224(sp)
    800051be:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    800051c0:	08000613          	li	a2,128
    800051c4:	f3040593          	addi	a1,s0,-208
    800051c8:	4501                	li	a0,0
    800051ca:	f98fd0ef          	jal	80002962 <argstr>
    800051ce:	14054d63          	bltz	a0,80005328 <sys_unlink+0x170>
    800051d2:	eda6                	sd	s1,216(sp)
  begin_op();
    800051d4:	cbbfe0ef          	jal	80003e8e <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    800051d8:	fb040593          	addi	a1,s0,-80
    800051dc:	f3040513          	addi	a0,s0,-208
    800051e0:	aebfe0ef          	jal	80003cca <nameiparent>
    800051e4:	84aa                	mv	s1,a0
    800051e6:	c955                	beqz	a0,8000529a <sys_unlink+0xe2>
  ilock(dp);
    800051e8:	a3cfe0ef          	jal	80003424 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800051ec:	00003597          	auipc	a1,0x3
    800051f0:	40458593          	addi	a1,a1,1028 # 800085f0 <etext+0x5f0>
    800051f4:	fb040513          	addi	a0,s0,-80
    800051f8:	ffefe0ef          	jal	800039f6 <namecmp>
    800051fc:	10050b63          	beqz	a0,80005312 <sys_unlink+0x15a>
    80005200:	00003597          	auipc	a1,0x3
    80005204:	3f858593          	addi	a1,a1,1016 # 800085f8 <etext+0x5f8>
    80005208:	fb040513          	addi	a0,s0,-80
    8000520c:	feafe0ef          	jal	800039f6 <namecmp>
    80005210:	10050163          	beqz	a0,80005312 <sys_unlink+0x15a>
    80005214:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80005216:	f2c40613          	addi	a2,s0,-212
    8000521a:	fb040593          	addi	a1,s0,-80
    8000521e:	8526                	mv	a0,s1
    80005220:	fecfe0ef          	jal	80003a0c <dirlookup>
    80005224:	892a                	mv	s2,a0
    80005226:	0e050563          	beqz	a0,80005310 <sys_unlink+0x158>
    8000522a:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    8000522c:	9f8fe0ef          	jal	80003424 <ilock>
  if (ip->nlink < 1)
    80005230:	04a91783          	lh	a5,74(s2)
    80005234:	06f05863          	blez	a5,800052a4 <sys_unlink+0xec>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80005238:	04491703          	lh	a4,68(s2)
    8000523c:	4785                	li	a5,1
    8000523e:	06f70963          	beq	a4,a5,800052b0 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    80005242:	fc040993          	addi	s3,s0,-64
    80005246:	4641                	li	a2,16
    80005248:	4581                	li	a1,0
    8000524a:	854e                	mv	a0,s3
    8000524c:	a5dfb0ef          	jal	80000ca8 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005250:	4741                	li	a4,16
    80005252:	f2c42683          	lw	a3,-212(s0)
    80005256:	864e                	mv	a2,s3
    80005258:	4581                	li	a1,0
    8000525a:	8526                	mv	a0,s1
    8000525c:	e94fe0ef          	jal	800038f0 <writei>
    80005260:	47c1                	li	a5,16
    80005262:	08f51863          	bne	a0,a5,800052f2 <sys_unlink+0x13a>
  if (ip->type == T_DIR) {
    80005266:	04491703          	lh	a4,68(s2)
    8000526a:	4785                	li	a5,1
    8000526c:	08f70963          	beq	a4,a5,800052fe <sys_unlink+0x146>
  iunlockput(dp);
    80005270:	8526                	mv	a0,s1
    80005272:	c06fe0ef          	jal	80003678 <iunlockput>
  ip->nlink--;
    80005276:	04a95783          	lhu	a5,74(s2)
    8000527a:	37fd                	addiw	a5,a5,-1
    8000527c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005280:	854a                	mv	a0,s2
    80005282:	8eefe0ef          	jal	80003370 <iupdate>
  iunlockput(ip);
    80005286:	854a                	mv	a0,s2
    80005288:	bf0fe0ef          	jal	80003678 <iunlockput>
  end_op();
    8000528c:	c8ffe0ef          	jal	80003f1a <end_op>
  return 0;
    80005290:	4501                	li	a0,0
    80005292:	64ee                	ld	s1,216(sp)
    80005294:	694e                	ld	s2,208(sp)
    80005296:	69ae                	ld	s3,200(sp)
    80005298:	a061                	j	80005320 <sys_unlink+0x168>
    end_op();
    8000529a:	c81fe0ef          	jal	80003f1a <end_op>
    return -1;
    8000529e:	557d                	li	a0,-1
    800052a0:	64ee                	ld	s1,216(sp)
    800052a2:	a8bd                	j	80005320 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800052a4:	00003517          	auipc	a0,0x3
    800052a8:	35c50513          	addi	a0,a0,860 # 80008600 <etext+0x600>
    800052ac:	d88fb0ef          	jal	80000834 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800052b0:	04c92703          	lw	a4,76(s2)
    800052b4:	02000793          	li	a5,32
    800052b8:	f8e7f5e3          	bgeu	a5,a4,80005242 <sys_unlink+0x8a>
    800052bc:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800052be:	4741                	li	a4,16
    800052c0:	86ce                	mv	a3,s3
    800052c2:	f1840613          	addi	a2,s0,-232
    800052c6:	4581                	li	a1,0
    800052c8:	854a                	mv	a0,s2
    800052ca:	d34fe0ef          	jal	800037fe <readi>
    800052ce:	47c1                	li	a5,16
    800052d0:	00f51b63          	bne	a0,a5,800052e6 <sys_unlink+0x12e>
    if (de.inum != 0)
    800052d4:	f1845783          	lhu	a5,-232(s0)
    800052d8:	ebb1                	bnez	a5,8000532c <sys_unlink+0x174>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800052da:	29c1                	addiw	s3,s3,16
    800052dc:	04c92783          	lw	a5,76(s2)
    800052e0:	fcf9efe3          	bltu	s3,a5,800052be <sys_unlink+0x106>
    800052e4:	bfb9                	j	80005242 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800052e6:	00003517          	auipc	a0,0x3
    800052ea:	33250513          	addi	a0,a0,818 # 80008618 <etext+0x618>
    800052ee:	d46fb0ef          	jal	80000834 <panic>
    panic("unlink: writei");
    800052f2:	00003517          	auipc	a0,0x3
    800052f6:	33e50513          	addi	a0,a0,830 # 80008630 <etext+0x630>
    800052fa:	d3afb0ef          	jal	80000834 <panic>
    dp->nlink--;
    800052fe:	04a4d783          	lhu	a5,74(s1)
    80005302:	37fd                	addiw	a5,a5,-1
    80005304:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005308:	8526                	mv	a0,s1
    8000530a:	866fe0ef          	jal	80003370 <iupdate>
    8000530e:	b78d                	j	80005270 <sys_unlink+0xb8>
    80005310:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005312:	8526                	mv	a0,s1
    80005314:	b64fe0ef          	jal	80003678 <iunlockput>
  end_op();
    80005318:	c03fe0ef          	jal	80003f1a <end_op>
  return -1;
    8000531c:	557d                	li	a0,-1
    8000531e:	64ee                	ld	s1,216(sp)
}
    80005320:	70ae                	ld	ra,232(sp)
    80005322:	740e                	ld	s0,224(sp)
    80005324:	616d                	addi	sp,sp,240
    80005326:	8082                	ret
    return -1;
    80005328:	557d                	li	a0,-1
    8000532a:	bfdd                	j	80005320 <sys_unlink+0x168>
    iunlockput(ip);
    8000532c:	854a                	mv	a0,s2
    8000532e:	b4afe0ef          	jal	80003678 <iunlockput>
    goto bad;
    80005332:	694e                	ld	s2,208(sp)
    80005334:	69ae                	ld	s3,200(sp)
    80005336:	bff1                	j	80005312 <sys_unlink+0x15a>

0000000080005338 <sys_open>:

uint64
sys_open(void)
{
    80005338:	7131                	addi	sp,sp,-192
    8000533a:	fd06                	sd	ra,184(sp)
    8000533c:	f922                	sd	s0,176(sp)
    8000533e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005340:	f4c40593          	addi	a1,s0,-180
    80005344:	4505                	li	a0,1
    80005346:	de4fd0ef          	jal	8000292a <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    8000534a:	08000613          	li	a2,128
    8000534e:	f5040593          	addi	a1,s0,-176
    80005352:	4501                	li	a0,0
    80005354:	e0efd0ef          	jal	80002962 <argstr>
    80005358:	87aa                	mv	a5,a0
    return -1;
    8000535a:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    8000535c:	0a07c363          	bltz	a5,80005402 <sys_open+0xca>
    80005360:	f526                	sd	s1,168(sp)

  begin_op();
    80005362:	b2dfe0ef          	jal	80003e8e <begin_op>

  if (omode & O_CREATE) {
    80005366:	f4c42783          	lw	a5,-180(s0)
    8000536a:	2007f793          	andi	a5,a5,512
    8000536e:	c3dd                	beqz	a5,80005414 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80005370:	4681                	li	a3,0
    80005372:	4601                	li	a2,0
    80005374:	4589                	li	a1,2
    80005376:	f5040513          	addi	a0,s0,-176
    8000537a:	a5dff0ef          	jal	80004dd6 <create>
    8000537e:	84aa                	mv	s1,a0
    if (ip == 0) {
    80005380:	c549                	beqz	a0,8000540a <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80005382:	04449703          	lh	a4,68(s1)
    80005386:	478d                	li	a5,3
    80005388:	00f71763          	bne	a4,a5,80005396 <sys_open+0x5e>
    8000538c:	0464d703          	lhu	a4,70(s1)
    80005390:	47a5                	li	a5,9
    80005392:	0ae7ee63          	bltu	a5,a4,8000544e <sys_open+0x116>
    80005396:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80005398:	f0dfe0ef          	jal	800042a4 <filealloc>
    8000539c:	892a                	mv	s2,a0
    8000539e:	c561                	beqz	a0,80005466 <sys_open+0x12e>
    800053a0:	ed4e                	sd	s3,152(sp)
    800053a2:	9f5ff0ef          	jal	80004d96 <fdalloc>
    800053a6:	89aa                	mv	s3,a0
    800053a8:	0a054b63          	bltz	a0,8000545e <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    800053ac:	04449703          	lh	a4,68(s1)
    800053b0:	478d                	li	a5,3
    800053b2:	0cf70363          	beq	a4,a5,80005478 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800053b6:	4789                	li	a5,2
    800053b8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800053bc:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800053c0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800053c4:	f4c42783          	lw	a5,-180(s0)
    800053c8:	0017f713          	andi	a4,a5,1
    800053cc:	00174713          	xori	a4,a4,1
    800053d0:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800053d4:	0037f713          	andi	a4,a5,3
    800053d8:	00e03733          	snez	a4,a4
    800053dc:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    800053e0:	4007f793          	andi	a5,a5,1024
    800053e4:	c791                	beqz	a5,800053f0 <sys_open+0xb8>
    800053e6:	04449703          	lh	a4,68(s1)
    800053ea:	4789                	li	a5,2
    800053ec:	08f70d63          	beq	a4,a5,80005486 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800053f0:	8526                	mv	a0,s1
    800053f2:	8e0fe0ef          	jal	800034d2 <iunlock>
  end_op();
    800053f6:	b25fe0ef          	jal	80003f1a <end_op>

  return fd;
    800053fa:	854e                	mv	a0,s3
    800053fc:	74aa                	ld	s1,168(sp)
    800053fe:	790a                	ld	s2,160(sp)
    80005400:	69ea                	ld	s3,152(sp)
}
    80005402:	70ea                	ld	ra,184(sp)
    80005404:	744a                	ld	s0,176(sp)
    80005406:	6129                	addi	sp,sp,192
    80005408:	8082                	ret
      end_op();
    8000540a:	b11fe0ef          	jal	80003f1a <end_op>
      return -1;
    8000540e:	557d                	li	a0,-1
    80005410:	74aa                	ld	s1,168(sp)
    80005412:	bfc5                	j	80005402 <sys_open+0xca>
    if ((ip = namei(path)) == 0) {
    80005414:	f5040513          	addi	a0,s0,-176
    80005418:	899fe0ef          	jal	80003cb0 <namei>
    8000541c:	84aa                	mv	s1,a0
    8000541e:	c11d                	beqz	a0,80005444 <sys_open+0x10c>
    ilock(ip);
    80005420:	804fe0ef          	jal	80003424 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80005424:	04449703          	lh	a4,68(s1)
    80005428:	4785                	li	a5,1
    8000542a:	f4f71ce3          	bne	a4,a5,80005382 <sys_open+0x4a>
    8000542e:	f4c42783          	lw	a5,-180(s0)
    80005432:	d3b5                	beqz	a5,80005396 <sys_open+0x5e>
      iunlockput(ip);
    80005434:	8526                	mv	a0,s1
    80005436:	a42fe0ef          	jal	80003678 <iunlockput>
      end_op();
    8000543a:	ae1fe0ef          	jal	80003f1a <end_op>
      return -1;
    8000543e:	557d                	li	a0,-1
    80005440:	74aa                	ld	s1,168(sp)
    80005442:	b7c1                	j	80005402 <sys_open+0xca>
      end_op();
    80005444:	ad7fe0ef          	jal	80003f1a <end_op>
      return -1;
    80005448:	557d                	li	a0,-1
    8000544a:	74aa                	ld	s1,168(sp)
    8000544c:	bf5d                	j	80005402 <sys_open+0xca>
    iunlockput(ip);
    8000544e:	8526                	mv	a0,s1
    80005450:	a28fe0ef          	jal	80003678 <iunlockput>
    end_op();
    80005454:	ac7fe0ef          	jal	80003f1a <end_op>
    return -1;
    80005458:	557d                	li	a0,-1
    8000545a:	74aa                	ld	s1,168(sp)
    8000545c:	b75d                	j	80005402 <sys_open+0xca>
      fileclose(f);
    8000545e:	854a                	mv	a0,s2
    80005460:	ee9fe0ef          	jal	80004348 <fileclose>
    80005464:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005466:	8526                	mv	a0,s1
    80005468:	a10fe0ef          	jal	80003678 <iunlockput>
    end_op();
    8000546c:	aaffe0ef          	jal	80003f1a <end_op>
    return -1;
    80005470:	557d                	li	a0,-1
    80005472:	74aa                	ld	s1,168(sp)
    80005474:	790a                	ld	s2,160(sp)
    80005476:	b771                	j	80005402 <sys_open+0xca>
    f->type = FD_DEVICE;
    80005478:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    8000547c:	04649783          	lh	a5,70(s1)
    80005480:	02f91223          	sh	a5,36(s2)
    80005484:	bf35                	j	800053c0 <sys_open+0x88>
    itrunc(ip);
    80005486:	8526                	mv	a0,s1
    80005488:	88afe0ef          	jal	80003512 <itrunc>
    8000548c:	b795                	j	800053f0 <sys_open+0xb8>

000000008000548e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000548e:	7175                	addi	sp,sp,-144
    80005490:	e506                	sd	ra,136(sp)
    80005492:	e122                	sd	s0,128(sp)
    80005494:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005496:	9f9fe0ef          	jal	80003e8e <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    8000549a:	08000613          	li	a2,128
    8000549e:	f7040593          	addi	a1,s0,-144
    800054a2:	4501                	li	a0,0
    800054a4:	cbefd0ef          	jal	80002962 <argstr>
    800054a8:	02054363          	bltz	a0,800054ce <sys_mkdir+0x40>
    800054ac:	4681                	li	a3,0
    800054ae:	4601                	li	a2,0
    800054b0:	4585                	li	a1,1
    800054b2:	f7040513          	addi	a0,s0,-144
    800054b6:	921ff0ef          	jal	80004dd6 <create>
    800054ba:	c911                	beqz	a0,800054ce <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800054bc:	9bcfe0ef          	jal	80003678 <iunlockput>
  end_op();
    800054c0:	a5bfe0ef          	jal	80003f1a <end_op>
  return 0;
    800054c4:	4501                	li	a0,0
}
    800054c6:	60aa                	ld	ra,136(sp)
    800054c8:	640a                	ld	s0,128(sp)
    800054ca:	6149                	addi	sp,sp,144
    800054cc:	8082                	ret
    end_op();
    800054ce:	a4dfe0ef          	jal	80003f1a <end_op>
    return -1;
    800054d2:	557d                	li	a0,-1
    800054d4:	bfcd                	j	800054c6 <sys_mkdir+0x38>

00000000800054d6 <sys_mknod>:

uint64
sys_mknod(void)
{
    800054d6:	7135                	addi	sp,sp,-160
    800054d8:	ed06                	sd	ra,152(sp)
    800054da:	e922                	sd	s0,144(sp)
    800054dc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800054de:	9b1fe0ef          	jal	80003e8e <begin_op>
  argint(1, &major);
    800054e2:	f6c40593          	addi	a1,s0,-148
    800054e6:	4505                	li	a0,1
    800054e8:	c42fd0ef          	jal	8000292a <argint>
  argint(2, &minor);
    800054ec:	f6840593          	addi	a1,s0,-152
    800054f0:	4509                	li	a0,2
    800054f2:	c38fd0ef          	jal	8000292a <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800054f6:	08000613          	li	a2,128
    800054fa:	f7040593          	addi	a1,s0,-144
    800054fe:	4501                	li	a0,0
    80005500:	c62fd0ef          	jal	80002962 <argstr>
    80005504:	02054563          	bltz	a0,8000552e <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80005508:	f6841683          	lh	a3,-152(s0)
    8000550c:	f6c41603          	lh	a2,-148(s0)
    80005510:	458d                	li	a1,3
    80005512:	f7040513          	addi	a0,s0,-144
    80005516:	8c1ff0ef          	jal	80004dd6 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    8000551a:	c911                	beqz	a0,8000552e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000551c:	95cfe0ef          	jal	80003678 <iunlockput>
  end_op();
    80005520:	9fbfe0ef          	jal	80003f1a <end_op>
  return 0;
    80005524:	4501                	li	a0,0
}
    80005526:	60ea                	ld	ra,152(sp)
    80005528:	644a                	ld	s0,144(sp)
    8000552a:	610d                	addi	sp,sp,160
    8000552c:	8082                	ret
    end_op();
    8000552e:	9edfe0ef          	jal	80003f1a <end_op>
    return -1;
    80005532:	557d                	li	a0,-1
    80005534:	bfcd                	j	80005526 <sys_mknod+0x50>

0000000080005536 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005536:	7135                	addi	sp,sp,-160
    80005538:	ed06                	sd	ra,152(sp)
    8000553a:	e922                	sd	s0,144(sp)
    8000553c:	e14a                	sd	s2,128(sp)
    8000553e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005540:	be8fc0ef          	jal	80001928 <myproc>
    80005544:	892a                	mv	s2,a0

  begin_op();
    80005546:	949fe0ef          	jal	80003e8e <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    8000554a:	08000613          	li	a2,128
    8000554e:	f6040593          	addi	a1,s0,-160
    80005552:	4501                	li	a0,0
    80005554:	c0efd0ef          	jal	80002962 <argstr>
    80005558:	04054363          	bltz	a0,8000559e <sys_chdir+0x68>
    8000555c:	e526                	sd	s1,136(sp)
    8000555e:	f6040513          	addi	a0,s0,-160
    80005562:	f4efe0ef          	jal	80003cb0 <namei>
    80005566:	84aa                	mv	s1,a0
    80005568:	c915                	beqz	a0,8000559c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000556a:	ebbfd0ef          	jal	80003424 <ilock>
  if (ip->type != T_DIR) {
    8000556e:	04449703          	lh	a4,68(s1)
    80005572:	4785                	li	a5,1
    80005574:	02f71963          	bne	a4,a5,800055a6 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005578:	8526                	mv	a0,s1
    8000557a:	f59fd0ef          	jal	800034d2 <iunlock>
  iput(p->cwd);
    8000557e:	15893503          	ld	a0,344(s2)
    80005582:	824fe0ef          	jal	800035a6 <iput>
  end_op();
    80005586:	995fe0ef          	jal	80003f1a <end_op>
  p->cwd = ip;
    8000558a:	14993c23          	sd	s1,344(s2)
  return 0;
    8000558e:	4501                	li	a0,0
    80005590:	64aa                	ld	s1,136(sp)
}
    80005592:	60ea                	ld	ra,152(sp)
    80005594:	644a                	ld	s0,144(sp)
    80005596:	690a                	ld	s2,128(sp)
    80005598:	610d                	addi	sp,sp,160
    8000559a:	8082                	ret
    8000559c:	64aa                	ld	s1,136(sp)
    end_op();
    8000559e:	97dfe0ef          	jal	80003f1a <end_op>
    return -1;
    800055a2:	557d                	li	a0,-1
    800055a4:	b7fd                	j	80005592 <sys_chdir+0x5c>
    iunlockput(ip);
    800055a6:	8526                	mv	a0,s1
    800055a8:	8d0fe0ef          	jal	80003678 <iunlockput>
    end_op();
    800055ac:	96ffe0ef          	jal	80003f1a <end_op>
    return -1;
    800055b0:	557d                	li	a0,-1
    800055b2:	64aa                	ld	s1,136(sp)
    800055b4:	bff9                	j	80005592 <sys_chdir+0x5c>

00000000800055b6 <sys_exec>:

uint64
sys_exec(void)
{
    800055b6:	7105                	addi	sp,sp,-480
    800055b8:	ef86                	sd	ra,472(sp)
    800055ba:	eba2                	sd	s0,464(sp)
    800055bc:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800055be:	e2840593          	addi	a1,s0,-472
    800055c2:	4505                	li	a0,1
    800055c4:	b82fd0ef          	jal	80002946 <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    800055c8:	08000613          	li	a2,128
    800055cc:	f3040593          	addi	a1,s0,-208
    800055d0:	4501                	li	a0,0
    800055d2:	b90fd0ef          	jal	80002962 <argstr>
    800055d6:	87aa                	mv	a5,a0
    return -1;
    800055d8:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    800055da:	0e07c063          	bltz	a5,800056ba <sys_exec+0x104>
    800055de:	e7a6                	sd	s1,456(sp)
    800055e0:	e3ca                	sd	s2,448(sp)
    800055e2:	ff4e                	sd	s3,440(sp)
    800055e4:	fb52                	sd	s4,432(sp)
    800055e6:	f756                	sd	s5,424(sp)
    800055e8:	f35a                	sd	s6,416(sp)
    800055ea:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800055ec:	e3040a13          	addi	s4,s0,-464
    800055f0:	10000613          	li	a2,256
    800055f4:	4581                	li	a1,0
    800055f6:	8552                	mv	a0,s4
    800055f8:	eb0fb0ef          	jal	80000ca8 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    800055fc:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800055fe:	89d2                	mv	s3,s4
    80005600:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005602:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005606:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    80005608:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    8000560c:	00391513          	slli	a0,s2,0x3
    80005610:	85d6                	mv	a1,s5
    80005612:	e2843783          	ld	a5,-472(s0)
    80005616:	953e                	add	a0,a0,a5
    80005618:	a86fd0ef          	jal	8000289e <fetchaddr>
    8000561c:	02054663          	bltz	a0,80005648 <sys_exec+0x92>
    if (uarg == 0) {
    80005620:	e2043783          	ld	a5,-480(s0)
    80005624:	c7a1                	beqz	a5,8000566c <sys_exec+0xb6>
    argv[i] = kalloc();
    80005626:	ce8fb0ef          	jal	80000b0e <kalloc>
    8000562a:	85aa                	mv	a1,a0
    8000562c:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005630:	cd01                	beqz	a0,80005648 <sys_exec+0x92>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005632:	865a                	mv	a2,s6
    80005634:	e2043503          	ld	a0,-480(s0)
    80005638:	ab0fd0ef          	jal	800028e8 <fetchstr>
    8000563c:	00054663          	bltz	a0,80005648 <sys_exec+0x92>
    if (i >= NELEM(argv)) {
    80005640:	0905                	addi	s2,s2,1
    80005642:	09a1                	addi	s3,s3,8
    80005644:	fd7914e3          	bne	s2,s7,8000560c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005648:	100a0a13          	addi	s4,s4,256
    8000564c:	6088                	ld	a0,0(s1)
    8000564e:	cd31                	beqz	a0,800056aa <sys_exec+0xf4>
    kfree(argv[i]);
    80005650:	bd6fb0ef          	jal	80000a26 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005654:	04a1                	addi	s1,s1,8
    80005656:	ff449be3          	bne	s1,s4,8000564c <sys_exec+0x96>
  return -1;
    8000565a:	557d                	li	a0,-1
    8000565c:	64be                	ld	s1,456(sp)
    8000565e:	691e                	ld	s2,448(sp)
    80005660:	79fa                	ld	s3,440(sp)
    80005662:	7a5a                	ld	s4,432(sp)
    80005664:	7aba                	ld	s5,424(sp)
    80005666:	7b1a                	ld	s6,416(sp)
    80005668:	6bfa                	ld	s7,408(sp)
    8000566a:	a881                	j	800056ba <sys_exec+0x104>
      argv[i] = 0;
    8000566c:	0009079b          	sext.w	a5,s2
    80005670:	e3040593          	addi	a1,s0,-464
    80005674:	078e                	slli	a5,a5,0x3
    80005676:	97ae                	add	a5,a5,a1
    80005678:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    8000567c:	f3040513          	addi	a0,s0,-208
    80005680:	b62ff0ef          	jal	800049e2 <kexec>
    80005684:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005686:	100a0a13          	addi	s4,s4,256
    8000568a:	6088                	ld	a0,0(s1)
    8000568c:	c511                	beqz	a0,80005698 <sys_exec+0xe2>
    kfree(argv[i]);
    8000568e:	b98fb0ef          	jal	80000a26 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005692:	04a1                	addi	s1,s1,8
    80005694:	ff449be3          	bne	s1,s4,8000568a <sys_exec+0xd4>
  return ret;
    80005698:	854a                	mv	a0,s2
    8000569a:	64be                	ld	s1,456(sp)
    8000569c:	691e                	ld	s2,448(sp)
    8000569e:	79fa                	ld	s3,440(sp)
    800056a0:	7a5a                	ld	s4,432(sp)
    800056a2:	7aba                	ld	s5,424(sp)
    800056a4:	7b1a                	ld	s6,416(sp)
    800056a6:	6bfa                	ld	s7,408(sp)
    800056a8:	a809                	j	800056ba <sys_exec+0x104>
  return -1;
    800056aa:	557d                	li	a0,-1
    800056ac:	64be                	ld	s1,456(sp)
    800056ae:	691e                	ld	s2,448(sp)
    800056b0:	79fa                	ld	s3,440(sp)
    800056b2:	7a5a                	ld	s4,432(sp)
    800056b4:	7aba                	ld	s5,424(sp)
    800056b6:	7b1a                	ld	s6,416(sp)
    800056b8:	6bfa                	ld	s7,408(sp)
}
    800056ba:	60fe                	ld	ra,472(sp)
    800056bc:	645e                	ld	s0,464(sp)
    800056be:	613d                	addi	sp,sp,480
    800056c0:	8082                	ret

00000000800056c2 <sys_pipe>:

uint64
sys_pipe(void)
{
    800056c2:	7139                	addi	sp,sp,-64
    800056c4:	fc06                	sd	ra,56(sp)
    800056c6:	f822                	sd	s0,48(sp)
    800056c8:	f426                	sd	s1,40(sp)
    800056ca:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800056cc:	a5cfc0ef          	jal	80001928 <myproc>
    800056d0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800056d2:	fd840593          	addi	a1,s0,-40
    800056d6:	4501                	li	a0,0
    800056d8:	a6efd0ef          	jal	80002946 <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    800056dc:	fc840593          	addi	a1,s0,-56
    800056e0:	fd040513          	addi	a0,s0,-48
    800056e4:	f99fe0ef          	jal	8000467c <pipealloc>
    return -1;
    800056e8:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    800056ea:	0a054963          	bltz	a0,8000579c <sys_pipe+0xda>
  fd0 = -1;
    800056ee:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    800056f2:	fd043503          	ld	a0,-48(s0)
    800056f6:	ea0ff0ef          	jal	80004d96 <fdalloc>
    800056fa:	fca42223          	sw	a0,-60(s0)
    800056fe:	08054663          	bltz	a0,8000578a <sys_pipe+0xc8>
    80005702:	fc843503          	ld	a0,-56(s0)
    80005706:	e90ff0ef          	jal	80004d96 <fdalloc>
    8000570a:	fca42023          	sw	a0,-64(s0)
    8000570e:	06054463          	bltz	a0,80005776 <sys_pipe+0xb4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005712:	4711                	li	a4,4
    80005714:	fc440693          	addi	a3,s0,-60
    80005718:	fd843603          	ld	a2,-40(s0)
    8000571c:	64ac                	ld	a1,72(s1)
    8000571e:	6ca8                	ld	a0,88(s1)
    80005720:	e27fb0ef          	jal	80001546 <copyout>
    80005724:	00054f63          	bltz	a0,80005742 <sys_pipe+0x80>
      copyout(p->pagetable, p->sz, fdarray + sizeof(fd0), (char *)&fd1,
    80005728:	4711                	li	a4,4
    8000572a:	fc040693          	addi	a3,s0,-64
    8000572e:	fd843603          	ld	a2,-40(s0)
    80005732:	963a                	add	a2,a2,a4
    80005734:	64ac                	ld	a1,72(s1)
    80005736:	6ca8                	ld	a0,88(s1)
    80005738:	e0ffb0ef          	jal	80001546 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000573c:	4781                	li	a5,0
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000573e:	04055f63          	bgez	a0,8000579c <sys_pipe+0xda>
    p->ofile[fd0] = 0;
    80005742:	fc442783          	lw	a5,-60(s0)
    80005746:	078e                	slli	a5,a5,0x3
    80005748:	0d078793          	addi	a5,a5,208
    8000574c:	97a6                	add	a5,a5,s1
    8000574e:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005752:	fc042783          	lw	a5,-64(s0)
    80005756:	078e                	slli	a5,a5,0x3
    80005758:	0d078793          	addi	a5,a5,208
    8000575c:	94be                	add	s1,s1,a5
    8000575e:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005762:	fd043503          	ld	a0,-48(s0)
    80005766:	be3fe0ef          	jal	80004348 <fileclose>
    fileclose(wf);
    8000576a:	fc843503          	ld	a0,-56(s0)
    8000576e:	bdbfe0ef          	jal	80004348 <fileclose>
    return -1;
    80005772:	57fd                	li	a5,-1
    80005774:	a025                	j	8000579c <sys_pipe+0xda>
    if (fd0 >= 0)
    80005776:	fc442783          	lw	a5,-60(s0)
    8000577a:	0007c863          	bltz	a5,8000578a <sys_pipe+0xc8>
      p->ofile[fd0] = 0;
    8000577e:	078e                	slli	a5,a5,0x3
    80005780:	0d078793          	addi	a5,a5,208
    80005784:	97a6                	add	a5,a5,s1
    80005786:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000578a:	fd043503          	ld	a0,-48(s0)
    8000578e:	bbbfe0ef          	jal	80004348 <fileclose>
    fileclose(wf);
    80005792:	fc843503          	ld	a0,-56(s0)
    80005796:	bb3fe0ef          	jal	80004348 <fileclose>
    return -1;
    8000579a:	57fd                	li	a5,-1
}
    8000579c:	853e                	mv	a0,a5
    8000579e:	70e2                	ld	ra,56(sp)
    800057a0:	7442                	ld	s0,48(sp)
    800057a2:	74a2                	ld	s1,40(sp)
    800057a4:	6121                	addi	sp,sp,64
    800057a6:	8082                	ret
	...

00000000800057b0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800057b0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800057b2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800057b4:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    800057b6:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800057b8:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800057ba:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800057bc:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800057be:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800057c0:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800057c2:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800057c4:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800057c6:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800057c8:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800057ca:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800057cc:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800057ce:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800057d0:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800057d2:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800057d4:	fd9fc0ef          	jal	800027ac <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800057d8:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800057da:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800057dc:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800057de:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800057e0:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800057e2:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800057e4:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800057e6:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800057e8:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800057ea:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800057ec:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800057ee:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800057f0:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800057f2:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800057f4:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800057f6:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800057f8:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800057fa:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800057fc:	10200073          	sret
    80005800:	0001                	nop
    80005802:	00000013          	nop
    80005806:	00000013          	nop
    8000580a:	00000013          	nop

000000008000580e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000580e:	1141                	addi	sp,sp,-16
    80005810:	e406                	sd	ra,8(sp)
    80005812:	e022                	sd	s0,0(sp)
    80005814:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    80005816:	0c000737          	lui	a4,0xc000
    8000581a:	4785                	li	a5,1
    8000581c:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    8000581e:	c35c                	sw	a5,4(a4)
}
    80005820:	60a2                	ld	ra,8(sp)
    80005822:	6402                	ld	s0,0(sp)
    80005824:	0141                	addi	sp,sp,16
    80005826:	8082                	ret

0000000080005828 <plicinithart>:

void
plicinithart(void)
{
    80005828:	1141                	addi	sp,sp,-16
    8000582a:	e406                	sd	ra,8(sp)
    8000582c:	e022                	sd	s0,0(sp)
    8000582e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005830:	8c4fc0ef          	jal	800018f4 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005834:	0085171b          	slliw	a4,a0,0x8
    80005838:	0c0027b7          	lui	a5,0xc002
    8000583c:	97ba                	add	a5,a5,a4
    8000583e:	40200713          	li	a4,1026
    80005842:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80005846:	00d5151b          	slliw	a0,a0,0xd
    8000584a:	0c2017b7          	lui	a5,0xc201
    8000584e:	97aa                	add	a5,a5,a0
    80005850:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005854:	60a2                	ld	ra,8(sp)
    80005856:	6402                	ld	s0,0(sp)
    80005858:	0141                	addi	sp,sp,16
    8000585a:	8082                	ret

000000008000585c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000585c:	1141                	addi	sp,sp,-16
    8000585e:	e406                	sd	ra,8(sp)
    80005860:	e022                	sd	s0,0(sp)
    80005862:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005864:	890fc0ef          	jal	800018f4 <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80005868:	00d5151b          	slliw	a0,a0,0xd
    8000586c:	0c2017b7          	lui	a5,0xc201
    80005870:	97aa                	add	a5,a5,a0
  return irq;
}
    80005872:	43c8                	lw	a0,4(a5)
    80005874:	60a2                	ld	ra,8(sp)
    80005876:	6402                	ld	s0,0(sp)
    80005878:	0141                	addi	sp,sp,16
    8000587a:	8082                	ret

000000008000587c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000587c:	1101                	addi	sp,sp,-32
    8000587e:	ec06                	sd	ra,24(sp)
    80005880:	e822                	sd	s0,16(sp)
    80005882:	e426                	sd	s1,8(sp)
    80005884:	1000                	addi	s0,sp,32
    80005886:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005888:	86cfc0ef          	jal	800018f4 <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    8000588c:	00d5179b          	slliw	a5,a0,0xd
    80005890:	0c201737          	lui	a4,0xc201
    80005894:	97ba                	add	a5,a5,a4
    80005896:	c3c4                	sw	s1,4(a5)
}
    80005898:	60e2                	ld	ra,24(sp)
    8000589a:	6442                	ld	s0,16(sp)
    8000589c:	64a2                	ld	s1,8(sp)
    8000589e:	6105                	addi	sp,sp,32
    800058a0:	8082                	ret

00000000800058a2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800058a2:	1141                	addi	sp,sp,-16
    800058a4:	e406                	sd	ra,8(sp)
    800058a6:	e022                	sd	s0,0(sp)
    800058a8:	0800                	addi	s0,sp,16
  if (i >= NUM)
    800058aa:	479d                	li	a5,7
    800058ac:	04a7ca63          	blt	a5,a0,80005900 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    800058b0:	0001f797          	auipc	a5,0x1f
    800058b4:	08878793          	addi	a5,a5,136 # 80024938 <disk>
    800058b8:	97aa                	add	a5,a5,a0
    800058ba:	0187c783          	lbu	a5,24(a5)
    800058be:	e7b9                	bnez	a5,8000590c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800058c0:	00451693          	slli	a3,a0,0x4
    800058c4:	0001f797          	auipc	a5,0x1f
    800058c8:	07478793          	addi	a5,a5,116 # 80024938 <disk>
    800058cc:	6398                	ld	a4,0(a5)
    800058ce:	9736                	add	a4,a4,a3
    800058d0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800058d4:	6398                	ld	a4,0(a5)
    800058d6:	9736                	add	a4,a4,a3
    800058d8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800058dc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800058e0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800058e4:	97aa                	add	a5,a5,a0
    800058e6:	4705                	li	a4,1
    800058e8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800058ec:	0001f517          	auipc	a0,0x1f
    800058f0:	06450513          	addi	a0,a0,100 # 80024950 <disk+0x18>
    800058f4:	f6afc0ef          	jal	8000205e <wakeup>
}
    800058f8:	60a2                	ld	ra,8(sp)
    800058fa:	6402                	ld	s0,0(sp)
    800058fc:	0141                	addi	sp,sp,16
    800058fe:	8082                	ret
    panic("free_desc 1");
    80005900:	00003517          	auipc	a0,0x3
    80005904:	d4050513          	addi	a0,a0,-704 # 80008640 <etext+0x640>
    80005908:	f2dfa0ef          	jal	80000834 <panic>
    panic("free_desc 2");
    8000590c:	00003517          	auipc	a0,0x3
    80005910:	d4450513          	addi	a0,a0,-700 # 80008650 <etext+0x650>
    80005914:	f21fa0ef          	jal	80000834 <panic>

0000000080005918 <virtio_disk_init>:
{
    80005918:	1101                	addi	sp,sp,-32
    8000591a:	ec06                	sd	ra,24(sp)
    8000591c:	e822                	sd	s0,16(sp)
    8000591e:	e426                	sd	s1,8(sp)
    80005920:	e04a                	sd	s2,0(sp)
    80005922:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005924:	00003597          	auipc	a1,0x3
    80005928:	d3c58593          	addi	a1,a1,-708 # 80008660 <etext+0x660>
    8000592c:	0001f517          	auipc	a0,0x1f
    80005930:	13450513          	addi	a0,a0,308 # 80024a60 <disk+0x128>
    80005934:	a34fb0ef          	jal	80000b68 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005938:	100017b7          	lui	a5,0x10001
    8000593c:	4398                	lw	a4,0(a5)
    8000593e:	2701                	sext.w	a4,a4
    80005940:	747277b7          	lui	a5,0x74727
    80005944:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005948:	14f71863          	bne	a4,a5,80005a98 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000594c:	100017b7          	lui	a5,0x10001
    80005950:	43dc                	lw	a5,4(a5)
    80005952:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005954:	4709                	li	a4,2
    80005956:	14e79163          	bne	a5,a4,80005a98 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000595a:	100017b7          	lui	a5,0x10001
    8000595e:	479c                	lw	a5,8(a5)
    80005960:	2781                	sext.w	a5,a5
    80005962:	12e79b63          	bne	a5,a4,80005a98 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80005966:	100017b7          	lui	a5,0x10001
    8000596a:	47d8                	lw	a4,12(a5)
    8000596c:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000596e:	554d47b7          	lui	a5,0x554d4
    80005972:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005976:	12f71163          	bne	a4,a5,80005a98 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000597a:	100017b7          	lui	a5,0x10001
    8000597e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005982:	4705                	li	a4,1
    80005984:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005986:	470d                	li	a4,3
    80005988:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000598a:	10001737          	lui	a4,0x10001
    8000598e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005990:	c7ffe6b7          	lui	a3,0xc7ffe
    80005994:	55f68693          	addi	a3,a3,1375 # ffffffffc7ffe55f <end+0xffffffff47fd98cf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005998:	8f75                	and	a4,a4,a3
    8000599a:	100016b7          	lui	a3,0x10001
    8000599e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800059a0:	472d                	li	a4,11
    800059a2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800059a4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800059a8:	439c                	lw	a5,0(a5)
    800059aa:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800059ae:	8ba1                	andi	a5,a5,8
    800059b0:	0e078a63          	beqz	a5,80005aa4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800059b4:	100017b7          	lui	a5,0x10001
    800059b8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    800059bc:	43fc                	lw	a5,68(a5)
    800059be:	2781                	sext.w	a5,a5
    800059c0:	0e079863          	bnez	a5,80005ab0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800059c4:	100017b7          	lui	a5,0x10001
    800059c8:	5bdc                	lw	a5,52(a5)
    800059ca:	2781                	sext.w	a5,a5
  if (max == 0)
    800059cc:	0e078863          	beqz	a5,80005abc <virtio_disk_init+0x1a4>
  if (max < NUM)
    800059d0:	471d                	li	a4,7
    800059d2:	0ef77b63          	bgeu	a4,a5,80005ac8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    800059d6:	938fb0ef          	jal	80000b0e <kalloc>
    800059da:	0001f497          	auipc	s1,0x1f
    800059de:	f5e48493          	addi	s1,s1,-162 # 80024938 <disk>
    800059e2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800059e4:	92afb0ef          	jal	80000b0e <kalloc>
    800059e8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800059ea:	924fb0ef          	jal	80000b0e <kalloc>
    800059ee:	87aa                	mv	a5,a0
    800059f0:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    800059f2:	6088                	ld	a0,0(s1)
    800059f4:	0e050063          	beqz	a0,80005ad4 <virtio_disk_init+0x1bc>
    800059f8:	0001f717          	auipc	a4,0x1f
    800059fc:	f4873703          	ld	a4,-184(a4) # 80024940 <disk+0x8>
    80005a00:	cb71                	beqz	a4,80005ad4 <virtio_disk_init+0x1bc>
    80005a02:	cbe9                	beqz	a5,80005ad4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005a04:	6605                	lui	a2,0x1
    80005a06:	4581                	li	a1,0
    80005a08:	aa0fb0ef          	jal	80000ca8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005a0c:	0001f497          	auipc	s1,0x1f
    80005a10:	f2c48493          	addi	s1,s1,-212 # 80024938 <disk>
    80005a14:	6605                	lui	a2,0x1
    80005a16:	4581                	li	a1,0
    80005a18:	6488                	ld	a0,8(s1)
    80005a1a:	a8efb0ef          	jal	80000ca8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005a1e:	6605                	lui	a2,0x1
    80005a20:	4581                	li	a1,0
    80005a22:	6888                	ld	a0,16(s1)
    80005a24:	a84fb0ef          	jal	80000ca8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005a28:	100017b7          	lui	a5,0x10001
    80005a2c:	4721                	li	a4,8
    80005a2e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005a30:	4098                	lw	a4,0(s1)
    80005a32:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005a36:	40d8                	lw	a4,4(s1)
    80005a38:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005a3c:	649c                	ld	a5,8(s1)
    80005a3e:	0007869b          	sext.w	a3,a5
    80005a42:	10001737          	lui	a4,0x10001
    80005a46:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005a4a:	9781                	srai	a5,a5,0x20
    80005a4c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005a50:	689c                	ld	a5,16(s1)
    80005a52:	0007869b          	sext.w	a3,a5
    80005a56:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005a5a:	9781                	srai	a5,a5,0x20
    80005a5c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005a60:	4785                	li	a5,1
    80005a62:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005a64:	00f48c23          	sb	a5,24(s1)
    80005a68:	00f48ca3          	sb	a5,25(s1)
    80005a6c:	00f48d23          	sb	a5,26(s1)
    80005a70:	00f48da3          	sb	a5,27(s1)
    80005a74:	00f48e23          	sb	a5,28(s1)
    80005a78:	00f48ea3          	sb	a5,29(s1)
    80005a7c:	00f48f23          	sb	a5,30(s1)
    80005a80:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005a84:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a88:	07272823          	sw	s2,112(a4)
}
    80005a8c:	60e2                	ld	ra,24(sp)
    80005a8e:	6442                	ld	s0,16(sp)
    80005a90:	64a2                	ld	s1,8(sp)
    80005a92:	6902                	ld	s2,0(sp)
    80005a94:	6105                	addi	sp,sp,32
    80005a96:	8082                	ret
    panic("could not find virtio disk");
    80005a98:	00003517          	auipc	a0,0x3
    80005a9c:	bd850513          	addi	a0,a0,-1064 # 80008670 <etext+0x670>
    80005aa0:	d95fa0ef          	jal	80000834 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005aa4:	00003517          	auipc	a0,0x3
    80005aa8:	bec50513          	addi	a0,a0,-1044 # 80008690 <etext+0x690>
    80005aac:	d89fa0ef          	jal	80000834 <panic>
    panic("virtio disk should not be ready");
    80005ab0:	00003517          	auipc	a0,0x3
    80005ab4:	c0050513          	addi	a0,a0,-1024 # 800086b0 <etext+0x6b0>
    80005ab8:	d7dfa0ef          	jal	80000834 <panic>
    panic("virtio disk has no queue 0");
    80005abc:	00003517          	auipc	a0,0x3
    80005ac0:	c1450513          	addi	a0,a0,-1004 # 800086d0 <etext+0x6d0>
    80005ac4:	d71fa0ef          	jal	80000834 <panic>
    panic("virtio disk max queue too short");
    80005ac8:	00003517          	auipc	a0,0x3
    80005acc:	c2850513          	addi	a0,a0,-984 # 800086f0 <etext+0x6f0>
    80005ad0:	d65fa0ef          	jal	80000834 <panic>
    panic("virtio disk kalloc");
    80005ad4:	00003517          	auipc	a0,0x3
    80005ad8:	c3c50513          	addi	a0,a0,-964 # 80008710 <etext+0x710>
    80005adc:	d59fa0ef          	jal	80000834 <panic>

0000000080005ae0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005ae0:	711d                	addi	sp,sp,-96
    80005ae2:	ec86                	sd	ra,88(sp)
    80005ae4:	e8a2                	sd	s0,80(sp)
    80005ae6:	e4a6                	sd	s1,72(sp)
    80005ae8:	e0ca                	sd	s2,64(sp)
    80005aea:	fc4e                	sd	s3,56(sp)
    80005aec:	f852                	sd	s4,48(sp)
    80005aee:	f456                	sd	s5,40(sp)
    80005af0:	f05a                	sd	s6,32(sp)
    80005af2:	ec5e                	sd	s7,24(sp)
    80005af4:	e862                	sd	s8,16(sp)
    80005af6:	1080                	addi	s0,sp,96
    80005af8:	89aa                	mv	s3,a0
    80005afa:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005afc:	00c52b83          	lw	s7,12(a0)
    80005b00:	001b9b9b          	slliw	s7,s7,0x1
    80005b04:	1b82                	slli	s7,s7,0x20
    80005b06:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005b0a:	0001f517          	auipc	a0,0x1f
    80005b0e:	f5650513          	addi	a0,a0,-170 # 80024a60 <disk+0x128>
    80005b12:	8d6fb0ef          	jal	80000be8 <acquire>
  for (int i = 0; i < NUM; i++) {
    80005b16:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005b18:	0001fa97          	auipc	s5,0x1f
    80005b1c:	e20a8a93          	addi	s5,s5,-480 # 80024938 <disk>
  for (int i = 0; i < 3; i++) {
    80005b20:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005b22:	5c7d                	li	s8,-1
    80005b24:	a8a5                	j	80005b9c <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    80005b26:	00fa8733          	add	a4,s5,a5
    80005b2a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005b2e:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005b30:	0207c563          	bltz	a5,80005b5a <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    80005b34:	2905                	addiw	s2,s2,1
    80005b36:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005b38:	07490663          	beq	s2,s4,80005ba4 <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005b3c:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005b3e:	0001f717          	auipc	a4,0x1f
    80005b42:	dfa70713          	addi	a4,a4,-518 # 80024938 <disk>
    80005b46:	4781                	li	a5,0
    if (disk.free[i]) {
    80005b48:	01874683          	lbu	a3,24(a4)
    80005b4c:	fee9                	bnez	a3,80005b26 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    80005b4e:	2785                	addiw	a5,a5,1
    80005b50:	0705                	addi	a4,a4,1
    80005b52:	fe979be3          	bne	a5,s1,80005b48 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005b56:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    80005b5a:	01205d63          	blez	s2,80005b74 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005b5e:	fa042503          	lw	a0,-96(s0)
    80005b62:	d41ff0ef          	jal	800058a2 <free_desc>
      for (int j = 0; j < i; j++)
    80005b66:	4785                	li	a5,1
    80005b68:	0127d663          	bge	a5,s2,80005b74 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005b6c:	fa442503          	lw	a0,-92(s0)
    80005b70:	d33ff0ef          	jal	800058a2 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep_prepare(&disk.free[0]);
    80005b74:	0001f517          	auipc	a0,0x1f
    80005b78:	ddc50513          	addi	a0,a0,-548 # 80024950 <disk+0x18>
    80005b7c:	c76fc0ef          	jal	80001ff2 <sleep_prepare>
    release(&disk.vdisk_lock);
    80005b80:	0001f517          	auipc	a0,0x1f
    80005b84:	ee050513          	addi	a0,a0,-288 # 80024a60 <disk+0x128>
    80005b88:	8e8fb0ef          	jal	80000c70 <release>
    sleep();
    80005b8c:	ca2fc0ef          	jal	8000202e <sleep>
    acquire(&disk.vdisk_lock);
    80005b90:	0001f517          	auipc	a0,0x1f
    80005b94:	ed050513          	addi	a0,a0,-304 # 80024a60 <disk+0x128>
    80005b98:	850fb0ef          	jal	80000be8 <acquire>
  for (int i = 0; i < 3; i++) {
    80005b9c:	fa040613          	addi	a2,s0,-96
    80005ba0:	4901                	li	s2,0
    80005ba2:	bf69                	j	80005b3c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005ba4:	fa042503          	lw	a0,-96(s0)
    80005ba8:	00451693          	slli	a3,a0,0x4

  if (write)
    80005bac:	0001f797          	auipc	a5,0x1f
    80005bb0:	d8c78793          	addi	a5,a5,-628 # 80024938 <disk>
    80005bb4:	00451713          	slli	a4,a0,0x4
    80005bb8:	0a070713          	addi	a4,a4,160
    80005bbc:	973e                	add	a4,a4,a5
    80005bbe:	01603633          	snez	a2,s6
    80005bc2:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005bc4:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005bc8:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005bcc:	6398                	ld	a4,0(a5)
    80005bce:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005bd0:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005bd4:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005bd6:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005bd8:	6390                	ld	a2,0(a5)
    80005bda:	00d60833          	add	a6,a2,a3
    80005bde:	4741                	li	a4,16
    80005be0:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005be4:	4585                	li	a1,1
    80005be6:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80005bea:	fa442703          	lw	a4,-92(s0)
    80005bee:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80005bf2:	0712                	slli	a4,a4,0x4
    80005bf4:	963a                	add	a2,a2,a4
    80005bf6:	05898813          	addi	a6,s3,88
    80005bfa:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005bfe:	0007b883          	ld	a7,0(a5)
    80005c02:	9746                	add	a4,a4,a7
    80005c04:	40000613          	li	a2,1024
    80005c08:	c710                	sw	a2,8(a4)
  if (write)
    80005c0a:	001b3613          	seqz	a2,s6
    80005c0e:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005c12:	8e4d                	or	a2,a2,a1
    80005c14:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005c18:	fa842603          	lw	a2,-88(s0)
    80005c1c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005c20:	00451813          	slli	a6,a0,0x4
    80005c24:	02080813          	addi	a6,a6,32
    80005c28:	983e                	add	a6,a6,a5
    80005c2a:	577d                	li	a4,-1
    80005c2c:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80005c30:	0612                	slli	a2,a2,0x4
    80005c32:	98b2                	add	a7,a7,a2
    80005c34:	03068713          	addi	a4,a3,48
    80005c38:	973e                	add	a4,a4,a5
    80005c3a:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005c3e:	6398                	ld	a4,0(a5)
    80005c40:	9732                	add	a4,a4,a2
    80005c42:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005c44:	4689                	li	a3,2
    80005c46:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005c4a:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005c4e:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80005c52:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005c56:	6794                	ld	a3,8(a5)
    80005c58:	0026d703          	lhu	a4,2(a3)
    80005c5c:	8b1d                	andi	a4,a4,7
    80005c5e:	0706                	slli	a4,a4,0x1
    80005c60:	96ba                	add	a3,a3,a4
    80005c62:	00a69223          	sh	a0,4(a3)

// fence for memory-mapped IO
static inline void
io_fence()
{
  asm volatile("fence iorw, iorw" ::: "memory");
    80005c66:	0ff0000f          	fence

  io_fence();

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005c6a:	6798                	ld	a4,8(a5)
    80005c6c:	00275783          	lhu	a5,2(a4)
    80005c70:	2785                	addiw	a5,a5,1
    80005c72:	00f71123          	sh	a5,2(a4)
    80005c76:	0ff0000f          	fence

  io_fence();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005c7a:	100017b7          	lui	a5,0x10001
    80005c7e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005c82:	0049a783          	lw	a5,4(s3)
    sleep_prepare(b);
    release(&disk.vdisk_lock);
    80005c86:	0001f497          	auipc	s1,0x1f
    80005c8a:	dda48493          	addi	s1,s1,-550 # 80024a60 <disk+0x128>
  while (b->disk == 1) {
    80005c8e:	892e                	mv	s2,a1
    80005c90:	02b79163          	bne	a5,a1,80005cb2 <virtio_disk_rw+0x1d2>
    sleep_prepare(b);
    80005c94:	854e                	mv	a0,s3
    80005c96:	b5cfc0ef          	jal	80001ff2 <sleep_prepare>
    release(&disk.vdisk_lock);
    80005c9a:	8526                	mv	a0,s1
    80005c9c:	fd5fa0ef          	jal	80000c70 <release>
    sleep();
    80005ca0:	b8efc0ef          	jal	8000202e <sleep>
    acquire(&disk.vdisk_lock);
    80005ca4:	8526                	mv	a0,s1
    80005ca6:	f43fa0ef          	jal	80000be8 <acquire>
  while (b->disk == 1) {
    80005caa:	0049a783          	lw	a5,4(s3)
    80005cae:	ff2783e3          	beq	a5,s2,80005c94 <virtio_disk_rw+0x1b4>
  }

  disk.info[idx[0]].b = 0;
    80005cb2:	fa042903          	lw	s2,-96(s0)
    80005cb6:	00491713          	slli	a4,s2,0x4
    80005cba:	02070713          	addi	a4,a4,32
    80005cbe:	0001f797          	auipc	a5,0x1f
    80005cc2:	c7a78793          	addi	a5,a5,-902 # 80024938 <disk>
    80005cc6:	97ba                	add	a5,a5,a4
    80005cc8:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005ccc:	0001f997          	auipc	s3,0x1f
    80005cd0:	c6c98993          	addi	s3,s3,-916 # 80024938 <disk>
    80005cd4:	00491713          	slli	a4,s2,0x4
    80005cd8:	0009b783          	ld	a5,0(s3)
    80005cdc:	97ba                	add	a5,a5,a4
    80005cde:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005ce2:	854a                	mv	a0,s2
    80005ce4:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005ce8:	bbbff0ef          	jal	800058a2 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005cec:	8885                	andi	s1,s1,1
    80005cee:	f0fd                	bnez	s1,80005cd4 <virtio_disk_rw+0x1f4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005cf0:	0001f517          	auipc	a0,0x1f
    80005cf4:	d7050513          	addi	a0,a0,-656 # 80024a60 <disk+0x128>
    80005cf8:	f79fa0ef          	jal	80000c70 <release>
}
    80005cfc:	60e6                	ld	ra,88(sp)
    80005cfe:	6446                	ld	s0,80(sp)
    80005d00:	64a6                	ld	s1,72(sp)
    80005d02:	6906                	ld	s2,64(sp)
    80005d04:	79e2                	ld	s3,56(sp)
    80005d06:	7a42                	ld	s4,48(sp)
    80005d08:	7aa2                	ld	s5,40(sp)
    80005d0a:	7b02                	ld	s6,32(sp)
    80005d0c:	6be2                	ld	s7,24(sp)
    80005d0e:	6c42                	ld	s8,16(sp)
    80005d10:	6125                	addi	sp,sp,96
    80005d12:	8082                	ret

0000000080005d14 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005d14:	1101                	addi	sp,sp,-32
    80005d16:	ec06                	sd	ra,24(sp)
    80005d18:	e822                	sd	s0,16(sp)
    80005d1a:	e426                	sd	s1,8(sp)
    80005d1c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005d1e:	0001f497          	auipc	s1,0x1f
    80005d22:	c1a48493          	addi	s1,s1,-998 # 80024938 <disk>
    80005d26:	0001f517          	auipc	a0,0x1f
    80005d2a:	d3a50513          	addi	a0,a0,-710 # 80024a60 <disk+0x128>
    80005d2e:	ebbfa0ef          	jal	80000be8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005d32:	100017b7          	lui	a5,0x10001
    80005d36:	53bc                	lw	a5,96(a5)
    80005d38:	8b8d                	andi	a5,a5,3
    80005d3a:	10001737          	lui	a4,0x10001
    80005d3e:	d37c                	sw	a5,100(a4)
    80005d40:	0ff0000f          	fence
  io_fence();

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005d44:	689c                	ld	a5,16(s1)
    80005d46:	0204d703          	lhu	a4,32(s1)
    80005d4a:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005d4e:	04f70863          	beq	a4,a5,80005d9e <virtio_disk_intr+0x8a>
    80005d52:	0ff0000f          	fence
    io_fence();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005d56:	6898                	ld	a4,16(s1)
    80005d58:	0204d783          	lhu	a5,32(s1)
    80005d5c:	8b9d                	andi	a5,a5,7
    80005d5e:	078e                	slli	a5,a5,0x3
    80005d60:	97ba                	add	a5,a5,a4
    80005d62:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80005d64:	00479713          	slli	a4,a5,0x4
    80005d68:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80005d6c:	9726                	add	a4,a4,s1
    80005d6e:	01074703          	lbu	a4,16(a4)
    80005d72:	e329                	bnez	a4,80005db4 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005d74:	0792                	slli	a5,a5,0x4
    80005d76:	02078793          	addi	a5,a5,32
    80005d7a:	97a6                	add	a5,a5,s1
    80005d7c:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    80005d7e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005d82:	adcfc0ef          	jal	8000205e <wakeup>

    disk.used_idx += 1;
    80005d86:	0204d783          	lhu	a5,32(s1)
    80005d8a:	2785                	addiw	a5,a5,1
    80005d8c:	17c2                	slli	a5,a5,0x30
    80005d8e:	93c1                	srli	a5,a5,0x30
    80005d90:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005d94:	6898                	ld	a4,16(s1)
    80005d96:	00275703          	lhu	a4,2(a4)
    80005d9a:	faf71ce3          	bne	a4,a5,80005d52 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005d9e:	0001f517          	auipc	a0,0x1f
    80005da2:	cc250513          	addi	a0,a0,-830 # 80024a60 <disk+0x128>
    80005da6:	ecbfa0ef          	jal	80000c70 <release>
}
    80005daa:	60e2                	ld	ra,24(sp)
    80005dac:	6442                	ld	s0,16(sp)
    80005dae:	64a2                	ld	s1,8(sp)
    80005db0:	6105                	addi	sp,sp,32
    80005db2:	8082                	ret
      panic("virtio_disk_intr status");
    80005db4:	00003517          	auipc	a0,0x3
    80005db8:	97450513          	addi	a0,a0,-1676 # 80008728 <etext+0x728>
    80005dbc:	a79fa0ef          	jal	80000834 <panic>

0000000080005dc0 <seminit>:
  struct semaphore sem[NSEM];
} semtable;

void
seminit(void)
{
    80005dc0:	7179                	addi	sp,sp,-48
    80005dc2:	f406                	sd	ra,40(sp)
    80005dc4:	f022                	sd	s0,32(sp)
    80005dc6:	ec26                	sd	s1,24(sp)
    80005dc8:	e84a                	sd	s2,16(sp)
    80005dca:	e44e                	sd	s3,8(sp)
    80005dcc:	1800                	addi	s0,sp,48
  int i;

  initlock(&semtable.lock, "semtable");
    80005dce:	00003597          	auipc	a1,0x3
    80005dd2:	97258593          	addi	a1,a1,-1678 # 80008740 <etext+0x740>
    80005dd6:	0001f517          	auipc	a0,0x1f
    80005dda:	ca250513          	addi	a0,a0,-862 # 80024a78 <semtable>
    80005dde:	d8bfa0ef          	jal	80000b68 <initlock>

  for(i = 0; i < NSEM; i++){
    80005de2:	0001f497          	auipc	s1,0x1f
    80005de6:	cae48493          	addi	s1,s1,-850 # 80024a90 <semtable+0x18>
    80005dea:	0001f997          	auipc	s3,0x1f
    80005dee:	ea698993          	addi	s3,s3,-346 # 80024c90 <end>
    initlock(&semtable.sem[i].lock, "semaphore");
    80005df2:	00003917          	auipc	s2,0x3
    80005df6:	95e90913          	addi	s2,s2,-1698 # 80008750 <etext+0x750>
    80005dfa:	85ca                	mv	a1,s2
    80005dfc:	8526                	mv	a0,s1
    80005dfe:	d6bfa0ef          	jal	80000b68 <initlock>
    semtable.sem[i].value = 0;
    80005e02:	0004ac23          	sw	zero,24(s1)
    semtable.sem[i].used = 0;
    80005e06:	0004ae23          	sw	zero,28(s1)
  for(i = 0; i < NSEM; i++){
    80005e0a:	02048493          	addi	s1,s1,32
    80005e0e:	ff3496e3          	bne	s1,s3,80005dfa <seminit+0x3a>
  }
}
    80005e12:	70a2                	ld	ra,40(sp)
    80005e14:	7402                	ld	s0,32(sp)
    80005e16:	64e2                	ld	s1,24(sp)
    80005e18:	6942                	ld	s2,16(sp)
    80005e1a:	69a2                	ld	s3,8(sp)
    80005e1c:	6145                	addi	sp,sp,48
    80005e1e:	8082                	ret

0000000080005e20 <sem_create>:

int
sem_create(int value)
{
    80005e20:	1101                	addi	sp,sp,-32
    80005e22:	ec06                	sd	ra,24(sp)
    80005e24:	e822                	sd	s0,16(sp)
    80005e26:	e426                	sd	s1,8(sp)
    80005e28:	1000                	addi	s0,sp,32
  int i;

  if(value < 0)
    80005e2a:	06054a63          	bltz	a0,80005e9e <sem_create+0x7e>
    80005e2e:	e04a                	sd	s2,0(sp)
    80005e30:	892a                	mv	s2,a0
    return -1;

  acquire(&semtable.lock);
    80005e32:	0001f517          	auipc	a0,0x1f
    80005e36:	c4650513          	addi	a0,a0,-954 # 80024a78 <semtable>
    80005e3a:	daffa0ef          	jal	80000be8 <acquire>

  for(i = 0; i < NSEM; i++){
    80005e3e:	0001f797          	auipc	a5,0x1f
    80005e42:	c6e78793          	addi	a5,a5,-914 # 80024aac <semtable+0x34>
    80005e46:	4481                	li	s1,0
    80005e48:	46c1                	li	a3,16
    if(!semtable.sem[i].used){
    80005e4a:	4398                	lw	a4,0(a5)
    80005e4c:	c705                	beqz	a4,80005e74 <sem_create+0x54>
  for(i = 0; i < NSEM; i++){
    80005e4e:	2485                	addiw	s1,s1,1
    80005e50:	02078793          	addi	a5,a5,32
    80005e54:	fed49be3          	bne	s1,a3,80005e4a <sem_create+0x2a>
      release(&semtable.lock);
      return i;
    }
  }

  release(&semtable.lock);
    80005e58:	0001f517          	auipc	a0,0x1f
    80005e5c:	c2050513          	addi	a0,a0,-992 # 80024a78 <semtable>
    80005e60:	e11fa0ef          	jal	80000c70 <release>
  return -1;
    80005e64:	54fd                	li	s1,-1
    80005e66:	6902                	ld	s2,0(sp)
}
    80005e68:	8526                	mv	a0,s1
    80005e6a:	60e2                	ld	ra,24(sp)
    80005e6c:	6442                	ld	s0,16(sp)
    80005e6e:	64a2                	ld	s1,8(sp)
    80005e70:	6105                	addi	sp,sp,32
    80005e72:	8082                	ret
      semtable.sem[i].used = 1;
    80005e74:	00549713          	slli	a4,s1,0x5
    80005e78:	02070713          	addi	a4,a4,32
    80005e7c:	0001f797          	auipc	a5,0x1f
    80005e80:	bfc78793          	addi	a5,a5,-1028 # 80024a78 <semtable>
    80005e84:	97ba                	add	a5,a5,a4
    80005e86:	4705                	li	a4,1
    80005e88:	cbd8                	sw	a4,20(a5)
      semtable.sem[i].value = value;
    80005e8a:	0127a823          	sw	s2,16(a5)
      release(&semtable.lock);
    80005e8e:	0001f517          	auipc	a0,0x1f
    80005e92:	bea50513          	addi	a0,a0,-1046 # 80024a78 <semtable>
    80005e96:	ddbfa0ef          	jal	80000c70 <release>
      return i;
    80005e9a:	6902                	ld	s2,0(sp)
    80005e9c:	b7f1                	j	80005e68 <sem_create+0x48>
    return -1;
    80005e9e:	54fd                	li	s1,-1
    80005ea0:	b7e1                	j	80005e68 <sem_create+0x48>

0000000080005ea2 <sem_wait>:
int
sem_wait(int id)
{
  struct semaphore *sem;

  if(id < 0 || id >= NSEM)
    80005ea2:	47bd                	li	a5,15
    80005ea4:	08a7e963          	bltu	a5,a0,80005f36 <sem_wait+0x94>
{
    80005ea8:	7179                	addi	sp,sp,-48
    80005eaa:	f406                	sd	ra,40(sp)
    80005eac:	f022                	sd	s0,32(sp)
    80005eae:	ec26                	sd	s1,24(sp)
    80005eb0:	e84a                	sd	s2,16(sp)
    80005eb2:	e44e                	sd	s3,8(sp)
    80005eb4:	1800                	addi	s0,sp,48
    80005eb6:	89aa                	mv	s3,a0
    return -1;

  sem = &semtable.sem[id];
    80005eb8:	0001f917          	auipc	s2,0x1f
    80005ebc:	bc090913          	addi	s2,s2,-1088 # 80024a78 <semtable>
    80005ec0:	00551493          	slli	s1,a0,0x5
    80005ec4:	04e1                	addi	s1,s1,24
    80005ec6:	94ca                	add	s1,s1,s2

  acquire(&sem->lock);
    80005ec8:	8526                	mv	a0,s1
    80005eca:	d1ffa0ef          	jal	80000be8 <acquire>

  while(sem->value == 0){
    80005ece:	00599793          	slli	a5,s3,0x5
    80005ed2:	02078793          	addi	a5,a5,32
    80005ed6:	993e                	add	s2,s2,a5
    80005ed8:	01092783          	lw	a5,16(s2)
    80005edc:	eb85                	bnez	a5,80005f0c <sem_wait+0x6a>
    80005ede:	00599793          	slli	a5,s3,0x5
    80005ee2:	02078793          	addi	a5,a5,32
    80005ee6:	0001f917          	auipc	s2,0x1f
    80005eea:	b9290913          	addi	s2,s2,-1134 # 80024a78 <semtable>
    80005eee:	993e                	add	s2,s2,a5
    sleep_prepare(sem);
    80005ef0:	8526                	mv	a0,s1
    80005ef2:	900fc0ef          	jal	80001ff2 <sleep_prepare>
    release(&sem->lock);
    80005ef6:	8526                	mv	a0,s1
    80005ef8:	d79fa0ef          	jal	80000c70 <release>
    sleep();
    80005efc:	932fc0ef          	jal	8000202e <sleep>
    acquire(&sem->lock);
    80005f00:	8526                	mv	a0,s1
    80005f02:	ce7fa0ef          	jal	80000be8 <acquire>
  while(sem->value == 0){
    80005f06:	01092783          	lw	a5,16(s2)
    80005f0a:	d3fd                	beqz	a5,80005ef0 <sem_wait+0x4e>
  }

  sem->value--;
    80005f0c:	0996                	slli	s3,s3,0x5
    80005f0e:	02098993          	addi	s3,s3,32
    80005f12:	0001f717          	auipc	a4,0x1f
    80005f16:	b6670713          	addi	a4,a4,-1178 # 80024a78 <semtable>
    80005f1a:	974e                	add	a4,a4,s3
    80005f1c:	37fd                	addiw	a5,a5,-1
    80005f1e:	cb1c                	sw	a5,16(a4)

  release(&sem->lock);
    80005f20:	8526                	mv	a0,s1
    80005f22:	d4ffa0ef          	jal	80000c70 <release>

  return 0;
    80005f26:	4501                	li	a0,0
}
    80005f28:	70a2                	ld	ra,40(sp)
    80005f2a:	7402                	ld	s0,32(sp)
    80005f2c:	64e2                	ld	s1,24(sp)
    80005f2e:	6942                	ld	s2,16(sp)
    80005f30:	69a2                	ld	s3,8(sp)
    80005f32:	6145                	addi	sp,sp,48
    80005f34:	8082                	ret
    return -1;
    80005f36:	557d                	li	a0,-1
}
    80005f38:	8082                	ret

0000000080005f3a <sem_signal>:
int
sem_signal(int id)
{
  struct semaphore *sem;

  if(id < 0 || id >= NSEM)
    80005f3a:	47bd                	li	a5,15
    80005f3c:	04a7ec63          	bltu	a5,a0,80005f94 <sem_signal+0x5a>
{
    80005f40:	7179                	addi	sp,sp,-48
    80005f42:	f406                	sd	ra,40(sp)
    80005f44:	f022                	sd	s0,32(sp)
    80005f46:	ec26                	sd	s1,24(sp)
    80005f48:	e84a                	sd	s2,16(sp)
    80005f4a:	e44e                	sd	s3,8(sp)
    80005f4c:	1800                	addi	s0,sp,48
    80005f4e:	84aa                	mv	s1,a0
    return -1;

  sem = &semtable.sem[id];
    80005f50:	0001f997          	auipc	s3,0x1f
    80005f54:	b2898993          	addi	s3,s3,-1240 # 80024a78 <semtable>
    80005f58:	00551913          	slli	s2,a0,0x5
    80005f5c:	0961                	addi	s2,s2,24
    80005f5e:	994e                	add	s2,s2,s3

  acquire(&sem->lock);
    80005f60:	854a                	mv	a0,s2
    80005f62:	c87fa0ef          	jal	80000be8 <acquire>

  sem->value++;
    80005f66:	0496                	slli	s1,s1,0x5
    80005f68:	02048493          	addi	s1,s1,32
    80005f6c:	99a6                	add	s3,s3,s1
    80005f6e:	0109a783          	lw	a5,16(s3)
    80005f72:	2785                	addiw	a5,a5,1
    80005f74:	00f9a823          	sw	a5,16(s3)

  wakeup(sem);
    80005f78:	854a                	mv	a0,s2
    80005f7a:	8e4fc0ef          	jal	8000205e <wakeup>

  release(&sem->lock);
    80005f7e:	854a                	mv	a0,s2
    80005f80:	cf1fa0ef          	jal	80000c70 <release>

  return 0;
    80005f84:	4501                	li	a0,0
}
    80005f86:	70a2                	ld	ra,40(sp)
    80005f88:	7402                	ld	s0,32(sp)
    80005f8a:	64e2                	ld	s1,24(sp)
    80005f8c:	6942                	ld	s2,16(sp)
    80005f8e:	69a2                	ld	s3,8(sp)
    80005f90:	6145                	addi	sp,sp,48
    80005f92:	8082                	ret
    return -1;
    80005f94:	557d                	li	a0,-1
}
    80005f96:	8082                	ret

0000000080005f98 <sem_free>:
int
sem_free(int id)
{
  struct semaphore *sem;

  if(id < 0 || id >= NSEM)
    80005f98:	47bd                	li	a5,15
    80005f9a:	08a7e863          	bltu	a5,a0,8000602a <sem_free+0x92>
{
    80005f9e:	7179                	addi	sp,sp,-48
    80005fa0:	f406                	sd	ra,40(sp)
    80005fa2:	f022                	sd	s0,32(sp)
    80005fa4:	ec26                	sd	s1,24(sp)
    80005fa6:	e84a                	sd	s2,16(sp)
    80005fa8:	e44e                	sd	s3,8(sp)
    80005faa:	1800                	addi	s0,sp,48
    80005fac:	84aa                	mv	s1,a0
    return -1;

  sem = &semtable.sem[id];

  acquire(&semtable.lock);
    80005fae:	0001f917          	auipc	s2,0x1f
    80005fb2:	aca90913          	addi	s2,s2,-1334 # 80024a78 <semtable>
    80005fb6:	854a                	mv	a0,s2
    80005fb8:	c31fa0ef          	jal	80000be8 <acquire>
  acquire(&sem->lock);
    80005fbc:	00549993          	slli	s3,s1,0x5
    80005fc0:	09e1                	addi	s3,s3,24
    80005fc2:	99ca                	add	s3,s3,s2
    80005fc4:	854e                	mv	a0,s3
    80005fc6:	c23fa0ef          	jal	80000be8 <acquire>

  if(!sem->used){
    80005fca:	00549793          	slli	a5,s1,0x5
    80005fce:	02078793          	addi	a5,a5,32
    80005fd2:	993e                	add	s2,s2,a5
    80005fd4:	01492783          	lw	a5,20(s2)
    80005fd8:	cf95                	beqz	a5,80006014 <sem_free+0x7c>
    release(&sem->lock);
    release(&semtable.lock);
    return -1;
  }

  sem->used = 0;
    80005fda:	0496                	slli	s1,s1,0x5
    80005fdc:	02048493          	addi	s1,s1,32
    80005fe0:	0001f797          	auipc	a5,0x1f
    80005fe4:	a9878793          	addi	a5,a5,-1384 # 80024a78 <semtable>
    80005fe8:	97a6                	add	a5,a5,s1
    80005fea:	0007aa23          	sw	zero,20(a5)
  sem->value = 0;
    80005fee:	0007a823          	sw	zero,16(a5)

  release(&sem->lock);
    80005ff2:	854e                	mv	a0,s3
    80005ff4:	c7dfa0ef          	jal	80000c70 <release>
  release(&semtable.lock);
    80005ff8:	0001f517          	auipc	a0,0x1f
    80005ffc:	a8050513          	addi	a0,a0,-1408 # 80024a78 <semtable>
    80006000:	c71fa0ef          	jal	80000c70 <release>

  return 0;
    80006004:	4501                	li	a0,0
}
    80006006:	70a2                	ld	ra,40(sp)
    80006008:	7402                	ld	s0,32(sp)
    8000600a:	64e2                	ld	s1,24(sp)
    8000600c:	6942                	ld	s2,16(sp)
    8000600e:	69a2                	ld	s3,8(sp)
    80006010:	6145                	addi	sp,sp,48
    80006012:	8082                	ret
    release(&sem->lock);
    80006014:	854e                	mv	a0,s3
    80006016:	c5bfa0ef          	jal	80000c70 <release>
    release(&semtable.lock);
    8000601a:	0001f517          	auipc	a0,0x1f
    8000601e:	a5e50513          	addi	a0,a0,-1442 # 80024a78 <semtable>
    80006022:	c4ffa0ef          	jal	80000c70 <release>
    return -1;
    80006026:	557d                	li	a0,-1
    80006028:	bff9                	j	80006006 <sem_free+0x6e>
    return -1;
    8000602a:	557d                	li	a0,-1
}
    8000602c:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	9282                	jalr	t0

000000008000709c <userret>:
    8000709c:	0000100f          	fence.i
    800070a0:	12000073          	sfence.vma
    800070a4:	18051073          	csrw	satp,a0
    800070a8:	12000073          	sfence.vma
    800070ac:	02000537          	lui	a0,0x2000
    800070b0:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070b2:	0536                	slli	a0,a0,0xd
    800070b4:	02853083          	ld	ra,40(a0)
    800070b8:	03053103          	ld	sp,48(a0)
    800070bc:	03853183          	ld	gp,56(a0)
    800070c0:	04053203          	ld	tp,64(a0)
    800070c4:	04853283          	ld	t0,72(a0)
    800070c8:	05053303          	ld	t1,80(a0)
    800070cc:	05853383          	ld	t2,88(a0)
    800070d0:	7120                	ld	s0,96(a0)
    800070d2:	7524                	ld	s1,104(a0)
    800070d4:	7d2c                	ld	a1,120(a0)
    800070d6:	6150                	ld	a2,128(a0)
    800070d8:	6554                	ld	a3,136(a0)
    800070da:	6958                	ld	a4,144(a0)
    800070dc:	6d5c                	ld	a5,152(a0)
    800070de:	0a053803          	ld	a6,160(a0)
    800070e2:	0a853883          	ld	a7,168(a0)
    800070e6:	0b053903          	ld	s2,176(a0)
    800070ea:	0b853983          	ld	s3,184(a0)
    800070ee:	0c053a03          	ld	s4,192(a0)
    800070f2:	0c853a83          	ld	s5,200(a0)
    800070f6:	0d053b03          	ld	s6,208(a0)
    800070fa:	0d853b83          	ld	s7,216(a0)
    800070fe:	0e053c03          	ld	s8,224(a0)
    80007102:	0e853c83          	ld	s9,232(a0)
    80007106:	0f053d03          	ld	s10,240(a0)
    8000710a:	0f853d83          	ld	s11,248(a0)
    8000710e:	10053e03          	ld	t3,256(a0)
    80007112:	10853e83          	ld	t4,264(a0)
    80007116:	11053f03          	ld	t5,272(a0)
    8000711a:	11853f83          	ld	t6,280(a0)
    8000711e:	7928                	ld	a0,112(a0)
    80007120:	10200073          	sret
	...
