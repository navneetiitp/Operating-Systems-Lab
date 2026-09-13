
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if (argc < 2) {
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for (i = 1; i < argc; i++) {
    if (unlink(argv[i]) < 0) {
  26:	6088                	ld	a0,0(s1)
  28:	36c000ef          	jal	394 <unlink>
  2c:	02054463          	bltz	a0,54 <main+0x54>
  for (i = 1; i < argc; i++) {
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit(0);
  36:	4501                	li	a0,0
  38:	2e4000ef          	jal	31c <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: rm files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	91058593          	addi	a1,a1,-1776 # 950 <malloc+0xfe>
  48:	4509                	li	a0,2
  4a:	726000ef          	jal	770 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2cc000ef          	jal	31c <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	91258593          	addi	a1,a1,-1774 # 968 <malloc+0x116>
  5e:	4509                	li	a0,2
  60:	710000ef          	jal	770 <fprintf>
      break;
  64:	bfc9                	j	36 <main+0x36>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  6e:	f93ff0ef          	jal	0 <main>
  exit(r);
  72:	2aa000ef          	jal	31c <exit>

0000000000000076 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  76:	1141                	addi	sp,sp,-16
  78:	e406                	sd	ra,8(sp)
  7a:	e022                	sd	s0,0(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0xa>
    ;
  return os;
}
  8e:	60a2                	ld	ra,8(sp)
  90:	6402                	ld	s0,0(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cb91                	beqz	a5,b6 <strcmp+0x20>
  a4:	0005c703          	lbu	a4,0(a1)
  a8:	00f71763          	bne	a4,a5,b6 <strcmp+0x20>
    p++, q++;
  ac:	0505                	addi	a0,a0,1
  ae:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	fbe5                	bnez	a5,a4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b6:	0005c503          	lbu	a0,0(a1)
}
  ba:	40a7853b          	subw	a0,a5,a0
  be:	60a2                	ld	ra,8(sp)
  c0:	6402                	ld	s0,0(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strlen>:

uint
strlen(const char *s)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf91                	beqz	a5,ee <strlen+0x28>
  d4:	00150793          	addi	a5,a0,1
  d8:	86be                	mv	a3,a5
  da:	0785                	addi	a5,a5,1
  dc:	fff7c703          	lbu	a4,-1(a5)
  e0:	ff65                	bnez	a4,d8 <strlen+0x12>
  e2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret
  for (n = 0; s[n]; n++)
  ee:	4501                	li	a0,0
  f0:	bfdd                	j	e6 <strlen+0x20>

00000000000000f2 <memset>:

void *
memset(void *dst, int c, uint n)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  fa:	ca19                	beqz	a2,110 <memset+0x1e>
  fc:	87aa                	mv	a5,a0
  fe:	1602                	slli	a2,a2,0x20
 100:	9201                	srli	a2,a2,0x20
 102:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 106:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 10a:	0785                	addi	a5,a5,1
 10c:	fee79de3          	bne	a5,a4,106 <memset+0x14>
  }
  return dst;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strchr>:

char *
strchr(const char *s, char c)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  for (; *s; s++)
 120:	00054783          	lbu	a5,0(a0)
 124:	cf81                	beqz	a5,13c <strchr+0x24>
    if (*s == c)
 126:	00f58763          	beq	a1,a5,134 <strchr+0x1c>
  for (; *s; s++)
 12a:	0505                	addi	a0,a0,1
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbfd                	bnez	a5,126 <strchr+0xe>
      return (char *)s;
  return 0;
 132:	4501                	li	a0,0
}
 134:	60a2                	ld	ra,8(sp)
 136:	6402                	ld	s0,0(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret
  return 0;
 13c:	4501                	li	a0,0
 13e:	bfdd                	j	134 <strchr+0x1c>

0000000000000140 <gets>:

char *
gets(char *buf, int max)
{
 140:	711d                	addi	sp,sp,-96
 142:	ec86                	sd	ra,88(sp)
 144:	e8a2                	sd	s0,80(sp)
 146:	e4a6                	sd	s1,72(sp)
 148:	e0ca                	sd	s2,64(sp)
 14a:	fc4e                	sd	s3,56(sp)
 14c:	f852                	sd	s4,48(sp)
 14e:	f456                	sd	s5,40(sp)
 150:	f05a                	sd	s6,32(sp)
 152:	ec5e                	sd	s7,24(sp)
 154:	e862                	sd	s8,16(sp)
 156:	1080                	addi	s0,sp,96
 158:	8baa                	mv	s7,a0
 15a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 15c:	892a                	mv	s2,a0
 15e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 160:	faf40b13          	addi	s6,s0,-81
 164:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 166:	8c26                	mv	s8,s1
 168:	0014899b          	addiw	s3,s1,1
 16c:	84ce                	mv	s1,s3
 16e:	0349d463          	bge	s3,s4,196 <gets+0x56>
    cc = read(0, &c, 1);
 172:	8656                	mv	a2,s5
 174:	85da                	mv	a1,s6
 176:	4501                	li	a0,0
 178:	1c4000ef          	jal	33c <read>
    if (cc < 1)
 17c:	00a05d63          	blez	a0,196 <gets+0x56>
      break;
    buf[i++] = c;
 180:	faf44783          	lbu	a5,-81(s0)
 184:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 188:	0905                	addi	s2,s2,1
 18a:	ff678713          	addi	a4,a5,-10
 18e:	c319                	beqz	a4,194 <gets+0x54>
 190:	17cd                	addi	a5,a5,-13
 192:	fbf1                	bnez	a5,166 <gets+0x26>
    buf[i++] = c;
 194:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 196:	9c5e                	add	s8,s8,s7
 198:	000c0023          	sb	zero,0(s8)
  return buf;
}
 19c:	855e                	mv	a0,s7
 19e:	60e6                	ld	ra,88(sp)
 1a0:	6446                	ld	s0,80(sp)
 1a2:	64a6                	ld	s1,72(sp)
 1a4:	6906                	ld	s2,64(sp)
 1a6:	79e2                	ld	s3,56(sp)
 1a8:	7a42                	ld	s4,48(sp)
 1aa:	7aa2                	ld	s5,40(sp)
 1ac:	7b02                	ld	s6,32(sp)
 1ae:	6be2                	ld	s7,24(sp)
 1b0:	6c42                	ld	s8,16(sp)
 1b2:	6125                	addi	sp,sp,96
 1b4:	8082                	ret

00000000000001b6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b6:	1101                	addi	sp,sp,-32
 1b8:	ec06                	sd	ra,24(sp)
 1ba:	e822                	sd	s0,16(sp)
 1bc:	e04a                	sd	s2,0(sp)
 1be:	1000                	addi	s0,sp,32
 1c0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c2:	4581                	li	a1,0
 1c4:	1c0000ef          	jal	384 <open>
  if (fd < 0)
 1c8:	02054263          	bltz	a0,1ec <stat+0x36>
 1cc:	e426                	sd	s1,8(sp)
 1ce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d0:	85ca                	mv	a1,s2
 1d2:	1ca000ef          	jal	39c <fstat>
 1d6:	892a                	mv	s2,a0
  close(fd);
 1d8:	8526                	mv	a0,s1
 1da:	192000ef          	jal	36c <close>
  return r;
 1de:	64a2                	ld	s1,8(sp)
}
 1e0:	854a                	mv	a0,s2
 1e2:	60e2                	ld	ra,24(sp)
 1e4:	6442                	ld	s0,16(sp)
 1e6:	6902                	ld	s2,0(sp)
 1e8:	6105                	addi	sp,sp,32
 1ea:	8082                	ret
    return -1;
 1ec:	57fd                	li	a5,-1
 1ee:	893e                	mv	s2,a5
 1f0:	bfc5                	j	1e0 <stat+0x2a>

00000000000001f2 <atoi>:

int
atoi(const char *s)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e406                	sd	ra,8(sp)
 1f6:	e022                	sd	s0,0(sp)
 1f8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1fa:	00054683          	lbu	a3,0(a0)
 1fe:	fd06879b          	addiw	a5,a3,-48
 202:	0ff7f793          	zext.b	a5,a5
 206:	4625                	li	a2,9
 208:	02f66963          	bltu	a2,a5,23a <atoi+0x48>
 20c:	872a                	mv	a4,a0
  n = 0;
 20e:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 210:	0705                	addi	a4,a4,1
 212:	0025179b          	slliw	a5,a0,0x2
 216:	9fa9                	addw	a5,a5,a0
 218:	0017979b          	slliw	a5,a5,0x1
 21c:	9fb5                	addw	a5,a5,a3
 21e:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 222:	00074683          	lbu	a3,0(a4)
 226:	fd06879b          	addiw	a5,a3,-48
 22a:	0ff7f793          	zext.b	a5,a5
 22e:	fef671e3          	bgeu	a2,a5,210 <atoi+0x1e>
  return n;
}
 232:	60a2                	ld	ra,8(sp)
 234:	6402                	ld	s0,0(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret
  n = 0;
 23a:	4501                	li	a0,0
 23c:	bfdd                	j	232 <atoi+0x40>

000000000000023e <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e406                	sd	ra,8(sp)
 242:	e022                	sd	s0,0(sp)
 244:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 246:	02b57563          	bgeu	a0,a1,270 <memmove+0x32>
    while (n-- > 0)
 24a:	00c05f63          	blez	a2,268 <memmove+0x2a>
 24e:	1602                	slli	a2,a2,0x20
 250:	9201                	srli	a2,a2,0x20
 252:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 256:	872a                	mv	a4,a0
      *dst++ = *src++;
 258:	0585                	addi	a1,a1,1
 25a:	0705                	addi	a4,a4,1
 25c:	fff5c683          	lbu	a3,-1(a1)
 260:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 264:	fee79ae3          	bne	a5,a4,258 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 268:	60a2                	ld	ra,8(sp)
 26a:	6402                	ld	s0,0(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
    while (n-- > 0)
 270:	fec05ce3          	blez	a2,268 <memmove+0x2a>
    dst += n;
 274:	00c50733          	add	a4,a0,a2
    src += n;
 278:	95b2                	add	a1,a1,a2
 27a:	fff6079b          	addiw	a5,a2,-1
 27e:	1782                	slli	a5,a5,0x20
 280:	9381                	srli	a5,a5,0x20
 282:	fff7c793          	not	a5,a5
 286:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 288:	15fd                	addi	a1,a1,-1
 28a:	177d                	addi	a4,a4,-1
 28c:	0005c683          	lbu	a3,0(a1)
 290:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 294:	fef71ae3          	bne	a4,a5,288 <memmove+0x4a>
 298:	bfc1                	j	268 <memmove+0x2a>

000000000000029a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a2:	c61d                	beqz	a2,2d0 <memcmp+0x36>
 2a4:	1602                	slli	a2,a2,0x20
 2a6:	9201                	srli	a2,a2,0x20
 2a8:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	0005c703          	lbu	a4,0(a1)
 2b4:	00e79863          	bne	a5,a4,2c4 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2b8:	0505                	addi	a0,a0,1
    p2++;
 2ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2bc:	fed518e3          	bne	a0,a3,2ac <memcmp+0x12>
  }
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	a019                	j	2c8 <memcmp+0x2e>
      return *p1 - *p2;
 2c4:	40e7853b          	subw	a0,a5,a4
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret
  return 0;
 2d0:	4501                	li	a0,0
 2d2:	bfdd                	j	2c8 <memcmp+0x2e>

00000000000002d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2dc:	f63ff0ef          	jal	23e <memmove>
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <sbrk>:

char *
sbrk(int n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f0:	4585                	li	a1,1
 2f2:	0da000ef          	jal	3cc <sys_sbrk>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <sbrklazy>:

char *
sbrklazy(int n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 306:	4589                	li	a1,2
 308:	0c4000ef          	jal	3cc <sys_sbrk>
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 314:	4885                	li	a7,1
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exit>:
.global exit
exit:
 li a7, SYS_exit
 31c:	4889                	li	a7,2
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <wait>:
.global wait
wait:
 li a7, SYS_wait
 324:	488d                	li	a7,3
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 32c:	48b5                	li	a7,13
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 334:	4891                	li	a7,4
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <read>:
.global read
read:
 li a7, SYS_read
 33c:	4895                	li	a7,5
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <write>:
.global write
write:
 li a7, SYS_write
 344:	48c1                	li	a7,16
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <sem_create>:
.global sem_create
sem_create:
 li a7, SYS_sem_create
 34c:	48e1                	li	a7,24
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <sem_wait>:
.global sem_wait
sem_wait:
 li a7, SYS_sem_wait
 354:	48e5                	li	a7,25
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sem_signal>:
.global sem_signal
sem_signal:
 li a7, SYS_sem_signal
 35c:	48e9                	li	a7,26
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <sem_free>:
.global sem_free
sem_free:
 li a7, SYS_sem_free
 364:	48ed                	li	a7,27
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <close>:
.global close
close:
 li a7, SYS_close
 36c:	48d5                	li	a7,21
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <kill>:
.global kill
kill:
 li a7, SYS_kill
 374:	4899                	li	a7,6
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <exec>:
.global exec
exec:
 li a7, SYS_exec
 37c:	489d                	li	a7,7
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <open>:
.global open
open:
 li a7, SYS_open
 384:	48bd                	li	a7,15
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 38c:	48c5                	li	a7,17
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 394:	48c9                	li	a7,18
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 39c:	48a1                	li	a7,8
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <link>:
.global link
link:
 li a7, SYS_link
 3a4:	48cd                	li	a7,19
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ac:	48d1                	li	a7,20
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3b4:	48a5                	li	a7,9
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <dup>:
.global dup
dup:
 li a7, SYS_dup
 3bc:	48a9                	li	a7,10
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c4:	48ad                	li	a7,11
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3cc:	48b1                	li	a7,12
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3d4:	48b5                	li	a7,13
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3dc:	48b9                	li	a7,14
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3e4:	48d9                	li	a7,22
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <shm_get>:
.global shm_get
shm_get:
 li a7, SYS_shm_get
 3ec:	48dd                	li	a7,23
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f4:	1101                	addi	sp,sp,-32
 3f6:	ec06                	sd	ra,24(sp)
 3f8:	e822                	sd	s0,16(sp)
 3fa:	1000                	addi	s0,sp,32
 3fc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 400:	4605                	li	a2,1
 402:	fef40593          	addi	a1,s0,-17
 406:	f3fff0ef          	jal	344 <write>
}
 40a:	60e2                	ld	ra,24(sp)
 40c:	6442                	ld	s0,16(sp)
 40e:	6105                	addi	sp,sp,32
 410:	8082                	ret

0000000000000412 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 412:	715d                	addi	sp,sp,-80
 414:	e486                	sd	ra,72(sp)
 416:	e0a2                	sd	s0,64(sp)
 418:	f84a                	sd	s2,48(sp)
 41a:	f44e                	sd	s3,40(sp)
 41c:	0880                	addi	s0,sp,80
 41e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 420:	c6d1                	beqz	a3,4ac <printint+0x9a>
 422:	0805d563          	bgez	a1,4ac <printint+0x9a>
    neg = 1;
    x = -xx;
 426:	40b005b3          	neg	a1,a1
    neg = 1;
 42a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 42c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 430:	86ce                	mv	a3,s3
  i = 0;
 432:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 434:	00000817          	auipc	a6,0x0
 438:	55c80813          	addi	a6,a6,1372 # 990 <digits>
 43c:	88ba                	mv	a7,a4
 43e:	0017051b          	addiw	a0,a4,1
 442:	872a                	mv	a4,a0
 444:	02c5f7b3          	remu	a5,a1,a2
 448:	97c2                	add	a5,a5,a6
 44a:	0007c783          	lbu	a5,0(a5)
 44e:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 452:	87ae                	mv	a5,a1
 454:	02c5d5b3          	divu	a1,a1,a2
 458:	0685                	addi	a3,a3,1
 45a:	fec7f1e3          	bgeu	a5,a2,43c <printint+0x2a>
  if (neg)
 45e:	00030c63          	beqz	t1,476 <printint+0x64>
    buf[i++] = '-';
 462:	fd050793          	addi	a5,a0,-48
 466:	00878533          	add	a0,a5,s0
 46a:	02d00793          	li	a5,45
 46e:	fef50423          	sb	a5,-24(a0)
 472:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 476:	02e05563          	blez	a4,4a0 <printint+0x8e>
 47a:	fc26                	sd	s1,56(sp)
 47c:	377d                	addiw	a4,a4,-1
 47e:	00e984b3          	add	s1,s3,a4
 482:	19fd                	addi	s3,s3,-1
 484:	99ba                	add	s3,s3,a4
 486:	1702                	slli	a4,a4,0x20
 488:	9301                	srli	a4,a4,0x20
 48a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48e:	0004c583          	lbu	a1,0(s1)
 492:	854a                	mv	a0,s2
 494:	f61ff0ef          	jal	3f4 <putc>
  while (--i >= 0)
 498:	14fd                	addi	s1,s1,-1
 49a:	ff349ae3          	bne	s1,s3,48e <printint+0x7c>
 49e:	74e2                	ld	s1,56(sp)
}
 4a0:	60a6                	ld	ra,72(sp)
 4a2:	6406                	ld	s0,64(sp)
 4a4:	7942                	ld	s2,48(sp)
 4a6:	79a2                	ld	s3,40(sp)
 4a8:	6161                	addi	sp,sp,80
 4aa:	8082                	ret
  neg = 0;
 4ac:	4301                	li	t1,0
 4ae:	bfbd                	j	42c <printint+0x1a>

00000000000004b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b0:	711d                	addi	sp,sp,-96
 4b2:	ec86                	sd	ra,88(sp)
 4b4:	e8a2                	sd	s0,80(sp)
 4b6:	e4a6                	sd	s1,72(sp)
 4b8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4ba:	0005c483          	lbu	s1,0(a1)
 4be:	22048363          	beqz	s1,6e4 <vprintf+0x234>
 4c2:	e0ca                	sd	s2,64(sp)
 4c4:	fc4e                	sd	s3,56(sp)
 4c6:	f852                	sd	s4,48(sp)
 4c8:	f456                	sd	s5,40(sp)
 4ca:	f05a                	sd	s6,32(sp)
 4cc:	ec5e                	sd	s7,24(sp)
 4ce:	e862                	sd	s8,16(sp)
 4d0:	8b2a                	mv	s6,a0
 4d2:	8a2e                	mv	s4,a1
 4d4:	8bb2                	mv	s7,a2
  state = 0;
 4d6:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4d8:	4901                	li	s2,0
 4da:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4dc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4e0:	06400c13          	li	s8,100
 4e4:	a00d                	j	506 <vprintf+0x56>
        putc(fd, c0);
 4e6:	85a6                	mv	a1,s1
 4e8:	855a                	mv	a0,s6
 4ea:	f0bff0ef          	jal	3f4 <putc>
 4ee:	a019                	j	4f4 <vprintf+0x44>
    } else if (state == '%') {
 4f0:	03598363          	beq	s3,s5,516 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4f4:	0019079b          	addiw	a5,s2,1
 4f8:	893e                	mv	s2,a5
 4fa:	873e                	mv	a4,a5
 4fc:	97d2                	add	a5,a5,s4
 4fe:	0007c483          	lbu	s1,0(a5)
 502:	1c048a63          	beqz	s1,6d6 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 506:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 50a:	fe0993e3          	bnez	s3,4f0 <vprintf+0x40>
      if (c0 == '%') {
 50e:	fd579ce3          	bne	a5,s5,4e6 <vprintf+0x36>
        state = '%';
 512:	89be                	mv	s3,a5
 514:	b7c5                	j	4f4 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 516:	00ea06b3          	add	a3,s4,a4
 51a:	0016c603          	lbu	a2,1(a3)
      if (c1)
 51e:	1c060863          	beqz	a2,6ee <vprintf+0x23e>
      if (c0 == 'd') {
 522:	03878763          	beq	a5,s8,550 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 526:	f9478693          	addi	a3,a5,-108
 52a:	0016b693          	seqz	a3,a3
 52e:	f9c60593          	addi	a1,a2,-100
 532:	e99d                	bnez	a1,568 <vprintf+0xb8>
 534:	ca95                	beqz	a3,568 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 536:	008b8493          	addi	s1,s7,8
 53a:	4685                	li	a3,1
 53c:	4629                	li	a2,10
 53e:	000bb583          	ld	a1,0(s7)
 542:	855a                	mv	a0,s6
 544:	ecfff0ef          	jal	412 <printint>
        i += 1;
 548:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 54a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 54c:	4981                	li	s3,0
 54e:	b75d                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 550:	008b8493          	addi	s1,s7,8
 554:	4685                	li	a3,1
 556:	4629                	li	a2,10
 558:	000ba583          	lw	a1,0(s7)
 55c:	855a                	mv	a0,s6
 55e:	eb5ff0ef          	jal	412 <printint>
 562:	8ba6                	mv	s7,s1
      state = 0;
 564:	4981                	li	s3,0
 566:	b779                	j	4f4 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 568:	9752                	add	a4,a4,s4
 56a:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 56e:	f9460713          	addi	a4,a2,-108
 572:	00173713          	seqz	a4,a4
 576:	8f75                	and	a4,a4,a3
 578:	f9c58513          	addi	a0,a1,-100
 57c:	18051363          	bnez	a0,702 <vprintf+0x252>
 580:	18070163          	beqz	a4,702 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 584:	008b8493          	addi	s1,s7,8
 588:	4685                	li	a3,1
 58a:	4629                	li	a2,10
 58c:	000bb583          	ld	a1,0(s7)
 590:	855a                	mv	a0,s6
 592:	e81ff0ef          	jal	412 <printint>
        i += 2;
 596:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 598:	8ba6                	mv	s7,s1
      state = 0;
 59a:	4981                	li	s3,0
        i += 2;
 59c:	bfa1                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 59e:	008b8493          	addi	s1,s7,8
 5a2:	4681                	li	a3,0
 5a4:	4629                	li	a2,10
 5a6:	000be583          	lwu	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	e67ff0ef          	jal	412 <printint>
 5b0:	8ba6                	mv	s7,s1
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	b781                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b6:	008b8493          	addi	s1,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4629                	li	a2,10
 5be:	000bb583          	ld	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	e4fff0ef          	jal	412 <printint>
        i += 1;
 5c8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	8ba6                	mv	s7,s1
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b71d                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	008b8493          	addi	s1,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4629                	li	a2,10
 5d8:	000bb583          	ld	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	e35ff0ef          	jal	412 <printint>
        i += 2;
 5e2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e4:	8ba6                	mv	s7,s1
      state = 0;
 5e6:	4981                	li	s3,0
        i += 2;
 5e8:	b731                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5ea:	008b8493          	addi	s1,s7,8
 5ee:	4681                	li	a3,0
 5f0:	4641                	li	a2,16
 5f2:	000be583          	lwu	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	e1bff0ef          	jal	412 <printint>
 5fc:	8ba6                	mv	s7,s1
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bdd5                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 602:	008b8493          	addi	s1,s7,8
 606:	4681                	li	a3,0
 608:	4641                	li	a2,16
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	e03ff0ef          	jal	412 <printint>
        i += 1;
 614:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	8ba6                	mv	s7,s1
      state = 0;
 618:	4981                	li	s3,0
 61a:	bde9                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	008b8493          	addi	s1,s7,8
 620:	4681                	li	a3,0
 622:	4641                	li	a2,16
 624:	000bb583          	ld	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	de9ff0ef          	jal	412 <printint>
        i += 2;
 62e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 630:	8ba6                	mv	s7,s1
      state = 0;
 632:	4981                	li	s3,0
        i += 2;
 634:	b5c1                	j	4f4 <vprintf+0x44>
 636:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 638:	008b8793          	addi	a5,s7,8
 63c:	8cbe                	mv	s9,a5
 63e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 642:	03000593          	li	a1,48
 646:	855a                	mv	a0,s6
 648:	dadff0ef          	jal	3f4 <putc>
  putc(fd, 'x');
 64c:	07800593          	li	a1,120
 650:	855a                	mv	a0,s6
 652:	da3ff0ef          	jal	3f4 <putc>
 656:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 658:	00000b97          	auipc	s7,0x0
 65c:	338b8b93          	addi	s7,s7,824 # 990 <digits>
 660:	03c9d793          	srli	a5,s3,0x3c
 664:	97de                	add	a5,a5,s7
 666:	0007c583          	lbu	a1,0(a5)
 66a:	855a                	mv	a0,s6
 66c:	d89ff0ef          	jal	3f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 670:	0992                	slli	s3,s3,0x4
 672:	34fd                	addiw	s1,s1,-1
 674:	f4f5                	bnez	s1,660 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 676:	8be6                	mv	s7,s9
      state = 0;
 678:	4981                	li	s3,0
 67a:	6ca2                	ld	s9,8(sp)
 67c:	bda5                	j	4f4 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 67e:	008b8493          	addi	s1,s7,8
 682:	000bc583          	lbu	a1,0(s7)
 686:	855a                	mv	a0,s6
 688:	d6dff0ef          	jal	3f4 <putc>
 68c:	8ba6                	mv	s7,s1
      state = 0;
 68e:	4981                	li	s3,0
 690:	b595                	j	4f4 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 692:	008b8993          	addi	s3,s7,8
 696:	000bb483          	ld	s1,0(s7)
 69a:	cc91                	beqz	s1,6b6 <vprintf+0x206>
        for (; *s; s++)
 69c:	0004c583          	lbu	a1,0(s1)
 6a0:	c985                	beqz	a1,6d0 <vprintf+0x220>
          putc(fd, *s);
 6a2:	855a                	mv	a0,s6
 6a4:	d51ff0ef          	jal	3f4 <putc>
        for (; *s; s++)
 6a8:	0485                	addi	s1,s1,1
 6aa:	0004c583          	lbu	a1,0(s1)
 6ae:	f9f5                	bnez	a1,6a2 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 6b0:	8bce                	mv	s7,s3
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	b581                	j	4f4 <vprintf+0x44>
          s = "(null)";
 6b6:	00000497          	auipc	s1,0x0
 6ba:	2d248493          	addi	s1,s1,722 # 988 <malloc+0x136>
        for (; *s; s++)
 6be:	02800593          	li	a1,40
 6c2:	b7c5                	j	6a2 <vprintf+0x1f2>
        putc(fd, '%');
 6c4:	85be                	mv	a1,a5
 6c6:	855a                	mv	a0,s6
 6c8:	d2dff0ef          	jal	3f4 <putc>
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b51d                	j	4f4 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6d0:	8bce                	mv	s7,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b505                	j	4f4 <vprintf+0x44>
 6d6:	6906                	ld	s2,64(sp)
 6d8:	79e2                	ld	s3,56(sp)
 6da:	7a42                	ld	s4,48(sp)
 6dc:	7aa2                	ld	s5,40(sp)
 6de:	7b02                	ld	s6,32(sp)
 6e0:	6be2                	ld	s7,24(sp)
 6e2:	6c42                	ld	s8,16(sp)
    }
  }
}
 6e4:	60e6                	ld	ra,88(sp)
 6e6:	6446                	ld	s0,80(sp)
 6e8:	64a6                	ld	s1,72(sp)
 6ea:	6125                	addi	sp,sp,96
 6ec:	8082                	ret
      if (c0 == 'd') {
 6ee:	06400713          	li	a4,100
 6f2:	e4e78fe3          	beq	a5,a4,550 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 6f6:	f9478693          	addi	a3,a5,-108
 6fa:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6fe:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 700:	4701                	li	a4,0
      } else if (c0 == 'u') {
 702:	07500513          	li	a0,117
 706:	e8a78ce3          	beq	a5,a0,59e <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 70a:	f8b60513          	addi	a0,a2,-117
 70e:	e119                	bnez	a0,714 <vprintf+0x264>
 710:	ea0693e3          	bnez	a3,5b6 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 714:	f8b58513          	addi	a0,a1,-117
 718:	e119                	bnez	a0,71e <vprintf+0x26e>
 71a:	ea071be3          	bnez	a4,5d0 <vprintf+0x120>
      } else if (c0 == 'x') {
 71e:	07800513          	li	a0,120
 722:	eca784e3          	beq	a5,a0,5ea <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 726:	f8860613          	addi	a2,a2,-120
 72a:	e219                	bnez	a2,730 <vprintf+0x280>
 72c:	ec069be3          	bnez	a3,602 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 730:	f8858593          	addi	a1,a1,-120
 734:	e199                	bnez	a1,73a <vprintf+0x28a>
 736:	ee0713e3          	bnez	a4,61c <vprintf+0x16c>
      } else if (c0 == 'p') {
 73a:	07000713          	li	a4,112
 73e:	eee78ce3          	beq	a5,a4,636 <vprintf+0x186>
      } else if (c0 == 'c') {
 742:	06300713          	li	a4,99
 746:	f2e78ce3          	beq	a5,a4,67e <vprintf+0x1ce>
      } else if (c0 == 's') {
 74a:	07300713          	li	a4,115
 74e:	f4e782e3          	beq	a5,a4,692 <vprintf+0x1e2>
      } else if (c0 == '%') {
 752:	02500713          	li	a4,37
 756:	f6e787e3          	beq	a5,a4,6c4 <vprintf+0x214>
        putc(fd, '%');
 75a:	02500593          	li	a1,37
 75e:	855a                	mv	a0,s6
 760:	c95ff0ef          	jal	3f4 <putc>
        putc(fd, c0);
 764:	85a6                	mv	a1,s1
 766:	855a                	mv	a0,s6
 768:	c8dff0ef          	jal	3f4 <putc>
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b359                	j	4f4 <vprintf+0x44>

0000000000000770 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 770:	715d                	addi	sp,sp,-80
 772:	ec06                	sd	ra,24(sp)
 774:	e822                	sd	s0,16(sp)
 776:	1000                	addi	s0,sp,32
 778:	e010                	sd	a2,0(s0)
 77a:	e414                	sd	a3,8(s0)
 77c:	e818                	sd	a4,16(s0)
 77e:	ec1c                	sd	a5,24(s0)
 780:	03043023          	sd	a6,32(s0)
 784:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 788:	8622                	mv	a2,s0
 78a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 78e:	d23ff0ef          	jal	4b0 <vprintf>
}
 792:	60e2                	ld	ra,24(sp)
 794:	6442                	ld	s0,16(sp)
 796:	6161                	addi	sp,sp,80
 798:	8082                	ret

000000000000079a <printf>:

void
printf(const char *fmt, ...)
{
 79a:	711d                	addi	sp,sp,-96
 79c:	ec06                	sd	ra,24(sp)
 79e:	e822                	sd	s0,16(sp)
 7a0:	1000                	addi	s0,sp,32
 7a2:	e40c                	sd	a1,8(s0)
 7a4:	e810                	sd	a2,16(s0)
 7a6:	ec14                	sd	a3,24(s0)
 7a8:	f018                	sd	a4,32(s0)
 7aa:	f41c                	sd	a5,40(s0)
 7ac:	03043823          	sd	a6,48(s0)
 7b0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b4:	00840613          	addi	a2,s0,8
 7b8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7bc:	85aa                	mv	a1,a0
 7be:	4505                	li	a0,1
 7c0:	cf1ff0ef          	jal	4b0 <vprintf>
}
 7c4:	60e2                	ld	ra,24(sp)
 7c6:	6442                	ld	s0,16(sp)
 7c8:	6125                	addi	sp,sp,96
 7ca:	8082                	ret

00000000000007cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7cc:	1141                	addi	sp,sp,-16
 7ce:	e406                	sd	ra,8(sp)
 7d0:	e022                	sd	s0,0(sp)
 7d2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7d4:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	00001797          	auipc	a5,0x1
 7dc:	8287b783          	ld	a5,-2008(a5) # 1000 <freep>
 7e0:	a039                	j	7ee <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	6398                	ld	a4,0(a5)
 7e4:	00e7e463          	bltu	a5,a4,7ec <free+0x20>
 7e8:	00e6ea63          	bltu	a3,a4,7fc <free+0x30>
{
 7ec:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	fed7fae3          	bgeu	a5,a3,7e2 <free+0x16>
 7f2:	6398                	ld	a4,0(a5)
 7f4:	00e6e463          	bltu	a3,a4,7fc <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	fee7eae3          	bltu	a5,a4,7ec <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7fc:	ff852583          	lw	a1,-8(a0)
 800:	6390                	ld	a2,0(a5)
 802:	02059813          	slli	a6,a1,0x20
 806:	01c85713          	srli	a4,a6,0x1c
 80a:	9736                	add	a4,a4,a3
 80c:	02e60563          	beq	a2,a4,836 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 810:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 814:	4790                	lw	a2,8(a5)
 816:	02061593          	slli	a1,a2,0x20
 81a:	01c5d713          	srli	a4,a1,0x1c
 81e:	973e                	add	a4,a4,a5
 820:	02e68263          	beq	a3,a4,844 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 824:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 826:	00000717          	auipc	a4,0x0
 82a:	7cf73d23          	sd	a5,2010(a4) # 1000 <freep>
}
 82e:	60a2                	ld	ra,8(sp)
 830:	6402                	ld	s0,0(sp)
 832:	0141                	addi	sp,sp,16
 834:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 836:	4618                	lw	a4,8(a2)
 838:	9f2d                	addw	a4,a4,a1
 83a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83e:	6398                	ld	a4,0(a5)
 840:	6310                	ld	a2,0(a4)
 842:	b7f9                	j	810 <free+0x44>
    p->s.size += bp->s.size;
 844:	ff852703          	lw	a4,-8(a0)
 848:	9f31                	addw	a4,a4,a2
 84a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 84c:	ff053683          	ld	a3,-16(a0)
 850:	bfd1                	j	824 <free+0x58>

0000000000000852 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 852:	7139                	addi	sp,sp,-64
 854:	fc06                	sd	ra,56(sp)
 856:	f822                	sd	s0,48(sp)
 858:	f04a                	sd	s2,32(sp)
 85a:	ec4e                	sd	s3,24(sp)
 85c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 85e:	02051993          	slli	s3,a0,0x20
 862:	0209d993          	srli	s3,s3,0x20
 866:	09bd                	addi	s3,s3,15
 868:	0049d993          	srli	s3,s3,0x4
 86c:	2985                	addiw	s3,s3,1
 86e:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 870:	00000517          	auipc	a0,0x0
 874:	79053503          	ld	a0,1936(a0) # 1000 <freep>
 878:	c905                	beqz	a0,8a8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 87a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 87c:	4798                	lw	a4,8(a5)
 87e:	09377663          	bgeu	a4,s3,90a <malloc+0xb8>
 882:	f426                	sd	s1,40(sp)
 884:	e852                	sd	s4,16(sp)
 886:	e456                	sd	s5,8(sp)
 888:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 88a:	8a4e                	mv	s4,s3
 88c:	6705                	lui	a4,0x1
 88e:	00e9f363          	bgeu	s3,a4,894 <malloc+0x42>
 892:	6a05                	lui	s4,0x1
 894:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 898:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 89c:	00000497          	auipc	s1,0x0
 8a0:	76448493          	addi	s1,s1,1892 # 1000 <freep>
  if (p == SBRK_ERROR)
 8a4:	5afd                	li	s5,-1
 8a6:	a83d                	j	8e4 <malloc+0x92>
 8a8:	f426                	sd	s1,40(sp)
 8aa:	e852                	sd	s4,16(sp)
 8ac:	e456                	sd	s5,8(sp)
 8ae:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b0:	00000797          	auipc	a5,0x0
 8b4:	76078793          	addi	a5,a5,1888 # 1010 <base>
 8b8:	00000717          	auipc	a4,0x0
 8bc:	74f73423          	sd	a5,1864(a4) # 1000 <freep>
 8c0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c2:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8c6:	b7d1                	j	88a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8c8:	6398                	ld	a4,0(a5)
 8ca:	e118                	sd	a4,0(a0)
 8cc:	a899                	j	922 <malloc+0xd0>
  hp->s.size = nu;
 8ce:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8d2:	0541                	addi	a0,a0,16
 8d4:	ef9ff0ef          	jal	7cc <free>
  return freep;
 8d8:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8da:	c125                	beqz	a0,93a <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8dc:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8de:	4798                	lw	a4,8(a5)
 8e0:	03277163          	bgeu	a4,s2,902 <malloc+0xb0>
    if (p == freep)
 8e4:	6098                	ld	a4,0(s1)
 8e6:	853e                	mv	a0,a5
 8e8:	fef71ae3          	bne	a4,a5,8dc <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8ec:	8552                	mv	a0,s4
 8ee:	9fbff0ef          	jal	2e8 <sbrk>
  if (p == SBRK_ERROR)
 8f2:	fd551ee3          	bne	a0,s5,8ce <malloc+0x7c>
        return 0;
 8f6:	4501                	li	a0,0
 8f8:	74a2                	ld	s1,40(sp)
 8fa:	6a42                	ld	s4,16(sp)
 8fc:	6aa2                	ld	s5,8(sp)
 8fe:	6b02                	ld	s6,0(sp)
 900:	a03d                	j	92e <malloc+0xdc>
 902:	74a2                	ld	s1,40(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 90a:	fae90fe3          	beq	s2,a4,8c8 <malloc+0x76>
        p->s.size -= nunits;
 90e:	4137073b          	subw	a4,a4,s3
 912:	c798                	sw	a4,8(a5)
        p += p->s.size;
 914:	02071693          	slli	a3,a4,0x20
 918:	01c6d713          	srli	a4,a3,0x1c
 91c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 91e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 922:	00000717          	auipc	a4,0x0
 926:	6ca73f23          	sd	a0,1758(a4) # 1000 <freep>
      return (void *)(p + 1);
 92a:	01078513          	addi	a0,a5,16
  }
}
 92e:	70e2                	ld	ra,56(sp)
 930:	7442                	ld	s0,48(sp)
 932:	7902                	ld	s2,32(sp)
 934:	69e2                	ld	s3,24(sp)
 936:	6121                	addi	sp,sp,64
 938:	8082                	ret
 93a:	74a2                	ld	s1,40(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
 942:	b7f5                	j	92e <malloc+0xdc>
