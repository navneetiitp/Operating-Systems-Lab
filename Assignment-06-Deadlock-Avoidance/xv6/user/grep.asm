
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
}

// matchstar: search for c*re at beginning of text
int
matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do { // a * matches zero or more instances
    if (matchhere(re, text))
      return 1;
  } while (*text != '\0' && (*text++ == c || c == '.'));
  16:	fd250a13          	addi	s4,a0,-46
  1a:	001a3a13          	seqz	s4,s4
    if (matchhere(re, text))
  1e:	85a6                	mv	a1,s1
  20:	854e                	mv	a0,s3
  22:	02a000ef          	jal	4c <matchhere>
  26:	e911                	bnez	a0,3a <matchstar+0x3a>
  } while (*text != '\0' && (*text++ == c || c == '.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb81                	beqz	a5,3c <matchstar+0x3c>
  2e:	0485                	addi	s1,s1,1
  30:	ff2787e3          	beq	a5,s2,1e <matchstar+0x1e>
  34:	fe0a15e3          	bnez	s4,1e <matchstar+0x1e>
  38:	a011                	j	3c <matchstar+0x3c>
      return 1;
  3a:	4505                	li	a0,1
  return 0;
}
  3c:	70a2                	ld	ra,40(sp)
  3e:	7402                	ld	s0,32(sp)
  40:	64e2                	ld	s1,24(sp)
  42:	6942                	ld	s2,16(sp)
  44:	69a2                	ld	s3,8(sp)
  46:	6a02                	ld	s4,0(sp)
  48:	6145                	addi	sp,sp,48
  4a:	8082                	ret

000000000000004c <matchhere>:
  if (re[0] == '\0')
  4c:	00054703          	lbu	a4,0(a0)
  50:	cf39                	beqz	a4,ae <matchhere+0x62>
{
  52:	1141                	addi	sp,sp,-16
  54:	e406                	sd	ra,8(sp)
  56:	e022                	sd	s0,0(sp)
  58:	0800                	addi	s0,sp,16
  5a:	87aa                	mv	a5,a0
  if (re[1] == '*')
  5c:	00154683          	lbu	a3,1(a0)
  60:	02a00613          	li	a2,42
  64:	02c68363          	beq	a3,a2,8a <matchhere+0x3e>
  if (re[0] == '$' && re[1] == '\0')
  68:	e681                	bnez	a3,70 <matchhere+0x24>
  6a:	fdc70693          	addi	a3,a4,-36
  6e:	c68d                	beqz	a3,98 <matchhere+0x4c>
  if (*text != '\0' && (re[0] == '.' || re[0] == *text))
  70:	0005c683          	lbu	a3,0(a1)
  return 0;
  74:	4501                	li	a0,0
  if (*text != '\0' && (re[0] == '.' || re[0] == *text))
  76:	c691                	beqz	a3,82 <matchhere+0x36>
  78:	02d70563          	beq	a4,a3,a2 <matchhere+0x56>
  7c:	fd270713          	addi	a4,a4,-46
  80:	c30d                	beqz	a4,a2 <matchhere+0x56>
}
  82:	60a2                	ld	ra,8(sp)
  84:	6402                	ld	s0,0(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret
    return matchstar(re[0], re + 2, text);
  8a:	862e                	mv	a2,a1
  8c:	00250593          	addi	a1,a0,2
  90:	853a                	mv	a0,a4
  92:	f6fff0ef          	jal	0 <matchstar>
  96:	b7f5                	j	82 <matchhere+0x36>
    return *text == '\0';
  98:	0005c503          	lbu	a0,0(a1)
  9c:	00153513          	seqz	a0,a0
  a0:	b7cd                	j	82 <matchhere+0x36>
    return matchhere(re + 1, text + 1);
  a2:	0585                	addi	a1,a1,1
  a4:	00178513          	addi	a0,a5,1
  a8:	fa5ff0ef          	jal	4c <matchhere>
  ac:	bfd9                	j	82 <matchhere+0x36>
    return 1;
  ae:	4505                	li	a0,1
}
  b0:	8082                	ret

00000000000000b2 <match>:
{
  b2:	1101                	addi	sp,sp,-32
  b4:	ec06                	sd	ra,24(sp)
  b6:	e822                	sd	s0,16(sp)
  b8:	e426                	sd	s1,8(sp)
  ba:	e04a                	sd	s2,0(sp)
  bc:	1000                	addi	s0,sp,32
  be:	892a                	mv	s2,a0
  c0:	84ae                	mv	s1,a1
  if (re[0] == '^')
  c2:	00054703          	lbu	a4,0(a0)
  c6:	05e00793          	li	a5,94
  ca:	00f70c63          	beq	a4,a5,e2 <match+0x30>
    if (matchhere(re, text))
  ce:	85a6                	mv	a1,s1
  d0:	854a                	mv	a0,s2
  d2:	f7bff0ef          	jal	4c <matchhere>
  d6:	e911                	bnez	a0,ea <match+0x38>
  } while (*text++ != '\0');
  d8:	0485                	addi	s1,s1,1
  da:	fff4c783          	lbu	a5,-1(s1)
  de:	fbe5                	bnez	a5,ce <match+0x1c>
  e0:	a031                	j	ec <match+0x3a>
    return matchhere(re + 1, text);
  e2:	0505                	addi	a0,a0,1
  e4:	f69ff0ef          	jal	4c <matchhere>
  e8:	a011                	j	ec <match+0x3a>
      return 1;
  ea:	4505                	li	a0,1
}
  ec:	60e2                	ld	ra,24(sp)
  ee:	6442                	ld	s0,16(sp)
  f0:	64a2                	ld	s1,8(sp)
  f2:	6902                	ld	s2,0(sp)
  f4:	6105                	addi	sp,sp,32
  f6:	8082                	ret

00000000000000f8 <grep>:
{
  f8:	711d                	addi	sp,sp,-96
  fa:	ec86                	sd	ra,88(sp)
  fc:	e8a2                	sd	s0,80(sp)
  fe:	e4a6                	sd	s1,72(sp)
 100:	e0ca                	sd	s2,64(sp)
 102:	fc4e                	sd	s3,56(sp)
 104:	f852                	sd	s4,48(sp)
 106:	f456                	sd	s5,40(sp)
 108:	f05a                	sd	s6,32(sp)
 10a:	ec5e                	sd	s7,24(sp)
 10c:	e862                	sd	s8,16(sp)
 10e:	e466                	sd	s9,8(sp)
 110:	e06a                	sd	s10,0(sp)
 112:	1080                	addi	s0,sp,96
 114:	8aaa                	mv	s5,a0
 116:	8cae                	mv	s9,a1
  m = 0;
 118:	4b01                	li	s6,0
  while ((n = read(fd, buf + m, sizeof(buf) - m - 1)) > 0) {
 11a:	3ff00d13          	li	s10,1023
 11e:	00002b97          	auipc	s7,0x2
 122:	ef2b8b93          	addi	s7,s7,-270 # 2010 <buf>
    while ((q = strchr(p, '\n')) != 0) {
 126:	49a9                	li	s3,10
        write(1, p, q + 1 - p);
 128:	4c05                	li	s8,1
  while ((n = read(fd, buf + m, sizeof(buf) - m - 1)) > 0) {
 12a:	a82d                	j	164 <grep+0x6c>
      p = q + 1;
 12c:	00148913          	addi	s2,s1,1
    while ((q = strchr(p, '\n')) != 0) {
 130:	85ce                	mv	a1,s3
 132:	854a                	mv	a0,s2
 134:	1da000ef          	jal	30e <strchr>
 138:	84aa                	mv	s1,a0
 13a:	c11d                	beqz	a0,160 <grep+0x68>
      *q = 0;
 13c:	00048023          	sb	zero,0(s1)
      if (match(pattern, p)) {
 140:	85ca                	mv	a1,s2
 142:	8556                	mv	a0,s5
 144:	f6fff0ef          	jal	b2 <match>
 148:	d175                	beqz	a0,12c <grep+0x34>
        *q = '\n';
 14a:	01348023          	sb	s3,0(s1)
        write(1, p, q + 1 - p);
 14e:	00148613          	addi	a2,s1,1
 152:	4126063b          	subw	a2,a2,s2
 156:	85ca                	mv	a1,s2
 158:	8562                	mv	a0,s8
 15a:	3e0000ef          	jal	53a <write>
 15e:	b7f9                	j	12c <grep+0x34>
    if (m > 0) {
 160:	03604463          	bgtz	s6,188 <grep+0x90>
  while ((n = read(fd, buf + m, sizeof(buf) - m - 1)) > 0) {
 164:	416d063b          	subw	a2,s10,s6
 168:	016b85b3          	add	a1,s7,s6
 16c:	8566                	mv	a0,s9
 16e:	3c4000ef          	jal	532 <read>
 172:	02a05c63          	blez	a0,1aa <grep+0xb2>
    m += n;
 176:	00ab0a3b          	addw	s4,s6,a0
 17a:	8b52                	mv	s6,s4
    buf[m] = '\0';
 17c:	014b87b3          	add	a5,s7,s4
 180:	00078023          	sb	zero,0(a5)
    p = buf;
 184:	895e                	mv	s2,s7
    while ((q = strchr(p, '\n')) != 0) {
 186:	b76d                	j	130 <grep+0x38>
      m -= p - buf;
 188:	00002797          	auipc	a5,0x2
 18c:	e8878793          	addi	a5,a5,-376 # 2010 <buf>
 190:	40f907b3          	sub	a5,s2,a5
 194:	40fa063b          	subw	a2,s4,a5
 198:	8b32                	mv	s6,a2
      memmove(buf, p, m);
 19a:	85ca                	mv	a1,s2
 19c:	00002517          	auipc	a0,0x2
 1a0:	e7450513          	addi	a0,a0,-396 # 2010 <buf>
 1a4:	290000ef          	jal	434 <memmove>
 1a8:	bf75                	j	164 <grep+0x6c>
}
 1aa:	60e6                	ld	ra,88(sp)
 1ac:	6446                	ld	s0,80(sp)
 1ae:	64a6                	ld	s1,72(sp)
 1b0:	6906                	ld	s2,64(sp)
 1b2:	79e2                	ld	s3,56(sp)
 1b4:	7a42                	ld	s4,48(sp)
 1b6:	7aa2                	ld	s5,40(sp)
 1b8:	7b02                	ld	s6,32(sp)
 1ba:	6be2                	ld	s7,24(sp)
 1bc:	6c42                	ld	s8,16(sp)
 1be:	6ca2                	ld	s9,8(sp)
 1c0:	6d02                	ld	s10,0(sp)
 1c2:	6125                	addi	sp,sp,96
 1c4:	8082                	ret

00000000000001c6 <main>:
{
 1c6:	7179                	addi	sp,sp,-48
 1c8:	f406                	sd	ra,40(sp)
 1ca:	f022                	sd	s0,32(sp)
 1cc:	ec26                	sd	s1,24(sp)
 1ce:	e84a                	sd	s2,16(sp)
 1d0:	e44e                	sd	s3,8(sp)
 1d2:	e052                	sd	s4,0(sp)
 1d4:	1800                	addi	s0,sp,48
  if (argc <= 1) {
 1d6:	4785                	li	a5,1
 1d8:	04a7d663          	bge	a5,a0,224 <main+0x5e>
  pattern = argv[1];
 1dc:	0085ba03          	ld	s4,8(a1)
  if (argc <= 2) {
 1e0:	4789                	li	a5,2
 1e2:	04a7db63          	bge	a5,a0,238 <main+0x72>
 1e6:	01058913          	addi	s2,a1,16
 1ea:	ffd5099b          	addiw	s3,a0,-3
 1ee:	02099793          	slli	a5,s3,0x20
 1f2:	01d7d993          	srli	s3,a5,0x1d
 1f6:	05e1                	addi	a1,a1,24
 1f8:	99ae                	add	s3,s3,a1
    if ((fd = open(argv[i], O_RDONLY)) < 0) {
 1fa:	4581                	li	a1,0
 1fc:	00093503          	ld	a0,0(s2)
 200:	37a000ef          	jal	57a <open>
 204:	84aa                	mv	s1,a0
 206:	04054063          	bltz	a0,246 <main+0x80>
    grep(pattern, fd);
 20a:	85aa                	mv	a1,a0
 20c:	8552                	mv	a0,s4
 20e:	eebff0ef          	jal	f8 <grep>
    close(fd);
 212:	8526                	mv	a0,s1
 214:	34e000ef          	jal	562 <close>
  for (i = 2; i < argc; i++) {
 218:	0921                	addi	s2,s2,8
 21a:	ff3910e3          	bne	s2,s3,1fa <main+0x34>
  exit(0);
 21e:	4501                	li	a0,0
 220:	2f2000ef          	jal	512 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 224:	00001597          	auipc	a1,0x1
 228:	91c58593          	addi	a1,a1,-1764 # b40 <malloc+0xf8>
 22c:	4509                	li	a0,2
 22e:	738000ef          	jal	966 <fprintf>
    exit(1);
 232:	4505                	li	a0,1
 234:	2de000ef          	jal	512 <exit>
    grep(pattern, 0);
 238:	4581                	li	a1,0
 23a:	8552                	mv	a0,s4
 23c:	ebdff0ef          	jal	f8 <grep>
    exit(0);
 240:	4501                	li	a0,0
 242:	2d0000ef          	jal	512 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 246:	00093583          	ld	a1,0(s2)
 24a:	00001517          	auipc	a0,0x1
 24e:	91650513          	addi	a0,a0,-1770 # b60 <malloc+0x118>
 252:	73e000ef          	jal	990 <printf>
      exit(1);
 256:	4505                	li	a0,1
 258:	2ba000ef          	jal	512 <exit>

000000000000025c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e406                	sd	ra,8(sp)
 260:	e022                	sd	s0,0(sp)
 262:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 264:	f63ff0ef          	jal	1c6 <main>
  exit(r);
 268:	2aa000ef          	jal	512 <exit>

000000000000026c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 274:	87aa                	mv	a5,a0
 276:	0585                	addi	a1,a1,1
 278:	0785                	addi	a5,a5,1
 27a:	fff5c703          	lbu	a4,-1(a1)
 27e:	fee78fa3          	sb	a4,-1(a5)
 282:	fb75                	bnez	a4,276 <strcpy+0xa>
    ;
  return os;
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret

000000000000028c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 294:	00054783          	lbu	a5,0(a0)
 298:	cb91                	beqz	a5,2ac <strcmp+0x20>
 29a:	0005c703          	lbu	a4,0(a1)
 29e:	00f71763          	bne	a4,a5,2ac <strcmp+0x20>
    p++, q++;
 2a2:	0505                	addi	a0,a0,1
 2a4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	fbe5                	bnez	a5,29a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2ac:	0005c503          	lbu	a0,0(a1)
}
 2b0:	40a7853b          	subw	a0,a5,a0
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <strlen>:

uint
strlen(const char *s)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	cf91                	beqz	a5,2e4 <strlen+0x28>
 2ca:	00150793          	addi	a5,a0,1
 2ce:	86be                	mv	a3,a5
 2d0:	0785                	addi	a5,a5,1
 2d2:	fff7c703          	lbu	a4,-1(a5)
 2d6:	ff65                	bnez	a4,2ce <strlen+0x12>
 2d8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  for (n = 0; s[n]; n++)
 2e4:	4501                	li	a0,0
 2e6:	bfdd                	j	2dc <strlen+0x20>

00000000000002e8 <memset>:

void *
memset(void *dst, int c, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 2f0:	ca19                	beqz	a2,306 <memset+0x1e>
 2f2:	87aa                	mv	a5,a0
 2f4:	1602                	slli	a2,a2,0x20
 2f6:	9201                	srli	a2,a2,0x20
 2f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fc:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 300:	0785                	addi	a5,a5,1
 302:	fee79de3          	bne	a5,a4,2fc <memset+0x14>
  }
  return dst;
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <strchr>:

char *
strchr(const char *s, char c)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  for (; *s; s++)
 316:	00054783          	lbu	a5,0(a0)
 31a:	cf81                	beqz	a5,332 <strchr+0x24>
    if (*s == c)
 31c:	00f58763          	beq	a1,a5,32a <strchr+0x1c>
  for (; *s; s++)
 320:	0505                	addi	a0,a0,1
 322:	00054783          	lbu	a5,0(a0)
 326:	fbfd                	bnez	a5,31c <strchr+0xe>
      return (char *)s;
  return 0;
 328:	4501                	li	a0,0
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  return 0;
 332:	4501                	li	a0,0
 334:	bfdd                	j	32a <strchr+0x1c>

0000000000000336 <gets>:

char *
gets(char *buf, int max)
{
 336:	711d                	addi	sp,sp,-96
 338:	ec86                	sd	ra,88(sp)
 33a:	e8a2                	sd	s0,80(sp)
 33c:	e4a6                	sd	s1,72(sp)
 33e:	e0ca                	sd	s2,64(sp)
 340:	fc4e                	sd	s3,56(sp)
 342:	f852                	sd	s4,48(sp)
 344:	f456                	sd	s5,40(sp)
 346:	f05a                	sd	s6,32(sp)
 348:	ec5e                	sd	s7,24(sp)
 34a:	e862                	sd	s8,16(sp)
 34c:	1080                	addi	s0,sp,96
 34e:	8baa                	mv	s7,a0
 350:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 352:	892a                	mv	s2,a0
 354:	4481                	li	s1,0
    cc = read(0, &c, 1);
 356:	faf40b13          	addi	s6,s0,-81
 35a:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 35c:	8c26                	mv	s8,s1
 35e:	0014899b          	addiw	s3,s1,1
 362:	84ce                	mv	s1,s3
 364:	0349d463          	bge	s3,s4,38c <gets+0x56>
    cc = read(0, &c, 1);
 368:	8656                	mv	a2,s5
 36a:	85da                	mv	a1,s6
 36c:	4501                	li	a0,0
 36e:	1c4000ef          	jal	532 <read>
    if (cc < 1)
 372:	00a05d63          	blez	a0,38c <gets+0x56>
      break;
    buf[i++] = c;
 376:	faf44783          	lbu	a5,-81(s0)
 37a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 37e:	0905                	addi	s2,s2,1
 380:	ff678713          	addi	a4,a5,-10
 384:	c319                	beqz	a4,38a <gets+0x54>
 386:	17cd                	addi	a5,a5,-13
 388:	fbf1                	bnez	a5,35c <gets+0x26>
    buf[i++] = c;
 38a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 38c:	9c5e                	add	s8,s8,s7
 38e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 392:	855e                	mv	a0,s7
 394:	60e6                	ld	ra,88(sp)
 396:	6446                	ld	s0,80(sp)
 398:	64a6                	ld	s1,72(sp)
 39a:	6906                	ld	s2,64(sp)
 39c:	79e2                	ld	s3,56(sp)
 39e:	7a42                	ld	s4,48(sp)
 3a0:	7aa2                	ld	s5,40(sp)
 3a2:	7b02                	ld	s6,32(sp)
 3a4:	6be2                	ld	s7,24(sp)
 3a6:	6c42                	ld	s8,16(sp)
 3a8:	6125                	addi	sp,sp,96
 3aa:	8082                	ret

00000000000003ac <stat>:

int
stat(const char *n, struct stat *st)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	e04a                	sd	s2,0(sp)
 3b4:	1000                	addi	s0,sp,32
 3b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b8:	4581                	li	a1,0
 3ba:	1c0000ef          	jal	57a <open>
  if (fd < 0)
 3be:	02054263          	bltz	a0,3e2 <stat+0x36>
 3c2:	e426                	sd	s1,8(sp)
 3c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c6:	85ca                	mv	a1,s2
 3c8:	1ca000ef          	jal	592 <fstat>
 3cc:	892a                	mv	s2,a0
  close(fd);
 3ce:	8526                	mv	a0,s1
 3d0:	192000ef          	jal	562 <close>
  return r;
 3d4:	64a2                	ld	s1,8(sp)
}
 3d6:	854a                	mv	a0,s2
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	6902                	ld	s2,0(sp)
 3de:	6105                	addi	sp,sp,32
 3e0:	8082                	ret
    return -1;
 3e2:	57fd                	li	a5,-1
 3e4:	893e                	mv	s2,a5
 3e6:	bfc5                	j	3d6 <stat+0x2a>

00000000000003e8 <atoi>:

int
atoi(const char *s)
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e406                	sd	ra,8(sp)
 3ec:	e022                	sd	s0,0(sp)
 3ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 3f0:	00054683          	lbu	a3,0(a0)
 3f4:	fd06879b          	addiw	a5,a3,-48
 3f8:	0ff7f793          	zext.b	a5,a5
 3fc:	4625                	li	a2,9
 3fe:	02f66963          	bltu	a2,a5,430 <atoi+0x48>
 402:	872a                	mv	a4,a0
  n = 0;
 404:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 406:	0705                	addi	a4,a4,1
 408:	0025179b          	slliw	a5,a0,0x2
 40c:	9fa9                	addw	a5,a5,a0
 40e:	0017979b          	slliw	a5,a5,0x1
 412:	9fb5                	addw	a5,a5,a3
 414:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 418:	00074683          	lbu	a3,0(a4)
 41c:	fd06879b          	addiw	a5,a3,-48
 420:	0ff7f793          	zext.b	a5,a5
 424:	fef671e3          	bgeu	a2,a5,406 <atoi+0x1e>
  return n;
}
 428:	60a2                	ld	ra,8(sp)
 42a:	6402                	ld	s0,0(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret
  n = 0;
 430:	4501                	li	a0,0
 432:	bfdd                	j	428 <atoi+0x40>

0000000000000434 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 434:	1141                	addi	sp,sp,-16
 436:	e406                	sd	ra,8(sp)
 438:	e022                	sd	s0,0(sp)
 43a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 43c:	02b57563          	bgeu	a0,a1,466 <memmove+0x32>
    while (n-- > 0)
 440:	00c05f63          	blez	a2,45e <memmove+0x2a>
 444:	1602                	slli	a2,a2,0x20
 446:	9201                	srli	a2,a2,0x20
 448:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 44c:	872a                	mv	a4,a0
      *dst++ = *src++;
 44e:	0585                	addi	a1,a1,1
 450:	0705                	addi	a4,a4,1
 452:	fff5c683          	lbu	a3,-1(a1)
 456:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 45a:	fee79ae3          	bne	a5,a4,44e <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret
    while (n-- > 0)
 466:	fec05ce3          	blez	a2,45e <memmove+0x2a>
    dst += n;
 46a:	00c50733          	add	a4,a0,a2
    src += n;
 46e:	95b2                	add	a1,a1,a2
 470:	fff6079b          	addiw	a5,a2,-1
 474:	1782                	slli	a5,a5,0x20
 476:	9381                	srli	a5,a5,0x20
 478:	fff7c793          	not	a5,a5
 47c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 47e:	15fd                	addi	a1,a1,-1
 480:	177d                	addi	a4,a4,-1
 482:	0005c683          	lbu	a3,0(a1)
 486:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 48a:	fef71ae3          	bne	a4,a5,47e <memmove+0x4a>
 48e:	bfc1                	j	45e <memmove+0x2a>

0000000000000490 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 490:	1141                	addi	sp,sp,-16
 492:	e406                	sd	ra,8(sp)
 494:	e022                	sd	s0,0(sp)
 496:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 498:	c61d                	beqz	a2,4c6 <memcmp+0x36>
 49a:	1602                	slli	a2,a2,0x20
 49c:	9201                	srli	a2,a2,0x20
 49e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4a2:	00054783          	lbu	a5,0(a0)
 4a6:	0005c703          	lbu	a4,0(a1)
 4aa:	00e79863          	bne	a5,a4,4ba <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 4ae:	0505                	addi	a0,a0,1
    p2++;
 4b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4b2:	fed518e3          	bne	a0,a3,4a2 <memcmp+0x12>
  }
  return 0;
 4b6:	4501                	li	a0,0
 4b8:	a019                	j	4be <memcmp+0x2e>
      return *p1 - *p2;
 4ba:	40e7853b          	subw	a0,a5,a4
}
 4be:	60a2                	ld	ra,8(sp)
 4c0:	6402                	ld	s0,0(sp)
 4c2:	0141                	addi	sp,sp,16
 4c4:	8082                	ret
  return 0;
 4c6:	4501                	li	a0,0
 4c8:	bfdd                	j	4be <memcmp+0x2e>

00000000000004ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ca:	1141                	addi	sp,sp,-16
 4cc:	e406                	sd	ra,8(sp)
 4ce:	e022                	sd	s0,0(sp)
 4d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4d2:	f63ff0ef          	jal	434 <memmove>
}
 4d6:	60a2                	ld	ra,8(sp)
 4d8:	6402                	ld	s0,0(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret

00000000000004de <sbrk>:

char *
sbrk(int n)
{
 4de:	1141                	addi	sp,sp,-16
 4e0:	e406                	sd	ra,8(sp)
 4e2:	e022                	sd	s0,0(sp)
 4e4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4e6:	4585                	li	a1,1
 4e8:	0da000ef          	jal	5c2 <sys_sbrk>
}
 4ec:	60a2                	ld	ra,8(sp)
 4ee:	6402                	ld	s0,0(sp)
 4f0:	0141                	addi	sp,sp,16
 4f2:	8082                	ret

00000000000004f4 <sbrklazy>:

char *
sbrklazy(int n)
{
 4f4:	1141                	addi	sp,sp,-16
 4f6:	e406                	sd	ra,8(sp)
 4f8:	e022                	sd	s0,0(sp)
 4fa:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4fc:	4589                	li	a1,2
 4fe:	0c4000ef          	jal	5c2 <sys_sbrk>
}
 502:	60a2                	ld	ra,8(sp)
 504:	6402                	ld	s0,0(sp)
 506:	0141                	addi	sp,sp,16
 508:	8082                	ret

000000000000050a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 50a:	4885                	li	a7,1
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <exit>:
.global exit
exit:
 li a7, SYS_exit
 512:	4889                	li	a7,2
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <wait>:
.global wait
wait:
 li a7, SYS_wait
 51a:	488d                	li	a7,3
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 522:	48b5                	li	a7,13
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 52a:	4891                	li	a7,4
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <read>:
.global read
read:
 li a7, SYS_read
 532:	4895                	li	a7,5
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <write>:
.global write
write:
 li a7, SYS_write
 53a:	48c1                	li	a7,16
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <sem_create>:
.global sem_create
sem_create:
 li a7, SYS_sem_create
 542:	48e1                	li	a7,24
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <sem_wait>:
.global sem_wait
sem_wait:
 li a7, SYS_sem_wait
 54a:	48e5                	li	a7,25
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <sem_signal>:
.global sem_signal
sem_signal:
 li a7, SYS_sem_signal
 552:	48e9                	li	a7,26
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <sem_free>:
.global sem_free
sem_free:
 li a7, SYS_sem_free
 55a:	48ed                	li	a7,27
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <close>:
.global close
close:
 li a7, SYS_close
 562:	48d5                	li	a7,21
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <kill>:
.global kill
kill:
 li a7, SYS_kill
 56a:	4899                	li	a7,6
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <exec>:
.global exec
exec:
 li a7, SYS_exec
 572:	489d                	li	a7,7
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <open>:
.global open
open:
 li a7, SYS_open
 57a:	48bd                	li	a7,15
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 582:	48c5                	li	a7,17
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 58a:	48c9                	li	a7,18
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 592:	48a1                	li	a7,8
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <link>:
.global link
link:
 li a7, SYS_link
 59a:	48cd                	li	a7,19
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5a2:	48d1                	li	a7,20
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5aa:	48a5                	li	a7,9
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b2:	48a9                	li	a7,10
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ba:	48ad                	li	a7,11
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5c2:	48b1                	li	a7,12
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <pause>:
.global pause
pause:
 li a7, SYS_pause
 5ca:	48b5                	li	a7,13
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5d2:	48b9                	li	a7,14
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <sync>:
.global sync
sync:
 li a7, SYS_sync
 5da:	48d9                	li	a7,22
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <shm_get>:
.global shm_get
shm_get:
 li a7, SYS_shm_get
 5e2:	48dd                	li	a7,23
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ea:	1101                	addi	sp,sp,-32
 5ec:	ec06                	sd	ra,24(sp)
 5ee:	e822                	sd	s0,16(sp)
 5f0:	1000                	addi	s0,sp,32
 5f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5f6:	4605                	li	a2,1
 5f8:	fef40593          	addi	a1,s0,-17
 5fc:	f3fff0ef          	jal	53a <write>
}
 600:	60e2                	ld	ra,24(sp)
 602:	6442                	ld	s0,16(sp)
 604:	6105                	addi	sp,sp,32
 606:	8082                	ret

0000000000000608 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 608:	715d                	addi	sp,sp,-80
 60a:	e486                	sd	ra,72(sp)
 60c:	e0a2                	sd	s0,64(sp)
 60e:	f84a                	sd	s2,48(sp)
 610:	f44e                	sd	s3,40(sp)
 612:	0880                	addi	s0,sp,80
 614:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 616:	c6d1                	beqz	a3,6a2 <printint+0x9a>
 618:	0805d563          	bgez	a1,6a2 <printint+0x9a>
    neg = 1;
    x = -xx;
 61c:	40b005b3          	neg	a1,a1
    neg = 1;
 620:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 622:	fb840993          	addi	s3,s0,-72
  neg = 0;
 626:	86ce                	mv	a3,s3
  i = 0;
 628:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 62a:	00000817          	auipc	a6,0x0
 62e:	55680813          	addi	a6,a6,1366 # b80 <digits>
 632:	88ba                	mv	a7,a4
 634:	0017051b          	addiw	a0,a4,1
 638:	872a                	mv	a4,a0
 63a:	02c5f7b3          	remu	a5,a1,a2
 63e:	97c2                	add	a5,a5,a6
 640:	0007c783          	lbu	a5,0(a5)
 644:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 648:	87ae                	mv	a5,a1
 64a:	02c5d5b3          	divu	a1,a1,a2
 64e:	0685                	addi	a3,a3,1
 650:	fec7f1e3          	bgeu	a5,a2,632 <printint+0x2a>
  if (neg)
 654:	00030c63          	beqz	t1,66c <printint+0x64>
    buf[i++] = '-';
 658:	fd050793          	addi	a5,a0,-48
 65c:	00878533          	add	a0,a5,s0
 660:	02d00793          	li	a5,45
 664:	fef50423          	sb	a5,-24(a0)
 668:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 66c:	02e05563          	blez	a4,696 <printint+0x8e>
 670:	fc26                	sd	s1,56(sp)
 672:	377d                	addiw	a4,a4,-1
 674:	00e984b3          	add	s1,s3,a4
 678:	19fd                	addi	s3,s3,-1
 67a:	99ba                	add	s3,s3,a4
 67c:	1702                	slli	a4,a4,0x20
 67e:	9301                	srli	a4,a4,0x20
 680:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 684:	0004c583          	lbu	a1,0(s1)
 688:	854a                	mv	a0,s2
 68a:	f61ff0ef          	jal	5ea <putc>
  while (--i >= 0)
 68e:	14fd                	addi	s1,s1,-1
 690:	ff349ae3          	bne	s1,s3,684 <printint+0x7c>
 694:	74e2                	ld	s1,56(sp)
}
 696:	60a6                	ld	ra,72(sp)
 698:	6406                	ld	s0,64(sp)
 69a:	7942                	ld	s2,48(sp)
 69c:	79a2                	ld	s3,40(sp)
 69e:	6161                	addi	sp,sp,80
 6a0:	8082                	ret
  neg = 0;
 6a2:	4301                	li	t1,0
 6a4:	bfbd                	j	622 <printint+0x1a>

00000000000006a6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6a6:	711d                	addi	sp,sp,-96
 6a8:	ec86                	sd	ra,88(sp)
 6aa:	e8a2                	sd	s0,80(sp)
 6ac:	e4a6                	sd	s1,72(sp)
 6ae:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 6b0:	0005c483          	lbu	s1,0(a1)
 6b4:	22048363          	beqz	s1,8da <vprintf+0x234>
 6b8:	e0ca                	sd	s2,64(sp)
 6ba:	fc4e                	sd	s3,56(sp)
 6bc:	f852                	sd	s4,48(sp)
 6be:	f456                	sd	s5,40(sp)
 6c0:	f05a                	sd	s6,32(sp)
 6c2:	ec5e                	sd	s7,24(sp)
 6c4:	e862                	sd	s8,16(sp)
 6c6:	8b2a                	mv	s6,a0
 6c8:	8a2e                	mv	s4,a1
 6ca:	8bb2                	mv	s7,a2
  state = 0;
 6cc:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 6ce:	4901                	li	s2,0
 6d0:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 6d2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 6d6:	06400c13          	li	s8,100
 6da:	a00d                	j	6fc <vprintf+0x56>
        putc(fd, c0);
 6dc:	85a6                	mv	a1,s1
 6de:	855a                	mv	a0,s6
 6e0:	f0bff0ef          	jal	5ea <putc>
 6e4:	a019                	j	6ea <vprintf+0x44>
    } else if (state == '%') {
 6e6:	03598363          	beq	s3,s5,70c <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 6ea:	0019079b          	addiw	a5,s2,1
 6ee:	893e                	mv	s2,a5
 6f0:	873e                	mv	a4,a5
 6f2:	97d2                	add	a5,a5,s4
 6f4:	0007c483          	lbu	s1,0(a5)
 6f8:	1c048a63          	beqz	s1,8cc <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 6fc:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 700:	fe0993e3          	bnez	s3,6e6 <vprintf+0x40>
      if (c0 == '%') {
 704:	fd579ce3          	bne	a5,s5,6dc <vprintf+0x36>
        state = '%';
 708:	89be                	mv	s3,a5
 70a:	b7c5                	j	6ea <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 70c:	00ea06b3          	add	a3,s4,a4
 710:	0016c603          	lbu	a2,1(a3)
      if (c1)
 714:	1c060863          	beqz	a2,8e4 <vprintf+0x23e>
      if (c0 == 'd') {
 718:	03878763          	beq	a5,s8,746 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 71c:	f9478693          	addi	a3,a5,-108
 720:	0016b693          	seqz	a3,a3
 724:	f9c60593          	addi	a1,a2,-100
 728:	e99d                	bnez	a1,75e <vprintf+0xb8>
 72a:	ca95                	beqz	a3,75e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 72c:	008b8493          	addi	s1,s7,8
 730:	4685                	li	a3,1
 732:	4629                	li	a2,10
 734:	000bb583          	ld	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	ecfff0ef          	jal	608 <printint>
        i += 1;
 73e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 740:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 742:	4981                	li	s3,0
 744:	b75d                	j	6ea <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 746:	008b8493          	addi	s1,s7,8
 74a:	4685                	li	a3,1
 74c:	4629                	li	a2,10
 74e:	000ba583          	lw	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	eb5ff0ef          	jal	608 <printint>
 758:	8ba6                	mv	s7,s1
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b779                	j	6ea <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 75e:	9752                	add	a4,a4,s4
 760:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 764:	f9460713          	addi	a4,a2,-108
 768:	00173713          	seqz	a4,a4
 76c:	8f75                	and	a4,a4,a3
 76e:	f9c58513          	addi	a0,a1,-100
 772:	18051363          	bnez	a0,8f8 <vprintf+0x252>
 776:	18070163          	beqz	a4,8f8 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 77a:	008b8493          	addi	s1,s7,8
 77e:	4685                	li	a3,1
 780:	4629                	li	a2,10
 782:	000bb583          	ld	a1,0(s7)
 786:	855a                	mv	a0,s6
 788:	e81ff0ef          	jal	608 <printint>
        i += 2;
 78c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 78e:	8ba6                	mv	s7,s1
      state = 0;
 790:	4981                	li	s3,0
        i += 2;
 792:	bfa1                	j	6ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 794:	008b8493          	addi	s1,s7,8
 798:	4681                	li	a3,0
 79a:	4629                	li	a2,10
 79c:	000be583          	lwu	a1,0(s7)
 7a0:	855a                	mv	a0,s6
 7a2:	e67ff0ef          	jal	608 <printint>
 7a6:	8ba6                	mv	s7,s1
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	b781                	j	6ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ac:	008b8493          	addi	s1,s7,8
 7b0:	4681                	li	a3,0
 7b2:	4629                	li	a2,10
 7b4:	000bb583          	ld	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	e4fff0ef          	jal	608 <printint>
        i += 1;
 7be:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c0:	8ba6                	mv	s7,s1
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	b71d                	j	6ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c6:	008b8493          	addi	s1,s7,8
 7ca:	4681                	li	a3,0
 7cc:	4629                	li	a2,10
 7ce:	000bb583          	ld	a1,0(s7)
 7d2:	855a                	mv	a0,s6
 7d4:	e35ff0ef          	jal	608 <printint>
        i += 2;
 7d8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7da:	8ba6                	mv	s7,s1
      state = 0;
 7dc:	4981                	li	s3,0
        i += 2;
 7de:	b731                	j	6ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7e0:	008b8493          	addi	s1,s7,8
 7e4:	4681                	li	a3,0
 7e6:	4641                	li	a2,16
 7e8:	000be583          	lwu	a1,0(s7)
 7ec:	855a                	mv	a0,s6
 7ee:	e1bff0ef          	jal	608 <printint>
 7f2:	8ba6                	mv	s7,s1
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	bdd5                	j	6ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f8:	008b8493          	addi	s1,s7,8
 7fc:	4681                	li	a3,0
 7fe:	4641                	li	a2,16
 800:	000bb583          	ld	a1,0(s7)
 804:	855a                	mv	a0,s6
 806:	e03ff0ef          	jal	608 <printint>
        i += 1;
 80a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 80c:	8ba6                	mv	s7,s1
      state = 0;
 80e:	4981                	li	s3,0
 810:	bde9                	j	6ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 812:	008b8493          	addi	s1,s7,8
 816:	4681                	li	a3,0
 818:	4641                	li	a2,16
 81a:	000bb583          	ld	a1,0(s7)
 81e:	855a                	mv	a0,s6
 820:	de9ff0ef          	jal	608 <printint>
        i += 2;
 824:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 826:	8ba6                	mv	s7,s1
      state = 0;
 828:	4981                	li	s3,0
        i += 2;
 82a:	b5c1                	j	6ea <vprintf+0x44>
 82c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 82e:	008b8793          	addi	a5,s7,8
 832:	8cbe                	mv	s9,a5
 834:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 838:	03000593          	li	a1,48
 83c:	855a                	mv	a0,s6
 83e:	dadff0ef          	jal	5ea <putc>
  putc(fd, 'x');
 842:	07800593          	li	a1,120
 846:	855a                	mv	a0,s6
 848:	da3ff0ef          	jal	5ea <putc>
 84c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 84e:	00000b97          	auipc	s7,0x0
 852:	332b8b93          	addi	s7,s7,818 # b80 <digits>
 856:	03c9d793          	srli	a5,s3,0x3c
 85a:	97de                	add	a5,a5,s7
 85c:	0007c583          	lbu	a1,0(a5)
 860:	855a                	mv	a0,s6
 862:	d89ff0ef          	jal	5ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 866:	0992                	slli	s3,s3,0x4
 868:	34fd                	addiw	s1,s1,-1
 86a:	f4f5                	bnez	s1,856 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 86c:	8be6                	mv	s7,s9
      state = 0;
 86e:	4981                	li	s3,0
 870:	6ca2                	ld	s9,8(sp)
 872:	bda5                	j	6ea <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 874:	008b8493          	addi	s1,s7,8
 878:	000bc583          	lbu	a1,0(s7)
 87c:	855a                	mv	a0,s6
 87e:	d6dff0ef          	jal	5ea <putc>
 882:	8ba6                	mv	s7,s1
      state = 0;
 884:	4981                	li	s3,0
 886:	b595                	j	6ea <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 888:	008b8993          	addi	s3,s7,8
 88c:	000bb483          	ld	s1,0(s7)
 890:	cc91                	beqz	s1,8ac <vprintf+0x206>
        for (; *s; s++)
 892:	0004c583          	lbu	a1,0(s1)
 896:	c985                	beqz	a1,8c6 <vprintf+0x220>
          putc(fd, *s);
 898:	855a                	mv	a0,s6
 89a:	d51ff0ef          	jal	5ea <putc>
        for (; *s; s++)
 89e:	0485                	addi	s1,s1,1
 8a0:	0004c583          	lbu	a1,0(s1)
 8a4:	f9f5                	bnez	a1,898 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 8a6:	8bce                	mv	s7,s3
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	b581                	j	6ea <vprintf+0x44>
          s = "(null)";
 8ac:	00000497          	auipc	s1,0x0
 8b0:	2cc48493          	addi	s1,s1,716 # b78 <malloc+0x130>
        for (; *s; s++)
 8b4:	02800593          	li	a1,40
 8b8:	b7c5                	j	898 <vprintf+0x1f2>
        putc(fd, '%');
 8ba:	85be                	mv	a1,a5
 8bc:	855a                	mv	a0,s6
 8be:	d2dff0ef          	jal	5ea <putc>
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	b51d                	j	6ea <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 8c6:	8bce                	mv	s7,s3
      state = 0;
 8c8:	4981                	li	s3,0
 8ca:	b505                	j	6ea <vprintf+0x44>
 8cc:	6906                	ld	s2,64(sp)
 8ce:	79e2                	ld	s3,56(sp)
 8d0:	7a42                	ld	s4,48(sp)
 8d2:	7aa2                	ld	s5,40(sp)
 8d4:	7b02                	ld	s6,32(sp)
 8d6:	6be2                	ld	s7,24(sp)
 8d8:	6c42                	ld	s8,16(sp)
    }
  }
}
 8da:	60e6                	ld	ra,88(sp)
 8dc:	6446                	ld	s0,80(sp)
 8de:	64a6                	ld	s1,72(sp)
 8e0:	6125                	addi	sp,sp,96
 8e2:	8082                	ret
      if (c0 == 'd') {
 8e4:	06400713          	li	a4,100
 8e8:	e4e78fe3          	beq	a5,a4,746 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 8ec:	f9478693          	addi	a3,a5,-108
 8f0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 8f4:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 8f6:	4701                	li	a4,0
      } else if (c0 == 'u') {
 8f8:	07500513          	li	a0,117
 8fc:	e8a78ce3          	beq	a5,a0,794 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 900:	f8b60513          	addi	a0,a2,-117
 904:	e119                	bnez	a0,90a <vprintf+0x264>
 906:	ea0693e3          	bnez	a3,7ac <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 90a:	f8b58513          	addi	a0,a1,-117
 90e:	e119                	bnez	a0,914 <vprintf+0x26e>
 910:	ea071be3          	bnez	a4,7c6 <vprintf+0x120>
      } else if (c0 == 'x') {
 914:	07800513          	li	a0,120
 918:	eca784e3          	beq	a5,a0,7e0 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 91c:	f8860613          	addi	a2,a2,-120
 920:	e219                	bnez	a2,926 <vprintf+0x280>
 922:	ec069be3          	bnez	a3,7f8 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 926:	f8858593          	addi	a1,a1,-120
 92a:	e199                	bnez	a1,930 <vprintf+0x28a>
 92c:	ee0713e3          	bnez	a4,812 <vprintf+0x16c>
      } else if (c0 == 'p') {
 930:	07000713          	li	a4,112
 934:	eee78ce3          	beq	a5,a4,82c <vprintf+0x186>
      } else if (c0 == 'c') {
 938:	06300713          	li	a4,99
 93c:	f2e78ce3          	beq	a5,a4,874 <vprintf+0x1ce>
      } else if (c0 == 's') {
 940:	07300713          	li	a4,115
 944:	f4e782e3          	beq	a5,a4,888 <vprintf+0x1e2>
      } else if (c0 == '%') {
 948:	02500713          	li	a4,37
 94c:	f6e787e3          	beq	a5,a4,8ba <vprintf+0x214>
        putc(fd, '%');
 950:	02500593          	li	a1,37
 954:	855a                	mv	a0,s6
 956:	c95ff0ef          	jal	5ea <putc>
        putc(fd, c0);
 95a:	85a6                	mv	a1,s1
 95c:	855a                	mv	a0,s6
 95e:	c8dff0ef          	jal	5ea <putc>
      state = 0;
 962:	4981                	li	s3,0
 964:	b359                	j	6ea <vprintf+0x44>

0000000000000966 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 966:	715d                	addi	sp,sp,-80
 968:	ec06                	sd	ra,24(sp)
 96a:	e822                	sd	s0,16(sp)
 96c:	1000                	addi	s0,sp,32
 96e:	e010                	sd	a2,0(s0)
 970:	e414                	sd	a3,8(s0)
 972:	e818                	sd	a4,16(s0)
 974:	ec1c                	sd	a5,24(s0)
 976:	03043023          	sd	a6,32(s0)
 97a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 97e:	8622                	mv	a2,s0
 980:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 984:	d23ff0ef          	jal	6a6 <vprintf>
}
 988:	60e2                	ld	ra,24(sp)
 98a:	6442                	ld	s0,16(sp)
 98c:	6161                	addi	sp,sp,80
 98e:	8082                	ret

0000000000000990 <printf>:

void
printf(const char *fmt, ...)
{
 990:	711d                	addi	sp,sp,-96
 992:	ec06                	sd	ra,24(sp)
 994:	e822                	sd	s0,16(sp)
 996:	1000                	addi	s0,sp,32
 998:	e40c                	sd	a1,8(s0)
 99a:	e810                	sd	a2,16(s0)
 99c:	ec14                	sd	a3,24(s0)
 99e:	f018                	sd	a4,32(s0)
 9a0:	f41c                	sd	a5,40(s0)
 9a2:	03043823          	sd	a6,48(s0)
 9a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9aa:	00840613          	addi	a2,s0,8
 9ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9b2:	85aa                	mv	a1,a0
 9b4:	4505                	li	a0,1
 9b6:	cf1ff0ef          	jal	6a6 <vprintf>
}
 9ba:	60e2                	ld	ra,24(sp)
 9bc:	6442                	ld	s0,16(sp)
 9be:	6125                	addi	sp,sp,96
 9c0:	8082                	ret

00000000000009c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9c2:	1141                	addi	sp,sp,-16
 9c4:	e406                	sd	ra,8(sp)
 9c6:	e022                	sd	s0,0(sp)
 9c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 9ca:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ce:	00001797          	auipc	a5,0x1
 9d2:	6327b783          	ld	a5,1586(a5) # 2000 <freep>
 9d6:	a039                	j	9e4 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d8:	6398                	ld	a4,0(a5)
 9da:	00e7e463          	bltu	a5,a4,9e2 <free+0x20>
 9de:	00e6ea63          	bltu	a3,a4,9f2 <free+0x30>
{
 9e2:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e4:	fed7fae3          	bgeu	a5,a3,9d8 <free+0x16>
 9e8:	6398                	ld	a4,0(a5)
 9ea:	00e6e463          	bltu	a3,a4,9f2 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ee:	fee7eae3          	bltu	a5,a4,9e2 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 9f2:	ff852583          	lw	a1,-8(a0)
 9f6:	6390                	ld	a2,0(a5)
 9f8:	02059813          	slli	a6,a1,0x20
 9fc:	01c85713          	srli	a4,a6,0x1c
 a00:	9736                	add	a4,a4,a3
 a02:	02e60563          	beq	a2,a4,a2c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 a06:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 a0a:	4790                	lw	a2,8(a5)
 a0c:	02061593          	slli	a1,a2,0x20
 a10:	01c5d713          	srli	a4,a1,0x1c
 a14:	973e                	add	a4,a4,a5
 a16:	02e68263          	beq	a3,a4,a3a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a1a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a1c:	00001717          	auipc	a4,0x1
 a20:	5ef73223          	sd	a5,1508(a4) # 2000 <freep>
}
 a24:	60a2                	ld	ra,8(sp)
 a26:	6402                	ld	s0,0(sp)
 a28:	0141                	addi	sp,sp,16
 a2a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 a2c:	4618                	lw	a4,8(a2)
 a2e:	9f2d                	addw	a4,a4,a1
 a30:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a34:	6398                	ld	a4,0(a5)
 a36:	6310                	ld	a2,0(a4)
 a38:	b7f9                	j	a06 <free+0x44>
    p->s.size += bp->s.size;
 a3a:	ff852703          	lw	a4,-8(a0)
 a3e:	9f31                	addw	a4,a4,a2
 a40:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a42:	ff053683          	ld	a3,-16(a0)
 a46:	bfd1                	j	a1a <free+0x58>

0000000000000a48 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 a48:	7139                	addi	sp,sp,-64
 a4a:	fc06                	sd	ra,56(sp)
 a4c:	f822                	sd	s0,48(sp)
 a4e:	f04a                	sd	s2,32(sp)
 a50:	ec4e                	sd	s3,24(sp)
 a52:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 a54:	02051993          	slli	s3,a0,0x20
 a58:	0209d993          	srli	s3,s3,0x20
 a5c:	09bd                	addi	s3,s3,15
 a5e:	0049d993          	srli	s3,s3,0x4
 a62:	2985                	addiw	s3,s3,1
 a64:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 a66:	00001517          	auipc	a0,0x1
 a6a:	59a53503          	ld	a0,1434(a0) # 2000 <freep>
 a6e:	c905                	beqz	a0,a9e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a70:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a72:	4798                	lw	a4,8(a5)
 a74:	09377663          	bgeu	a4,s3,b00 <malloc+0xb8>
 a78:	f426                	sd	s1,40(sp)
 a7a:	e852                	sd	s4,16(sp)
 a7c:	e456                	sd	s5,8(sp)
 a7e:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 a80:	8a4e                	mv	s4,s3
 a82:	6705                	lui	a4,0x1
 a84:	00e9f363          	bgeu	s3,a4,a8a <malloc+0x42>
 a88:	6a05                	lui	s4,0x1
 a8a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a8e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 a92:	00001497          	auipc	s1,0x1
 a96:	56e48493          	addi	s1,s1,1390 # 2000 <freep>
  if (p == SBRK_ERROR)
 a9a:	5afd                	li	s5,-1
 a9c:	a83d                	j	ada <malloc+0x92>
 a9e:	f426                	sd	s1,40(sp)
 aa0:	e852                	sd	s4,16(sp)
 aa2:	e456                	sd	s5,8(sp)
 aa4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 aa6:	00002797          	auipc	a5,0x2
 aaa:	96a78793          	addi	a5,a5,-1686 # 2410 <base>
 aae:	00001717          	auipc	a4,0x1
 ab2:	54f73923          	sd	a5,1362(a4) # 2000 <freep>
 ab6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ab8:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 abc:	b7d1                	j	a80 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 abe:	6398                	ld	a4,0(a5)
 ac0:	e118                	sd	a4,0(a0)
 ac2:	a899                	j	b18 <malloc+0xd0>
  hp->s.size = nu;
 ac4:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 ac8:	0541                	addi	a0,a0,16
 aca:	ef9ff0ef          	jal	9c2 <free>
  return freep;
 ace:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 ad0:	c125                	beqz	a0,b30 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 ad2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 ad4:	4798                	lw	a4,8(a5)
 ad6:	03277163          	bgeu	a4,s2,af8 <malloc+0xb0>
    if (p == freep)
 ada:	6098                	ld	a4,0(s1)
 adc:	853e                	mv	a0,a5
 ade:	fef71ae3          	bne	a4,a5,ad2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ae2:	8552                	mv	a0,s4
 ae4:	9fbff0ef          	jal	4de <sbrk>
  if (p == SBRK_ERROR)
 ae8:	fd551ee3          	bne	a0,s5,ac4 <malloc+0x7c>
        return 0;
 aec:	4501                	li	a0,0
 aee:	74a2                	ld	s1,40(sp)
 af0:	6a42                	ld	s4,16(sp)
 af2:	6aa2                	ld	s5,8(sp)
 af4:	6b02                	ld	s6,0(sp)
 af6:	a03d                	j	b24 <malloc+0xdc>
 af8:	74a2                	ld	s1,40(sp)
 afa:	6a42                	ld	s4,16(sp)
 afc:	6aa2                	ld	s5,8(sp)
 afe:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 b00:	fae90fe3          	beq	s2,a4,abe <malloc+0x76>
        p->s.size -= nunits;
 b04:	4137073b          	subw	a4,a4,s3
 b08:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b0a:	02071693          	slli	a3,a4,0x20
 b0e:	01c6d713          	srli	a4,a3,0x1c
 b12:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b14:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b18:	00001717          	auipc	a4,0x1
 b1c:	4ea73423          	sd	a0,1256(a4) # 2000 <freep>
      return (void *)(p + 1);
 b20:	01078513          	addi	a0,a5,16
  }
}
 b24:	70e2                	ld	ra,56(sp)
 b26:	7442                	ld	s0,48(sp)
 b28:	7902                	ld	s2,32(sp)
 b2a:	69e2                	ld	s3,24(sp)
 b2c:	6121                	addi	sp,sp,64
 b2e:	8082                	ret
 b30:	74a2                	ld	s1,40(sp)
 b32:	6a42                	ld	s4,16(sp)
 b34:	6aa2                	ld	s5,8(sp)
 b36:	6b02                	ld	s6,0(sp)
 b38:	b7f5                	j	b24 <malloc+0xdc>
