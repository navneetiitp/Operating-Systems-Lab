
user/_peterson:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
  asm volatile("fence rw, rw" ::: "memory");
}

int
main(void)
{
   0:	711d                	addi	sp,sp,-96
   2:	ec86                	sd	ra,88(sp)
   4:	e8a2                	sd	s0,80(sp)
   6:	e4a6                	sd	s1,72(sp)
   8:	e0ca                	sd	s2,64(sp)
   a:	fc4e                	sd	s3,56(sp)
   c:	f852                	sd	s4,48(sp)
   e:	f456                	sd	s5,40(sp)
  10:	f05a                	sd	s6,32(sp)
  12:	ec5e                	sd	s7,24(sp)
  14:	e862                	sd	s8,16(sp)
  16:	e466                	sd	s9,8(sp)
  18:	e06a                	sd	s10,0(sp)
  1a:	1080                	addi	s0,sp,96
  int pid;
  int id;
  int other;
  int i;

  shm = (volatile struct shared_data *)shm_get();
  1c:	470000ef          	jal	48c <shm_get>

  if (shm == (void *)-1) {
  20:	57fd                	li	a5,-1
  22:	04f50363          	beq	a0,a5,68 <main+0x68>
  26:	84aa                	mv	s1,a0
    printf("shm_get failed\n");
    exit(1);
  }

  shm->flag[0] = 0;
  28:	00052023          	sw	zero,0(a0)
  shm->flag[1] = 0;
  2c:	00052223          	sw	zero,4(a0)
  shm->turn = 0;
  30:	00052423          	sw	zero,8(a0)
  shm->counter = 0;
  34:	00052623          	sw	zero,12(a0)
  asm volatile("fence rw, rw" ::: "memory");
  38:	0330000f          	fence	rw,rw

  memory_fence();

  pid = fork();
  3c:	378000ef          	jal	3b4 <fork>
  40:	8d2a                	mv	s10,a0

  if (pid < 0) {
  42:	02054c63          	bltz	a0,7a <main+0x7a>
    printf("fork failed\n");
    exit(1);
  }

  if (pid == 0) {
  46:	e139                	bnez	a0,8c <main+0x8c>
    id = 1;
    other = 0;
  48:	892a                	mv	s2,a0
    id = 1;
  4a:	4b85                	li	s7,1
  } else {
    id = 0;
  4c:	4a29                	li	s4,10
  4e:	002b9a93          	slli	s5,s7,0x2
  52:	9aa6                	add	s5,s5,s1
  }

  for (i = 0; i < ITERATIONS; i++) {

    /* Peterson entry section */
    shm->flag[id] = 1;
  54:	4b05                	li	s6,1
  56:	8cda                	mv	s9,s6
    shm->turn = other;
    memory_fence();

    while (shm->flag[other] && shm->turn == other)
  58:	00291993          	slli	s3,s2,0x2
  5c:	99a6                	add	s3,s3,s1
    memory_fence();

    /* Critical section */
    shm->counter++;

    printf("Process %d in CS, counter = %d\n",
  5e:	00001c17          	auipc	s8,0x1
  62:	9b2c0c13          	addi	s8,s8,-1614 # a10 <malloc+0x11e>
  66:	a8b9                	j	c4 <main+0xc4>
    printf("shm_get failed\n");
  68:	00001517          	auipc	a0,0x1
  6c:	98850513          	addi	a0,a0,-1656 # 9f0 <malloc+0xfe>
  70:	7ca000ef          	jal	83a <printf>
    exit(1);
  74:	4505                	li	a0,1
  76:	346000ef          	jal	3bc <exit>
    printf("fork failed\n");
  7a:	00001517          	auipc	a0,0x1
  7e:	98650513          	addi	a0,a0,-1658 # a00 <malloc+0x10e>
  82:	7b8000ef          	jal	83a <printf>
    exit(1);
  86:	4505                	li	a0,1
  88:	334000ef          	jal	3bc <exit>
    other = 1;
  8c:	4905                	li	s2,1
    id = 0;
  8e:	4b81                	li	s7,0
  90:	bf75                	j	4c <main+0x4c>
  asm volatile("fence rw, rw" ::: "memory");
  92:	0330000f          	fence	rw,rw
    shm->counter++;
  96:	44dc                	lw	a5,12(s1)
  98:	2785                	addiw	a5,a5,1
  9a:	c4dc                	sw	a5,12(s1)
           id, shm->counter);
  9c:	44d0                	lw	a2,12(s1)
    printf("Process %d in CS, counter = %d\n",
  9e:	85de                	mv	a1,s7
  a0:	8562                	mv	a0,s8
  a2:	798000ef          	jal	83a <printf>

    pause(1);
  a6:	855a                	mv	a0,s6
  a8:	3cc000ef          	jal	474 <pause>
  asm volatile("fence rw, rw" ::: "memory");
  ac:	0330000f          	fence	rw,rw

    /* Peterson exit section */
    memory_fence();
    shm->flag[id] = 0;
  b0:	000aa023          	sw	zero,0(s5)
  asm volatile("fence rw, rw" ::: "memory");
  b4:	0330000f          	fence	rw,rw
    memory_fence();

    pause(1);
  b8:	855a                	mv	a0,s6
  ba:	3ba000ef          	jal	474 <pause>
  for (i = 0; i < ITERATIONS; i++) {
  be:	3a7d                	addiw	s4,s4,-1
  c0:	020a0163          	beqz	s4,e2 <main+0xe2>
    shm->flag[id] = 1;
  c4:	019aa023          	sw	s9,0(s5)
    shm->turn = other;
  c8:	0124a423          	sw	s2,8(s1)
  asm volatile("fence rw, rw" ::: "memory");
  cc:	0330000f          	fence	rw,rw
    while (shm->flag[other] && shm->turn == other)
  d0:	0009a783          	lw	a5,0(s3)
  d4:	2781                	sext.w	a5,a5
  d6:	dfd5                	beqz	a5,92 <main+0x92>
  d8:	449c                	lw	a5,8(s1)
  da:	2781                	sext.w	a5,a5
  dc:	ff278ae3          	beq	a5,s2,d0 <main+0xd0>
  e0:	bf4d                	j	92 <main+0x92>
  }

  if (pid != 0) {
  e2:	000d1563          	bnez	s10,ec <main+0xec>
    wait(0);
    memory_fence();
    printf("Final counter = %d\n", shm->counter);
  }

  exit(0);
  e6:	4501                	li	a0,0
  e8:	2d4000ef          	jal	3bc <exit>
    wait(0);
  ec:	4501                	li	a0,0
  ee:	2d6000ef          	jal	3c4 <wait>
  asm volatile("fence rw, rw" ::: "memory");
  f2:	0330000f          	fence	rw,rw
    printf("Final counter = %d\n", shm->counter);
  f6:	44cc                	lw	a1,12(s1)
  f8:	00001517          	auipc	a0,0x1
  fc:	93850513          	addi	a0,a0,-1736 # a30 <malloc+0x13e>
 100:	73a000ef          	jal	83a <printf>
 104:	b7cd                	j	e6 <main+0xe6>

0000000000000106 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 10e:	ef3ff0ef          	jal	0 <main>
  exit(r);
 112:	2aa000ef          	jal	3bc <exit>

0000000000000116 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 116:	1141                	addi	sp,sp,-16
 118:	e406                	sd	ra,8(sp)
 11a:	e022                	sd	s0,0(sp)
 11c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 11e:	87aa                	mv	a5,a0
 120:	0585                	addi	a1,a1,1
 122:	0785                	addi	a5,a5,1
 124:	fff5c703          	lbu	a4,-1(a1)
 128:	fee78fa3          	sb	a4,-1(a5)
 12c:	fb75                	bnez	a4,120 <strcpy+0xa>
    ;
  return os;
}
 12e:	60a2                	ld	ra,8(sp)
 130:	6402                	ld	s0,0(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret

0000000000000136 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 136:	1141                	addi	sp,sp,-16
 138:	e406                	sd	ra,8(sp)
 13a:	e022                	sd	s0,0(sp)
 13c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 13e:	00054783          	lbu	a5,0(a0)
 142:	cb91                	beqz	a5,156 <strcmp+0x20>
 144:	0005c703          	lbu	a4,0(a1)
 148:	00f71763          	bne	a4,a5,156 <strcmp+0x20>
    p++, q++;
 14c:	0505                	addi	a0,a0,1
 14e:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 150:	00054783          	lbu	a5,0(a0)
 154:	fbe5                	bnez	a5,144 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 156:	0005c503          	lbu	a0,0(a1)
}
 15a:	40a7853b          	subw	a0,a5,a0
 15e:	60a2                	ld	ra,8(sp)
 160:	6402                	ld	s0,0(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strlen>:

uint
strlen(const char *s)
{
 166:	1141                	addi	sp,sp,-16
 168:	e406                	sd	ra,8(sp)
 16a:	e022                	sd	s0,0(sp)
 16c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 16e:	00054783          	lbu	a5,0(a0)
 172:	cf91                	beqz	a5,18e <strlen+0x28>
 174:	00150793          	addi	a5,a0,1
 178:	86be                	mv	a3,a5
 17a:	0785                	addi	a5,a5,1
 17c:	fff7c703          	lbu	a4,-1(a5)
 180:	ff65                	bnez	a4,178 <strlen+0x12>
 182:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 186:	60a2                	ld	ra,8(sp)
 188:	6402                	ld	s0,0(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret
  for (n = 0; s[n]; n++)
 18e:	4501                	li	a0,0
 190:	bfdd                	j	186 <strlen+0x20>

0000000000000192 <memset>:

void *
memset(void *dst, int c, uint n)
{
 192:	1141                	addi	sp,sp,-16
 194:	e406                	sd	ra,8(sp)
 196:	e022                	sd	s0,0(sp)
 198:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 19a:	ca19                	beqz	a2,1b0 <memset+0x1e>
 19c:	87aa                	mv	a5,a0
 19e:	1602                	slli	a2,a2,0x20
 1a0:	9201                	srli	a2,a2,0x20
 1a2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a6:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 1aa:	0785                	addi	a5,a5,1
 1ac:	fee79de3          	bne	a5,a4,1a6 <memset+0x14>
  }
  return dst;
}
 1b0:	60a2                	ld	ra,8(sp)
 1b2:	6402                	ld	s0,0(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret

00000000000001b8 <strchr>:

char *
strchr(const char *s, char c)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e406                	sd	ra,8(sp)
 1bc:	e022                	sd	s0,0(sp)
 1be:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cf81                	beqz	a5,1dc <strchr+0x24>
    if (*s == c)
 1c6:	00f58763          	beq	a1,a5,1d4 <strchr+0x1c>
  for (; *s; s++)
 1ca:	0505                	addi	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	fbfd                	bnez	a5,1c6 <strchr+0xe>
      return (char *)s;
  return 0;
 1d2:	4501                	li	a0,0
}
 1d4:	60a2                	ld	ra,8(sp)
 1d6:	6402                	ld	s0,0(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret
  return 0;
 1dc:	4501                	li	a0,0
 1de:	bfdd                	j	1d4 <strchr+0x1c>

00000000000001e0 <gets>:

char *
gets(char *buf, int max)
{
 1e0:	711d                	addi	sp,sp,-96
 1e2:	ec86                	sd	ra,88(sp)
 1e4:	e8a2                	sd	s0,80(sp)
 1e6:	e4a6                	sd	s1,72(sp)
 1e8:	e0ca                	sd	s2,64(sp)
 1ea:	fc4e                	sd	s3,56(sp)
 1ec:	f852                	sd	s4,48(sp)
 1ee:	f456                	sd	s5,40(sp)
 1f0:	f05a                	sd	s6,32(sp)
 1f2:	ec5e                	sd	s7,24(sp)
 1f4:	e862                	sd	s8,16(sp)
 1f6:	1080                	addi	s0,sp,96
 1f8:	8baa                	mv	s7,a0
 1fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1fc:	892a                	mv	s2,a0
 1fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
 200:	faf40b13          	addi	s6,s0,-81
 204:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 206:	8c26                	mv	s8,s1
 208:	0014899b          	addiw	s3,s1,1
 20c:	84ce                	mv	s1,s3
 20e:	0349d463          	bge	s3,s4,236 <gets+0x56>
    cc = read(0, &c, 1);
 212:	8656                	mv	a2,s5
 214:	85da                	mv	a1,s6
 216:	4501                	li	a0,0
 218:	1c4000ef          	jal	3dc <read>
    if (cc < 1)
 21c:	00a05d63          	blez	a0,236 <gets+0x56>
      break;
    buf[i++] = c;
 220:	faf44783          	lbu	a5,-81(s0)
 224:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 228:	0905                	addi	s2,s2,1
 22a:	ff678713          	addi	a4,a5,-10
 22e:	c319                	beqz	a4,234 <gets+0x54>
 230:	17cd                	addi	a5,a5,-13
 232:	fbf1                	bnez	a5,206 <gets+0x26>
    buf[i++] = c;
 234:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 236:	9c5e                	add	s8,s8,s7
 238:	000c0023          	sb	zero,0(s8)
  return buf;
}
 23c:	855e                	mv	a0,s7
 23e:	60e6                	ld	ra,88(sp)
 240:	6446                	ld	s0,80(sp)
 242:	64a6                	ld	s1,72(sp)
 244:	6906                	ld	s2,64(sp)
 246:	79e2                	ld	s3,56(sp)
 248:	7a42                	ld	s4,48(sp)
 24a:	7aa2                	ld	s5,40(sp)
 24c:	7b02                	ld	s6,32(sp)
 24e:	6be2                	ld	s7,24(sp)
 250:	6c42                	ld	s8,16(sp)
 252:	6125                	addi	sp,sp,96
 254:	8082                	ret

0000000000000256 <stat>:

int
stat(const char *n, struct stat *st)
{
 256:	1101                	addi	sp,sp,-32
 258:	ec06                	sd	ra,24(sp)
 25a:	e822                	sd	s0,16(sp)
 25c:	e04a                	sd	s2,0(sp)
 25e:	1000                	addi	s0,sp,32
 260:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 262:	4581                	li	a1,0
 264:	1c0000ef          	jal	424 <open>
  if (fd < 0)
 268:	02054263          	bltz	a0,28c <stat+0x36>
 26c:	e426                	sd	s1,8(sp)
 26e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	1ca000ef          	jal	43c <fstat>
 276:	892a                	mv	s2,a0
  close(fd);
 278:	8526                	mv	a0,s1
 27a:	192000ef          	jal	40c <close>
  return r;
 27e:	64a2                	ld	s1,8(sp)
}
 280:	854a                	mv	a0,s2
 282:	60e2                	ld	ra,24(sp)
 284:	6442                	ld	s0,16(sp)
 286:	6902                	ld	s2,0(sp)
 288:	6105                	addi	sp,sp,32
 28a:	8082                	ret
    return -1;
 28c:	57fd                	li	a5,-1
 28e:	893e                	mv	s2,a5
 290:	bfc5                	j	280 <stat+0x2a>

0000000000000292 <atoi>:

int
atoi(const char *s)
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 29a:	00054683          	lbu	a3,0(a0)
 29e:	fd06879b          	addiw	a5,a3,-48
 2a2:	0ff7f793          	zext.b	a5,a5
 2a6:	4625                	li	a2,9
 2a8:	02f66963          	bltu	a2,a5,2da <atoi+0x48>
 2ac:	872a                	mv	a4,a0
  n = 0;
 2ae:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 2b0:	0705                	addi	a4,a4,1
 2b2:	0025179b          	slliw	a5,a0,0x2
 2b6:	9fa9                	addw	a5,a5,a0
 2b8:	0017979b          	slliw	a5,a5,0x1
 2bc:	9fb5                	addw	a5,a5,a3
 2be:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2c2:	00074683          	lbu	a3,0(a4)
 2c6:	fd06879b          	addiw	a5,a3,-48
 2ca:	0ff7f793          	zext.b	a5,a5
 2ce:	fef671e3          	bgeu	a2,a5,2b0 <atoi+0x1e>
  return n;
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  n = 0;
 2da:	4501                	li	a0,0
 2dc:	bfdd                	j	2d2 <atoi+0x40>

00000000000002de <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e6:	02b57563          	bgeu	a0,a1,310 <memmove+0x32>
    while (n-- > 0)
 2ea:	00c05f63          	blez	a2,308 <memmove+0x2a>
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f8:	0585                	addi	a1,a1,1
 2fa:	0705                	addi	a4,a4,1
 2fc:	fff5c683          	lbu	a3,-1(a1)
 300:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
    while (n-- > 0)
 310:	fec05ce3          	blez	a2,308 <memmove+0x2a>
    dst += n;
 314:	00c50733          	add	a4,a0,a2
    src += n;
 318:	95b2                	add	a1,a1,a2
 31a:	fff6079b          	addiw	a5,a2,-1
 31e:	1782                	slli	a5,a5,0x20
 320:	9381                	srli	a5,a5,0x20
 322:	fff7c793          	not	a5,a5
 326:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 328:	15fd                	addi	a1,a1,-1
 32a:	177d                	addi	a4,a4,-1
 32c:	0005c683          	lbu	a3,0(a1)
 330:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 334:	fef71ae3          	bne	a4,a5,328 <memmove+0x4a>
 338:	bfc1                	j	308 <memmove+0x2a>

000000000000033a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 342:	c61d                	beqz	a2,370 <memcmp+0x36>
 344:	1602                	slli	a2,a2,0x20
 346:	9201                	srli	a2,a2,0x20
 348:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 34c:	00054783          	lbu	a5,0(a0)
 350:	0005c703          	lbu	a4,0(a1)
 354:	00e79863          	bne	a5,a4,364 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 358:	0505                	addi	a0,a0,1
    p2++;
 35a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35c:	fed518e3          	bne	a0,a3,34c <memcmp+0x12>
  }
  return 0;
 360:	4501                	li	a0,0
 362:	a019                	j	368 <memcmp+0x2e>
      return *p1 - *p2;
 364:	40e7853b          	subw	a0,a5,a4
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
  return 0;
 370:	4501                	li	a0,0
 372:	bfdd                	j	368 <memcmp+0x2e>

0000000000000374 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 374:	1141                	addi	sp,sp,-16
 376:	e406                	sd	ra,8(sp)
 378:	e022                	sd	s0,0(sp)
 37a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37c:	f63ff0ef          	jal	2de <memmove>
}
 380:	60a2                	ld	ra,8(sp)
 382:	6402                	ld	s0,0(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret

0000000000000388 <sbrk>:

char *
sbrk(int n)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e406                	sd	ra,8(sp)
 38c:	e022                	sd	s0,0(sp)
 38e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 390:	4585                	li	a1,1
 392:	0da000ef          	jal	46c <sys_sbrk>
}
 396:	60a2                	ld	ra,8(sp)
 398:	6402                	ld	s0,0(sp)
 39a:	0141                	addi	sp,sp,16
 39c:	8082                	ret

000000000000039e <sbrklazy>:

char *
sbrklazy(int n)
{
 39e:	1141                	addi	sp,sp,-16
 3a0:	e406                	sd	ra,8(sp)
 3a2:	e022                	sd	s0,0(sp)
 3a4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3a6:	4589                	li	a1,2
 3a8:	0c4000ef          	jal	46c <sys_sbrk>
}
 3ac:	60a2                	ld	ra,8(sp)
 3ae:	6402                	ld	s0,0(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret

00000000000003b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b4:	4885                	li	a7,1
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 3bc:	4889                	li	a7,2
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c4:	488d                	li	a7,3
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3cc:	48b5                	li	a7,13
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d4:	4891                	li	a7,4
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <read>:
.global read
read:
 li a7, SYS_read
 3dc:	4895                	li	a7,5
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <write>:
.global write
write:
 li a7, SYS_write
 3e4:	48c1                	li	a7,16
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <sem_create>:
.global sem_create
sem_create:
 li a7, SYS_sem_create
 3ec:	48e1                	li	a7,24
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <sem_wait>:
.global sem_wait
sem_wait:
 li a7, SYS_sem_wait
 3f4:	48e5                	li	a7,25
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <sem_signal>:
.global sem_signal
sem_signal:
 li a7, SYS_sem_signal
 3fc:	48e9                	li	a7,26
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <sem_free>:
.global sem_free
sem_free:
 li a7, SYS_sem_free
 404:	48ed                	li	a7,27
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <close>:
.global close
close:
 li a7, SYS_close
 40c:	48d5                	li	a7,21
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <kill>:
.global kill
kill:
 li a7, SYS_kill
 414:	4899                	li	a7,6
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <exec>:
.global exec
exec:
 li a7, SYS_exec
 41c:	489d                	li	a7,7
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <open>:
.global open
open:
 li a7, SYS_open
 424:	48bd                	li	a7,15
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 42c:	48c5                	li	a7,17
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 434:	48c9                	li	a7,18
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 43c:	48a1                	li	a7,8
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <link>:
.global link
link:
 li a7, SYS_link
 444:	48cd                	li	a7,19
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 44c:	48d1                	li	a7,20
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 454:	48a5                	li	a7,9
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <dup>:
.global dup
dup:
 li a7, SYS_dup
 45c:	48a9                	li	a7,10
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 464:	48ad                	li	a7,11
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 46c:	48b1                	li	a7,12
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <pause>:
.global pause
pause:
 li a7, SYS_pause
 474:	48b5                	li	a7,13
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 47c:	48b9                	li	a7,14
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <sync>:
.global sync
sync:
 li a7, SYS_sync
 484:	48d9                	li	a7,22
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <shm_get>:
.global shm_get
shm_get:
 li a7, SYS_shm_get
 48c:	48dd                	li	a7,23
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 494:	1101                	addi	sp,sp,-32
 496:	ec06                	sd	ra,24(sp)
 498:	e822                	sd	s0,16(sp)
 49a:	1000                	addi	s0,sp,32
 49c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a0:	4605                	li	a2,1
 4a2:	fef40593          	addi	a1,s0,-17
 4a6:	f3fff0ef          	jal	3e4 <write>
}
 4aa:	60e2                	ld	ra,24(sp)
 4ac:	6442                	ld	s0,16(sp)
 4ae:	6105                	addi	sp,sp,32
 4b0:	8082                	ret

00000000000004b2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4b2:	715d                	addi	sp,sp,-80
 4b4:	e486                	sd	ra,72(sp)
 4b6:	e0a2                	sd	s0,64(sp)
 4b8:	f84a                	sd	s2,48(sp)
 4ba:	f44e                	sd	s3,40(sp)
 4bc:	0880                	addi	s0,sp,80
 4be:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 4c0:	c6d1                	beqz	a3,54c <printint+0x9a>
 4c2:	0805d563          	bgez	a1,54c <printint+0x9a>
    neg = 1;
    x = -xx;
 4c6:	40b005b3          	neg	a1,a1
    neg = 1;
 4ca:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4cc:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4d0:	86ce                	mv	a3,s3
  i = 0;
 4d2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 4d4:	00000817          	auipc	a6,0x0
 4d8:	57c80813          	addi	a6,a6,1404 # a50 <digits>
 4dc:	88ba                	mv	a7,a4
 4de:	0017051b          	addiw	a0,a4,1
 4e2:	872a                	mv	a4,a0
 4e4:	02c5f7b3          	remu	a5,a1,a2
 4e8:	97c2                	add	a5,a5,a6
 4ea:	0007c783          	lbu	a5,0(a5)
 4ee:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4f2:	87ae                	mv	a5,a1
 4f4:	02c5d5b3          	divu	a1,a1,a2
 4f8:	0685                	addi	a3,a3,1
 4fa:	fec7f1e3          	bgeu	a5,a2,4dc <printint+0x2a>
  if (neg)
 4fe:	00030c63          	beqz	t1,516 <printint+0x64>
    buf[i++] = '-';
 502:	fd050793          	addi	a5,a0,-48
 506:	00878533          	add	a0,a5,s0
 50a:	02d00793          	li	a5,45
 50e:	fef50423          	sb	a5,-24(a0)
 512:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 516:	02e05563          	blez	a4,540 <printint+0x8e>
 51a:	fc26                	sd	s1,56(sp)
 51c:	377d                	addiw	a4,a4,-1
 51e:	00e984b3          	add	s1,s3,a4
 522:	19fd                	addi	s3,s3,-1
 524:	99ba                	add	s3,s3,a4
 526:	1702                	slli	a4,a4,0x20
 528:	9301                	srli	a4,a4,0x20
 52a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 52e:	0004c583          	lbu	a1,0(s1)
 532:	854a                	mv	a0,s2
 534:	f61ff0ef          	jal	494 <putc>
  while (--i >= 0)
 538:	14fd                	addi	s1,s1,-1
 53a:	ff349ae3          	bne	s1,s3,52e <printint+0x7c>
 53e:	74e2                	ld	s1,56(sp)
}
 540:	60a6                	ld	ra,72(sp)
 542:	6406                	ld	s0,64(sp)
 544:	7942                	ld	s2,48(sp)
 546:	79a2                	ld	s3,40(sp)
 548:	6161                	addi	sp,sp,80
 54a:	8082                	ret
  neg = 0;
 54c:	4301                	li	t1,0
 54e:	bfbd                	j	4cc <printint+0x1a>

0000000000000550 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 550:	711d                	addi	sp,sp,-96
 552:	ec86                	sd	ra,88(sp)
 554:	e8a2                	sd	s0,80(sp)
 556:	e4a6                	sd	s1,72(sp)
 558:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 55a:	0005c483          	lbu	s1,0(a1)
 55e:	22048363          	beqz	s1,784 <vprintf+0x234>
 562:	e0ca                	sd	s2,64(sp)
 564:	fc4e                	sd	s3,56(sp)
 566:	f852                	sd	s4,48(sp)
 568:	f456                	sd	s5,40(sp)
 56a:	f05a                	sd	s6,32(sp)
 56c:	ec5e                	sd	s7,24(sp)
 56e:	e862                	sd	s8,16(sp)
 570:	8b2a                	mv	s6,a0
 572:	8a2e                	mv	s4,a1
 574:	8bb2                	mv	s7,a2
  state = 0;
 576:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 578:	4901                	li	s2,0
 57a:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 57c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 580:	06400c13          	li	s8,100
 584:	a00d                	j	5a6 <vprintf+0x56>
        putc(fd, c0);
 586:	85a6                	mv	a1,s1
 588:	855a                	mv	a0,s6
 58a:	f0bff0ef          	jal	494 <putc>
 58e:	a019                	j	594 <vprintf+0x44>
    } else if (state == '%') {
 590:	03598363          	beq	s3,s5,5b6 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 594:	0019079b          	addiw	a5,s2,1
 598:	893e                	mv	s2,a5
 59a:	873e                	mv	a4,a5
 59c:	97d2                	add	a5,a5,s4
 59e:	0007c483          	lbu	s1,0(a5)
 5a2:	1c048a63          	beqz	s1,776 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 5a6:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 5aa:	fe0993e3          	bnez	s3,590 <vprintf+0x40>
      if (c0 == '%') {
 5ae:	fd579ce3          	bne	a5,s5,586 <vprintf+0x36>
        state = '%';
 5b2:	89be                	mv	s3,a5
 5b4:	b7c5                	j	594 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 5b6:	00ea06b3          	add	a3,s4,a4
 5ba:	0016c603          	lbu	a2,1(a3)
      if (c1)
 5be:	1c060863          	beqz	a2,78e <vprintf+0x23e>
      if (c0 == 'd') {
 5c2:	03878763          	beq	a5,s8,5f0 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5c6:	f9478693          	addi	a3,a5,-108
 5ca:	0016b693          	seqz	a3,a3
 5ce:	f9c60593          	addi	a1,a2,-100
 5d2:	e99d                	bnez	a1,608 <vprintf+0xb8>
 5d4:	ca95                	beqz	a3,608 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4685                	li	a3,1
 5dc:	4629                	li	a2,10
 5de:	000bb583          	ld	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	ecfff0ef          	jal	4b2 <printint>
        i += 1;
 5e8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ea:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b75d                	j	594 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4685                	li	a3,1
 5f6:	4629                	li	a2,10
 5f8:	000ba583          	lw	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	eb5ff0ef          	jal	4b2 <printint>
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
 606:	b779                	j	594 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 608:	9752                	add	a4,a4,s4
 60a:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 60e:	f9460713          	addi	a4,a2,-108
 612:	00173713          	seqz	a4,a4
 616:	8f75                	and	a4,a4,a3
 618:	f9c58513          	addi	a0,a1,-100
 61c:	18051363          	bnez	a0,7a2 <vprintf+0x252>
 620:	18070163          	beqz	a4,7a2 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 624:	008b8493          	addi	s1,s7,8
 628:	4685                	li	a3,1
 62a:	4629                	li	a2,10
 62c:	000bb583          	ld	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	e81ff0ef          	jal	4b2 <printint>
        i += 2;
 636:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 638:	8ba6                	mv	s7,s1
      state = 0;
 63a:	4981                	li	s3,0
        i += 2;
 63c:	bfa1                	j	594 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 63e:	008b8493          	addi	s1,s7,8
 642:	4681                	li	a3,0
 644:	4629                	li	a2,10
 646:	000be583          	lwu	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	e67ff0ef          	jal	4b2 <printint>
 650:	8ba6                	mv	s7,s1
      state = 0;
 652:	4981                	li	s3,0
 654:	b781                	j	594 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 656:	008b8493          	addi	s1,s7,8
 65a:	4681                	li	a3,0
 65c:	4629                	li	a2,10
 65e:	000bb583          	ld	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	e4fff0ef          	jal	4b2 <printint>
        i += 1;
 668:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 66a:	8ba6                	mv	s7,s1
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b71d                	j	594 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 670:	008b8493          	addi	s1,s7,8
 674:	4681                	li	a3,0
 676:	4629                	li	a2,10
 678:	000bb583          	ld	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	e35ff0ef          	jal	4b2 <printint>
        i += 2;
 682:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 684:	8ba6                	mv	s7,s1
      state = 0;
 686:	4981                	li	s3,0
        i += 2;
 688:	b731                	j	594 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 68a:	008b8493          	addi	s1,s7,8
 68e:	4681                	li	a3,0
 690:	4641                	li	a2,16
 692:	000be583          	lwu	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	e1bff0ef          	jal	4b2 <printint>
 69c:	8ba6                	mv	s7,s1
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	bdd5                	j	594 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a2:	008b8493          	addi	s1,s7,8
 6a6:	4681                	li	a3,0
 6a8:	4641                	li	a2,16
 6aa:	000bb583          	ld	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	e03ff0ef          	jal	4b2 <printint>
        i += 1;
 6b4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b6:	8ba6                	mv	s7,s1
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bde9                	j	594 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6bc:	008b8493          	addi	s1,s7,8
 6c0:	4681                	li	a3,0
 6c2:	4641                	li	a2,16
 6c4:	000bb583          	ld	a1,0(s7)
 6c8:	855a                	mv	a0,s6
 6ca:	de9ff0ef          	jal	4b2 <printint>
        i += 2;
 6ce:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d0:	8ba6                	mv	s7,s1
      state = 0;
 6d2:	4981                	li	s3,0
        i += 2;
 6d4:	b5c1                	j	594 <vprintf+0x44>
 6d6:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6d8:	008b8793          	addi	a5,s7,8
 6dc:	8cbe                	mv	s9,a5
 6de:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e2:	03000593          	li	a1,48
 6e6:	855a                	mv	a0,s6
 6e8:	dadff0ef          	jal	494 <putc>
  putc(fd, 'x');
 6ec:	07800593          	li	a1,120
 6f0:	855a                	mv	a0,s6
 6f2:	da3ff0ef          	jal	494 <putc>
 6f6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f8:	00000b97          	auipc	s7,0x0
 6fc:	358b8b93          	addi	s7,s7,856 # a50 <digits>
 700:	03c9d793          	srli	a5,s3,0x3c
 704:	97de                	add	a5,a5,s7
 706:	0007c583          	lbu	a1,0(a5)
 70a:	855a                	mv	a0,s6
 70c:	d89ff0ef          	jal	494 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 710:	0992                	slli	s3,s3,0x4
 712:	34fd                	addiw	s1,s1,-1
 714:	f4f5                	bnez	s1,700 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 716:	8be6                	mv	s7,s9
      state = 0;
 718:	4981                	li	s3,0
 71a:	6ca2                	ld	s9,8(sp)
 71c:	bda5                	j	594 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 71e:	008b8493          	addi	s1,s7,8
 722:	000bc583          	lbu	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	d6dff0ef          	jal	494 <putc>
 72c:	8ba6                	mv	s7,s1
      state = 0;
 72e:	4981                	li	s3,0
 730:	b595                	j	594 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 732:	008b8993          	addi	s3,s7,8
 736:	000bb483          	ld	s1,0(s7)
 73a:	cc91                	beqz	s1,756 <vprintf+0x206>
        for (; *s; s++)
 73c:	0004c583          	lbu	a1,0(s1)
 740:	c985                	beqz	a1,770 <vprintf+0x220>
          putc(fd, *s);
 742:	855a                	mv	a0,s6
 744:	d51ff0ef          	jal	494 <putc>
        for (; *s; s++)
 748:	0485                	addi	s1,s1,1
 74a:	0004c583          	lbu	a1,0(s1)
 74e:	f9f5                	bnez	a1,742 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 750:	8bce                	mv	s7,s3
      state = 0;
 752:	4981                	li	s3,0
 754:	b581                	j	594 <vprintf+0x44>
          s = "(null)";
 756:	00000497          	auipc	s1,0x0
 75a:	2f248493          	addi	s1,s1,754 # a48 <malloc+0x156>
        for (; *s; s++)
 75e:	02800593          	li	a1,40
 762:	b7c5                	j	742 <vprintf+0x1f2>
        putc(fd, '%');
 764:	85be                	mv	a1,a5
 766:	855a                	mv	a0,s6
 768:	d2dff0ef          	jal	494 <putc>
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b51d                	j	594 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 770:	8bce                	mv	s7,s3
      state = 0;
 772:	4981                	li	s3,0
 774:	b505                	j	594 <vprintf+0x44>
 776:	6906                	ld	s2,64(sp)
 778:	79e2                	ld	s3,56(sp)
 77a:	7a42                	ld	s4,48(sp)
 77c:	7aa2                	ld	s5,40(sp)
 77e:	7b02                	ld	s6,32(sp)
 780:	6be2                	ld	s7,24(sp)
 782:	6c42                	ld	s8,16(sp)
    }
  }
}
 784:	60e6                	ld	ra,88(sp)
 786:	6446                	ld	s0,80(sp)
 788:	64a6                	ld	s1,72(sp)
 78a:	6125                	addi	sp,sp,96
 78c:	8082                	ret
      if (c0 == 'd') {
 78e:	06400713          	li	a4,100
 792:	e4e78fe3          	beq	a5,a4,5f0 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 796:	f9478693          	addi	a3,a5,-108
 79a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 79e:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7a0:	4701                	li	a4,0
      } else if (c0 == 'u') {
 7a2:	07500513          	li	a0,117
 7a6:	e8a78ce3          	beq	a5,a0,63e <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 7aa:	f8b60513          	addi	a0,a2,-117
 7ae:	e119                	bnez	a0,7b4 <vprintf+0x264>
 7b0:	ea0693e3          	bnez	a3,656 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 7b4:	f8b58513          	addi	a0,a1,-117
 7b8:	e119                	bnez	a0,7be <vprintf+0x26e>
 7ba:	ea071be3          	bnez	a4,670 <vprintf+0x120>
      } else if (c0 == 'x') {
 7be:	07800513          	li	a0,120
 7c2:	eca784e3          	beq	a5,a0,68a <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 7c6:	f8860613          	addi	a2,a2,-120
 7ca:	e219                	bnez	a2,7d0 <vprintf+0x280>
 7cc:	ec069be3          	bnez	a3,6a2 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 7d0:	f8858593          	addi	a1,a1,-120
 7d4:	e199                	bnez	a1,7da <vprintf+0x28a>
 7d6:	ee0713e3          	bnez	a4,6bc <vprintf+0x16c>
      } else if (c0 == 'p') {
 7da:	07000713          	li	a4,112
 7de:	eee78ce3          	beq	a5,a4,6d6 <vprintf+0x186>
      } else if (c0 == 'c') {
 7e2:	06300713          	li	a4,99
 7e6:	f2e78ce3          	beq	a5,a4,71e <vprintf+0x1ce>
      } else if (c0 == 's') {
 7ea:	07300713          	li	a4,115
 7ee:	f4e782e3          	beq	a5,a4,732 <vprintf+0x1e2>
      } else if (c0 == '%') {
 7f2:	02500713          	li	a4,37
 7f6:	f6e787e3          	beq	a5,a4,764 <vprintf+0x214>
        putc(fd, '%');
 7fa:	02500593          	li	a1,37
 7fe:	855a                	mv	a0,s6
 800:	c95ff0ef          	jal	494 <putc>
        putc(fd, c0);
 804:	85a6                	mv	a1,s1
 806:	855a                	mv	a0,s6
 808:	c8dff0ef          	jal	494 <putc>
      state = 0;
 80c:	4981                	li	s3,0
 80e:	b359                	j	594 <vprintf+0x44>

0000000000000810 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 810:	715d                	addi	sp,sp,-80
 812:	ec06                	sd	ra,24(sp)
 814:	e822                	sd	s0,16(sp)
 816:	1000                	addi	s0,sp,32
 818:	e010                	sd	a2,0(s0)
 81a:	e414                	sd	a3,8(s0)
 81c:	e818                	sd	a4,16(s0)
 81e:	ec1c                	sd	a5,24(s0)
 820:	03043023          	sd	a6,32(s0)
 824:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 828:	8622                	mv	a2,s0
 82a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 82e:	d23ff0ef          	jal	550 <vprintf>
}
 832:	60e2                	ld	ra,24(sp)
 834:	6442                	ld	s0,16(sp)
 836:	6161                	addi	sp,sp,80
 838:	8082                	ret

000000000000083a <printf>:

void
printf(const char *fmt, ...)
{
 83a:	711d                	addi	sp,sp,-96
 83c:	ec06                	sd	ra,24(sp)
 83e:	e822                	sd	s0,16(sp)
 840:	1000                	addi	s0,sp,32
 842:	e40c                	sd	a1,8(s0)
 844:	e810                	sd	a2,16(s0)
 846:	ec14                	sd	a3,24(s0)
 848:	f018                	sd	a4,32(s0)
 84a:	f41c                	sd	a5,40(s0)
 84c:	03043823          	sd	a6,48(s0)
 850:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 854:	00840613          	addi	a2,s0,8
 858:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 85c:	85aa                	mv	a1,a0
 85e:	4505                	li	a0,1
 860:	cf1ff0ef          	jal	550 <vprintf>
}
 864:	60e2                	ld	ra,24(sp)
 866:	6442                	ld	s0,16(sp)
 868:	6125                	addi	sp,sp,96
 86a:	8082                	ret

000000000000086c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86c:	1141                	addi	sp,sp,-16
 86e:	e406                	sd	ra,8(sp)
 870:	e022                	sd	s0,0(sp)
 872:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 874:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 878:	00000797          	auipc	a5,0x0
 87c:	7887b783          	ld	a5,1928(a5) # 1000 <freep>
 880:	a039                	j	88e <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 882:	6398                	ld	a4,0(a5)
 884:	00e7e463          	bltu	a5,a4,88c <free+0x20>
 888:	00e6ea63          	bltu	a3,a4,89c <free+0x30>
{
 88c:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88e:	fed7fae3          	bgeu	a5,a3,882 <free+0x16>
 892:	6398                	ld	a4,0(a5)
 894:	00e6e463          	bltu	a3,a4,89c <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 898:	fee7eae3          	bltu	a5,a4,88c <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 89c:	ff852583          	lw	a1,-8(a0)
 8a0:	6390                	ld	a2,0(a5)
 8a2:	02059813          	slli	a6,a1,0x20
 8a6:	01c85713          	srli	a4,a6,0x1c
 8aa:	9736                	add	a4,a4,a3
 8ac:	02e60563          	beq	a2,a4,8d6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8b0:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 8b4:	4790                	lw	a2,8(a5)
 8b6:	02061593          	slli	a1,a2,0x20
 8ba:	01c5d713          	srli	a4,a1,0x1c
 8be:	973e                	add	a4,a4,a5
 8c0:	02e68263          	beq	a3,a4,8e4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8c4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8c6:	00000717          	auipc	a4,0x0
 8ca:	72f73d23          	sd	a5,1850(a4) # 1000 <freep>
}
 8ce:	60a2                	ld	ra,8(sp)
 8d0:	6402                	ld	s0,0(sp)
 8d2:	0141                	addi	sp,sp,16
 8d4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8d6:	4618                	lw	a4,8(a2)
 8d8:	9f2d                	addw	a4,a4,a1
 8da:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8de:	6398                	ld	a4,0(a5)
 8e0:	6310                	ld	a2,0(a4)
 8e2:	b7f9                	j	8b0 <free+0x44>
    p->s.size += bp->s.size;
 8e4:	ff852703          	lw	a4,-8(a0)
 8e8:	9f31                	addw	a4,a4,a2
 8ea:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ec:	ff053683          	ld	a3,-16(a0)
 8f0:	bfd1                	j	8c4 <free+0x58>

00000000000008f2 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8f2:	7139                	addi	sp,sp,-64
 8f4:	fc06                	sd	ra,56(sp)
 8f6:	f822                	sd	s0,48(sp)
 8f8:	f04a                	sd	s2,32(sp)
 8fa:	ec4e                	sd	s3,24(sp)
 8fc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8fe:	02051993          	slli	s3,a0,0x20
 902:	0209d993          	srli	s3,s3,0x20
 906:	09bd                	addi	s3,s3,15
 908:	0049d993          	srli	s3,s3,0x4
 90c:	2985                	addiw	s3,s3,1
 90e:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 910:	00000517          	auipc	a0,0x0
 914:	6f053503          	ld	a0,1776(a0) # 1000 <freep>
 918:	c905                	beqz	a0,948 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 91a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 91c:	4798                	lw	a4,8(a5)
 91e:	09377663          	bgeu	a4,s3,9aa <malloc+0xb8>
 922:	f426                	sd	s1,40(sp)
 924:	e852                	sd	s4,16(sp)
 926:	e456                	sd	s5,8(sp)
 928:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 92a:	8a4e                	mv	s4,s3
 92c:	6705                	lui	a4,0x1
 92e:	00e9f363          	bgeu	s3,a4,934 <malloc+0x42>
 932:	6a05                	lui	s4,0x1
 934:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 938:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 93c:	00000497          	auipc	s1,0x0
 940:	6c448493          	addi	s1,s1,1732 # 1000 <freep>
  if (p == SBRK_ERROR)
 944:	5afd                	li	s5,-1
 946:	a83d                	j	984 <malloc+0x92>
 948:	f426                	sd	s1,40(sp)
 94a:	e852                	sd	s4,16(sp)
 94c:	e456                	sd	s5,8(sp)
 94e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 950:	00000797          	auipc	a5,0x0
 954:	6c078793          	addi	a5,a5,1728 # 1010 <base>
 958:	00000717          	auipc	a4,0x0
 95c:	6af73423          	sd	a5,1704(a4) # 1000 <freep>
 960:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 962:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 966:	b7d1                	j	92a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 968:	6398                	ld	a4,0(a5)
 96a:	e118                	sd	a4,0(a0)
 96c:	a899                	j	9c2 <malloc+0xd0>
  hp->s.size = nu;
 96e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 972:	0541                	addi	a0,a0,16
 974:	ef9ff0ef          	jal	86c <free>
  return freep;
 978:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 97a:	c125                	beqz	a0,9da <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 97c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 97e:	4798                	lw	a4,8(a5)
 980:	03277163          	bgeu	a4,s2,9a2 <malloc+0xb0>
    if (p == freep)
 984:	6098                	ld	a4,0(s1)
 986:	853e                	mv	a0,a5
 988:	fef71ae3          	bne	a4,a5,97c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 98c:	8552                	mv	a0,s4
 98e:	9fbff0ef          	jal	388 <sbrk>
  if (p == SBRK_ERROR)
 992:	fd551ee3          	bne	a0,s5,96e <malloc+0x7c>
        return 0;
 996:	4501                	li	a0,0
 998:	74a2                	ld	s1,40(sp)
 99a:	6a42                	ld	s4,16(sp)
 99c:	6aa2                	ld	s5,8(sp)
 99e:	6b02                	ld	s6,0(sp)
 9a0:	a03d                	j	9ce <malloc+0xdc>
 9a2:	74a2                	ld	s1,40(sp)
 9a4:	6a42                	ld	s4,16(sp)
 9a6:	6aa2                	ld	s5,8(sp)
 9a8:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9aa:	fae90fe3          	beq	s2,a4,968 <malloc+0x76>
        p->s.size -= nunits;
 9ae:	4137073b          	subw	a4,a4,s3
 9b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9b4:	02071693          	slli	a3,a4,0x20
 9b8:	01c6d713          	srli	a4,a3,0x1c
 9bc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9be:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9c2:	00000717          	auipc	a4,0x0
 9c6:	62a73f23          	sd	a0,1598(a4) # 1000 <freep>
      return (void *)(p + 1);
 9ca:	01078513          	addi	a0,a5,16
  }
}
 9ce:	70e2                	ld	ra,56(sp)
 9d0:	7442                	ld	s0,48(sp)
 9d2:	7902                	ld	s2,32(sp)
 9d4:	69e2                	ld	s3,24(sp)
 9d6:	6121                	addi	sp,sp,64
 9d8:	8082                	ret
 9da:	74a2                	ld	s1,40(sp)
 9dc:	6a42                	ld	s4,16(sp)
 9de:	6aa2                	ld	s5,8(sp)
 9e0:	6b02                	ld	s6,0(sp)
 9e2:	b7f5                	j	9ce <malloc+0xdc>
