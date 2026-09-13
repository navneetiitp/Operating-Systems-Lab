
user/_prodcons:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
  int capacity;
};

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	e456                	sd	s5,8(sp)
   8:	0080                	addi	s0,sp,64
  int item;
  int expected;

  capacity = DEFAULT_CAPACITY;

  if(argc == 2){
   a:	4789                	li	a5,2
   c:	06f50d63          	beq	a0,a5,86 <main+0x86>
    if(capacity < 1 || capacity > MAX_BUFFER){
      printf("Buffer size must be between 1 and %d\n", MAX_BUFFER);
      exit(1);
    }
  }
  else if(argc > 2){
  10:	4789                	li	a5,2
  capacity = DEFAULT_CAPACITY;
  12:	4a95                	li	s5,5
  else if(argc > 2){
  14:	0aa7c163          	blt	a5,a0,b6 <main+0xb6>
  18:	f426                	sd	s1,40(sp)

  /*
   * Obtain one shared page before fork().
   * The child inherits the same physical shared page.
   */
  shared = (volatile struct shared_buffer *)shm_get();
  1a:	5fe000ef          	jal	618 <shm_get>
  1e:	84aa                	mv	s1,a0

  if(shared == (void *)-1){
  20:	57fd                	li	a5,-1
  22:	0af50863          	beq	a0,a5,d2 <main+0xd2>
  26:	f04a                	sd	s2,32(sp)
  28:	ec4e                	sd	s3,24(sp)
  2a:	e852                	sd	s4,16(sp)
    printf("shm_get failed\n");
    exit(1);
  }

  shared->in = 0;
  2c:	04052023          	sw	zero,64(a0)
  shared->out = 0;
  30:	04052223          	sw	zero,68(a0)
  shared->capacity = capacity;
  34:	05552423          	sw	s5,72(a0)

  for(i = 0; i < MAX_BUFFER; i++)
  38:	4781                	li	a5,0
  3a:	46c1                	li	a3,16
    shared->buffer[i] = 0;
  3c:	00279713          	slli	a4,a5,0x2
  40:	9726                	add	a4,a4,s1
  42:	00072023          	sw	zero,0(a4)
  for(i = 0; i < MAX_BUFFER; i++)
  46:	2785                	addiw	a5,a5,1
  48:	fed79ae3          	bne	a5,a3,3c <main+0x3c>
  /*
   * empty = number of free buffer slots
   * full  = number of occupied buffer slots
   * mutex = protects the circular buffer
   */
  empty = sem_create(capacity);
  4c:	8556                	mv	a0,s5
  4e:	52a000ef          	jal	578 <sem_create>
  52:	89aa                	mv	s3,a0
  full = sem_create(0);
  54:	4501                	li	a0,0
  56:	522000ef          	jal	578 <sem_create>
  5a:	8a2a                	mv	s4,a0
  mutex = sem_create(1);
  5c:	4505                	li	a0,1
  5e:	51a000ef          	jal	578 <sem_create>
  62:	892a                	mv	s2,a0

  if(empty < 0 || full < 0 || mutex < 0){
  64:	0149e7b3          	or	a5,s3,s4
  68:	8fc9                	or	a5,a5,a0
  6a:	02079713          	slli	a4,a5,0x20
  6e:	06075f63          	bgez	a4,ec <main+0xec>
  72:	e05a                	sd	s6,0(sp)
    printf("Semaphore creation failed\n");
  74:	00001517          	auipc	a0,0x1
  78:	b5c50513          	addi	a0,a0,-1188 # bd0 <malloc+0x152>
  7c:	14b000ef          	jal	9c6 <printf>
    exit(1);
  80:	4505                	li	a0,1
  82:	4c6000ef          	jal	548 <exit>
    capacity = atoi(argv[1]);
  86:	6588                	ld	a0,8(a1)
  88:	396000ef          	jal	41e <atoi>
  8c:	8aaa                	mv	s5,a0
    if(capacity < 1 || capacity > MAX_BUFFER){
  8e:	fff5071b          	addiw	a4,a0,-1
  92:	47bd                	li	a5,15
  94:	f8e7f2e3          	bgeu	a5,a4,18 <main+0x18>
  98:	f426                	sd	s1,40(sp)
  9a:	f04a                	sd	s2,32(sp)
  9c:	ec4e                	sd	s3,24(sp)
  9e:	e852                	sd	s4,16(sp)
  a0:	e05a                	sd	s6,0(sp)
      printf("Buffer size must be between 1 and %d\n", MAX_BUFFER);
  a2:	45c1                	li	a1,16
  a4:	00001517          	auipc	a0,0x1
  a8:	acc50513          	addi	a0,a0,-1332 # b70 <malloc+0xf2>
  ac:	11b000ef          	jal	9c6 <printf>
      exit(1);
  b0:	4505                	li	a0,1
  b2:	496000ef          	jal	548 <exit>
  b6:	f426                	sd	s1,40(sp)
  b8:	f04a                	sd	s2,32(sp)
  ba:	ec4e                	sd	s3,24(sp)
  bc:	e852                	sd	s4,16(sp)
  be:	e05a                	sd	s6,0(sp)
    printf("Usage: prodcons [buffer_size]\n");
  c0:	00001517          	auipc	a0,0x1
  c4:	ae050513          	addi	a0,a0,-1312 # ba0 <malloc+0x122>
  c8:	0ff000ef          	jal	9c6 <printf>
    exit(1);
  cc:	4505                	li	a0,1
  ce:	47a000ef          	jal	548 <exit>
  d2:	f04a                	sd	s2,32(sp)
  d4:	ec4e                	sd	s3,24(sp)
  d6:	e852                	sd	s4,16(sp)
  d8:	e05a                	sd	s6,0(sp)
    printf("shm_get failed\n");
  da:	00001517          	auipc	a0,0x1
  de:	ae650513          	addi	a0,a0,-1306 # bc0 <malloc+0x142>
  e2:	0e5000ef          	jal	9c6 <printf>
    exit(1);
  e6:	4505                	li	a0,1
  e8:	460000ef          	jal	548 <exit>
  ec:	e05a                	sd	s6,0(sp)
  }

  printf("Producer-Consumer started\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	b0250513          	addi	a0,a0,-1278 # bf0 <malloc+0x172>
  f6:	0d1000ef          	jal	9c6 <printf>
  printf("Buffer capacity = %d\n", capacity);
  fa:	85d6                	mv	a1,s5
  fc:	00001517          	auipc	a0,0x1
 100:	b1450513          	addi	a0,a0,-1260 # c10 <malloc+0x192>
 104:	0c3000ef          	jal	9c6 <printf>

  pid = fork();
 108:	438000ef          	jal	540 <fork>

  if(pid < 0){
 10c:	08054463          	bltz	a0,194 <main+0x194>

  /*
   * Parent = producer
   * Child  = consumer
   */
  if(pid != 0){
 110:	0a050d63          	beqz	a0,1ca <main+0x1ca>

    for(item = 1; item <= ITEMS; item++){
 114:	4a85                	li	s5,1

      /*
       * Producer waits if the buffer is full.
       */
      if(sem_wait(empty) < 0){
 116:	854e                	mv	a0,s3
 118:	468000ef          	jal	580 <sem_wait>
 11c:	08054563          	bltz	a0,1a6 <main+0x1a6>
        printf("Producer: sem_wait(empty) failed\n");
        exit(1);
      }

      if(sem_wait(mutex) < 0){
 120:	854a                	mv	a0,s2
 122:	45e000ef          	jal	580 <sem_wait>
 126:	08054963          	bltz	a0,1b8 <main+0x1b8>
        printf("Producer: sem_wait(mutex) failed\n");
        exit(1);
      }

      shared->buffer[shared->in] = item;
 12a:	40bc                	lw	a5,64(s1)
 12c:	078a                	slli	a5,a5,0x2
 12e:	97a6                	add	a5,a5,s1
 130:	0157a023          	sw	s5,0(a5)

      printf("Producer: inserted %d at slot %d\n",
             item, shared->in);
 134:	40b0                	lw	a2,64(s1)
      printf("Producer: inserted %d at slot %d\n",
 136:	85d6                	mv	a1,s5
 138:	00001517          	auipc	a0,0x1
 13c:	b5050513          	addi	a0,a0,-1200 # c88 <malloc+0x20a>
 140:	087000ef          	jal	9c6 <printf>

      shared->in = (shared->in + 1) % shared->capacity;
 144:	40bc                	lw	a5,64(s1)
 146:	44b8                	lw	a4,72(s1)
 148:	2785                	addiw	a5,a5,1
 14a:	02e7e7bb          	remw	a5,a5,a4
 14e:	c0bc                	sw	a5,64(s1)

      sem_signal(mutex);
 150:	854a                	mv	a0,s2
 152:	436000ef          	jal	588 <sem_signal>
      sem_signal(full);
 156:	8552                	mv	a0,s4
 158:	430000ef          	jal	588 <sem_signal>

      /*
       * Brief producer delay.
       */
      sleep(1);
 15c:	4505                	li	a0,1
 15e:	3fa000ef          	jal	558 <sleep>
    for(item = 1; item <= ITEMS; item++){
 162:	2a85                	addiw	s5,s5,1
 164:	47d5                	li	a5,21
 166:	fafa98e3          	bne	s5,a5,116 <main+0x116>
    }

    wait(0);
 16a:	4501                	li	a0,0
 16c:	3e4000ef          	jal	550 <wait>

    sem_free(empty);
 170:	854e                	mv	a0,s3
 172:	41e000ef          	jal	590 <sem_free>
    sem_free(full);
 176:	8552                	mv	a0,s4
 178:	418000ef          	jal	590 <sem_free>
    sem_free(mutex);
 17c:	854a                	mv	a0,s2
 17e:	412000ef          	jal	590 <sem_free>

    printf("Producer-Consumer test completed successfully.\n");
 182:	00001517          	auipc	a0,0x1
 186:	b2e50513          	addi	a0,a0,-1234 # cb0 <malloc+0x232>
 18a:	03d000ef          	jal	9c6 <printf>
    printf("Consumer: all %d items consumed in order.\n", ITEMS);

    exit(0);
  }

  exit(0);
 18e:	4501                	li	a0,0
 190:	3b8000ef          	jal	548 <exit>
    printf("fork failed\n");
 194:	00001517          	auipc	a0,0x1
 198:	a9450513          	addi	a0,a0,-1388 # c28 <malloc+0x1aa>
 19c:	02b000ef          	jal	9c6 <printf>
    exit(1);
 1a0:	4505                	li	a0,1
 1a2:	3a6000ef          	jal	548 <exit>
        printf("Producer: sem_wait(empty) failed\n");
 1a6:	00001517          	auipc	a0,0x1
 1aa:	a9250513          	addi	a0,a0,-1390 # c38 <malloc+0x1ba>
 1ae:	019000ef          	jal	9c6 <printf>
        exit(1);
 1b2:	4505                	li	a0,1
 1b4:	394000ef          	jal	548 <exit>
        printf("Producer: sem_wait(mutex) failed\n");
 1b8:	00001517          	auipc	a0,0x1
 1bc:	aa850513          	addi	a0,a0,-1368 # c60 <malloc+0x1e2>
 1c0:	007000ef          	jal	9c6 <printf>
        exit(1);
 1c4:	4505                	li	a0,1
 1c6:	382000ef          	jal	548 <exit>
    sleep(3);
 1ca:	450d                	li	a0,3
 1cc:	38c000ef          	jal	558 <sleep>
    expected = 1;
 1d0:	4a85                	li	s5,1
      if(sem_wait(full) < 0){
 1d2:	8552                	mv	a0,s4
 1d4:	3ac000ef          	jal	580 <sem_wait>
 1d8:	06054a63          	bltz	a0,24c <main+0x24c>
      if(sem_wait(mutex) < 0){
 1dc:	854a                	mv	a0,s2
 1de:	3a2000ef          	jal	580 <sem_wait>
 1e2:	06054e63          	bltz	a0,25e <main+0x25e>
      item = shared->buffer[shared->out];
 1e6:	40fc                	lw	a5,68(s1)
 1e8:	078a                	slli	a5,a5,0x2
 1ea:	97a6                	add	a5,a5,s1
 1ec:	439c                	lw	a5,0(a5)
 1ee:	2781                	sext.w	a5,a5
 1f0:	8b3e                	mv	s6,a5
             item, shared->out);
 1f2:	40f0                	lw	a2,68(s1)
      printf("Consumer: removed %d from slot %d\n",
 1f4:	85be                	mv	a1,a5
 1f6:	00001517          	auipc	a0,0x1
 1fa:	b3a50513          	addi	a0,a0,-1222 # d30 <malloc+0x2b2>
 1fe:	7c8000ef          	jal	9c6 <printf>
      if(item != expected){
 202:	075b1763          	bne	s6,s5,270 <main+0x270>
      expected++;
 206:	2a85                	addiw	s5,s5,1
      shared->out = (shared->out + 1) % shared->capacity;
 208:	40fc                	lw	a5,68(s1)
 20a:	44b8                	lw	a4,72(s1)
 20c:	2785                	addiw	a5,a5,1
 20e:	02e7e7bb          	remw	a5,a5,a4
 212:	c0fc                	sw	a5,68(s1)
      sem_signal(mutex);
 214:	854a                	mv	a0,s2
 216:	372000ef          	jal	588 <sem_signal>
      sem_signal(empty);
 21a:	854e                	mv	a0,s3
 21c:	36c000ef          	jal	588 <sem_signal>
      sleep(2);
 220:	4509                	li	a0,2
 222:	336000ef          	jal	558 <sleep>
    for(i = 0; i < ITEMS; i++){
 226:	47d5                	li	a5,21
 228:	fafa95e3          	bne	s5,a5,1d2 <main+0x1d2>
    printf("Consumer: verification successful\n");
 22c:	00001517          	auipc	a0,0x1
 230:	b5450513          	addi	a0,a0,-1196 # d80 <malloc+0x302>
 234:	792000ef          	jal	9c6 <printf>
    printf("Consumer: all %d items consumed in order.\n", ITEMS);
 238:	45d1                	li	a1,20
 23a:	00001517          	auipc	a0,0x1
 23e:	b6e50513          	addi	a0,a0,-1170 # da8 <malloc+0x32a>
 242:	784000ef          	jal	9c6 <printf>
    exit(0);
 246:	4501                	li	a0,0
 248:	300000ef          	jal	548 <exit>
        printf("Consumer: sem_wait(full) failed\n");
 24c:	00001517          	auipc	a0,0x1
 250:	a9450513          	addi	a0,a0,-1388 # ce0 <malloc+0x262>
 254:	772000ef          	jal	9c6 <printf>
        exit(1);
 258:	4505                	li	a0,1
 25a:	2ee000ef          	jal	548 <exit>
        printf("Consumer: sem_wait(mutex) failed\n");
 25e:	00001517          	auipc	a0,0x1
 262:	aaa50513          	addi	a0,a0,-1366 # d08 <malloc+0x28a>
 266:	760000ef          	jal	9c6 <printf>
        exit(1);
 26a:	4505                	li	a0,1
 26c:	2dc000ef          	jal	548 <exit>
        printf("ERROR: expected %d but received %d\n",
 270:	865a                	mv	a2,s6
 272:	85d6                	mv	a1,s5
 274:	00001517          	auipc	a0,0x1
 278:	ae450513          	addi	a0,a0,-1308 # d58 <malloc+0x2da>
 27c:	74a000ef          	jal	9c6 <printf>
        sem_signal(mutex);
 280:	854a                	mv	a0,s2
 282:	306000ef          	jal	588 <sem_signal>
        sem_signal(empty);
 286:	854e                	mv	a0,s3
 288:	300000ef          	jal	588 <sem_signal>
        exit(1);
 28c:	4505                	li	a0,1
 28e:	2ba000ef          	jal	548 <exit>

0000000000000292 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 29a:	d67ff0ef          	jal	0 <main>
  exit(r);
 29e:	2aa000ef          	jal	548 <exit>

00000000000002a2 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 2aa:	87aa                	mv	a5,a0
 2ac:	0585                	addi	a1,a1,1
 2ae:	0785                	addi	a5,a5,1
 2b0:	fff5c703          	lbu	a4,-1(a1)
 2b4:	fee78fa3          	sb	a4,-1(a5)
 2b8:	fb75                	bnez	a4,2ac <strcpy+0xa>
    ;
  return os;
}
 2ba:	60a2                	ld	ra,8(sp)
 2bc:	6402                	ld	s0,0(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	cb91                	beqz	a5,2e2 <strcmp+0x20>
 2d0:	0005c703          	lbu	a4,0(a1)
 2d4:	00f71763          	bne	a4,a5,2e2 <strcmp+0x20>
    p++, q++;
 2d8:	0505                	addi	a0,a0,1
 2da:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 2dc:	00054783          	lbu	a5,0(a0)
 2e0:	fbe5                	bnez	a5,2d0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2e2:	0005c503          	lbu	a0,0(a1)
}
 2e6:	40a7853b          	subw	a0,a5,a0
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <strlen>:

uint
strlen(const char *s)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 2fa:	00054783          	lbu	a5,0(a0)
 2fe:	cf91                	beqz	a5,31a <strlen+0x28>
 300:	00150793          	addi	a5,a0,1
 304:	86be                	mv	a3,a5
 306:	0785                	addi	a5,a5,1
 308:	fff7c703          	lbu	a4,-1(a5)
 30c:	ff65                	bnez	a4,304 <strlen+0x12>
 30e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret
  for (n = 0; s[n]; n++)
 31a:	4501                	li	a0,0
 31c:	bfdd                	j	312 <strlen+0x20>

000000000000031e <memset>:

void *
memset(void *dst, int c, uint n)
{
 31e:	1141                	addi	sp,sp,-16
 320:	e406                	sd	ra,8(sp)
 322:	e022                	sd	s0,0(sp)
 324:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 326:	ca19                	beqz	a2,33c <memset+0x1e>
 328:	87aa                	mv	a5,a0
 32a:	1602                	slli	a2,a2,0x20
 32c:	9201                	srli	a2,a2,0x20
 32e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 332:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 336:	0785                	addi	a5,a5,1
 338:	fee79de3          	bne	a5,a4,332 <memset+0x14>
  }
  return dst;
}
 33c:	60a2                	ld	ra,8(sp)
 33e:	6402                	ld	s0,0(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret

0000000000000344 <strchr>:

char *
strchr(const char *s, char c)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  for (; *s; s++)
 34c:	00054783          	lbu	a5,0(a0)
 350:	cf81                	beqz	a5,368 <strchr+0x24>
    if (*s == c)
 352:	00f58763          	beq	a1,a5,360 <strchr+0x1c>
  for (; *s; s++)
 356:	0505                	addi	a0,a0,1
 358:	00054783          	lbu	a5,0(a0)
 35c:	fbfd                	bnez	a5,352 <strchr+0xe>
      return (char *)s;
  return 0;
 35e:	4501                	li	a0,0
}
 360:	60a2                	ld	ra,8(sp)
 362:	6402                	ld	s0,0(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret
  return 0;
 368:	4501                	li	a0,0
 36a:	bfdd                	j	360 <strchr+0x1c>

000000000000036c <gets>:

char *
gets(char *buf, int max)
{
 36c:	711d                	addi	sp,sp,-96
 36e:	ec86                	sd	ra,88(sp)
 370:	e8a2                	sd	s0,80(sp)
 372:	e4a6                	sd	s1,72(sp)
 374:	e0ca                	sd	s2,64(sp)
 376:	fc4e                	sd	s3,56(sp)
 378:	f852                	sd	s4,48(sp)
 37a:	f456                	sd	s5,40(sp)
 37c:	f05a                	sd	s6,32(sp)
 37e:	ec5e                	sd	s7,24(sp)
 380:	e862                	sd	s8,16(sp)
 382:	1080                	addi	s0,sp,96
 384:	8baa                	mv	s7,a0
 386:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 388:	892a                	mv	s2,a0
 38a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 38c:	faf40b13          	addi	s6,s0,-81
 390:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 392:	8c26                	mv	s8,s1
 394:	0014899b          	addiw	s3,s1,1
 398:	84ce                	mv	s1,s3
 39a:	0349d463          	bge	s3,s4,3c2 <gets+0x56>
    cc = read(0, &c, 1);
 39e:	8656                	mv	a2,s5
 3a0:	85da                	mv	a1,s6
 3a2:	4501                	li	a0,0
 3a4:	1c4000ef          	jal	568 <read>
    if (cc < 1)
 3a8:	00a05d63          	blez	a0,3c2 <gets+0x56>
      break;
    buf[i++] = c;
 3ac:	faf44783          	lbu	a5,-81(s0)
 3b0:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 3b4:	0905                	addi	s2,s2,1
 3b6:	ff678713          	addi	a4,a5,-10
 3ba:	c319                	beqz	a4,3c0 <gets+0x54>
 3bc:	17cd                	addi	a5,a5,-13
 3be:	fbf1                	bnez	a5,392 <gets+0x26>
    buf[i++] = c;
 3c0:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 3c2:	9c5e                	add	s8,s8,s7
 3c4:	000c0023          	sb	zero,0(s8)
  return buf;
}
 3c8:	855e                	mv	a0,s7
 3ca:	60e6                	ld	ra,88(sp)
 3cc:	6446                	ld	s0,80(sp)
 3ce:	64a6                	ld	s1,72(sp)
 3d0:	6906                	ld	s2,64(sp)
 3d2:	79e2                	ld	s3,56(sp)
 3d4:	7a42                	ld	s4,48(sp)
 3d6:	7aa2                	ld	s5,40(sp)
 3d8:	7b02                	ld	s6,32(sp)
 3da:	6be2                	ld	s7,24(sp)
 3dc:	6c42                	ld	s8,16(sp)
 3de:	6125                	addi	sp,sp,96
 3e0:	8082                	ret

00000000000003e2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e2:	1101                	addi	sp,sp,-32
 3e4:	ec06                	sd	ra,24(sp)
 3e6:	e822                	sd	s0,16(sp)
 3e8:	e04a                	sd	s2,0(sp)
 3ea:	1000                	addi	s0,sp,32
 3ec:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ee:	4581                	li	a1,0
 3f0:	1c0000ef          	jal	5b0 <open>
  if (fd < 0)
 3f4:	02054263          	bltz	a0,418 <stat+0x36>
 3f8:	e426                	sd	s1,8(sp)
 3fa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3fc:	85ca                	mv	a1,s2
 3fe:	1ca000ef          	jal	5c8 <fstat>
 402:	892a                	mv	s2,a0
  close(fd);
 404:	8526                	mv	a0,s1
 406:	192000ef          	jal	598 <close>
  return r;
 40a:	64a2                	ld	s1,8(sp)
}
 40c:	854a                	mv	a0,s2
 40e:	60e2                	ld	ra,24(sp)
 410:	6442                	ld	s0,16(sp)
 412:	6902                	ld	s2,0(sp)
 414:	6105                	addi	sp,sp,32
 416:	8082                	ret
    return -1;
 418:	57fd                	li	a5,-1
 41a:	893e                	mv	s2,a5
 41c:	bfc5                	j	40c <stat+0x2a>

000000000000041e <atoi>:

int
atoi(const char *s)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e406                	sd	ra,8(sp)
 422:	e022                	sd	s0,0(sp)
 424:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 426:	00054683          	lbu	a3,0(a0)
 42a:	fd06879b          	addiw	a5,a3,-48
 42e:	0ff7f793          	zext.b	a5,a5
 432:	4625                	li	a2,9
 434:	02f66963          	bltu	a2,a5,466 <atoi+0x48>
 438:	872a                	mv	a4,a0
  n = 0;
 43a:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 43c:	0705                	addi	a4,a4,1
 43e:	0025179b          	slliw	a5,a0,0x2
 442:	9fa9                	addw	a5,a5,a0
 444:	0017979b          	slliw	a5,a5,0x1
 448:	9fb5                	addw	a5,a5,a3
 44a:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 44e:	00074683          	lbu	a3,0(a4)
 452:	fd06879b          	addiw	a5,a3,-48
 456:	0ff7f793          	zext.b	a5,a5
 45a:	fef671e3          	bgeu	a2,a5,43c <atoi+0x1e>
  return n;
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret
  n = 0;
 466:	4501                	li	a0,0
 468:	bfdd                	j	45e <atoi+0x40>

000000000000046a <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e406                	sd	ra,8(sp)
 46e:	e022                	sd	s0,0(sp)
 470:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 472:	02b57563          	bgeu	a0,a1,49c <memmove+0x32>
    while (n-- > 0)
 476:	00c05f63          	blez	a2,494 <memmove+0x2a>
 47a:	1602                	slli	a2,a2,0x20
 47c:	9201                	srli	a2,a2,0x20
 47e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 482:	872a                	mv	a4,a0
      *dst++ = *src++;
 484:	0585                	addi	a1,a1,1
 486:	0705                	addi	a4,a4,1
 488:	fff5c683          	lbu	a3,-1(a1)
 48c:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 490:	fee79ae3          	bne	a5,a4,484 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 494:	60a2                	ld	ra,8(sp)
 496:	6402                	ld	s0,0(sp)
 498:	0141                	addi	sp,sp,16
 49a:	8082                	ret
    while (n-- > 0)
 49c:	fec05ce3          	blez	a2,494 <memmove+0x2a>
    dst += n;
 4a0:	00c50733          	add	a4,a0,a2
    src += n;
 4a4:	95b2                	add	a1,a1,a2
 4a6:	fff6079b          	addiw	a5,a2,-1
 4aa:	1782                	slli	a5,a5,0x20
 4ac:	9381                	srli	a5,a5,0x20
 4ae:	fff7c793          	not	a5,a5
 4b2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4b4:	15fd                	addi	a1,a1,-1
 4b6:	177d                	addi	a4,a4,-1
 4b8:	0005c683          	lbu	a3,0(a1)
 4bc:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 4c0:	fef71ae3          	bne	a4,a5,4b4 <memmove+0x4a>
 4c4:	bfc1                	j	494 <memmove+0x2a>

00000000000004c6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4c6:	1141                	addi	sp,sp,-16
 4c8:	e406                	sd	ra,8(sp)
 4ca:	e022                	sd	s0,0(sp)
 4cc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ce:	c61d                	beqz	a2,4fc <memcmp+0x36>
 4d0:	1602                	slli	a2,a2,0x20
 4d2:	9201                	srli	a2,a2,0x20
 4d4:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4d8:	00054783          	lbu	a5,0(a0)
 4dc:	0005c703          	lbu	a4,0(a1)
 4e0:	00e79863          	bne	a5,a4,4f0 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 4e4:	0505                	addi	a0,a0,1
    p2++;
 4e6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4e8:	fed518e3          	bne	a0,a3,4d8 <memcmp+0x12>
  }
  return 0;
 4ec:	4501                	li	a0,0
 4ee:	a019                	j	4f4 <memcmp+0x2e>
      return *p1 - *p2;
 4f0:	40e7853b          	subw	a0,a5,a4
}
 4f4:	60a2                	ld	ra,8(sp)
 4f6:	6402                	ld	s0,0(sp)
 4f8:	0141                	addi	sp,sp,16
 4fa:	8082                	ret
  return 0;
 4fc:	4501                	li	a0,0
 4fe:	bfdd                	j	4f4 <memcmp+0x2e>

0000000000000500 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 500:	1141                	addi	sp,sp,-16
 502:	e406                	sd	ra,8(sp)
 504:	e022                	sd	s0,0(sp)
 506:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 508:	f63ff0ef          	jal	46a <memmove>
}
 50c:	60a2                	ld	ra,8(sp)
 50e:	6402                	ld	s0,0(sp)
 510:	0141                	addi	sp,sp,16
 512:	8082                	ret

0000000000000514 <sbrk>:

char *
sbrk(int n)
{
 514:	1141                	addi	sp,sp,-16
 516:	e406                	sd	ra,8(sp)
 518:	e022                	sd	s0,0(sp)
 51a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 51c:	4585                	li	a1,1
 51e:	0da000ef          	jal	5f8 <sys_sbrk>
}
 522:	60a2                	ld	ra,8(sp)
 524:	6402                	ld	s0,0(sp)
 526:	0141                	addi	sp,sp,16
 528:	8082                	ret

000000000000052a <sbrklazy>:

char *
sbrklazy(int n)
{
 52a:	1141                	addi	sp,sp,-16
 52c:	e406                	sd	ra,8(sp)
 52e:	e022                	sd	s0,0(sp)
 530:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 532:	4589                	li	a1,2
 534:	0c4000ef          	jal	5f8 <sys_sbrk>
}
 538:	60a2                	ld	ra,8(sp)
 53a:	6402                	ld	s0,0(sp)
 53c:	0141                	addi	sp,sp,16
 53e:	8082                	ret

0000000000000540 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 540:	4885                	li	a7,1
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <exit>:
.global exit
exit:
 li a7, SYS_exit
 548:	4889                	li	a7,2
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <wait>:
.global wait
wait:
 li a7, SYS_wait
 550:	488d                	li	a7,3
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 558:	48b5                	li	a7,13
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 560:	4891                	li	a7,4
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <read>:
.global read
read:
 li a7, SYS_read
 568:	4895                	li	a7,5
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <write>:
.global write
write:
 li a7, SYS_write
 570:	48c1                	li	a7,16
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <sem_create>:
.global sem_create
sem_create:
 li a7, SYS_sem_create
 578:	48e1                	li	a7,24
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <sem_wait>:
.global sem_wait
sem_wait:
 li a7, SYS_sem_wait
 580:	48e5                	li	a7,25
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <sem_signal>:
.global sem_signal
sem_signal:
 li a7, SYS_sem_signal
 588:	48e9                	li	a7,26
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <sem_free>:
.global sem_free
sem_free:
 li a7, SYS_sem_free
 590:	48ed                	li	a7,27
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <close>:
.global close
close:
 li a7, SYS_close
 598:	48d5                	li	a7,21
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5a0:	4899                	li	a7,6
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5a8:	489d                	li	a7,7
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <open>:
.global open
open:
 li a7, SYS_open
 5b0:	48bd                	li	a7,15
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5b8:	48c5                	li	a7,17
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5c0:	48c9                	li	a7,18
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5c8:	48a1                	li	a7,8
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <link>:
.global link
link:
 li a7, SYS_link
 5d0:	48cd                	li	a7,19
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5d8:	48d1                	li	a7,20
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5e0:	48a5                	li	a7,9
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e8:	48a9                	li	a7,10
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f0:	48ad                	li	a7,11
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5f8:	48b1                	li	a7,12
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <pause>:
.global pause
pause:
 li a7, SYS_pause
 600:	48b5                	li	a7,13
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 608:	48b9                	li	a7,14
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <sync>:
.global sync
sync:
 li a7, SYS_sync
 610:	48d9                	li	a7,22
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <shm_get>:
.global shm_get
shm_get:
 li a7, SYS_shm_get
 618:	48dd                	li	a7,23
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 620:	1101                	addi	sp,sp,-32
 622:	ec06                	sd	ra,24(sp)
 624:	e822                	sd	s0,16(sp)
 626:	1000                	addi	s0,sp,32
 628:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 62c:	4605                	li	a2,1
 62e:	fef40593          	addi	a1,s0,-17
 632:	f3fff0ef          	jal	570 <write>
}
 636:	60e2                	ld	ra,24(sp)
 638:	6442                	ld	s0,16(sp)
 63a:	6105                	addi	sp,sp,32
 63c:	8082                	ret

000000000000063e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 63e:	715d                	addi	sp,sp,-80
 640:	e486                	sd	ra,72(sp)
 642:	e0a2                	sd	s0,64(sp)
 644:	f84a                	sd	s2,48(sp)
 646:	f44e                	sd	s3,40(sp)
 648:	0880                	addi	s0,sp,80
 64a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 64c:	c6d1                	beqz	a3,6d8 <printint+0x9a>
 64e:	0805d563          	bgez	a1,6d8 <printint+0x9a>
    neg = 1;
    x = -xx;
 652:	40b005b3          	neg	a1,a1
    neg = 1;
 656:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 658:	fb840993          	addi	s3,s0,-72
  neg = 0;
 65c:	86ce                	mv	a3,s3
  i = 0;
 65e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 660:	00000817          	auipc	a6,0x0
 664:	78080813          	addi	a6,a6,1920 # de0 <digits>
 668:	88ba                	mv	a7,a4
 66a:	0017051b          	addiw	a0,a4,1
 66e:	872a                	mv	a4,a0
 670:	02c5f7b3          	remu	a5,a1,a2
 674:	97c2                	add	a5,a5,a6
 676:	0007c783          	lbu	a5,0(a5)
 67a:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 67e:	87ae                	mv	a5,a1
 680:	02c5d5b3          	divu	a1,a1,a2
 684:	0685                	addi	a3,a3,1
 686:	fec7f1e3          	bgeu	a5,a2,668 <printint+0x2a>
  if (neg)
 68a:	00030c63          	beqz	t1,6a2 <printint+0x64>
    buf[i++] = '-';
 68e:	fd050793          	addi	a5,a0,-48
 692:	00878533          	add	a0,a5,s0
 696:	02d00793          	li	a5,45
 69a:	fef50423          	sb	a5,-24(a0)
 69e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 6a2:	02e05563          	blez	a4,6cc <printint+0x8e>
 6a6:	fc26                	sd	s1,56(sp)
 6a8:	377d                	addiw	a4,a4,-1
 6aa:	00e984b3          	add	s1,s3,a4
 6ae:	19fd                	addi	s3,s3,-1
 6b0:	99ba                	add	s3,s3,a4
 6b2:	1702                	slli	a4,a4,0x20
 6b4:	9301                	srli	a4,a4,0x20
 6b6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ba:	0004c583          	lbu	a1,0(s1)
 6be:	854a                	mv	a0,s2
 6c0:	f61ff0ef          	jal	620 <putc>
  while (--i >= 0)
 6c4:	14fd                	addi	s1,s1,-1
 6c6:	ff349ae3          	bne	s1,s3,6ba <printint+0x7c>
 6ca:	74e2                	ld	s1,56(sp)
}
 6cc:	60a6                	ld	ra,72(sp)
 6ce:	6406                	ld	s0,64(sp)
 6d0:	7942                	ld	s2,48(sp)
 6d2:	79a2                	ld	s3,40(sp)
 6d4:	6161                	addi	sp,sp,80
 6d6:	8082                	ret
  neg = 0;
 6d8:	4301                	li	t1,0
 6da:	bfbd                	j	658 <printint+0x1a>

00000000000006dc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6dc:	711d                	addi	sp,sp,-96
 6de:	ec86                	sd	ra,88(sp)
 6e0:	e8a2                	sd	s0,80(sp)
 6e2:	e4a6                	sd	s1,72(sp)
 6e4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 6e6:	0005c483          	lbu	s1,0(a1)
 6ea:	22048363          	beqz	s1,910 <vprintf+0x234>
 6ee:	e0ca                	sd	s2,64(sp)
 6f0:	fc4e                	sd	s3,56(sp)
 6f2:	f852                	sd	s4,48(sp)
 6f4:	f456                	sd	s5,40(sp)
 6f6:	f05a                	sd	s6,32(sp)
 6f8:	ec5e                	sd	s7,24(sp)
 6fa:	e862                	sd	s8,16(sp)
 6fc:	8b2a                	mv	s6,a0
 6fe:	8a2e                	mv	s4,a1
 700:	8bb2                	mv	s7,a2
  state = 0;
 702:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 704:	4901                	li	s2,0
 706:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 708:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 70c:	06400c13          	li	s8,100
 710:	a00d                	j	732 <vprintf+0x56>
        putc(fd, c0);
 712:	85a6                	mv	a1,s1
 714:	855a                	mv	a0,s6
 716:	f0bff0ef          	jal	620 <putc>
 71a:	a019                	j	720 <vprintf+0x44>
    } else if (state == '%') {
 71c:	03598363          	beq	s3,s5,742 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 720:	0019079b          	addiw	a5,s2,1
 724:	893e                	mv	s2,a5
 726:	873e                	mv	a4,a5
 728:	97d2                	add	a5,a5,s4
 72a:	0007c483          	lbu	s1,0(a5)
 72e:	1c048a63          	beqz	s1,902 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 732:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 736:	fe0993e3          	bnez	s3,71c <vprintf+0x40>
      if (c0 == '%') {
 73a:	fd579ce3          	bne	a5,s5,712 <vprintf+0x36>
        state = '%';
 73e:	89be                	mv	s3,a5
 740:	b7c5                	j	720 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 742:	00ea06b3          	add	a3,s4,a4
 746:	0016c603          	lbu	a2,1(a3)
      if (c1)
 74a:	1c060863          	beqz	a2,91a <vprintf+0x23e>
      if (c0 == 'd') {
 74e:	03878763          	beq	a5,s8,77c <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 752:	f9478693          	addi	a3,a5,-108
 756:	0016b693          	seqz	a3,a3
 75a:	f9c60593          	addi	a1,a2,-100
 75e:	e99d                	bnez	a1,794 <vprintf+0xb8>
 760:	ca95                	beqz	a3,794 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 762:	008b8493          	addi	s1,s7,8
 766:	4685                	li	a3,1
 768:	4629                	li	a2,10
 76a:	000bb583          	ld	a1,0(s7)
 76e:	855a                	mv	a0,s6
 770:	ecfff0ef          	jal	63e <printint>
        i += 1;
 774:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 776:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 778:	4981                	li	s3,0
 77a:	b75d                	j	720 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 77c:	008b8493          	addi	s1,s7,8
 780:	4685                	li	a3,1
 782:	4629                	li	a2,10
 784:	000ba583          	lw	a1,0(s7)
 788:	855a                	mv	a0,s6
 78a:	eb5ff0ef          	jal	63e <printint>
 78e:	8ba6                	mv	s7,s1
      state = 0;
 790:	4981                	li	s3,0
 792:	b779                	j	720 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 794:	9752                	add	a4,a4,s4
 796:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 79a:	f9460713          	addi	a4,a2,-108
 79e:	00173713          	seqz	a4,a4
 7a2:	8f75                	and	a4,a4,a3
 7a4:	f9c58513          	addi	a0,a1,-100
 7a8:	18051363          	bnez	a0,92e <vprintf+0x252>
 7ac:	18070163          	beqz	a4,92e <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b0:	008b8493          	addi	s1,s7,8
 7b4:	4685                	li	a3,1
 7b6:	4629                	li	a2,10
 7b8:	000bb583          	ld	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	e81ff0ef          	jal	63e <printint>
        i += 2;
 7c2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c4:	8ba6                	mv	s7,s1
      state = 0;
 7c6:	4981                	li	s3,0
        i += 2;
 7c8:	bfa1                	j	720 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7ca:	008b8493          	addi	s1,s7,8
 7ce:	4681                	li	a3,0
 7d0:	4629                	li	a2,10
 7d2:	000be583          	lwu	a1,0(s7)
 7d6:	855a                	mv	a0,s6
 7d8:	e67ff0ef          	jal	63e <printint>
 7dc:	8ba6                	mv	s7,s1
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b781                	j	720 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e2:	008b8493          	addi	s1,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4629                	li	a2,10
 7ea:	000bb583          	ld	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	e4fff0ef          	jal	63e <printint>
        i += 1;
 7f4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f6:	8ba6                	mv	s7,s1
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	b71d                	j	720 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fc:	008b8493          	addi	s1,s7,8
 800:	4681                	li	a3,0
 802:	4629                	li	a2,10
 804:	000bb583          	ld	a1,0(s7)
 808:	855a                	mv	a0,s6
 80a:	e35ff0ef          	jal	63e <printint>
        i += 2;
 80e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 810:	8ba6                	mv	s7,s1
      state = 0;
 812:	4981                	li	s3,0
        i += 2;
 814:	b731                	j	720 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 816:	008b8493          	addi	s1,s7,8
 81a:	4681                	li	a3,0
 81c:	4641                	li	a2,16
 81e:	000be583          	lwu	a1,0(s7)
 822:	855a                	mv	a0,s6
 824:	e1bff0ef          	jal	63e <printint>
 828:	8ba6                	mv	s7,s1
      state = 0;
 82a:	4981                	li	s3,0
 82c:	bdd5                	j	720 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 82e:	008b8493          	addi	s1,s7,8
 832:	4681                	li	a3,0
 834:	4641                	li	a2,16
 836:	000bb583          	ld	a1,0(s7)
 83a:	855a                	mv	a0,s6
 83c:	e03ff0ef          	jal	63e <printint>
        i += 1;
 840:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 842:	8ba6                	mv	s7,s1
      state = 0;
 844:	4981                	li	s3,0
 846:	bde9                	j	720 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 848:	008b8493          	addi	s1,s7,8
 84c:	4681                	li	a3,0
 84e:	4641                	li	a2,16
 850:	000bb583          	ld	a1,0(s7)
 854:	855a                	mv	a0,s6
 856:	de9ff0ef          	jal	63e <printint>
        i += 2;
 85a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 85c:	8ba6                	mv	s7,s1
      state = 0;
 85e:	4981                	li	s3,0
        i += 2;
 860:	b5c1                	j	720 <vprintf+0x44>
 862:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 864:	008b8793          	addi	a5,s7,8
 868:	8cbe                	mv	s9,a5
 86a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 86e:	03000593          	li	a1,48
 872:	855a                	mv	a0,s6
 874:	dadff0ef          	jal	620 <putc>
  putc(fd, 'x');
 878:	07800593          	li	a1,120
 87c:	855a                	mv	a0,s6
 87e:	da3ff0ef          	jal	620 <putc>
 882:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 884:	00000b97          	auipc	s7,0x0
 888:	55cb8b93          	addi	s7,s7,1372 # de0 <digits>
 88c:	03c9d793          	srli	a5,s3,0x3c
 890:	97de                	add	a5,a5,s7
 892:	0007c583          	lbu	a1,0(a5)
 896:	855a                	mv	a0,s6
 898:	d89ff0ef          	jal	620 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 89c:	0992                	slli	s3,s3,0x4
 89e:	34fd                	addiw	s1,s1,-1
 8a0:	f4f5                	bnez	s1,88c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 8a2:	8be6                	mv	s7,s9
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	6ca2                	ld	s9,8(sp)
 8a8:	bda5                	j	720 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 8aa:	008b8493          	addi	s1,s7,8
 8ae:	000bc583          	lbu	a1,0(s7)
 8b2:	855a                	mv	a0,s6
 8b4:	d6dff0ef          	jal	620 <putc>
 8b8:	8ba6                	mv	s7,s1
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	b595                	j	720 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 8be:	008b8993          	addi	s3,s7,8
 8c2:	000bb483          	ld	s1,0(s7)
 8c6:	cc91                	beqz	s1,8e2 <vprintf+0x206>
        for (; *s; s++)
 8c8:	0004c583          	lbu	a1,0(s1)
 8cc:	c985                	beqz	a1,8fc <vprintf+0x220>
          putc(fd, *s);
 8ce:	855a                	mv	a0,s6
 8d0:	d51ff0ef          	jal	620 <putc>
        for (; *s; s++)
 8d4:	0485                	addi	s1,s1,1
 8d6:	0004c583          	lbu	a1,0(s1)
 8da:	f9f5                	bnez	a1,8ce <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 8dc:	8bce                	mv	s7,s3
      state = 0;
 8de:	4981                	li	s3,0
 8e0:	b581                	j	720 <vprintf+0x44>
          s = "(null)";
 8e2:	00000497          	auipc	s1,0x0
 8e6:	4f648493          	addi	s1,s1,1270 # dd8 <malloc+0x35a>
        for (; *s; s++)
 8ea:	02800593          	li	a1,40
 8ee:	b7c5                	j	8ce <vprintf+0x1f2>
        putc(fd, '%');
 8f0:	85be                	mv	a1,a5
 8f2:	855a                	mv	a0,s6
 8f4:	d2dff0ef          	jal	620 <putc>
      state = 0;
 8f8:	4981                	li	s3,0
 8fa:	b51d                	j	720 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 8fc:	8bce                	mv	s7,s3
      state = 0;
 8fe:	4981                	li	s3,0
 900:	b505                	j	720 <vprintf+0x44>
 902:	6906                	ld	s2,64(sp)
 904:	79e2                	ld	s3,56(sp)
 906:	7a42                	ld	s4,48(sp)
 908:	7aa2                	ld	s5,40(sp)
 90a:	7b02                	ld	s6,32(sp)
 90c:	6be2                	ld	s7,24(sp)
 90e:	6c42                	ld	s8,16(sp)
    }
  }
}
 910:	60e6                	ld	ra,88(sp)
 912:	6446                	ld	s0,80(sp)
 914:	64a6                	ld	s1,72(sp)
 916:	6125                	addi	sp,sp,96
 918:	8082                	ret
      if (c0 == 'd') {
 91a:	06400713          	li	a4,100
 91e:	e4e78fe3          	beq	a5,a4,77c <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 922:	f9478693          	addi	a3,a5,-108
 926:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 92a:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 92c:	4701                	li	a4,0
      } else if (c0 == 'u') {
 92e:	07500513          	li	a0,117
 932:	e8a78ce3          	beq	a5,a0,7ca <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 936:	f8b60513          	addi	a0,a2,-117
 93a:	e119                	bnez	a0,940 <vprintf+0x264>
 93c:	ea0693e3          	bnez	a3,7e2 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 940:	f8b58513          	addi	a0,a1,-117
 944:	e119                	bnez	a0,94a <vprintf+0x26e>
 946:	ea071be3          	bnez	a4,7fc <vprintf+0x120>
      } else if (c0 == 'x') {
 94a:	07800513          	li	a0,120
 94e:	eca784e3          	beq	a5,a0,816 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 952:	f8860613          	addi	a2,a2,-120
 956:	e219                	bnez	a2,95c <vprintf+0x280>
 958:	ec069be3          	bnez	a3,82e <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 95c:	f8858593          	addi	a1,a1,-120
 960:	e199                	bnez	a1,966 <vprintf+0x28a>
 962:	ee0713e3          	bnez	a4,848 <vprintf+0x16c>
      } else if (c0 == 'p') {
 966:	07000713          	li	a4,112
 96a:	eee78ce3          	beq	a5,a4,862 <vprintf+0x186>
      } else if (c0 == 'c') {
 96e:	06300713          	li	a4,99
 972:	f2e78ce3          	beq	a5,a4,8aa <vprintf+0x1ce>
      } else if (c0 == 's') {
 976:	07300713          	li	a4,115
 97a:	f4e782e3          	beq	a5,a4,8be <vprintf+0x1e2>
      } else if (c0 == '%') {
 97e:	02500713          	li	a4,37
 982:	f6e787e3          	beq	a5,a4,8f0 <vprintf+0x214>
        putc(fd, '%');
 986:	02500593          	li	a1,37
 98a:	855a                	mv	a0,s6
 98c:	c95ff0ef          	jal	620 <putc>
        putc(fd, c0);
 990:	85a6                	mv	a1,s1
 992:	855a                	mv	a0,s6
 994:	c8dff0ef          	jal	620 <putc>
      state = 0;
 998:	4981                	li	s3,0
 99a:	b359                	j	720 <vprintf+0x44>

000000000000099c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 99c:	715d                	addi	sp,sp,-80
 99e:	ec06                	sd	ra,24(sp)
 9a0:	e822                	sd	s0,16(sp)
 9a2:	1000                	addi	s0,sp,32
 9a4:	e010                	sd	a2,0(s0)
 9a6:	e414                	sd	a3,8(s0)
 9a8:	e818                	sd	a4,16(s0)
 9aa:	ec1c                	sd	a5,24(s0)
 9ac:	03043023          	sd	a6,32(s0)
 9b0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9b4:	8622                	mv	a2,s0
 9b6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9ba:	d23ff0ef          	jal	6dc <vprintf>
}
 9be:	60e2                	ld	ra,24(sp)
 9c0:	6442                	ld	s0,16(sp)
 9c2:	6161                	addi	sp,sp,80
 9c4:	8082                	ret

00000000000009c6 <printf>:

void
printf(const char *fmt, ...)
{
 9c6:	711d                	addi	sp,sp,-96
 9c8:	ec06                	sd	ra,24(sp)
 9ca:	e822                	sd	s0,16(sp)
 9cc:	1000                	addi	s0,sp,32
 9ce:	e40c                	sd	a1,8(s0)
 9d0:	e810                	sd	a2,16(s0)
 9d2:	ec14                	sd	a3,24(s0)
 9d4:	f018                	sd	a4,32(s0)
 9d6:	f41c                	sd	a5,40(s0)
 9d8:	03043823          	sd	a6,48(s0)
 9dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9e0:	00840613          	addi	a2,s0,8
 9e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9e8:	85aa                	mv	a1,a0
 9ea:	4505                	li	a0,1
 9ec:	cf1ff0ef          	jal	6dc <vprintf>
}
 9f0:	60e2                	ld	ra,24(sp)
 9f2:	6442                	ld	s0,16(sp)
 9f4:	6125                	addi	sp,sp,96
 9f6:	8082                	ret

00000000000009f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9f8:	1141                	addi	sp,sp,-16
 9fa:	e406                	sd	ra,8(sp)
 9fc:	e022                	sd	s0,0(sp)
 9fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 a00:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a04:	00001797          	auipc	a5,0x1
 a08:	5fc7b783          	ld	a5,1532(a5) # 2000 <freep>
 a0c:	a039                	j	a1a <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a0e:	6398                	ld	a4,0(a5)
 a10:	00e7e463          	bltu	a5,a4,a18 <free+0x20>
 a14:	00e6ea63          	bltu	a3,a4,a28 <free+0x30>
{
 a18:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a1a:	fed7fae3          	bgeu	a5,a3,a0e <free+0x16>
 a1e:	6398                	ld	a4,0(a5)
 a20:	00e6e463          	bltu	a3,a4,a28 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a24:	fee7eae3          	bltu	a5,a4,a18 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 a28:	ff852583          	lw	a1,-8(a0)
 a2c:	6390                	ld	a2,0(a5)
 a2e:	02059813          	slli	a6,a1,0x20
 a32:	01c85713          	srli	a4,a6,0x1c
 a36:	9736                	add	a4,a4,a3
 a38:	02e60563          	beq	a2,a4,a62 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 a3c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 a40:	4790                	lw	a2,8(a5)
 a42:	02061593          	slli	a1,a2,0x20
 a46:	01c5d713          	srli	a4,a1,0x1c
 a4a:	973e                	add	a4,a4,a5
 a4c:	02e68263          	beq	a3,a4,a70 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a50:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a52:	00001717          	auipc	a4,0x1
 a56:	5af73723          	sd	a5,1454(a4) # 2000 <freep>
}
 a5a:	60a2                	ld	ra,8(sp)
 a5c:	6402                	ld	s0,0(sp)
 a5e:	0141                	addi	sp,sp,16
 a60:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 a62:	4618                	lw	a4,8(a2)
 a64:	9f2d                	addw	a4,a4,a1
 a66:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a6a:	6398                	ld	a4,0(a5)
 a6c:	6310                	ld	a2,0(a4)
 a6e:	b7f9                	j	a3c <free+0x44>
    p->s.size += bp->s.size;
 a70:	ff852703          	lw	a4,-8(a0)
 a74:	9f31                	addw	a4,a4,a2
 a76:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a78:	ff053683          	ld	a3,-16(a0)
 a7c:	bfd1                	j	a50 <free+0x58>

0000000000000a7e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 a7e:	7139                	addi	sp,sp,-64
 a80:	fc06                	sd	ra,56(sp)
 a82:	f822                	sd	s0,48(sp)
 a84:	f04a                	sd	s2,32(sp)
 a86:	ec4e                	sd	s3,24(sp)
 a88:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 a8a:	02051993          	slli	s3,a0,0x20
 a8e:	0209d993          	srli	s3,s3,0x20
 a92:	09bd                	addi	s3,s3,15
 a94:	0049d993          	srli	s3,s3,0x4
 a98:	2985                	addiw	s3,s3,1
 a9a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 a9c:	00001517          	auipc	a0,0x1
 aa0:	56453503          	ld	a0,1380(a0) # 2000 <freep>
 aa4:	c905                	beqz	a0,ad4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 aa6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 aa8:	4798                	lw	a4,8(a5)
 aaa:	09377663          	bgeu	a4,s3,b36 <malloc+0xb8>
 aae:	f426                	sd	s1,40(sp)
 ab0:	e852                	sd	s4,16(sp)
 ab2:	e456                	sd	s5,8(sp)
 ab4:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 ab6:	8a4e                	mv	s4,s3
 ab8:	6705                	lui	a4,0x1
 aba:	00e9f363          	bgeu	s3,a4,ac0 <malloc+0x42>
 abe:	6a05                	lui	s4,0x1
 ac0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ac4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 ac8:	00001497          	auipc	s1,0x1
 acc:	53848493          	addi	s1,s1,1336 # 2000 <freep>
  if (p == SBRK_ERROR)
 ad0:	5afd                	li	s5,-1
 ad2:	a83d                	j	b10 <malloc+0x92>
 ad4:	f426                	sd	s1,40(sp)
 ad6:	e852                	sd	s4,16(sp)
 ad8:	e456                	sd	s5,8(sp)
 ada:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 adc:	00001797          	auipc	a5,0x1
 ae0:	53478793          	addi	a5,a5,1332 # 2010 <base>
 ae4:	00001717          	auipc	a4,0x1
 ae8:	50f73e23          	sd	a5,1308(a4) # 2000 <freep>
 aec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 aee:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 af2:	b7d1                	j	ab6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 af4:	6398                	ld	a4,0(a5)
 af6:	e118                	sd	a4,0(a0)
 af8:	a899                	j	b4e <malloc+0xd0>
  hp->s.size = nu;
 afa:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 afe:	0541                	addi	a0,a0,16
 b00:	ef9ff0ef          	jal	9f8 <free>
  return freep;
 b04:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 b06:	c125                	beqz	a0,b66 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 b08:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 b0a:	4798                	lw	a4,8(a5)
 b0c:	03277163          	bgeu	a4,s2,b2e <malloc+0xb0>
    if (p == freep)
 b10:	6098                	ld	a4,0(s1)
 b12:	853e                	mv	a0,a5
 b14:	fef71ae3          	bne	a4,a5,b08 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b18:	8552                	mv	a0,s4
 b1a:	9fbff0ef          	jal	514 <sbrk>
  if (p == SBRK_ERROR)
 b1e:	fd551ee3          	bne	a0,s5,afa <malloc+0x7c>
        return 0;
 b22:	4501                	li	a0,0
 b24:	74a2                	ld	s1,40(sp)
 b26:	6a42                	ld	s4,16(sp)
 b28:	6aa2                	ld	s5,8(sp)
 b2a:	6b02                	ld	s6,0(sp)
 b2c:	a03d                	j	b5a <malloc+0xdc>
 b2e:	74a2                	ld	s1,40(sp)
 b30:	6a42                	ld	s4,16(sp)
 b32:	6aa2                	ld	s5,8(sp)
 b34:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 b36:	fae90fe3          	beq	s2,a4,af4 <malloc+0x76>
        p->s.size -= nunits;
 b3a:	4137073b          	subw	a4,a4,s3
 b3e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b40:	02071693          	slli	a3,a4,0x20
 b44:	01c6d713          	srli	a4,a3,0x1c
 b48:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b4a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b4e:	00001717          	auipc	a4,0x1
 b52:	4aa73923          	sd	a0,1202(a4) # 2000 <freep>
      return (void *)(p + 1);
 b56:	01078513          	addi	a0,a5,16
  }
}
 b5a:	70e2                	ld	ra,56(sp)
 b5c:	7442                	ld	s0,48(sp)
 b5e:	7902                	ld	s2,32(sp)
 b60:	69e2                	ld	s3,24(sp)
 b62:	6121                	addi	sp,sp,64
 b64:	8082                	ret
 b66:	74a2                	ld	s1,40(sp)
 b68:	6a42                	ld	s4,16(sp)
 b6a:	6aa2                	ld	s5,8(sp)
 b6c:	6b02                	ld	s6,0(sp)
 b6e:	b7f5                	j	b5a <malloc+0xdc>
