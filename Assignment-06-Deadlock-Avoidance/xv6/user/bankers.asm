
user/_bankers:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <calculate_need>:

int available[M] = {3, 3, 2};

void
calculate_need(int need[N][M])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    for (int i = 0; i < N; i++)
   8:	00002797          	auipc	a5,0x2
   c:	ff878793          	addi	a5,a5,-8 # 2000 <max>
  10:	00002717          	auipc	a4,0x2
  14:	03070713          	addi	a4,a4,48 # 2040 <allocation>
  18:	00002597          	auipc	a1,0x2
  1c:	02458593          	addi	a1,a1,36 # 203c <max+0x3c>
        for (int j = 0; j < M; j++)
            need[i][j] = max[i][j] - allocation[i][j];
  20:	4394                	lw	a3,0(a5)
  22:	4310                	lw	a2,0(a4)
  24:	9e91                	subw	a3,a3,a2
  26:	c114                	sw	a3,0(a0)
  28:	43d4                	lw	a3,4(a5)
  2a:	4350                	lw	a2,4(a4)
  2c:	9e91                	subw	a3,a3,a2
  2e:	c154                	sw	a3,4(a0)
  30:	4794                	lw	a3,8(a5)
  32:	4710                	lw	a2,8(a4)
  34:	9e91                	subw	a3,a3,a2
  36:	c514                	sw	a3,8(a0)
    for (int i = 0; i < N; i++)
  38:	07b1                	addi	a5,a5,12
  3a:	0731                	addi	a4,a4,12
  3c:	0531                	addi	a0,a0,12
  3e:	feb791e3          	bne	a5,a1,20 <calculate_need+0x20>
}
  42:	60a2                	ld	ra,8(sp)
  44:	6402                	ld	s0,0(sp)
  46:	0141                	addi	sp,sp,16
  48:	8082                	ret

000000000000004a <is_safe>:

int
is_safe(int print_sequence)
{
  4a:	7175                	addi	sp,sp,-144
  4c:	e506                	sd	ra,136(sp)
  4e:	e122                	sd	s0,128(sp)
  50:	fca6                	sd	s1,120(sp)
  52:	0900                	addi	s0,sp,144
  54:	84aa                	mv	s1,a0
    int work[M];
    int finish[N];
    int sequence[N];
    int count = 0;

    calculate_need(need);
  56:	fa040513          	addi	a0,s0,-96
  5a:	fa7ff0ef          	jal	0 <calculate_need>

    for (int j = 0; j < M; j++)
        work[j] = available[j];
  5e:	00002797          	auipc	a5,0x2
  62:	fa278793          	addi	a5,a5,-94 # 2000 <max>
  66:	0807a883          	lw	a7,128(a5)
  6a:	0847a503          	lw	a0,132(a5)
  6e:	0887a303          	lw	t1,136(a5)

    for (int i = 0; i < N; i++)
        finish[i] = 0;
  72:	f8042423          	sw	zero,-120(s0)
  76:	f8042623          	sw	zero,-116(s0)
  7a:	f8042823          	sw	zero,-112(s0)
  7e:	f8042a23          	sw	zero,-108(s0)
  82:	f8042c23          	sw	zero,-104(s0)
    int count = 0;
  86:	4e01                	li	t3,0

    while (count < N) {
        int found = 0;

        for (int i = 0; i < N; i++) {
  88:	4815                	li	a6,5

            if (possible) {
                for (int j = 0; j < M; j++)
                    work[j] += allocation[i][j];

                finish[i] = 1;
  8a:	4f05                	li	t5,1
                sequence[count++] = i;
  8c:	f7040293          	addi	t0,s0,-144
    while (count < N) {
  90:	4f91                	li	t6,4
  92:	a0b9                	j	e0 <is_safe+0x96>
        for (int i = 0; i < N; i++) {
  94:	2705                	addiw	a4,a4,1
  96:	0691                	addi	a3,a3,4
  98:	0631                	addi	a2,a2,12
  9a:	07b1                	addi	a5,a5,12
  9c:	03070e63          	beq	a4,a6,d8 <is_safe+0x8e>
            if (finish[i])
  a0:	428c                	lw	a1,0(a3)
  a2:	f9ed                	bnez	a1,94 <is_safe+0x4a>
                if (need[i][j] > work[j]) {
  a4:	438c                	lw	a1,0(a5)
  a6:	feb8c7e3          	blt	a7,a1,94 <is_safe+0x4a>
  aa:	43cc                	lw	a1,4(a5)
  ac:	feb544e3          	blt	a0,a1,94 <is_safe+0x4a>
  b0:	478c                	lw	a1,8(a5)
  b2:	feb341e3          	blt	t1,a1,94 <is_safe+0x4a>
                    work[j] += allocation[i][j];
  b6:	420c                	lw	a1,0(a2)
  b8:	011588bb          	addw	a7,a1,a7
  bc:	424c                	lw	a1,4(a2)
  be:	9d2d                	addw	a0,a0,a1
  c0:	460c                	lw	a1,8(a2)
  c2:	0065833b          	addw	t1,a1,t1
                finish[i] = 1;
  c6:	01e6a023          	sw	t5,0(a3)
                sequence[count++] = i;
  ca:	002e1593          	slli	a1,t3,0x2
  ce:	9596                	add	a1,a1,t0
  d0:	c198                	sw	a4,0(a1)
  d2:	2e05                	addiw	t3,t3,1
                found = 1;
  d4:	8efa                	mv	t4,t5
  d6:	bf7d                	j	94 <is_safe+0x4a>
            }
        }

        if (!found)
  d8:	000e8f63          	beqz	t4,f6 <is_safe+0xac>
    while (count < N) {
  dc:	01cfcd63          	blt	t6,t3,f6 <is_safe+0xac>
        for (int i = 0; i < N; i++) {
  e0:	f8840693          	addi	a3,s0,-120
  e4:	00002617          	auipc	a2,0x2
  e8:	f5c60613          	addi	a2,a2,-164 # 2040 <allocation>
  ec:	fa040793          	addi	a5,s0,-96
  f0:	4701                	li	a4,0
        int found = 0;
  f2:	4e81                	li	t4,0
  f4:	b775                	j	a0 <is_safe+0x56>
            break;
    }

    if (count != N) {
  f6:	4795                	li	a5,5
  f8:	02fe0163          	beq	t3,a5,11a <is_safe+0xd0>
        if (print_sequence)
            printf("System is NOT in a safe state.\n");
        return 0;
  fc:	8526                	mv	a0,s1
        if (print_sequence)
  fe:	e491                	bnez	s1,10a <is_safe+0xc0>

        printf("\n");
    }

    return 1;
}
 100:	60aa                	ld	ra,136(sp)
 102:	640a                	ld	s0,128(sp)
 104:	74e6                	ld	s1,120(sp)
 106:	6149                	addi	sp,sp,144
 108:	8082                	ret
            printf("System is NOT in a safe state.\n");
 10a:	00001517          	auipc	a0,0x1
 10e:	c6650513          	addi	a0,a0,-922 # d70 <malloc+0xf8>
 112:	2af000ef          	jal	bc0 <printf>
        return 0;
 116:	4501                	li	a0,0
 118:	b7e5                	j	100 <is_safe+0xb6>
    return 1;
 11a:	4505                	li	a0,1
    if (print_sequence) {
 11c:	d0f5                	beqz	s1,100 <is_safe+0xb6>
        printf("System is in a SAFE state.\n");
 11e:	00001517          	auipc	a0,0x1
 122:	c7250513          	addi	a0,a0,-910 # d90 <malloc+0x118>
 126:	29b000ef          	jal	bc0 <printf>
        printf("Safe sequence: ");
 12a:	00001517          	auipc	a0,0x1
 12e:	c8650513          	addi	a0,a0,-890 # db0 <malloc+0x138>
 132:	28f000ef          	jal	bc0 <printf>
        for (int i = 0; i < N; i++) {
 136:	f7040493          	addi	s1,s0,-144
 13a:	a821                	j	152 <is_safe+0x108>
                printf(" -> ");
 13c:	00001517          	auipc	a0,0x1
 140:	c8c50513          	addi	a0,a0,-884 # dc8 <malloc+0x150>
 144:	27d000ef          	jal	bc0 <printf>
        for (int i = 0; i < N; i++) {
 148:	0491                	addi	s1,s1,4
 14a:	f8440793          	addi	a5,s0,-124
 14e:	00f48d63          	beq	s1,a5,168 <is_safe+0x11e>
            printf("P%d", sequence[i]);
 152:	408c                	lw	a1,0(s1)
 154:	00001517          	auipc	a0,0x1
 158:	c6c50513          	addi	a0,a0,-916 # dc0 <malloc+0x148>
 15c:	265000ef          	jal	bc0 <printf>
            if (i != N - 1)
 160:	f8040793          	addi	a5,s0,-128
 164:	fc979ce3          	bne	a5,s1,13c <is_safe+0xf2>
        printf("\n");
 168:	00001517          	auipc	a0,0x1
 16c:	c6850513          	addi	a0,a0,-920 # dd0 <malloc+0x158>
 170:	251000ef          	jal	bc0 <printf>
    return 1;
 174:	4505                	li	a0,1
 176:	b769                	j	100 <is_safe+0xb6>

0000000000000178 <request_resources>:

int
request_resources(int process, int request[M])
{
 178:	7119                	addi	sp,sp,-128
 17a:	fc86                	sd	ra,120(sp)
 17c:	f8a2                	sd	s0,112(sp)
 17e:	f4a6                	sd	s1,104(sp)
 180:	f0ca                	sd	s2,96(sp)
 182:	ecce                	sd	s3,88(sp)
 184:	e8d2                	sd	s4,80(sp)
 186:	e4d6                	sd	s5,72(sp)
 188:	0100                	addi	s0,sp,128
 18a:	8a2a                	mv	s4,a0
 18c:	84ae                	mv	s1,a1
    int need[N][M];

    calculate_need(need);
 18e:	f8040913          	addi	s2,s0,-128
 192:	854a                	mv	a0,s2
 194:	e6dff0ef          	jal	0 <calculate_need>

    printf("\nRequest from P%d: [%d %d %d]\n",
 198:	4498                	lw	a4,8(s1)
 19a:	40d4                	lw	a3,4(s1)
 19c:	4090                	lw	a2,0(s1)
 19e:	85d2                	mv	a1,s4
 1a0:	00001517          	auipc	a0,0x1
 1a4:	c3850513          	addi	a0,a0,-968 # dd8 <malloc+0x160>
 1a8:	219000ef          	jal	bc0 <printf>
           process, request[0], request[1], request[2]);

    for (int j = 0; j < M; j++) {
 1ac:	89a6                	mv	s3,s1
 1ae:	001a1513          	slli	a0,s4,0x1
 1b2:	9552                	add	a0,a0,s4
 1b4:	050a                	slli	a0,a0,0x2
 1b6:	00a907b3          	add	a5,s2,a0
 1ba:	00002a17          	auipc	s4,0x2
 1be:	ec6a0a13          	addi	s4,s4,-314 # 2080 <available>
 1c2:	00c48a93          	addi	s5,s1,12
    printf("\nRequest from P%d: [%d %d %d]\n",
 1c6:	86d2                	mv	a3,s4
 1c8:	8726                	mv	a4,s1
        if (request[j] > need[process][j]) {
 1ca:	4310                	lw	a2,0(a4)
 1cc:	438c                	lw	a1,0(a5)
 1ce:	0ac5c063          	blt	a1,a2,26e <request_resources+0xf6>
            printf("Request denied - exceeds Need.\n");
            return 0;
        }

        if (request[j] > available[j]) {
 1d2:	428c                	lw	a1,0(a3)
 1d4:	0ac5c563          	blt	a1,a2,27e <request_resources+0x106>
    for (int j = 0; j < M; j++) {
 1d8:	0711                	addi	a4,a4,4
 1da:	0791                	addi	a5,a5,4
 1dc:	0691                	addi	a3,a3,4
 1de:	ff5716e3          	bne	a4,s5,1ca <request_resources+0x52>
 1e2:	00002917          	auipc	s2,0x2
 1e6:	e5e90913          	addi	s2,s2,-418 # 2040 <allocation>
 1ea:	992a                	add	s2,s2,a0
 1ec:	874a                	mv	a4,s2
 1ee:	85a6                	mv	a1,s1
 1f0:	00002797          	auipc	a5,0x2
 1f4:	e9078793          	addi	a5,a5,-368 # 2080 <available>
            return 0;
        }
    }

    for (int j = 0; j < M; j++) {
        available[j] -= request[j];
 1f8:	4394                	lw	a3,0(a5)
 1fa:	4190                	lw	a2,0(a1)
 1fc:	9e91                	subw	a3,a3,a2
 1fe:	c394                	sw	a3,0(a5)
        allocation[process][j] += request[j];
 200:	4310                	lw	a2,0(a4)
 202:	4194                	lw	a3,0(a1)
 204:	9eb1                	addw	a3,a3,a2
 206:	c314                	sw	a3,0(a4)
    for (int j = 0; j < M; j++) {
 208:	0791                	addi	a5,a5,4
 20a:	0591                	addi	a1,a1,4
 20c:	0711                	addi	a4,a4,4
 20e:	ff5595e3          	bne	a1,s5,1f8 <request_resources+0x80>
    }

    printf("Request temporarily granted. Checking safety...\n");
 212:	00001517          	auipc	a0,0x1
 216:	c3650513          	addi	a0,a0,-970 # e48 <malloc+0x1d0>
 21a:	1a7000ef          	jal	bc0 <printf>

    if (is_safe(0)) {
 21e:	4501                	li	a0,0
 220:	e2bff0ef          	jal	4a <is_safe>
 224:	84aa                	mv	s1,a0
 226:	e525                	bnez	a0,28e <request_resources+0x116>
        printf("Request GRANTED - system remains safe.\n");
        return 1;
    }

    for (int j = 0; j < M; j++) {
        available[j] += request[j];
 228:	000a2703          	lw	a4,0(s4)
 22c:	0009a783          	lw	a5,0(s3)
 230:	9fb9                	addw	a5,a5,a4
 232:	00fa2023          	sw	a5,0(s4)
        allocation[process][j] -= request[j];
 236:	00092783          	lw	a5,0(s2)
 23a:	0009a703          	lw	a4,0(s3)
 23e:	9f99                	subw	a5,a5,a4
 240:	00f92023          	sw	a5,0(s2)
    for (int j = 0; j < M; j++) {
 244:	0a11                	addi	s4,s4,4
 246:	0991                	addi	s3,s3,4
 248:	0911                	addi	s2,s2,4
 24a:	fd599fe3          	bne	s3,s5,228 <request_resources+0xb0>
    }

    printf("Request denied - would lead to unsafe state.\n");
 24e:	00001517          	auipc	a0,0x1
 252:	c5a50513          	addi	a0,a0,-934 # ea8 <malloc+0x230>
 256:	16b000ef          	jal	bc0 <printf>
    return 0;
}
 25a:	8526                	mv	a0,s1
 25c:	70e6                	ld	ra,120(sp)
 25e:	7446                	ld	s0,112(sp)
 260:	74a6                	ld	s1,104(sp)
 262:	7906                	ld	s2,96(sp)
 264:	69e6                	ld	s3,88(sp)
 266:	6a46                	ld	s4,80(sp)
 268:	6aa6                	ld	s5,72(sp)
 26a:	6109                	addi	sp,sp,128
 26c:	8082                	ret
            printf("Request denied - exceeds Need.\n");
 26e:	00001517          	auipc	a0,0x1
 272:	b8a50513          	addi	a0,a0,-1142 # df8 <malloc+0x180>
 276:	14b000ef          	jal	bc0 <printf>
            return 0;
 27a:	4481                	li	s1,0
 27c:	bff9                	j	25a <request_resources+0xe2>
            printf("Request denied - resources are not Available.\n");
 27e:	00001517          	auipc	a0,0x1
 282:	b9a50513          	addi	a0,a0,-1126 # e18 <malloc+0x1a0>
 286:	13b000ef          	jal	bc0 <printf>
            return 0;
 28a:	4481                	li	s1,0
 28c:	b7f9                	j	25a <request_resources+0xe2>
        printf("Request GRANTED - system remains safe.\n");
 28e:	00001517          	auipc	a0,0x1
 292:	bf250513          	addi	a0,a0,-1038 # e80 <malloc+0x208>
 296:	12b000ef          	jal	bc0 <printf>
        return 1;
 29a:	4485                	li	s1,1
 29c:	bf7d                	j	25a <request_resources+0xe2>

000000000000029e <print_state>:

void
print_state(void)
{
 29e:	7159                	addi	sp,sp,-112
 2a0:	f486                	sd	ra,104(sp)
 2a2:	f0a2                	sd	s0,96(sp)
 2a4:	eca6                	sd	s1,88(sp)
 2a6:	e8ca                	sd	s2,80(sp)
 2a8:	e4ce                	sd	s3,72(sp)
 2aa:	e0d2                	sd	s4,64(sp)
 2ac:	1880                	addi	s0,sp,112
    int need[N][M];

    calculate_need(need);
 2ae:	f9040513          	addi	a0,s0,-112
 2b2:	d4fff0ef          	jal	0 <calculate_need>

    printf("\nAllocation Matrix:\n");
 2b6:	00001517          	auipc	a0,0x1
 2ba:	c2250513          	addi	a0,a0,-990 # ed8 <malloc+0x260>
 2be:	103000ef          	jal	bc0 <printf>

    for (int i = 0; i < N; i++)
 2c2:	00002497          	auipc	s1,0x2
 2c6:	d7e48493          	addi	s1,s1,-642 # 2040 <allocation>
 2ca:	4901                	li	s2,0
        printf("P%d: %d %d %d\n",
 2cc:	00001a17          	auipc	s4,0x1
 2d0:	c24a0a13          	addi	s4,s4,-988 # ef0 <malloc+0x278>
    for (int i = 0; i < N; i++)
 2d4:	4995                	li	s3,5
        printf("P%d: %d %d %d\n",
 2d6:	4498                	lw	a4,8(s1)
 2d8:	40d4                	lw	a3,4(s1)
 2da:	4090                	lw	a2,0(s1)
 2dc:	85ca                	mv	a1,s2
 2de:	8552                	mv	a0,s4
 2e0:	0e1000ef          	jal	bc0 <printf>
    for (int i = 0; i < N; i++)
 2e4:	2905                	addiw	s2,s2,1
 2e6:	04b1                	addi	s1,s1,12
 2e8:	ff3917e3          	bne	s2,s3,2d6 <print_state+0x38>
               i, allocation[i][0], allocation[i][1], allocation[i][2]);

    printf("\nMax Matrix:\n");
 2ec:	00001517          	auipc	a0,0x1
 2f0:	c1450513          	addi	a0,a0,-1004 # f00 <malloc+0x288>
 2f4:	0cd000ef          	jal	bc0 <printf>

    for (int i = 0; i < N; i++)
 2f8:	00002497          	auipc	s1,0x2
 2fc:	d0848493          	addi	s1,s1,-760 # 2000 <max>
 300:	4901                	li	s2,0
        printf("P%d: %d %d %d\n",
 302:	00001a17          	auipc	s4,0x1
 306:	beea0a13          	addi	s4,s4,-1042 # ef0 <malloc+0x278>
    for (int i = 0; i < N; i++)
 30a:	4995                	li	s3,5
        printf("P%d: %d %d %d\n",
 30c:	4498                	lw	a4,8(s1)
 30e:	40d4                	lw	a3,4(s1)
 310:	4090                	lw	a2,0(s1)
 312:	85ca                	mv	a1,s2
 314:	8552                	mv	a0,s4
 316:	0ab000ef          	jal	bc0 <printf>
    for (int i = 0; i < N; i++)
 31a:	2905                	addiw	s2,s2,1
 31c:	04b1                	addi	s1,s1,12
 31e:	ff3917e3          	bne	s2,s3,30c <print_state+0x6e>
               i, max[i][0], max[i][1], max[i][2]);

    printf("\nNeed Matrix:\n");
 322:	00001517          	auipc	a0,0x1
 326:	bee50513          	addi	a0,a0,-1042 # f10 <malloc+0x298>
 32a:	097000ef          	jal	bc0 <printf>

    for (int i = 0; i < N; i++)
 32e:	f9040493          	addi	s1,s0,-112
 332:	4901                	li	s2,0
        printf("P%d: %d %d %d\n",
 334:	00001a17          	auipc	s4,0x1
 338:	bbca0a13          	addi	s4,s4,-1092 # ef0 <malloc+0x278>
    for (int i = 0; i < N; i++)
 33c:	4995                	li	s3,5
        printf("P%d: %d %d %d\n",
 33e:	4498                	lw	a4,8(s1)
 340:	40d4                	lw	a3,4(s1)
 342:	4090                	lw	a2,0(s1)
 344:	85ca                	mv	a1,s2
 346:	8552                	mv	a0,s4
 348:	079000ef          	jal	bc0 <printf>
    for (int i = 0; i < N; i++)
 34c:	2905                	addiw	s2,s2,1
 34e:	04b1                	addi	s1,s1,12
 350:	ff3917e3          	bne	s2,s3,33e <print_state+0xa0>
               i, need[i][0], need[i][1], need[i][2]);

    printf("\nAvailable: [%d %d %d]\n",
 354:	00002797          	auipc	a5,0x2
 358:	cac78793          	addi	a5,a5,-852 # 2000 <max>
 35c:	0887a683          	lw	a3,136(a5)
 360:	0847a603          	lw	a2,132(a5)
 364:	0807a583          	lw	a1,128(a5)
 368:	00001517          	auipc	a0,0x1
 36c:	bb850513          	addi	a0,a0,-1096 # f20 <malloc+0x2a8>
 370:	051000ef          	jal	bc0 <printf>
           available[0], available[1], available[2]);
}
 374:	70a6                	ld	ra,104(sp)
 376:	7406                	ld	s0,96(sp)
 378:	64e6                	ld	s1,88(sp)
 37a:	6946                	ld	s2,80(sp)
 37c:	69a6                	ld	s3,72(sp)
 37e:	6a06                	ld	s4,64(sp)
 380:	6165                	addi	sp,sp,112
 382:	8082                	ret

0000000000000384 <main>:

int
main(int argc, char *argv[])
{
 384:	7159                	addi	sp,sp,-112
 386:	f486                	sd	ra,104(sp)
 388:	f0a2                	sd	s0,96(sp)
 38a:	1880                	addi	s0,sp,112
    int safe_request[M] = {1, 0, 2};
 38c:	4785                	li	a5,1
 38e:	fef42023          	sw	a5,-32(s0)
 392:	fe042223          	sw	zero,-28(s0)
 396:	4789                	li	a5,2
 398:	fef42423          	sw	a5,-24(s0)
    int unsafe_request[M] = {3, 3, 0};
 39c:	478d                	li	a5,3
 39e:	fcf42823          	sw	a5,-48(s0)
 3a2:	fcf42a23          	sw	a5,-44(s0)
 3a6:	fc042c23          	sw	zero,-40(s0)

    printf("Banker's Algorithm Simulation\n");
 3aa:	00001517          	auipc	a0,0x1
 3ae:	b8e50513          	addi	a0,a0,-1138 # f38 <malloc+0x2c0>
 3b2:	00f000ef          	jal	bc0 <printf>
    printf("==============================\n");
 3b6:	00001517          	auipc	a0,0x1
 3ba:	ba250513          	addi	a0,a0,-1118 # f58 <malloc+0x2e0>
 3be:	003000ef          	jal	bc0 <printf>

    print_state();
 3c2:	eddff0ef          	jal	29e <print_state>

    printf("\n--- Initial Safety Check ---\n");
 3c6:	00001517          	auipc	a0,0x1
 3ca:	bb250513          	addi	a0,a0,-1102 # f78 <malloc+0x300>
 3ce:	7f2000ef          	jal	bc0 <printf>
    is_safe(1);
 3d2:	4505                	li	a0,1
 3d4:	c77ff0ef          	jal	4a <is_safe>

    printf("\n--- Scenario 1: Safe Request ---\n");
 3d8:	00001517          	auipc	a0,0x1
 3dc:	bc050513          	addi	a0,a0,-1088 # f98 <malloc+0x320>
 3e0:	7e0000ef          	jal	bc0 <printf>
request_resources(1, safe_request);
 3e4:	fe040593          	addi	a1,s0,-32
 3e8:	4505                	li	a0,1
 3ea:	d8fff0ef          	jal	178 <request_resources>

/* Reset the system to the original state for Scenario 2. */
int original_allocation[N][M] = {
 3ee:	00001797          	auipc	a5,0x1
 3f2:	c3a78793          	addi	a5,a5,-966 # 1028 <malloc+0x3b0>
 3f6:	0007b803          	ld	a6,0(a5)
 3fa:	6788                	ld	a0,8(a5)
 3fc:	6b8c                	ld	a1,16(a5)
 3fe:	6f90                	ld	a2,24(a5)
 400:	7394                	ld	a3,32(a5)
 402:	7798                	ld	a4,40(a5)
 404:	f9043823          	sd	a6,-112(s0)
 408:	f8a43c23          	sd	a0,-104(s0)
 40c:	fab43023          	sd	a1,-96(s0)
 410:	fac43423          	sd	a2,-88(s0)
 414:	fad43823          	sd	a3,-80(s0)
 418:	fae43c23          	sd	a4,-72(s0)
 41c:	7b98                	ld	a4,48(a5)
 41e:	fce43023          	sd	a4,-64(s0)
 422:	5f9c                	lw	a5,56(a5)
 424:	fcf42423          	sw	a5,-56(s0)
    {0, 0, 2}
};

int original_available[M] = {3, 3, 2};

for (int i = 0; i < N; i++)
 428:	f9040793          	addi	a5,s0,-112
 42c:	00002717          	auipc	a4,0x2
 430:	c1470713          	addi	a4,a4,-1004 # 2040 <allocation>
 434:	fcc40613          	addi	a2,s0,-52
    for (int j = 0; j < M; j++)
        allocation[i][j] = original_allocation[i][j];
 438:	4394                	lw	a3,0(a5)
 43a:	c314                	sw	a3,0(a4)
 43c:	43d4                	lw	a3,4(a5)
 43e:	c354                	sw	a3,4(a4)
 440:	4794                	lw	a3,8(a5)
 442:	c714                	sw	a3,8(a4)
for (int i = 0; i < N; i++)
 444:	07b1                	addi	a5,a5,12
 446:	0731                	addi	a4,a4,12
 448:	fec798e3          	bne	a5,a2,438 <main+0xb4>

for (int j = 0; j < M; j++)
    available[j] = original_available[j];
 44c:	00002797          	auipc	a5,0x2
 450:	bb478793          	addi	a5,a5,-1100 # 2000 <max>
 454:	470d                	li	a4,3
 456:	08e7a023          	sw	a4,128(a5)
 45a:	08e7a223          	sw	a4,132(a5)
 45e:	4709                	li	a4,2
 460:	08e7a423          	sw	a4,136(a5)

printf("\n--- Scenario 2: Unsafe Request ---\n");
 464:	00001517          	auipc	a0,0x1
 468:	b5c50513          	addi	a0,a0,-1188 # fc0 <malloc+0x348>
 46c:	754000ef          	jal	bc0 <printf>
request_resources(4, unsafe_request);
 470:	fd040593          	addi	a1,s0,-48
 474:	4511                	li	a0,4
 476:	d03ff0ef          	jal	178 <request_resources>

    printf("\nBanker's Algorithm test completed successfully.\n");
 47a:	00001517          	auipc	a0,0x1
 47e:	b6e50513          	addi	a0,a0,-1170 # fe8 <malloc+0x370>
 482:	73e000ef          	jal	bc0 <printf>

    exit(0);
 486:	4501                	li	a0,0
 488:	2ba000ef          	jal	742 <exit>

000000000000048c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 48c:	1141                	addi	sp,sp,-16
 48e:	e406                	sd	ra,8(sp)
 490:	e022                	sd	s0,0(sp)
 492:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 494:	ef1ff0ef          	jal	384 <main>
  exit(r);
 498:	2aa000ef          	jal	742 <exit>

000000000000049c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 49c:	1141                	addi	sp,sp,-16
 49e:	e406                	sd	ra,8(sp)
 4a0:	e022                	sd	s0,0(sp)
 4a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 4a4:	87aa                	mv	a5,a0
 4a6:	0585                	addi	a1,a1,1
 4a8:	0785                	addi	a5,a5,1
 4aa:	fff5c703          	lbu	a4,-1(a1)
 4ae:	fee78fa3          	sb	a4,-1(a5)
 4b2:	fb75                	bnez	a4,4a6 <strcpy+0xa>
    ;
  return os;
}
 4b4:	60a2                	ld	ra,8(sp)
 4b6:	6402                	ld	s0,0(sp)
 4b8:	0141                	addi	sp,sp,16
 4ba:	8082                	ret

00000000000004bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4bc:	1141                	addi	sp,sp,-16
 4be:	e406                	sd	ra,8(sp)
 4c0:	e022                	sd	s0,0(sp)
 4c2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 4c4:	00054783          	lbu	a5,0(a0)
 4c8:	cb91                	beqz	a5,4dc <strcmp+0x20>
 4ca:	0005c703          	lbu	a4,0(a1)
 4ce:	00f71763          	bne	a4,a5,4dc <strcmp+0x20>
    p++, q++;
 4d2:	0505                	addi	a0,a0,1
 4d4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 4d6:	00054783          	lbu	a5,0(a0)
 4da:	fbe5                	bnez	a5,4ca <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 4dc:	0005c503          	lbu	a0,0(a1)
}
 4e0:	40a7853b          	subw	a0,a5,a0
 4e4:	60a2                	ld	ra,8(sp)
 4e6:	6402                	ld	s0,0(sp)
 4e8:	0141                	addi	sp,sp,16
 4ea:	8082                	ret

00000000000004ec <strlen>:

uint
strlen(const char *s)
{
 4ec:	1141                	addi	sp,sp,-16
 4ee:	e406                	sd	ra,8(sp)
 4f0:	e022                	sd	s0,0(sp)
 4f2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 4f4:	00054783          	lbu	a5,0(a0)
 4f8:	cf91                	beqz	a5,514 <strlen+0x28>
 4fa:	00150793          	addi	a5,a0,1
 4fe:	86be                	mv	a3,a5
 500:	0785                	addi	a5,a5,1
 502:	fff7c703          	lbu	a4,-1(a5)
 506:	ff65                	bnez	a4,4fe <strlen+0x12>
 508:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 50c:	60a2                	ld	ra,8(sp)
 50e:	6402                	ld	s0,0(sp)
 510:	0141                	addi	sp,sp,16
 512:	8082                	ret
  for (n = 0; s[n]; n++)
 514:	4501                	li	a0,0
 516:	bfdd                	j	50c <strlen+0x20>

0000000000000518 <memset>:

void *
memset(void *dst, int c, uint n)
{
 518:	1141                	addi	sp,sp,-16
 51a:	e406                	sd	ra,8(sp)
 51c:	e022                	sd	s0,0(sp)
 51e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 520:	ca19                	beqz	a2,536 <memset+0x1e>
 522:	87aa                	mv	a5,a0
 524:	1602                	slli	a2,a2,0x20
 526:	9201                	srli	a2,a2,0x20
 528:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 52c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 530:	0785                	addi	a5,a5,1
 532:	fee79de3          	bne	a5,a4,52c <memset+0x14>
  }
  return dst;
}
 536:	60a2                	ld	ra,8(sp)
 538:	6402                	ld	s0,0(sp)
 53a:	0141                	addi	sp,sp,16
 53c:	8082                	ret

000000000000053e <strchr>:

char *
strchr(const char *s, char c)
{
 53e:	1141                	addi	sp,sp,-16
 540:	e406                	sd	ra,8(sp)
 542:	e022                	sd	s0,0(sp)
 544:	0800                	addi	s0,sp,16
  for (; *s; s++)
 546:	00054783          	lbu	a5,0(a0)
 54a:	cf81                	beqz	a5,562 <strchr+0x24>
    if (*s == c)
 54c:	00f58763          	beq	a1,a5,55a <strchr+0x1c>
  for (; *s; s++)
 550:	0505                	addi	a0,a0,1
 552:	00054783          	lbu	a5,0(a0)
 556:	fbfd                	bnez	a5,54c <strchr+0xe>
      return (char *)s;
  return 0;
 558:	4501                	li	a0,0
}
 55a:	60a2                	ld	ra,8(sp)
 55c:	6402                	ld	s0,0(sp)
 55e:	0141                	addi	sp,sp,16
 560:	8082                	ret
  return 0;
 562:	4501                	li	a0,0
 564:	bfdd                	j	55a <strchr+0x1c>

0000000000000566 <gets>:

char *
gets(char *buf, int max)
{
 566:	711d                	addi	sp,sp,-96
 568:	ec86                	sd	ra,88(sp)
 56a:	e8a2                	sd	s0,80(sp)
 56c:	e4a6                	sd	s1,72(sp)
 56e:	e0ca                	sd	s2,64(sp)
 570:	fc4e                	sd	s3,56(sp)
 572:	f852                	sd	s4,48(sp)
 574:	f456                	sd	s5,40(sp)
 576:	f05a                	sd	s6,32(sp)
 578:	ec5e                	sd	s7,24(sp)
 57a:	e862                	sd	s8,16(sp)
 57c:	1080                	addi	s0,sp,96
 57e:	8baa                	mv	s7,a0
 580:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 582:	892a                	mv	s2,a0
 584:	4481                	li	s1,0
    cc = read(0, &c, 1);
 586:	faf40b13          	addi	s6,s0,-81
 58a:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 58c:	8c26                	mv	s8,s1
 58e:	0014899b          	addiw	s3,s1,1
 592:	84ce                	mv	s1,s3
 594:	0349d463          	bge	s3,s4,5bc <gets+0x56>
    cc = read(0, &c, 1);
 598:	8656                	mv	a2,s5
 59a:	85da                	mv	a1,s6
 59c:	4501                	li	a0,0
 59e:	1c4000ef          	jal	762 <read>
    if (cc < 1)
 5a2:	00a05d63          	blez	a0,5bc <gets+0x56>
      break;
    buf[i++] = c;
 5a6:	faf44783          	lbu	a5,-81(s0)
 5aa:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 5ae:	0905                	addi	s2,s2,1
 5b0:	ff678713          	addi	a4,a5,-10
 5b4:	c319                	beqz	a4,5ba <gets+0x54>
 5b6:	17cd                	addi	a5,a5,-13
 5b8:	fbf1                	bnez	a5,58c <gets+0x26>
    buf[i++] = c;
 5ba:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 5bc:	9c5e                	add	s8,s8,s7
 5be:	000c0023          	sb	zero,0(s8)
  return buf;
}
 5c2:	855e                	mv	a0,s7
 5c4:	60e6                	ld	ra,88(sp)
 5c6:	6446                	ld	s0,80(sp)
 5c8:	64a6                	ld	s1,72(sp)
 5ca:	6906                	ld	s2,64(sp)
 5cc:	79e2                	ld	s3,56(sp)
 5ce:	7a42                	ld	s4,48(sp)
 5d0:	7aa2                	ld	s5,40(sp)
 5d2:	7b02                	ld	s6,32(sp)
 5d4:	6be2                	ld	s7,24(sp)
 5d6:	6c42                	ld	s8,16(sp)
 5d8:	6125                	addi	sp,sp,96
 5da:	8082                	ret

00000000000005dc <stat>:

int
stat(const char *n, struct stat *st)
{
 5dc:	1101                	addi	sp,sp,-32
 5de:	ec06                	sd	ra,24(sp)
 5e0:	e822                	sd	s0,16(sp)
 5e2:	e04a                	sd	s2,0(sp)
 5e4:	1000                	addi	s0,sp,32
 5e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5e8:	4581                	li	a1,0
 5ea:	1c0000ef          	jal	7aa <open>
  if (fd < 0)
 5ee:	02054263          	bltz	a0,612 <stat+0x36>
 5f2:	e426                	sd	s1,8(sp)
 5f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5f6:	85ca                	mv	a1,s2
 5f8:	1ca000ef          	jal	7c2 <fstat>
 5fc:	892a                	mv	s2,a0
  close(fd);
 5fe:	8526                	mv	a0,s1
 600:	192000ef          	jal	792 <close>
  return r;
 604:	64a2                	ld	s1,8(sp)
}
 606:	854a                	mv	a0,s2
 608:	60e2                	ld	ra,24(sp)
 60a:	6442                	ld	s0,16(sp)
 60c:	6902                	ld	s2,0(sp)
 60e:	6105                	addi	sp,sp,32
 610:	8082                	ret
    return -1;
 612:	57fd                	li	a5,-1
 614:	893e                	mv	s2,a5
 616:	bfc5                	j	606 <stat+0x2a>

0000000000000618 <atoi>:

int
atoi(const char *s)
{
 618:	1141                	addi	sp,sp,-16
 61a:	e406                	sd	ra,8(sp)
 61c:	e022                	sd	s0,0(sp)
 61e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 620:	00054683          	lbu	a3,0(a0)
 624:	fd06879b          	addiw	a5,a3,-48
 628:	0ff7f793          	zext.b	a5,a5
 62c:	4625                	li	a2,9
 62e:	02f66963          	bltu	a2,a5,660 <atoi+0x48>
 632:	872a                	mv	a4,a0
  n = 0;
 634:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 636:	0705                	addi	a4,a4,1
 638:	0025179b          	slliw	a5,a0,0x2
 63c:	9fa9                	addw	a5,a5,a0
 63e:	0017979b          	slliw	a5,a5,0x1
 642:	9fb5                	addw	a5,a5,a3
 644:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 648:	00074683          	lbu	a3,0(a4)
 64c:	fd06879b          	addiw	a5,a3,-48
 650:	0ff7f793          	zext.b	a5,a5
 654:	fef671e3          	bgeu	a2,a5,636 <atoi+0x1e>
  return n;
}
 658:	60a2                	ld	ra,8(sp)
 65a:	6402                	ld	s0,0(sp)
 65c:	0141                	addi	sp,sp,16
 65e:	8082                	ret
  n = 0;
 660:	4501                	li	a0,0
 662:	bfdd                	j	658 <atoi+0x40>

0000000000000664 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 664:	1141                	addi	sp,sp,-16
 666:	e406                	sd	ra,8(sp)
 668:	e022                	sd	s0,0(sp)
 66a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 66c:	02b57563          	bgeu	a0,a1,696 <memmove+0x32>
    while (n-- > 0)
 670:	00c05f63          	blez	a2,68e <memmove+0x2a>
 674:	1602                	slli	a2,a2,0x20
 676:	9201                	srli	a2,a2,0x20
 678:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 67c:	872a                	mv	a4,a0
      *dst++ = *src++;
 67e:	0585                	addi	a1,a1,1
 680:	0705                	addi	a4,a4,1
 682:	fff5c683          	lbu	a3,-1(a1)
 686:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 68a:	fee79ae3          	bne	a5,a4,67e <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 68e:	60a2                	ld	ra,8(sp)
 690:	6402                	ld	s0,0(sp)
 692:	0141                	addi	sp,sp,16
 694:	8082                	ret
    while (n-- > 0)
 696:	fec05ce3          	blez	a2,68e <memmove+0x2a>
    dst += n;
 69a:	00c50733          	add	a4,a0,a2
    src += n;
 69e:	95b2                	add	a1,a1,a2
 6a0:	fff6079b          	addiw	a5,a2,-1
 6a4:	1782                	slli	a5,a5,0x20
 6a6:	9381                	srli	a5,a5,0x20
 6a8:	fff7c793          	not	a5,a5
 6ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6ae:	15fd                	addi	a1,a1,-1
 6b0:	177d                	addi	a4,a4,-1
 6b2:	0005c683          	lbu	a3,0(a1)
 6b6:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 6ba:	fef71ae3          	bne	a4,a5,6ae <memmove+0x4a>
 6be:	bfc1                	j	68e <memmove+0x2a>

00000000000006c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6c0:	1141                	addi	sp,sp,-16
 6c2:	e406                	sd	ra,8(sp)
 6c4:	e022                	sd	s0,0(sp)
 6c6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6c8:	c61d                	beqz	a2,6f6 <memcmp+0x36>
 6ca:	1602                	slli	a2,a2,0x20
 6cc:	9201                	srli	a2,a2,0x20
 6ce:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 6d2:	00054783          	lbu	a5,0(a0)
 6d6:	0005c703          	lbu	a4,0(a1)
 6da:	00e79863          	bne	a5,a4,6ea <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 6de:	0505                	addi	a0,a0,1
    p2++;
 6e0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6e2:	fed518e3          	bne	a0,a3,6d2 <memcmp+0x12>
  }
  return 0;
 6e6:	4501                	li	a0,0
 6e8:	a019                	j	6ee <memcmp+0x2e>
      return *p1 - *p2;
 6ea:	40e7853b          	subw	a0,a5,a4
}
 6ee:	60a2                	ld	ra,8(sp)
 6f0:	6402                	ld	s0,0(sp)
 6f2:	0141                	addi	sp,sp,16
 6f4:	8082                	ret
  return 0;
 6f6:	4501                	li	a0,0
 6f8:	bfdd                	j	6ee <memcmp+0x2e>

00000000000006fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6fa:	1141                	addi	sp,sp,-16
 6fc:	e406                	sd	ra,8(sp)
 6fe:	e022                	sd	s0,0(sp)
 700:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 702:	f63ff0ef          	jal	664 <memmove>
}
 706:	60a2                	ld	ra,8(sp)
 708:	6402                	ld	s0,0(sp)
 70a:	0141                	addi	sp,sp,16
 70c:	8082                	ret

000000000000070e <sbrk>:

char *
sbrk(int n)
{
 70e:	1141                	addi	sp,sp,-16
 710:	e406                	sd	ra,8(sp)
 712:	e022                	sd	s0,0(sp)
 714:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 716:	4585                	li	a1,1
 718:	0da000ef          	jal	7f2 <sys_sbrk>
}
 71c:	60a2                	ld	ra,8(sp)
 71e:	6402                	ld	s0,0(sp)
 720:	0141                	addi	sp,sp,16
 722:	8082                	ret

0000000000000724 <sbrklazy>:

char *
sbrklazy(int n)
{
 724:	1141                	addi	sp,sp,-16
 726:	e406                	sd	ra,8(sp)
 728:	e022                	sd	s0,0(sp)
 72a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 72c:	4589                	li	a1,2
 72e:	0c4000ef          	jal	7f2 <sys_sbrk>
}
 732:	60a2                	ld	ra,8(sp)
 734:	6402                	ld	s0,0(sp)
 736:	0141                	addi	sp,sp,16
 738:	8082                	ret

000000000000073a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 73a:	4885                	li	a7,1
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <exit>:
.global exit
exit:
 li a7, SYS_exit
 742:	4889                	li	a7,2
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <wait>:
.global wait
wait:
 li a7, SYS_wait
 74a:	488d                	li	a7,3
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 752:	48b5                	li	a7,13
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 75a:	4891                	li	a7,4
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <read>:
.global read
read:
 li a7, SYS_read
 762:	4895                	li	a7,5
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <write>:
.global write
write:
 li a7, SYS_write
 76a:	48c1                	li	a7,16
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <sem_create>:
.global sem_create
sem_create:
 li a7, SYS_sem_create
 772:	48e1                	li	a7,24
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <sem_wait>:
.global sem_wait
sem_wait:
 li a7, SYS_sem_wait
 77a:	48e5                	li	a7,25
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <sem_signal>:
.global sem_signal
sem_signal:
 li a7, SYS_sem_signal
 782:	48e9                	li	a7,26
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <sem_free>:
.global sem_free
sem_free:
 li a7, SYS_sem_free
 78a:	48ed                	li	a7,27
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <close>:
.global close
close:
 li a7, SYS_close
 792:	48d5                	li	a7,21
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <kill>:
.global kill
kill:
 li a7, SYS_kill
 79a:	4899                	li	a7,6
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7a2:	489d                	li	a7,7
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <open>:
.global open
open:
 li a7, SYS_open
 7aa:	48bd                	li	a7,15
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7b2:	48c5                	li	a7,17
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7ba:	48c9                	li	a7,18
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7c2:	48a1                	li	a7,8
 ecall
 7c4:	00000073          	ecall
 ret
 7c8:	8082                	ret

00000000000007ca <link>:
.global link
link:
 li a7, SYS_link
 7ca:	48cd                	li	a7,19
 ecall
 7cc:	00000073          	ecall
 ret
 7d0:	8082                	ret

00000000000007d2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7d2:	48d1                	li	a7,20
 ecall
 7d4:	00000073          	ecall
 ret
 7d8:	8082                	ret

00000000000007da <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7da:	48a5                	li	a7,9
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7e2:	48a9                	li	a7,10
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7ea:	48ad                	li	a7,11
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	8082                	ret

00000000000007f2 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 7f2:	48b1                	li	a7,12
 ecall
 7f4:	00000073          	ecall
 ret
 7f8:	8082                	ret

00000000000007fa <pause>:
.global pause
pause:
 li a7, SYS_pause
 7fa:	48b5                	li	a7,13
 ecall
 7fc:	00000073          	ecall
 ret
 800:	8082                	ret

0000000000000802 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 802:	48b9                	li	a7,14
 ecall
 804:	00000073          	ecall
 ret
 808:	8082                	ret

000000000000080a <sync>:
.global sync
sync:
 li a7, SYS_sync
 80a:	48d9                	li	a7,22
 ecall
 80c:	00000073          	ecall
 ret
 810:	8082                	ret

0000000000000812 <shm_get>:
.global shm_get
shm_get:
 li a7, SYS_shm_get
 812:	48dd                	li	a7,23
 ecall
 814:	00000073          	ecall
 ret
 818:	8082                	ret

000000000000081a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 81a:	1101                	addi	sp,sp,-32
 81c:	ec06                	sd	ra,24(sp)
 81e:	e822                	sd	s0,16(sp)
 820:	1000                	addi	s0,sp,32
 822:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 826:	4605                	li	a2,1
 828:	fef40593          	addi	a1,s0,-17
 82c:	f3fff0ef          	jal	76a <write>
}
 830:	60e2                	ld	ra,24(sp)
 832:	6442                	ld	s0,16(sp)
 834:	6105                	addi	sp,sp,32
 836:	8082                	ret

0000000000000838 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 838:	715d                	addi	sp,sp,-80
 83a:	e486                	sd	ra,72(sp)
 83c:	e0a2                	sd	s0,64(sp)
 83e:	f84a                	sd	s2,48(sp)
 840:	f44e                	sd	s3,40(sp)
 842:	0880                	addi	s0,sp,80
 844:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 846:	c6d1                	beqz	a3,8d2 <printint+0x9a>
 848:	0805d563          	bgez	a1,8d2 <printint+0x9a>
    neg = 1;
    x = -xx;
 84c:	40b005b3          	neg	a1,a1
    neg = 1;
 850:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 852:	fb840993          	addi	s3,s0,-72
  neg = 0;
 856:	86ce                	mv	a3,s3
  i = 0;
 858:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 85a:	00001817          	auipc	a6,0x1
 85e:	80e80813          	addi	a6,a6,-2034 # 1068 <digits>
 862:	88ba                	mv	a7,a4
 864:	0017051b          	addiw	a0,a4,1
 868:	872a                	mv	a4,a0
 86a:	02c5f7b3          	remu	a5,a1,a2
 86e:	97c2                	add	a5,a5,a6
 870:	0007c783          	lbu	a5,0(a5)
 874:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 878:	87ae                	mv	a5,a1
 87a:	02c5d5b3          	divu	a1,a1,a2
 87e:	0685                	addi	a3,a3,1
 880:	fec7f1e3          	bgeu	a5,a2,862 <printint+0x2a>
  if (neg)
 884:	00030c63          	beqz	t1,89c <printint+0x64>
    buf[i++] = '-';
 888:	fd050793          	addi	a5,a0,-48
 88c:	00878533          	add	a0,a5,s0
 890:	02d00793          	li	a5,45
 894:	fef50423          	sb	a5,-24(a0)
 898:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 89c:	02e05563          	blez	a4,8c6 <printint+0x8e>
 8a0:	fc26                	sd	s1,56(sp)
 8a2:	377d                	addiw	a4,a4,-1
 8a4:	00e984b3          	add	s1,s3,a4
 8a8:	19fd                	addi	s3,s3,-1
 8aa:	99ba                	add	s3,s3,a4
 8ac:	1702                	slli	a4,a4,0x20
 8ae:	9301                	srli	a4,a4,0x20
 8b0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 8b4:	0004c583          	lbu	a1,0(s1)
 8b8:	854a                	mv	a0,s2
 8ba:	f61ff0ef          	jal	81a <putc>
  while (--i >= 0)
 8be:	14fd                	addi	s1,s1,-1
 8c0:	ff349ae3          	bne	s1,s3,8b4 <printint+0x7c>
 8c4:	74e2                	ld	s1,56(sp)
}
 8c6:	60a6                	ld	ra,72(sp)
 8c8:	6406                	ld	s0,64(sp)
 8ca:	7942                	ld	s2,48(sp)
 8cc:	79a2                	ld	s3,40(sp)
 8ce:	6161                	addi	sp,sp,80
 8d0:	8082                	ret
  neg = 0;
 8d2:	4301                	li	t1,0
 8d4:	bfbd                	j	852 <printint+0x1a>

00000000000008d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8d6:	711d                	addi	sp,sp,-96
 8d8:	ec86                	sd	ra,88(sp)
 8da:	e8a2                	sd	s0,80(sp)
 8dc:	e4a6                	sd	s1,72(sp)
 8de:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 8e0:	0005c483          	lbu	s1,0(a1)
 8e4:	22048363          	beqz	s1,b0a <vprintf+0x234>
 8e8:	e0ca                	sd	s2,64(sp)
 8ea:	fc4e                	sd	s3,56(sp)
 8ec:	f852                	sd	s4,48(sp)
 8ee:	f456                	sd	s5,40(sp)
 8f0:	f05a                	sd	s6,32(sp)
 8f2:	ec5e                	sd	s7,24(sp)
 8f4:	e862                	sd	s8,16(sp)
 8f6:	8b2a                	mv	s6,a0
 8f8:	8a2e                	mv	s4,a1
 8fa:	8bb2                	mv	s7,a2
  state = 0;
 8fc:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 8fe:	4901                	li	s2,0
 900:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 902:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 906:	06400c13          	li	s8,100
 90a:	a00d                	j	92c <vprintf+0x56>
        putc(fd, c0);
 90c:	85a6                	mv	a1,s1
 90e:	855a                	mv	a0,s6
 910:	f0bff0ef          	jal	81a <putc>
 914:	a019                	j	91a <vprintf+0x44>
    } else if (state == '%') {
 916:	03598363          	beq	s3,s5,93c <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 91a:	0019079b          	addiw	a5,s2,1
 91e:	893e                	mv	s2,a5
 920:	873e                	mv	a4,a5
 922:	97d2                	add	a5,a5,s4
 924:	0007c483          	lbu	s1,0(a5)
 928:	1c048a63          	beqz	s1,afc <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 92c:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 930:	fe0993e3          	bnez	s3,916 <vprintf+0x40>
      if (c0 == '%') {
 934:	fd579ce3          	bne	a5,s5,90c <vprintf+0x36>
        state = '%';
 938:	89be                	mv	s3,a5
 93a:	b7c5                	j	91a <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 93c:	00ea06b3          	add	a3,s4,a4
 940:	0016c603          	lbu	a2,1(a3)
      if (c1)
 944:	1c060863          	beqz	a2,b14 <vprintf+0x23e>
      if (c0 == 'd') {
 948:	03878763          	beq	a5,s8,976 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 94c:	f9478693          	addi	a3,a5,-108
 950:	0016b693          	seqz	a3,a3
 954:	f9c60593          	addi	a1,a2,-100
 958:	e99d                	bnez	a1,98e <vprintf+0xb8>
 95a:	ca95                	beqz	a3,98e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 95c:	008b8493          	addi	s1,s7,8
 960:	4685                	li	a3,1
 962:	4629                	li	a2,10
 964:	000bb583          	ld	a1,0(s7)
 968:	855a                	mv	a0,s6
 96a:	ecfff0ef          	jal	838 <printint>
        i += 1;
 96e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 970:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 972:	4981                	li	s3,0
 974:	b75d                	j	91a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 976:	008b8493          	addi	s1,s7,8
 97a:	4685                	li	a3,1
 97c:	4629                	li	a2,10
 97e:	000ba583          	lw	a1,0(s7)
 982:	855a                	mv	a0,s6
 984:	eb5ff0ef          	jal	838 <printint>
 988:	8ba6                	mv	s7,s1
      state = 0;
 98a:	4981                	li	s3,0
 98c:	b779                	j	91a <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 98e:	9752                	add	a4,a4,s4
 990:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 994:	f9460713          	addi	a4,a2,-108
 998:	00173713          	seqz	a4,a4
 99c:	8f75                	and	a4,a4,a3
 99e:	f9c58513          	addi	a0,a1,-100
 9a2:	18051363          	bnez	a0,b28 <vprintf+0x252>
 9a6:	18070163          	beqz	a4,b28 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9aa:	008b8493          	addi	s1,s7,8
 9ae:	4685                	li	a3,1
 9b0:	4629                	li	a2,10
 9b2:	000bb583          	ld	a1,0(s7)
 9b6:	855a                	mv	a0,s6
 9b8:	e81ff0ef          	jal	838 <printint>
        i += 2;
 9bc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 9be:	8ba6                	mv	s7,s1
      state = 0;
 9c0:	4981                	li	s3,0
        i += 2;
 9c2:	bfa1                	j	91a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 9c4:	008b8493          	addi	s1,s7,8
 9c8:	4681                	li	a3,0
 9ca:	4629                	li	a2,10
 9cc:	000be583          	lwu	a1,0(s7)
 9d0:	855a                	mv	a0,s6
 9d2:	e67ff0ef          	jal	838 <printint>
 9d6:	8ba6                	mv	s7,s1
      state = 0;
 9d8:	4981                	li	s3,0
 9da:	b781                	j	91a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9dc:	008b8493          	addi	s1,s7,8
 9e0:	4681                	li	a3,0
 9e2:	4629                	li	a2,10
 9e4:	000bb583          	ld	a1,0(s7)
 9e8:	855a                	mv	a0,s6
 9ea:	e4fff0ef          	jal	838 <printint>
        i += 1;
 9ee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 9f0:	8ba6                	mv	s7,s1
      state = 0;
 9f2:	4981                	li	s3,0
 9f4:	b71d                	j	91a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9f6:	008b8493          	addi	s1,s7,8
 9fa:	4681                	li	a3,0
 9fc:	4629                	li	a2,10
 9fe:	000bb583          	ld	a1,0(s7)
 a02:	855a                	mv	a0,s6
 a04:	e35ff0ef          	jal	838 <printint>
        i += 2;
 a08:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a0a:	8ba6                	mv	s7,s1
      state = 0;
 a0c:	4981                	li	s3,0
        i += 2;
 a0e:	b731                	j	91a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 a10:	008b8493          	addi	s1,s7,8
 a14:	4681                	li	a3,0
 a16:	4641                	li	a2,16
 a18:	000be583          	lwu	a1,0(s7)
 a1c:	855a                	mv	a0,s6
 a1e:	e1bff0ef          	jal	838 <printint>
 a22:	8ba6                	mv	s7,s1
      state = 0;
 a24:	4981                	li	s3,0
 a26:	bdd5                	j	91a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a28:	008b8493          	addi	s1,s7,8
 a2c:	4681                	li	a3,0
 a2e:	4641                	li	a2,16
 a30:	000bb583          	ld	a1,0(s7)
 a34:	855a                	mv	a0,s6
 a36:	e03ff0ef          	jal	838 <printint>
        i += 1;
 a3a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a3c:	8ba6                	mv	s7,s1
      state = 0;
 a3e:	4981                	li	s3,0
 a40:	bde9                	j	91a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a42:	008b8493          	addi	s1,s7,8
 a46:	4681                	li	a3,0
 a48:	4641                	li	a2,16
 a4a:	000bb583          	ld	a1,0(s7)
 a4e:	855a                	mv	a0,s6
 a50:	de9ff0ef          	jal	838 <printint>
        i += 2;
 a54:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a56:	8ba6                	mv	s7,s1
      state = 0;
 a58:	4981                	li	s3,0
        i += 2;
 a5a:	b5c1                	j	91a <vprintf+0x44>
 a5c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 a5e:	008b8793          	addi	a5,s7,8
 a62:	8cbe                	mv	s9,a5
 a64:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a68:	03000593          	li	a1,48
 a6c:	855a                	mv	a0,s6
 a6e:	dadff0ef          	jal	81a <putc>
  putc(fd, 'x');
 a72:	07800593          	li	a1,120
 a76:	855a                	mv	a0,s6
 a78:	da3ff0ef          	jal	81a <putc>
 a7c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a7e:	00000b97          	auipc	s7,0x0
 a82:	5eab8b93          	addi	s7,s7,1514 # 1068 <digits>
 a86:	03c9d793          	srli	a5,s3,0x3c
 a8a:	97de                	add	a5,a5,s7
 a8c:	0007c583          	lbu	a1,0(a5)
 a90:	855a                	mv	a0,s6
 a92:	d89ff0ef          	jal	81a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a96:	0992                	slli	s3,s3,0x4
 a98:	34fd                	addiw	s1,s1,-1
 a9a:	f4f5                	bnez	s1,a86 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 a9c:	8be6                	mv	s7,s9
      state = 0;
 a9e:	4981                	li	s3,0
 aa0:	6ca2                	ld	s9,8(sp)
 aa2:	bda5                	j	91a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 aa4:	008b8493          	addi	s1,s7,8
 aa8:	000bc583          	lbu	a1,0(s7)
 aac:	855a                	mv	a0,s6
 aae:	d6dff0ef          	jal	81a <putc>
 ab2:	8ba6                	mv	s7,s1
      state = 0;
 ab4:	4981                	li	s3,0
 ab6:	b595                	j	91a <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 ab8:	008b8993          	addi	s3,s7,8
 abc:	000bb483          	ld	s1,0(s7)
 ac0:	cc91                	beqz	s1,adc <vprintf+0x206>
        for (; *s; s++)
 ac2:	0004c583          	lbu	a1,0(s1)
 ac6:	c985                	beqz	a1,af6 <vprintf+0x220>
          putc(fd, *s);
 ac8:	855a                	mv	a0,s6
 aca:	d51ff0ef          	jal	81a <putc>
        for (; *s; s++)
 ace:	0485                	addi	s1,s1,1
 ad0:	0004c583          	lbu	a1,0(s1)
 ad4:	f9f5                	bnez	a1,ac8 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 ad6:	8bce                	mv	s7,s3
      state = 0;
 ad8:	4981                	li	s3,0
 ada:	b581                	j	91a <vprintf+0x44>
          s = "(null)";
 adc:	00000497          	auipc	s1,0x0
 ae0:	54448493          	addi	s1,s1,1348 # 1020 <malloc+0x3a8>
        for (; *s; s++)
 ae4:	02800593          	li	a1,40
 ae8:	b7c5                	j	ac8 <vprintf+0x1f2>
        putc(fd, '%');
 aea:	85be                	mv	a1,a5
 aec:	855a                	mv	a0,s6
 aee:	d2dff0ef          	jal	81a <putc>
      state = 0;
 af2:	4981                	li	s3,0
 af4:	b51d                	j	91a <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 af6:	8bce                	mv	s7,s3
      state = 0;
 af8:	4981                	li	s3,0
 afa:	b505                	j	91a <vprintf+0x44>
 afc:	6906                	ld	s2,64(sp)
 afe:	79e2                	ld	s3,56(sp)
 b00:	7a42                	ld	s4,48(sp)
 b02:	7aa2                	ld	s5,40(sp)
 b04:	7b02                	ld	s6,32(sp)
 b06:	6be2                	ld	s7,24(sp)
 b08:	6c42                	ld	s8,16(sp)
    }
  }
}
 b0a:	60e6                	ld	ra,88(sp)
 b0c:	6446                	ld	s0,80(sp)
 b0e:	64a6                	ld	s1,72(sp)
 b10:	6125                	addi	sp,sp,96
 b12:	8082                	ret
      if (c0 == 'd') {
 b14:	06400713          	li	a4,100
 b18:	e4e78fe3          	beq	a5,a4,976 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 b1c:	f9478693          	addi	a3,a5,-108
 b20:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 b24:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 b26:	4701                	li	a4,0
      } else if (c0 == 'u') {
 b28:	07500513          	li	a0,117
 b2c:	e8a78ce3          	beq	a5,a0,9c4 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 b30:	f8b60513          	addi	a0,a2,-117
 b34:	e119                	bnez	a0,b3a <vprintf+0x264>
 b36:	ea0693e3          	bnez	a3,9dc <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 b3a:	f8b58513          	addi	a0,a1,-117
 b3e:	e119                	bnez	a0,b44 <vprintf+0x26e>
 b40:	ea071be3          	bnez	a4,9f6 <vprintf+0x120>
      } else if (c0 == 'x') {
 b44:	07800513          	li	a0,120
 b48:	eca784e3          	beq	a5,a0,a10 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 b4c:	f8860613          	addi	a2,a2,-120
 b50:	e219                	bnez	a2,b56 <vprintf+0x280>
 b52:	ec069be3          	bnez	a3,a28 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 b56:	f8858593          	addi	a1,a1,-120
 b5a:	e199                	bnez	a1,b60 <vprintf+0x28a>
 b5c:	ee0713e3          	bnez	a4,a42 <vprintf+0x16c>
      } else if (c0 == 'p') {
 b60:	07000713          	li	a4,112
 b64:	eee78ce3          	beq	a5,a4,a5c <vprintf+0x186>
      } else if (c0 == 'c') {
 b68:	06300713          	li	a4,99
 b6c:	f2e78ce3          	beq	a5,a4,aa4 <vprintf+0x1ce>
      } else if (c0 == 's') {
 b70:	07300713          	li	a4,115
 b74:	f4e782e3          	beq	a5,a4,ab8 <vprintf+0x1e2>
      } else if (c0 == '%') {
 b78:	02500713          	li	a4,37
 b7c:	f6e787e3          	beq	a5,a4,aea <vprintf+0x214>
        putc(fd, '%');
 b80:	02500593          	li	a1,37
 b84:	855a                	mv	a0,s6
 b86:	c95ff0ef          	jal	81a <putc>
        putc(fd, c0);
 b8a:	85a6                	mv	a1,s1
 b8c:	855a                	mv	a0,s6
 b8e:	c8dff0ef          	jal	81a <putc>
      state = 0;
 b92:	4981                	li	s3,0
 b94:	b359                	j	91a <vprintf+0x44>

0000000000000b96 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b96:	715d                	addi	sp,sp,-80
 b98:	ec06                	sd	ra,24(sp)
 b9a:	e822                	sd	s0,16(sp)
 b9c:	1000                	addi	s0,sp,32
 b9e:	e010                	sd	a2,0(s0)
 ba0:	e414                	sd	a3,8(s0)
 ba2:	e818                	sd	a4,16(s0)
 ba4:	ec1c                	sd	a5,24(s0)
 ba6:	03043023          	sd	a6,32(s0)
 baa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 bae:	8622                	mv	a2,s0
 bb0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 bb4:	d23ff0ef          	jal	8d6 <vprintf>
}
 bb8:	60e2                	ld	ra,24(sp)
 bba:	6442                	ld	s0,16(sp)
 bbc:	6161                	addi	sp,sp,80
 bbe:	8082                	ret

0000000000000bc0 <printf>:

void
printf(const char *fmt, ...)
{
 bc0:	711d                	addi	sp,sp,-96
 bc2:	ec06                	sd	ra,24(sp)
 bc4:	e822                	sd	s0,16(sp)
 bc6:	1000                	addi	s0,sp,32
 bc8:	e40c                	sd	a1,8(s0)
 bca:	e810                	sd	a2,16(s0)
 bcc:	ec14                	sd	a3,24(s0)
 bce:	f018                	sd	a4,32(s0)
 bd0:	f41c                	sd	a5,40(s0)
 bd2:	03043823          	sd	a6,48(s0)
 bd6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 bda:	00840613          	addi	a2,s0,8
 bde:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 be2:	85aa                	mv	a1,a0
 be4:	4505                	li	a0,1
 be6:	cf1ff0ef          	jal	8d6 <vprintf>
}
 bea:	60e2                	ld	ra,24(sp)
 bec:	6442                	ld	s0,16(sp)
 bee:	6125                	addi	sp,sp,96
 bf0:	8082                	ret

0000000000000bf2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bf2:	1141                	addi	sp,sp,-16
 bf4:	e406                	sd	ra,8(sp)
 bf6:	e022                	sd	s0,0(sp)
 bf8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 bfa:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bfe:	00001797          	auipc	a5,0x1
 c02:	4927b783          	ld	a5,1170(a5) # 2090 <freep>
 c06:	a039                	j	c14 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c08:	6398                	ld	a4,0(a5)
 c0a:	00e7e463          	bltu	a5,a4,c12 <free+0x20>
 c0e:	00e6ea63          	bltu	a3,a4,c22 <free+0x30>
{
 c12:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c14:	fed7fae3          	bgeu	a5,a3,c08 <free+0x16>
 c18:	6398                	ld	a4,0(a5)
 c1a:	00e6e463          	bltu	a3,a4,c22 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c1e:	fee7eae3          	bltu	a5,a4,c12 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 c22:	ff852583          	lw	a1,-8(a0)
 c26:	6390                	ld	a2,0(a5)
 c28:	02059813          	slli	a6,a1,0x20
 c2c:	01c85713          	srli	a4,a6,0x1c
 c30:	9736                	add	a4,a4,a3
 c32:	02e60563          	beq	a2,a4,c5c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 c36:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 c3a:	4790                	lw	a2,8(a5)
 c3c:	02061593          	slli	a1,a2,0x20
 c40:	01c5d713          	srli	a4,a1,0x1c
 c44:	973e                	add	a4,a4,a5
 c46:	02e68263          	beq	a3,a4,c6a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 c4a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c4c:	00001717          	auipc	a4,0x1
 c50:	44f73223          	sd	a5,1092(a4) # 2090 <freep>
}
 c54:	60a2                	ld	ra,8(sp)
 c56:	6402                	ld	s0,0(sp)
 c58:	0141                	addi	sp,sp,16
 c5a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 c5c:	4618                	lw	a4,8(a2)
 c5e:	9f2d                	addw	a4,a4,a1
 c60:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c64:	6398                	ld	a4,0(a5)
 c66:	6310                	ld	a2,0(a4)
 c68:	b7f9                	j	c36 <free+0x44>
    p->s.size += bp->s.size;
 c6a:	ff852703          	lw	a4,-8(a0)
 c6e:	9f31                	addw	a4,a4,a2
 c70:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c72:	ff053683          	ld	a3,-16(a0)
 c76:	bfd1                	j	c4a <free+0x58>

0000000000000c78 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 c78:	7139                	addi	sp,sp,-64
 c7a:	fc06                	sd	ra,56(sp)
 c7c:	f822                	sd	s0,48(sp)
 c7e:	f04a                	sd	s2,32(sp)
 c80:	ec4e                	sd	s3,24(sp)
 c82:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 c84:	02051993          	slli	s3,a0,0x20
 c88:	0209d993          	srli	s3,s3,0x20
 c8c:	09bd                	addi	s3,s3,15
 c8e:	0049d993          	srli	s3,s3,0x4
 c92:	2985                	addiw	s3,s3,1
 c94:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 c96:	00001517          	auipc	a0,0x1
 c9a:	3fa53503          	ld	a0,1018(a0) # 2090 <freep>
 c9e:	c905                	beqz	a0,cce <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 ca0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 ca2:	4798                	lw	a4,8(a5)
 ca4:	09377663          	bgeu	a4,s3,d30 <malloc+0xb8>
 ca8:	f426                	sd	s1,40(sp)
 caa:	e852                	sd	s4,16(sp)
 cac:	e456                	sd	s5,8(sp)
 cae:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 cb0:	8a4e                	mv	s4,s3
 cb2:	6705                	lui	a4,0x1
 cb4:	00e9f363          	bgeu	s3,a4,cba <malloc+0x42>
 cb8:	6a05                	lui	s4,0x1
 cba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 cbe:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 cc2:	00001497          	auipc	s1,0x1
 cc6:	3ce48493          	addi	s1,s1,974 # 2090 <freep>
  if (p == SBRK_ERROR)
 cca:	5afd                	li	s5,-1
 ccc:	a83d                	j	d0a <malloc+0x92>
 cce:	f426                	sd	s1,40(sp)
 cd0:	e852                	sd	s4,16(sp)
 cd2:	e456                	sd	s5,8(sp)
 cd4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 cd6:	00001797          	auipc	a5,0x1
 cda:	3ca78793          	addi	a5,a5,970 # 20a0 <base>
 cde:	00001717          	auipc	a4,0x1
 ce2:	3af73923          	sd	a5,946(a4) # 2090 <freep>
 ce6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ce8:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 cec:	b7d1                	j	cb0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 cee:	6398                	ld	a4,0(a5)
 cf0:	e118                	sd	a4,0(a0)
 cf2:	a899                	j	d48 <malloc+0xd0>
  hp->s.size = nu;
 cf4:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 cf8:	0541                	addi	a0,a0,16
 cfa:	ef9ff0ef          	jal	bf2 <free>
  return freep;
 cfe:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 d00:	c125                	beqz	a0,d60 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 d02:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 d04:	4798                	lw	a4,8(a5)
 d06:	03277163          	bgeu	a4,s2,d28 <malloc+0xb0>
    if (p == freep)
 d0a:	6098                	ld	a4,0(s1)
 d0c:	853e                	mv	a0,a5
 d0e:	fef71ae3          	bne	a4,a5,d02 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 d12:	8552                	mv	a0,s4
 d14:	9fbff0ef          	jal	70e <sbrk>
  if (p == SBRK_ERROR)
 d18:	fd551ee3          	bne	a0,s5,cf4 <malloc+0x7c>
        return 0;
 d1c:	4501                	li	a0,0
 d1e:	74a2                	ld	s1,40(sp)
 d20:	6a42                	ld	s4,16(sp)
 d22:	6aa2                	ld	s5,8(sp)
 d24:	6b02                	ld	s6,0(sp)
 d26:	a03d                	j	d54 <malloc+0xdc>
 d28:	74a2                	ld	s1,40(sp)
 d2a:	6a42                	ld	s4,16(sp)
 d2c:	6aa2                	ld	s5,8(sp)
 d2e:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 d30:	fae90fe3          	beq	s2,a4,cee <malloc+0x76>
        p->s.size -= nunits;
 d34:	4137073b          	subw	a4,a4,s3
 d38:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d3a:	02071693          	slli	a3,a4,0x20
 d3e:	01c6d713          	srli	a4,a3,0x1c
 d42:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d44:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d48:	00001717          	auipc	a4,0x1
 d4c:	34a73423          	sd	a0,840(a4) # 2090 <freep>
      return (void *)(p + 1);
 d50:	01078513          	addi	a0,a5,16
  }
}
 d54:	70e2                	ld	ra,56(sp)
 d56:	7442                	ld	s0,48(sp)
 d58:	7902                	ld	s2,32(sp)
 d5a:	69e2                	ld	s3,24(sp)
 d5c:	6121                	addi	sp,sp,64
 d5e:	8082                	ret
 d60:	74a2                	ld	s1,40(sp)
 d62:	6a42                	ld	s4,16(sp)
 d64:	6aa2                	ld	s5,8(sp)
 d66:	6b02                	ld	s6,0(sp)
 d68:	b7f5                	j	d54 <malloc+0xdc>
