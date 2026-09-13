
user/_sync:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  sync();
   8:	388000ef          	jal	390 <sync>
  exit(0);
   c:	4501                	li	a0,0
   e:	2ba000ef          	jal	2c8 <exit>

0000000000000012 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  12:	1141                	addi	sp,sp,-16
  14:	e406                	sd	ra,8(sp)
  16:	e022                	sd	s0,0(sp)
  18:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  1a:	fe7ff0ef          	jal	0 <main>
  exit(r);
  1e:	2aa000ef          	jal	2c8 <exit>

0000000000000022 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  22:	1141                	addi	sp,sp,-16
  24:	e406                	sd	ra,8(sp)
  26:	e022                	sd	s0,0(sp)
  28:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  2a:	87aa                	mv	a5,a0
  2c:	0585                	addi	a1,a1,1
  2e:	0785                	addi	a5,a5,1
  30:	fff5c703          	lbu	a4,-1(a1)
  34:	fee78fa3          	sb	a4,-1(a5)
  38:	fb75                	bnez	a4,2c <strcpy+0xa>
    ;
  return os;
}
  3a:	60a2                	ld	ra,8(sp)
  3c:	6402                	ld	s0,0(sp)
  3e:	0141                	addi	sp,sp,16
  40:	8082                	ret

0000000000000042 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  42:	1141                	addi	sp,sp,-16
  44:	e406                	sd	ra,8(sp)
  46:	e022                	sd	s0,0(sp)
  48:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  4a:	00054783          	lbu	a5,0(a0)
  4e:	cb91                	beqz	a5,62 <strcmp+0x20>
  50:	0005c703          	lbu	a4,0(a1)
  54:	00f71763          	bne	a4,a5,62 <strcmp+0x20>
    p++, q++;
  58:	0505                	addi	a0,a0,1
  5a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	fbe5                	bnez	a5,50 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  62:	0005c503          	lbu	a0,0(a1)
}
  66:	40a7853b          	subw	a0,a5,a0
  6a:	60a2                	ld	ra,8(sp)
  6c:	6402                	ld	s0,0(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e406                	sd	ra,8(sp)
  76:	e022                	sd	s0,0(sp)
  78:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  7a:	00054783          	lbu	a5,0(a0)
  7e:	cf91                	beqz	a5,9a <strlen+0x28>
  80:	00150793          	addi	a5,a0,1
  84:	86be                	mv	a3,a5
  86:	0785                	addi	a5,a5,1
  88:	fff7c703          	lbu	a4,-1(a5)
  8c:	ff65                	bnez	a4,84 <strlen+0x12>
  8e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  92:	60a2                	ld	ra,8(sp)
  94:	6402                	ld	s0,0(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret
  for (n = 0; s[n]; n++)
  9a:	4501                	li	a0,0
  9c:	bfdd                	j	92 <strlen+0x20>

000000000000009e <memset>:

void *
memset(void *dst, int c, uint n)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e406                	sd	ra,8(sp)
  a2:	e022                	sd	s0,0(sp)
  a4:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  a6:	ca19                	beqz	a2,bc <memset+0x1e>
  a8:	87aa                	mv	a5,a0
  aa:	1602                	slli	a2,a2,0x20
  ac:	9201                	srli	a2,a2,0x20
  ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  b6:	0785                	addi	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x14>
  }
  return dst;
}
  bc:	60a2                	ld	ra,8(sp)
  be:	6402                	ld	s0,0(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char *
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  for (; *s; s++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cf81                	beqz	a5,e8 <strchr+0x24>
    if (*s == c)
  d2:	00f58763          	beq	a1,a5,e0 <strchr+0x1c>
  for (; *s; s++)
  d6:	0505                	addi	a0,a0,1
  d8:	00054783          	lbu	a5,0(a0)
  dc:	fbfd                	bnez	a5,d2 <strchr+0xe>
      return (char *)s;
  return 0;
  de:	4501                	li	a0,0
}
  e0:	60a2                	ld	ra,8(sp)
  e2:	6402                	ld	s0,0(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret
  return 0;
  e8:	4501                	li	a0,0
  ea:	bfdd                	j	e0 <strchr+0x1c>

00000000000000ec <gets>:

char *
gets(char *buf, int max)
{
  ec:	711d                	addi	sp,sp,-96
  ee:	ec86                	sd	ra,88(sp)
  f0:	e8a2                	sd	s0,80(sp)
  f2:	e4a6                	sd	s1,72(sp)
  f4:	e0ca                	sd	s2,64(sp)
  f6:	fc4e                	sd	s3,56(sp)
  f8:	f852                	sd	s4,48(sp)
  fa:	f456                	sd	s5,40(sp)
  fc:	f05a                	sd	s6,32(sp)
  fe:	ec5e                	sd	s7,24(sp)
 100:	e862                	sd	s8,16(sp)
 102:	1080                	addi	s0,sp,96
 104:	8baa                	mv	s7,a0
 106:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 108:	892a                	mv	s2,a0
 10a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 10c:	faf40b13          	addi	s6,s0,-81
 110:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 112:	8c26                	mv	s8,s1
 114:	0014899b          	addiw	s3,s1,1
 118:	84ce                	mv	s1,s3
 11a:	0349d463          	bge	s3,s4,142 <gets+0x56>
    cc = read(0, &c, 1);
 11e:	8656                	mv	a2,s5
 120:	85da                	mv	a1,s6
 122:	4501                	li	a0,0
 124:	1c4000ef          	jal	2e8 <read>
    if (cc < 1)
 128:	00a05d63          	blez	a0,142 <gets+0x56>
      break;
    buf[i++] = c;
 12c:	faf44783          	lbu	a5,-81(s0)
 130:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 134:	0905                	addi	s2,s2,1
 136:	ff678713          	addi	a4,a5,-10
 13a:	c319                	beqz	a4,140 <gets+0x54>
 13c:	17cd                	addi	a5,a5,-13
 13e:	fbf1                	bnez	a5,112 <gets+0x26>
    buf[i++] = c;
 140:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 142:	9c5e                	add	s8,s8,s7
 144:	000c0023          	sb	zero,0(s8)
  return buf;
}
 148:	855e                	mv	a0,s7
 14a:	60e6                	ld	ra,88(sp)
 14c:	6446                	ld	s0,80(sp)
 14e:	64a6                	ld	s1,72(sp)
 150:	6906                	ld	s2,64(sp)
 152:	79e2                	ld	s3,56(sp)
 154:	7a42                	ld	s4,48(sp)
 156:	7aa2                	ld	s5,40(sp)
 158:	7b02                	ld	s6,32(sp)
 15a:	6be2                	ld	s7,24(sp)
 15c:	6c42                	ld	s8,16(sp)
 15e:	6125                	addi	sp,sp,96
 160:	8082                	ret

0000000000000162 <stat>:

int
stat(const char *n, struct stat *st)
{
 162:	1101                	addi	sp,sp,-32
 164:	ec06                	sd	ra,24(sp)
 166:	e822                	sd	s0,16(sp)
 168:	e04a                	sd	s2,0(sp)
 16a:	1000                	addi	s0,sp,32
 16c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16e:	4581                	li	a1,0
 170:	1c0000ef          	jal	330 <open>
  if (fd < 0)
 174:	02054263          	bltz	a0,198 <stat+0x36>
 178:	e426                	sd	s1,8(sp)
 17a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 17c:	85ca                	mv	a1,s2
 17e:	1ca000ef          	jal	348 <fstat>
 182:	892a                	mv	s2,a0
  close(fd);
 184:	8526                	mv	a0,s1
 186:	192000ef          	jal	318 <close>
  return r;
 18a:	64a2                	ld	s1,8(sp)
}
 18c:	854a                	mv	a0,s2
 18e:	60e2                	ld	ra,24(sp)
 190:	6442                	ld	s0,16(sp)
 192:	6902                	ld	s2,0(sp)
 194:	6105                	addi	sp,sp,32
 196:	8082                	ret
    return -1;
 198:	57fd                	li	a5,-1
 19a:	893e                	mv	s2,a5
 19c:	bfc5                	j	18c <stat+0x2a>

000000000000019e <atoi>:

int
atoi(const char *s)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e406                	sd	ra,8(sp)
 1a2:	e022                	sd	s0,0(sp)
 1a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1a6:	00054683          	lbu	a3,0(a0)
 1aa:	fd06879b          	addiw	a5,a3,-48
 1ae:	0ff7f793          	zext.b	a5,a5
 1b2:	4625                	li	a2,9
 1b4:	02f66963          	bltu	a2,a5,1e6 <atoi+0x48>
 1b8:	872a                	mv	a4,a0
  n = 0;
 1ba:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1bc:	0705                	addi	a4,a4,1
 1be:	0025179b          	slliw	a5,a0,0x2
 1c2:	9fa9                	addw	a5,a5,a0
 1c4:	0017979b          	slliw	a5,a5,0x1
 1c8:	9fb5                	addw	a5,a5,a3
 1ca:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1ce:	00074683          	lbu	a3,0(a4)
 1d2:	fd06879b          	addiw	a5,a3,-48
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	fef671e3          	bgeu	a2,a5,1bc <atoi+0x1e>
  return n;
}
 1de:	60a2                	ld	ra,8(sp)
 1e0:	6402                	ld	s0,0(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  n = 0;
 1e6:	4501                	li	a0,0
 1e8:	bfdd                	j	1de <atoi+0x40>

00000000000001ea <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f2:	02b57563          	bgeu	a0,a1,21c <memmove+0x32>
    while (n-- > 0)
 1f6:	00c05f63          	blez	a2,214 <memmove+0x2a>
 1fa:	1602                	slli	a2,a2,0x20
 1fc:	9201                	srli	a2,a2,0x20
 1fe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 202:	872a                	mv	a4,a0
      *dst++ = *src++;
 204:	0585                	addi	a1,a1,1
 206:	0705                	addi	a4,a4,1
 208:	fff5c683          	lbu	a3,-1(a1)
 20c:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 210:	fee79ae3          	bne	a5,a4,204 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 214:	60a2                	ld	ra,8(sp)
 216:	6402                	ld	s0,0(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
    while (n-- > 0)
 21c:	fec05ce3          	blez	a2,214 <memmove+0x2a>
    dst += n;
 220:	00c50733          	add	a4,a0,a2
    src += n;
 224:	95b2                	add	a1,a1,a2
 226:	fff6079b          	addiw	a5,a2,-1
 22a:	1782                	slli	a5,a5,0x20
 22c:	9381                	srli	a5,a5,0x20
 22e:	fff7c793          	not	a5,a5
 232:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 234:	15fd                	addi	a1,a1,-1
 236:	177d                	addi	a4,a4,-1
 238:	0005c683          	lbu	a3,0(a1)
 23c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 240:	fef71ae3          	bne	a4,a5,234 <memmove+0x4a>
 244:	bfc1                	j	214 <memmove+0x2a>

0000000000000246 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e406                	sd	ra,8(sp)
 24a:	e022                	sd	s0,0(sp)
 24c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 24e:	c61d                	beqz	a2,27c <memcmp+0x36>
 250:	1602                	slli	a2,a2,0x20
 252:	9201                	srli	a2,a2,0x20
 254:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 258:	00054783          	lbu	a5,0(a0)
 25c:	0005c703          	lbu	a4,0(a1)
 260:	00e79863          	bne	a5,a4,270 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 264:	0505                	addi	a0,a0,1
    p2++;
 266:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 268:	fed518e3          	bne	a0,a3,258 <memcmp+0x12>
  }
  return 0;
 26c:	4501                	li	a0,0
 26e:	a019                	j	274 <memcmp+0x2e>
      return *p1 - *p2;
 270:	40e7853b          	subw	a0,a5,a4
}
 274:	60a2                	ld	ra,8(sp)
 276:	6402                	ld	s0,0(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
  return 0;
 27c:	4501                	li	a0,0
 27e:	bfdd                	j	274 <memcmp+0x2e>

0000000000000280 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 288:	f63ff0ef          	jal	1ea <memmove>
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <sbrk>:

char *
sbrk(int n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 29c:	4585                	li	a1,1
 29e:	0da000ef          	jal	378 <sys_sbrk>
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret

00000000000002aa <sbrklazy>:

char *
sbrklazy(int n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2b2:	4589                	li	a1,2
 2b4:	0c4000ef          	jal	378 <sys_sbrk>
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c0:	4885                	li	a7,1
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c8:	4889                	li	a7,2
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d0:	488d                	li	a7,3
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2d8:	48b5                	li	a7,13
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e0:	4891                	li	a7,4
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <read>:
.global read
read:
 li a7, SYS_read
 2e8:	4895                	li	a7,5
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <write>:
.global write
write:
 li a7, SYS_write
 2f0:	48c1                	li	a7,16
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <sem_create>:
.global sem_create
sem_create:
 li a7, SYS_sem_create
 2f8:	48e1                	li	a7,24
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <sem_wait>:
.global sem_wait
sem_wait:
 li a7, SYS_sem_wait
 300:	48e5                	li	a7,25
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <sem_signal>:
.global sem_signal
sem_signal:
 li a7, SYS_sem_signal
 308:	48e9                	li	a7,26
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <sem_free>:
.global sem_free
sem_free:
 li a7, SYS_sem_free
 310:	48ed                	li	a7,27
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <close>:
.global close
close:
 li a7, SYS_close
 318:	48d5                	li	a7,21
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <kill>:
.global kill
kill:
 li a7, SYS_kill
 320:	4899                	li	a7,6
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <exec>:
.global exec
exec:
 li a7, SYS_exec
 328:	489d                	li	a7,7
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <open>:
.global open
open:
 li a7, SYS_open
 330:	48bd                	li	a7,15
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 338:	48c5                	li	a7,17
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 340:	48c9                	li	a7,18
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 348:	48a1                	li	a7,8
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <link>:
.global link
link:
 li a7, SYS_link
 350:	48cd                	li	a7,19
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 358:	48d1                	li	a7,20
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 360:	48a5                	li	a7,9
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <dup>:
.global dup
dup:
 li a7, SYS_dup
 368:	48a9                	li	a7,10
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 370:	48ad                	li	a7,11
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 378:	48b1                	li	a7,12
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <pause>:
.global pause
pause:
 li a7, SYS_pause
 380:	48b5                	li	a7,13
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 388:	48b9                	li	a7,14
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <sync>:
.global sync
sync:
 li a7, SYS_sync
 390:	48d9                	li	a7,22
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <shm_get>:
.global shm_get
shm_get:
 li a7, SYS_shm_get
 398:	48dd                	li	a7,23
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a0:	1101                	addi	sp,sp,-32
 3a2:	ec06                	sd	ra,24(sp)
 3a4:	e822                	sd	s0,16(sp)
 3a6:	1000                	addi	s0,sp,32
 3a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ac:	4605                	li	a2,1
 3ae:	fef40593          	addi	a1,s0,-17
 3b2:	f3fff0ef          	jal	2f0 <write>
}
 3b6:	60e2                	ld	ra,24(sp)
 3b8:	6442                	ld	s0,16(sp)
 3ba:	6105                	addi	sp,sp,32
 3bc:	8082                	ret

00000000000003be <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3be:	715d                	addi	sp,sp,-80
 3c0:	e486                	sd	ra,72(sp)
 3c2:	e0a2                	sd	s0,64(sp)
 3c4:	f84a                	sd	s2,48(sp)
 3c6:	f44e                	sd	s3,40(sp)
 3c8:	0880                	addi	s0,sp,80
 3ca:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3cc:	c6d1                	beqz	a3,458 <printint+0x9a>
 3ce:	0805d563          	bgez	a1,458 <printint+0x9a>
    neg = 1;
    x = -xx;
 3d2:	40b005b3          	neg	a1,a1
    neg = 1;
 3d6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3d8:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3dc:	86ce                	mv	a3,s3
  i = 0;
 3de:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3e0:	00000817          	auipc	a6,0x0
 3e4:	51880813          	addi	a6,a6,1304 # 8f8 <digits>
 3e8:	88ba                	mv	a7,a4
 3ea:	0017051b          	addiw	a0,a4,1
 3ee:	872a                	mv	a4,a0
 3f0:	02c5f7b3          	remu	a5,a1,a2
 3f4:	97c2                	add	a5,a5,a6
 3f6:	0007c783          	lbu	a5,0(a5)
 3fa:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 3fe:	87ae                	mv	a5,a1
 400:	02c5d5b3          	divu	a1,a1,a2
 404:	0685                	addi	a3,a3,1
 406:	fec7f1e3          	bgeu	a5,a2,3e8 <printint+0x2a>
  if (neg)
 40a:	00030c63          	beqz	t1,422 <printint+0x64>
    buf[i++] = '-';
 40e:	fd050793          	addi	a5,a0,-48
 412:	00878533          	add	a0,a5,s0
 416:	02d00793          	li	a5,45
 41a:	fef50423          	sb	a5,-24(a0)
 41e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 422:	02e05563          	blez	a4,44c <printint+0x8e>
 426:	fc26                	sd	s1,56(sp)
 428:	377d                	addiw	a4,a4,-1
 42a:	00e984b3          	add	s1,s3,a4
 42e:	19fd                	addi	s3,s3,-1
 430:	99ba                	add	s3,s3,a4
 432:	1702                	slli	a4,a4,0x20
 434:	9301                	srli	a4,a4,0x20
 436:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 43a:	0004c583          	lbu	a1,0(s1)
 43e:	854a                	mv	a0,s2
 440:	f61ff0ef          	jal	3a0 <putc>
  while (--i >= 0)
 444:	14fd                	addi	s1,s1,-1
 446:	ff349ae3          	bne	s1,s3,43a <printint+0x7c>
 44a:	74e2                	ld	s1,56(sp)
}
 44c:	60a6                	ld	ra,72(sp)
 44e:	6406                	ld	s0,64(sp)
 450:	7942                	ld	s2,48(sp)
 452:	79a2                	ld	s3,40(sp)
 454:	6161                	addi	sp,sp,80
 456:	8082                	ret
  neg = 0;
 458:	4301                	li	t1,0
 45a:	bfbd                	j	3d8 <printint+0x1a>

000000000000045c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 45c:	711d                	addi	sp,sp,-96
 45e:	ec86                	sd	ra,88(sp)
 460:	e8a2                	sd	s0,80(sp)
 462:	e4a6                	sd	s1,72(sp)
 464:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 466:	0005c483          	lbu	s1,0(a1)
 46a:	22048363          	beqz	s1,690 <vprintf+0x234>
 46e:	e0ca                	sd	s2,64(sp)
 470:	fc4e                	sd	s3,56(sp)
 472:	f852                	sd	s4,48(sp)
 474:	f456                	sd	s5,40(sp)
 476:	f05a                	sd	s6,32(sp)
 478:	ec5e                	sd	s7,24(sp)
 47a:	e862                	sd	s8,16(sp)
 47c:	8b2a                	mv	s6,a0
 47e:	8a2e                	mv	s4,a1
 480:	8bb2                	mv	s7,a2
  state = 0;
 482:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 484:	4901                	li	s2,0
 486:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 488:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 48c:	06400c13          	li	s8,100
 490:	a00d                	j	4b2 <vprintf+0x56>
        putc(fd, c0);
 492:	85a6                	mv	a1,s1
 494:	855a                	mv	a0,s6
 496:	f0bff0ef          	jal	3a0 <putc>
 49a:	a019                	j	4a0 <vprintf+0x44>
    } else if (state == '%') {
 49c:	03598363          	beq	s3,s5,4c2 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4a0:	0019079b          	addiw	a5,s2,1
 4a4:	893e                	mv	s2,a5
 4a6:	873e                	mv	a4,a5
 4a8:	97d2                	add	a5,a5,s4
 4aa:	0007c483          	lbu	s1,0(a5)
 4ae:	1c048a63          	beqz	s1,682 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4b2:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4b6:	fe0993e3          	bnez	s3,49c <vprintf+0x40>
      if (c0 == '%') {
 4ba:	fd579ce3          	bne	a5,s5,492 <vprintf+0x36>
        state = '%';
 4be:	89be                	mv	s3,a5
 4c0:	b7c5                	j	4a0 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4c2:	00ea06b3          	add	a3,s4,a4
 4c6:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4ca:	1c060863          	beqz	a2,69a <vprintf+0x23e>
      if (c0 == 'd') {
 4ce:	03878763          	beq	a5,s8,4fc <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4d2:	f9478693          	addi	a3,a5,-108
 4d6:	0016b693          	seqz	a3,a3
 4da:	f9c60593          	addi	a1,a2,-100
 4de:	e99d                	bnez	a1,514 <vprintf+0xb8>
 4e0:	ca95                	beqz	a3,514 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4e2:	008b8493          	addi	s1,s7,8
 4e6:	4685                	li	a3,1
 4e8:	4629                	li	a2,10
 4ea:	000bb583          	ld	a1,0(s7)
 4ee:	855a                	mv	a0,s6
 4f0:	ecfff0ef          	jal	3be <printint>
        i += 1;
 4f4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f6:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4f8:	4981                	li	s3,0
 4fa:	b75d                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4fc:	008b8493          	addi	s1,s7,8
 500:	4685                	li	a3,1
 502:	4629                	li	a2,10
 504:	000ba583          	lw	a1,0(s7)
 508:	855a                	mv	a0,s6
 50a:	eb5ff0ef          	jal	3be <printint>
 50e:	8ba6                	mv	s7,s1
      state = 0;
 510:	4981                	li	s3,0
 512:	b779                	j	4a0 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 514:	9752                	add	a4,a4,s4
 516:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 51a:	f9460713          	addi	a4,a2,-108
 51e:	00173713          	seqz	a4,a4
 522:	8f75                	and	a4,a4,a3
 524:	f9c58513          	addi	a0,a1,-100
 528:	18051363          	bnez	a0,6ae <vprintf+0x252>
 52c:	18070163          	beqz	a4,6ae <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 530:	008b8493          	addi	s1,s7,8
 534:	4685                	li	a3,1
 536:	4629                	li	a2,10
 538:	000bb583          	ld	a1,0(s7)
 53c:	855a                	mv	a0,s6
 53e:	e81ff0ef          	jal	3be <printint>
        i += 2;
 542:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 544:	8ba6                	mv	s7,s1
      state = 0;
 546:	4981                	li	s3,0
        i += 2;
 548:	bfa1                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 54a:	008b8493          	addi	s1,s7,8
 54e:	4681                	li	a3,0
 550:	4629                	li	a2,10
 552:	000be583          	lwu	a1,0(s7)
 556:	855a                	mv	a0,s6
 558:	e67ff0ef          	jal	3be <printint>
 55c:	8ba6                	mv	s7,s1
      state = 0;
 55e:	4981                	li	s3,0
 560:	b781                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 562:	008b8493          	addi	s1,s7,8
 566:	4681                	li	a3,0
 568:	4629                	li	a2,10
 56a:	000bb583          	ld	a1,0(s7)
 56e:	855a                	mv	a0,s6
 570:	e4fff0ef          	jal	3be <printint>
        i += 1;
 574:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 576:	8ba6                	mv	s7,s1
      state = 0;
 578:	4981                	li	s3,0
 57a:	b71d                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57c:	008b8493          	addi	s1,s7,8
 580:	4681                	li	a3,0
 582:	4629                	li	a2,10
 584:	000bb583          	ld	a1,0(s7)
 588:	855a                	mv	a0,s6
 58a:	e35ff0ef          	jal	3be <printint>
        i += 2;
 58e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 590:	8ba6                	mv	s7,s1
      state = 0;
 592:	4981                	li	s3,0
        i += 2;
 594:	b731                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 596:	008b8493          	addi	s1,s7,8
 59a:	4681                	li	a3,0
 59c:	4641                	li	a2,16
 59e:	000be583          	lwu	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	e1bff0ef          	jal	3be <printint>
 5a8:	8ba6                	mv	s7,s1
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bdd5                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ae:	008b8493          	addi	s1,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4641                	li	a2,16
 5b6:	000bb583          	ld	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	e03ff0ef          	jal	3be <printint>
        i += 1;
 5c0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c2:	8ba6                	mv	s7,s1
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bde9                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c8:	008b8493          	addi	s1,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4641                	li	a2,16
 5d0:	000bb583          	ld	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	de9ff0ef          	jal	3be <printint>
        i += 2;
 5da:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5dc:	8ba6                	mv	s7,s1
      state = 0;
 5de:	4981                	li	s3,0
        i += 2;
 5e0:	b5c1                	j	4a0 <vprintf+0x44>
 5e2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5e4:	008b8793          	addi	a5,s7,8
 5e8:	8cbe                	mv	s9,a5
 5ea:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ee:	03000593          	li	a1,48
 5f2:	855a                	mv	a0,s6
 5f4:	dadff0ef          	jal	3a0 <putc>
  putc(fd, 'x');
 5f8:	07800593          	li	a1,120
 5fc:	855a                	mv	a0,s6
 5fe:	da3ff0ef          	jal	3a0 <putc>
 602:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 604:	00000b97          	auipc	s7,0x0
 608:	2f4b8b93          	addi	s7,s7,756 # 8f8 <digits>
 60c:	03c9d793          	srli	a5,s3,0x3c
 610:	97de                	add	a5,a5,s7
 612:	0007c583          	lbu	a1,0(a5)
 616:	855a                	mv	a0,s6
 618:	d89ff0ef          	jal	3a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 61c:	0992                	slli	s3,s3,0x4
 61e:	34fd                	addiw	s1,s1,-1
 620:	f4f5                	bnez	s1,60c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 622:	8be6                	mv	s7,s9
      state = 0;
 624:	4981                	li	s3,0
 626:	6ca2                	ld	s9,8(sp)
 628:	bda5                	j	4a0 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 62a:	008b8493          	addi	s1,s7,8
 62e:	000bc583          	lbu	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	d6dff0ef          	jal	3a0 <putc>
 638:	8ba6                	mv	s7,s1
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b595                	j	4a0 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 63e:	008b8993          	addi	s3,s7,8
 642:	000bb483          	ld	s1,0(s7)
 646:	cc91                	beqz	s1,662 <vprintf+0x206>
        for (; *s; s++)
 648:	0004c583          	lbu	a1,0(s1)
 64c:	c985                	beqz	a1,67c <vprintf+0x220>
          putc(fd, *s);
 64e:	855a                	mv	a0,s6
 650:	d51ff0ef          	jal	3a0 <putc>
        for (; *s; s++)
 654:	0485                	addi	s1,s1,1
 656:	0004c583          	lbu	a1,0(s1)
 65a:	f9f5                	bnez	a1,64e <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 65c:	8bce                	mv	s7,s3
      state = 0;
 65e:	4981                	li	s3,0
 660:	b581                	j	4a0 <vprintf+0x44>
          s = "(null)";
 662:	00000497          	auipc	s1,0x0
 666:	28e48493          	addi	s1,s1,654 # 8f0 <malloc+0xf2>
        for (; *s; s++)
 66a:	02800593          	li	a1,40
 66e:	b7c5                	j	64e <vprintf+0x1f2>
        putc(fd, '%');
 670:	85be                	mv	a1,a5
 672:	855a                	mv	a0,s6
 674:	d2dff0ef          	jal	3a0 <putc>
      state = 0;
 678:	4981                	li	s3,0
 67a:	b51d                	j	4a0 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 67c:	8bce                	mv	s7,s3
      state = 0;
 67e:	4981                	li	s3,0
 680:	b505                	j	4a0 <vprintf+0x44>
 682:	6906                	ld	s2,64(sp)
 684:	79e2                	ld	s3,56(sp)
 686:	7a42                	ld	s4,48(sp)
 688:	7aa2                	ld	s5,40(sp)
 68a:	7b02                	ld	s6,32(sp)
 68c:	6be2                	ld	s7,24(sp)
 68e:	6c42                	ld	s8,16(sp)
    }
  }
}
 690:	60e6                	ld	ra,88(sp)
 692:	6446                	ld	s0,80(sp)
 694:	64a6                	ld	s1,72(sp)
 696:	6125                	addi	sp,sp,96
 698:	8082                	ret
      if (c0 == 'd') {
 69a:	06400713          	li	a4,100
 69e:	e4e78fe3          	beq	a5,a4,4fc <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 6a2:	f9478693          	addi	a3,a5,-108
 6a6:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6aa:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6ac:	4701                	li	a4,0
      } else if (c0 == 'u') {
 6ae:	07500513          	li	a0,117
 6b2:	e8a78ce3          	beq	a5,a0,54a <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 6b6:	f8b60513          	addi	a0,a2,-117
 6ba:	e119                	bnez	a0,6c0 <vprintf+0x264>
 6bc:	ea0693e3          	bnez	a3,562 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6c0:	f8b58513          	addi	a0,a1,-117
 6c4:	e119                	bnez	a0,6ca <vprintf+0x26e>
 6c6:	ea071be3          	bnez	a4,57c <vprintf+0x120>
      } else if (c0 == 'x') {
 6ca:	07800513          	li	a0,120
 6ce:	eca784e3          	beq	a5,a0,596 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 6d2:	f8860613          	addi	a2,a2,-120
 6d6:	e219                	bnez	a2,6dc <vprintf+0x280>
 6d8:	ec069be3          	bnez	a3,5ae <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6dc:	f8858593          	addi	a1,a1,-120
 6e0:	e199                	bnez	a1,6e6 <vprintf+0x28a>
 6e2:	ee0713e3          	bnez	a4,5c8 <vprintf+0x16c>
      } else if (c0 == 'p') {
 6e6:	07000713          	li	a4,112
 6ea:	eee78ce3          	beq	a5,a4,5e2 <vprintf+0x186>
      } else if (c0 == 'c') {
 6ee:	06300713          	li	a4,99
 6f2:	f2e78ce3          	beq	a5,a4,62a <vprintf+0x1ce>
      } else if (c0 == 's') {
 6f6:	07300713          	li	a4,115
 6fa:	f4e782e3          	beq	a5,a4,63e <vprintf+0x1e2>
      } else if (c0 == '%') {
 6fe:	02500713          	li	a4,37
 702:	f6e787e3          	beq	a5,a4,670 <vprintf+0x214>
        putc(fd, '%');
 706:	02500593          	li	a1,37
 70a:	855a                	mv	a0,s6
 70c:	c95ff0ef          	jal	3a0 <putc>
        putc(fd, c0);
 710:	85a6                	mv	a1,s1
 712:	855a                	mv	a0,s6
 714:	c8dff0ef          	jal	3a0 <putc>
      state = 0;
 718:	4981                	li	s3,0
 71a:	b359                	j	4a0 <vprintf+0x44>

000000000000071c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71c:	715d                	addi	sp,sp,-80
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e010                	sd	a2,0(s0)
 726:	e414                	sd	a3,8(s0)
 728:	e818                	sd	a4,16(s0)
 72a:	ec1c                	sd	a5,24(s0)
 72c:	03043023          	sd	a6,32(s0)
 730:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	8622                	mv	a2,s0
 736:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73a:	d23ff0ef          	jal	45c <vprintf>
}
 73e:	60e2                	ld	ra,24(sp)
 740:	6442                	ld	s0,16(sp)
 742:	6161                	addi	sp,sp,80
 744:	8082                	ret

0000000000000746 <printf>:

void
printf(const char *fmt, ...)
{
 746:	711d                	addi	sp,sp,-96
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	addi	s0,sp,32
 74e:	e40c                	sd	a1,8(s0)
 750:	e810                	sd	a2,16(s0)
 752:	ec14                	sd	a3,24(s0)
 754:	f018                	sd	a4,32(s0)
 756:	f41c                	sd	a5,40(s0)
 758:	03043823          	sd	a6,48(s0)
 75c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 760:	00840613          	addi	a2,s0,8
 764:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 768:	85aa                	mv	a1,a0
 76a:	4505                	li	a0,1
 76c:	cf1ff0ef          	jal	45c <vprintf>
}
 770:	60e2                	ld	ra,24(sp)
 772:	6442                	ld	s0,16(sp)
 774:	6125                	addi	sp,sp,96
 776:	8082                	ret

0000000000000778 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 778:	1141                	addi	sp,sp,-16
 77a:	e406                	sd	ra,8(sp)
 77c:	e022                	sd	s0,0(sp)
 77e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 780:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 784:	00001797          	auipc	a5,0x1
 788:	87c7b783          	ld	a5,-1924(a5) # 1000 <freep>
 78c:	a039                	j	79a <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78e:	6398                	ld	a4,0(a5)
 790:	00e7e463          	bltu	a5,a4,798 <free+0x20>
 794:	00e6ea63          	bltu	a3,a4,7a8 <free+0x30>
{
 798:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79a:	fed7fae3          	bgeu	a5,a3,78e <free+0x16>
 79e:	6398                	ld	a4,0(a5)
 7a0:	00e6e463          	bltu	a3,a4,7a8 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a4:	fee7eae3          	bltu	a5,a4,798 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7a8:	ff852583          	lw	a1,-8(a0)
 7ac:	6390                	ld	a2,0(a5)
 7ae:	02059813          	slli	a6,a1,0x20
 7b2:	01c85713          	srli	a4,a6,0x1c
 7b6:	9736                	add	a4,a4,a3
 7b8:	02e60563          	beq	a2,a4,7e2 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7bc:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7c0:	4790                	lw	a2,8(a5)
 7c2:	02061593          	slli	a1,a2,0x20
 7c6:	01c5d713          	srli	a4,a1,0x1c
 7ca:	973e                	add	a4,a4,a5
 7cc:	02e68263          	beq	a3,a4,7f0 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7d0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d2:	00001717          	auipc	a4,0x1
 7d6:	82f73723          	sd	a5,-2002(a4) # 1000 <freep>
}
 7da:	60a2                	ld	ra,8(sp)
 7dc:	6402                	ld	s0,0(sp)
 7de:	0141                	addi	sp,sp,16
 7e0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7e2:	4618                	lw	a4,8(a2)
 7e4:	9f2d                	addw	a4,a4,a1
 7e6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ea:	6398                	ld	a4,0(a5)
 7ec:	6310                	ld	a2,0(a4)
 7ee:	b7f9                	j	7bc <free+0x44>
    p->s.size += bp->s.size;
 7f0:	ff852703          	lw	a4,-8(a0)
 7f4:	9f31                	addw	a4,a4,a2
 7f6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7f8:	ff053683          	ld	a3,-16(a0)
 7fc:	bfd1                	j	7d0 <free+0x58>

00000000000007fe <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 7fe:	7139                	addi	sp,sp,-64
 800:	fc06                	sd	ra,56(sp)
 802:	f822                	sd	s0,48(sp)
 804:	f04a                	sd	s2,32(sp)
 806:	ec4e                	sd	s3,24(sp)
 808:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 80a:	02051993          	slli	s3,a0,0x20
 80e:	0209d993          	srli	s3,s3,0x20
 812:	09bd                	addi	s3,s3,15
 814:	0049d993          	srli	s3,s3,0x4
 818:	2985                	addiw	s3,s3,1
 81a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 81c:	00000517          	auipc	a0,0x0
 820:	7e453503          	ld	a0,2020(a0) # 1000 <freep>
 824:	c905                	beqz	a0,854 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 826:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 828:	4798                	lw	a4,8(a5)
 82a:	09377663          	bgeu	a4,s3,8b6 <malloc+0xb8>
 82e:	f426                	sd	s1,40(sp)
 830:	e852                	sd	s4,16(sp)
 832:	e456                	sd	s5,8(sp)
 834:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 836:	8a4e                	mv	s4,s3
 838:	6705                	lui	a4,0x1
 83a:	00e9f363          	bgeu	s3,a4,840 <malloc+0x42>
 83e:	6a05                	lui	s4,0x1
 840:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 844:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 848:	00000497          	auipc	s1,0x0
 84c:	7b848493          	addi	s1,s1,1976 # 1000 <freep>
  if (p == SBRK_ERROR)
 850:	5afd                	li	s5,-1
 852:	a83d                	j	890 <malloc+0x92>
 854:	f426                	sd	s1,40(sp)
 856:	e852                	sd	s4,16(sp)
 858:	e456                	sd	s5,8(sp)
 85a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 85c:	00000797          	auipc	a5,0x0
 860:	7b478793          	addi	a5,a5,1972 # 1010 <base>
 864:	00000717          	auipc	a4,0x0
 868:	78f73e23          	sd	a5,1948(a4) # 1000 <freep>
 86c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 86e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 872:	b7d1                	j	836 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 874:	6398                	ld	a4,0(a5)
 876:	e118                	sd	a4,0(a0)
 878:	a899                	j	8ce <malloc+0xd0>
  hp->s.size = nu;
 87a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 87e:	0541                	addi	a0,a0,16
 880:	ef9ff0ef          	jal	778 <free>
  return freep;
 884:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 886:	c125                	beqz	a0,8e6 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 888:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 88a:	4798                	lw	a4,8(a5)
 88c:	03277163          	bgeu	a4,s2,8ae <malloc+0xb0>
    if (p == freep)
 890:	6098                	ld	a4,0(s1)
 892:	853e                	mv	a0,a5
 894:	fef71ae3          	bne	a4,a5,888 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 898:	8552                	mv	a0,s4
 89a:	9fbff0ef          	jal	294 <sbrk>
  if (p == SBRK_ERROR)
 89e:	fd551ee3          	bne	a0,s5,87a <malloc+0x7c>
        return 0;
 8a2:	4501                	li	a0,0
 8a4:	74a2                	ld	s1,40(sp)
 8a6:	6a42                	ld	s4,16(sp)
 8a8:	6aa2                	ld	s5,8(sp)
 8aa:	6b02                	ld	s6,0(sp)
 8ac:	a03d                	j	8da <malloc+0xdc>
 8ae:	74a2                	ld	s1,40(sp)
 8b0:	6a42                	ld	s4,16(sp)
 8b2:	6aa2                	ld	s5,8(sp)
 8b4:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8b6:	fae90fe3          	beq	s2,a4,874 <malloc+0x76>
        p->s.size -= nunits;
 8ba:	4137073b          	subw	a4,a4,s3
 8be:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c0:	02071693          	slli	a3,a4,0x20
 8c4:	01c6d713          	srli	a4,a3,0x1c
 8c8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ce:	00000717          	auipc	a4,0x0
 8d2:	72a73923          	sd	a0,1842(a4) # 1000 <freep>
      return (void *)(p + 1);
 8d6:	01078513          	addi	a0,a5,16
  }
}
 8da:	70e2                	ld	ra,56(sp)
 8dc:	7442                	ld	s0,48(sp)
 8de:	7902                	ld	s2,32(sp)
 8e0:	69e2                	ld	s3,24(sp)
 8e2:	6121                	addi	sp,sp,64
 8e4:	8082                	ret
 8e6:	74a2                	ld	s1,40(sp)
 8e8:	6a42                	ld	s4,16(sp)
 8ea:	6aa2                	ld	s5,8(sp)
 8ec:	6b02                	ld	s6,0(sp)
 8ee:	b7f5                	j	8da <malloc+0xdc>
