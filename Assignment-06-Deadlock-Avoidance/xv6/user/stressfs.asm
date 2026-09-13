
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	9e278793          	addi	a5,a5,-1566 # a00 <malloc+0x12c>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	99c50513          	addi	a0,a0,-1636 # 9d0 <malloc+0xfc>
  3c:	7e0000ef          	jal	81c <printf>
  memset(data, 'a', sizeof(data));
  40:	20000613          	li	a2,512
  44:	06100593          	li	a1,97
  48:	dc040513          	addi	a0,s0,-576
  4c:	128000ef          	jal	174 <memset>

  for (i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if (fork() > 0)
  54:	342000ef          	jal	396 <fork>
  58:	00a04563          	bgtz	a0,62 <main+0x62>
  for (i = 0; i < 4; i++)
  5c:	2485                	addiw	s1,s1,1
  5e:	ff249be3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  62:	85a6                	mv	a1,s1
  64:	00001517          	auipc	a0,0x1
  68:	98450513          	addi	a0,a0,-1660 # 9e8 <malloc+0x114>
  6c:	7b0000ef          	jal	81c <printf>

  path[8] += i;
  70:	fc844783          	lbu	a5,-56(s0)
  74:	9fa5                	addw	a5,a5,s1
  76:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  7a:	20200593          	li	a1,514
  7e:	fc040513          	addi	a0,s0,-64
  82:	384000ef          	jal	406 <open>
  86:	892a                	mv	s2,a0
  88:	44d1                	li	s1,20
  for (i = 0; i < 20; i++) {
    // printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  8a:	dc040a13          	addi	s4,s0,-576
  8e:	20000993          	li	s3,512
  92:	864e                	mv	a2,s3
  94:	85d2                	mv	a1,s4
  96:	854a                	mv	a0,s2
  98:	32e000ef          	jal	3c6 <write>
  for (i = 0; i < 20; i++) {
  9c:	34fd                	addiw	s1,s1,-1
  9e:	f8f5                	bnez	s1,92 <main+0x92>
  }
  close(fd);
  a0:	854a                	mv	a0,s2
  a2:	34c000ef          	jal	3ee <close>

  printf("read\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	95250513          	addi	a0,a0,-1710 # 9f8 <malloc+0x124>
  ae:	76e000ef          	jal	81c <printf>

  fd = open(path, O_RDONLY);
  b2:	4581                	li	a1,0
  b4:	fc040513          	addi	a0,s0,-64
  b8:	34e000ef          	jal	406 <open>
  bc:	892a                	mv	s2,a0
  be:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  c0:	dc040a13          	addi	s4,s0,-576
  c4:	20000993          	li	s3,512
  c8:	864e                	mv	a2,s3
  ca:	85d2                	mv	a1,s4
  cc:	854a                	mv	a0,s2
  ce:	2f0000ef          	jal	3be <read>
  for (i = 0; i < 20; i++)
  d2:	34fd                	addiw	s1,s1,-1
  d4:	f8f5                	bnez	s1,c8 <main+0xc8>
  close(fd);
  d6:	854a                	mv	a0,s2
  d8:	316000ef          	jal	3ee <close>

  wait(0);
  dc:	4501                	li	a0,0
  de:	2c8000ef          	jal	3a6 <wait>

  exit(0);
  e2:	4501                	li	a0,0
  e4:	2ba000ef          	jal	39e <exit>

00000000000000e8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  f0:	f11ff0ef          	jal	0 <main>
  exit(r);
  f4:	2aa000ef          	jal	39e <exit>

00000000000000f8 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 100:	87aa                	mv	a5,a0
 102:	0585                	addi	a1,a1,1
 104:	0785                	addi	a5,a5,1
 106:	fff5c703          	lbu	a4,-1(a1)
 10a:	fee78fa3          	sb	a4,-1(a5)
 10e:	fb75                	bnez	a4,102 <strcpy+0xa>
    ;
  return os;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 120:	00054783          	lbu	a5,0(a0)
 124:	cb91                	beqz	a5,138 <strcmp+0x20>
 126:	0005c703          	lbu	a4,0(a1)
 12a:	00f71763          	bne	a4,a5,138 <strcmp+0x20>
    p++, q++;
 12e:	0505                	addi	a0,a0,1
 130:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	fbe5                	bnez	a5,126 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 138:	0005c503          	lbu	a0,0(a1)
}
 13c:	40a7853b          	subw	a0,a5,a0
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strlen>:

uint
strlen(const char *s)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cf91                	beqz	a5,170 <strlen+0x28>
 156:	00150793          	addi	a5,a0,1
 15a:	86be                	mv	a3,a5
 15c:	0785                	addi	a5,a5,1
 15e:	fff7c703          	lbu	a4,-1(a5)
 162:	ff65                	bnez	a4,15a <strlen+0x12>
 164:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret
  for (n = 0; s[n]; n++)
 170:	4501                	li	a0,0
 172:	bfdd                	j	168 <strlen+0x20>

0000000000000174 <memset>:

void *
memset(void *dst, int c, uint n)
{
 174:	1141                	addi	sp,sp,-16
 176:	e406                	sd	ra,8(sp)
 178:	e022                	sd	s0,0(sp)
 17a:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 17c:	ca19                	beqz	a2,192 <memset+0x1e>
 17e:	87aa                	mv	a5,a0
 180:	1602                	slli	a2,a2,0x20
 182:	9201                	srli	a2,a2,0x20
 184:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 188:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 18c:	0785                	addi	a5,a5,1
 18e:	fee79de3          	bne	a5,a4,188 <memset+0x14>
  }
  return dst;
}
 192:	60a2                	ld	ra,8(sp)
 194:	6402                	ld	s0,0(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret

000000000000019a <strchr>:

char *
strchr(const char *s, char c)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e406                	sd	ra,8(sp)
 19e:	e022                	sd	s0,0(sp)
 1a0:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	cf81                	beqz	a5,1be <strchr+0x24>
    if (*s == c)
 1a8:	00f58763          	beq	a1,a5,1b6 <strchr+0x1c>
  for (; *s; s++)
 1ac:	0505                	addi	a0,a0,1
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	fbfd                	bnez	a5,1a8 <strchr+0xe>
      return (char *)s;
  return 0;
 1b4:	4501                	li	a0,0
}
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret
  return 0;
 1be:	4501                	li	a0,0
 1c0:	bfdd                	j	1b6 <strchr+0x1c>

00000000000001c2 <gets>:

char *
gets(char *buf, int max)
{
 1c2:	711d                	addi	sp,sp,-96
 1c4:	ec86                	sd	ra,88(sp)
 1c6:	e8a2                	sd	s0,80(sp)
 1c8:	e4a6                	sd	s1,72(sp)
 1ca:	e0ca                	sd	s2,64(sp)
 1cc:	fc4e                	sd	s3,56(sp)
 1ce:	f852                	sd	s4,48(sp)
 1d0:	f456                	sd	s5,40(sp)
 1d2:	f05a                	sd	s6,32(sp)
 1d4:	ec5e                	sd	s7,24(sp)
 1d6:	e862                	sd	s8,16(sp)
 1d8:	1080                	addi	s0,sp,96
 1da:	8baa                	mv	s7,a0
 1dc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1de:	892a                	mv	s2,a0
 1e0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1e2:	faf40b13          	addi	s6,s0,-81
 1e6:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1e8:	8c26                	mv	s8,s1
 1ea:	0014899b          	addiw	s3,s1,1
 1ee:	84ce                	mv	s1,s3
 1f0:	0349d463          	bge	s3,s4,218 <gets+0x56>
    cc = read(0, &c, 1);
 1f4:	8656                	mv	a2,s5
 1f6:	85da                	mv	a1,s6
 1f8:	4501                	li	a0,0
 1fa:	1c4000ef          	jal	3be <read>
    if (cc < 1)
 1fe:	00a05d63          	blez	a0,218 <gets+0x56>
      break;
    buf[i++] = c;
 202:	faf44783          	lbu	a5,-81(s0)
 206:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 20a:	0905                	addi	s2,s2,1
 20c:	ff678713          	addi	a4,a5,-10
 210:	c319                	beqz	a4,216 <gets+0x54>
 212:	17cd                	addi	a5,a5,-13
 214:	fbf1                	bnez	a5,1e8 <gets+0x26>
    buf[i++] = c;
 216:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 218:	9c5e                	add	s8,s8,s7
 21a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 21e:	855e                	mv	a0,s7
 220:	60e6                	ld	ra,88(sp)
 222:	6446                	ld	s0,80(sp)
 224:	64a6                	ld	s1,72(sp)
 226:	6906                	ld	s2,64(sp)
 228:	79e2                	ld	s3,56(sp)
 22a:	7a42                	ld	s4,48(sp)
 22c:	7aa2                	ld	s5,40(sp)
 22e:	7b02                	ld	s6,32(sp)
 230:	6be2                	ld	s7,24(sp)
 232:	6c42                	ld	s8,16(sp)
 234:	6125                	addi	sp,sp,96
 236:	8082                	ret

0000000000000238 <stat>:

int
stat(const char *n, struct stat *st)
{
 238:	1101                	addi	sp,sp,-32
 23a:	ec06                	sd	ra,24(sp)
 23c:	e822                	sd	s0,16(sp)
 23e:	e04a                	sd	s2,0(sp)
 240:	1000                	addi	s0,sp,32
 242:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 244:	4581                	li	a1,0
 246:	1c0000ef          	jal	406 <open>
  if (fd < 0)
 24a:	02054263          	bltz	a0,26e <stat+0x36>
 24e:	e426                	sd	s1,8(sp)
 250:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 252:	85ca                	mv	a1,s2
 254:	1ca000ef          	jal	41e <fstat>
 258:	892a                	mv	s2,a0
  close(fd);
 25a:	8526                	mv	a0,s1
 25c:	192000ef          	jal	3ee <close>
  return r;
 260:	64a2                	ld	s1,8(sp)
}
 262:	854a                	mv	a0,s2
 264:	60e2                	ld	ra,24(sp)
 266:	6442                	ld	s0,16(sp)
 268:	6902                	ld	s2,0(sp)
 26a:	6105                	addi	sp,sp,32
 26c:	8082                	ret
    return -1;
 26e:	57fd                	li	a5,-1
 270:	893e                	mv	s2,a5
 272:	bfc5                	j	262 <stat+0x2a>

0000000000000274 <atoi>:

int
atoi(const char *s)
{
 274:	1141                	addi	sp,sp,-16
 276:	e406                	sd	ra,8(sp)
 278:	e022                	sd	s0,0(sp)
 27a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 27c:	00054683          	lbu	a3,0(a0)
 280:	fd06879b          	addiw	a5,a3,-48
 284:	0ff7f793          	zext.b	a5,a5
 288:	4625                	li	a2,9
 28a:	02f66963          	bltu	a2,a5,2bc <atoi+0x48>
 28e:	872a                	mv	a4,a0
  n = 0;
 290:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 292:	0705                	addi	a4,a4,1
 294:	0025179b          	slliw	a5,a0,0x2
 298:	9fa9                	addw	a5,a5,a0
 29a:	0017979b          	slliw	a5,a5,0x1
 29e:	9fb5                	addw	a5,a5,a3
 2a0:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2a4:	00074683          	lbu	a3,0(a4)
 2a8:	fd06879b          	addiw	a5,a3,-48
 2ac:	0ff7f793          	zext.b	a5,a5
 2b0:	fef671e3          	bgeu	a2,a5,292 <atoi+0x1e>
  return n;
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
  n = 0;
 2bc:	4501                	li	a0,0
 2be:	bfdd                	j	2b4 <atoi+0x40>

00000000000002c0 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e406                	sd	ra,8(sp)
 2c4:	e022                	sd	s0,0(sp)
 2c6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c8:	02b57563          	bgeu	a0,a1,2f2 <memmove+0x32>
    while (n-- > 0)
 2cc:	00c05f63          	blez	a2,2ea <memmove+0x2a>
 2d0:	1602                	slli	a2,a2,0x20
 2d2:	9201                	srli	a2,a2,0x20
 2d4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2da:	0585                	addi	a1,a1,1
 2dc:	0705                	addi	a4,a4,1
 2de:	fff5c683          	lbu	a3,-1(a1)
 2e2:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2e6:	fee79ae3          	bne	a5,a4,2da <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret
    while (n-- > 0)
 2f2:	fec05ce3          	blez	a2,2ea <memmove+0x2a>
    dst += n;
 2f6:	00c50733          	add	a4,a0,a2
    src += n;
 2fa:	95b2                	add	a1,a1,a2
 2fc:	fff6079b          	addiw	a5,a2,-1
 300:	1782                	slli	a5,a5,0x20
 302:	9381                	srli	a5,a5,0x20
 304:	fff7c793          	not	a5,a5
 308:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30a:	15fd                	addi	a1,a1,-1
 30c:	177d                	addi	a4,a4,-1
 30e:	0005c683          	lbu	a3,0(a1)
 312:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 316:	fef71ae3          	bne	a4,a5,30a <memmove+0x4a>
 31a:	bfc1                	j	2ea <memmove+0x2a>

000000000000031c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 324:	c61d                	beqz	a2,352 <memcmp+0x36>
 326:	1602                	slli	a2,a2,0x20
 328:	9201                	srli	a2,a2,0x20
 32a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 32e:	00054783          	lbu	a5,0(a0)
 332:	0005c703          	lbu	a4,0(a1)
 336:	00e79863          	bne	a5,a4,346 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 33a:	0505                	addi	a0,a0,1
    p2++;
 33c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33e:	fed518e3          	bne	a0,a3,32e <memcmp+0x12>
  }
  return 0;
 342:	4501                	li	a0,0
 344:	a019                	j	34a <memcmp+0x2e>
      return *p1 - *p2;
 346:	40e7853b          	subw	a0,a5,a4
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
  return 0;
 352:	4501                	li	a0,0
 354:	bfdd                	j	34a <memcmp+0x2e>

0000000000000356 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e406                	sd	ra,8(sp)
 35a:	e022                	sd	s0,0(sp)
 35c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35e:	f63ff0ef          	jal	2c0 <memmove>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <sbrk>:

char *
sbrk(int n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 372:	4585                	li	a1,1
 374:	0da000ef          	jal	44e <sys_sbrk>
}
 378:	60a2                	ld	ra,8(sp)
 37a:	6402                	ld	s0,0(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret

0000000000000380 <sbrklazy>:

char *
sbrklazy(int n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e406                	sd	ra,8(sp)
 384:	e022                	sd	s0,0(sp)
 386:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 388:	4589                	li	a1,2
 38a:	0c4000ef          	jal	44e <sys_sbrk>
}
 38e:	60a2                	ld	ra,8(sp)
 390:	6402                	ld	s0,0(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret

0000000000000396 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 396:	4885                	li	a7,1
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <exit>:
.global exit
exit:
 li a7, SYS_exit
 39e:	4889                	li	a7,2
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a6:	488d                	li	a7,3
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ae:	48b5                	li	a7,13
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b6:	4891                	li	a7,4
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <read>:
.global read
read:
 li a7, SYS_read
 3be:	4895                	li	a7,5
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <write>:
.global write
write:
 li a7, SYS_write
 3c6:	48c1                	li	a7,16
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <sem_create>:
.global sem_create
sem_create:
 li a7, SYS_sem_create
 3ce:	48e1                	li	a7,24
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <sem_wait>:
.global sem_wait
sem_wait:
 li a7, SYS_sem_wait
 3d6:	48e5                	li	a7,25
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <sem_signal>:
.global sem_signal
sem_signal:
 li a7, SYS_sem_signal
 3de:	48e9                	li	a7,26
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <sem_free>:
.global sem_free
sem_free:
 li a7, SYS_sem_free
 3e6:	48ed                	li	a7,27
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <close>:
.global close
close:
 li a7, SYS_close
 3ee:	48d5                	li	a7,21
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f6:	4899                	li	a7,6
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 3fe:	489d                	li	a7,7
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <open>:
.global open
open:
 li a7, SYS_open
 406:	48bd                	li	a7,15
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 40e:	48c5                	li	a7,17
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 416:	48c9                	li	a7,18
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 41e:	48a1                	li	a7,8
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <link>:
.global link
link:
 li a7, SYS_link
 426:	48cd                	li	a7,19
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 42e:	48d1                	li	a7,20
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 436:	48a5                	li	a7,9
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <dup>:
.global dup
dup:
 li a7, SYS_dup
 43e:	48a9                	li	a7,10
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 446:	48ad                	li	a7,11
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 44e:	48b1                	li	a7,12
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <pause>:
.global pause
pause:
 li a7, SYS_pause
 456:	48b5                	li	a7,13
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 45e:	48b9                	li	a7,14
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sync>:
.global sync
sync:
 li a7, SYS_sync
 466:	48d9                	li	a7,22
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <shm_get>:
.global shm_get
shm_get:
 li a7, SYS_shm_get
 46e:	48dd                	li	a7,23
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 476:	1101                	addi	sp,sp,-32
 478:	ec06                	sd	ra,24(sp)
 47a:	e822                	sd	s0,16(sp)
 47c:	1000                	addi	s0,sp,32
 47e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 482:	4605                	li	a2,1
 484:	fef40593          	addi	a1,s0,-17
 488:	f3fff0ef          	jal	3c6 <write>
}
 48c:	60e2                	ld	ra,24(sp)
 48e:	6442                	ld	s0,16(sp)
 490:	6105                	addi	sp,sp,32
 492:	8082                	ret

0000000000000494 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 494:	715d                	addi	sp,sp,-80
 496:	e486                	sd	ra,72(sp)
 498:	e0a2                	sd	s0,64(sp)
 49a:	f84a                	sd	s2,48(sp)
 49c:	f44e                	sd	s3,40(sp)
 49e:	0880                	addi	s0,sp,80
 4a0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 4a2:	c6d1                	beqz	a3,52e <printint+0x9a>
 4a4:	0805d563          	bgez	a1,52e <printint+0x9a>
    neg = 1;
    x = -xx;
 4a8:	40b005b3          	neg	a1,a1
    neg = 1;
 4ac:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4ae:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4b2:	86ce                	mv	a3,s3
  i = 0;
 4b4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 4b6:	00000817          	auipc	a6,0x0
 4ba:	56280813          	addi	a6,a6,1378 # a18 <digits>
 4be:	88ba                	mv	a7,a4
 4c0:	0017051b          	addiw	a0,a4,1
 4c4:	872a                	mv	a4,a0
 4c6:	02c5f7b3          	remu	a5,a1,a2
 4ca:	97c2                	add	a5,a5,a6
 4cc:	0007c783          	lbu	a5,0(a5)
 4d0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4d4:	87ae                	mv	a5,a1
 4d6:	02c5d5b3          	divu	a1,a1,a2
 4da:	0685                	addi	a3,a3,1
 4dc:	fec7f1e3          	bgeu	a5,a2,4be <printint+0x2a>
  if (neg)
 4e0:	00030c63          	beqz	t1,4f8 <printint+0x64>
    buf[i++] = '-';
 4e4:	fd050793          	addi	a5,a0,-48
 4e8:	00878533          	add	a0,a5,s0
 4ec:	02d00793          	li	a5,45
 4f0:	fef50423          	sb	a5,-24(a0)
 4f4:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4f8:	02e05563          	blez	a4,522 <printint+0x8e>
 4fc:	fc26                	sd	s1,56(sp)
 4fe:	377d                	addiw	a4,a4,-1
 500:	00e984b3          	add	s1,s3,a4
 504:	19fd                	addi	s3,s3,-1
 506:	99ba                	add	s3,s3,a4
 508:	1702                	slli	a4,a4,0x20
 50a:	9301                	srli	a4,a4,0x20
 50c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 510:	0004c583          	lbu	a1,0(s1)
 514:	854a                	mv	a0,s2
 516:	f61ff0ef          	jal	476 <putc>
  while (--i >= 0)
 51a:	14fd                	addi	s1,s1,-1
 51c:	ff349ae3          	bne	s1,s3,510 <printint+0x7c>
 520:	74e2                	ld	s1,56(sp)
}
 522:	60a6                	ld	ra,72(sp)
 524:	6406                	ld	s0,64(sp)
 526:	7942                	ld	s2,48(sp)
 528:	79a2                	ld	s3,40(sp)
 52a:	6161                	addi	sp,sp,80
 52c:	8082                	ret
  neg = 0;
 52e:	4301                	li	t1,0
 530:	bfbd                	j	4ae <printint+0x1a>

0000000000000532 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 532:	711d                	addi	sp,sp,-96
 534:	ec86                	sd	ra,88(sp)
 536:	e8a2                	sd	s0,80(sp)
 538:	e4a6                	sd	s1,72(sp)
 53a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 53c:	0005c483          	lbu	s1,0(a1)
 540:	22048363          	beqz	s1,766 <vprintf+0x234>
 544:	e0ca                	sd	s2,64(sp)
 546:	fc4e                	sd	s3,56(sp)
 548:	f852                	sd	s4,48(sp)
 54a:	f456                	sd	s5,40(sp)
 54c:	f05a                	sd	s6,32(sp)
 54e:	ec5e                	sd	s7,24(sp)
 550:	e862                	sd	s8,16(sp)
 552:	8b2a                	mv	s6,a0
 554:	8a2e                	mv	s4,a1
 556:	8bb2                	mv	s7,a2
  state = 0;
 558:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 55a:	4901                	li	s2,0
 55c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 55e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 562:	06400c13          	li	s8,100
 566:	a00d                	j	588 <vprintf+0x56>
        putc(fd, c0);
 568:	85a6                	mv	a1,s1
 56a:	855a                	mv	a0,s6
 56c:	f0bff0ef          	jal	476 <putc>
 570:	a019                	j	576 <vprintf+0x44>
    } else if (state == '%') {
 572:	03598363          	beq	s3,s5,598 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 576:	0019079b          	addiw	a5,s2,1
 57a:	893e                	mv	s2,a5
 57c:	873e                	mv	a4,a5
 57e:	97d2                	add	a5,a5,s4
 580:	0007c483          	lbu	s1,0(a5)
 584:	1c048a63          	beqz	s1,758 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 588:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 58c:	fe0993e3          	bnez	s3,572 <vprintf+0x40>
      if (c0 == '%') {
 590:	fd579ce3          	bne	a5,s5,568 <vprintf+0x36>
        state = '%';
 594:	89be                	mv	s3,a5
 596:	b7c5                	j	576 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 598:	00ea06b3          	add	a3,s4,a4
 59c:	0016c603          	lbu	a2,1(a3)
      if (c1)
 5a0:	1c060863          	beqz	a2,770 <vprintf+0x23e>
      if (c0 == 'd') {
 5a4:	03878763          	beq	a5,s8,5d2 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5a8:	f9478693          	addi	a3,a5,-108
 5ac:	0016b693          	seqz	a3,a3
 5b0:	f9c60593          	addi	a1,a2,-100
 5b4:	e99d                	bnez	a1,5ea <vprintf+0xb8>
 5b6:	ca95                	beqz	a3,5ea <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b8:	008b8493          	addi	s1,s7,8
 5bc:	4685                	li	a3,1
 5be:	4629                	li	a2,10
 5c0:	000bb583          	ld	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	ecfff0ef          	jal	494 <printint>
        i += 1;
 5ca:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5cc:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b75d                	j	576 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5d2:	008b8493          	addi	s1,s7,8
 5d6:	4685                	li	a3,1
 5d8:	4629                	li	a2,10
 5da:	000ba583          	lw	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	eb5ff0ef          	jal	494 <printint>
 5e4:	8ba6                	mv	s7,s1
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	b779                	j	576 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 5ea:	9752                	add	a4,a4,s4
 5ec:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5f0:	f9460713          	addi	a4,a2,-108
 5f4:	00173713          	seqz	a4,a4
 5f8:	8f75                	and	a4,a4,a3
 5fa:	f9c58513          	addi	a0,a1,-100
 5fe:	18051363          	bnez	a0,784 <vprintf+0x252>
 602:	18070163          	beqz	a4,784 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 606:	008b8493          	addi	s1,s7,8
 60a:	4685                	li	a3,1
 60c:	4629                	li	a2,10
 60e:	000bb583          	ld	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	e81ff0ef          	jal	494 <printint>
        i += 2;
 618:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 61a:	8ba6                	mv	s7,s1
      state = 0;
 61c:	4981                	li	s3,0
        i += 2;
 61e:	bfa1                	j	576 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 620:	008b8493          	addi	s1,s7,8
 624:	4681                	li	a3,0
 626:	4629                	li	a2,10
 628:	000be583          	lwu	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	e67ff0ef          	jal	494 <printint>
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
 636:	b781                	j	576 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 638:	008b8493          	addi	s1,s7,8
 63c:	4681                	li	a3,0
 63e:	4629                	li	a2,10
 640:	000bb583          	ld	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	e4fff0ef          	jal	494 <printint>
        i += 1;
 64a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 64c:	8ba6                	mv	s7,s1
      state = 0;
 64e:	4981                	li	s3,0
 650:	b71d                	j	576 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 652:	008b8493          	addi	s1,s7,8
 656:	4681                	li	a3,0
 658:	4629                	li	a2,10
 65a:	000bb583          	ld	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	e35ff0ef          	jal	494 <printint>
        i += 2;
 664:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 666:	8ba6                	mv	s7,s1
      state = 0;
 668:	4981                	li	s3,0
        i += 2;
 66a:	b731                	j	576 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 66c:	008b8493          	addi	s1,s7,8
 670:	4681                	li	a3,0
 672:	4641                	li	a2,16
 674:	000be583          	lwu	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	e1bff0ef          	jal	494 <printint>
 67e:	8ba6                	mv	s7,s1
      state = 0;
 680:	4981                	li	s3,0
 682:	bdd5                	j	576 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 684:	008b8493          	addi	s1,s7,8
 688:	4681                	li	a3,0
 68a:	4641                	li	a2,16
 68c:	000bb583          	ld	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	e03ff0ef          	jal	494 <printint>
        i += 1;
 696:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 698:	8ba6                	mv	s7,s1
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bde9                	j	576 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 69e:	008b8493          	addi	s1,s7,8
 6a2:	4681                	li	a3,0
 6a4:	4641                	li	a2,16
 6a6:	000bb583          	ld	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	de9ff0ef          	jal	494 <printint>
        i += 2;
 6b0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b2:	8ba6                	mv	s7,s1
      state = 0;
 6b4:	4981                	li	s3,0
        i += 2;
 6b6:	b5c1                	j	576 <vprintf+0x44>
 6b8:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6ba:	008b8793          	addi	a5,s7,8
 6be:	8cbe                	mv	s9,a5
 6c0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6c4:	03000593          	li	a1,48
 6c8:	855a                	mv	a0,s6
 6ca:	dadff0ef          	jal	476 <putc>
  putc(fd, 'x');
 6ce:	07800593          	li	a1,120
 6d2:	855a                	mv	a0,s6
 6d4:	da3ff0ef          	jal	476 <putc>
 6d8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6da:	00000b97          	auipc	s7,0x0
 6de:	33eb8b93          	addi	s7,s7,830 # a18 <digits>
 6e2:	03c9d793          	srli	a5,s3,0x3c
 6e6:	97de                	add	a5,a5,s7
 6e8:	0007c583          	lbu	a1,0(a5)
 6ec:	855a                	mv	a0,s6
 6ee:	d89ff0ef          	jal	476 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f2:	0992                	slli	s3,s3,0x4
 6f4:	34fd                	addiw	s1,s1,-1
 6f6:	f4f5                	bnez	s1,6e2 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6f8:	8be6                	mv	s7,s9
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	6ca2                	ld	s9,8(sp)
 6fe:	bda5                	j	576 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 700:	008b8493          	addi	s1,s7,8
 704:	000bc583          	lbu	a1,0(s7)
 708:	855a                	mv	a0,s6
 70a:	d6dff0ef          	jal	476 <putc>
 70e:	8ba6                	mv	s7,s1
      state = 0;
 710:	4981                	li	s3,0
 712:	b595                	j	576 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 714:	008b8993          	addi	s3,s7,8
 718:	000bb483          	ld	s1,0(s7)
 71c:	cc91                	beqz	s1,738 <vprintf+0x206>
        for (; *s; s++)
 71e:	0004c583          	lbu	a1,0(s1)
 722:	c985                	beqz	a1,752 <vprintf+0x220>
          putc(fd, *s);
 724:	855a                	mv	a0,s6
 726:	d51ff0ef          	jal	476 <putc>
        for (; *s; s++)
 72a:	0485                	addi	s1,s1,1
 72c:	0004c583          	lbu	a1,0(s1)
 730:	f9f5                	bnez	a1,724 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 732:	8bce                	mv	s7,s3
      state = 0;
 734:	4981                	li	s3,0
 736:	b581                	j	576 <vprintf+0x44>
          s = "(null)";
 738:	00000497          	auipc	s1,0x0
 73c:	2d848493          	addi	s1,s1,728 # a10 <malloc+0x13c>
        for (; *s; s++)
 740:	02800593          	li	a1,40
 744:	b7c5                	j	724 <vprintf+0x1f2>
        putc(fd, '%');
 746:	85be                	mv	a1,a5
 748:	855a                	mv	a0,s6
 74a:	d2dff0ef          	jal	476 <putc>
      state = 0;
 74e:	4981                	li	s3,0
 750:	b51d                	j	576 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 752:	8bce                	mv	s7,s3
      state = 0;
 754:	4981                	li	s3,0
 756:	b505                	j	576 <vprintf+0x44>
 758:	6906                	ld	s2,64(sp)
 75a:	79e2                	ld	s3,56(sp)
 75c:	7a42                	ld	s4,48(sp)
 75e:	7aa2                	ld	s5,40(sp)
 760:	7b02                	ld	s6,32(sp)
 762:	6be2                	ld	s7,24(sp)
 764:	6c42                	ld	s8,16(sp)
    }
  }
}
 766:	60e6                	ld	ra,88(sp)
 768:	6446                	ld	s0,80(sp)
 76a:	64a6                	ld	s1,72(sp)
 76c:	6125                	addi	sp,sp,96
 76e:	8082                	ret
      if (c0 == 'd') {
 770:	06400713          	li	a4,100
 774:	e4e78fe3          	beq	a5,a4,5d2 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 778:	f9478693          	addi	a3,a5,-108
 77c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 780:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 782:	4701                	li	a4,0
      } else if (c0 == 'u') {
 784:	07500513          	li	a0,117
 788:	e8a78ce3          	beq	a5,a0,620 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 78c:	f8b60513          	addi	a0,a2,-117
 790:	e119                	bnez	a0,796 <vprintf+0x264>
 792:	ea0693e3          	bnez	a3,638 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 796:	f8b58513          	addi	a0,a1,-117
 79a:	e119                	bnez	a0,7a0 <vprintf+0x26e>
 79c:	ea071be3          	bnez	a4,652 <vprintf+0x120>
      } else if (c0 == 'x') {
 7a0:	07800513          	li	a0,120
 7a4:	eca784e3          	beq	a5,a0,66c <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 7a8:	f8860613          	addi	a2,a2,-120
 7ac:	e219                	bnez	a2,7b2 <vprintf+0x280>
 7ae:	ec069be3          	bnez	a3,684 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 7b2:	f8858593          	addi	a1,a1,-120
 7b6:	e199                	bnez	a1,7bc <vprintf+0x28a>
 7b8:	ee0713e3          	bnez	a4,69e <vprintf+0x16c>
      } else if (c0 == 'p') {
 7bc:	07000713          	li	a4,112
 7c0:	eee78ce3          	beq	a5,a4,6b8 <vprintf+0x186>
      } else if (c0 == 'c') {
 7c4:	06300713          	li	a4,99
 7c8:	f2e78ce3          	beq	a5,a4,700 <vprintf+0x1ce>
      } else if (c0 == 's') {
 7cc:	07300713          	li	a4,115
 7d0:	f4e782e3          	beq	a5,a4,714 <vprintf+0x1e2>
      } else if (c0 == '%') {
 7d4:	02500713          	li	a4,37
 7d8:	f6e787e3          	beq	a5,a4,746 <vprintf+0x214>
        putc(fd, '%');
 7dc:	02500593          	li	a1,37
 7e0:	855a                	mv	a0,s6
 7e2:	c95ff0ef          	jal	476 <putc>
        putc(fd, c0);
 7e6:	85a6                	mv	a1,s1
 7e8:	855a                	mv	a0,s6
 7ea:	c8dff0ef          	jal	476 <putc>
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	b359                	j	576 <vprintf+0x44>

00000000000007f2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f2:	715d                	addi	sp,sp,-80
 7f4:	ec06                	sd	ra,24(sp)
 7f6:	e822                	sd	s0,16(sp)
 7f8:	1000                	addi	s0,sp,32
 7fa:	e010                	sd	a2,0(s0)
 7fc:	e414                	sd	a3,8(s0)
 7fe:	e818                	sd	a4,16(s0)
 800:	ec1c                	sd	a5,24(s0)
 802:	03043023          	sd	a6,32(s0)
 806:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 80a:	8622                	mv	a2,s0
 80c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 810:	d23ff0ef          	jal	532 <vprintf>
}
 814:	60e2                	ld	ra,24(sp)
 816:	6442                	ld	s0,16(sp)
 818:	6161                	addi	sp,sp,80
 81a:	8082                	ret

000000000000081c <printf>:

void
printf(const char *fmt, ...)
{
 81c:	711d                	addi	sp,sp,-96
 81e:	ec06                	sd	ra,24(sp)
 820:	e822                	sd	s0,16(sp)
 822:	1000                	addi	s0,sp,32
 824:	e40c                	sd	a1,8(s0)
 826:	e810                	sd	a2,16(s0)
 828:	ec14                	sd	a3,24(s0)
 82a:	f018                	sd	a4,32(s0)
 82c:	f41c                	sd	a5,40(s0)
 82e:	03043823          	sd	a6,48(s0)
 832:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 836:	00840613          	addi	a2,s0,8
 83a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 83e:	85aa                	mv	a1,a0
 840:	4505                	li	a0,1
 842:	cf1ff0ef          	jal	532 <vprintf>
}
 846:	60e2                	ld	ra,24(sp)
 848:	6442                	ld	s0,16(sp)
 84a:	6125                	addi	sp,sp,96
 84c:	8082                	ret

000000000000084e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84e:	1141                	addi	sp,sp,-16
 850:	e406                	sd	ra,8(sp)
 852:	e022                	sd	s0,0(sp)
 854:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 856:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85a:	00000797          	auipc	a5,0x0
 85e:	7a67b783          	ld	a5,1958(a5) # 1000 <freep>
 862:	a039                	j	870 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	6398                	ld	a4,0(a5)
 866:	00e7e463          	bltu	a5,a4,86e <free+0x20>
 86a:	00e6ea63          	bltu	a3,a4,87e <free+0x30>
{
 86e:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 870:	fed7fae3          	bgeu	a5,a3,864 <free+0x16>
 874:	6398                	ld	a4,0(a5)
 876:	00e6e463          	bltu	a3,a4,87e <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87a:	fee7eae3          	bltu	a5,a4,86e <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 87e:	ff852583          	lw	a1,-8(a0)
 882:	6390                	ld	a2,0(a5)
 884:	02059813          	slli	a6,a1,0x20
 888:	01c85713          	srli	a4,a6,0x1c
 88c:	9736                	add	a4,a4,a3
 88e:	02e60563          	beq	a2,a4,8b8 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 892:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 896:	4790                	lw	a2,8(a5)
 898:	02061593          	slli	a1,a2,0x20
 89c:	01c5d713          	srli	a4,a1,0x1c
 8a0:	973e                	add	a4,a4,a5
 8a2:	02e68263          	beq	a3,a4,8c6 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8a6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8a8:	00000717          	auipc	a4,0x0
 8ac:	74f73c23          	sd	a5,1880(a4) # 1000 <freep>
}
 8b0:	60a2                	ld	ra,8(sp)
 8b2:	6402                	ld	s0,0(sp)
 8b4:	0141                	addi	sp,sp,16
 8b6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8b8:	4618                	lw	a4,8(a2)
 8ba:	9f2d                	addw	a4,a4,a1
 8bc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c0:	6398                	ld	a4,0(a5)
 8c2:	6310                	ld	a2,0(a4)
 8c4:	b7f9                	j	892 <free+0x44>
    p->s.size += bp->s.size;
 8c6:	ff852703          	lw	a4,-8(a0)
 8ca:	9f31                	addw	a4,a4,a2
 8cc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ce:	ff053683          	ld	a3,-16(a0)
 8d2:	bfd1                	j	8a6 <free+0x58>

00000000000008d4 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8d4:	7139                	addi	sp,sp,-64
 8d6:	fc06                	sd	ra,56(sp)
 8d8:	f822                	sd	s0,48(sp)
 8da:	f04a                	sd	s2,32(sp)
 8dc:	ec4e                	sd	s3,24(sp)
 8de:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8e0:	02051993          	slli	s3,a0,0x20
 8e4:	0209d993          	srli	s3,s3,0x20
 8e8:	09bd                	addi	s3,s3,15
 8ea:	0049d993          	srli	s3,s3,0x4
 8ee:	2985                	addiw	s3,s3,1
 8f0:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8f2:	00000517          	auipc	a0,0x0
 8f6:	70e53503          	ld	a0,1806(a0) # 1000 <freep>
 8fa:	c905                	beqz	a0,92a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8fc:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8fe:	4798                	lw	a4,8(a5)
 900:	09377663          	bgeu	a4,s3,98c <malloc+0xb8>
 904:	f426                	sd	s1,40(sp)
 906:	e852                	sd	s4,16(sp)
 908:	e456                	sd	s5,8(sp)
 90a:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 90c:	8a4e                	mv	s4,s3
 90e:	6705                	lui	a4,0x1
 910:	00e9f363          	bgeu	s3,a4,916 <malloc+0x42>
 914:	6a05                	lui	s4,0x1
 916:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 91a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 91e:	00000497          	auipc	s1,0x0
 922:	6e248493          	addi	s1,s1,1762 # 1000 <freep>
  if (p == SBRK_ERROR)
 926:	5afd                	li	s5,-1
 928:	a83d                	j	966 <malloc+0x92>
 92a:	f426                	sd	s1,40(sp)
 92c:	e852                	sd	s4,16(sp)
 92e:	e456                	sd	s5,8(sp)
 930:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 932:	00000797          	auipc	a5,0x0
 936:	6de78793          	addi	a5,a5,1758 # 1010 <base>
 93a:	00000717          	auipc	a4,0x0
 93e:	6cf73323          	sd	a5,1734(a4) # 1000 <freep>
 942:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 944:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 948:	b7d1                	j	90c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 94a:	6398                	ld	a4,0(a5)
 94c:	e118                	sd	a4,0(a0)
 94e:	a899                	j	9a4 <malloc+0xd0>
  hp->s.size = nu;
 950:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 954:	0541                	addi	a0,a0,16
 956:	ef9ff0ef          	jal	84e <free>
  return freep;
 95a:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 95c:	c125                	beqz	a0,9bc <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 95e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 960:	4798                	lw	a4,8(a5)
 962:	03277163          	bgeu	a4,s2,984 <malloc+0xb0>
    if (p == freep)
 966:	6098                	ld	a4,0(s1)
 968:	853e                	mv	a0,a5
 96a:	fef71ae3          	bne	a4,a5,95e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 96e:	8552                	mv	a0,s4
 970:	9fbff0ef          	jal	36a <sbrk>
  if (p == SBRK_ERROR)
 974:	fd551ee3          	bne	a0,s5,950 <malloc+0x7c>
        return 0;
 978:	4501                	li	a0,0
 97a:	74a2                	ld	s1,40(sp)
 97c:	6a42                	ld	s4,16(sp)
 97e:	6aa2                	ld	s5,8(sp)
 980:	6b02                	ld	s6,0(sp)
 982:	a03d                	j	9b0 <malloc+0xdc>
 984:	74a2                	ld	s1,40(sp)
 986:	6a42                	ld	s4,16(sp)
 988:	6aa2                	ld	s5,8(sp)
 98a:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 98c:	fae90fe3          	beq	s2,a4,94a <malloc+0x76>
        p->s.size -= nunits;
 990:	4137073b          	subw	a4,a4,s3
 994:	c798                	sw	a4,8(a5)
        p += p->s.size;
 996:	02071693          	slli	a3,a4,0x20
 99a:	01c6d713          	srli	a4,a3,0x1c
 99e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9a0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a4:	00000717          	auipc	a4,0x0
 9a8:	64a73e23          	sd	a0,1628(a4) # 1000 <freep>
      return (void *)(p + 1);
 9ac:	01078513          	addi	a0,a5,16
  }
}
 9b0:	70e2                	ld	ra,56(sp)
 9b2:	7442                	ld	s0,48(sp)
 9b4:	7902                	ld	s2,32(sp)
 9b6:	69e2                	ld	s3,24(sp)
 9b8:	6121                	addi	sp,sp,64
 9ba:	8082                	ret
 9bc:	74a2                	ld	s1,40(sp)
 9be:	6a42                	ld	s4,16(sp)
 9c0:	6aa2                	ld	s5,8(sp)
 9c2:	6b02                	ld	s6,0(sp)
 9c4:	b7f5                	j	9b0 <malloc+0xdc>
