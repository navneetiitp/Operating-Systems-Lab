
user/_readwrite:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <reader>:
};

void
reader(struct shared_rw *shared, int mutex, int resource, int queue,
       int output_mutex, int id)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	84aa                	mv	s1,a0
  20:	892e                	mv	s2,a1
  22:	f8c43423          	sd	a2,-120(s0)
  26:	8b36                	mv	s6,a3
  28:	8aba                	mv	s5,a4
  2a:	8cbe                	mv	s9,a5
  2c:	4a15                	li	s4,5
    sem_wait(queue);

    sem_wait(mutex);
    shared->read_count++;

    if(shared->read_count == 1)
  2e:	4b85                	li	s7,1
    // Multiple readers can be here simultaneously.
    value = shared->shared_data;

    sem_wait(output_mutex);

     printf("Reader %d (PID %d) [time %d]: READ shared_data = %d, active_readers = %d\n",
  30:	00001d97          	auipc	s11,0x1
  34:	b60d8d93          	addi	s11,s11,-1184 # b90 <malloc+0xf4>
       id, getpid(), uptime(), value, shared->read_count);

    sem_signal(output_mutex);

    sleep(2);
  38:	4d09                	li	s10,2
  3a:	a839                	j	58 <reader+0x58>
      sem_wait(resource);
  3c:	f8843503          	ld	a0,-120(s0)
  40:	55e000ef          	jal	59e <sem_wait>
  44:	a02d                	j	6e <reader+0x6e>
    shared->read_count--;

    if(shared->read_count == 0)
      sem_signal(resource);

    sem_signal(mutex);
  46:	854a                	mv	a0,s2
  48:	55e000ef          	jal	5a6 <sem_signal>

    sleep(1);
  4c:	855e                	mv	a0,s7
  4e:	528000ef          	jal	576 <sleep>
  for(int i = 0; i < READS_PER_READER; i++){
  52:	3a7d                	addiw	s4,s4,-1
  54:	060a0763          	beqz	s4,c2 <reader+0xc2>
    sem_wait(queue);
  58:	855a                	mv	a0,s6
  5a:	544000ef          	jal	59e <sem_wait>
    sem_wait(mutex);
  5e:	854a                	mv	a0,s2
  60:	53e000ef          	jal	59e <sem_wait>
    shared->read_count++;
  64:	40dc                	lw	a5,4(s1)
  66:	2785                	addiw	a5,a5,1
  68:	c0dc                	sw	a5,4(s1)
    if(shared->read_count == 1)
  6a:	fd7789e3          	beq	a5,s7,3c <reader+0x3c>
    sem_signal(queue);
  6e:	855a                	mv	a0,s6
  70:	536000ef          	jal	5a6 <sem_signal>
    sem_signal(mutex);
  74:	854a                	mv	a0,s2
  76:	530000ef          	jal	5a6 <sem_signal>
    value = shared->shared_data;
  7a:	0004ac03          	lw	s8,0(s1)
    sem_wait(output_mutex);
  7e:	8556                	mv	a0,s5
  80:	51e000ef          	jal	59e <sem_wait>
     printf("Reader %d (PID %d) [time %d]: READ shared_data = %d, active_readers = %d\n",
  84:	58a000ef          	jal	60e <getpid>
  88:	89aa                	mv	s3,a0
  8a:	59c000ef          	jal	626 <uptime>
  8e:	86aa                	mv	a3,a0
  90:	40dc                	lw	a5,4(s1)
  92:	8762                	mv	a4,s8
  94:	864e                	mv	a2,s3
  96:	85e6                	mv	a1,s9
  98:	856e                	mv	a0,s11
  9a:	14b000ef          	jal	9e4 <printf>
    sem_signal(output_mutex);
  9e:	8556                	mv	a0,s5
  a0:	506000ef          	jal	5a6 <sem_signal>
    sleep(2);
  a4:	856a                	mv	a0,s10
  a6:	4d0000ef          	jal	576 <sleep>
    sem_wait(mutex);
  aa:	854a                	mv	a0,s2
  ac:	4f2000ef          	jal	59e <sem_wait>
    shared->read_count--;
  b0:	40dc                	lw	a5,4(s1)
  b2:	37fd                	addiw	a5,a5,-1
  b4:	c0dc                	sw	a5,4(s1)
    if(shared->read_count == 0)
  b6:	fbc1                	bnez	a5,46 <reader+0x46>
      sem_signal(resource);
  b8:	f8843503          	ld	a0,-120(s0)
  bc:	4ea000ef          	jal	5a6 <sem_signal>
  c0:	b759                	j	46 <reader+0x46>
  }

  exit(0);
  c2:	4501                	li	a0,0
  c4:	4a2000ef          	jal	566 <exit>

00000000000000c8 <writer>:
}

void
writer(struct shared_rw *shared, int resource, int queue,
       int output_mutex, int id)
{
  c8:	711d                	addi	sp,sp,-96
  ca:	ec86                	sd	ra,88(sp)
  cc:	e8a2                	sd	s0,80(sp)
  ce:	e4a6                	sd	s1,72(sp)
  d0:	e0ca                	sd	s2,64(sp)
  d2:	fc4e                	sd	s3,56(sp)
  d4:	f852                	sd	s4,48(sp)
  d6:	f456                	sd	s5,40(sp)
  d8:	f05a                	sd	s6,32(sp)
  da:	ec5e                	sd	s7,24(sp)
  dc:	e862                	sd	s8,16(sp)
  de:	e466                	sd	s9,8(sp)
  e0:	1080                	addi	s0,sp,96
  e2:	892a                	mv	s2,a0
  e4:	8b2e                	mv	s6,a1
  e6:	8ab2                	mv	s5,a2
  e8:	8a36                	mv	s4,a3
  ea:	8c3a                	mv	s8,a4
  ec:	4995                	li	s3,5
    sem_signal(queue);

    shared->shared_data++;
sem_wait(output_mutex);

printf("Writer %d (PID %d) [time %d]: WRITE shared_data = %d\n",
  ee:	00001c97          	auipc	s9,0x1
  f2:	af2c8c93          	addi	s9,s9,-1294 # be0 <malloc+0x144>
       id, getpid(), uptime(), shared->shared_data);

sem_signal(output_mutex);
    sleep(2);
  f6:	4b89                	li	s7,2
    sem_wait(queue);
  f8:	8556                	mv	a0,s5
  fa:	4a4000ef          	jal	59e <sem_wait>
    sem_wait(resource);
  fe:	855a                	mv	a0,s6
 100:	49e000ef          	jal	59e <sem_wait>
    sem_signal(queue);
 104:	8556                	mv	a0,s5
 106:	4a0000ef          	jal	5a6 <sem_signal>
    shared->shared_data++;
 10a:	00092783          	lw	a5,0(s2)
 10e:	2785                	addiw	a5,a5,1
 110:	00f92023          	sw	a5,0(s2)
sem_wait(output_mutex);
 114:	8552                	mv	a0,s4
 116:	488000ef          	jal	59e <sem_wait>
printf("Writer %d (PID %d) [time %d]: WRITE shared_data = %d\n",
 11a:	4f4000ef          	jal	60e <getpid>
 11e:	84aa                	mv	s1,a0
 120:	506000ef          	jal	626 <uptime>
 124:	86aa                	mv	a3,a0
 126:	00092703          	lw	a4,0(s2)
 12a:	8626                	mv	a2,s1
 12c:	85e2                	mv	a1,s8
 12e:	8566                	mv	a0,s9
 130:	0b5000ef          	jal	9e4 <printf>
sem_signal(output_mutex);
 134:	8552                	mv	a0,s4
 136:	470000ef          	jal	5a6 <sem_signal>
    sleep(2);
 13a:	855e                	mv	a0,s7
 13c:	43a000ef          	jal	576 <sleep>

    sem_signal(resource);
 140:	855a                	mv	a0,s6
 142:	464000ef          	jal	5a6 <sem_signal>

    sleep(2);
 146:	855e                	mv	a0,s7
 148:	42e000ef          	jal	576 <sleep>
  for(int i = 0; i < WRITES_PER_WRITER; i++){
 14c:	39fd                	addiw	s3,s3,-1
 14e:	fa0995e3          	bnez	s3,f8 <writer+0x30>
  }

  exit(0);
 152:	4501                	li	a0,0
 154:	412000ef          	jal	566 <exit>

0000000000000158 <main>:
}

int
main(void)
{
 158:	7139                	addi	sp,sp,-64
 15a:	fc06                	sd	ra,56(sp)
 15c:	f822                	sd	s0,48(sp)
 15e:	0080                	addi	s0,sp,64
  int queue;
  int output_mutex;
  int pid;
  int i;

  shared = (volatile struct shared_rw *)shm_get();
 160:	4d6000ef          	jal	636 <shm_get>

  if(shared == (void *)-1){
 164:	57fd                	li	a5,-1
 166:	04f50e63          	beq	a0,a5,1c2 <main+0x6a>
 16a:	f426                	sd	s1,40(sp)
 16c:	f04a                	sd	s2,32(sp)
 16e:	ec4e                	sd	s3,24(sp)
 170:	e852                	sd	s4,16(sp)
 172:	e05a                	sd	s6,0(sp)
 174:	84aa                	mv	s1,a0
    printf("shm_get failed\n");
    exit(1);
  }

  shared->shared_data = 0;
 176:	00052023          	sw	zero,0(a0)
  shared->read_count = 0;
 17a:	00052223          	sw	zero,4(a0)
   *
   * queue:
   * Fairness gate. Readers and writers must pass
   * through this gate before accessing resource.
   */
  mutex = sem_create(1);
 17e:	4505                	li	a0,1
 180:	416000ef          	jal	596 <sem_create>
 184:	8a2a                	mv	s4,a0
  resource = sem_create(1);
 186:	4505                	li	a0,1
 188:	40e000ef          	jal	596 <sem_create>
 18c:	89aa                	mv	s3,a0
  queue = sem_create(1);
 18e:	4505                	li	a0,1
 190:	406000ef          	jal	596 <sem_create>
 194:	892a                	mv	s2,a0
output_mutex = sem_create(1);
 196:	4505                	li	a0,1
 198:	3fe000ef          	jal	596 <sem_create>
 19c:	8b2a                	mv	s6,a0
  if(mutex < 0 || resource < 0 || queue < 0){
 19e:	013a67b3          	or	a5,s4,s3
 1a2:	00f967b3          	or	a5,s2,a5
 1a6:	02079713          	slli	a4,a5,0x20
 1aa:	02075b63          	bgez	a4,1e0 <main+0x88>
 1ae:	e456                	sd	s5,8(sp)
    printf("Semaphore creation failed\n");
 1b0:	00001517          	auipc	a0,0x1
 1b4:	a7850513          	addi	a0,a0,-1416 # c28 <malloc+0x18c>
 1b8:	02d000ef          	jal	9e4 <printf>
    exit(1);
 1bc:	4505                	li	a0,1
 1be:	3a8000ef          	jal	566 <exit>
 1c2:	f426                	sd	s1,40(sp)
 1c4:	f04a                	sd	s2,32(sp)
 1c6:	ec4e                	sd	s3,24(sp)
 1c8:	e852                	sd	s4,16(sp)
 1ca:	e456                	sd	s5,8(sp)
 1cc:	e05a                	sd	s6,0(sp)
    printf("shm_get failed\n");
 1ce:	00001517          	auipc	a0,0x1
 1d2:	a4a50513          	addi	a0,a0,-1462 # c18 <malloc+0x17c>
 1d6:	00f000ef          	jal	9e4 <printf>
    exit(1);
 1da:	4505                	li	a0,1
 1dc:	38a000ef          	jal	566 <exit>
 1e0:	e456                	sd	s5,8(sp)
  }

  printf("Readers-Writers started\n");
 1e2:	00001517          	auipc	a0,0x1
 1e6:	a6650513          	addi	a0,a0,-1434 # c48 <malloc+0x1ac>
 1ea:	7fa000ef          	jal	9e4 <printf>
  printf("Readers = %d, Writers = %d\n",
 1ee:	4609                	li	a2,2
 1f0:	458d                	li	a1,3
 1f2:	00001517          	auipc	a0,0x1
 1f6:	a7650513          	addi	a0,a0,-1418 # c68 <malloc+0x1cc>
 1fa:	7ea000ef          	jal	9e4 <printf>
         NUM_READERS, NUM_WRITERS);

  /*
   * Create 3 reader processes.
   */
  for(i = 0; i < NUM_READERS; i++){
 1fe:	4a81                	li	s5,0
    pid = fork();
 200:	35e000ef          	jal	55e <fork>

    if(pid < 0){
 204:	06054463          	bltz	a0,26c <main+0x114>
      printf("fork failed\n");
      exit(1);
    }

    if(pid == 0){
 208:	c93d                	beqz	a0,27e <main+0x126>
  for(i = 0; i < NUM_READERS; i++){
 20a:	2a85                	addiw	s5,s5,1
 20c:	478d                	li	a5,3
 20e:	fefa99e3          	bne	s5,a5,200 <main+0xa8>

  /*
   * Create 2 writer processes.
   */
  for(i = 0; i < NUM_WRITERS; i++){
    pid = fork();
 212:	34c000ef          	jal	55e <fork>

    if(pid < 0){
 216:	06054c63          	bltz	a0,28e <main+0x136>
      printf("fork failed\n");
      exit(1);
    }

    if(pid == 0){
 21a:	c541                	beqz	a0,2a2 <main+0x14a>
    pid = fork();
 21c:	342000ef          	jal	55e <fork>
    if(pid < 0){
 220:	06054763          	bltz	a0,28e <main+0x136>
    if(pid == 0){
 224:	4a95                	li	s5,5
 226:	cd2d                	beqz	a0,2a0 <main+0x148>

  /*
   * Wait for all 5 children.
   */
  for(i = 0; i < NUM_READERS + NUM_WRITERS; i++)
    wait(0);
 228:	4501                	li	a0,0
 22a:	344000ef          	jal	56e <wait>
  for(i = 0; i < NUM_READERS + NUM_WRITERS; i++)
 22e:	3afd                	addiw	s5,s5,-1
 230:	fe0a9ce3          	bnez	s5,228 <main+0xd0>

  printf("Readers-Writers completed successfully.\n");
 234:	00001517          	auipc	a0,0x1
 238:	a6450513          	addi	a0,a0,-1436 # c98 <malloc+0x1fc>
 23c:	7a8000ef          	jal	9e4 <printf>
  printf("Final shared_data = %d\n", shared->shared_data);
 240:	408c                	lw	a1,0(s1)
 242:	00001517          	auipc	a0,0x1
 246:	a8650513          	addi	a0,a0,-1402 # cc8 <malloc+0x22c>
 24a:	79a000ef          	jal	9e4 <printf>

  sem_free(mutex);
 24e:	8552                	mv	a0,s4
 250:	35e000ef          	jal	5ae <sem_free>
  sem_free(resource);
 254:	854e                	mv	a0,s3
 256:	358000ef          	jal	5ae <sem_free>
  sem_free(queue);
 25a:	854a                	mv	a0,s2
 25c:	352000ef          	jal	5ae <sem_free>
sem_free(output_mutex);
 260:	855a                	mv	a0,s6
 262:	34c000ef          	jal	5ae <sem_free>
  exit(0);
 266:	4501                	li	a0,0
 268:	2fe000ef          	jal	566 <exit>
      printf("fork failed\n");
 26c:	00001517          	auipc	a0,0x1
 270:	a1c50513          	addi	a0,a0,-1508 # c88 <malloc+0x1ec>
 274:	770000ef          	jal	9e4 <printf>
      exit(1);
 278:	4505                	li	a0,1
 27a:	2ec000ef          	jal	566 <exit>
reader((struct shared_rw *)shared,
 27e:	87d6                	mv	a5,s5
 280:	875a                	mv	a4,s6
 282:	86ca                	mv	a3,s2
 284:	864e                	mv	a2,s3
 286:	85d2                	mv	a1,s4
 288:	8526                	mv	a0,s1
 28a:	d77ff0ef          	jal	0 <reader>
      printf("fork failed\n");
 28e:	00001517          	auipc	a0,0x1
 292:	9fa50513          	addi	a0,a0,-1542 # c88 <malloc+0x1ec>
 296:	74e000ef          	jal	9e4 <printf>
      exit(1);
 29a:	4505                	li	a0,1
 29c:	2ca000ef          	jal	566 <exit>
 2a0:	4505                	li	a0,1
writer((struct shared_rw *)shared,
 2a2:	872a                	mv	a4,a0
 2a4:	86da                	mv	a3,s6
 2a6:	864a                	mv	a2,s2
 2a8:	85ce                	mv	a1,s3
 2aa:	8526                	mv	a0,s1
 2ac:	e1dff0ef          	jal	c8 <writer>

00000000000002b0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 2b8:	ea1ff0ef          	jal	158 <main>
  exit(r);
 2bc:	2aa000ef          	jal	566 <exit>

00000000000002c0 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e406                	sd	ra,8(sp)
 2c4:	e022                	sd	s0,0(sp)
 2c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 2c8:	87aa                	mv	a5,a0
 2ca:	0585                	addi	a1,a1,1
 2cc:	0785                	addi	a5,a5,1
 2ce:	fff5c703          	lbu	a4,-1(a1)
 2d2:	fee78fa3          	sb	a4,-1(a5)
 2d6:	fb75                	bnez	a4,2ca <strcpy+0xa>
    ;
  return os;
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e406                	sd	ra,8(sp)
 2e4:	e022                	sd	s0,0(sp)
 2e6:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 2e8:	00054783          	lbu	a5,0(a0)
 2ec:	cb91                	beqz	a5,300 <strcmp+0x20>
 2ee:	0005c703          	lbu	a4,0(a1)
 2f2:	00f71763          	bne	a4,a5,300 <strcmp+0x20>
    p++, q++;
 2f6:	0505                	addi	a0,a0,1
 2f8:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 2fa:	00054783          	lbu	a5,0(a0)
 2fe:	fbe5                	bnez	a5,2ee <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 300:	0005c503          	lbu	a0,0(a1)
}
 304:	40a7853b          	subw	a0,a5,a0
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <strlen>:

uint
strlen(const char *s)
{
 310:	1141                	addi	sp,sp,-16
 312:	e406                	sd	ra,8(sp)
 314:	e022                	sd	s0,0(sp)
 316:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 318:	00054783          	lbu	a5,0(a0)
 31c:	cf91                	beqz	a5,338 <strlen+0x28>
 31e:	00150793          	addi	a5,a0,1
 322:	86be                	mv	a3,a5
 324:	0785                	addi	a5,a5,1
 326:	fff7c703          	lbu	a4,-1(a5)
 32a:	ff65                	bnez	a4,322 <strlen+0x12>
 32c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 330:	60a2                	ld	ra,8(sp)
 332:	6402                	ld	s0,0(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret
  for (n = 0; s[n]; n++)
 338:	4501                	li	a0,0
 33a:	bfdd                	j	330 <strlen+0x20>

000000000000033c <memset>:

void *
memset(void *dst, int c, uint n)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e406                	sd	ra,8(sp)
 340:	e022                	sd	s0,0(sp)
 342:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 344:	ca19                	beqz	a2,35a <memset+0x1e>
 346:	87aa                	mv	a5,a0
 348:	1602                	slli	a2,a2,0x20
 34a:	9201                	srli	a2,a2,0x20
 34c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 350:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 354:	0785                	addi	a5,a5,1
 356:	fee79de3          	bne	a5,a4,350 <memset+0x14>
  }
  return dst;
}
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret

0000000000000362 <strchr>:

char *
strchr(const char *s, char c)
{
 362:	1141                	addi	sp,sp,-16
 364:	e406                	sd	ra,8(sp)
 366:	e022                	sd	s0,0(sp)
 368:	0800                	addi	s0,sp,16
  for (; *s; s++)
 36a:	00054783          	lbu	a5,0(a0)
 36e:	cf81                	beqz	a5,386 <strchr+0x24>
    if (*s == c)
 370:	00f58763          	beq	a1,a5,37e <strchr+0x1c>
  for (; *s; s++)
 374:	0505                	addi	a0,a0,1
 376:	00054783          	lbu	a5,0(a0)
 37a:	fbfd                	bnez	a5,370 <strchr+0xe>
      return (char *)s;
  return 0;
 37c:	4501                	li	a0,0
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret
  return 0;
 386:	4501                	li	a0,0
 388:	bfdd                	j	37e <strchr+0x1c>

000000000000038a <gets>:

char *
gets(char *buf, int max)
{
 38a:	711d                	addi	sp,sp,-96
 38c:	ec86                	sd	ra,88(sp)
 38e:	e8a2                	sd	s0,80(sp)
 390:	e4a6                	sd	s1,72(sp)
 392:	e0ca                	sd	s2,64(sp)
 394:	fc4e                	sd	s3,56(sp)
 396:	f852                	sd	s4,48(sp)
 398:	f456                	sd	s5,40(sp)
 39a:	f05a                	sd	s6,32(sp)
 39c:	ec5e                	sd	s7,24(sp)
 39e:	e862                	sd	s8,16(sp)
 3a0:	1080                	addi	s0,sp,96
 3a2:	8baa                	mv	s7,a0
 3a4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 3a6:	892a                	mv	s2,a0
 3a8:	4481                	li	s1,0
    cc = read(0, &c, 1);
 3aa:	faf40b13          	addi	s6,s0,-81
 3ae:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 3b0:	8c26                	mv	s8,s1
 3b2:	0014899b          	addiw	s3,s1,1
 3b6:	84ce                	mv	s1,s3
 3b8:	0349d463          	bge	s3,s4,3e0 <gets+0x56>
    cc = read(0, &c, 1);
 3bc:	8656                	mv	a2,s5
 3be:	85da                	mv	a1,s6
 3c0:	4501                	li	a0,0
 3c2:	1c4000ef          	jal	586 <read>
    if (cc < 1)
 3c6:	00a05d63          	blez	a0,3e0 <gets+0x56>
      break;
    buf[i++] = c;
 3ca:	faf44783          	lbu	a5,-81(s0)
 3ce:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 3d2:	0905                	addi	s2,s2,1
 3d4:	ff678713          	addi	a4,a5,-10
 3d8:	c319                	beqz	a4,3de <gets+0x54>
 3da:	17cd                	addi	a5,a5,-13
 3dc:	fbf1                	bnez	a5,3b0 <gets+0x26>
    buf[i++] = c;
 3de:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 3e0:	9c5e                	add	s8,s8,s7
 3e2:	000c0023          	sb	zero,0(s8)
  return buf;
}
 3e6:	855e                	mv	a0,s7
 3e8:	60e6                	ld	ra,88(sp)
 3ea:	6446                	ld	s0,80(sp)
 3ec:	64a6                	ld	s1,72(sp)
 3ee:	6906                	ld	s2,64(sp)
 3f0:	79e2                	ld	s3,56(sp)
 3f2:	7a42                	ld	s4,48(sp)
 3f4:	7aa2                	ld	s5,40(sp)
 3f6:	7b02                	ld	s6,32(sp)
 3f8:	6be2                	ld	s7,24(sp)
 3fa:	6c42                	ld	s8,16(sp)
 3fc:	6125                	addi	sp,sp,96
 3fe:	8082                	ret

0000000000000400 <stat>:

int
stat(const char *n, struct stat *st)
{
 400:	1101                	addi	sp,sp,-32
 402:	ec06                	sd	ra,24(sp)
 404:	e822                	sd	s0,16(sp)
 406:	e04a                	sd	s2,0(sp)
 408:	1000                	addi	s0,sp,32
 40a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 40c:	4581                	li	a1,0
 40e:	1c0000ef          	jal	5ce <open>
  if (fd < 0)
 412:	02054263          	bltz	a0,436 <stat+0x36>
 416:	e426                	sd	s1,8(sp)
 418:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 41a:	85ca                	mv	a1,s2
 41c:	1ca000ef          	jal	5e6 <fstat>
 420:	892a                	mv	s2,a0
  close(fd);
 422:	8526                	mv	a0,s1
 424:	192000ef          	jal	5b6 <close>
  return r;
 428:	64a2                	ld	s1,8(sp)
}
 42a:	854a                	mv	a0,s2
 42c:	60e2                	ld	ra,24(sp)
 42e:	6442                	ld	s0,16(sp)
 430:	6902                	ld	s2,0(sp)
 432:	6105                	addi	sp,sp,32
 434:	8082                	ret
    return -1;
 436:	57fd                	li	a5,-1
 438:	893e                	mv	s2,a5
 43a:	bfc5                	j	42a <stat+0x2a>

000000000000043c <atoi>:

int
atoi(const char *s)
{
 43c:	1141                	addi	sp,sp,-16
 43e:	e406                	sd	ra,8(sp)
 440:	e022                	sd	s0,0(sp)
 442:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 444:	00054683          	lbu	a3,0(a0)
 448:	fd06879b          	addiw	a5,a3,-48
 44c:	0ff7f793          	zext.b	a5,a5
 450:	4625                	li	a2,9
 452:	02f66963          	bltu	a2,a5,484 <atoi+0x48>
 456:	872a                	mv	a4,a0
  n = 0;
 458:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 45a:	0705                	addi	a4,a4,1
 45c:	0025179b          	slliw	a5,a0,0x2
 460:	9fa9                	addw	a5,a5,a0
 462:	0017979b          	slliw	a5,a5,0x1
 466:	9fb5                	addw	a5,a5,a3
 468:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 46c:	00074683          	lbu	a3,0(a4)
 470:	fd06879b          	addiw	a5,a3,-48
 474:	0ff7f793          	zext.b	a5,a5
 478:	fef671e3          	bgeu	a2,a5,45a <atoi+0x1e>
  return n;
}
 47c:	60a2                	ld	ra,8(sp)
 47e:	6402                	ld	s0,0(sp)
 480:	0141                	addi	sp,sp,16
 482:	8082                	ret
  n = 0;
 484:	4501                	li	a0,0
 486:	bfdd                	j	47c <atoi+0x40>

0000000000000488 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 488:	1141                	addi	sp,sp,-16
 48a:	e406                	sd	ra,8(sp)
 48c:	e022                	sd	s0,0(sp)
 48e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 490:	02b57563          	bgeu	a0,a1,4ba <memmove+0x32>
    while (n-- > 0)
 494:	00c05f63          	blez	a2,4b2 <memmove+0x2a>
 498:	1602                	slli	a2,a2,0x20
 49a:	9201                	srli	a2,a2,0x20
 49c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4a0:	872a                	mv	a4,a0
      *dst++ = *src++;
 4a2:	0585                	addi	a1,a1,1
 4a4:	0705                	addi	a4,a4,1
 4a6:	fff5c683          	lbu	a3,-1(a1)
 4aa:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 4ae:	fee79ae3          	bne	a5,a4,4a2 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4b2:	60a2                	ld	ra,8(sp)
 4b4:	6402                	ld	s0,0(sp)
 4b6:	0141                	addi	sp,sp,16
 4b8:	8082                	ret
    while (n-- > 0)
 4ba:	fec05ce3          	blez	a2,4b2 <memmove+0x2a>
    dst += n;
 4be:	00c50733          	add	a4,a0,a2
    src += n;
 4c2:	95b2                	add	a1,a1,a2
 4c4:	fff6079b          	addiw	a5,a2,-1
 4c8:	1782                	slli	a5,a5,0x20
 4ca:	9381                	srli	a5,a5,0x20
 4cc:	fff7c793          	not	a5,a5
 4d0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4d2:	15fd                	addi	a1,a1,-1
 4d4:	177d                	addi	a4,a4,-1
 4d6:	0005c683          	lbu	a3,0(a1)
 4da:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 4de:	fef71ae3          	bne	a4,a5,4d2 <memmove+0x4a>
 4e2:	bfc1                	j	4b2 <memmove+0x2a>

00000000000004e4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4e4:	1141                	addi	sp,sp,-16
 4e6:	e406                	sd	ra,8(sp)
 4e8:	e022                	sd	s0,0(sp)
 4ea:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ec:	c61d                	beqz	a2,51a <memcmp+0x36>
 4ee:	1602                	slli	a2,a2,0x20
 4f0:	9201                	srli	a2,a2,0x20
 4f2:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4f6:	00054783          	lbu	a5,0(a0)
 4fa:	0005c703          	lbu	a4,0(a1)
 4fe:	00e79863          	bne	a5,a4,50e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 502:	0505                	addi	a0,a0,1
    p2++;
 504:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 506:	fed518e3          	bne	a0,a3,4f6 <memcmp+0x12>
  }
  return 0;
 50a:	4501                	li	a0,0
 50c:	a019                	j	512 <memcmp+0x2e>
      return *p1 - *p2;
 50e:	40e7853b          	subw	a0,a5,a4
}
 512:	60a2                	ld	ra,8(sp)
 514:	6402                	ld	s0,0(sp)
 516:	0141                	addi	sp,sp,16
 518:	8082                	ret
  return 0;
 51a:	4501                	li	a0,0
 51c:	bfdd                	j	512 <memcmp+0x2e>

000000000000051e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 51e:	1141                	addi	sp,sp,-16
 520:	e406                	sd	ra,8(sp)
 522:	e022                	sd	s0,0(sp)
 524:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 526:	f63ff0ef          	jal	488 <memmove>
}
 52a:	60a2                	ld	ra,8(sp)
 52c:	6402                	ld	s0,0(sp)
 52e:	0141                	addi	sp,sp,16
 530:	8082                	ret

0000000000000532 <sbrk>:

char *
sbrk(int n)
{
 532:	1141                	addi	sp,sp,-16
 534:	e406                	sd	ra,8(sp)
 536:	e022                	sd	s0,0(sp)
 538:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 53a:	4585                	li	a1,1
 53c:	0da000ef          	jal	616 <sys_sbrk>
}
 540:	60a2                	ld	ra,8(sp)
 542:	6402                	ld	s0,0(sp)
 544:	0141                	addi	sp,sp,16
 546:	8082                	ret

0000000000000548 <sbrklazy>:

char *
sbrklazy(int n)
{
 548:	1141                	addi	sp,sp,-16
 54a:	e406                	sd	ra,8(sp)
 54c:	e022                	sd	s0,0(sp)
 54e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 550:	4589                	li	a1,2
 552:	0c4000ef          	jal	616 <sys_sbrk>
}
 556:	60a2                	ld	ra,8(sp)
 558:	6402                	ld	s0,0(sp)
 55a:	0141                	addi	sp,sp,16
 55c:	8082                	ret

000000000000055e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 55e:	4885                	li	a7,1
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <exit>:
.global exit
exit:
 li a7, SYS_exit
 566:	4889                	li	a7,2
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <wait>:
.global wait
wait:
 li a7, SYS_wait
 56e:	488d                	li	a7,3
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 576:	48b5                	li	a7,13
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 57e:	4891                	li	a7,4
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <read>:
.global read
read:
 li a7, SYS_read
 586:	4895                	li	a7,5
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <write>:
.global write
write:
 li a7, SYS_write
 58e:	48c1                	li	a7,16
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <sem_create>:
.global sem_create
sem_create:
 li a7, SYS_sem_create
 596:	48e1                	li	a7,24
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <sem_wait>:
.global sem_wait
sem_wait:
 li a7, SYS_sem_wait
 59e:	48e5                	li	a7,25
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <sem_signal>:
.global sem_signal
sem_signal:
 li a7, SYS_sem_signal
 5a6:	48e9                	li	a7,26
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <sem_free>:
.global sem_free
sem_free:
 li a7, SYS_sem_free
 5ae:	48ed                	li	a7,27
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <close>:
.global close
close:
 li a7, SYS_close
 5b6:	48d5                	li	a7,21
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <kill>:
.global kill
kill:
 li a7, SYS_kill
 5be:	4899                	li	a7,6
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5c6:	489d                	li	a7,7
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <open>:
.global open
open:
 li a7, SYS_open
 5ce:	48bd                	li	a7,15
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5d6:	48c5                	li	a7,17
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5de:	48c9                	li	a7,18
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5e6:	48a1                	li	a7,8
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <link>:
.global link
link:
 li a7, SYS_link
 5ee:	48cd                	li	a7,19
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5f6:	48d1                	li	a7,20
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5fe:	48a5                	li	a7,9
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <dup>:
.global dup
dup:
 li a7, SYS_dup
 606:	48a9                	li	a7,10
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 60e:	48ad                	li	a7,11
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 616:	48b1                	li	a7,12
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <pause>:
.global pause
pause:
 li a7, SYS_pause
 61e:	48b5                	li	a7,13
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 626:	48b9                	li	a7,14
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <sync>:
.global sync
sync:
 li a7, SYS_sync
 62e:	48d9                	li	a7,22
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <shm_get>:
.global shm_get
shm_get:
 li a7, SYS_shm_get
 636:	48dd                	li	a7,23
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 63e:	1101                	addi	sp,sp,-32
 640:	ec06                	sd	ra,24(sp)
 642:	e822                	sd	s0,16(sp)
 644:	1000                	addi	s0,sp,32
 646:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 64a:	4605                	li	a2,1
 64c:	fef40593          	addi	a1,s0,-17
 650:	f3fff0ef          	jal	58e <write>
}
 654:	60e2                	ld	ra,24(sp)
 656:	6442                	ld	s0,16(sp)
 658:	6105                	addi	sp,sp,32
 65a:	8082                	ret

000000000000065c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 65c:	715d                	addi	sp,sp,-80
 65e:	e486                	sd	ra,72(sp)
 660:	e0a2                	sd	s0,64(sp)
 662:	f84a                	sd	s2,48(sp)
 664:	f44e                	sd	s3,40(sp)
 666:	0880                	addi	s0,sp,80
 668:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 66a:	c6d1                	beqz	a3,6f6 <printint+0x9a>
 66c:	0805d563          	bgez	a1,6f6 <printint+0x9a>
    neg = 1;
    x = -xx;
 670:	40b005b3          	neg	a1,a1
    neg = 1;
 674:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 676:	fb840993          	addi	s3,s0,-72
  neg = 0;
 67a:	86ce                	mv	a3,s3
  i = 0;
 67c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 67e:	00000817          	auipc	a6,0x0
 682:	66a80813          	addi	a6,a6,1642 # ce8 <digits>
 686:	88ba                	mv	a7,a4
 688:	0017051b          	addiw	a0,a4,1
 68c:	872a                	mv	a4,a0
 68e:	02c5f7b3          	remu	a5,a1,a2
 692:	97c2                	add	a5,a5,a6
 694:	0007c783          	lbu	a5,0(a5)
 698:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 69c:	87ae                	mv	a5,a1
 69e:	02c5d5b3          	divu	a1,a1,a2
 6a2:	0685                	addi	a3,a3,1
 6a4:	fec7f1e3          	bgeu	a5,a2,686 <printint+0x2a>
  if (neg)
 6a8:	00030c63          	beqz	t1,6c0 <printint+0x64>
    buf[i++] = '-';
 6ac:	fd050793          	addi	a5,a0,-48
 6b0:	00878533          	add	a0,a5,s0
 6b4:	02d00793          	li	a5,45
 6b8:	fef50423          	sb	a5,-24(a0)
 6bc:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 6c0:	02e05563          	blez	a4,6ea <printint+0x8e>
 6c4:	fc26                	sd	s1,56(sp)
 6c6:	377d                	addiw	a4,a4,-1
 6c8:	00e984b3          	add	s1,s3,a4
 6cc:	19fd                	addi	s3,s3,-1
 6ce:	99ba                	add	s3,s3,a4
 6d0:	1702                	slli	a4,a4,0x20
 6d2:	9301                	srli	a4,a4,0x20
 6d4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6d8:	0004c583          	lbu	a1,0(s1)
 6dc:	854a                	mv	a0,s2
 6de:	f61ff0ef          	jal	63e <putc>
  while (--i >= 0)
 6e2:	14fd                	addi	s1,s1,-1
 6e4:	ff349ae3          	bne	s1,s3,6d8 <printint+0x7c>
 6e8:	74e2                	ld	s1,56(sp)
}
 6ea:	60a6                	ld	ra,72(sp)
 6ec:	6406                	ld	s0,64(sp)
 6ee:	7942                	ld	s2,48(sp)
 6f0:	79a2                	ld	s3,40(sp)
 6f2:	6161                	addi	sp,sp,80
 6f4:	8082                	ret
  neg = 0;
 6f6:	4301                	li	t1,0
 6f8:	bfbd                	j	676 <printint+0x1a>

00000000000006fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6fa:	711d                	addi	sp,sp,-96
 6fc:	ec86                	sd	ra,88(sp)
 6fe:	e8a2                	sd	s0,80(sp)
 700:	e4a6                	sd	s1,72(sp)
 702:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 704:	0005c483          	lbu	s1,0(a1)
 708:	22048363          	beqz	s1,92e <vprintf+0x234>
 70c:	e0ca                	sd	s2,64(sp)
 70e:	fc4e                	sd	s3,56(sp)
 710:	f852                	sd	s4,48(sp)
 712:	f456                	sd	s5,40(sp)
 714:	f05a                	sd	s6,32(sp)
 716:	ec5e                	sd	s7,24(sp)
 718:	e862                	sd	s8,16(sp)
 71a:	8b2a                	mv	s6,a0
 71c:	8a2e                	mv	s4,a1
 71e:	8bb2                	mv	s7,a2
  state = 0;
 720:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 722:	4901                	li	s2,0
 724:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 726:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 72a:	06400c13          	li	s8,100
 72e:	a00d                	j	750 <vprintf+0x56>
        putc(fd, c0);
 730:	85a6                	mv	a1,s1
 732:	855a                	mv	a0,s6
 734:	f0bff0ef          	jal	63e <putc>
 738:	a019                	j	73e <vprintf+0x44>
    } else if (state == '%') {
 73a:	03598363          	beq	s3,s5,760 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 73e:	0019079b          	addiw	a5,s2,1
 742:	893e                	mv	s2,a5
 744:	873e                	mv	a4,a5
 746:	97d2                	add	a5,a5,s4
 748:	0007c483          	lbu	s1,0(a5)
 74c:	1c048a63          	beqz	s1,920 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 750:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 754:	fe0993e3          	bnez	s3,73a <vprintf+0x40>
      if (c0 == '%') {
 758:	fd579ce3          	bne	a5,s5,730 <vprintf+0x36>
        state = '%';
 75c:	89be                	mv	s3,a5
 75e:	b7c5                	j	73e <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 760:	00ea06b3          	add	a3,s4,a4
 764:	0016c603          	lbu	a2,1(a3)
      if (c1)
 768:	1c060863          	beqz	a2,938 <vprintf+0x23e>
      if (c0 == 'd') {
 76c:	03878763          	beq	a5,s8,79a <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 770:	f9478693          	addi	a3,a5,-108
 774:	0016b693          	seqz	a3,a3
 778:	f9c60593          	addi	a1,a2,-100
 77c:	e99d                	bnez	a1,7b2 <vprintf+0xb8>
 77e:	ca95                	beqz	a3,7b2 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 780:	008b8493          	addi	s1,s7,8
 784:	4685                	li	a3,1
 786:	4629                	li	a2,10
 788:	000bb583          	ld	a1,0(s7)
 78c:	855a                	mv	a0,s6
 78e:	ecfff0ef          	jal	65c <printint>
        i += 1;
 792:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 794:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 796:	4981                	li	s3,0
 798:	b75d                	j	73e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 79a:	008b8493          	addi	s1,s7,8
 79e:	4685                	li	a3,1
 7a0:	4629                	li	a2,10
 7a2:	000ba583          	lw	a1,0(s7)
 7a6:	855a                	mv	a0,s6
 7a8:	eb5ff0ef          	jal	65c <printint>
 7ac:	8ba6                	mv	s7,s1
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b779                	j	73e <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 7b2:	9752                	add	a4,a4,s4
 7b4:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7b8:	f9460713          	addi	a4,a2,-108
 7bc:	00173713          	seqz	a4,a4
 7c0:	8f75                	and	a4,a4,a3
 7c2:	f9c58513          	addi	a0,a1,-100
 7c6:	18051363          	bnez	a0,94c <vprintf+0x252>
 7ca:	18070163          	beqz	a4,94c <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ce:	008b8493          	addi	s1,s7,8
 7d2:	4685                	li	a3,1
 7d4:	4629                	li	a2,10
 7d6:	000bb583          	ld	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	e81ff0ef          	jal	65c <printint>
        i += 2;
 7e0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e2:	8ba6                	mv	s7,s1
      state = 0;
 7e4:	4981                	li	s3,0
        i += 2;
 7e6:	bfa1                	j	73e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7e8:	008b8493          	addi	s1,s7,8
 7ec:	4681                	li	a3,0
 7ee:	4629                	li	a2,10
 7f0:	000be583          	lwu	a1,0(s7)
 7f4:	855a                	mv	a0,s6
 7f6:	e67ff0ef          	jal	65c <printint>
 7fa:	8ba6                	mv	s7,s1
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	b781                	j	73e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 800:	008b8493          	addi	s1,s7,8
 804:	4681                	li	a3,0
 806:	4629                	li	a2,10
 808:	000bb583          	ld	a1,0(s7)
 80c:	855a                	mv	a0,s6
 80e:	e4fff0ef          	jal	65c <printint>
        i += 1;
 812:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 814:	8ba6                	mv	s7,s1
      state = 0;
 816:	4981                	li	s3,0
 818:	b71d                	j	73e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 81a:	008b8493          	addi	s1,s7,8
 81e:	4681                	li	a3,0
 820:	4629                	li	a2,10
 822:	000bb583          	ld	a1,0(s7)
 826:	855a                	mv	a0,s6
 828:	e35ff0ef          	jal	65c <printint>
        i += 2;
 82c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 82e:	8ba6                	mv	s7,s1
      state = 0;
 830:	4981                	li	s3,0
        i += 2;
 832:	b731                	j	73e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 834:	008b8493          	addi	s1,s7,8
 838:	4681                	li	a3,0
 83a:	4641                	li	a2,16
 83c:	000be583          	lwu	a1,0(s7)
 840:	855a                	mv	a0,s6
 842:	e1bff0ef          	jal	65c <printint>
 846:	8ba6                	mv	s7,s1
      state = 0;
 848:	4981                	li	s3,0
 84a:	bdd5                	j	73e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 84c:	008b8493          	addi	s1,s7,8
 850:	4681                	li	a3,0
 852:	4641                	li	a2,16
 854:	000bb583          	ld	a1,0(s7)
 858:	855a                	mv	a0,s6
 85a:	e03ff0ef          	jal	65c <printint>
        i += 1;
 85e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 860:	8ba6                	mv	s7,s1
      state = 0;
 862:	4981                	li	s3,0
 864:	bde9                	j	73e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 866:	008b8493          	addi	s1,s7,8
 86a:	4681                	li	a3,0
 86c:	4641                	li	a2,16
 86e:	000bb583          	ld	a1,0(s7)
 872:	855a                	mv	a0,s6
 874:	de9ff0ef          	jal	65c <printint>
        i += 2;
 878:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 87a:	8ba6                	mv	s7,s1
      state = 0;
 87c:	4981                	li	s3,0
        i += 2;
 87e:	b5c1                	j	73e <vprintf+0x44>
 880:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 882:	008b8793          	addi	a5,s7,8
 886:	8cbe                	mv	s9,a5
 888:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 88c:	03000593          	li	a1,48
 890:	855a                	mv	a0,s6
 892:	dadff0ef          	jal	63e <putc>
  putc(fd, 'x');
 896:	07800593          	li	a1,120
 89a:	855a                	mv	a0,s6
 89c:	da3ff0ef          	jal	63e <putc>
 8a0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8a2:	00000b97          	auipc	s7,0x0
 8a6:	446b8b93          	addi	s7,s7,1094 # ce8 <digits>
 8aa:	03c9d793          	srli	a5,s3,0x3c
 8ae:	97de                	add	a5,a5,s7
 8b0:	0007c583          	lbu	a1,0(a5)
 8b4:	855a                	mv	a0,s6
 8b6:	d89ff0ef          	jal	63e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8ba:	0992                	slli	s3,s3,0x4
 8bc:	34fd                	addiw	s1,s1,-1
 8be:	f4f5                	bnez	s1,8aa <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 8c0:	8be6                	mv	s7,s9
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	6ca2                	ld	s9,8(sp)
 8c6:	bda5                	j	73e <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 8c8:	008b8493          	addi	s1,s7,8
 8cc:	000bc583          	lbu	a1,0(s7)
 8d0:	855a                	mv	a0,s6
 8d2:	d6dff0ef          	jal	63e <putc>
 8d6:	8ba6                	mv	s7,s1
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	b595                	j	73e <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 8dc:	008b8993          	addi	s3,s7,8
 8e0:	000bb483          	ld	s1,0(s7)
 8e4:	cc91                	beqz	s1,900 <vprintf+0x206>
        for (; *s; s++)
 8e6:	0004c583          	lbu	a1,0(s1)
 8ea:	c985                	beqz	a1,91a <vprintf+0x220>
          putc(fd, *s);
 8ec:	855a                	mv	a0,s6
 8ee:	d51ff0ef          	jal	63e <putc>
        for (; *s; s++)
 8f2:	0485                	addi	s1,s1,1
 8f4:	0004c583          	lbu	a1,0(s1)
 8f8:	f9f5                	bnez	a1,8ec <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 8fa:	8bce                	mv	s7,s3
      state = 0;
 8fc:	4981                	li	s3,0
 8fe:	b581                	j	73e <vprintf+0x44>
          s = "(null)";
 900:	00000497          	auipc	s1,0x0
 904:	3e048493          	addi	s1,s1,992 # ce0 <malloc+0x244>
        for (; *s; s++)
 908:	02800593          	li	a1,40
 90c:	b7c5                	j	8ec <vprintf+0x1f2>
        putc(fd, '%');
 90e:	85be                	mv	a1,a5
 910:	855a                	mv	a0,s6
 912:	d2dff0ef          	jal	63e <putc>
      state = 0;
 916:	4981                	li	s3,0
 918:	b51d                	j	73e <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 91a:	8bce                	mv	s7,s3
      state = 0;
 91c:	4981                	li	s3,0
 91e:	b505                	j	73e <vprintf+0x44>
 920:	6906                	ld	s2,64(sp)
 922:	79e2                	ld	s3,56(sp)
 924:	7a42                	ld	s4,48(sp)
 926:	7aa2                	ld	s5,40(sp)
 928:	7b02                	ld	s6,32(sp)
 92a:	6be2                	ld	s7,24(sp)
 92c:	6c42                	ld	s8,16(sp)
    }
  }
}
 92e:	60e6                	ld	ra,88(sp)
 930:	6446                	ld	s0,80(sp)
 932:	64a6                	ld	s1,72(sp)
 934:	6125                	addi	sp,sp,96
 936:	8082                	ret
      if (c0 == 'd') {
 938:	06400713          	li	a4,100
 93c:	e4e78fe3          	beq	a5,a4,79a <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 940:	f9478693          	addi	a3,a5,-108
 944:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 948:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 94a:	4701                	li	a4,0
      } else if (c0 == 'u') {
 94c:	07500513          	li	a0,117
 950:	e8a78ce3          	beq	a5,a0,7e8 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 954:	f8b60513          	addi	a0,a2,-117
 958:	e119                	bnez	a0,95e <vprintf+0x264>
 95a:	ea0693e3          	bnez	a3,800 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 95e:	f8b58513          	addi	a0,a1,-117
 962:	e119                	bnez	a0,968 <vprintf+0x26e>
 964:	ea071be3          	bnez	a4,81a <vprintf+0x120>
      } else if (c0 == 'x') {
 968:	07800513          	li	a0,120
 96c:	eca784e3          	beq	a5,a0,834 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 970:	f8860613          	addi	a2,a2,-120
 974:	e219                	bnez	a2,97a <vprintf+0x280>
 976:	ec069be3          	bnez	a3,84c <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 97a:	f8858593          	addi	a1,a1,-120
 97e:	e199                	bnez	a1,984 <vprintf+0x28a>
 980:	ee0713e3          	bnez	a4,866 <vprintf+0x16c>
      } else if (c0 == 'p') {
 984:	07000713          	li	a4,112
 988:	eee78ce3          	beq	a5,a4,880 <vprintf+0x186>
      } else if (c0 == 'c') {
 98c:	06300713          	li	a4,99
 990:	f2e78ce3          	beq	a5,a4,8c8 <vprintf+0x1ce>
      } else if (c0 == 's') {
 994:	07300713          	li	a4,115
 998:	f4e782e3          	beq	a5,a4,8dc <vprintf+0x1e2>
      } else if (c0 == '%') {
 99c:	02500713          	li	a4,37
 9a0:	f6e787e3          	beq	a5,a4,90e <vprintf+0x214>
        putc(fd, '%');
 9a4:	02500593          	li	a1,37
 9a8:	855a                	mv	a0,s6
 9aa:	c95ff0ef          	jal	63e <putc>
        putc(fd, c0);
 9ae:	85a6                	mv	a1,s1
 9b0:	855a                	mv	a0,s6
 9b2:	c8dff0ef          	jal	63e <putc>
      state = 0;
 9b6:	4981                	li	s3,0
 9b8:	b359                	j	73e <vprintf+0x44>

00000000000009ba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9ba:	715d                	addi	sp,sp,-80
 9bc:	ec06                	sd	ra,24(sp)
 9be:	e822                	sd	s0,16(sp)
 9c0:	1000                	addi	s0,sp,32
 9c2:	e010                	sd	a2,0(s0)
 9c4:	e414                	sd	a3,8(s0)
 9c6:	e818                	sd	a4,16(s0)
 9c8:	ec1c                	sd	a5,24(s0)
 9ca:	03043023          	sd	a6,32(s0)
 9ce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9d2:	8622                	mv	a2,s0
 9d4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9d8:	d23ff0ef          	jal	6fa <vprintf>
}
 9dc:	60e2                	ld	ra,24(sp)
 9de:	6442                	ld	s0,16(sp)
 9e0:	6161                	addi	sp,sp,80
 9e2:	8082                	ret

00000000000009e4 <printf>:

void
printf(const char *fmt, ...)
{
 9e4:	711d                	addi	sp,sp,-96
 9e6:	ec06                	sd	ra,24(sp)
 9e8:	e822                	sd	s0,16(sp)
 9ea:	1000                	addi	s0,sp,32
 9ec:	e40c                	sd	a1,8(s0)
 9ee:	e810                	sd	a2,16(s0)
 9f0:	ec14                	sd	a3,24(s0)
 9f2:	f018                	sd	a4,32(s0)
 9f4:	f41c                	sd	a5,40(s0)
 9f6:	03043823          	sd	a6,48(s0)
 9fa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9fe:	00840613          	addi	a2,s0,8
 a02:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a06:	85aa                	mv	a1,a0
 a08:	4505                	li	a0,1
 a0a:	cf1ff0ef          	jal	6fa <vprintf>
}
 a0e:	60e2                	ld	ra,24(sp)
 a10:	6442                	ld	s0,16(sp)
 a12:	6125                	addi	sp,sp,96
 a14:	8082                	ret

0000000000000a16 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a16:	1141                	addi	sp,sp,-16
 a18:	e406                	sd	ra,8(sp)
 a1a:	e022                	sd	s0,0(sp)
 a1c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 a1e:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a22:	00001797          	auipc	a5,0x1
 a26:	5de7b783          	ld	a5,1502(a5) # 2000 <freep>
 a2a:	a039                	j	a38 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a2c:	6398                	ld	a4,0(a5)
 a2e:	00e7e463          	bltu	a5,a4,a36 <free+0x20>
 a32:	00e6ea63          	bltu	a3,a4,a46 <free+0x30>
{
 a36:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a38:	fed7fae3          	bgeu	a5,a3,a2c <free+0x16>
 a3c:	6398                	ld	a4,0(a5)
 a3e:	00e6e463          	bltu	a3,a4,a46 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a42:	fee7eae3          	bltu	a5,a4,a36 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 a46:	ff852583          	lw	a1,-8(a0)
 a4a:	6390                	ld	a2,0(a5)
 a4c:	02059813          	slli	a6,a1,0x20
 a50:	01c85713          	srli	a4,a6,0x1c
 a54:	9736                	add	a4,a4,a3
 a56:	02e60563          	beq	a2,a4,a80 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 a5a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 a5e:	4790                	lw	a2,8(a5)
 a60:	02061593          	slli	a1,a2,0x20
 a64:	01c5d713          	srli	a4,a1,0x1c
 a68:	973e                	add	a4,a4,a5
 a6a:	02e68263          	beq	a3,a4,a8e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a6e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a70:	00001717          	auipc	a4,0x1
 a74:	58f73823          	sd	a5,1424(a4) # 2000 <freep>
}
 a78:	60a2                	ld	ra,8(sp)
 a7a:	6402                	ld	s0,0(sp)
 a7c:	0141                	addi	sp,sp,16
 a7e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 a80:	4618                	lw	a4,8(a2)
 a82:	9f2d                	addw	a4,a4,a1
 a84:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a88:	6398                	ld	a4,0(a5)
 a8a:	6310                	ld	a2,0(a4)
 a8c:	b7f9                	j	a5a <free+0x44>
    p->s.size += bp->s.size;
 a8e:	ff852703          	lw	a4,-8(a0)
 a92:	9f31                	addw	a4,a4,a2
 a94:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a96:	ff053683          	ld	a3,-16(a0)
 a9a:	bfd1                	j	a6e <free+0x58>

0000000000000a9c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 a9c:	7139                	addi	sp,sp,-64
 a9e:	fc06                	sd	ra,56(sp)
 aa0:	f822                	sd	s0,48(sp)
 aa2:	f04a                	sd	s2,32(sp)
 aa4:	ec4e                	sd	s3,24(sp)
 aa6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 aa8:	02051993          	slli	s3,a0,0x20
 aac:	0209d993          	srli	s3,s3,0x20
 ab0:	09bd                	addi	s3,s3,15
 ab2:	0049d993          	srli	s3,s3,0x4
 ab6:	2985                	addiw	s3,s3,1
 ab8:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 aba:	00001517          	auipc	a0,0x1
 abe:	54653503          	ld	a0,1350(a0) # 2000 <freep>
 ac2:	c905                	beqz	a0,af2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 ac4:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 ac6:	4798                	lw	a4,8(a5)
 ac8:	09377663          	bgeu	a4,s3,b54 <malloc+0xb8>
 acc:	f426                	sd	s1,40(sp)
 ace:	e852                	sd	s4,16(sp)
 ad0:	e456                	sd	s5,8(sp)
 ad2:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 ad4:	8a4e                	mv	s4,s3
 ad6:	6705                	lui	a4,0x1
 ad8:	00e9f363          	bgeu	s3,a4,ade <malloc+0x42>
 adc:	6a05                	lui	s4,0x1
 ade:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ae2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 ae6:	00001497          	auipc	s1,0x1
 aea:	51a48493          	addi	s1,s1,1306 # 2000 <freep>
  if (p == SBRK_ERROR)
 aee:	5afd                	li	s5,-1
 af0:	a83d                	j	b2e <malloc+0x92>
 af2:	f426                	sd	s1,40(sp)
 af4:	e852                	sd	s4,16(sp)
 af6:	e456                	sd	s5,8(sp)
 af8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 afa:	00001797          	auipc	a5,0x1
 afe:	51678793          	addi	a5,a5,1302 # 2010 <base>
 b02:	00001717          	auipc	a4,0x1
 b06:	4ef73f23          	sd	a5,1278(a4) # 2000 <freep>
 b0a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b0c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 b10:	b7d1                	j	ad4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b12:	6398                	ld	a4,0(a5)
 b14:	e118                	sd	a4,0(a0)
 b16:	a899                	j	b6c <malloc+0xd0>
  hp->s.size = nu;
 b18:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 b1c:	0541                	addi	a0,a0,16
 b1e:	ef9ff0ef          	jal	a16 <free>
  return freep;
 b22:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 b24:	c125                	beqz	a0,b84 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 b26:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 b28:	4798                	lw	a4,8(a5)
 b2a:	03277163          	bgeu	a4,s2,b4c <malloc+0xb0>
    if (p == freep)
 b2e:	6098                	ld	a4,0(s1)
 b30:	853e                	mv	a0,a5
 b32:	fef71ae3          	bne	a4,a5,b26 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b36:	8552                	mv	a0,s4
 b38:	9fbff0ef          	jal	532 <sbrk>
  if (p == SBRK_ERROR)
 b3c:	fd551ee3          	bne	a0,s5,b18 <malloc+0x7c>
        return 0;
 b40:	4501                	li	a0,0
 b42:	74a2                	ld	s1,40(sp)
 b44:	6a42                	ld	s4,16(sp)
 b46:	6aa2                	ld	s5,8(sp)
 b48:	6b02                	ld	s6,0(sp)
 b4a:	a03d                	j	b78 <malloc+0xdc>
 b4c:	74a2                	ld	s1,40(sp)
 b4e:	6a42                	ld	s4,16(sp)
 b50:	6aa2                	ld	s5,8(sp)
 b52:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 b54:	fae90fe3          	beq	s2,a4,b12 <malloc+0x76>
        p->s.size -= nunits;
 b58:	4137073b          	subw	a4,a4,s3
 b5c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b5e:	02071693          	slli	a3,a4,0x20
 b62:	01c6d713          	srli	a4,a3,0x1c
 b66:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b68:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b6c:	00001717          	auipc	a4,0x1
 b70:	48a73a23          	sd	a0,1172(a4) # 2000 <freep>
      return (void *)(p + 1);
 b74:	01078513          	addi	a0,a5,16
  }
}
 b78:	70e2                	ld	ra,56(sp)
 b7a:	7442                	ld	s0,48(sp)
 b7c:	7902                	ld	s2,32(sp)
 b7e:	69e2                	ld	s3,24(sp)
 b80:	6121                	addi	sp,sp,64
 b82:	8082                	ret
 b84:	74a2                	ld	s1,40(sp)
 b86:	6a42                	ld	s4,16(sp)
 b88:	6aa2                	ld	s5,8(sp)
 b8a:	6b02                	ld	s6,0(sp)
 b8c:	b7f5                	j	b78 <malloc+0xdc>
