
user/_philosophers:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <philosopher>:
#define NPHIL 5
#define CYCLES 5

void
philosopher(int id, int forks[NPHIL])
{
   0:	7159                	addi	sp,sp,-112
   2:	f486                	sd	ra,104(sp)
   4:	f0a2                	sd	s0,96(sp)
   6:	eca6                	sd	s1,88(sp)
   8:	e8ca                	sd	s2,80(sp)
   a:	e4ce                	sd	s3,72(sp)
   c:	e0d2                	sd	s4,64(sp)
   e:	fc56                	sd	s5,56(sp)
  10:	f85a                	sd	s6,48(sp)
  12:	f45e                	sd	s7,40(sp)
  14:	f062                	sd	s8,32(sp)
  16:	ec66                	sd	s9,24(sp)
  18:	e86a                	sd	s10,16(sp)
  1a:	e46e                	sd	s11,8(sp)
  1c:	1880                	addi	s0,sp,112
  1e:	84aa                	mv	s1,a0
    int left = id;
    int right = (id + 1) % NPHIL;
  20:	0015071b          	addiw	a4,a0,1
  24:	666667b7          	lui	a5,0x66666
  28:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x66664657>
  2c:	02f707b3          	mul	a5,a4,a5
  30:	9785                	srai	a5,a5,0x21
  32:	41f7569b          	sraiw	a3,a4,0x1f
  36:	9f95                	subw	a5,a5,a3
  38:	0027969b          	slliw	a3,a5,0x2
  3c:	9fb5                	addw	a5,a5,a3
  3e:	40f707bb          	subw	a5,a4,a5

    // Pick the lower-numbered fork first to prevent circular wait.
    int first = left < right ? left : right;
  42:	89aa                	mv	s3,a0
  44:	00a7d363          	bge	a5,a0,4a <philosopher+0x4a>
  48:	89be                	mv	s3,a5
        sleep(2);

        printf("Philosopher %d: HUNGRY (cycle %d)\n",
               id, cycle + 1);

        sem_wait(forks[first]);
  4a:	2981                	sext.w	s3,s3
  4c:	098a                	slli	s3,s3,0x2
  4e:	99ae                	add	s3,s3,a1
    int second = left < right ? right : left;
  50:	8726                	mv	a4,s1
  52:	00f4d363          	bge	s1,a5,58 <philosopher+0x58>
  56:	873e                	mv	a4,a5
        sem_wait(forks[second]);
  58:	2701                	sext.w	a4,a4
  5a:	070a                	slli	a4,a4,0x2
  5c:	00e58ab3          	add	s5,a1,a4
    for (int cycle = 0; cycle < CYCLES; cycle++) {
  60:	4a01                	li	s4,0
        printf("Philosopher %d: THINKING (cycle %d)\n",
  62:	00001d97          	auipc	s11,0x1
  66:	a5ed8d93          	addi	s11,s11,-1442 # ac0 <malloc+0xf8>
        sleep(2);
  6a:	4b09                	li	s6,2
        printf("Philosopher %d: HUNGRY (cycle %d)\n",
  6c:	00001d17          	auipc	s10,0x1
  70:	a7cd0d13          	addi	s10,s10,-1412 # ae8 <malloc+0x120>

        printf("Philosopher %d: EATING (cycle %d)\n",
  74:	00001c97          	auipc	s9,0x1
  78:	a9cc8c93          	addi	s9,s9,-1380 # b10 <malloc+0x148>
               id, cycle + 1);
        sleep(3);
  7c:	4c0d                	li	s8,3
    for (int cycle = 0; cycle < CYCLES; cycle++) {
  7e:	4b95                	li	s7,5
        printf("Philosopher %d: THINKING (cycle %d)\n",
  80:	001a091b          	addiw	s2,s4,1
  84:	8a4a                	mv	s4,s2
  86:	864a                	mv	a2,s2
  88:	85a6                	mv	a1,s1
  8a:	856e                	mv	a0,s11
  8c:	085000ef          	jal	910 <printf>
        sleep(2);
  90:	855a                	mv	a0,s6
  92:	410000ef          	jal	4a2 <sleep>
        printf("Philosopher %d: HUNGRY (cycle %d)\n",
  96:	864a                	mv	a2,s2
  98:	85a6                	mv	a1,s1
  9a:	856a                	mv	a0,s10
  9c:	075000ef          	jal	910 <printf>
        sem_wait(forks[first]);
  a0:	0009a503          	lw	a0,0(s3)
  a4:	426000ef          	jal	4ca <sem_wait>
        sem_wait(forks[second]);
  a8:	000aa503          	lw	a0,0(s5)
  ac:	41e000ef          	jal	4ca <sem_wait>
        printf("Philosopher %d: EATING (cycle %d)\n",
  b0:	864a                	mv	a2,s2
  b2:	85a6                	mv	a1,s1
  b4:	8566                	mv	a0,s9
  b6:	05b000ef          	jal	910 <printf>
        sleep(3);
  ba:	8562                	mv	a0,s8
  bc:	3e6000ef          	jal	4a2 <sleep>

        sem_signal(forks[second]);
  c0:	000aa503          	lw	a0,0(s5)
  c4:	40e000ef          	jal	4d2 <sem_signal>
        sem_signal(forks[first]);
  c8:	0009a503          	lw	a0,0(s3)
  cc:	406000ef          	jal	4d2 <sem_signal>

        printf("Philosopher %d: THINKING (forks released)\n", id);
  d0:	85a6                	mv	a1,s1
  d2:	00001517          	auipc	a0,0x1
  d6:	a6650513          	addi	a0,a0,-1434 # b38 <malloc+0x170>
  da:	037000ef          	jal	910 <printf>
        sleep(2);
  de:	855a                	mv	a0,s6
  e0:	3c2000ef          	jal	4a2 <sleep>
    for (int cycle = 0; cycle < CYCLES; cycle++) {
  e4:	f9791ee3          	bne	s2,s7,80 <philosopher+0x80>
    }

    printf("Philosopher %d: completed all cycles\n", id);
  e8:	85a6                	mv	a1,s1
  ea:	00001517          	auipc	a0,0x1
  ee:	a7e50513          	addi	a0,a0,-1410 # b68 <malloc+0x1a0>
  f2:	01f000ef          	jal	910 <printf>
}
  f6:	70a6                	ld	ra,104(sp)
  f8:	7406                	ld	s0,96(sp)
  fa:	64e6                	ld	s1,88(sp)
  fc:	6946                	ld	s2,80(sp)
  fe:	69a6                	ld	s3,72(sp)
 100:	6a06                	ld	s4,64(sp)
 102:	7ae2                	ld	s5,56(sp)
 104:	7b42                	ld	s6,48(sp)
 106:	7ba2                	ld	s7,40(sp)
 108:	7c02                	ld	s8,32(sp)
 10a:	6ce2                	ld	s9,24(sp)
 10c:	6d42                	ld	s10,16(sp)
 10e:	6da2                	ld	s11,8(sp)
 110:	6165                	addi	sp,sp,112
 112:	8082                	ret

0000000000000114 <main>:

int
main(int argc, char *argv[])
{
 114:	711d                	addi	sp,sp,-96
 116:	ec86                	sd	ra,88(sp)
 118:	e8a2                	sd	s0,80(sp)
 11a:	e4a6                	sd	s1,72(sp)
 11c:	e0ca                	sd	s2,64(sp)
 11e:	fc4e                	sd	s3,56(sp)
 120:	f852                	sd	s4,48(sp)
 122:	f456                	sd	s5,40(sp)
 124:	1080                	addi	s0,sp,96
    int forks[NPHIL];

    printf("Dining Philosophers started\n");
 126:	00001517          	auipc	a0,0x1
 12a:	a6a50513          	addi	a0,a0,-1430 # b90 <malloc+0x1c8>
 12e:	7e2000ef          	jal	910 <printf>
    printf("Philosophers = 5, Cycles = %d\n", CYCLES);
 132:	4595                	li	a1,5
 134:	00001517          	auipc	a0,0x1
 138:	a7c50513          	addi	a0,a0,-1412 # bb0 <malloc+0x1e8>
 13c:	7d4000ef          	jal	910 <printf>

    // One binary semaphore for each fork.
    for (int i = 0; i < NPHIL; i++) {
 140:	fa840493          	addi	s1,s0,-88
    printf("Philosophers = 5, Cycles = %d\n", CYCLES);
 144:	8926                	mv	s2,s1
    for (int i = 0; i < NPHIL; i++) {
 146:	4981                	li	s3,0
        forks[i] = sem_create(1);
 148:	4a05                	li	s4,1
    for (int i = 0; i < NPHIL; i++) {
 14a:	4a95                	li	s5,5
        forks[i] = sem_create(1);
 14c:	8552                	mv	a0,s4
 14e:	374000ef          	jal	4c2 <sem_create>
 152:	00a92023          	sw	a0,0(s2)
        if (forks[i] < 0) {
 156:	04054863          	bltz	a0,1a6 <main+0x92>
    for (int i = 0; i < NPHIL; i++) {
 15a:	2985                	addiw	s3,s3,1
 15c:	0911                	addi	s2,s2,4
 15e:	ff5997e3          	bne	s3,s5,14c <main+0x38>
            exit(1);
        }
    }

    // Create five philosopher processes.
    for (int i = 0; i < NPHIL; i++) {
 162:	4901                	li	s2,0
 164:	4995                	li	s3,5
        int pid = fork();
 166:	324000ef          	jal	48a <fork>

        if (pid < 0) {
 16a:	04054863          	bltz	a0,1ba <main+0xa6>
            printf("fork failed\n");
            exit(1);
        }

        if (pid == 0) {
 16e:	cd39                	beqz	a0,1cc <main+0xb8>
    for (int i = 0; i < NPHIL; i++) {
 170:	2905                	addiw	s2,s2,1
 172:	ff391ae3          	bne	s2,s3,166 <main+0x52>
 176:	4915                	li	s2,5
        }
    }

    // Wait for all philosophers.
    for (int i = 0; i < NPHIL; i++)
        wait(0);
 178:	4501                	li	a0,0
 17a:	320000ef          	jal	49a <wait>
    for (int i = 0; i < NPHIL; i++)
 17e:	397d                	addiw	s2,s2,-1
 180:	fe091ce3          	bnez	s2,178 <main+0x64>
 184:	01448913          	addi	s2,s1,20

    for (int i = 0; i < NPHIL; i++)
        sem_free(forks[i]);
 188:	4088                	lw	a0,0(s1)
 18a:	350000ef          	jal	4da <sem_free>
    for (int i = 0; i < NPHIL; i++)
 18e:	0491                	addi	s1,s1,4
 190:	ff249ce3          	bne	s1,s2,188 <main+0x74>

    printf("Dining Philosophers completed successfully.\n");
 194:	00001517          	auipc	a0,0x1
 198:	a7450513          	addi	a0,a0,-1420 # c08 <malloc+0x240>
 19c:	774000ef          	jal	910 <printf>

    exit(0);
 1a0:	4501                	li	a0,0
 1a2:	2f0000ef          	jal	492 <exit>
            printf("Failed to create fork semaphore %d\n", i);
 1a6:	85ce                	mv	a1,s3
 1a8:	00001517          	auipc	a0,0x1
 1ac:	a2850513          	addi	a0,a0,-1496 # bd0 <malloc+0x208>
 1b0:	760000ef          	jal	910 <printf>
            exit(1);
 1b4:	4505                	li	a0,1
 1b6:	2dc000ef          	jal	492 <exit>
            printf("fork failed\n");
 1ba:	00001517          	auipc	a0,0x1
 1be:	a3e50513          	addi	a0,a0,-1474 # bf8 <malloc+0x230>
 1c2:	74e000ef          	jal	910 <printf>
            exit(1);
 1c6:	4505                	li	a0,1
 1c8:	2ca000ef          	jal	492 <exit>
            philosopher(i, forks);
 1cc:	fa840593          	addi	a1,s0,-88
 1d0:	854a                	mv	a0,s2
 1d2:	e2fff0ef          	jal	0 <philosopher>
            exit(0);
 1d6:	4501                	li	a0,0
 1d8:	2ba000ef          	jal	492 <exit>

00000000000001dc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e406                	sd	ra,8(sp)
 1e0:	e022                	sd	s0,0(sp)
 1e2:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 1e4:	f31ff0ef          	jal	114 <main>
  exit(r);
 1e8:	2aa000ef          	jal	492 <exit>

00000000000001ec <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e406                	sd	ra,8(sp)
 1f0:	e022                	sd	s0,0(sp)
 1f2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 1f4:	87aa                	mv	a5,a0
 1f6:	0585                	addi	a1,a1,1
 1f8:	0785                	addi	a5,a5,1
 1fa:	fff5c703          	lbu	a4,-1(a1)
 1fe:	fee78fa3          	sb	a4,-1(a5)
 202:	fb75                	bnez	a4,1f6 <strcpy+0xa>
    ;
  return os;
}
 204:	60a2                	ld	ra,8(sp)
 206:	6402                	ld	s0,0(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret

000000000000020c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e406                	sd	ra,8(sp)
 210:	e022                	sd	s0,0(sp)
 212:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 214:	00054783          	lbu	a5,0(a0)
 218:	cb91                	beqz	a5,22c <strcmp+0x20>
 21a:	0005c703          	lbu	a4,0(a1)
 21e:	00f71763          	bne	a4,a5,22c <strcmp+0x20>
    p++, q++;
 222:	0505                	addi	a0,a0,1
 224:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 226:	00054783          	lbu	a5,0(a0)
 22a:	fbe5                	bnez	a5,21a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 22c:	0005c503          	lbu	a0,0(a1)
}
 230:	40a7853b          	subw	a0,a5,a0
 234:	60a2                	ld	ra,8(sp)
 236:	6402                	ld	s0,0(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret

000000000000023c <strlen>:

uint
strlen(const char *s)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e406                	sd	ra,8(sp)
 240:	e022                	sd	s0,0(sp)
 242:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 244:	00054783          	lbu	a5,0(a0)
 248:	cf91                	beqz	a5,264 <strlen+0x28>
 24a:	00150793          	addi	a5,a0,1
 24e:	86be                	mv	a3,a5
 250:	0785                	addi	a5,a5,1
 252:	fff7c703          	lbu	a4,-1(a5)
 256:	ff65                	bnez	a4,24e <strlen+0x12>
 258:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 25c:	60a2                	ld	ra,8(sp)
 25e:	6402                	ld	s0,0(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  for (n = 0; s[n]; n++)
 264:	4501                	li	a0,0
 266:	bfdd                	j	25c <strlen+0x20>

0000000000000268 <memset>:

void *
memset(void *dst, int c, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 270:	ca19                	beqz	a2,286 <memset+0x1e>
 272:	87aa                	mv	a5,a0
 274:	1602                	slli	a2,a2,0x20
 276:	9201                	srli	a2,a2,0x20
 278:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 27c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 280:	0785                	addi	a5,a5,1
 282:	fee79de3          	bne	a5,a4,27c <memset+0x14>
  }
  return dst;
}
 286:	60a2                	ld	ra,8(sp)
 288:	6402                	ld	s0,0(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <strchr>:

char *
strchr(const char *s, char c)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  for (; *s; s++)
 296:	00054783          	lbu	a5,0(a0)
 29a:	cf81                	beqz	a5,2b2 <strchr+0x24>
    if (*s == c)
 29c:	00f58763          	beq	a1,a5,2aa <strchr+0x1c>
  for (; *s; s++)
 2a0:	0505                	addi	a0,a0,1
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	fbfd                	bnez	a5,29c <strchr+0xe>
      return (char *)s;
  return 0;
 2a8:	4501                	li	a0,0
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
  return 0;
 2b2:	4501                	li	a0,0
 2b4:	bfdd                	j	2aa <strchr+0x1c>

00000000000002b6 <gets>:

char *
gets(char *buf, int max)
{
 2b6:	711d                	addi	sp,sp,-96
 2b8:	ec86                	sd	ra,88(sp)
 2ba:	e8a2                	sd	s0,80(sp)
 2bc:	e4a6                	sd	s1,72(sp)
 2be:	e0ca                	sd	s2,64(sp)
 2c0:	fc4e                	sd	s3,56(sp)
 2c2:	f852                	sd	s4,48(sp)
 2c4:	f456                	sd	s5,40(sp)
 2c6:	f05a                	sd	s6,32(sp)
 2c8:	ec5e                	sd	s7,24(sp)
 2ca:	e862                	sd	s8,16(sp)
 2cc:	1080                	addi	s0,sp,96
 2ce:	8baa                	mv	s7,a0
 2d0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 2d2:	892a                	mv	s2,a0
 2d4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2d6:	faf40b13          	addi	s6,s0,-81
 2da:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 2dc:	8c26                	mv	s8,s1
 2de:	0014899b          	addiw	s3,s1,1
 2e2:	84ce                	mv	s1,s3
 2e4:	0349d463          	bge	s3,s4,30c <gets+0x56>
    cc = read(0, &c, 1);
 2e8:	8656                	mv	a2,s5
 2ea:	85da                	mv	a1,s6
 2ec:	4501                	li	a0,0
 2ee:	1c4000ef          	jal	4b2 <read>
    if (cc < 1)
 2f2:	00a05d63          	blez	a0,30c <gets+0x56>
      break;
    buf[i++] = c;
 2f6:	faf44783          	lbu	a5,-81(s0)
 2fa:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 2fe:	0905                	addi	s2,s2,1
 300:	ff678713          	addi	a4,a5,-10
 304:	c319                	beqz	a4,30a <gets+0x54>
 306:	17cd                	addi	a5,a5,-13
 308:	fbf1                	bnez	a5,2dc <gets+0x26>
    buf[i++] = c;
 30a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 30c:	9c5e                	add	s8,s8,s7
 30e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 312:	855e                	mv	a0,s7
 314:	60e6                	ld	ra,88(sp)
 316:	6446                	ld	s0,80(sp)
 318:	64a6                	ld	s1,72(sp)
 31a:	6906                	ld	s2,64(sp)
 31c:	79e2                	ld	s3,56(sp)
 31e:	7a42                	ld	s4,48(sp)
 320:	7aa2                	ld	s5,40(sp)
 322:	7b02                	ld	s6,32(sp)
 324:	6be2                	ld	s7,24(sp)
 326:	6c42                	ld	s8,16(sp)
 328:	6125                	addi	sp,sp,96
 32a:	8082                	ret

000000000000032c <stat>:

int
stat(const char *n, struct stat *st)
{
 32c:	1101                	addi	sp,sp,-32
 32e:	ec06                	sd	ra,24(sp)
 330:	e822                	sd	s0,16(sp)
 332:	e04a                	sd	s2,0(sp)
 334:	1000                	addi	s0,sp,32
 336:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 338:	4581                	li	a1,0
 33a:	1c0000ef          	jal	4fa <open>
  if (fd < 0)
 33e:	02054263          	bltz	a0,362 <stat+0x36>
 342:	e426                	sd	s1,8(sp)
 344:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 346:	85ca                	mv	a1,s2
 348:	1ca000ef          	jal	512 <fstat>
 34c:	892a                	mv	s2,a0
  close(fd);
 34e:	8526                	mv	a0,s1
 350:	192000ef          	jal	4e2 <close>
  return r;
 354:	64a2                	ld	s1,8(sp)
}
 356:	854a                	mv	a0,s2
 358:	60e2                	ld	ra,24(sp)
 35a:	6442                	ld	s0,16(sp)
 35c:	6902                	ld	s2,0(sp)
 35e:	6105                	addi	sp,sp,32
 360:	8082                	ret
    return -1;
 362:	57fd                	li	a5,-1
 364:	893e                	mv	s2,a5
 366:	bfc5                	j	356 <stat+0x2a>

0000000000000368 <atoi>:

int
atoi(const char *s)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e406                	sd	ra,8(sp)
 36c:	e022                	sd	s0,0(sp)
 36e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 370:	00054683          	lbu	a3,0(a0)
 374:	fd06879b          	addiw	a5,a3,-48
 378:	0ff7f793          	zext.b	a5,a5
 37c:	4625                	li	a2,9
 37e:	02f66963          	bltu	a2,a5,3b0 <atoi+0x48>
 382:	872a                	mv	a4,a0
  n = 0;
 384:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 386:	0705                	addi	a4,a4,1
 388:	0025179b          	slliw	a5,a0,0x2
 38c:	9fa9                	addw	a5,a5,a0
 38e:	0017979b          	slliw	a5,a5,0x1
 392:	9fb5                	addw	a5,a5,a3
 394:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 398:	00074683          	lbu	a3,0(a4)
 39c:	fd06879b          	addiw	a5,a3,-48
 3a0:	0ff7f793          	zext.b	a5,a5
 3a4:	fef671e3          	bgeu	a2,a5,386 <atoi+0x1e>
  return n;
}
 3a8:	60a2                	ld	ra,8(sp)
 3aa:	6402                	ld	s0,0(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret
  n = 0;
 3b0:	4501                	li	a0,0
 3b2:	bfdd                	j	3a8 <atoi+0x40>

00000000000003b4 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 3b4:	1141                	addi	sp,sp,-16
 3b6:	e406                	sd	ra,8(sp)
 3b8:	e022                	sd	s0,0(sp)
 3ba:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3bc:	02b57563          	bgeu	a0,a1,3e6 <memmove+0x32>
    while (n-- > 0)
 3c0:	00c05f63          	blez	a2,3de <memmove+0x2a>
 3c4:	1602                	slli	a2,a2,0x20
 3c6:	9201                	srli	a2,a2,0x20
 3c8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3cc:	872a                	mv	a4,a0
      *dst++ = *src++;
 3ce:	0585                	addi	a1,a1,1
 3d0:	0705                	addi	a4,a4,1
 3d2:	fff5c683          	lbu	a3,-1(a1)
 3d6:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 3da:	fee79ae3          	bne	a5,a4,3ce <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3de:	60a2                	ld	ra,8(sp)
 3e0:	6402                	ld	s0,0(sp)
 3e2:	0141                	addi	sp,sp,16
 3e4:	8082                	ret
    while (n-- > 0)
 3e6:	fec05ce3          	blez	a2,3de <memmove+0x2a>
    dst += n;
 3ea:	00c50733          	add	a4,a0,a2
    src += n;
 3ee:	95b2                	add	a1,a1,a2
 3f0:	fff6079b          	addiw	a5,a2,-1
 3f4:	1782                	slli	a5,a5,0x20
 3f6:	9381                	srli	a5,a5,0x20
 3f8:	fff7c793          	not	a5,a5
 3fc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3fe:	15fd                	addi	a1,a1,-1
 400:	177d                	addi	a4,a4,-1
 402:	0005c683          	lbu	a3,0(a1)
 406:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 40a:	fef71ae3          	bne	a4,a5,3fe <memmove+0x4a>
 40e:	bfc1                	j	3de <memmove+0x2a>

0000000000000410 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 410:	1141                	addi	sp,sp,-16
 412:	e406                	sd	ra,8(sp)
 414:	e022                	sd	s0,0(sp)
 416:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 418:	c61d                	beqz	a2,446 <memcmp+0x36>
 41a:	1602                	slli	a2,a2,0x20
 41c:	9201                	srli	a2,a2,0x20
 41e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 422:	00054783          	lbu	a5,0(a0)
 426:	0005c703          	lbu	a4,0(a1)
 42a:	00e79863          	bne	a5,a4,43a <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 42e:	0505                	addi	a0,a0,1
    p2++;
 430:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 432:	fed518e3          	bne	a0,a3,422 <memcmp+0x12>
  }
  return 0;
 436:	4501                	li	a0,0
 438:	a019                	j	43e <memcmp+0x2e>
      return *p1 - *p2;
 43a:	40e7853b          	subw	a0,a5,a4
}
 43e:	60a2                	ld	ra,8(sp)
 440:	6402                	ld	s0,0(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret
  return 0;
 446:	4501                	li	a0,0
 448:	bfdd                	j	43e <memcmp+0x2e>

000000000000044a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e406                	sd	ra,8(sp)
 44e:	e022                	sd	s0,0(sp)
 450:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 452:	f63ff0ef          	jal	3b4 <memmove>
}
 456:	60a2                	ld	ra,8(sp)
 458:	6402                	ld	s0,0(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret

000000000000045e <sbrk>:

char *
sbrk(int n)
{
 45e:	1141                	addi	sp,sp,-16
 460:	e406                	sd	ra,8(sp)
 462:	e022                	sd	s0,0(sp)
 464:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 466:	4585                	li	a1,1
 468:	0da000ef          	jal	542 <sys_sbrk>
}
 46c:	60a2                	ld	ra,8(sp)
 46e:	6402                	ld	s0,0(sp)
 470:	0141                	addi	sp,sp,16
 472:	8082                	ret

0000000000000474 <sbrklazy>:

char *
sbrklazy(int n)
{
 474:	1141                	addi	sp,sp,-16
 476:	e406                	sd	ra,8(sp)
 478:	e022                	sd	s0,0(sp)
 47a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 47c:	4589                	li	a1,2
 47e:	0c4000ef          	jal	542 <sys_sbrk>
}
 482:	60a2                	ld	ra,8(sp)
 484:	6402                	ld	s0,0(sp)
 486:	0141                	addi	sp,sp,16
 488:	8082                	ret

000000000000048a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 48a:	4885                	li	a7,1
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <exit>:
.global exit
exit:
 li a7, SYS_exit
 492:	4889                	li	a7,2
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <wait>:
.global wait
wait:
 li a7, SYS_wait
 49a:	488d                	li	a7,3
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a2:	48b5                	li	a7,13
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4aa:	4891                	li	a7,4
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <read>:
.global read
read:
 li a7, SYS_read
 4b2:	4895                	li	a7,5
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <write>:
.global write
write:
 li a7, SYS_write
 4ba:	48c1                	li	a7,16
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <sem_create>:
.global sem_create
sem_create:
 li a7, SYS_sem_create
 4c2:	48e1                	li	a7,24
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <sem_wait>:
.global sem_wait
sem_wait:
 li a7, SYS_sem_wait
 4ca:	48e5                	li	a7,25
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <sem_signal>:
.global sem_signal
sem_signal:
 li a7, SYS_sem_signal
 4d2:	48e9                	li	a7,26
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <sem_free>:
.global sem_free
sem_free:
 li a7, SYS_sem_free
 4da:	48ed                	li	a7,27
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <close>:
.global close
close:
 li a7, SYS_close
 4e2:	48d5                	li	a7,21
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ea:	4899                	li	a7,6
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f2:	489d                	li	a7,7
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <open>:
.global open
open:
 li a7, SYS_open
 4fa:	48bd                	li	a7,15
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 502:	48c5                	li	a7,17
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 50a:	48c9                	li	a7,18
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 512:	48a1                	li	a7,8
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <link>:
.global link
link:
 li a7, SYS_link
 51a:	48cd                	li	a7,19
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 522:	48d1                	li	a7,20
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 52a:	48a5                	li	a7,9
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <dup>:
.global dup
dup:
 li a7, SYS_dup
 532:	48a9                	li	a7,10
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 53a:	48ad                	li	a7,11
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 542:	48b1                	li	a7,12
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <pause>:
.global pause
pause:
 li a7, SYS_pause
 54a:	48b5                	li	a7,13
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 552:	48b9                	li	a7,14
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <sync>:
.global sync
sync:
 li a7, SYS_sync
 55a:	48d9                	li	a7,22
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <shm_get>:
.global shm_get
shm_get:
 li a7, SYS_shm_get
 562:	48dd                	li	a7,23
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 56a:	1101                	addi	sp,sp,-32
 56c:	ec06                	sd	ra,24(sp)
 56e:	e822                	sd	s0,16(sp)
 570:	1000                	addi	s0,sp,32
 572:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 576:	4605                	li	a2,1
 578:	fef40593          	addi	a1,s0,-17
 57c:	f3fff0ef          	jal	4ba <write>
}
 580:	60e2                	ld	ra,24(sp)
 582:	6442                	ld	s0,16(sp)
 584:	6105                	addi	sp,sp,32
 586:	8082                	ret

0000000000000588 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 588:	715d                	addi	sp,sp,-80
 58a:	e486                	sd	ra,72(sp)
 58c:	e0a2                	sd	s0,64(sp)
 58e:	f84a                	sd	s2,48(sp)
 590:	f44e                	sd	s3,40(sp)
 592:	0880                	addi	s0,sp,80
 594:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 596:	c6d1                	beqz	a3,622 <printint+0x9a>
 598:	0805d563          	bgez	a1,622 <printint+0x9a>
    neg = 1;
    x = -xx;
 59c:	40b005b3          	neg	a1,a1
    neg = 1;
 5a0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 5a2:	fb840993          	addi	s3,s0,-72
  neg = 0;
 5a6:	86ce                	mv	a3,s3
  i = 0;
 5a8:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 5aa:	00000817          	auipc	a6,0x0
 5ae:	69680813          	addi	a6,a6,1686 # c40 <digits>
 5b2:	88ba                	mv	a7,a4
 5b4:	0017051b          	addiw	a0,a4,1
 5b8:	872a                	mv	a4,a0
 5ba:	02c5f7b3          	remu	a5,a1,a2
 5be:	97c2                	add	a5,a5,a6
 5c0:	0007c783          	lbu	a5,0(a5)
 5c4:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 5c8:	87ae                	mv	a5,a1
 5ca:	02c5d5b3          	divu	a1,a1,a2
 5ce:	0685                	addi	a3,a3,1
 5d0:	fec7f1e3          	bgeu	a5,a2,5b2 <printint+0x2a>
  if (neg)
 5d4:	00030c63          	beqz	t1,5ec <printint+0x64>
    buf[i++] = '-';
 5d8:	fd050793          	addi	a5,a0,-48
 5dc:	00878533          	add	a0,a5,s0
 5e0:	02d00793          	li	a5,45
 5e4:	fef50423          	sb	a5,-24(a0)
 5e8:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 5ec:	02e05563          	blez	a4,616 <printint+0x8e>
 5f0:	fc26                	sd	s1,56(sp)
 5f2:	377d                	addiw	a4,a4,-1
 5f4:	00e984b3          	add	s1,s3,a4
 5f8:	19fd                	addi	s3,s3,-1
 5fa:	99ba                	add	s3,s3,a4
 5fc:	1702                	slli	a4,a4,0x20
 5fe:	9301                	srli	a4,a4,0x20
 600:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 604:	0004c583          	lbu	a1,0(s1)
 608:	854a                	mv	a0,s2
 60a:	f61ff0ef          	jal	56a <putc>
  while (--i >= 0)
 60e:	14fd                	addi	s1,s1,-1
 610:	ff349ae3          	bne	s1,s3,604 <printint+0x7c>
 614:	74e2                	ld	s1,56(sp)
}
 616:	60a6                	ld	ra,72(sp)
 618:	6406                	ld	s0,64(sp)
 61a:	7942                	ld	s2,48(sp)
 61c:	79a2                	ld	s3,40(sp)
 61e:	6161                	addi	sp,sp,80
 620:	8082                	ret
  neg = 0;
 622:	4301                	li	t1,0
 624:	bfbd                	j	5a2 <printint+0x1a>

0000000000000626 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 626:	711d                	addi	sp,sp,-96
 628:	ec86                	sd	ra,88(sp)
 62a:	e8a2                	sd	s0,80(sp)
 62c:	e4a6                	sd	s1,72(sp)
 62e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 630:	0005c483          	lbu	s1,0(a1)
 634:	22048363          	beqz	s1,85a <vprintf+0x234>
 638:	e0ca                	sd	s2,64(sp)
 63a:	fc4e                	sd	s3,56(sp)
 63c:	f852                	sd	s4,48(sp)
 63e:	f456                	sd	s5,40(sp)
 640:	f05a                	sd	s6,32(sp)
 642:	ec5e                	sd	s7,24(sp)
 644:	e862                	sd	s8,16(sp)
 646:	8b2a                	mv	s6,a0
 648:	8a2e                	mv	s4,a1
 64a:	8bb2                	mv	s7,a2
  state = 0;
 64c:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 64e:	4901                	li	s2,0
 650:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 652:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 656:	06400c13          	li	s8,100
 65a:	a00d                	j	67c <vprintf+0x56>
        putc(fd, c0);
 65c:	85a6                	mv	a1,s1
 65e:	855a                	mv	a0,s6
 660:	f0bff0ef          	jal	56a <putc>
 664:	a019                	j	66a <vprintf+0x44>
    } else if (state == '%') {
 666:	03598363          	beq	s3,s5,68c <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 66a:	0019079b          	addiw	a5,s2,1
 66e:	893e                	mv	s2,a5
 670:	873e                	mv	a4,a5
 672:	97d2                	add	a5,a5,s4
 674:	0007c483          	lbu	s1,0(a5)
 678:	1c048a63          	beqz	s1,84c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 67c:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 680:	fe0993e3          	bnez	s3,666 <vprintf+0x40>
      if (c0 == '%') {
 684:	fd579ce3          	bne	a5,s5,65c <vprintf+0x36>
        state = '%';
 688:	89be                	mv	s3,a5
 68a:	b7c5                	j	66a <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 68c:	00ea06b3          	add	a3,s4,a4
 690:	0016c603          	lbu	a2,1(a3)
      if (c1)
 694:	1c060863          	beqz	a2,864 <vprintf+0x23e>
      if (c0 == 'd') {
 698:	03878763          	beq	a5,s8,6c6 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 69c:	f9478693          	addi	a3,a5,-108
 6a0:	0016b693          	seqz	a3,a3
 6a4:	f9c60593          	addi	a1,a2,-100
 6a8:	e99d                	bnez	a1,6de <vprintf+0xb8>
 6aa:	ca95                	beqz	a3,6de <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ac:	008b8493          	addi	s1,s7,8
 6b0:	4685                	li	a3,1
 6b2:	4629                	li	a2,10
 6b4:	000bb583          	ld	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	ecfff0ef          	jal	588 <printint>
        i += 1;
 6be:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c0:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b75d                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 6c6:	008b8493          	addi	s1,s7,8
 6ca:	4685                	li	a3,1
 6cc:	4629                	li	a2,10
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	eb5ff0ef          	jal	588 <printint>
 6d8:	8ba6                	mv	s7,s1
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b779                	j	66a <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 6de:	9752                	add	a4,a4,s4
 6e0:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6e4:	f9460713          	addi	a4,a2,-108
 6e8:	00173713          	seqz	a4,a4
 6ec:	8f75                	and	a4,a4,a3
 6ee:	f9c58513          	addi	a0,a1,-100
 6f2:	18051363          	bnez	a0,878 <vprintf+0x252>
 6f6:	18070163          	beqz	a4,878 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fa:	008b8493          	addi	s1,s7,8
 6fe:	4685                	li	a3,1
 700:	4629                	li	a2,10
 702:	000bb583          	ld	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	e81ff0ef          	jal	588 <printint>
        i += 2;
 70c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 70e:	8ba6                	mv	s7,s1
      state = 0;
 710:	4981                	li	s3,0
        i += 2;
 712:	bfa1                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 714:	008b8493          	addi	s1,s7,8
 718:	4681                	li	a3,0
 71a:	4629                	li	a2,10
 71c:	000be583          	lwu	a1,0(s7)
 720:	855a                	mv	a0,s6
 722:	e67ff0ef          	jal	588 <printint>
 726:	8ba6                	mv	s7,s1
      state = 0;
 728:	4981                	li	s3,0
 72a:	b781                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 72c:	008b8493          	addi	s1,s7,8
 730:	4681                	li	a3,0
 732:	4629                	li	a2,10
 734:	000bb583          	ld	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	e4fff0ef          	jal	588 <printint>
        i += 1;
 73e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 740:	8ba6                	mv	s7,s1
      state = 0;
 742:	4981                	li	s3,0
 744:	b71d                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 746:	008b8493          	addi	s1,s7,8
 74a:	4681                	li	a3,0
 74c:	4629                	li	a2,10
 74e:	000bb583          	ld	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	e35ff0ef          	jal	588 <printint>
        i += 2;
 758:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 75a:	8ba6                	mv	s7,s1
      state = 0;
 75c:	4981                	li	s3,0
        i += 2;
 75e:	b731                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 760:	008b8493          	addi	s1,s7,8
 764:	4681                	li	a3,0
 766:	4641                	li	a2,16
 768:	000be583          	lwu	a1,0(s7)
 76c:	855a                	mv	a0,s6
 76e:	e1bff0ef          	jal	588 <printint>
 772:	8ba6                	mv	s7,s1
      state = 0;
 774:	4981                	li	s3,0
 776:	bdd5                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 778:	008b8493          	addi	s1,s7,8
 77c:	4681                	li	a3,0
 77e:	4641                	li	a2,16
 780:	000bb583          	ld	a1,0(s7)
 784:	855a                	mv	a0,s6
 786:	e03ff0ef          	jal	588 <printint>
        i += 1;
 78a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 78c:	8ba6                	mv	s7,s1
      state = 0;
 78e:	4981                	li	s3,0
 790:	bde9                	j	66a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 792:	008b8493          	addi	s1,s7,8
 796:	4681                	li	a3,0
 798:	4641                	li	a2,16
 79a:	000bb583          	ld	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	de9ff0ef          	jal	588 <printint>
        i += 2;
 7a4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a6:	8ba6                	mv	s7,s1
      state = 0;
 7a8:	4981                	li	s3,0
        i += 2;
 7aa:	b5c1                	j	66a <vprintf+0x44>
 7ac:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 7ae:	008b8793          	addi	a5,s7,8
 7b2:	8cbe                	mv	s9,a5
 7b4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7b8:	03000593          	li	a1,48
 7bc:	855a                	mv	a0,s6
 7be:	dadff0ef          	jal	56a <putc>
  putc(fd, 'x');
 7c2:	07800593          	li	a1,120
 7c6:	855a                	mv	a0,s6
 7c8:	da3ff0ef          	jal	56a <putc>
 7cc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ce:	00000b97          	auipc	s7,0x0
 7d2:	472b8b93          	addi	s7,s7,1138 # c40 <digits>
 7d6:	03c9d793          	srli	a5,s3,0x3c
 7da:	97de                	add	a5,a5,s7
 7dc:	0007c583          	lbu	a1,0(a5)
 7e0:	855a                	mv	a0,s6
 7e2:	d89ff0ef          	jal	56a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e6:	0992                	slli	s3,s3,0x4
 7e8:	34fd                	addiw	s1,s1,-1
 7ea:	f4f5                	bnez	s1,7d6 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 7ec:	8be6                	mv	s7,s9
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	6ca2                	ld	s9,8(sp)
 7f2:	bda5                	j	66a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 7f4:	008b8493          	addi	s1,s7,8
 7f8:	000bc583          	lbu	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	d6dff0ef          	jal	56a <putc>
 802:	8ba6                	mv	s7,s1
      state = 0;
 804:	4981                	li	s3,0
 806:	b595                	j	66a <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 808:	008b8993          	addi	s3,s7,8
 80c:	000bb483          	ld	s1,0(s7)
 810:	cc91                	beqz	s1,82c <vprintf+0x206>
        for (; *s; s++)
 812:	0004c583          	lbu	a1,0(s1)
 816:	c985                	beqz	a1,846 <vprintf+0x220>
          putc(fd, *s);
 818:	855a                	mv	a0,s6
 81a:	d51ff0ef          	jal	56a <putc>
        for (; *s; s++)
 81e:	0485                	addi	s1,s1,1
 820:	0004c583          	lbu	a1,0(s1)
 824:	f9f5                	bnez	a1,818 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 826:	8bce                	mv	s7,s3
      state = 0;
 828:	4981                	li	s3,0
 82a:	b581                	j	66a <vprintf+0x44>
          s = "(null)";
 82c:	00000497          	auipc	s1,0x0
 830:	40c48493          	addi	s1,s1,1036 # c38 <malloc+0x270>
        for (; *s; s++)
 834:	02800593          	li	a1,40
 838:	b7c5                	j	818 <vprintf+0x1f2>
        putc(fd, '%');
 83a:	85be                	mv	a1,a5
 83c:	855a                	mv	a0,s6
 83e:	d2dff0ef          	jal	56a <putc>
      state = 0;
 842:	4981                	li	s3,0
 844:	b51d                	j	66a <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 846:	8bce                	mv	s7,s3
      state = 0;
 848:	4981                	li	s3,0
 84a:	b505                	j	66a <vprintf+0x44>
 84c:	6906                	ld	s2,64(sp)
 84e:	79e2                	ld	s3,56(sp)
 850:	7a42                	ld	s4,48(sp)
 852:	7aa2                	ld	s5,40(sp)
 854:	7b02                	ld	s6,32(sp)
 856:	6be2                	ld	s7,24(sp)
 858:	6c42                	ld	s8,16(sp)
    }
  }
}
 85a:	60e6                	ld	ra,88(sp)
 85c:	6446                	ld	s0,80(sp)
 85e:	64a6                	ld	s1,72(sp)
 860:	6125                	addi	sp,sp,96
 862:	8082                	ret
      if (c0 == 'd') {
 864:	06400713          	li	a4,100
 868:	e4e78fe3          	beq	a5,a4,6c6 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 86c:	f9478693          	addi	a3,a5,-108
 870:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 874:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 876:	4701                	li	a4,0
      } else if (c0 == 'u') {
 878:	07500513          	li	a0,117
 87c:	e8a78ce3          	beq	a5,a0,714 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 880:	f8b60513          	addi	a0,a2,-117
 884:	e119                	bnez	a0,88a <vprintf+0x264>
 886:	ea0693e3          	bnez	a3,72c <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 88a:	f8b58513          	addi	a0,a1,-117
 88e:	e119                	bnez	a0,894 <vprintf+0x26e>
 890:	ea071be3          	bnez	a4,746 <vprintf+0x120>
      } else if (c0 == 'x') {
 894:	07800513          	li	a0,120
 898:	eca784e3          	beq	a5,a0,760 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 89c:	f8860613          	addi	a2,a2,-120
 8a0:	e219                	bnez	a2,8a6 <vprintf+0x280>
 8a2:	ec069be3          	bnez	a3,778 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 8a6:	f8858593          	addi	a1,a1,-120
 8aa:	e199                	bnez	a1,8b0 <vprintf+0x28a>
 8ac:	ee0713e3          	bnez	a4,792 <vprintf+0x16c>
      } else if (c0 == 'p') {
 8b0:	07000713          	li	a4,112
 8b4:	eee78ce3          	beq	a5,a4,7ac <vprintf+0x186>
      } else if (c0 == 'c') {
 8b8:	06300713          	li	a4,99
 8bc:	f2e78ce3          	beq	a5,a4,7f4 <vprintf+0x1ce>
      } else if (c0 == 's') {
 8c0:	07300713          	li	a4,115
 8c4:	f4e782e3          	beq	a5,a4,808 <vprintf+0x1e2>
      } else if (c0 == '%') {
 8c8:	02500713          	li	a4,37
 8cc:	f6e787e3          	beq	a5,a4,83a <vprintf+0x214>
        putc(fd, '%');
 8d0:	02500593          	li	a1,37
 8d4:	855a                	mv	a0,s6
 8d6:	c95ff0ef          	jal	56a <putc>
        putc(fd, c0);
 8da:	85a6                	mv	a1,s1
 8dc:	855a                	mv	a0,s6
 8de:	c8dff0ef          	jal	56a <putc>
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	b359                	j	66a <vprintf+0x44>

00000000000008e6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e6:	715d                	addi	sp,sp,-80
 8e8:	ec06                	sd	ra,24(sp)
 8ea:	e822                	sd	s0,16(sp)
 8ec:	1000                	addi	s0,sp,32
 8ee:	e010                	sd	a2,0(s0)
 8f0:	e414                	sd	a3,8(s0)
 8f2:	e818                	sd	a4,16(s0)
 8f4:	ec1c                	sd	a5,24(s0)
 8f6:	03043023          	sd	a6,32(s0)
 8fa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8fe:	8622                	mv	a2,s0
 900:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 904:	d23ff0ef          	jal	626 <vprintf>
}
 908:	60e2                	ld	ra,24(sp)
 90a:	6442                	ld	s0,16(sp)
 90c:	6161                	addi	sp,sp,80
 90e:	8082                	ret

0000000000000910 <printf>:

void
printf(const char *fmt, ...)
{
 910:	711d                	addi	sp,sp,-96
 912:	ec06                	sd	ra,24(sp)
 914:	e822                	sd	s0,16(sp)
 916:	1000                	addi	s0,sp,32
 918:	e40c                	sd	a1,8(s0)
 91a:	e810                	sd	a2,16(s0)
 91c:	ec14                	sd	a3,24(s0)
 91e:	f018                	sd	a4,32(s0)
 920:	f41c                	sd	a5,40(s0)
 922:	03043823          	sd	a6,48(s0)
 926:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 92a:	00840613          	addi	a2,s0,8
 92e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 932:	85aa                	mv	a1,a0
 934:	4505                	li	a0,1
 936:	cf1ff0ef          	jal	626 <vprintf>
}
 93a:	60e2                	ld	ra,24(sp)
 93c:	6442                	ld	s0,16(sp)
 93e:	6125                	addi	sp,sp,96
 940:	8082                	ret

0000000000000942 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 942:	1141                	addi	sp,sp,-16
 944:	e406                	sd	ra,8(sp)
 946:	e022                	sd	s0,0(sp)
 948:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 94a:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94e:	00001797          	auipc	a5,0x1
 952:	6b27b783          	ld	a5,1714(a5) # 2000 <freep>
 956:	a039                	j	964 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 958:	6398                	ld	a4,0(a5)
 95a:	00e7e463          	bltu	a5,a4,962 <free+0x20>
 95e:	00e6ea63          	bltu	a3,a4,972 <free+0x30>
{
 962:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 964:	fed7fae3          	bgeu	a5,a3,958 <free+0x16>
 968:	6398                	ld	a4,0(a5)
 96a:	00e6e463          	bltu	a3,a4,972 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 96e:	fee7eae3          	bltu	a5,a4,962 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 972:	ff852583          	lw	a1,-8(a0)
 976:	6390                	ld	a2,0(a5)
 978:	02059813          	slli	a6,a1,0x20
 97c:	01c85713          	srli	a4,a6,0x1c
 980:	9736                	add	a4,a4,a3
 982:	02e60563          	beq	a2,a4,9ac <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 986:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 98a:	4790                	lw	a2,8(a5)
 98c:	02061593          	slli	a1,a2,0x20
 990:	01c5d713          	srli	a4,a1,0x1c
 994:	973e                	add	a4,a4,a5
 996:	02e68263          	beq	a3,a4,9ba <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 99a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 99c:	00001717          	auipc	a4,0x1
 9a0:	66f73223          	sd	a5,1636(a4) # 2000 <freep>
}
 9a4:	60a2                	ld	ra,8(sp)
 9a6:	6402                	ld	s0,0(sp)
 9a8:	0141                	addi	sp,sp,16
 9aa:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 9ac:	4618                	lw	a4,8(a2)
 9ae:	9f2d                	addw	a4,a4,a1
 9b0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b4:	6398                	ld	a4,0(a5)
 9b6:	6310                	ld	a2,0(a4)
 9b8:	b7f9                	j	986 <free+0x44>
    p->s.size += bp->s.size;
 9ba:	ff852703          	lw	a4,-8(a0)
 9be:	9f31                	addw	a4,a4,a2
 9c0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9c2:	ff053683          	ld	a3,-16(a0)
 9c6:	bfd1                	j	99a <free+0x58>

00000000000009c8 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 9c8:	7139                	addi	sp,sp,-64
 9ca:	fc06                	sd	ra,56(sp)
 9cc:	f822                	sd	s0,48(sp)
 9ce:	f04a                	sd	s2,32(sp)
 9d0:	ec4e                	sd	s3,24(sp)
 9d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9d4:	02051993          	slli	s3,a0,0x20
 9d8:	0209d993          	srli	s3,s3,0x20
 9dc:	09bd                	addi	s3,s3,15
 9de:	0049d993          	srli	s3,s3,0x4
 9e2:	2985                	addiw	s3,s3,1
 9e4:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 9e6:	00001517          	auipc	a0,0x1
 9ea:	61a53503          	ld	a0,1562(a0) # 2000 <freep>
 9ee:	c905                	beqz	a0,a1e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9f0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9f2:	4798                	lw	a4,8(a5)
 9f4:	09377663          	bgeu	a4,s3,a80 <malloc+0xb8>
 9f8:	f426                	sd	s1,40(sp)
 9fa:	e852                	sd	s4,16(sp)
 9fc:	e456                	sd	s5,8(sp)
 9fe:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 a00:	8a4e                	mv	s4,s3
 a02:	6705                	lui	a4,0x1
 a04:	00e9f363          	bgeu	s3,a4,a0a <malloc+0x42>
 a08:	6a05                	lui	s4,0x1
 a0a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a0e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 a12:	00001497          	auipc	s1,0x1
 a16:	5ee48493          	addi	s1,s1,1518 # 2000 <freep>
  if (p == SBRK_ERROR)
 a1a:	5afd                	li	s5,-1
 a1c:	a83d                	j	a5a <malloc+0x92>
 a1e:	f426                	sd	s1,40(sp)
 a20:	e852                	sd	s4,16(sp)
 a22:	e456                	sd	s5,8(sp)
 a24:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a26:	00001797          	auipc	a5,0x1
 a2a:	5ea78793          	addi	a5,a5,1514 # 2010 <base>
 a2e:	00001717          	auipc	a4,0x1
 a32:	5cf73923          	sd	a5,1490(a4) # 2000 <freep>
 a36:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a38:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 a3c:	b7d1                	j	a00 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a3e:	6398                	ld	a4,0(a5)
 a40:	e118                	sd	a4,0(a0)
 a42:	a899                	j	a98 <malloc+0xd0>
  hp->s.size = nu;
 a44:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 a48:	0541                	addi	a0,a0,16
 a4a:	ef9ff0ef          	jal	942 <free>
  return freep;
 a4e:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 a50:	c125                	beqz	a0,ab0 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a52:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a54:	4798                	lw	a4,8(a5)
 a56:	03277163          	bgeu	a4,s2,a78 <malloc+0xb0>
    if (p == freep)
 a5a:	6098                	ld	a4,0(s1)
 a5c:	853e                	mv	a0,a5
 a5e:	fef71ae3          	bne	a4,a5,a52 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a62:	8552                	mv	a0,s4
 a64:	9fbff0ef          	jal	45e <sbrk>
  if (p == SBRK_ERROR)
 a68:	fd551ee3          	bne	a0,s5,a44 <malloc+0x7c>
        return 0;
 a6c:	4501                	li	a0,0
 a6e:	74a2                	ld	s1,40(sp)
 a70:	6a42                	ld	s4,16(sp)
 a72:	6aa2                	ld	s5,8(sp)
 a74:	6b02                	ld	s6,0(sp)
 a76:	a03d                	j	aa4 <malloc+0xdc>
 a78:	74a2                	ld	s1,40(sp)
 a7a:	6a42                	ld	s4,16(sp)
 a7c:	6aa2                	ld	s5,8(sp)
 a7e:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 a80:	fae90fe3          	beq	s2,a4,a3e <malloc+0x76>
        p->s.size -= nunits;
 a84:	4137073b          	subw	a4,a4,s3
 a88:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a8a:	02071693          	slli	a3,a4,0x20
 a8e:	01c6d713          	srli	a4,a3,0x1c
 a92:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a94:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a98:	00001717          	auipc	a4,0x1
 a9c:	56a73423          	sd	a0,1384(a4) # 2000 <freep>
      return (void *)(p + 1);
 aa0:	01078513          	addi	a0,a5,16
  }
}
 aa4:	70e2                	ld	ra,56(sp)
 aa6:	7442                	ld	s0,48(sp)
 aa8:	7902                	ld	s2,32(sp)
 aaa:	69e2                	ld	s3,24(sp)
 aac:	6121                	addi	sp,sp,64
 aae:	8082                	ret
 ab0:	74a2                	ld	s1,40(sp)
 ab2:	6a42                	ld	s4,16(sp)
 ab4:	6aa2                	ld	s5,8(sp)
 ab6:	6b02                	ld	s6,0(sp)
 ab8:	b7f5                	j	aa4 <malloc+0xdc>
