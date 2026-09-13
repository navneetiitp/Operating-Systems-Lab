
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
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
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for (i = 1; i < argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1b8000ef          	jal	1e0 <atoi>
  2c:	336000ef          	jal	362 <kill>
  for (i = 1; i < argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	2d2000ef          	jal	30a <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
  44:	90058593          	addi	a1,a1,-1792 # 940 <malloc+0x100>
  48:	4509                	li	a0,2
  4a:	714000ef          	jal	75e <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2ba000ef          	jal	30a <exit>

0000000000000054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  5c:	fa5ff0ef          	jal	0 <main>
  exit(r);
  60:	2aa000ef          	jal	30a <exit>

0000000000000064 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  6c:	87aa                	mv	a5,a0
  6e:	0585                	addi	a1,a1,1
  70:	0785                	addi	a5,a5,1
  72:	fff5c703          	lbu	a4,-1(a1)
  76:	fee78fa3          	sb	a4,-1(a5)
  7a:	fb75                	bnez	a4,6e <strcpy+0xa>
    ;
  return os;
}
  7c:	60a2                	ld	ra,8(sp)
  7e:	6402                	ld	s0,0(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  8c:	00054783          	lbu	a5,0(a0)
  90:	cb91                	beqz	a5,a4 <strcmp+0x20>
  92:	0005c703          	lbu	a4,0(a1)
  96:	00f71763          	bne	a4,a5,a4 <strcmp+0x20>
    p++, q++;
  9a:	0505                	addi	a0,a0,1
  9c:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	fbe5                	bnez	a5,92 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a4:	0005c503          	lbu	a0,0(a1)
}
  a8:	40a7853b          	subw	a0,a5,a0
  ac:	60a2                	ld	ra,8(sp)
  ae:	6402                	ld	s0,0(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strlen>:

uint
strlen(const char *s)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cf91                	beqz	a5,dc <strlen+0x28>
  c2:	00150793          	addi	a5,a0,1
  c6:	86be                	mv	a3,a5
  c8:	0785                	addi	a5,a5,1
  ca:	fff7c703          	lbu	a4,-1(a5)
  ce:	ff65                	bnez	a4,c6 <strlen+0x12>
  d0:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret
  for (n = 0; s[n]; n++)
  dc:	4501                	li	a0,0
  de:	bfdd                	j	d4 <strlen+0x20>

00000000000000e0 <memset>:

void *
memset(void *dst, int c, uint n)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e406                	sd	ra,8(sp)
  e4:	e022                	sd	s0,0(sp)
  e6:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  e8:	ca19                	beqz	a2,fe <memset+0x1e>
  ea:	87aa                	mv	a5,a0
  ec:	1602                	slli	a2,a2,0x20
  ee:	9201                	srli	a2,a2,0x20
  f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f4:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  f8:	0785                	addi	a5,a5,1
  fa:	fee79de3          	bne	a5,a4,f4 <memset+0x14>
  }
  return dst;
}
  fe:	60a2                	ld	ra,8(sp)
 100:	6402                	ld	s0,0(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strchr>:

char *
strchr(const char *s, char c)
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  for (; *s; s++)
 10e:	00054783          	lbu	a5,0(a0)
 112:	cf81                	beqz	a5,12a <strchr+0x24>
    if (*s == c)
 114:	00f58763          	beq	a1,a5,122 <strchr+0x1c>
  for (; *s; s++)
 118:	0505                	addi	a0,a0,1
 11a:	00054783          	lbu	a5,0(a0)
 11e:	fbfd                	bnez	a5,114 <strchr+0xe>
      return (char *)s;
  return 0;
 120:	4501                	li	a0,0
}
 122:	60a2                	ld	ra,8(sp)
 124:	6402                	ld	s0,0(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret
  return 0;
 12a:	4501                	li	a0,0
 12c:	bfdd                	j	122 <strchr+0x1c>

000000000000012e <gets>:

char *
gets(char *buf, int max)
{
 12e:	711d                	addi	sp,sp,-96
 130:	ec86                	sd	ra,88(sp)
 132:	e8a2                	sd	s0,80(sp)
 134:	e4a6                	sd	s1,72(sp)
 136:	e0ca                	sd	s2,64(sp)
 138:	fc4e                	sd	s3,56(sp)
 13a:	f852                	sd	s4,48(sp)
 13c:	f456                	sd	s5,40(sp)
 13e:	f05a                	sd	s6,32(sp)
 140:	ec5e                	sd	s7,24(sp)
 142:	e862                	sd	s8,16(sp)
 144:	1080                	addi	s0,sp,96
 146:	8baa                	mv	s7,a0
 148:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 14a:	892a                	mv	s2,a0
 14c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 14e:	faf40b13          	addi	s6,s0,-81
 152:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 154:	8c26                	mv	s8,s1
 156:	0014899b          	addiw	s3,s1,1
 15a:	84ce                	mv	s1,s3
 15c:	0349d463          	bge	s3,s4,184 <gets+0x56>
    cc = read(0, &c, 1);
 160:	8656                	mv	a2,s5
 162:	85da                	mv	a1,s6
 164:	4501                	li	a0,0
 166:	1c4000ef          	jal	32a <read>
    if (cc < 1)
 16a:	00a05d63          	blez	a0,184 <gets+0x56>
      break;
    buf[i++] = c;
 16e:	faf44783          	lbu	a5,-81(s0)
 172:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 176:	0905                	addi	s2,s2,1
 178:	ff678713          	addi	a4,a5,-10
 17c:	c319                	beqz	a4,182 <gets+0x54>
 17e:	17cd                	addi	a5,a5,-13
 180:	fbf1                	bnez	a5,154 <gets+0x26>
    buf[i++] = c;
 182:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 184:	9c5e                	add	s8,s8,s7
 186:	000c0023          	sb	zero,0(s8)
  return buf;
}
 18a:	855e                	mv	a0,s7
 18c:	60e6                	ld	ra,88(sp)
 18e:	6446                	ld	s0,80(sp)
 190:	64a6                	ld	s1,72(sp)
 192:	6906                	ld	s2,64(sp)
 194:	79e2                	ld	s3,56(sp)
 196:	7a42                	ld	s4,48(sp)
 198:	7aa2                	ld	s5,40(sp)
 19a:	7b02                	ld	s6,32(sp)
 19c:	6be2                	ld	s7,24(sp)
 19e:	6c42                	ld	s8,16(sp)
 1a0:	6125                	addi	sp,sp,96
 1a2:	8082                	ret

00000000000001a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a4:	1101                	addi	sp,sp,-32
 1a6:	ec06                	sd	ra,24(sp)
 1a8:	e822                	sd	s0,16(sp)
 1aa:	e04a                	sd	s2,0(sp)
 1ac:	1000                	addi	s0,sp,32
 1ae:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b0:	4581                	li	a1,0
 1b2:	1c0000ef          	jal	372 <open>
  if (fd < 0)
 1b6:	02054263          	bltz	a0,1da <stat+0x36>
 1ba:	e426                	sd	s1,8(sp)
 1bc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1be:	85ca                	mv	a1,s2
 1c0:	1ca000ef          	jal	38a <fstat>
 1c4:	892a                	mv	s2,a0
  close(fd);
 1c6:	8526                	mv	a0,s1
 1c8:	192000ef          	jal	35a <close>
  return r;
 1cc:	64a2                	ld	s1,8(sp)
}
 1ce:	854a                	mv	a0,s2
 1d0:	60e2                	ld	ra,24(sp)
 1d2:	6442                	ld	s0,16(sp)
 1d4:	6902                	ld	s2,0(sp)
 1d6:	6105                	addi	sp,sp,32
 1d8:	8082                	ret
    return -1;
 1da:	57fd                	li	a5,-1
 1dc:	893e                	mv	s2,a5
 1de:	bfc5                	j	1ce <stat+0x2a>

00000000000001e0 <atoi>:

int
atoi(const char *s)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e406                	sd	ra,8(sp)
 1e4:	e022                	sd	s0,0(sp)
 1e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1e8:	00054683          	lbu	a3,0(a0)
 1ec:	fd06879b          	addiw	a5,a3,-48
 1f0:	0ff7f793          	zext.b	a5,a5
 1f4:	4625                	li	a2,9
 1f6:	02f66963          	bltu	a2,a5,228 <atoi+0x48>
 1fa:	872a                	mv	a4,a0
  n = 0;
 1fc:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1fe:	0705                	addi	a4,a4,1
 200:	0025179b          	slliw	a5,a0,0x2
 204:	9fa9                	addw	a5,a5,a0
 206:	0017979b          	slliw	a5,a5,0x1
 20a:	9fb5                	addw	a5,a5,a3
 20c:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 210:	00074683          	lbu	a3,0(a4)
 214:	fd06879b          	addiw	a5,a3,-48
 218:	0ff7f793          	zext.b	a5,a5
 21c:	fef671e3          	bgeu	a2,a5,1fe <atoi+0x1e>
  return n;
}
 220:	60a2                	ld	ra,8(sp)
 222:	6402                	ld	s0,0(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret
  n = 0;
 228:	4501                	li	a0,0
 22a:	bfdd                	j	220 <atoi+0x40>

000000000000022c <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e406                	sd	ra,8(sp)
 230:	e022                	sd	s0,0(sp)
 232:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 234:	02b57563          	bgeu	a0,a1,25e <memmove+0x32>
    while (n-- > 0)
 238:	00c05f63          	blez	a2,256 <memmove+0x2a>
 23c:	1602                	slli	a2,a2,0x20
 23e:	9201                	srli	a2,a2,0x20
 240:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 244:	872a                	mv	a4,a0
      *dst++ = *src++;
 246:	0585                	addi	a1,a1,1
 248:	0705                	addi	a4,a4,1
 24a:	fff5c683          	lbu	a3,-1(a1)
 24e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 252:	fee79ae3          	bne	a5,a4,246 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 256:	60a2                	ld	ra,8(sp)
 258:	6402                	ld	s0,0(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
    while (n-- > 0)
 25e:	fec05ce3          	blez	a2,256 <memmove+0x2a>
    dst += n;
 262:	00c50733          	add	a4,a0,a2
    src += n;
 266:	95b2                	add	a1,a1,a2
 268:	fff6079b          	addiw	a5,a2,-1
 26c:	1782                	slli	a5,a5,0x20
 26e:	9381                	srli	a5,a5,0x20
 270:	fff7c793          	not	a5,a5
 274:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 276:	15fd                	addi	a1,a1,-1
 278:	177d                	addi	a4,a4,-1
 27a:	0005c683          	lbu	a3,0(a1)
 27e:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 282:	fef71ae3          	bne	a4,a5,276 <memmove+0x4a>
 286:	bfc1                	j	256 <memmove+0x2a>

0000000000000288 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 290:	c61d                	beqz	a2,2be <memcmp+0x36>
 292:	1602                	slli	a2,a2,0x20
 294:	9201                	srli	a2,a2,0x20
 296:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 29a:	00054783          	lbu	a5,0(a0)
 29e:	0005c703          	lbu	a4,0(a1)
 2a2:	00e79863          	bne	a5,a4,2b2 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2a6:	0505                	addi	a0,a0,1
    p2++;
 2a8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2aa:	fed518e3          	bne	a0,a3,29a <memcmp+0x12>
  }
  return 0;
 2ae:	4501                	li	a0,0
 2b0:	a019                	j	2b6 <memcmp+0x2e>
      return *p1 - *p2;
 2b2:	40e7853b          	subw	a0,a5,a4
}
 2b6:	60a2                	ld	ra,8(sp)
 2b8:	6402                	ld	s0,0(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret
  return 0;
 2be:	4501                	li	a0,0
 2c0:	bfdd                	j	2b6 <memcmp+0x2e>

00000000000002c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ca:	f63ff0ef          	jal	22c <memmove>
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret

00000000000002d6 <sbrk>:

char *
sbrk(int n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2de:	4585                	li	a1,1
 2e0:	0da000ef          	jal	3ba <sys_sbrk>
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <sbrklazy>:

char *
sbrklazy(int n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2f4:	4589                	li	a1,2
 2f6:	0c4000ef          	jal	3ba <sys_sbrk>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 302:	4885                	li	a7,1
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <exit>:
.global exit
exit:
 li a7, SYS_exit
 30a:	4889                	li	a7,2
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <wait>:
.global wait
wait:
 li a7, SYS_wait
 312:	488d                	li	a7,3
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 31a:	48b5                	li	a7,13
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 322:	4891                	li	a7,4
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <read>:
.global read
read:
 li a7, SYS_read
 32a:	4895                	li	a7,5
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <write>:
.global write
write:
 li a7, SYS_write
 332:	48c1                	li	a7,16
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <sem_create>:
.global sem_create
sem_create:
 li a7, SYS_sem_create
 33a:	48e1                	li	a7,24
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <sem_wait>:
.global sem_wait
sem_wait:
 li a7, SYS_sem_wait
 342:	48e5                	li	a7,25
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <sem_signal>:
.global sem_signal
sem_signal:
 li a7, SYS_sem_signal
 34a:	48e9                	li	a7,26
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <sem_free>:
.global sem_free
sem_free:
 li a7, SYS_sem_free
 352:	48ed                	li	a7,27
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <close>:
.global close
close:
 li a7, SYS_close
 35a:	48d5                	li	a7,21
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <kill>:
.global kill
kill:
 li a7, SYS_kill
 362:	4899                	li	a7,6
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <exec>:
.global exec
exec:
 li a7, SYS_exec
 36a:	489d                	li	a7,7
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <open>:
.global open
open:
 li a7, SYS_open
 372:	48bd                	li	a7,15
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37a:	48c5                	li	a7,17
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 382:	48c9                	li	a7,18
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38a:	48a1                	li	a7,8
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <link>:
.global link
link:
 li a7, SYS_link
 392:	48cd                	li	a7,19
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39a:	48d1                	li	a7,20
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a2:	48a5                	li	a7,9
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <dup>:
.global dup
dup:
 li a7, SYS_dup
 3aa:	48a9                	li	a7,10
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b2:	48ad                	li	a7,11
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3ba:	48b1                	li	a7,12
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3c2:	48b5                	li	a7,13
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ca:	48b9                	li	a7,14
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3d2:	48d9                	li	a7,22
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <shm_get>:
.global shm_get
shm_get:
 li a7, SYS_shm_get
 3da:	48dd                	li	a7,23
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e2:	1101                	addi	sp,sp,-32
 3e4:	ec06                	sd	ra,24(sp)
 3e6:	e822                	sd	s0,16(sp)
 3e8:	1000                	addi	s0,sp,32
 3ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ee:	4605                	li	a2,1
 3f0:	fef40593          	addi	a1,s0,-17
 3f4:	f3fff0ef          	jal	332 <write>
}
 3f8:	60e2                	ld	ra,24(sp)
 3fa:	6442                	ld	s0,16(sp)
 3fc:	6105                	addi	sp,sp,32
 3fe:	8082                	ret

0000000000000400 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 400:	715d                	addi	sp,sp,-80
 402:	e486                	sd	ra,72(sp)
 404:	e0a2                	sd	s0,64(sp)
 406:	f84a                	sd	s2,48(sp)
 408:	f44e                	sd	s3,40(sp)
 40a:	0880                	addi	s0,sp,80
 40c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 40e:	c6d1                	beqz	a3,49a <printint+0x9a>
 410:	0805d563          	bgez	a1,49a <printint+0x9a>
    neg = 1;
    x = -xx;
 414:	40b005b3          	neg	a1,a1
    neg = 1;
 418:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 41a:	fb840993          	addi	s3,s0,-72
  neg = 0;
 41e:	86ce                	mv	a3,s3
  i = 0;
 420:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 422:	00000817          	auipc	a6,0x0
 426:	53e80813          	addi	a6,a6,1342 # 960 <digits>
 42a:	88ba                	mv	a7,a4
 42c:	0017051b          	addiw	a0,a4,1
 430:	872a                	mv	a4,a0
 432:	02c5f7b3          	remu	a5,a1,a2
 436:	97c2                	add	a5,a5,a6
 438:	0007c783          	lbu	a5,0(a5)
 43c:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 440:	87ae                	mv	a5,a1
 442:	02c5d5b3          	divu	a1,a1,a2
 446:	0685                	addi	a3,a3,1
 448:	fec7f1e3          	bgeu	a5,a2,42a <printint+0x2a>
  if (neg)
 44c:	00030c63          	beqz	t1,464 <printint+0x64>
    buf[i++] = '-';
 450:	fd050793          	addi	a5,a0,-48
 454:	00878533          	add	a0,a5,s0
 458:	02d00793          	li	a5,45
 45c:	fef50423          	sb	a5,-24(a0)
 460:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 464:	02e05563          	blez	a4,48e <printint+0x8e>
 468:	fc26                	sd	s1,56(sp)
 46a:	377d                	addiw	a4,a4,-1
 46c:	00e984b3          	add	s1,s3,a4
 470:	19fd                	addi	s3,s3,-1
 472:	99ba                	add	s3,s3,a4
 474:	1702                	slli	a4,a4,0x20
 476:	9301                	srli	a4,a4,0x20
 478:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 47c:	0004c583          	lbu	a1,0(s1)
 480:	854a                	mv	a0,s2
 482:	f61ff0ef          	jal	3e2 <putc>
  while (--i >= 0)
 486:	14fd                	addi	s1,s1,-1
 488:	ff349ae3          	bne	s1,s3,47c <printint+0x7c>
 48c:	74e2                	ld	s1,56(sp)
}
 48e:	60a6                	ld	ra,72(sp)
 490:	6406                	ld	s0,64(sp)
 492:	7942                	ld	s2,48(sp)
 494:	79a2                	ld	s3,40(sp)
 496:	6161                	addi	sp,sp,80
 498:	8082                	ret
  neg = 0;
 49a:	4301                	li	t1,0
 49c:	bfbd                	j	41a <printint+0x1a>

000000000000049e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 49e:	711d                	addi	sp,sp,-96
 4a0:	ec86                	sd	ra,88(sp)
 4a2:	e8a2                	sd	s0,80(sp)
 4a4:	e4a6                	sd	s1,72(sp)
 4a6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4a8:	0005c483          	lbu	s1,0(a1)
 4ac:	22048363          	beqz	s1,6d2 <vprintf+0x234>
 4b0:	e0ca                	sd	s2,64(sp)
 4b2:	fc4e                	sd	s3,56(sp)
 4b4:	f852                	sd	s4,48(sp)
 4b6:	f456                	sd	s5,40(sp)
 4b8:	f05a                	sd	s6,32(sp)
 4ba:	ec5e                	sd	s7,24(sp)
 4bc:	e862                	sd	s8,16(sp)
 4be:	8b2a                	mv	s6,a0
 4c0:	8a2e                	mv	s4,a1
 4c2:	8bb2                	mv	s7,a2
  state = 0;
 4c4:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4c6:	4901                	li	s2,0
 4c8:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4ca:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4ce:	06400c13          	li	s8,100
 4d2:	a00d                	j	4f4 <vprintf+0x56>
        putc(fd, c0);
 4d4:	85a6                	mv	a1,s1
 4d6:	855a                	mv	a0,s6
 4d8:	f0bff0ef          	jal	3e2 <putc>
 4dc:	a019                	j	4e2 <vprintf+0x44>
    } else if (state == '%') {
 4de:	03598363          	beq	s3,s5,504 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4e2:	0019079b          	addiw	a5,s2,1
 4e6:	893e                	mv	s2,a5
 4e8:	873e                	mv	a4,a5
 4ea:	97d2                	add	a5,a5,s4
 4ec:	0007c483          	lbu	s1,0(a5)
 4f0:	1c048a63          	beqz	s1,6c4 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4f4:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4f8:	fe0993e3          	bnez	s3,4de <vprintf+0x40>
      if (c0 == '%') {
 4fc:	fd579ce3          	bne	a5,s5,4d4 <vprintf+0x36>
        state = '%';
 500:	89be                	mv	s3,a5
 502:	b7c5                	j	4e2 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 504:	00ea06b3          	add	a3,s4,a4
 508:	0016c603          	lbu	a2,1(a3)
      if (c1)
 50c:	1c060863          	beqz	a2,6dc <vprintf+0x23e>
      if (c0 == 'd') {
 510:	03878763          	beq	a5,s8,53e <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 514:	f9478693          	addi	a3,a5,-108
 518:	0016b693          	seqz	a3,a3
 51c:	f9c60593          	addi	a1,a2,-100
 520:	e99d                	bnez	a1,556 <vprintf+0xb8>
 522:	ca95                	beqz	a3,556 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 524:	008b8493          	addi	s1,s7,8
 528:	4685                	li	a3,1
 52a:	4629                	li	a2,10
 52c:	000bb583          	ld	a1,0(s7)
 530:	855a                	mv	a0,s6
 532:	ecfff0ef          	jal	400 <printint>
        i += 1;
 536:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 538:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 53a:	4981                	li	s3,0
 53c:	b75d                	j	4e2 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 53e:	008b8493          	addi	s1,s7,8
 542:	4685                	li	a3,1
 544:	4629                	li	a2,10
 546:	000ba583          	lw	a1,0(s7)
 54a:	855a                	mv	a0,s6
 54c:	eb5ff0ef          	jal	400 <printint>
 550:	8ba6                	mv	s7,s1
      state = 0;
 552:	4981                	li	s3,0
 554:	b779                	j	4e2 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 556:	9752                	add	a4,a4,s4
 558:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 55c:	f9460713          	addi	a4,a2,-108
 560:	00173713          	seqz	a4,a4
 564:	8f75                	and	a4,a4,a3
 566:	f9c58513          	addi	a0,a1,-100
 56a:	18051363          	bnez	a0,6f0 <vprintf+0x252>
 56e:	18070163          	beqz	a4,6f0 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 572:	008b8493          	addi	s1,s7,8
 576:	4685                	li	a3,1
 578:	4629                	li	a2,10
 57a:	000bb583          	ld	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	e81ff0ef          	jal	400 <printint>
        i += 2;
 584:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 586:	8ba6                	mv	s7,s1
      state = 0;
 588:	4981                	li	s3,0
        i += 2;
 58a:	bfa1                	j	4e2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 58c:	008b8493          	addi	s1,s7,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000be583          	lwu	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	e67ff0ef          	jal	400 <printint>
 59e:	8ba6                	mv	s7,s1
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b781                	j	4e2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4629                	li	a2,10
 5ac:	000bb583          	ld	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	e4fff0ef          	jal	400 <printint>
        i += 1;
 5b6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b8:	8ba6                	mv	s7,s1
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	b71d                	j	4e2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5be:	008b8493          	addi	s1,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4629                	li	a2,10
 5c6:	000bb583          	ld	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	e35ff0ef          	jal	400 <printint>
        i += 2;
 5d0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d2:	8ba6                	mv	s7,s1
      state = 0;
 5d4:	4981                	li	s3,0
        i += 2;
 5d6:	b731                	j	4e2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5d8:	008b8493          	addi	s1,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000be583          	lwu	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	e1bff0ef          	jal	400 <printint>
 5ea:	8ba6                	mv	s7,s1
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	bdd5                	j	4e2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4641                	li	a2,16
 5f8:	000bb583          	ld	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e03ff0ef          	jal	400 <printint>
        i += 1;
 602:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 604:	8ba6                	mv	s7,s1
      state = 0;
 606:	4981                	li	s3,0
 608:	bde9                	j	4e2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 60a:	008b8493          	addi	s1,s7,8
 60e:	4681                	li	a3,0
 610:	4641                	li	a2,16
 612:	000bb583          	ld	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	de9ff0ef          	jal	400 <printint>
        i += 2;
 61c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 61e:	8ba6                	mv	s7,s1
      state = 0;
 620:	4981                	li	s3,0
        i += 2;
 622:	b5c1                	j	4e2 <vprintf+0x44>
 624:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 626:	008b8793          	addi	a5,s7,8
 62a:	8cbe                	mv	s9,a5
 62c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 630:	03000593          	li	a1,48
 634:	855a                	mv	a0,s6
 636:	dadff0ef          	jal	3e2 <putc>
  putc(fd, 'x');
 63a:	07800593          	li	a1,120
 63e:	855a                	mv	a0,s6
 640:	da3ff0ef          	jal	3e2 <putc>
 644:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 646:	00000b97          	auipc	s7,0x0
 64a:	31ab8b93          	addi	s7,s7,794 # 960 <digits>
 64e:	03c9d793          	srli	a5,s3,0x3c
 652:	97de                	add	a5,a5,s7
 654:	0007c583          	lbu	a1,0(a5)
 658:	855a                	mv	a0,s6
 65a:	d89ff0ef          	jal	3e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65e:	0992                	slli	s3,s3,0x4
 660:	34fd                	addiw	s1,s1,-1
 662:	f4f5                	bnez	s1,64e <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 664:	8be6                	mv	s7,s9
      state = 0;
 666:	4981                	li	s3,0
 668:	6ca2                	ld	s9,8(sp)
 66a:	bda5                	j	4e2 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 66c:	008b8493          	addi	s1,s7,8
 670:	000bc583          	lbu	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	d6dff0ef          	jal	3e2 <putc>
 67a:	8ba6                	mv	s7,s1
      state = 0;
 67c:	4981                	li	s3,0
 67e:	b595                	j	4e2 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 680:	008b8993          	addi	s3,s7,8
 684:	000bb483          	ld	s1,0(s7)
 688:	cc91                	beqz	s1,6a4 <vprintf+0x206>
        for (; *s; s++)
 68a:	0004c583          	lbu	a1,0(s1)
 68e:	c985                	beqz	a1,6be <vprintf+0x220>
          putc(fd, *s);
 690:	855a                	mv	a0,s6
 692:	d51ff0ef          	jal	3e2 <putc>
        for (; *s; s++)
 696:	0485                	addi	s1,s1,1
 698:	0004c583          	lbu	a1,0(s1)
 69c:	f9f5                	bnez	a1,690 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 69e:	8bce                	mv	s7,s3
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	b581                	j	4e2 <vprintf+0x44>
          s = "(null)";
 6a4:	00000497          	auipc	s1,0x0
 6a8:	2b448493          	addi	s1,s1,692 # 958 <malloc+0x118>
        for (; *s; s++)
 6ac:	02800593          	li	a1,40
 6b0:	b7c5                	j	690 <vprintf+0x1f2>
        putc(fd, '%');
 6b2:	85be                	mv	a1,a5
 6b4:	855a                	mv	a0,s6
 6b6:	d2dff0ef          	jal	3e2 <putc>
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	b51d                	j	4e2 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6be:	8bce                	mv	s7,s3
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b505                	j	4e2 <vprintf+0x44>
 6c4:	6906                	ld	s2,64(sp)
 6c6:	79e2                	ld	s3,56(sp)
 6c8:	7a42                	ld	s4,48(sp)
 6ca:	7aa2                	ld	s5,40(sp)
 6cc:	7b02                	ld	s6,32(sp)
 6ce:	6be2                	ld	s7,24(sp)
 6d0:	6c42                	ld	s8,16(sp)
    }
  }
}
 6d2:	60e6                	ld	ra,88(sp)
 6d4:	6446                	ld	s0,80(sp)
 6d6:	64a6                	ld	s1,72(sp)
 6d8:	6125                	addi	sp,sp,96
 6da:	8082                	ret
      if (c0 == 'd') {
 6dc:	06400713          	li	a4,100
 6e0:	e4e78fe3          	beq	a5,a4,53e <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 6e4:	f9478693          	addi	a3,a5,-108
 6e8:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6ec:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6ee:	4701                	li	a4,0
      } else if (c0 == 'u') {
 6f0:	07500513          	li	a0,117
 6f4:	e8a78ce3          	beq	a5,a0,58c <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 6f8:	f8b60513          	addi	a0,a2,-117
 6fc:	e119                	bnez	a0,702 <vprintf+0x264>
 6fe:	ea0693e3          	bnez	a3,5a4 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 702:	f8b58513          	addi	a0,a1,-117
 706:	e119                	bnez	a0,70c <vprintf+0x26e>
 708:	ea071be3          	bnez	a4,5be <vprintf+0x120>
      } else if (c0 == 'x') {
 70c:	07800513          	li	a0,120
 710:	eca784e3          	beq	a5,a0,5d8 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 714:	f8860613          	addi	a2,a2,-120
 718:	e219                	bnez	a2,71e <vprintf+0x280>
 71a:	ec069be3          	bnez	a3,5f0 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 71e:	f8858593          	addi	a1,a1,-120
 722:	e199                	bnez	a1,728 <vprintf+0x28a>
 724:	ee0713e3          	bnez	a4,60a <vprintf+0x16c>
      } else if (c0 == 'p') {
 728:	07000713          	li	a4,112
 72c:	eee78ce3          	beq	a5,a4,624 <vprintf+0x186>
      } else if (c0 == 'c') {
 730:	06300713          	li	a4,99
 734:	f2e78ce3          	beq	a5,a4,66c <vprintf+0x1ce>
      } else if (c0 == 's') {
 738:	07300713          	li	a4,115
 73c:	f4e782e3          	beq	a5,a4,680 <vprintf+0x1e2>
      } else if (c0 == '%') {
 740:	02500713          	li	a4,37
 744:	f6e787e3          	beq	a5,a4,6b2 <vprintf+0x214>
        putc(fd, '%');
 748:	02500593          	li	a1,37
 74c:	855a                	mv	a0,s6
 74e:	c95ff0ef          	jal	3e2 <putc>
        putc(fd, c0);
 752:	85a6                	mv	a1,s1
 754:	855a                	mv	a0,s6
 756:	c8dff0ef          	jal	3e2 <putc>
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b359                	j	4e2 <vprintf+0x44>

000000000000075e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75e:	715d                	addi	sp,sp,-80
 760:	ec06                	sd	ra,24(sp)
 762:	e822                	sd	s0,16(sp)
 764:	1000                	addi	s0,sp,32
 766:	e010                	sd	a2,0(s0)
 768:	e414                	sd	a3,8(s0)
 76a:	e818                	sd	a4,16(s0)
 76c:	ec1c                	sd	a5,24(s0)
 76e:	03043023          	sd	a6,32(s0)
 772:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 776:	8622                	mv	a2,s0
 778:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 77c:	d23ff0ef          	jal	49e <vprintf>
}
 780:	60e2                	ld	ra,24(sp)
 782:	6442                	ld	s0,16(sp)
 784:	6161                	addi	sp,sp,80
 786:	8082                	ret

0000000000000788 <printf>:

void
printf(const char *fmt, ...)
{
 788:	711d                	addi	sp,sp,-96
 78a:	ec06                	sd	ra,24(sp)
 78c:	e822                	sd	s0,16(sp)
 78e:	1000                	addi	s0,sp,32
 790:	e40c                	sd	a1,8(s0)
 792:	e810                	sd	a2,16(s0)
 794:	ec14                	sd	a3,24(s0)
 796:	f018                	sd	a4,32(s0)
 798:	f41c                	sd	a5,40(s0)
 79a:	03043823          	sd	a6,48(s0)
 79e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a2:	00840613          	addi	a2,s0,8
 7a6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7aa:	85aa                	mv	a1,a0
 7ac:	4505                	li	a0,1
 7ae:	cf1ff0ef          	jal	49e <vprintf>
}
 7b2:	60e2                	ld	ra,24(sp)
 7b4:	6442                	ld	s0,16(sp)
 7b6:	6125                	addi	sp,sp,96
 7b8:	8082                	ret

00000000000007ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ba:	1141                	addi	sp,sp,-16
 7bc:	e406                	sd	ra,8(sp)
 7be:	e022                	sd	s0,0(sp)
 7c0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7c2:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	00001797          	auipc	a5,0x1
 7ca:	83a7b783          	ld	a5,-1990(a5) # 1000 <freep>
 7ce:	a039                	j	7dc <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	6398                	ld	a4,0(a5)
 7d2:	00e7e463          	bltu	a5,a4,7da <free+0x20>
 7d6:	00e6ea63          	bltu	a3,a4,7ea <free+0x30>
{
 7da:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	fed7fae3          	bgeu	a5,a3,7d0 <free+0x16>
 7e0:	6398                	ld	a4,0(a5)
 7e2:	00e6e463          	bltu	a3,a4,7ea <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e6:	fee7eae3          	bltu	a5,a4,7da <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7ea:	ff852583          	lw	a1,-8(a0)
 7ee:	6390                	ld	a2,0(a5)
 7f0:	02059813          	slli	a6,a1,0x20
 7f4:	01c85713          	srli	a4,a6,0x1c
 7f8:	9736                	add	a4,a4,a3
 7fa:	02e60563          	beq	a2,a4,824 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7fe:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 802:	4790                	lw	a2,8(a5)
 804:	02061593          	slli	a1,a2,0x20
 808:	01c5d713          	srli	a4,a1,0x1c
 80c:	973e                	add	a4,a4,a5
 80e:	02e68263          	beq	a3,a4,832 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 812:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 814:	00000717          	auipc	a4,0x0
 818:	7ef73623          	sd	a5,2028(a4) # 1000 <freep>
}
 81c:	60a2                	ld	ra,8(sp)
 81e:	6402                	ld	s0,0(sp)
 820:	0141                	addi	sp,sp,16
 822:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 824:	4618                	lw	a4,8(a2)
 826:	9f2d                	addw	a4,a4,a1
 828:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 82c:	6398                	ld	a4,0(a5)
 82e:	6310                	ld	a2,0(a4)
 830:	b7f9                	j	7fe <free+0x44>
    p->s.size += bp->s.size;
 832:	ff852703          	lw	a4,-8(a0)
 836:	9f31                	addw	a4,a4,a2
 838:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 83a:	ff053683          	ld	a3,-16(a0)
 83e:	bfd1                	j	812 <free+0x58>

0000000000000840 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 840:	7139                	addi	sp,sp,-64
 842:	fc06                	sd	ra,56(sp)
 844:	f822                	sd	s0,48(sp)
 846:	f04a                	sd	s2,32(sp)
 848:	ec4e                	sd	s3,24(sp)
 84a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 84c:	02051993          	slli	s3,a0,0x20
 850:	0209d993          	srli	s3,s3,0x20
 854:	09bd                	addi	s3,s3,15
 856:	0049d993          	srli	s3,s3,0x4
 85a:	2985                	addiw	s3,s3,1
 85c:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 85e:	00000517          	auipc	a0,0x0
 862:	7a253503          	ld	a0,1954(a0) # 1000 <freep>
 866:	c905                	beqz	a0,896 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 868:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 86a:	4798                	lw	a4,8(a5)
 86c:	09377663          	bgeu	a4,s3,8f8 <malloc+0xb8>
 870:	f426                	sd	s1,40(sp)
 872:	e852                	sd	s4,16(sp)
 874:	e456                	sd	s5,8(sp)
 876:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 878:	8a4e                	mv	s4,s3
 87a:	6705                	lui	a4,0x1
 87c:	00e9f363          	bgeu	s3,a4,882 <malloc+0x42>
 880:	6a05                	lui	s4,0x1
 882:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 886:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 88a:	00000497          	auipc	s1,0x0
 88e:	77648493          	addi	s1,s1,1910 # 1000 <freep>
  if (p == SBRK_ERROR)
 892:	5afd                	li	s5,-1
 894:	a83d                	j	8d2 <malloc+0x92>
 896:	f426                	sd	s1,40(sp)
 898:	e852                	sd	s4,16(sp)
 89a:	e456                	sd	s5,8(sp)
 89c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 89e:	00000797          	auipc	a5,0x0
 8a2:	77278793          	addi	a5,a5,1906 # 1010 <base>
 8a6:	00000717          	auipc	a4,0x0
 8aa:	74f73d23          	sd	a5,1882(a4) # 1000 <freep>
 8ae:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b0:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8b4:	b7d1                	j	878 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8b6:	6398                	ld	a4,0(a5)
 8b8:	e118                	sd	a4,0(a0)
 8ba:	a899                	j	910 <malloc+0xd0>
  hp->s.size = nu;
 8bc:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8c0:	0541                	addi	a0,a0,16
 8c2:	ef9ff0ef          	jal	7ba <free>
  return freep;
 8c6:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8c8:	c125                	beqz	a0,928 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8ca:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8cc:	4798                	lw	a4,8(a5)
 8ce:	03277163          	bgeu	a4,s2,8f0 <malloc+0xb0>
    if (p == freep)
 8d2:	6098                	ld	a4,0(s1)
 8d4:	853e                	mv	a0,a5
 8d6:	fef71ae3          	bne	a4,a5,8ca <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8da:	8552                	mv	a0,s4
 8dc:	9fbff0ef          	jal	2d6 <sbrk>
  if (p == SBRK_ERROR)
 8e0:	fd551ee3          	bne	a0,s5,8bc <malloc+0x7c>
        return 0;
 8e4:	4501                	li	a0,0
 8e6:	74a2                	ld	s1,40(sp)
 8e8:	6a42                	ld	s4,16(sp)
 8ea:	6aa2                	ld	s5,8(sp)
 8ec:	6b02                	ld	s6,0(sp)
 8ee:	a03d                	j	91c <malloc+0xdc>
 8f0:	74a2                	ld	s1,40(sp)
 8f2:	6a42                	ld	s4,16(sp)
 8f4:	6aa2                	ld	s5,8(sp)
 8f6:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8f8:	fae90fe3          	beq	s2,a4,8b6 <malloc+0x76>
        p->s.size -= nunits;
 8fc:	4137073b          	subw	a4,a4,s3
 900:	c798                	sw	a4,8(a5)
        p += p->s.size;
 902:	02071693          	slli	a3,a4,0x20
 906:	01c6d713          	srli	a4,a3,0x1c
 90a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 90c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 910:	00000717          	auipc	a4,0x0
 914:	6ea73823          	sd	a0,1776(a4) # 1000 <freep>
      return (void *)(p + 1);
 918:	01078513          	addi	a0,a5,16
  }
}
 91c:	70e2                	ld	ra,56(sp)
 91e:	7442                	ld	s0,48(sp)
 920:	7902                	ld	s2,32(sp)
 922:	69e2                	ld	s3,24(sp)
 924:	6121                	addi	sp,sp,64
 926:	8082                	ret
 928:	74a2                	ld	s1,40(sp)
 92a:	6a42                	ld	s4,16(sp)
 92c:	6aa2                	ld	s5,8(sp)
 92e:	6b02                	ld	s6,0(sp)
 930:	b7f5                	j	91c <malloc+0xdc>
