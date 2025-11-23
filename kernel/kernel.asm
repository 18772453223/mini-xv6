
kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00002117          	auipc	sp,0x2
    80000004:	61010113          	add	sp,sp,1552 # 80002610 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	912a                	add	sp,sp,a0
    8000000c:	00002297          	auipc	t0,0x2
    80000010:	5e428293          	add	t0,t0,1508 # 800025f0 <panicked>
    80000014:	00007317          	auipc	t1,0x7
    80000018:	97c30313          	add	t1,t1,-1668 # 80006990 <__bss_end>
    8000001c:	00628663          	beq	t0,t1,80000028 <_entry+0x28>
    80000020:	00028023          	sb	zero,0(t0)
    80000024:	0285                	add	t0,t0,1
    80000026:	bfdd                	j	8000001c <_entry+0x1c>
    80000028:	6e1000ef          	jal	80000f08 <start>

000000008000002c <spin>:
    8000002c:	a001                	j	8000002c <spin>

000000008000002e <main>:
    8000002e:	1141                	add	sp,sp,-16
    80000030:	e406                	sd	ra,8(sp)
    80000032:	79f000ef          	jal	80000fd0 <trap_init>
    80000036:	7ce000ef          	jal	80000804 <pmm_init>
    8000003a:	44b000ef          	jal	80000c84 <kvminit>
    8000003e:	139000ef          	jal	80000976 <kvminithart>
    80000042:	400010ef          	jal	80001442 <init_process_table>
    80000046:	0c3010ef          	jal	80001908 <userinit>
    8000004a:	100027f3          	csrr	a5,sstatus
    8000004e:	0027e793          	or	a5,a5,2
    80000052:	10079073          	csrw	sstatus,a5
    80000056:	60a2                	ld	ra,8(sp)
    80000058:	0141                	add	sp,sp,16
    8000005a:	6e60106f          	j	80001740 <scheduler>

000000008000005e <uart_putc>:
    8000005e:	10000737          	lui	a4,0x10000
    80000062:	00574783          	lbu	a5,5(a4) # 10000005 <userret+0xfffff69>
    80000066:	0207f793          	and	a5,a5,32
    8000006a:	dfe5                	beqz	a5,80000062 <uart_putc+0x4>
    8000006c:	00a70023          	sb	a0,0(a4)
    80000070:	8082                	ret

0000000080000072 <uart_puts>:
    80000072:	00054683          	lbu	a3,0(a0) # 1000 <userret+0xf64>
    80000076:	ce91                	beqz	a3,80000092 <uart_puts+0x20>
    80000078:	10000737          	lui	a4,0x10000
    8000007c:	00574783          	lbu	a5,5(a4) # 10000005 <userret+0xfffff69>
    80000080:	0207f793          	and	a5,a5,32
    80000084:	dfe5                	beqz	a5,8000007c <uart_puts+0xa>
    80000086:	00d70023          	sb	a3,0(a4)
    8000008a:	00154683          	lbu	a3,1(a0)
    8000008e:	0505                	add	a0,a0,1
    80000090:	f6f5                	bnez	a3,8000007c <uart_puts+0xa>
    80000092:	8082                	ret

0000000080000094 <uartgetc>:
    80000094:	10000737          	lui	a4,0x10000
    80000098:	00574783          	lbu	a5,5(a4) # 10000005 <userret+0xfffff69>
    8000009c:	8b85                	and	a5,a5,1
    8000009e:	c781                	beqz	a5,800000a6 <uartgetc+0x12>
    800000a0:	00074503          	lbu	a0,0(a4)
    800000a4:	8082                	ret
    800000a6:	557d                	li	a0,-1
    800000a8:	8082                	ret

00000000800000aa <consputc>:
    800000aa:	10000793          	li	a5,256
    800000ae:	00f50563          	beq	a0,a5,800000b8 <consputc+0xe>
    800000b2:	0ff57513          	zext.b	a0,a0
    800000b6:	b765                	j	8000005e <uart_putc>
    800000b8:	1141                	add	sp,sp,-16
    800000ba:	4521                	li	a0,8
    800000bc:	e406                	sd	ra,8(sp)
    800000be:	fa1ff0ef          	jal	8000005e <uart_putc>
    800000c2:	02000513          	li	a0,32
    800000c6:	f99ff0ef          	jal	8000005e <uart_putc>
    800000ca:	60a2                	ld	ra,8(sp)
    800000cc:	4521                	li	a0,8
    800000ce:	0141                	add	sp,sp,16
    800000d0:	b779                	j	8000005e <uart_putc>

00000000800000d2 <print_number>:
    800000d2:	7139                	add	sp,sp,-64
    800000d4:	fc06                	sd	ra,56(sp)
    800000d6:	f822                	sd	s0,48(sp)
    800000d8:	f426                	sd	s1,40(sp)
    800000da:	c219                	beqz	a2,800000e0 <print_number+0xe>
    800000dc:	06054763          	bltz	a0,8000014a <print_number+0x78>
    800000e0:	0005071b          	sext.w	a4,a0
    800000e4:	4601                	li	a2,0
    800000e6:	2581                	sext.w	a1,a1
    800000e8:	0034                	add	a3,sp,8
    800000ea:	4501                	li	a0,0
    800000ec:	00002897          	auipc	a7,0x2
    800000f0:	f4c88893          	add	a7,a7,-180 # 80002038 <digits>
    800000f4:	02b777bb          	remuw	a5,a4,a1
    800000f8:	0685                	add	a3,a3,1
    800000fa:	0007081b          	sext.w	a6,a4
    800000fe:	842a                	mv	s0,a0
    80000100:	2505                	addw	a0,a0,1
    80000102:	1782                	sll	a5,a5,0x20
    80000104:	9381                	srl	a5,a5,0x20
    80000106:	97c6                	add	a5,a5,a7
    80000108:	0007c783          	lbu	a5,0(a5)
    8000010c:	02b7573b          	divuw	a4,a4,a1
    80000110:	fef68fa3          	sb	a5,-1(a3)
    80000114:	feb870e3          	bgeu	a6,a1,800000f4 <print_number+0x22>
    80000118:	ca09                	beqz	a2,8000012a <print_number+0x58>
    8000011a:	02050793          	add	a5,a0,32
    8000011e:	978a                	add	a5,a5,sp
    80000120:	02d00713          	li	a4,45
    80000124:	fee78423          	sb	a4,-24(a5)
    80000128:	842a                	mv	s0,a0
    8000012a:	003c                	add	a5,sp,8
    8000012c:	943e                	add	s0,s0,a5
    8000012e:	fff78493          	add	s1,a5,-1
    80000132:	00044503          	lbu	a0,0(s0)
    80000136:	147d                	add	s0,s0,-1
    80000138:	f27ff0ef          	jal	8000005e <uart_putc>
    8000013c:	fe941be3          	bne	s0,s1,80000132 <print_number+0x60>
    80000140:	70e2                	ld	ra,56(sp)
    80000142:	7442                	ld	s0,48(sp)
    80000144:	74a2                	ld	s1,40(sp)
    80000146:	6121                	add	sp,sp,64
    80000148:	8082                	ret
    8000014a:	80000737          	lui	a4,0x80000
    8000014e:	f8e50ce3          	beq	a0,a4,800000e6 <print_number+0x14>
    80000152:	40a0073b          	negw	a4,a0
    80000156:	bf41                	j	800000e6 <print_number+0x14>

0000000080000158 <printf>:
    80000158:	7131                	add	sp,sp,-192
    8000015a:	f4a6                	sd	s1,104(sp)
    8000015c:	fc86                	sd	ra,120(sp)
    8000015e:	f8a2                	sd	s0,112(sp)
    80000160:	f0ca                	sd	s2,96(sp)
    80000162:	ecce                	sd	s3,88(sp)
    80000164:	e8d2                	sd	s4,80(sp)
    80000166:	e4d6                	sd	s5,72(sp)
    80000168:	e0da                	sd	s6,64(sp)
    8000016a:	fc5e                	sd	s7,56(sp)
    8000016c:	f862                	sd	s8,48(sp)
    8000016e:	f466                	sd	s9,40(sp)
    80000170:	f06a                	sd	s10,32(sp)
    80000172:	ec6e                	sd	s11,24(sp)
    80000174:	84aa                	mv	s1,a0
    80000176:	00054503          	lbu	a0,0(a0)
    8000017a:	f53e                	sd	a5,168(sp)
    8000017c:	013c                	add	a5,sp,136
    8000017e:	e52e                	sd	a1,136(sp)
    80000180:	e932                	sd	a2,144(sp)
    80000182:	ed36                	sd	a3,152(sp)
    80000184:	f13a                	sd	a4,160(sp)
    80000186:	f942                	sd	a6,176(sp)
    80000188:	fd46                	sd	a7,184(sp)
    8000018a:	e43e                	sd	a5,8(sp)
    8000018c:	c915                	beqz	a0,800001c0 <printf+0x68>
    8000018e:	02500913          	li	s2,37
    80000192:	4401                	li	s0,0
    80000194:	07500a13          	li	s4,117
    80000198:	07800b13          	li	s6,120
    8000019c:	07000b93          	li	s7,112
    800001a0:	06300c13          	li	s8,99
    800001a4:	06400993          	li	s3,100
    800001a8:	06c00a93          	li	s5,108
    800001ac:	07251f63          	bne	a0,s2,8000022a <printf+0xd2>
    800001b0:	00140d1b          	addw	s10,s0,1
    800001b4:	01a487b3          	add	a5,s1,s10
    800001b8:	0007cd83          	lbu	s11,0(a5)
    800001bc:	020d9263          	bnez	s11,800001e0 <printf+0x88>
    800001c0:	70e6                	ld	ra,120(sp)
    800001c2:	7446                	ld	s0,112(sp)
    800001c4:	74a6                	ld	s1,104(sp)
    800001c6:	7906                	ld	s2,96(sp)
    800001c8:	69e6                	ld	s3,88(sp)
    800001ca:	6a46                	ld	s4,80(sp)
    800001cc:	6aa6                	ld	s5,72(sp)
    800001ce:	6b06                	ld	s6,64(sp)
    800001d0:	7be2                	ld	s7,56(sp)
    800001d2:	7c42                	ld	s8,48(sp)
    800001d4:	7ca2                	ld	s9,40(sp)
    800001d6:	7d02                	ld	s10,32(sp)
    800001d8:	6de2                	ld	s11,24(sp)
    800001da:	4501                	li	a0,0
    800001dc:	6129                	add	sp,sp,192
    800001de:	8082                	ret
    800001e0:	0017c703          	lbu	a4,1(a5)
    800001e4:	e731                	bnez	a4,80000230 <printf+0xd8>
    800001e6:	073d8963          	beq	s11,s3,80000258 <printf+0x100>
    800001ea:	035d8063          	beq	s11,s5,8000020a <printf+0xb2>
    800001ee:	074d8e63          	beq	s11,s4,8000026a <printf+0x112>
    800001f2:	076d8f63          	beq	s11,s6,80000270 <printf+0x118>
    800001f6:	097d8663          	beq	s11,s7,80000282 <printf+0x12a>
    800001fa:	0d8d8363          	beq	s11,s8,800002c0 <printf+0x168>
    800001fe:	07300793          	li	a5,115
    80000202:	10fd8963          	beq	s11,a5,80000314 <printf+0x1bc>
    80000206:	0f2d8e63          	beq	s11,s2,80000302 <printf+0x1aa>
    8000020a:	02500513          	li	a0,37
    8000020e:	e9dff0ef          	jal	800000aa <consputc>
    80000212:	856e                	mv	a0,s11
    80000214:	e97ff0ef          	jal	800000aa <consputc>
    80000218:	846a                	mv	s0,s10
    8000021a:	2405                	addw	s0,s0,1
    8000021c:	008487b3          	add	a5,s1,s0
    80000220:	0007c503          	lbu	a0,0(a5)
    80000224:	dd51                	beqz	a0,800001c0 <printf+0x68>
    80000226:	f92505e3          	beq	a0,s2,800001b0 <printf+0x58>
    8000022a:	e81ff0ef          	jal	800000aa <consputc>
    8000022e:	b7f5                	j	8000021a <printf+0xc2>
    80000230:	0027c783          	lbu	a5,2(a5)
    80000234:	033d8263          	beq	s11,s3,80000258 <printf+0x100>
    80000238:	fb5d9be3          	bne	s11,s5,800001ee <printf+0x96>
    8000023c:	0b370963          	beq	a4,s3,800002ee <printf+0x196>
    80000240:	09570763          	beq	a4,s5,800002ce <printf+0x176>
    80000244:	0d470463          	beq	a4,s4,8000030c <printf+0x1b4>
    80000248:	07800793          	li	a5,120
    8000024c:	faf71fe3          	bne	a4,a5,8000020a <printf+0xb2>
    80000250:	67a2                	ld	a5,8(sp)
    80000252:	4601                	li	a2,0
    80000254:	45c1                	li	a1,16
    80000256:	a879                	j	800002f4 <printf+0x19c>
    80000258:	67a2                	ld	a5,8(sp)
    8000025a:	4605                	li	a2,1
    8000025c:	4388                	lw	a0,0(a5)
    8000025e:	45a9                	li	a1,10
    80000260:	07a1                	add	a5,a5,8
    80000262:	e43e                	sd	a5,8(sp)
    80000264:	e6fff0ef          	jal	800000d2 <print_number>
    80000268:	bf45                	j	80000218 <printf+0xc0>
    8000026a:	67a2                	ld	a5,8(sp)
    8000026c:	4601                	li	a2,0
    8000026e:	b7fd                	j	8000025c <printf+0x104>
    80000270:	67a2                	ld	a5,8(sp)
    80000272:	4601                	li	a2,0
    80000274:	45c1                	li	a1,16
    80000276:	4388                	lw	a0,0(a5)
    80000278:	07a1                	add	a5,a5,8
    8000027a:	e43e                	sd	a5,8(sp)
    8000027c:	e57ff0ef          	jal	800000d2 <print_number>
    80000280:	bf61                	j	80000218 <printf+0xc0>
    80000282:	67a2                	ld	a5,8(sp)
    80000284:	03000513          	li	a0,48
    80000288:	4cc1                	li	s9,16
    8000028a:	00878693          	add	a3,a5,8
    8000028e:	0007bd83          	ld	s11,0(a5)
    80000292:	e436                	sd	a3,8(sp)
    80000294:	e17ff0ef          	jal	800000aa <consputc>
    80000298:	07800513          	li	a0,120
    8000029c:	e0fff0ef          	jal	800000aa <consputc>
    800002a0:	00002417          	auipc	s0,0x2
    800002a4:	d9840413          	add	s0,s0,-616 # 80002038 <digits>
    800002a8:	03cdd793          	srl	a5,s11,0x3c
    800002ac:	97a2                	add	a5,a5,s0
    800002ae:	0007c503          	lbu	a0,0(a5)
    800002b2:	3cfd                	addw	s9,s9,-1
    800002b4:	0d92                	sll	s11,s11,0x4
    800002b6:	df5ff0ef          	jal	800000aa <consputc>
    800002ba:	fe0c97e3          	bnez	s9,800002a8 <printf+0x150>
    800002be:	bfa9                	j	80000218 <printf+0xc0>
    800002c0:	67a2                	ld	a5,8(sp)
    800002c2:	4388                	lw	a0,0(a5)
    800002c4:	07a1                	add	a5,a5,8
    800002c6:	e43e                	sd	a5,8(sp)
    800002c8:	de3ff0ef          	jal	800000aa <consputc>
    800002cc:	b7b1                	j	80000218 <printf+0xc0>
    800002ce:	0007871b          	sext.w	a4,a5
    800002d2:	05378e63          	beq	a5,s3,8000032e <printf+0x1d6>
    800002d6:	07500793          	li	a5,117
    800002da:	06f70b63          	beq	a4,a5,80000350 <printf+0x1f8>
    800002de:	07800793          	li	a5,120
    800002e2:	f2f714e3          	bne	a4,a5,8000020a <printf+0xb2>
    800002e6:	67a2                	ld	a5,8(sp)
    800002e8:	4601                	li	a2,0
    800002ea:	45c1                	li	a1,16
    800002ec:	a0a1                	j	80000334 <printf+0x1dc>
    800002ee:	67a2                	ld	a5,8(sp)
    800002f0:	4605                	li	a2,1
    800002f2:	45a9                	li	a1,10
    800002f4:	4388                	lw	a0,0(a5)
    800002f6:	07a1                	add	a5,a5,8
    800002f8:	e43e                	sd	a5,8(sp)
    800002fa:	2409                	addw	s0,s0,2
    800002fc:	dd7ff0ef          	jal	800000d2 <print_number>
    80000300:	bf29                	j	8000021a <printf+0xc2>
    80000302:	02500513          	li	a0,37
    80000306:	da5ff0ef          	jal	800000aa <consputc>
    8000030a:	b739                	j	80000218 <printf+0xc0>
    8000030c:	67a2                	ld	a5,8(sp)
    8000030e:	4601                	li	a2,0
    80000310:	45a9                	li	a1,10
    80000312:	b7cd                	j	800002f4 <printf+0x19c>
    80000314:	67a2                	ld	a5,8(sp)
    80000316:	6380                	ld	s0,0(a5)
    80000318:	07a1                	add	a5,a5,8
    8000031a:	e43e                	sd	a5,8(sp)
    8000031c:	e409                	bnez	s0,80000326 <printf+0x1ce>
    8000031e:	a015                	j	80000342 <printf+0x1ea>
    80000320:	0405                	add	s0,s0,1
    80000322:	d89ff0ef          	jal	800000aa <consputc>
    80000326:	00044503          	lbu	a0,0(s0)
    8000032a:	f97d                	bnez	a0,80000320 <printf+0x1c8>
    8000032c:	b5f5                	j	80000218 <printf+0xc0>
    8000032e:	67a2                	ld	a5,8(sp)
    80000330:	4605                	li	a2,1
    80000332:	45a9                	li	a1,10
    80000334:	4388                	lw	a0,0(a5)
    80000336:	07a1                	add	a5,a5,8
    80000338:	e43e                	sd	a5,8(sp)
    8000033a:	240d                	addw	s0,s0,3
    8000033c:	d97ff0ef          	jal	800000d2 <print_number>
    80000340:	bde9                	j	8000021a <printf+0xc2>
    80000342:	02800513          	li	a0,40
    80000346:	00002417          	auipc	s0,0x2
    8000034a:	cca40413          	add	s0,s0,-822 # 80002010 <etext+0x10>
    8000034e:	bfc9                	j	80000320 <printf+0x1c8>
    80000350:	67a2                	ld	a5,8(sp)
    80000352:	4601                	li	a2,0
    80000354:	bff9                	j	80000332 <printf+0x1da>

0000000080000356 <panic>:
    80000356:	1141                	add	sp,sp,-16
    80000358:	e022                	sd	s0,0(sp)
    8000035a:	842a                	mv	s0,a0
    8000035c:	00002517          	auipc	a0,0x2
    80000360:	cbc50513          	add	a0,a0,-836 # 80002018 <etext+0x18>
    80000364:	e406                	sd	ra,8(sp)
    80000366:	df3ff0ef          	jal	80000158 <printf>
    8000036a:	85a2                	mv	a1,s0
    8000036c:	00002517          	auipc	a0,0x2
    80000370:	cb450513          	add	a0,a0,-844 # 80002020 <etext+0x20>
    80000374:	de5ff0ef          	jal	80000158 <printf>
    80000378:	a001                	j	80000378 <panic+0x22>

000000008000037a <clear_screen>:
    8000037a:	1141                	add	sp,sp,-16
    8000037c:	00002517          	auipc	a0,0x2
    80000380:	cac50513          	add	a0,a0,-852 # 80002028 <etext+0x28>
    80000384:	e406                	sd	ra,8(sp)
    80000386:	dd3ff0ef          	jal	80000158 <printf>
    8000038a:	60a2                	ld	ra,8(sp)
    8000038c:	00002517          	auipc	a0,0x2
    80000390:	ca450513          	add	a0,a0,-860 # 80002030 <etext+0x30>
    80000394:	0141                	add	sp,sp,16
    80000396:	b3c9                	j	80000158 <printf>

0000000080000398 <assert>:
    80000398:	1141                	add	sp,sp,-16
    8000039a:	e406                	sd	ra,8(sp)
    8000039c:	cd11                	beqz	a0,800003b8 <assert+0x20>
    8000039e:	00002517          	auipc	a0,0x2
    800003a2:	cca50513          	add	a0,a0,-822 # 80002068 <digits+0x30>
    800003a6:	db3ff0ef          	jal	80000158 <printf>
    800003aa:	60a2                	ld	ra,8(sp)
    800003ac:	00002517          	auipc	a0,0x2
    800003b0:	d5c50513          	add	a0,a0,-676 # 80002108 <digits+0xd0>
    800003b4:	0141                	add	sp,sp,16
    800003b6:	b34d                	j	80000158 <printf>
    800003b8:	00002517          	auipc	a0,0x2
    800003bc:	c9850513          	add	a0,a0,-872 # 80002050 <digits+0x18>
    800003c0:	d99ff0ef          	jal	80000158 <printf>
    800003c4:	60a2                	ld	ra,8(sp)
    800003c6:	00002517          	auipc	a0,0x2
    800003ca:	d4250513          	add	a0,a0,-702 # 80002108 <digits+0xd0>
    800003ce:	0141                	add	sp,sp,16
    800003d0:	b361                	j	80000158 <printf>

00000000800003d2 <test_physical_memory>:
    800003d2:	1101                	add	sp,sp,-32
    800003d4:	ec06                	sd	ra,24(sp)
    800003d6:	e822                	sd	s0,16(sp)
    800003d8:	e426                	sd	s1,8(sp)
    800003da:	572000ef          	jal	8000094c <alloc_page>
    800003de:	842a                	mv	s0,a0
    800003e0:	56c000ef          	jal	8000094c <alloc_page>
    800003e4:	84aa                	mv	s1,a0
    800003e6:	862a                	mv	a2,a0
    800003e8:	85a2                	mv	a1,s0
    800003ea:	00002517          	auipc	a0,0x2
    800003ee:	c9650513          	add	a0,a0,-874 # 80002080 <digits+0x48>
    800003f2:	d67ff0ef          	jal	80000158 <printf>
    800003f6:	06940d63          	beq	s0,s1,80000470 <test_physical_memory+0x9e>
    800003fa:	00002517          	auipc	a0,0x2
    800003fe:	c6e50513          	add	a0,a0,-914 # 80002068 <digits+0x30>
    80000402:	d57ff0ef          	jal	80000158 <printf>
    80000406:	00002517          	auipc	a0,0x2
    8000040a:	d0250513          	add	a0,a0,-766 # 80002108 <digits+0xd0>
    8000040e:	d4bff0ef          	jal	80000158 <printf>
    80000412:	03441793          	sll	a5,s0,0x34
    80000416:	efa5                	bnez	a5,8000048e <test_physical_memory+0xbc>
    80000418:	00002517          	auipc	a0,0x2
    8000041c:	c5050513          	add	a0,a0,-944 # 80002068 <digits+0x30>
    80000420:	d39ff0ef          	jal	80000158 <printf>
    80000424:	00002517          	auipc	a0,0x2
    80000428:	ce450513          	add	a0,a0,-796 # 80002108 <digits+0xd0>
    8000042c:	d2dff0ef          	jal	80000158 <printf>
    80000430:	123457b7          	lui	a5,0x12345
    80000434:	67878793          	add	a5,a5,1656 # 12345678 <userret+0x123455dc>
    80000438:	c01c                	sw	a5,0(s0)
    8000043a:	00002517          	auipc	a0,0x2
    8000043e:	c2e50513          	add	a0,a0,-978 # 80002068 <digits+0x30>
    80000442:	d17ff0ef          	jal	80000158 <printf>
    80000446:	00002517          	auipc	a0,0x2
    8000044a:	cc250513          	add	a0,a0,-830 # 80002108 <digits+0xd0>
    8000044e:	d0bff0ef          	jal	80000158 <printf>
    80000452:	8522                	mv	a0,s0
    80000454:	4a8000ef          	jal	800008fc <free_page>
    80000458:	4f4000ef          	jal	8000094c <alloc_page>
    8000045c:	842a                	mv	s0,a0
    8000045e:	8526                	mv	a0,s1
    80000460:	49c000ef          	jal	800008fc <free_page>
    80000464:	8522                	mv	a0,s0
    80000466:	6442                	ld	s0,16(sp)
    80000468:	60e2                	ld	ra,24(sp)
    8000046a:	64a2                	ld	s1,8(sp)
    8000046c:	6105                	add	sp,sp,32
    8000046e:	a179                	j	800008fc <free_page>
    80000470:	00002517          	auipc	a0,0x2
    80000474:	be050513          	add	a0,a0,-1056 # 80002050 <digits+0x18>
    80000478:	ce1ff0ef          	jal	80000158 <printf>
    8000047c:	00002517          	auipc	a0,0x2
    80000480:	c8c50513          	add	a0,a0,-884 # 80002108 <digits+0xd0>
    80000484:	cd5ff0ef          	jal	80000158 <printf>
    80000488:	03441793          	sll	a5,s0,0x34
    8000048c:	d7d1                	beqz	a5,80000418 <test_physical_memory+0x46>
    8000048e:	00002517          	auipc	a0,0x2
    80000492:	bc250513          	add	a0,a0,-1086 # 80002050 <digits+0x18>
    80000496:	cc3ff0ef          	jal	80000158 <printf>
    8000049a:	00002517          	auipc	a0,0x2
    8000049e:	c6e50513          	add	a0,a0,-914 # 80002108 <digits+0xd0>
    800004a2:	cb7ff0ef          	jal	80000158 <printf>
    800004a6:	b769                	j	80000430 <test_physical_memory+0x5e>

00000000800004a8 <test_pagetable>:
    800004a8:	1101                	add	sp,sp,-32
    800004aa:	ec06                	sd	ra,24(sp)
    800004ac:	e822                	sd	s0,16(sp)
    800004ae:	e426                	sd	s1,8(sp)
    800004b0:	6ac000ef          	jal	80000b5c <create_pagetable>
    800004b4:	842a                	mv	s0,a0
    800004b6:	496000ef          	jal	8000094c <alloc_page>
    800004ba:	84aa                	mv	s1,a0
    800004bc:	4581                	li	a1,0
    800004be:	00002517          	auipc	a0,0x2
    800004c2:	be250513          	add	a0,a0,-1054 # 800020a0 <digits+0x68>
    800004c6:	c93ff0ef          	jal	80000158 <printf>
    800004ca:	4719                	li	a4,6
    800004cc:	86a6                	mv	a3,s1
    800004ce:	6605                	lui	a2,0x1
    800004d0:	010005b7          	lui	a1,0x1000
    800004d4:	8522                	mv	a0,s0
    800004d6:	55e000ef          	jal	80000a34 <mappages>
    800004da:	14051663          	bnez	a0,80000626 <test_pagetable+0x17e>
    800004de:	00002517          	auipc	a0,0x2
    800004e2:	b8a50513          	add	a0,a0,-1142 # 80002068 <digits+0x30>
    800004e6:	c73ff0ef          	jal	80000158 <printf>
    800004ea:	00002517          	auipc	a0,0x2
    800004ee:	c1e50513          	add	a0,a0,-994 # 80002108 <digits+0xd0>
    800004f2:	c67ff0ef          	jal	80000158 <printf>
    800004f6:	8522                	mv	a0,s0
    800004f8:	4601                	li	a2,0
    800004fa:	010005b7          	lui	a1,0x1000
    800004fe:	496000ef          	jal	80000994 <walk>
    80000502:	842a                	mv	s0,a0
    80000504:	c54d                	beqz	a0,800005ae <test_pagetable+0x106>
    80000506:	611c                	ld	a5,0(a0)
    80000508:	8b85                	and	a5,a5,1
    8000050a:	c3d5                	beqz	a5,800005ae <test_pagetable+0x106>
    8000050c:	00002517          	auipc	a0,0x2
    80000510:	b5c50513          	add	a0,a0,-1188 # 80002068 <digits+0x30>
    80000514:	c45ff0ef          	jal	80000158 <printf>
    80000518:	00002517          	auipc	a0,0x2
    8000051c:	bf050513          	add	a0,a0,-1040 # 80002108 <digits+0xd0>
    80000520:	c39ff0ef          	jal	80000158 <printf>
    80000524:	601c                	ld	a5,0(s0)
    80000526:	83a9                	srl	a5,a5,0xa
    80000528:	07b2                	sll	a5,a5,0xc
    8000052a:	0a979363          	bne	a5,s1,800005d0 <test_pagetable+0x128>
    8000052e:	00002517          	auipc	a0,0x2
    80000532:	b3a50513          	add	a0,a0,-1222 # 80002068 <digits+0x30>
    80000536:	c23ff0ef          	jal	80000158 <printf>
    8000053a:	00002517          	auipc	a0,0x2
    8000053e:	bce50513          	add	a0,a0,-1074 # 80002108 <digits+0xd0>
    80000542:	c17ff0ef          	jal	80000158 <printf>
    80000546:	601c                	ld	a5,0(s0)
    80000548:	8b89                	and	a5,a5,2
    8000054a:	c3d5                	beqz	a5,800005ee <test_pagetable+0x146>
    8000054c:	00002517          	auipc	a0,0x2
    80000550:	b1c50513          	add	a0,a0,-1252 # 80002068 <digits+0x30>
    80000554:	c05ff0ef          	jal	80000158 <printf>
    80000558:	00002517          	auipc	a0,0x2
    8000055c:	bb050513          	add	a0,a0,-1104 # 80002108 <digits+0xd0>
    80000560:	bf9ff0ef          	jal	80000158 <printf>
    80000564:	601c                	ld	a5,0(s0)
    80000566:	8b91                	and	a5,a5,4
    80000568:	c3d5                	beqz	a5,8000060c <test_pagetable+0x164>
    8000056a:	00002517          	auipc	a0,0x2
    8000056e:	afe50513          	add	a0,a0,-1282 # 80002068 <digits+0x30>
    80000572:	be7ff0ef          	jal	80000158 <printf>
    80000576:	00002517          	auipc	a0,0x2
    8000057a:	b9250513          	add	a0,a0,-1134 # 80002108 <digits+0xd0>
    8000057e:	bdbff0ef          	jal	80000158 <printf>
    80000582:	601c                	ld	a5,0(s0)
    80000584:	00002517          	auipc	a0,0x2
    80000588:	acc50513          	add	a0,a0,-1332 # 80002050 <digits+0x18>
    8000058c:	8ba1                	and	a5,a5,8
    8000058e:	e789                	bnez	a5,80000598 <test_pagetable+0xf0>
    80000590:	00002517          	auipc	a0,0x2
    80000594:	ad850513          	add	a0,a0,-1320 # 80002068 <digits+0x30>
    80000598:	bc1ff0ef          	jal	80000158 <printf>
    8000059c:	6442                	ld	s0,16(sp)
    8000059e:	60e2                	ld	ra,24(sp)
    800005a0:	64a2                	ld	s1,8(sp)
    800005a2:	00002517          	auipc	a0,0x2
    800005a6:	b6650513          	add	a0,a0,-1178 # 80002108 <digits+0xd0>
    800005aa:	6105                	add	sp,sp,32
    800005ac:	b675                	j	80000158 <printf>
    800005ae:	00002517          	auipc	a0,0x2
    800005b2:	aa250513          	add	a0,a0,-1374 # 80002050 <digits+0x18>
    800005b6:	ba3ff0ef          	jal	80000158 <printf>
    800005ba:	00002517          	auipc	a0,0x2
    800005be:	b4e50513          	add	a0,a0,-1202 # 80002108 <digits+0xd0>
    800005c2:	b97ff0ef          	jal	80000158 <printf>
    800005c6:	601c                	ld	a5,0(s0)
    800005c8:	83a9                	srl	a5,a5,0xa
    800005ca:	07b2                	sll	a5,a5,0xc
    800005cc:	f69781e3          	beq	a5,s1,8000052e <test_pagetable+0x86>
    800005d0:	00002517          	auipc	a0,0x2
    800005d4:	a8050513          	add	a0,a0,-1408 # 80002050 <digits+0x18>
    800005d8:	b81ff0ef          	jal	80000158 <printf>
    800005dc:	00002517          	auipc	a0,0x2
    800005e0:	b2c50513          	add	a0,a0,-1236 # 80002108 <digits+0xd0>
    800005e4:	b75ff0ef          	jal	80000158 <printf>
    800005e8:	601c                	ld	a5,0(s0)
    800005ea:	8b89                	and	a5,a5,2
    800005ec:	f3a5                	bnez	a5,8000054c <test_pagetable+0xa4>
    800005ee:	00002517          	auipc	a0,0x2
    800005f2:	a6250513          	add	a0,a0,-1438 # 80002050 <digits+0x18>
    800005f6:	b63ff0ef          	jal	80000158 <printf>
    800005fa:	00002517          	auipc	a0,0x2
    800005fe:	b0e50513          	add	a0,a0,-1266 # 80002108 <digits+0xd0>
    80000602:	b57ff0ef          	jal	80000158 <printf>
    80000606:	601c                	ld	a5,0(s0)
    80000608:	8b91                	and	a5,a5,4
    8000060a:	f3a5                	bnez	a5,8000056a <test_pagetable+0xc2>
    8000060c:	00002517          	auipc	a0,0x2
    80000610:	a4450513          	add	a0,a0,-1468 # 80002050 <digits+0x18>
    80000614:	b45ff0ef          	jal	80000158 <printf>
    80000618:	00002517          	auipc	a0,0x2
    8000061c:	af050513          	add	a0,a0,-1296 # 80002108 <digits+0xd0>
    80000620:	b39ff0ef          	jal	80000158 <printf>
    80000624:	bfb9                	j	80000582 <test_pagetable+0xda>
    80000626:	00002517          	auipc	a0,0x2
    8000062a:	a2a50513          	add	a0,a0,-1494 # 80002050 <digits+0x18>
    8000062e:	b2bff0ef          	jal	80000158 <printf>
    80000632:	00002517          	auipc	a0,0x2
    80000636:	ad650513          	add	a0,a0,-1322 # 80002108 <digits+0xd0>
    8000063a:	b1fff0ef          	jal	80000158 <printf>
    8000063e:	bd65                	j	800004f6 <test_pagetable+0x4e>

0000000080000640 <test_virtual_memory>:
    80000640:	1101                	add	sp,sp,-32
    80000642:	00002517          	auipc	a0,0x2
    80000646:	a6e50513          	add	a0,a0,-1426 # 800020b0 <digits+0x78>
    8000064a:	ec06                	sd	ra,24(sp)
    8000064c:	e822                	sd	s0,16(sp)
    8000064e:	e426                	sd	s1,8(sp)
    80000650:	b09ff0ef          	jal	80000158 <printf>
    80000654:	630000ef          	jal	80000c84 <kvminit>
    80000658:	31e000ef          	jal	80000976 <kvminithart>
    8000065c:	00002517          	auipc	a0,0x2
    80000660:	a7450513          	add	a0,a0,-1420 # 800020d0 <digits+0x98>
    80000664:	af5ff0ef          	jal	80000158 <printf>
    80000668:	00002497          	auipc	s1,0x2
    8000066c:	f9848493          	add	s1,s1,-104 # 80002600 <kernel_pagetable>
    80000670:	6088                	ld	a0,0(s1)
    80000672:	4601                	li	a2,0
    80000674:	00000597          	auipc	a1,0x0
    80000678:	9ea58593          	add	a1,a1,-1558 # 8000005e <uart_putc>
    8000067c:	318000ef          	jal	80000994 <walk>
    80000680:	842a                	mv	s0,a0
    80000682:	10050463          	beqz	a0,8000078a <test_virtual_memory+0x14a>
    80000686:	611c                	ld	a5,0(a0)
    80000688:	8b85                	and	a5,a5,1
    8000068a:	10078063          	beqz	a5,8000078a <test_virtual_memory+0x14a>
    8000068e:	00002517          	auipc	a0,0x2
    80000692:	9da50513          	add	a0,a0,-1574 # 80002068 <digits+0x30>
    80000696:	ac3ff0ef          	jal	80000158 <printf>
    8000069a:	00002517          	auipc	a0,0x2
    8000069e:	a6e50513          	add	a0,a0,-1426 # 80002108 <digits+0xd0>
    800006a2:	ab7ff0ef          	jal	80000158 <printf>
    800006a6:	601c                	ld	a5,0(s0)
    800006a8:	8b89                	and	a5,a5,2
    800006aa:	10078063          	beqz	a5,800007aa <test_virtual_memory+0x16a>
    800006ae:	00002517          	auipc	a0,0x2
    800006b2:	9ba50513          	add	a0,a0,-1606 # 80002068 <digits+0x30>
    800006b6:	aa3ff0ef          	jal	80000158 <printf>
    800006ba:	00002517          	auipc	a0,0x2
    800006be:	a4e50513          	add	a0,a0,-1458 # 80002108 <digits+0xd0>
    800006c2:	a97ff0ef          	jal	80000158 <printf>
    800006c6:	601c                	ld	a5,0(s0)
    800006c8:	8ba1                	and	a5,a5,8
    800006ca:	10078063          	beqz	a5,800007ca <test_virtual_memory+0x18a>
    800006ce:	00002517          	auipc	a0,0x2
    800006d2:	99a50513          	add	a0,a0,-1638 # 80002068 <digits+0x30>
    800006d6:	a83ff0ef          	jal	80000158 <printf>
    800006da:	00002517          	auipc	a0,0x2
    800006de:	a2e50513          	add	a0,a0,-1490 # 80002108 <digits+0xd0>
    800006e2:	a77ff0ef          	jal	80000158 <printf>
    800006e6:	601c                	ld	a5,0(s0)
    800006e8:	8b91                	and	a5,a5,4
    800006ea:	10079063          	bnez	a5,800007ea <test_virtual_memory+0x1aa>
    800006ee:	00002517          	auipc	a0,0x2
    800006f2:	97a50513          	add	a0,a0,-1670 # 80002068 <digits+0x30>
    800006f6:	a63ff0ef          	jal	80000158 <printf>
    800006fa:	00002517          	auipc	a0,0x2
    800006fe:	a0e50513          	add	a0,a0,-1522 # 80002108 <digits+0xd0>
    80000702:	a57ff0ef          	jal	80000158 <printf>
    80000706:	00002517          	auipc	a0,0x2
    8000070a:	9ea50513          	add	a0,a0,-1558 # 800020f0 <digits+0xb8>
    8000070e:	965ff0ef          	jal	80000072 <uart_puts>
    80000712:	6088                	ld	a0,0(s1)
    80000714:	4601                	li	a2,0
    80000716:	00002597          	auipc	a1,0x2
    8000071a:	eea58593          	add	a1,a1,-278 # 80002600 <kernel_pagetable>
    8000071e:	276000ef          	jal	80000994 <walk>
    80000722:	842a                	mv	s0,a0
    80000724:	c531                	beqz	a0,80000770 <test_virtual_memory+0x130>
    80000726:	611c                	ld	a5,0(a0)
    80000728:	8b85                	and	a5,a5,1
    8000072a:	c3b9                	beqz	a5,80000770 <test_virtual_memory+0x130>
    8000072c:	00002517          	auipc	a0,0x2
    80000730:	93c50513          	add	a0,a0,-1732 # 80002068 <digits+0x30>
    80000734:	a25ff0ef          	jal	80000158 <printf>
    80000738:	00002517          	auipc	a0,0x2
    8000073c:	9d050513          	add	a0,a0,-1584 # 80002108 <digits+0xd0>
    80000740:	a19ff0ef          	jal	80000158 <printf>
    80000744:	601c                	ld	a5,0(s0)
    80000746:	00002517          	auipc	a0,0x2
    8000074a:	90a50513          	add	a0,a0,-1782 # 80002050 <digits+0x18>
    8000074e:	8b89                	and	a5,a5,2
    80000750:	c789                	beqz	a5,8000075a <test_virtual_memory+0x11a>
    80000752:	00002517          	auipc	a0,0x2
    80000756:	91650513          	add	a0,a0,-1770 # 80002068 <digits+0x30>
    8000075a:	9ffff0ef          	jal	80000158 <printf>
    8000075e:	6442                	ld	s0,16(sp)
    80000760:	60e2                	ld	ra,24(sp)
    80000762:	64a2                	ld	s1,8(sp)
    80000764:	00002517          	auipc	a0,0x2
    80000768:	9a450513          	add	a0,a0,-1628 # 80002108 <digits+0xd0>
    8000076c:	6105                	add	sp,sp,32
    8000076e:	b2ed                	j	80000158 <printf>
    80000770:	00002517          	auipc	a0,0x2
    80000774:	8e050513          	add	a0,a0,-1824 # 80002050 <digits+0x18>
    80000778:	9e1ff0ef          	jal	80000158 <printf>
    8000077c:	00002517          	auipc	a0,0x2
    80000780:	98c50513          	add	a0,a0,-1652 # 80002108 <digits+0xd0>
    80000784:	9d5ff0ef          	jal	80000158 <printf>
    80000788:	bf75                	j	80000744 <test_virtual_memory+0x104>
    8000078a:	00002517          	auipc	a0,0x2
    8000078e:	8c650513          	add	a0,a0,-1850 # 80002050 <digits+0x18>
    80000792:	9c7ff0ef          	jal	80000158 <printf>
    80000796:	00002517          	auipc	a0,0x2
    8000079a:	97250513          	add	a0,a0,-1678 # 80002108 <digits+0xd0>
    8000079e:	9bbff0ef          	jal	80000158 <printf>
    800007a2:	601c                	ld	a5,0(s0)
    800007a4:	8b89                	and	a5,a5,2
    800007a6:	f00794e3          	bnez	a5,800006ae <test_virtual_memory+0x6e>
    800007aa:	00002517          	auipc	a0,0x2
    800007ae:	8a650513          	add	a0,a0,-1882 # 80002050 <digits+0x18>
    800007b2:	9a7ff0ef          	jal	80000158 <printf>
    800007b6:	00002517          	auipc	a0,0x2
    800007ba:	95250513          	add	a0,a0,-1710 # 80002108 <digits+0xd0>
    800007be:	99bff0ef          	jal	80000158 <printf>
    800007c2:	601c                	ld	a5,0(s0)
    800007c4:	8ba1                	and	a5,a5,8
    800007c6:	f00794e3          	bnez	a5,800006ce <test_virtual_memory+0x8e>
    800007ca:	00002517          	auipc	a0,0x2
    800007ce:	88650513          	add	a0,a0,-1914 # 80002050 <digits+0x18>
    800007d2:	987ff0ef          	jal	80000158 <printf>
    800007d6:	00002517          	auipc	a0,0x2
    800007da:	93250513          	add	a0,a0,-1742 # 80002108 <digits+0xd0>
    800007de:	97bff0ef          	jal	80000158 <printf>
    800007e2:	601c                	ld	a5,0(s0)
    800007e4:	8b91                	and	a5,a5,4
    800007e6:	f00784e3          	beqz	a5,800006ee <test_virtual_memory+0xae>
    800007ea:	00002517          	auipc	a0,0x2
    800007ee:	86650513          	add	a0,a0,-1946 # 80002050 <digits+0x18>
    800007f2:	967ff0ef          	jal	80000158 <printf>
    800007f6:	00002517          	auipc	a0,0x2
    800007fa:	91250513          	add	a0,a0,-1774 # 80002108 <digits+0xd0>
    800007fe:	95bff0ef          	jal	80000158 <printf>
    80000802:	b711                	j	80000706 <test_virtual_memory+0xc6>

0000000080000804 <pmm_init>:
    80000804:	7179                	add	sp,sp,-48
    80000806:	77fd                	lui	a5,0xfffff
    80000808:	f022                	sd	s0,32(sp)
    8000080a:	00007417          	auipc	s0,0x7
    8000080e:	18540413          	add	s0,s0,389 # 8000798f <__bss_end+0xfff>
    80000812:	8c7d                	and	s0,s0,a5
    80000814:	e84a                	sd	s2,16(sp)
    80000816:	6785                	lui	a5,0x1
    80000818:	4945                	li	s2,17
    8000081a:	f406                	sd	ra,40(sp)
    8000081c:	ec26                	sd	s1,24(sp)
    8000081e:	e44e                	sd	s3,8(sp)
    80000820:	e052                	sd	s4,0(sp)
    80000822:	97a2                	add	a5,a5,s0
    80000824:	096e                	sll	s2,s2,0x1b
    80000826:	04f96163          	bltu	s2,a5,80000868 <pmm_init+0x64>
    8000082a:	00006a17          	auipc	s4,0x6
    8000082e:	166a0a13          	add	s4,s4,358 # 80006990 <__bss_end>
    80000832:	00002497          	auipc	s1,0x2
    80000836:	dc648493          	add	s1,s1,-570 # 800025f8 <fmem>
    8000083a:	00002997          	auipc	s3,0x2
    8000083e:	8d698993          	add	s3,s3,-1834 # 80002110 <digits+0xd8>
    80000842:	854e                	mv	a0,s3
    80000844:	01446463          	bltu	s0,s4,8000084c <pmm_init+0x48>
    80000848:	01246463          	bltu	s0,s2,80000850 <pmm_init+0x4c>
    8000084c:	b0bff0ef          	jal	80000356 <panic>
    80000850:	8522                	mv	a0,s0
    80000852:	6605                	lui	a2,0x1
    80000854:	4585                	li	a1,1
    80000856:	606000ef          	jal	80000e5c <memset>
    8000085a:	609c                	ld	a5,0(s1)
    8000085c:	e01c                	sd	a5,0(s0)
    8000085e:	6785                	lui	a5,0x1
    80000860:	e080                	sd	s0,0(s1)
    80000862:	943e                	add	s0,s0,a5
    80000864:	fd241fe3          	bne	s0,s2,80000842 <pmm_init+0x3e>
    80000868:	70a2                	ld	ra,40(sp)
    8000086a:	7402                	ld	s0,32(sp)
    8000086c:	64e2                	ld	s1,24(sp)
    8000086e:	6942                	ld	s2,16(sp)
    80000870:	69a2                	ld	s3,8(sp)
    80000872:	6a02                	ld	s4,0(sp)
    80000874:	6145                	add	sp,sp,48
    80000876:	8082                	ret

0000000080000878 <freerange>:
    80000878:	6785                	lui	a5,0x1
    8000087a:	7139                	add	sp,sp,-64
    8000087c:	fff78713          	add	a4,a5,-1 # fff <userret+0xf63>
    80000880:	f822                	sd	s0,48(sp)
    80000882:	00e50433          	add	s0,a0,a4
    80000886:	777d                	lui	a4,0xfffff
    80000888:	8c79                	and	s0,s0,a4
    8000088a:	fc06                	sd	ra,56(sp)
    8000088c:	f426                	sd	s1,40(sp)
    8000088e:	f04a                	sd	s2,32(sp)
    80000890:	ec4e                	sd	s3,24(sp)
    80000892:	e852                	sd	s4,16(sp)
    80000894:	e456                	sd	s5,8(sp)
    80000896:	e05a                	sd	s6,0(sp)
    80000898:	97a2                	add	a5,a5,s0
    8000089a:	04f5e763          	bltu	a1,a5,800008e8 <freerange+0x70>
    8000089e:	4b45                	li	s6,17
    800008a0:	892e                	mv	s2,a1
    800008a2:	00006a97          	auipc	s5,0x6
    800008a6:	0eea8a93          	add	s5,s5,238 # 80006990 <__bss_end>
    800008aa:	00002497          	auipc	s1,0x2
    800008ae:	d4e48493          	add	s1,s1,-690 # 800025f8 <fmem>
    800008b2:	00002a17          	auipc	s4,0x2
    800008b6:	85ea0a13          	add	s4,s4,-1954 # 80002110 <digits+0xd8>
    800008ba:	0b6e                	sll	s6,s6,0x1b
    800008bc:	6989                	lui	s3,0x2
    800008be:	8552                	mv	a0,s4
    800008c0:	01546463          	bltu	s0,s5,800008c8 <freerange+0x50>
    800008c4:	01646463          	bltu	s0,s6,800008cc <freerange+0x54>
    800008c8:	a8fff0ef          	jal	80000356 <panic>
    800008cc:	8522                	mv	a0,s0
    800008ce:	6605                	lui	a2,0x1
    800008d0:	4585                	li	a1,1
    800008d2:	58a000ef          	jal	80000e5c <memset>
    800008d6:	6098                	ld	a4,0(s1)
    800008d8:	013407b3          	add	a5,s0,s3
    800008dc:	e018                	sd	a4,0(s0)
    800008de:	e080                	sd	s0,0(s1)
    800008e0:	6705                	lui	a4,0x1
    800008e2:	943a                	add	s0,s0,a4
    800008e4:	fcf97de3          	bgeu	s2,a5,800008be <freerange+0x46>
    800008e8:	70e2                	ld	ra,56(sp)
    800008ea:	7442                	ld	s0,48(sp)
    800008ec:	74a2                	ld	s1,40(sp)
    800008ee:	7902                	ld	s2,32(sp)
    800008f0:	69e2                	ld	s3,24(sp)
    800008f2:	6a42                	ld	s4,16(sp)
    800008f4:	6aa2                	ld	s5,8(sp)
    800008f6:	6b02                	ld	s6,0(sp)
    800008f8:	6121                	add	sp,sp,64
    800008fa:	8082                	ret

00000000800008fc <free_page>:
    800008fc:	1141                	add	sp,sp,-16
    800008fe:	e022                	sd	s0,0(sp)
    80000900:	e406                	sd	ra,8(sp)
    80000902:	03451793          	sll	a5,a0,0x34
    80000906:	842a                	mv	s0,a0
    80000908:	e799                	bnez	a5,80000916 <free_page+0x1a>
    8000090a:	00006797          	auipc	a5,0x6
    8000090e:	08678793          	add	a5,a5,134 # 80006990 <__bss_end>
    80000912:	02f57863          	bgeu	a0,a5,80000942 <free_page+0x46>
    80000916:	00001517          	auipc	a0,0x1
    8000091a:	7fa50513          	add	a0,a0,2042 # 80002110 <digits+0xd8>
    8000091e:	a39ff0ef          	jal	80000356 <panic>
    80000922:	8522                	mv	a0,s0
    80000924:	6605                	lui	a2,0x1
    80000926:	4585                	li	a1,1
    80000928:	534000ef          	jal	80000e5c <memset>
    8000092c:	00002797          	auipc	a5,0x2
    80000930:	ccc78793          	add	a5,a5,-820 # 800025f8 <fmem>
    80000934:	6398                	ld	a4,0(a5)
    80000936:	60a2                	ld	ra,8(sp)
    80000938:	e018                	sd	a4,0(s0)
    8000093a:	e380                	sd	s0,0(a5)
    8000093c:	6402                	ld	s0,0(sp)
    8000093e:	0141                	add	sp,sp,16
    80000940:	8082                	ret
    80000942:	47c5                	li	a5,17
    80000944:	07ee                	sll	a5,a5,0x1b
    80000946:	fcf56ee3          	bltu	a0,a5,80000922 <free_page+0x26>
    8000094a:	b7f1                	j	80000916 <free_page+0x1a>

000000008000094c <alloc_page>:
    8000094c:	1141                	add	sp,sp,-16
    8000094e:	00002797          	auipc	a5,0x2
    80000952:	caa78793          	add	a5,a5,-854 # 800025f8 <fmem>
    80000956:	e022                	sd	s0,0(sp)
    80000958:	6380                	ld	s0,0(a5)
    8000095a:	e406                	sd	ra,8(sp)
    8000095c:	c801                	beqz	s0,8000096c <alloc_page+0x20>
    8000095e:	6018                	ld	a4,0(s0)
    80000960:	6605                	lui	a2,0x1
    80000962:	4595                	li	a1,5
    80000964:	8522                	mv	a0,s0
    80000966:	e398                	sd	a4,0(a5)
    80000968:	4f4000ef          	jal	80000e5c <memset>
    8000096c:	60a2                	ld	ra,8(sp)
    8000096e:	8522                	mv	a0,s0
    80000970:	6402                	ld	s0,0(sp)
    80000972:	0141                	add	sp,sp,16
    80000974:	8082                	ret

0000000080000976 <kvminithart>:
    80000976:	12000073          	sfence.vma
    8000097a:	00002797          	auipc	a5,0x2
    8000097e:	c867b783          	ld	a5,-890(a5) # 80002600 <kernel_pagetable>
    80000982:	577d                	li	a4,-1
    80000984:	177e                	sll	a4,a4,0x3f
    80000986:	83b1                	srl	a5,a5,0xc
    80000988:	8fd9                	or	a5,a5,a4
    8000098a:	18079073          	csrw	satp,a5
    8000098e:	12000073          	sfence.vma
    80000992:	8082                	ret

0000000080000994 <walk>:
    80000994:	7139                	add	sp,sp,-64
    80000996:	57fd                	li	a5,-1
    80000998:	f426                	sd	s1,40(sp)
    8000099a:	f04a                	sd	s2,32(sp)
    8000099c:	e852                	sd	s4,16(sp)
    8000099e:	fc06                	sd	ra,56(sp)
    800009a0:	f822                	sd	s0,48(sp)
    800009a2:	ec4e                	sd	s3,24(sp)
    800009a4:	e456                	sd	s5,8(sp)
    800009a6:	83e9                	srl	a5,a5,0x1a
    800009a8:	8a2e                	mv	s4,a1
    800009aa:	84aa                	mv	s1,a0
    800009ac:	8932                	mv	s2,a2
    800009ae:	06b7ea63          	bltu	a5,a1,80000a22 <walk+0x8e>
    800009b2:	4a89                	li	s5,2
    800009b4:	4789                	li	a5,2
    800009b6:	4985                	li	s3,1
    800009b8:	0037941b          	sllw	s0,a5,0x3
    800009bc:	9c3d                	addw	s0,s0,a5
    800009be:	2431                	addw	s0,s0,12
    800009c0:	008a5433          	srl	s0,s4,s0
    800009c4:	1ff47413          	and	s0,s0,511
    800009c8:	040e                	sll	s0,s0,0x3
    800009ca:	9426                	add	s0,s0,s1
    800009cc:	6004                	ld	s1,0(s0)
    800009ce:	0014f793          	and	a5,s1,1
    800009d2:	80a9                	srl	s1,s1,0xa
    800009d4:	04b2                	sll	s1,s1,0xc
    800009d6:	e38d                	bnez	a5,800009f8 <walk+0x64>
    800009d8:	04090c63          	beqz	s2,80000a30 <walk+0x9c>
    800009dc:	f71ff0ef          	jal	8000094c <alloc_page>
    800009e0:	6605                	lui	a2,0x1
    800009e2:	4581                	li	a1,0
    800009e4:	84aa                	mv	s1,a0
    800009e6:	c529                	beqz	a0,80000a30 <walk+0x9c>
    800009e8:	474000ef          	jal	80000e5c <memset>
    800009ec:	00c4d793          	srl	a5,s1,0xc
    800009f0:	07aa                	sll	a5,a5,0xa
    800009f2:	0017e793          	or	a5,a5,1
    800009f6:	e01c                	sd	a5,0(s0)
    800009f8:	4785                	li	a5,1
    800009fa:	013a8463          	beq	s5,s3,80000a02 <walk+0x6e>
    800009fe:	4a85                	li	s5,1
    80000a00:	bf65                	j	800009b8 <walk+0x24>
    80000a02:	00ca5a13          	srl	s4,s4,0xc
    80000a06:	1ffa7a13          	and	s4,s4,511
    80000a0a:	0a0e                	sll	s4,s4,0x3
    80000a0c:	01448533          	add	a0,s1,s4
    80000a10:	70e2                	ld	ra,56(sp)
    80000a12:	7442                	ld	s0,48(sp)
    80000a14:	74a2                	ld	s1,40(sp)
    80000a16:	7902                	ld	s2,32(sp)
    80000a18:	69e2                	ld	s3,24(sp)
    80000a1a:	6a42                	ld	s4,16(sp)
    80000a1c:	6aa2                	ld	s5,8(sp)
    80000a1e:	6121                	add	sp,sp,64
    80000a20:	8082                	ret
    80000a22:	00001517          	auipc	a0,0x1
    80000a26:	6f650513          	add	a0,a0,1782 # 80002118 <digits+0xe0>
    80000a2a:	92dff0ef          	jal	80000356 <panic>
    80000a2e:	b751                	j	800009b2 <walk+0x1e>
    80000a30:	4501                	li	a0,0
    80000a32:	bff9                	j	80000a10 <walk+0x7c>

0000000080000a34 <mappages>:
    80000a34:	6785                	lui	a5,0x1
    80000a36:	715d                	add	sp,sp,-80
    80000a38:	17fd                	add	a5,a5,-1 # fff <userret+0xf63>
    80000a3a:	e0a2                	sd	s0,64(sp)
    80000a3c:	fc26                	sd	s1,56(sp)
    80000a3e:	f84a                	sd	s2,48(sp)
    80000a40:	f44e                	sd	s3,40(sp)
    80000a42:	f052                	sd	s4,32(sp)
    80000a44:	89b6                	mv	s3,a3
    80000a46:	ec56                	sd	s5,24(sp)
    80000a48:	e85a                	sd	s6,16(sp)
    80000a4a:	e486                	sd	ra,72(sp)
    80000a4c:	e45e                	sd	s7,8(sp)
    80000a4e:	e062                	sd	s8,0(sp)
    80000a50:	00f676b3          	and	a3,a2,a5
    80000a54:	8932                	mv	s2,a2
    80000a56:	84ae                	mv	s1,a1
    80000a58:	8a2a                	mv	s4,a0
    80000a5a:	8aba                	mv	s5,a4
    80000a5c:	00f5fb33          	and	s6,a1,a5
    80000a60:	00f9f433          	and	s0,s3,a5
    80000a64:	ea8d                	bnez	a3,80000a96 <mappages+0x62>
    80000a66:	0a0b1063          	bnez	s6,80000b06 <mappages+0xd2>
    80000a6a:	e449                	bnez	s0,80000af4 <mappages+0xc0>
    80000a6c:	02091e63          	bnez	s2,80000aa8 <mappages+0x74>
    80000a70:	00001517          	auipc	a0,0x1
    80000a74:	72050513          	add	a0,a0,1824 # 80002190 <digits+0x158>
    80000a78:	8dfff0ef          	jal	80000356 <panic>
    80000a7c:	4501                	li	a0,0
    80000a7e:	60a6                	ld	ra,72(sp)
    80000a80:	6406                	ld	s0,64(sp)
    80000a82:	74e2                	ld	s1,56(sp)
    80000a84:	7942                	ld	s2,48(sp)
    80000a86:	79a2                	ld	s3,40(sp)
    80000a88:	7a02                	ld	s4,32(sp)
    80000a8a:	6ae2                	ld	s5,24(sp)
    80000a8c:	6b42                	ld	s6,16(sp)
    80000a8e:	6ba2                	ld	s7,8(sp)
    80000a90:	6c02                	ld	s8,0(sp)
    80000a92:	6161                	add	sp,sp,80
    80000a94:	8082                	ret
    80000a96:	00001517          	auipc	a0,0x1
    80000a9a:	6aa50513          	add	a0,a0,1706 # 80002140 <digits+0x108>
    80000a9e:	8b9ff0ef          	jal	80000356 <panic>
    80000aa2:	060b1c63          	bnez	s6,80000b1a <mappages+0xe6>
    80000aa6:	e049                	bnez	s0,80000b28 <mappages+0xf4>
    80000aa8:	9926                	add	s2,s2,s1
    80000aaa:	8c26                	mv	s8,s1
    80000aac:	409989b3          	sub	s3,s3,s1
    80000ab0:	00001b97          	auipc	s7,0x1
    80000ab4:	6f8b8b93          	add	s7,s7,1784 # 800021a8 <digits+0x170>
    80000ab8:	6b05                	lui	s6,0x1
    80000aba:	0124ec63          	bltu	s1,s2,80000ad2 <mappages+0x9e>
    80000abe:	bf7d                	j	80000a7c <mappages+0x48>
    80000ac0:	8031                	srl	s0,s0,0xc
    80000ac2:	042a                	sll	s0,s0,0xa
    80000ac4:	01546433          	or	s0,s0,s5
    80000ac8:	00146413          	or	s0,s0,1
    80000acc:	e080                	sd	s0,0(s1)
    80000ace:	fb2c77e3          	bgeu	s8,s2,80000a7c <mappages+0x48>
    80000ad2:	85e2                	mv	a1,s8
    80000ad4:	4605                	li	a2,1
    80000ad6:	8552                	mv	a0,s4
    80000ad8:	ebdff0ef          	jal	80000994 <walk>
    80000adc:	013c0433          	add	s0,s8,s3
    80000ae0:	84aa                	mv	s1,a0
    80000ae2:	9c5a                	add	s8,s8,s6
    80000ae4:	c90d                	beqz	a0,80000b16 <mappages+0xe2>
    80000ae6:	611c                	ld	a5,0(a0)
    80000ae8:	8b85                	and	a5,a5,1
    80000aea:	dbf9                	beqz	a5,80000ac0 <mappages+0x8c>
    80000aec:	855e                	mv	a0,s7
    80000aee:	869ff0ef          	jal	80000356 <panic>
    80000af2:	b7f9                	j	80000ac0 <mappages+0x8c>
    80000af4:	00001517          	auipc	a0,0x1
    80000af8:	68450513          	add	a0,a0,1668 # 80002178 <digits+0x140>
    80000afc:	85bff0ef          	jal	80000356 <panic>
    80000b00:	f60908e3          	beqz	s2,80000a70 <mappages+0x3c>
    80000b04:	b755                	j	80000aa8 <mappages+0x74>
    80000b06:	00001517          	auipc	a0,0x1
    80000b0a:	65a50513          	add	a0,a0,1626 # 80002160 <digits+0x128>
    80000b0e:	849ff0ef          	jal	80000356 <panic>
    80000b12:	dc29                	beqz	s0,80000a6c <mappages+0x38>
    80000b14:	b7c5                	j	80000af4 <mappages+0xc0>
    80000b16:	557d                	li	a0,-1
    80000b18:	b79d                	j	80000a7e <mappages+0x4a>
    80000b1a:	00001517          	auipc	a0,0x1
    80000b1e:	64650513          	add	a0,a0,1606 # 80002160 <digits+0x128>
    80000b22:	835ff0ef          	jal	80000356 <panic>
    80000b26:	d049                	beqz	s0,80000aa8 <mappages+0x74>
    80000b28:	00001517          	auipc	a0,0x1
    80000b2c:	65050513          	add	a0,a0,1616 # 80002178 <digits+0x140>
    80000b30:	827ff0ef          	jal	80000356 <panic>
    80000b34:	bf95                	j	80000aa8 <mappages+0x74>

0000000080000b36 <kernel_map>:
    80000b36:	87b2                	mv	a5,a2
    80000b38:	1141                	add	sp,sp,-16
    80000b3a:	8636                	mv	a2,a3
    80000b3c:	86be                	mv	a3,a5
    80000b3e:	e406                	sd	ra,8(sp)
    80000b40:	ef5ff0ef          	jal	80000a34 <mappages>
    80000b44:	e501                	bnez	a0,80000b4c <kernel_map+0x16>
    80000b46:	60a2                	ld	ra,8(sp)
    80000b48:	0141                	add	sp,sp,16
    80000b4a:	8082                	ret
    80000b4c:	60a2                	ld	ra,8(sp)
    80000b4e:	00001517          	auipc	a0,0x1
    80000b52:	66a50513          	add	a0,a0,1642 # 800021b8 <digits+0x180>
    80000b56:	0141                	add	sp,sp,16
    80000b58:	ffeff06f          	j	80000356 <panic>

0000000080000b5c <create_pagetable>:
    80000b5c:	1141                	add	sp,sp,-16
    80000b5e:	e406                	sd	ra,8(sp)
    80000b60:	e022                	sd	s0,0(sp)
    80000b62:	debff0ef          	jal	8000094c <alloc_page>
    80000b66:	6605                	lui	a2,0x1
    80000b68:	4581                	li	a1,0
    80000b6a:	842a                	mv	s0,a0
    80000b6c:	2f0000ef          	jal	80000e5c <memset>
    80000b70:	4719                	li	a4,6
    80000b72:	100006b7          	lui	a3,0x10000
    80000b76:	6605                	lui	a2,0x1
    80000b78:	100005b7          	lui	a1,0x10000
    80000b7c:	8522                	mv	a0,s0
    80000b7e:	eb7ff0ef          	jal	80000a34 <mappages>
    80000b82:	e545                	bnez	a0,80000c2a <create_pagetable+0xce>
    80000b84:	00001517          	auipc	a0,0x1
    80000b88:	65450513          	add	a0,a0,1620 # 800021d8 <digits+0x1a0>
    80000b8c:	dccff0ef          	jal	80000158 <printf>
    80000b90:	4719                	li	a4,6
    80000b92:	100016b7          	lui	a3,0x10001
    80000b96:	6605                	lui	a2,0x1
    80000b98:	100015b7          	lui	a1,0x10001
    80000b9c:	8522                	mv	a0,s0
    80000b9e:	e97ff0ef          	jal	80000a34 <mappages>
    80000ba2:	0c051a63          	bnez	a0,80000c76 <create_pagetable+0x11a>
    80000ba6:	00001517          	auipc	a0,0x1
    80000baa:	64250513          	add	a0,a0,1602 # 800021e8 <digits+0x1b0>
    80000bae:	daaff0ef          	jal	80000158 <printf>
    80000bb2:	4719                	li	a4,6
    80000bb4:	0c0006b7          	lui	a3,0xc000
    80000bb8:	00400637          	lui	a2,0x400
    80000bbc:	0c0005b7          	lui	a1,0xc000
    80000bc0:	8522                	mv	a0,s0
    80000bc2:	e73ff0ef          	jal	80000a34 <mappages>
    80000bc6:	e14d                	bnez	a0,80000c68 <create_pagetable+0x10c>
    80000bc8:	00001517          	auipc	a0,0x1
    80000bcc:	63050513          	add	a0,a0,1584 # 800021f8 <digits+0x1c0>
    80000bd0:	d88ff0ef          	jal	80000158 <printf>
    80000bd4:	4685                	li	a3,1
    80000bd6:	06fe                	sll	a3,a3,0x1f
    80000bd8:	4729                	li	a4,10
    80000bda:	80001617          	auipc	a2,0x80001
    80000bde:	42660613          	add	a2,a2,1062 # 2000 <userret+0x1f64>
    80000be2:	85b6                	mv	a1,a3
    80000be4:	8522                	mv	a0,s0
    80000be6:	e4fff0ef          	jal	80000a34 <mappages>
    80000bea:	e925                	bnez	a0,80000c5a <create_pagetable+0xfe>
    80000bec:	00001517          	auipc	a0,0x1
    80000bf0:	61c50513          	add	a0,a0,1564 # 80002208 <digits+0x1d0>
    80000bf4:	d64ff0ef          	jal	80000158 <printf>
    80000bf8:	47c5                	li	a5,17
    80000bfa:	00001697          	auipc	a3,0x1
    80000bfe:	40668693          	add	a3,a3,1030 # 80002000 <etext>
    80000c02:	07ee                	sll	a5,a5,0x1b
    80000c04:	4719                	li	a4,6
    80000c06:	40d78633          	sub	a2,a5,a3
    80000c0a:	85b6                	mv	a1,a3
    80000c0c:	8522                	mv	a0,s0
    80000c0e:	e27ff0ef          	jal	80000a34 <mappages>
    80000c12:	e11d                	bnez	a0,80000c38 <create_pagetable+0xdc>
    80000c14:	00001517          	auipc	a0,0x1
    80000c18:	60c50513          	add	a0,a0,1548 # 80002220 <digits+0x1e8>
    80000c1c:	d3cff0ef          	jal	80000158 <printf>
    80000c20:	60a2                	ld	ra,8(sp)
    80000c22:	8522                	mv	a0,s0
    80000c24:	6402                	ld	s0,0(sp)
    80000c26:	0141                	add	sp,sp,16
    80000c28:	8082                	ret
    80000c2a:	00001517          	auipc	a0,0x1
    80000c2e:	58e50513          	add	a0,a0,1422 # 800021b8 <digits+0x180>
    80000c32:	f24ff0ef          	jal	80000356 <panic>
    80000c36:	b7b9                	j	80000b84 <create_pagetable+0x28>
    80000c38:	00001517          	auipc	a0,0x1
    80000c3c:	58050513          	add	a0,a0,1408 # 800021b8 <digits+0x180>
    80000c40:	f16ff0ef          	jal	80000356 <panic>
    80000c44:	00001517          	auipc	a0,0x1
    80000c48:	5dc50513          	add	a0,a0,1500 # 80002220 <digits+0x1e8>
    80000c4c:	d0cff0ef          	jal	80000158 <printf>
    80000c50:	60a2                	ld	ra,8(sp)
    80000c52:	8522                	mv	a0,s0
    80000c54:	6402                	ld	s0,0(sp)
    80000c56:	0141                	add	sp,sp,16
    80000c58:	8082                	ret
    80000c5a:	00001517          	auipc	a0,0x1
    80000c5e:	55e50513          	add	a0,a0,1374 # 800021b8 <digits+0x180>
    80000c62:	ef4ff0ef          	jal	80000356 <panic>
    80000c66:	b759                	j	80000bec <create_pagetable+0x90>
    80000c68:	00001517          	auipc	a0,0x1
    80000c6c:	55050513          	add	a0,a0,1360 # 800021b8 <digits+0x180>
    80000c70:	ee6ff0ef          	jal	80000356 <panic>
    80000c74:	bf91                	j	80000bc8 <create_pagetable+0x6c>
    80000c76:	00001517          	auipc	a0,0x1
    80000c7a:	54250513          	add	a0,a0,1346 # 800021b8 <digits+0x180>
    80000c7e:	ed8ff0ef          	jal	80000356 <panic>
    80000c82:	b715                	j	80000ba6 <create_pagetable+0x4a>

0000000080000c84 <kvminit>:
    80000c84:	1141                	add	sp,sp,-16
    80000c86:	e406                	sd	ra,8(sp)
    80000c88:	ed5ff0ef          	jal	80000b5c <create_pagetable>
    80000c8c:	60a2                	ld	ra,8(sp)
    80000c8e:	00002797          	auipc	a5,0x2
    80000c92:	96a7b923          	sd	a0,-1678(a5) # 80002600 <kernel_pagetable>
    80000c96:	0141                	add	sp,sp,16
    80000c98:	8082                	ret

0000000080000c9a <create_user_pagetable>:
    80000c9a:	1141                	add	sp,sp,-16
    80000c9c:	e022                	sd	s0,0(sp)
    80000c9e:	e406                	sd	ra,8(sp)
    80000ca0:	cadff0ef          	jal	8000094c <alloc_page>
    80000ca4:	842a                	mv	s0,a0
    80000ca6:	c509                	beqz	a0,80000cb0 <create_user_pagetable+0x16>
    80000ca8:	6605                	lui	a2,0x1
    80000caa:	4581                	li	a1,0
    80000cac:	1b0000ef          	jal	80000e5c <memset>
    80000cb0:	60a2                	ld	ra,8(sp)
    80000cb2:	8522                	mv	a0,s0
    80000cb4:	6402                	ld	s0,0(sp)
    80000cb6:	0141                	add	sp,sp,16
    80000cb8:	8082                	ret

0000000080000cba <remove_user_mappings>:
    80000cba:	7139                	add	sp,sp,-64
    80000cbc:	f426                	sd	s1,40(sp)
    80000cbe:	f04a                	sd	s2,32(sp)
    80000cc0:	ec4e                	sd	s3,24(sp)
    80000cc2:	e456                	sd	s5,8(sp)
    80000cc4:	fc06                	sd	ra,56(sp)
    80000cc6:	f822                	sd	s0,48(sp)
    80000cc8:	e852                	sd	s4,16(sp)
    80000cca:	03459793          	sll	a5,a1,0x34
    80000cce:	84ae                	mv	s1,a1
    80000cd0:	89aa                	mv	s3,a0
    80000cd2:	8932                	mv	s2,a2
    80000cd4:	8ab6                	mv	s5,a3
    80000cd6:	eba9                	bnez	a5,80000d28 <remove_user_mappings+0x6e>
    80000cd8:	0932                	sll	s2,s2,0xc
    80000cda:	9926                	add	s2,s2,s1
    80000cdc:	0324f563          	bgeu	s1,s2,80000d06 <remove_user_mappings+0x4c>
    80000ce0:	6a05                	lui	s4,0x1
    80000ce2:	85a6                	mv	a1,s1
    80000ce4:	4601                	li	a2,0
    80000ce6:	854e                	mv	a0,s3
    80000ce8:	cadff0ef          	jal	80000994 <walk>
    80000cec:	842a                	mv	s0,a0
    80000cee:	94d2                	add	s1,s1,s4
    80000cf0:	c909                	beqz	a0,80000d02 <remove_user_mappings+0x48>
    80000cf2:	611c                	ld	a5,0(a0)
    80000cf4:	0017f713          	and	a4,a5,1
    80000cf8:	c709                	beqz	a4,80000d02 <remove_user_mappings+0x48>
    80000cfa:	000a9f63          	bnez	s5,80000d18 <remove_user_mappings+0x5e>
    80000cfe:	00043023          	sd	zero,0(s0)
    80000d02:	ff24e0e3          	bltu	s1,s2,80000ce2 <remove_user_mappings+0x28>
    80000d06:	70e2                	ld	ra,56(sp)
    80000d08:	7442                	ld	s0,48(sp)
    80000d0a:	74a2                	ld	s1,40(sp)
    80000d0c:	7902                	ld	s2,32(sp)
    80000d0e:	69e2                	ld	s3,24(sp)
    80000d10:	6a42                	ld	s4,16(sp)
    80000d12:	6aa2                	ld	s5,8(sp)
    80000d14:	6121                	add	sp,sp,64
    80000d16:	8082                	ret
    80000d18:	83a9                	srl	a5,a5,0xa
    80000d1a:	00c79513          	sll	a0,a5,0xc
    80000d1e:	bdfff0ef          	jal	800008fc <free_page>
    80000d22:	00043023          	sd	zero,0(s0)
    80000d26:	bff1                	j	80000d02 <remove_user_mappings+0x48>
    80000d28:	00001517          	auipc	a0,0x1
    80000d2c:	52050513          	add	a0,a0,1312 # 80002248 <digits+0x210>
    80000d30:	e26ff0ef          	jal	80000356 <panic>
    80000d34:	b755                	j	80000cd8 <remove_user_mappings+0x1e>

0000000080000d36 <free_walk>:
    80000d36:	7179                	add	sp,sp,-48
    80000d38:	ec26                	sd	s1,24(sp)
    80000d3a:	6485                	lui	s1,0x1
    80000d3c:	f022                	sd	s0,32(sp)
    80000d3e:	e84a                	sd	s2,16(sp)
    80000d40:	e44e                	sd	s3,8(sp)
    80000d42:	e052                	sd	s4,0(sp)
    80000d44:	f406                	sd	ra,40(sp)
    80000d46:	8a2a                	mv	s4,a0
    80000d48:	842a                	mv	s0,a0
    80000d4a:	94aa                	add	s1,s1,a0
    80000d4c:	4905                	li	s2,1
    80000d4e:	00001997          	auipc	s3,0x1
    80000d52:	52a98993          	add	s3,s3,1322 # 80002278 <digits+0x240>
    80000d56:	a021                	j	80000d5e <free_walk+0x28>
    80000d58:	0421                	add	s0,s0,8
    80000d5a:	02940063          	beq	s0,s1,80000d7a <free_walk+0x44>
    80000d5e:	601c                	ld	a5,0(s0)
    80000d60:	00f7f713          	and	a4,a5,15
    80000d64:	0017f693          	and	a3,a5,1
    80000d68:	03270263          	beq	a4,s2,80000d8c <free_walk+0x56>
    80000d6c:	d6f5                	beqz	a3,80000d58 <free_walk+0x22>
    80000d6e:	854e                	mv	a0,s3
    80000d70:	0421                	add	s0,s0,8
    80000d72:	de4ff0ef          	jal	80000356 <panic>
    80000d76:	fe9414e3          	bne	s0,s1,80000d5e <free_walk+0x28>
    80000d7a:	7402                	ld	s0,32(sp)
    80000d7c:	70a2                	ld	ra,40(sp)
    80000d7e:	64e2                	ld	s1,24(sp)
    80000d80:	6942                	ld	s2,16(sp)
    80000d82:	69a2                	ld	s3,8(sp)
    80000d84:	8552                	mv	a0,s4
    80000d86:	6a02                	ld	s4,0(sp)
    80000d88:	6145                	add	sp,sp,48
    80000d8a:	be8d                	j	800008fc <free_page>
    80000d8c:	83a9                	srl	a5,a5,0xa
    80000d8e:	00c79513          	sll	a0,a5,0xc
    80000d92:	fa5ff0ef          	jal	80000d36 <free_walk>
    80000d96:	00043023          	sd	zero,0(s0)
    80000d9a:	bf7d                	j	80000d58 <free_walk+0x22>

0000000080000d9c <free_user_pagetable>:
    80000d9c:	1141                	add	sp,sp,-16
    80000d9e:	e022                	sd	s0,0(sp)
    80000da0:	e406                	sd	ra,8(sp)
    80000da2:	842a                	mv	s0,a0
    80000da4:	e591                	bnez	a1,80000db0 <free_user_pagetable+0x14>
    80000da6:	8522                	mv	a0,s0
    80000da8:	6402                	ld	s0,0(sp)
    80000daa:	60a2                	ld	ra,8(sp)
    80000dac:	0141                	add	sp,sp,16
    80000dae:	b761                	j	80000d36 <free_walk>
    80000db0:	6785                	lui	a5,0x1
    80000db2:	17fd                	add	a5,a5,-1 # fff <userret+0xf63>
    80000db4:	95be                	add	a1,a1,a5
    80000db6:	00c5d613          	srl	a2,a1,0xc
    80000dba:	4685                	li	a3,1
    80000dbc:	4581                	li	a1,0
    80000dbe:	efdff0ef          	jal	80000cba <remove_user_mappings>
    80000dc2:	8522                	mv	a0,s0
    80000dc4:	6402                	ld	s0,0(sp)
    80000dc6:	60a2                	ld	ra,8(sp)
    80000dc8:	0141                	add	sp,sp,16
    80000dca:	b7b5                	j	80000d36 <free_walk>

0000000080000dcc <copy_user_memory>:
    80000dcc:	c651                	beqz	a2,80000e58 <copy_user_memory+0x8c>
    80000dce:	7139                	add	sp,sp,-64
    80000dd0:	f822                	sd	s0,48(sp)
    80000dd2:	f04a                	sd	s2,32(sp)
    80000dd4:	ec4e                	sd	s3,24(sp)
    80000dd6:	e852                	sd	s4,16(sp)
    80000dd8:	fc06                	sd	ra,56(sp)
    80000dda:	f426                	sd	s1,40(sp)
    80000ddc:	e456                	sd	s5,8(sp)
    80000dde:	8932                	mv	s2,a2
    80000de0:	89aa                	mv	s3,a0
    80000de2:	8a2e                	mv	s4,a1
    80000de4:	4401                	li	s0,0
    80000de6:	85a2                	mv	a1,s0
    80000de8:	4601                	li	a2,0
    80000dea:	854e                	mv	a0,s3
    80000dec:	ba9ff0ef          	jal	80000994 <walk>
    80000df0:	c915                	beqz	a0,80000e24 <copy_user_memory+0x58>
    80000df2:	611c                	ld	a5,0(a0)
    80000df4:	00a7d593          	srl	a1,a5,0xa
    80000df8:	3ff7fa93          	and	s5,a5,1023
    80000dfc:	8b85                	and	a5,a5,1
    80000dfe:	00c59493          	sll	s1,a1,0xc
    80000e02:	c38d                	beqz	a5,80000e24 <copy_user_memory+0x58>
    80000e04:	b49ff0ef          	jal	8000094c <alloc_page>
    80000e08:	85a6                	mv	a1,s1
    80000e0a:	6605                	lui	a2,0x1
    80000e0c:	84aa                	mv	s1,a0
    80000e0e:	c90d                	beqz	a0,80000e40 <copy_user_memory+0x74>
    80000e10:	068000ef          	jal	80000e78 <memmove>
    80000e14:	8756                	mv	a4,s5
    80000e16:	86a6                	mv	a3,s1
    80000e18:	85a2                	mv	a1,s0
    80000e1a:	6605                	lui	a2,0x1
    80000e1c:	8552                	mv	a0,s4
    80000e1e:	c17ff0ef          	jal	80000a34 <mappages>
    80000e22:	ed19                	bnez	a0,80000e40 <copy_user_memory+0x74>
    80000e24:	6785                	lui	a5,0x1
    80000e26:	943e                	add	s0,s0,a5
    80000e28:	fb246fe3          	bltu	s0,s2,80000de6 <copy_user_memory+0x1a>
    80000e2c:	4501                	li	a0,0
    80000e2e:	70e2                	ld	ra,56(sp)
    80000e30:	7442                	ld	s0,48(sp)
    80000e32:	74a2                	ld	s1,40(sp)
    80000e34:	7902                	ld	s2,32(sp)
    80000e36:	69e2                	ld	s3,24(sp)
    80000e38:	6a42                	ld	s4,16(sp)
    80000e3a:	6aa2                	ld	s5,8(sp)
    80000e3c:	6121                	add	sp,sp,64
    80000e3e:	8082                	ret
    80000e40:	4685                	li	a3,1
    80000e42:	00c45613          	srl	a2,s0,0xc
    80000e46:	4581                	li	a1,0
    80000e48:	8552                	mv	a0,s4
    80000e4a:	e71ff0ef          	jal	80000cba <remove_user_mappings>
    80000e4e:	8552                	mv	a0,s4
    80000e50:	ee7ff0ef          	jal	80000d36 <free_walk>
    80000e54:	557d                	li	a0,-1
    80000e56:	bfe1                	j	80000e2e <copy_user_memory+0x62>
    80000e58:	4501                	li	a0,0
    80000e5a:	8082                	ret

0000000080000e5c <memset>:
    80000e5c:	ce09                	beqz	a2,80000e76 <memset+0x1a>
    80000e5e:	1602                	sll	a2,a2,0x20
    80000e60:	9201                	srl	a2,a2,0x20
    80000e62:	0ff5f593          	zext.b	a1,a1
    80000e66:	87aa                	mv	a5,a0
    80000e68:	00a60733          	add	a4,a2,a0
    80000e6c:	00b78023          	sb	a1,0(a5) # 1000 <userret+0xf64>
    80000e70:	0785                	add	a5,a5,1
    80000e72:	fee79de3          	bne	a5,a4,80000e6c <memset+0x10>
    80000e76:	8082                	ret

0000000080000e78 <memmove>:
    80000e78:	02b57063          	bgeu	a0,a1,80000e98 <memmove+0x20>
    80000e7c:	c239                	beqz	a2,80000ec2 <memmove+0x4a>
    80000e7e:	02061793          	sll	a5,a2,0x20
    80000e82:	9381                	srl	a5,a5,0x20
    80000e84:	97ae                	add	a5,a5,a1
    80000e86:	0005c703          	lbu	a4,0(a1) # c000000 <userret+0xbffff64>
    80000e8a:	0585                	add	a1,a1,1
    80000e8c:	0505                	add	a0,a0,1
    80000e8e:	fee50fa3          	sb	a4,-1(a0)
    80000e92:	fef59ae3          	bne	a1,a5,80000e86 <memmove+0xe>
    80000e96:	8082                	ret
    80000e98:	fff6079b          	addw	a5,a2,-1 # fff <userret+0xf63>
    80000e9c:	0007871b          	sext.w	a4,a5
    80000ea0:	02074163          	bltz	a4,80000ec2 <memmove+0x4a>
    80000ea4:	1782                	sll	a5,a5,0x20
    80000ea6:	9381                	srl	a5,a5,0x20
    80000ea8:	00f58733          	add	a4,a1,a5
    80000eac:	00074683          	lbu	a3,0(a4) # 1000 <userret+0xf64>
    80000eb0:	00f50733          	add	a4,a0,a5
    80000eb4:	17fd                	add	a5,a5,-1
    80000eb6:	00d70023          	sb	a3,0(a4)
    80000eba:	0007871b          	sext.w	a4,a5
    80000ebe:	fe0755e3          	bgez	a4,80000ea8 <memmove+0x30>
    80000ec2:	8082                	ret

0000000080000ec4 <safestrcpy>:
    80000ec4:	02c05863          	blez	a2,80000ef4 <safestrcpy+0x30>
    80000ec8:	4685                	li	a3,1
    80000eca:	fff6081b          	addw	a6,a2,-1
    80000ece:	872a                	mv	a4,a0
    80000ed0:	4781                	li	a5,0
    80000ed2:	00d61a63          	bne	a2,a3,80000ee6 <safestrcpy+0x22>
    80000ed6:	a02d                	j	80000f00 <safestrcpy+0x3c>
    80000ed8:	00d70023          	sb	a3,0(a4)
    80000edc:	0585                	add	a1,a1,1
    80000ede:	00160713          	add	a4,a2,1
    80000ee2:	01078a63          	beq	a5,a6,80000ef6 <safestrcpy+0x32>
    80000ee6:	0005c683          	lbu	a3,0(a1)
    80000eea:	2785                	addw	a5,a5,1
    80000eec:	863a                	mv	a2,a4
    80000eee:	f6ed                	bnez	a3,80000ed8 <safestrcpy+0x14>
    80000ef0:	00060023          	sb	zero,0(a2)
    80000ef4:	8082                	ret
    80000ef6:	00f50633          	add	a2,a0,a5
    80000efa:	00060023          	sb	zero,0(a2)
    80000efe:	bfdd                	j	80000ef4 <safestrcpy+0x30>
    80000f00:	862a                	mv	a2,a0
    80000f02:	00060023          	sb	zero,0(a2)
    80000f06:	b7fd                	j	80000ef4 <safestrcpy+0x30>

0000000080000f08 <start>:
    80000f08:	300027f3          	csrr	a5,mstatus
    80000f0c:	7779                	lui	a4,0xffffe
    80000f0e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <__bss_end+0xffffffff7fff7e6f>
    80000f12:	8ff9                	and	a5,a5,a4
    80000f14:	6705                	lui	a4,0x1
    80000f16:	80070713          	add	a4,a4,-2048 # 800 <userret+0x764>
    80000f1a:	8fd9                	or	a5,a5,a4
    80000f1c:	30079073          	csrw	mstatus,a5
    80000f20:	fffff797          	auipc	a5,0xfffff
    80000f24:	10e78793          	add	a5,a5,270 # 8000002e <main>
    80000f28:	34179073          	csrw	mepc,a5
    80000f2c:	4781                	li	a5,0
    80000f2e:	18079073          	csrw	satp,a5
    80000f32:	67c1                	lui	a5,0x10
    80000f34:	17fd                	add	a5,a5,-1 # ffff <userret+0xff63>
    80000f36:	30279073          	csrw	medeleg,a5
    80000f3a:	30379073          	csrw	mideleg,a5
    80000f3e:	104027f3          	csrr	a5,sie
    80000f42:	2207e793          	or	a5,a5,544
    80000f46:	10479073          	csrw	sie,a5
    80000f4a:	57fd                	li	a5,-1
    80000f4c:	00a7d713          	srl	a4,a5,0xa
    80000f50:	3b071073          	csrw	pmpaddr0,a4
    80000f54:	473d                	li	a4,15
    80000f56:	3a071073          	csrw	pmpcfg0,a4
    80000f5a:	30402773          	csrr	a4,mie
    80000f5e:	02076713          	or	a4,a4,32
    80000f62:	30471073          	csrw	mie,a4
    80000f66:	30a02773          	csrr	a4,0x30a
    80000f6a:	17fe                	sll	a5,a5,0x3f
    80000f6c:	8fd9                	or	a5,a5,a4
    80000f6e:	30a79073          	csrw	0x30a,a5
    80000f72:	306027f3          	csrr	a5,mcounteren
    80000f76:	0027e793          	or	a5,a5,2
    80000f7a:	30679073          	csrw	mcounteren,a5
    80000f7e:	c01027f3          	rdtime	a5
    80000f82:	000f4737          	lui	a4,0xf4
    80000f86:	24070713          	add	a4,a4,576 # f4240 <userret+0xf41a4>
    80000f8a:	97ba                	add	a5,a5,a4
    80000f8c:	14d79073          	csrw	stimecmp,a5
    80000f90:	30200073          	mret
    80000f94:	8082                	ret

0000000080000f96 <timerinit>:
    80000f96:	304027f3          	csrr	a5,mie
    80000f9a:	0207e793          	or	a5,a5,32
    80000f9e:	30479073          	csrw	mie,a5
    80000fa2:	30a027f3          	csrr	a5,0x30a
    80000fa6:	577d                	li	a4,-1
    80000fa8:	177e                	sll	a4,a4,0x3f
    80000faa:	8fd9                	or	a5,a5,a4
    80000fac:	30a79073          	csrw	0x30a,a5
    80000fb0:	306027f3          	csrr	a5,mcounteren
    80000fb4:	0027e793          	or	a5,a5,2
    80000fb8:	30679073          	csrw	mcounteren,a5
    80000fbc:	c01027f3          	rdtime	a5
    80000fc0:	000f4737          	lui	a4,0xf4
    80000fc4:	24070713          	add	a4,a4,576 # f4240 <userret+0xf41a4>
    80000fc8:	97ba                	add	a5,a5,a4
    80000fca:	14d79073          	csrw	stimecmp,a5
    80000fce:	8082                	ret

0000000080000fd0 <trap_init>:
    80000fd0:	00002797          	auipc	a5,0x2
    80000fd4:	64078793          	add	a5,a5,1600 # 80003610 <interrupt_table>
    80000fd8:	00002717          	auipc	a4,0x2
    80000fdc:	73870713          	add	a4,a4,1848 # 80003710 <cur_cpu>
    80000fe0:	0007b023          	sd	zero,0(a5)
    80000fe4:	07a1                	add	a5,a5,8
    80000fe6:	fee79de3          	bne	a5,a4,80000fe0 <trap_init+0x10>
    80000fea:	00000797          	auipc	a5,0x0
    80000fee:	33678793          	add	a5,a5,822 # 80001320 <kernelvec>
    80000ff2:	10579073          	csrw	stvec,a5
    80000ff6:	8082                	ret

0000000080000ff8 <register_interrupt>:
    80000ff8:	fff5071b          	addw	a4,a0,-1
    80000ffc:	47f9                	li	a5,30
    80000ffe:	00e7e963          	bltu	a5,a4,80001010 <register_interrupt+0x18>
    80001002:	050e                	sll	a0,a0,0x3
    80001004:	00002797          	auipc	a5,0x2
    80001008:	60c78793          	add	a5,a5,1548 # 80003610 <interrupt_table>
    8000100c:	97aa                	add	a5,a5,a0
    8000100e:	e38c                	sd	a1,0(a5)
    80001010:	8082                	ret

0000000080001012 <devintr>:
    80001012:	1141                	add	sp,sp,-16
    80001014:	e406                	sd	ra,8(sp)
    80001016:	e022                	sd	s0,0(sp)
    80001018:	14202473          	csrr	s0,scause
    8000101c:	00001517          	auipc	a0,0x1
    80001020:	28450513          	add	a0,a0,644 # 800022a0 <digits+0x268>
    80001024:	85a2                	mv	a1,s0
    80001026:	932ff0ef          	jal	80000158 <printf>
    8000102a:	57fd                	li	a5,-1
    8000102c:	17fe                	sll	a5,a5,0x3f
    8000102e:	00978713          	add	a4,a5,9
    80001032:	00e40a63          	beq	s0,a4,80001046 <devintr+0x34>
    80001036:	0795                	add	a5,a5,5
    80001038:	4501                	li	a0,0
    8000103a:	02f40d63          	beq	s0,a5,80001074 <devintr+0x62>
    8000103e:	60a2                	ld	ra,8(sp)
    80001040:	6402                	ld	s0,0(sp)
    80001042:	0141                	add	sp,sp,16
    80001044:	8082                	ret
    80001046:	2c6000ef          	jal	8000130c <plic_claim>
    8000104a:	fff5071b          	addw	a4,a0,-1
    8000104e:	47f9                	li	a5,30
    80001050:	842a                	mv	s0,a0
    80001052:	02e7ee63          	bltu	a5,a4,8000108e <devintr+0x7c>
    80001056:	00351713          	sll	a4,a0,0x3
    8000105a:	00002797          	auipc	a5,0x2
    8000105e:	5b678793          	add	a5,a5,1462 # 80003610 <interrupt_table>
    80001062:	97ba                	add	a5,a5,a4
    80001064:	639c                	ld	a5,0(a5)
    80001066:	c79d                	beqz	a5,80001094 <devintr+0x82>
    80001068:	9782                	jalr	a5
    8000106a:	8522                	mv	a0,s0
    8000106c:	2a8000ef          	jal	80001314 <plic_complete>
    80001070:	4505                	li	a0,1
    80001072:	b7f1                	j	8000103e <devintr+0x2c>
    80001074:	00001517          	auipc	a0,0x1
    80001078:	26450513          	add	a0,a0,612 # 800022d8 <digits+0x2a0>
    8000107c:	8dcff0ef          	jal	80000158 <printf>
    80001080:	784000ef          	jal	80001804 <yield>
    80001084:	60a2                	ld	ra,8(sp)
    80001086:	6402                	ld	s0,0(sp)
    80001088:	4509                	li	a0,2
    8000108a:	0141                	add	sp,sp,16
    8000108c:	8082                	ret
    8000108e:	fd71                	bnez	a0,8000106a <devintr+0x58>
    80001090:	4505                	li	a0,1
    80001092:	b775                	j	8000103e <devintr+0x2c>
    80001094:	85aa                	mv	a1,a0
    80001096:	00001517          	auipc	a0,0x1
    8000109a:	22250513          	add	a0,a0,546 # 800022b8 <digits+0x280>
    8000109e:	8baff0ef          	jal	80000158 <printf>
    800010a2:	b7e1                	j	8000106a <devintr+0x58>

00000000800010a4 <timer_interrupt>:
    800010a4:	00001797          	auipc	a5,0x1
    800010a8:	5647a783          	lw	a5,1380(a5) # 80002608 <interrupt_count>
    800010ac:	2785                	addw	a5,a5,1
    800010ae:	00001717          	auipc	a4,0x1
    800010b2:	54f72d23          	sw	a5,1370(a4) # 80002608 <interrupt_count>
    800010b6:	c01027f3          	rdtime	a5
    800010ba:	000f4737          	lui	a4,0xf4
    800010be:	24070713          	add	a4,a4,576 # f4240 <userret+0xf41a4>
    800010c2:	97ba                	add	a5,a5,a4
    800010c4:	14d79073          	csrw	stimecmp,a5
    800010c8:	8082                	ret

00000000800010ca <handle_exception>:
    800010ca:	142027f3          	csrr	a5,scause
    800010ce:	4735                	li	a4,13
    800010d0:	02e78963          	beq	a5,a4,80001102 <handle_exception+0x38>
    800010d4:	00f76e63          	bltu	a4,a5,800010f0 <handle_exception+0x26>
    800010d8:	4709                	li	a4,2
    800010da:	04e78063          	beq	a5,a4,8000111a <handle_exception+0x50>
    800010de:	4731                	li	a4,12
    800010e0:	02e79763          	bne	a5,a4,8000110e <handle_exception+0x44>
    800010e4:	00001517          	auipc	a0,0x1
    800010e8:	23450513          	add	a0,a0,564 # 80002318 <digits+0x2e0>
    800010ec:	a6aff06f          	j	80000356 <panic>
    800010f0:	473d                	li	a4,15
    800010f2:	00e79e63          	bne	a5,a4,8000110e <handle_exception+0x44>
    800010f6:	00001517          	auipc	a0,0x1
    800010fa:	27a50513          	add	a0,a0,634 # 80002370 <digits+0x338>
    800010fe:	a58ff06f          	j	80000356 <panic>
    80001102:	00001517          	auipc	a0,0x1
    80001106:	24650513          	add	a0,a0,582 # 80002348 <digits+0x310>
    8000110a:	a4cff06f          	j	80000356 <panic>
    8000110e:	00001517          	auipc	a0,0x1
    80001112:	28a50513          	add	a0,a0,650 # 80002398 <digits+0x360>
    80001116:	a40ff06f          	j	80000356 <panic>
    8000111a:	00001517          	auipc	a0,0x1
    8000111e:	1d650513          	add	a0,a0,470 # 800022f0 <digits+0x2b8>
    80001122:	a34ff06f          	j	80000356 <panic>

0000000080001126 <kerneltrap>:
    80001126:	7179                	add	sp,sp,-48
    80001128:	f406                	sd	ra,40(sp)
    8000112a:	f022                	sd	s0,32(sp)
    8000112c:	ec26                	sd	s1,24(sp)
    8000112e:	e84a                	sd	s2,16(sp)
    80001130:	e44e                	sd	s3,8(sp)
    80001132:	e052                	sd	s4,0(sp)
    80001134:	141029f3          	csrr	s3,sepc
    80001138:	10002973          	csrr	s2,sstatus
    8000113c:	14202473          	csrr	s0,scause
    80001140:	14302a73          	csrr	s4,stval
    80001144:	10097793          	and	a5,s2,256
    80001148:	cfa1                	beqz	a5,800011a0 <kerneltrap+0x7a>
    8000114a:	100027f3          	csrr	a5,sstatus
    8000114e:	8b89                	and	a5,a5,2
    80001150:	e3a9                	bnez	a5,80001192 <kerneltrap+0x6c>
    80001152:	03f45493          	srl	s1,s0,0x3f
    80001156:	00042713          	slti	a4,s0,0
    8000115a:	86ce                	mv	a3,s3
    8000115c:	8652                	mv	a2,s4
    8000115e:	85a2                	mv	a1,s0
    80001160:	00001517          	auipc	a0,0x1
    80001164:	29850513          	add	a0,a0,664 # 800023f8 <digits+0x3c0>
    80001168:	ff1fe0ef          	jal	80000158 <printf>
    8000116c:	c085                	beqz	s1,8000118c <kerneltrap+0x66>
    8000116e:	ea5ff0ef          	jal	80001012 <devintr>
    80001172:	cd15                	beqz	a0,800011ae <kerneltrap+0x88>
    80001174:	14199073          	csrw	sepc,s3
    80001178:	10091073          	csrw	sstatus,s2
    8000117c:	70a2                	ld	ra,40(sp)
    8000117e:	7402                	ld	s0,32(sp)
    80001180:	64e2                	ld	s1,24(sp)
    80001182:	6942                	ld	s2,16(sp)
    80001184:	69a2                	ld	s3,8(sp)
    80001186:	6a02                	ld	s4,0(sp)
    80001188:	6145                	add	sp,sp,48
    8000118a:	8082                	ret
    8000118c:	f3fff0ef          	jal	800010ca <handle_exception>
    80001190:	b7d5                	j	80001174 <kerneltrap+0x4e>
    80001192:	00001517          	auipc	a0,0x1
    80001196:	24650513          	add	a0,a0,582 # 800023d8 <digits+0x3a0>
    8000119a:	9bcff0ef          	jal	80000356 <panic>
    8000119e:	bf55                	j	80001152 <kerneltrap+0x2c>
    800011a0:	00001517          	auipc	a0,0x1
    800011a4:	21050513          	add	a0,a0,528 # 800023b0 <digits+0x378>
    800011a8:	9aeff0ef          	jal	80000356 <panic>
    800011ac:	bf79                	j	8000114a <kerneltrap+0x24>
    800011ae:	14102673          	csrr	a2,sepc
    800011b2:	143026f3          	csrr	a3,stval
    800011b6:	00001517          	auipc	a0,0x1
    800011ba:	28250513          	add	a0,a0,642 # 80002438 <digits+0x400>
    800011be:	85a2                	mv	a1,s0
    800011c0:	f99fe0ef          	jal	80000158 <printf>
    800011c4:	00001517          	auipc	a0,0x1
    800011c8:	2bc50513          	add	a0,a0,700 # 80002480 <digits+0x448>
    800011cc:	98aff0ef          	jal	80000356 <panic>
    800011d0:	b755                	j	80001174 <kerneltrap+0x4e>

00000000800011d2 <prepare_return>:
    800011d2:	1141                	add	sp,sp,-16
    800011d4:	e022                	sd	s0,0(sp)
    800011d6:	e406                	sd	ra,8(sp)
    800011d8:	2ba000ef          	jal	80001492 <get_current_process>
    800011dc:	842a                	mv	s0,a0
    800011de:	c125                	beqz	a0,8000123e <prepare_return+0x6c>
    800011e0:	100027f3          	csrr	a5,sstatus
    800011e4:	9bf5                	and	a5,a5,-3
    800011e6:	10079073          	csrw	sstatus,a5
    800011ea:	603c                	ld	a5,64(s0)
    800011ec:	180026f3          	csrr	a3,satp
    800011f0:	7418                	ld	a4,40(s0)
    800011f2:	6605                	lui	a2,0x1
    800011f4:	e394                	sd	a3,0(a5)
    800011f6:	9732                	add	a4,a4,a2
    800011f8:	e798                	sd	a4,8(a5)
    800011fa:	00000717          	auipc	a4,0x0
    800011fe:	05270713          	add	a4,a4,82 # 8000124c <usertrap>
    80001202:	eb98                	sd	a4,16(a5)
    80001204:	8712                	mv	a4,tp
    80001206:	f398                	sd	a4,32(a5)
    80001208:	10002773          	csrr	a4,sstatus
    8000120c:	eff77713          	and	a4,a4,-257
    80001210:	02076713          	or	a4,a4,32
    80001214:	10071073          	csrw	sstatus,a4
    80001218:	040006b7          	lui	a3,0x4000
    8000121c:	00000613          	li	a2,0
    80001220:	00000713          	li	a4,0
    80001224:	16fd                	add	a3,a3,-1 # 3ffffff <userret+0x3ffff63>
    80001226:	8f11                	sub	a4,a4,a2
    80001228:	06b2                	sll	a3,a3,0xc
    8000122a:	9736                	add	a4,a4,a3
    8000122c:	10571073          	csrw	stvec,a4
    80001230:	6f9c                	ld	a5,24(a5)
    80001232:	14179073          	csrw	sepc,a5
    80001236:	60a2                	ld	ra,8(sp)
    80001238:	6402                	ld	s0,0(sp)
    8000123a:	0141                	add	sp,sp,16
    8000123c:	8082                	ret
    8000123e:	00001517          	auipc	a0,0x1
    80001242:	25250513          	add	a0,a0,594 # 80002490 <digits+0x458>
    80001246:	910ff0ef          	jal	80000356 <panic>
    8000124a:	bf59                	j	800011e0 <prepare_return+0xe>

000000008000124c <usertrap>:
    8000124c:	1101                	add	sp,sp,-32
    8000124e:	e822                	sd	s0,16(sp)
    80001250:	ec06                	sd	ra,24(sp)
    80001252:	e426                	sd	s1,8(sp)
    80001254:	23e000ef          	jal	80001492 <get_current_process>
    80001258:	842a                	mv	s0,a0
    8000125a:	142024f3          	csrr	s1,scause
    8000125e:	00000797          	auipc	a5,0x0
    80001262:	0c278793          	add	a5,a5,194 # 80001320 <kernelvec>
    80001266:	10579073          	csrw	stvec,a5
    8000126a:	100027f3          	csrr	a5,sstatus
    8000126e:	1007f793          	and	a5,a5,256
    80001272:	e3b1                	bnez	a5,800012b6 <usertrap+0x6a>
    80001274:	6038                	ld	a4,64(s0)
    80001276:	141027f3          	csrr	a5,sepc
    8000127a:	46a1                	li	a3,8
    8000127c:	ef1c                	sd	a5,24(a4)
    8000127e:	04d48963          	beq	s1,a3,800012d0 <usertrap+0x84>
    80001282:	0404cd63          	bltz	s1,800012dc <usertrap+0x90>
    80001286:	4785                	li	a5,1
    80001288:	c81c                	sw	a5,16(s0)
    8000128a:	f49ff0ef          	jal	800011d2 <prepare_return>
    8000128e:	04000737          	lui	a4,0x4000
    80001292:	7c08                	ld	a0,56(s0)
    80001294:	09c00793          	li	a5,156
    80001298:	00000693          	li	a3,0
    8000129c:	177d                	add	a4,a4,-1 # 3ffffff <userret+0x3ffff63>
    8000129e:	6442                	ld	s0,16(sp)
    800012a0:	0732                	sll	a4,a4,0xc
    800012a2:	8f95                	sub	a5,a5,a3
    800012a4:	60e2                	ld	ra,24(sp)
    800012a6:	64a2                	ld	s1,8(sp)
    800012a8:	97ba                	add	a5,a5,a4
    800012aa:	577d                	li	a4,-1
    800012ac:	8131                	srl	a0,a0,0xc
    800012ae:	177e                	sll	a4,a4,0x3f
    800012b0:	8d59                	or	a0,a0,a4
    800012b2:	6105                	add	sp,sp,32
    800012b4:	8782                	jr	a5
    800012b6:	00001517          	auipc	a0,0x1
    800012ba:	1fa50513          	add	a0,a0,506 # 800024b0 <digits+0x478>
    800012be:	898ff0ef          	jal	80000356 <panic>
    800012c2:	6038                	ld	a4,64(s0)
    800012c4:	141027f3          	csrr	a5,sepc
    800012c8:	46a1                	li	a3,8
    800012ca:	ef1c                	sd	a5,24(a4)
    800012cc:	fad49be3          	bne	s1,a3,80001282 <usertrap+0x36>
    800012d0:	0791                	add	a5,a5,4
    800012d2:	ef1c                	sd	a5,24(a4)
    800012d4:	8522                	mv	a0,s0
    800012d6:	239000ef          	jal	80001d0e <syscall_dispatch>
    800012da:	bf45                	j	8000128a <usertrap+0x3e>
    800012dc:	d37ff0ef          	jal	80001012 <devintr>
    800012e0:	4789                	li	a5,2
    800012e2:	faf514e3          	bne	a0,a5,8000128a <usertrap+0x3e>
    800012e6:	51e000ef          	jal	80001804 <yield>
    800012ea:	b745                	j	8000128a <usertrap+0x3e>

00000000800012ec <plicinit>:
    800012ec:	0c0007b7          	lui	a5,0xc000
    800012f0:	4705                	li	a4,1
    800012f2:	d798                	sw	a4,40(a5)
    800012f4:	c3d8                	sw	a4,4(a5)
    800012f6:	0c0027b7          	lui	a5,0xc002
    800012fa:	40200713          	li	a4,1026
    800012fe:	08e7a023          	sw	a4,128(a5) # c002080 <userret+0xc001fe4>
    80001302:	0c2017b7          	lui	a5,0xc201
    80001306:	0007a023          	sw	zero,0(a5) # c201000 <userret+0xc200f64>
    8000130a:	8082                	ret

000000008000130c <plic_claim>:
    8000130c:	0c2017b7          	lui	a5,0xc201
    80001310:	43c8                	lw	a0,4(a5)
    80001312:	8082                	ret

0000000080001314 <plic_complete>:
    80001314:	0c2017b7          	lui	a5,0xc201
    80001318:	c3c8                	sw	a0,4(a5)
    8000131a:	8082                	ret
    8000131c:	0000                	unimp
	...

0000000080001320 <kernelvec>:
    80001320:	7111                	add	sp,sp,-256
    80001322:	e006                	sd	ra,0(sp)
    80001324:	e80e                	sd	gp,16(sp)
    80001326:	ec12                	sd	tp,24(sp)
    80001328:	f016                	sd	t0,32(sp)
    8000132a:	f41a                	sd	t1,40(sp)
    8000132c:	f81e                	sd	t2,48(sp)
    8000132e:	e4aa                	sd	a0,72(sp)
    80001330:	e8ae                	sd	a1,80(sp)
    80001332:	ecb2                	sd	a2,88(sp)
    80001334:	f0b6                	sd	a3,96(sp)
    80001336:	f4ba                	sd	a4,104(sp)
    80001338:	f8be                	sd	a5,112(sp)
    8000133a:	fcc2                	sd	a6,120(sp)
    8000133c:	e146                	sd	a7,128(sp)
    8000133e:	edf2                	sd	t3,216(sp)
    80001340:	f1f6                	sd	t4,224(sp)
    80001342:	f5fa                	sd	t5,232(sp)
    80001344:	f9fe                	sd	t6,240(sp)
    80001346:	de1ff0ef          	jal	80001126 <kerneltrap>
    8000134a:	6082                	ld	ra,0(sp)
    8000134c:	61c2                	ld	gp,16(sp)
    8000134e:	7282                	ld	t0,32(sp)
    80001350:	7322                	ld	t1,40(sp)
    80001352:	73c2                	ld	t2,48(sp)
    80001354:	6526                	ld	a0,72(sp)
    80001356:	65c6                	ld	a1,80(sp)
    80001358:	6666                	ld	a2,88(sp)
    8000135a:	7686                	ld	a3,96(sp)
    8000135c:	7726                	ld	a4,104(sp)
    8000135e:	77c6                	ld	a5,112(sp)
    80001360:	7866                	ld	a6,120(sp)
    80001362:	688a                	ld	a7,128(sp)
    80001364:	6e6e                	ld	t3,216(sp)
    80001366:	7e8e                	ld	t4,224(sp)
    80001368:	7f2e                	ld	t5,232(sp)
    8000136a:	7fce                	ld	t6,240(sp)
    8000136c:	6111                	add	sp,sp,256
    8000136e:	10200073          	sret
	...

000000008000137e <forkret>:
    8000137e:	1141                	add	sp,sp,-16
    80001380:	e022                	sd	s0,0(sp)
    80001382:	e406                	sd	ra,8(sp)
    80001384:	00002417          	auipc	s0,0x2
    80001388:	38c43403          	ld	s0,908(s0) # 80003710 <cur_cpu>
    8000138c:	e47ff0ef          	jal	800011d2 <prepare_return>
    80001390:	04000737          	lui	a4,0x4000
    80001394:	7c08                	ld	a0,56(s0)
    80001396:	09c00793          	li	a5,156
    8000139a:	00000693          	li	a3,0
    8000139e:	177d                	add	a4,a4,-1 # 3ffffff <userret+0x3ffff63>
    800013a0:	6402                	ld	s0,0(sp)
    800013a2:	0732                	sll	a4,a4,0xc
    800013a4:	8f95                	sub	a5,a5,a3
    800013a6:	60a2                	ld	ra,8(sp)
    800013a8:	97ba                	add	a5,a5,a4
    800013aa:	577d                	li	a4,-1
    800013ac:	8131                	srl	a0,a0,0xc
    800013ae:	177e                	sll	a4,a4,0x3f
    800013b0:	8d59                	or	a0,a0,a4
    800013b2:	0141                	add	sp,sp,16
    800013b4:	8782                	jr	a5

00000000800013b6 <push_off>:
    800013b6:	100026f3          	csrr	a3,sstatus
    800013ba:	100027f3          	csrr	a5,sstatus
    800013be:	9bf5                	and	a5,a5,-3
    800013c0:	10079073          	csrw	sstatus,a5
    800013c4:	00002717          	auipc	a4,0x2
    800013c8:	34c70713          	add	a4,a4,844 # 80003710 <cur_cpu>
    800013cc:	5f3c                	lw	a5,120(a4)
    800013ce:	e781                	bnez	a5,800013d6 <push_off+0x20>
    800013d0:	8285                	srl	a3,a3,0x1
    800013d2:	8a85                	and	a3,a3,1
    800013d4:	df74                	sw	a3,124(a4)
    800013d6:	2785                	addw	a5,a5,1 # c201001 <userret+0xc200f65>
    800013d8:	df3c                	sw	a5,120(a4)
    800013da:	8082                	ret

00000000800013dc <pop_off>:
    800013dc:	1141                	add	sp,sp,-16
    800013de:	e406                	sd	ra,8(sp)
    800013e0:	e022                	sd	s0,0(sp)
    800013e2:	100027f3          	csrr	a5,sstatus
    800013e6:	8b89                	and	a5,a5,2
    800013e8:	eb85                	bnez	a5,80001418 <pop_off+0x3c>
    800013ea:	00002417          	auipc	s0,0x2
    800013ee:	32640413          	add	s0,s0,806 # 80003710 <cur_cpu>
    800013f2:	5c3c                	lw	a5,120(s0)
    800013f4:	02f05f63          	blez	a5,80001432 <pop_off+0x56>
    800013f8:	fff7871b          	addw	a4,a5,-1
    800013fc:	dc38                	sw	a4,120(s0)
    800013fe:	eb09                	bnez	a4,80001410 <pop_off+0x34>
    80001400:	5c7c                	lw	a5,124(s0)
    80001402:	c799                	beqz	a5,80001410 <pop_off+0x34>
    80001404:	100027f3          	csrr	a5,sstatus
    80001408:	0027e793          	or	a5,a5,2
    8000140c:	10079073          	csrw	sstatus,a5
    80001410:	60a2                	ld	ra,8(sp)
    80001412:	6402                	ld	s0,0(sp)
    80001414:	0141                	add	sp,sp,16
    80001416:	8082                	ret
    80001418:	00001517          	auipc	a0,0x1
    8000141c:	0b850513          	add	a0,a0,184 # 800024d0 <digits+0x498>
    80001420:	f37fe0ef          	jal	80000356 <panic>
    80001424:	00002417          	auipc	s0,0x2
    80001428:	2ec40413          	add	s0,s0,748 # 80003710 <cur_cpu>
    8000142c:	5c3c                	lw	a5,120(s0)
    8000142e:	fcf045e3          	bgtz	a5,800013f8 <pop_off+0x1c>
    80001432:	00001517          	auipc	a0,0x1
    80001436:	0b650513          	add	a0,a0,182 # 800024e8 <digits+0x4b0>
    8000143a:	f1dfe0ef          	jal	80000356 <panic>
    8000143e:	5c3c                	lw	a5,120(s0)
    80001440:	bf65                	j	800013f8 <pop_off+0x1c>

0000000080001442 <init_process_table>:
    80001442:	040006b7          	lui	a3,0x4000
    80001446:	00002617          	auipc	a2,0x2
    8000144a:	34a60613          	add	a2,a2,842 # 80003790 <procs>
    8000144e:	16fd                	add	a3,a3,-1 # 3ffffff <userret+0x3ffff63>
    80001450:	8732                	mv	a4,a2
    80001452:	00005517          	auipc	a0,0x5
    80001456:	53e50513          	add	a0,a0,1342 # 80006990 <__bss_end>
    8000145a:	00001597          	auipc	a1,0x1
    8000145e:	ba65b583          	ld	a1,-1114(a1) # 80002000 <etext>
    80001462:	06b2                	sll	a3,a3,0xc
    80001464:	40c707b3          	sub	a5,a4,a2
    80001468:	878d                	sra	a5,a5,0x3
    8000146a:	02b787b3          	mul	a5,a5,a1
    8000146e:	00072023          	sw	zero,0(a4)
    80001472:	0c870713          	add	a4,a4,200
    80001476:	0785                	add	a5,a5,1
    80001478:	07b6                	sll	a5,a5,0xd
    8000147a:	40f687b3          	sub	a5,a3,a5
    8000147e:	f6f73023          	sd	a5,-160(a4)
    80001482:	fee511e3          	bne	a0,a4,80001464 <init_process_table+0x22>
    80001486:	8082                	ret

0000000080001488 <get_current_cpu>:
    80001488:	00002517          	auipc	a0,0x2
    8000148c:	28850513          	add	a0,a0,648 # 80003710 <cur_cpu>
    80001490:	8082                	ret

0000000080001492 <get_current_process>:
    80001492:	00002517          	auipc	a0,0x2
    80001496:	27e53503          	ld	a0,638(a0) # 80003710 <cur_cpu>
    8000149a:	8082                	ret

000000008000149c <proc_pagetable>:
    8000149c:	1101                	add	sp,sp,-32
    8000149e:	e426                	sd	s1,8(sp)
    800014a0:	ec06                	sd	ra,24(sp)
    800014a2:	e822                	sd	s0,16(sp)
    800014a4:	e04a                	sd	s2,0(sp)
    800014a6:	84aa                	mv	s1,a0
    800014a8:	ff2ff0ef          	jal	80000c9a <create_user_pagetable>
    800014ac:	c531                	beqz	a0,800014f8 <proc_pagetable+0x5c>
    800014ae:	04000937          	lui	s2,0x4000
    800014b2:	197d                	add	s2,s2,-1 # 3ffffff <userret+0x3ffff63>
    800014b4:	4729                	li	a4,10
    800014b6:	00000693          	li	a3,0
    800014ba:	6605                	lui	a2,0x1
    800014bc:	00c91593          	sll	a1,s2,0xc
    800014c0:	842a                	mv	s0,a0
    800014c2:	d72ff0ef          	jal	80000a34 <mappages>
    800014c6:	02054563          	bltz	a0,800014f0 <proc_pagetable+0x54>
    800014ca:	020005b7          	lui	a1,0x2000
    800014ce:	60b4                	ld	a3,64(s1)
    800014d0:	15fd                	add	a1,a1,-1 # 1ffffff <userret+0x1ffff63>
    800014d2:	4719                	li	a4,6
    800014d4:	6605                	lui	a2,0x1
    800014d6:	05b6                	sll	a1,a1,0xd
    800014d8:	8522                	mv	a0,s0
    800014da:	d5aff0ef          	jal	80000a34 <mappages>
    800014de:	02054563          	bltz	a0,80001508 <proc_pagetable+0x6c>
    800014e2:	60e2                	ld	ra,24(sp)
    800014e4:	8522                	mv	a0,s0
    800014e6:	6442                	ld	s0,16(sp)
    800014e8:	64a2                	ld	s1,8(sp)
    800014ea:	6902                	ld	s2,0(sp)
    800014ec:	6105                	add	sp,sp,32
    800014ee:	8082                	ret
    800014f0:	4581                	li	a1,0
    800014f2:	8522                	mv	a0,s0
    800014f4:	8a9ff0ef          	jal	80000d9c <free_user_pagetable>
    800014f8:	4401                	li	s0,0
    800014fa:	60e2                	ld	ra,24(sp)
    800014fc:	8522                	mv	a0,s0
    800014fe:	6442                	ld	s0,16(sp)
    80001500:	64a2                	ld	s1,8(sp)
    80001502:	6902                	ld	s2,0(sp)
    80001504:	6105                	add	sp,sp,32
    80001506:	8082                	ret
    80001508:	8522                	mv	a0,s0
    8000150a:	00c91593          	sll	a1,s2,0xc
    8000150e:	4681                	li	a3,0
    80001510:	4605                	li	a2,1
    80001512:	fa8ff0ef          	jal	80000cba <remove_user_mappings>
    80001516:	8522                	mv	a0,s0
    80001518:	4581                	li	a1,0
    8000151a:	883ff0ef          	jal	80000d9c <free_user_pagetable>
    8000151e:	4401                	li	s0,0
    80001520:	bfe9                	j	800014fa <proc_pagetable+0x5e>

0000000080001522 <allocate_process>:
    80001522:	7179                	add	sp,sp,-48
    80001524:	f406                	sd	ra,40(sp)
    80001526:	f022                	sd	s0,32(sp)
    80001528:	ec26                	sd	s1,24(sp)
    8000152a:	e84a                	sd	s2,16(sp)
    8000152c:	e44e                	sd	s3,8(sp)
    8000152e:	100026f3          	csrr	a3,sstatus
    80001532:	100027f3          	csrr	a5,sstatus
    80001536:	9bf5                	and	a5,a5,-3
    80001538:	10079073          	csrw	sstatus,a5
    8000153c:	00002717          	auipc	a4,0x2
    80001540:	1d470713          	add	a4,a4,468 # 80003710 <cur_cpu>
    80001544:	5f3c                	lw	a5,120(a4)
    80001546:	e781                	bnez	a5,8000154e <allocate_process+0x2c>
    80001548:	8285                	srl	a3,a3,0x1
    8000154a:	8a85                	and	a3,a3,1
    8000154c:	df74                	sw	a3,124(a4)
    8000154e:	2785                	addw	a5,a5,1
    80001550:	00002997          	auipc	s3,0x2
    80001554:	24098993          	add	s3,s3,576 # 80003790 <procs>
    80001558:	df3c                	sw	a5,120(a4)
    8000155a:	04000613          	li	a2,64
    8000155e:	874e                	mv	a4,s3
    80001560:	4781                	li	a5,0
    80001562:	a021                	j	8000156a <allocate_process+0x48>
    80001564:	2785                	addw	a5,a5,1
    80001566:	08c78163          	beq	a5,a2,800015e8 <allocate_process+0xc6>
    8000156a:	4314                	lw	a3,0(a4)
    8000156c:	0c870713          	add	a4,a4,200
    80001570:	faf5                	bnez	a3,80001564 <allocate_process+0x42>
    80001572:	0c800713          	li	a4,200
    80001576:	02e78433          	mul	s0,a5,a4
    8000157a:	00001717          	auipc	a4,0x1
    8000157e:	06670713          	add	a4,a4,102 # 800025e0 <nextpid>
    80001582:	431c                	lw	a5,0(a4)
    80001584:	0017869b          	addw	a3,a5,1
    80001588:	c314                	sw	a3,0(a4)
    8000158a:	008984b3          	add	s1,s3,s0
    8000158e:	cc9c                	sw	a5,24(s1)
    80001590:	bbcff0ef          	jal	8000094c <alloc_page>
    80001594:	e0a8                	sd	a0,64(s1)
    80001596:	c929                	beqz	a0,800015e8 <allocate_process+0xc6>
    80001598:	8526                	mv	a0,s1
    8000159a:	f03ff0ef          	jal	8000149c <proc_pagetable>
    8000159e:	fc88                	sd	a0,56(s1)
    800015a0:	8926                	mv	s2,s1
    800015a2:	cd15                	beqz	a0,800015de <allocate_process+0xbc>
    800015a4:	04840513          	add	a0,s0,72
    800015a8:	4785                	li	a5,1
    800015aa:	07000613          	li	a2,112
    800015ae:	4581                	li	a1,0
    800015b0:	954e                	add	a0,a0,s3
    800015b2:	c09c                	sw	a5,0(s1)
    800015b4:	8a9ff0ef          	jal	80000e5c <memset>
    800015b8:	749c                	ld	a5,40(s1)
    800015ba:	6705                	lui	a4,0x1
    800015bc:	97ba                	add	a5,a5,a4
    800015be:	00000717          	auipc	a4,0x0
    800015c2:	dc070713          	add	a4,a4,-576 # 8000137e <forkret>
    800015c6:	e4b8                	sd	a4,72(s1)
    800015c8:	e8bc                	sd	a5,80(s1)
    800015ca:	e13ff0ef          	jal	800013dc <pop_off>
    800015ce:	70a2                	ld	ra,40(sp)
    800015d0:	7402                	ld	s0,32(sp)
    800015d2:	64e2                	ld	s1,24(sp)
    800015d4:	69a2                	ld	s3,8(sp)
    800015d6:	854a                	mv	a0,s2
    800015d8:	6942                	ld	s2,16(sp)
    800015da:	6145                	add	sp,sp,48
    800015dc:	8082                	ret
    800015de:	60a8                	ld	a0,64(s1)
    800015e0:	b1cff0ef          	jal	800008fc <free_page>
    800015e4:	0404b023          	sd	zero,64(s1) # 1040 <userret+0xfa4>
    800015e8:	df5ff0ef          	jal	800013dc <pop_off>
    800015ec:	70a2                	ld	ra,40(sp)
    800015ee:	7402                	ld	s0,32(sp)
    800015f0:	4901                	li	s2,0
    800015f2:	64e2                	ld	s1,24(sp)
    800015f4:	69a2                	ld	s3,8(sp)
    800015f6:	854a                	mv	a0,s2
    800015f8:	6942                	ld	s2,16(sp)
    800015fa:	6145                	add	sp,sp,48
    800015fc:	8082                	ret

00000000800015fe <kfork>:
    800015fe:	1101                	add	sp,sp,-32
    80001600:	ec06                	sd	ra,24(sp)
    80001602:	e822                	sd	s0,16(sp)
    80001604:	e426                	sd	s1,8(sp)
    80001606:	e04a                	sd	s2,0(sp)
    80001608:	f1bff0ef          	jal	80001522 <allocate_process>
    8000160c:	0e050b63          	beqz	a0,80001702 <kfork+0x104>
    80001610:	00002917          	auipc	s2,0x2
    80001614:	10090913          	add	s2,s2,256 # 80003710 <cur_cpu>
    80001618:	00093483          	ld	s1,0(s2)
    8000161c:	7d0c                	ld	a1,56(a0)
    8000161e:	842a                	mv	s0,a0
    80001620:	7890                	ld	a2,48(s1)
    80001622:	7c88                	ld	a0,56(s1)
    80001624:	fa8ff0ef          	jal	80000dcc <copy_user_memory>
    80001628:	08054063          	bltz	a0,800016a8 <kfork+0xaa>
    8000162c:	6034                	ld	a3,64(s0)
    8000162e:	60bc                	ld	a5,64(s1)
    80001630:	8736                	mv	a4,a3
    80001632:	12078893          	add	a7,a5,288
    80001636:	0007b803          	ld	a6,0(a5)
    8000163a:	6788                	ld	a0,8(a5)
    8000163c:	6b8c                	ld	a1,16(a5)
    8000163e:	6f90                	ld	a2,24(a5)
    80001640:	01073023          	sd	a6,0(a4)
    80001644:	e708                	sd	a0,8(a4)
    80001646:	eb0c                	sd	a1,16(a4)
    80001648:	ef10                	sd	a2,24(a4)
    8000164a:	02078793          	add	a5,a5,32
    8000164e:	02070713          	add	a4,a4,32
    80001652:	ff1792e3          	bne	a5,a7,80001636 <kfork+0x38>
    80001656:	789c                	ld	a5,48(s1)
    80001658:	f81c                	sd	a5,48(s0)
    8000165a:	0606b823          	sd	zero,112(a3)
    8000165e:	10002773          	csrr	a4,sstatus
    80001662:	100027f3          	csrr	a5,sstatus
    80001666:	9bf5                	and	a5,a5,-3
    80001668:	10079073          	csrw	sstatus,a5
    8000166c:	07892783          	lw	a5,120(s2)
    80001670:	e789                	bnez	a5,8000167a <kfork+0x7c>
    80001672:	8305                	srl	a4,a4,0x1
    80001674:	8b05                	and	a4,a4,1
    80001676:	06e92e23          	sw	a4,124(s2)
    8000167a:	2785                	addw	a5,a5,1
    8000167c:	06f92c23          	sw	a5,120(s2)
    80001680:	478d                	li	a5,3
    80001682:	c01c                	sw	a5,0(s0)
    80001684:	f004                	sd	s1,32(s0)
    80001686:	d57ff0ef          	jal	800013dc <pop_off>
    8000168a:	4c10                	lw	a2,24(s0)
    8000168c:	4c8c                	lw	a1,24(s1)
    8000168e:	00001517          	auipc	a0,0x1
    80001692:	e6250513          	add	a0,a0,-414 # 800024f0 <digits+0x4b8>
    80001696:	ac3fe0ef          	jal	80000158 <printf>
    8000169a:	4c08                	lw	a0,24(s0)
    8000169c:	60e2                	ld	ra,24(sp)
    8000169e:	6442                	ld	s0,16(sp)
    800016a0:	64a2                	ld	s1,8(sp)
    800016a2:	6902                	ld	s2,0(sp)
    800016a4:	6105                	add	sp,sp,32
    800016a6:	8082                	ret
    800016a8:	6028                	ld	a0,64(s0)
    800016aa:	c119                	beqz	a0,800016b0 <kfork+0xb2>
    800016ac:	a50ff0ef          	jal	800008fc <free_page>
    800016b0:	7c08                	ld	a0,56(s0)
    800016b2:	04043023          	sd	zero,64(s0)
    800016b6:	c515                	beqz	a0,800016e2 <kfork+0xe4>
    800016b8:	040005b7          	lui	a1,0x4000
    800016bc:	15fd                	add	a1,a1,-1 # 3ffffff <userret+0x3ffff63>
    800016be:	4681                	li	a3,0
    800016c0:	4605                	li	a2,1
    800016c2:	05b2                	sll	a1,a1,0xc
    800016c4:	df6ff0ef          	jal	80000cba <remove_user_mappings>
    800016c8:	7c08                	ld	a0,56(s0)
    800016ca:	020005b7          	lui	a1,0x2000
    800016ce:	15fd                	add	a1,a1,-1 # 1ffffff <userret+0x1ffff63>
    800016d0:	05b6                	sll	a1,a1,0xd
    800016d2:	4681                	li	a3,0
    800016d4:	4605                	li	a2,1
    800016d6:	de4ff0ef          	jal	80000cba <remove_user_mappings>
    800016da:	780c                	ld	a1,48(s0)
    800016dc:	7c08                	ld	a0,56(s0)
    800016de:	ebeff0ef          	jal	80000d9c <free_user_pagetable>
    800016e2:	02043c23          	sd	zero,56(s0)
    800016e6:	02043823          	sd	zero,48(s0)
    800016ea:	00042c23          	sw	zero,24(s0)
    800016ee:	02043023          	sd	zero,32(s0)
    800016f2:	0a040c23          	sb	zero,184(s0)
    800016f6:	00043423          	sd	zero,8(s0)
    800016fa:	00043823          	sd	zero,16(s0)
    800016fe:	00042023          	sw	zero,0(s0)
    80001702:	557d                	li	a0,-1
    80001704:	bf61                	j	8000169c <kfork+0x9e>

0000000080001706 <free_proc_pagetable>:
    80001706:	1141                	add	sp,sp,-16
    80001708:	e022                	sd	s0,0(sp)
    8000170a:	040005b7          	lui	a1,0x4000
    8000170e:	842a                	mv	s0,a0
    80001710:	7d08                	ld	a0,56(a0)
    80001712:	15fd                	add	a1,a1,-1 # 3ffffff <userret+0x3ffff63>
    80001714:	4681                	li	a3,0
    80001716:	4605                	li	a2,1
    80001718:	05b2                	sll	a1,a1,0xc
    8000171a:	e406                	sd	ra,8(sp)
    8000171c:	d9eff0ef          	jal	80000cba <remove_user_mappings>
    80001720:	7c08                	ld	a0,56(s0)
    80001722:	020005b7          	lui	a1,0x2000
    80001726:	15fd                	add	a1,a1,-1 # 1ffffff <userret+0x1ffff63>
    80001728:	05b6                	sll	a1,a1,0xd
    8000172a:	4681                	li	a3,0
    8000172c:	4605                	li	a2,1
    8000172e:	d8cff0ef          	jal	80000cba <remove_user_mappings>
    80001732:	780c                	ld	a1,48(s0)
    80001734:	7c08                	ld	a0,56(s0)
    80001736:	6402                	ld	s0,0(sp)
    80001738:	60a2                	ld	ra,8(sp)
    8000173a:	0141                	add	sp,sp,16
    8000173c:	e60ff06f          	j	80000d9c <free_user_pagetable>

0000000080001740 <scheduler>:
    80001740:	7139                	add	sp,sp,-64
    80001742:	00001517          	auipc	a0,0x1
    80001746:	dce50513          	add	a0,a0,-562 # 80002510 <digits+0x4d8>
    8000174a:	fc06                	sd	ra,56(sp)
    8000174c:	f822                	sd	s0,48(sp)
    8000174e:	f426                	sd	s1,40(sp)
    80001750:	f04a                	sd	s2,32(sp)
    80001752:	ec4e                	sd	s3,24(sp)
    80001754:	e852                	sd	s4,16(sp)
    80001756:	e456                	sd	s5,8(sp)
    80001758:	a01fe0ef          	jal	80000158 <printf>
    8000175c:	00002797          	auipc	a5,0x2
    80001760:	fa07ba23          	sd	zero,-76(a5) # 80003710 <cur_cpu>
    80001764:	100027f3          	csrr	a5,sstatus
    80001768:	0027e793          	or	a5,a5,2
    8000176c:	10079073          	csrw	sstatus,a5
    80001770:	00002997          	auipc	s3,0x2
    80001774:	fa098993          	add	s3,s3,-96 # 80003710 <cur_cpu>
    80001778:	00005917          	auipc	s2,0x5
    8000177c:	21890913          	add	s2,s2,536 # 80006990 <__bss_end>
    80001780:	448d                	li	s1,3
    80001782:	4a91                	li	s5,4
    80001784:	00002a17          	auipc	s4,0x2
    80001788:	f94a0a13          	add	s4,s4,-108 # 80003718 <cur_cpu+0x8>
    8000178c:	10002773          	csrr	a4,sstatus
    80001790:	100027f3          	csrr	a5,sstatus
    80001794:	9bf5                	and	a5,a5,-3
    80001796:	10079073          	csrw	sstatus,a5
    8000179a:	0789a783          	lw	a5,120(s3)
    8000179e:	e789                	bnez	a5,800017a8 <scheduler+0x68>
    800017a0:	8305                	srl	a4,a4,0x1
    800017a2:	8b05                	and	a4,a4,1
    800017a4:	06e9ae23          	sw	a4,124(s3)
    800017a8:	2785                	addw	a5,a5,1
    800017aa:	06f9ac23          	sw	a5,120(s3)
    800017ae:	00002417          	auipc	s0,0x2
    800017b2:	fe240413          	add	s0,s0,-30 # 80003790 <procs>
    800017b6:	a029                	j	800017c0 <scheduler+0x80>
    800017b8:	0c840413          	add	s0,s0,200
    800017bc:	03240663          	beq	s0,s2,800017e8 <scheduler+0xa8>
    800017c0:	401c                	lw	a5,0(s0)
    800017c2:	fe979be3          	bne	a5,s1,800017b8 <scheduler+0x78>
    800017c6:	04840593          	add	a1,s0,72
    800017ca:	8552                	mv	a0,s4
    800017cc:	01542023          	sw	s5,0(s0)
    800017d0:	0089b023          	sd	s0,0(s3)
    800017d4:	4ac000ef          	jal	80001c80 <swtch>
    800017d8:	0c840413          	add	s0,s0,200
    800017dc:	00002797          	auipc	a5,0x2
    800017e0:	f207ba23          	sd	zero,-204(a5) # 80003710 <cur_cpu>
    800017e4:	fd241ee3          	bne	s0,s2,800017c0 <scheduler+0x80>
    800017e8:	bf5ff0ef          	jal	800013dc <pop_off>
    800017ec:	b745                	j	8000178c <scheduler+0x4c>

00000000800017ee <sched>:
    800017ee:	00002517          	auipc	a0,0x2
    800017f2:	f2253503          	ld	a0,-222(a0) # 80003710 <cur_cpu>
    800017f6:	00002597          	auipc	a1,0x2
    800017fa:	f2258593          	add	a1,a1,-222 # 80003718 <cur_cpu+0x8>
    800017fe:	04850513          	add	a0,a0,72
    80001802:	a9bd                	j	80001c80 <swtch>

0000000080001804 <yield>:
    80001804:	1141                	add	sp,sp,-16
    80001806:	e022                	sd	s0,0(sp)
    80001808:	00002417          	auipc	s0,0x2
    8000180c:	f0840413          	add	s0,s0,-248 # 80003710 <cur_cpu>
    80001810:	6014                	ld	a3,0(s0)
    80001812:	e406                	sd	ra,8(sp)
    80001814:	10002773          	csrr	a4,sstatus
    80001818:	100027f3          	csrr	a5,sstatus
    8000181c:	9bf5                	and	a5,a5,-3
    8000181e:	10079073          	csrw	sstatus,a5
    80001822:	5c3c                	lw	a5,120(s0)
    80001824:	e781                	bnez	a5,8000182c <yield+0x28>
    80001826:	8305                	srl	a4,a4,0x1
    80001828:	8b05                	and	a4,a4,1
    8000182a:	dc78                	sw	a4,124(s0)
    8000182c:	4298                	lw	a4,0(a3)
    8000182e:	2785                	addw	a5,a5,1
    80001830:	dc3c                	sw	a5,120(s0)
    80001832:	4791                	li	a5,4
    80001834:	00f71463          	bne	a4,a5,8000183c <yield+0x38>
    80001838:	478d                	li	a5,3
    8000183a:	c29c                	sw	a5,0(a3)
    8000183c:	ba1ff0ef          	jal	800013dc <pop_off>
    80001840:	6008                	ld	a0,0(s0)
    80001842:	6402                	ld	s0,0(sp)
    80001844:	60a2                	ld	ra,8(sp)
    80001846:	00002597          	auipc	a1,0x2
    8000184a:	ed258593          	add	a1,a1,-302 # 80003718 <cur_cpu+0x8>
    8000184e:	04850513          	add	a0,a0,72
    80001852:	0141                	add	sp,sp,16
    80001854:	a135                	j	80001c80 <swtch>

0000000080001856 <sleep>:
    80001856:	1101                	add	sp,sp,-32
    80001858:	e822                	sd	s0,16(sp)
    8000185a:	00002417          	auipc	s0,0x2
    8000185e:	eb640413          	add	s0,s0,-330 # 80003710 <cur_cpu>
    80001862:	e426                	sd	s1,8(sp)
    80001864:	ec06                	sd	ra,24(sp)
    80001866:	6004                	ld	s1,0(s0)
    80001868:	10002773          	csrr	a4,sstatus
    8000186c:	100027f3          	csrr	a5,sstatus
    80001870:	9bf5                	and	a5,a5,-3
    80001872:	10079073          	csrw	sstatus,a5
    80001876:	5c3c                	lw	a5,120(s0)
    80001878:	e781                	bnez	a5,80001880 <sleep+0x2a>
    8000187a:	8305                	srl	a4,a4,0x1
    8000187c:	8b05                	and	a4,a4,1
    8000187e:	dc78                	sw	a4,124(s0)
    80001880:	2785                	addw	a5,a5,1
    80001882:	dc3c                	sw	a5,120(s0)
    80001884:	4789                	li	a5,2
    80001886:	e488                	sd	a0,8(s1)
    80001888:	c09c                	sw	a5,0(s1)
    8000188a:	b53ff0ef          	jal	800013dc <pop_off>
    8000188e:	6008                	ld	a0,0(s0)
    80001890:	00002597          	auipc	a1,0x2
    80001894:	e8858593          	add	a1,a1,-376 # 80003718 <cur_cpu+0x8>
    80001898:	04850513          	add	a0,a0,72
    8000189c:	3e4000ef          	jal	80001c80 <swtch>
    800018a0:	60e2                	ld	ra,24(sp)
    800018a2:	6442                	ld	s0,16(sp)
    800018a4:	0004b423          	sd	zero,8(s1)
    800018a8:	64a2                	ld	s1,8(sp)
    800018aa:	6105                	add	sp,sp,32
    800018ac:	8082                	ret

00000000800018ae <wakeup>:
    800018ae:	100026f3          	csrr	a3,sstatus
    800018b2:	100027f3          	csrr	a5,sstatus
    800018b6:	9bf5                	and	a5,a5,-3
    800018b8:	10079073          	csrw	sstatus,a5
    800018bc:	00002717          	auipc	a4,0x2
    800018c0:	e5470713          	add	a4,a4,-428 # 80003710 <cur_cpu>
    800018c4:	5f3c                	lw	a5,120(a4)
    800018c6:	e781                	bnez	a5,800018ce <wakeup+0x20>
    800018c8:	8285                	srl	a3,a3,0x1
    800018ca:	8a85                	and	a3,a3,1
    800018cc:	df74                	sw	a3,124(a4)
    800018ce:	2785                	addw	a5,a5,1
    800018d0:	df3c                	sw	a5,120(a4)
    800018d2:	00005617          	auipc	a2,0x5
    800018d6:	0be60613          	add	a2,a2,190 # 80006990 <__bss_end>
    800018da:	00002797          	auipc	a5,0x2
    800018de:	eb678793          	add	a5,a5,-330 # 80003790 <procs>
    800018e2:	4689                	li	a3,2
    800018e4:	458d                	li	a1,3
    800018e6:	a029                	j	800018f0 <wakeup+0x42>
    800018e8:	0c878793          	add	a5,a5,200
    800018ec:	00f60d63          	beq	a2,a5,80001906 <wakeup+0x58>
    800018f0:	4398                	lw	a4,0(a5)
    800018f2:	fed71be3          	bne	a4,a3,800018e8 <wakeup+0x3a>
    800018f6:	6798                	ld	a4,8(a5)
    800018f8:	fea718e3          	bne	a4,a0,800018e8 <wakeup+0x3a>
    800018fc:	c38c                	sw	a1,0(a5)
    800018fe:	0c878793          	add	a5,a5,200
    80001902:	fef617e3          	bne	a2,a5,800018f0 <wakeup+0x42>
    80001906:	bcd9                	j	800013dc <pop_off>

0000000080001908 <userinit>:
    80001908:	1101                	add	sp,sp,-32
    8000190a:	e822                	sd	s0,16(sp)
    8000190c:	ec06                	sd	ra,24(sp)
    8000190e:	e426                	sd	s1,8(sp)
    80001910:	e04a                	sd	s2,0(sp)
    80001912:	c11ff0ef          	jal	80001522 <allocate_process>
    80001916:	842a                	mv	s0,a0
    80001918:	c171                	beqz	a0,800019dc <userinit+0xd4>
    8000191a:	832ff0ef          	jal	8000094c <alloc_page>
    8000191e:	84aa                	mv	s1,a0
    80001920:	c55d                	beqz	a0,800019ce <userinit+0xc6>
    80001922:	7c08                	ld	a0,56(s0)
    80001924:	4779                	li	a4,30
    80001926:	86a6                	mv	a3,s1
    80001928:	6605                	lui	a2,0x1
    8000192a:	4581                	li	a1,0
    8000192c:	908ff0ef          	jal	80000a34 <mappages>
    80001930:	08054863          	bltz	a0,800019c0 <userinit+0xb8>
    80001934:	00000797          	auipc	a5,0x0
    80001938:	41878793          	add	a5,a5,1048 # 80001d4c <_start>
    8000193c:	00000917          	auipc	s2,0x0
    80001940:	43e90913          	add	s2,s2,1086 # 80001d7a <forktest_end>
    80001944:	40f90933          	sub	s2,s2,a5
    80001948:	6785                	lui	a5,0x1
    8000194a:	0727e463          	bltu	a5,s2,800019b2 <userinit+0xaa>
    8000194e:	0009061b          	sext.w	a2,s2
    80001952:	8526                	mv	a0,s1
    80001954:	00000597          	auipc	a1,0x0
    80001958:	3f858593          	add	a1,a1,1016 # 80001d4c <_start>
    8000195c:	d1cff0ef          	jal	80000e78 <memmove>
    80001960:	603c                	ld	a5,64(s0)
    80001962:	6705                	lui	a4,0x1
    80001964:	f818                	sd	a4,48(s0)
    80001966:	0007bc23          	sd	zero,24(a5) # 1018 <userret+0xf7c>
    8000196a:	fb98                	sd	a4,48(a5)
    8000196c:	4641                	li	a2,16
    8000196e:	00001597          	auipc	a1,0x1
    80001972:	c1a58593          	add	a1,a1,-998 # 80002588 <digits+0x550>
    80001976:	0b840513          	add	a0,s0,184
    8000197a:	d4aff0ef          	jal	80000ec4 <safestrcpy>
    8000197e:	100026f3          	csrr	a3,sstatus
    80001982:	100027f3          	csrr	a5,sstatus
    80001986:	9bf5                	and	a5,a5,-3
    80001988:	10079073          	csrw	sstatus,a5
    8000198c:	00002717          	auipc	a4,0x2
    80001990:	d8470713          	add	a4,a4,-636 # 80003710 <cur_cpu>
    80001994:	5f3c                	lw	a5,120(a4)
    80001996:	e781                	bnez	a5,8000199e <userinit+0x96>
    80001998:	8285                	srl	a3,a3,0x1
    8000199a:	8a85                	and	a3,a3,1
    8000199c:	df74                	sw	a3,124(a4)
    8000199e:	2785                	addw	a5,a5,1
    800019a0:	df3c                	sw	a5,120(a4)
    800019a2:	478d                	li	a5,3
    800019a4:	c01c                	sw	a5,0(s0)
    800019a6:	6442                	ld	s0,16(sp)
    800019a8:	60e2                	ld	ra,24(sp)
    800019aa:	64a2                	ld	s1,8(sp)
    800019ac:	6902                	ld	s2,0(sp)
    800019ae:	6105                	add	sp,sp,32
    800019b0:	b435                	j	800013dc <pop_off>
    800019b2:	00001517          	auipc	a0,0x1
    800019b6:	bbe50513          	add	a0,a0,-1090 # 80002570 <digits+0x538>
    800019ba:	99dfe0ef          	jal	80000356 <panic>
    800019be:	bf41                	j	8000194e <userinit+0x46>
    800019c0:	00001517          	auipc	a0,0x1
    800019c4:	b9850513          	add	a0,a0,-1128 # 80002558 <digits+0x520>
    800019c8:	98ffe0ef          	jal	80000356 <panic>
    800019cc:	b7a5                	j	80001934 <userinit+0x2c>
    800019ce:	00001517          	auipc	a0,0x1
    800019d2:	b7250513          	add	a0,a0,-1166 # 80002540 <digits+0x508>
    800019d6:	981fe0ef          	jal	80000356 <panic>
    800019da:	b7a1                	j	80001922 <userinit+0x1a>
    800019dc:	00001517          	auipc	a0,0x1
    800019e0:	b4c50513          	add	a0,a0,-1204 # 80002528 <digits+0x4f0>
    800019e4:	973fe0ef          	jal	80000356 <panic>
    800019e8:	bf0d                	j	8000191a <userinit+0x12>

00000000800019ea <fork>:
    800019ea:	b911                	j	800015fe <kfork>

00000000800019ec <exit>:
    800019ec:	1101                	add	sp,sp,-32
    800019ee:	e822                	sd	s0,16(sp)
    800019f0:	00002417          	auipc	s0,0x2
    800019f4:	d2040413          	add	s0,s0,-736 # 80003710 <cur_cpu>
    800019f8:	e426                	sd	s1,8(sp)
    800019fa:	ec06                	sd	ra,24(sp)
    800019fc:	6004                	ld	s1,0(s0)
    800019fe:	862a                	mv	a2,a0
    80001a00:	10002773          	csrr	a4,sstatus
    80001a04:	100027f3          	csrr	a5,sstatus
    80001a08:	9bf5                	and	a5,a5,-3
    80001a0a:	10079073          	csrw	sstatus,a5
    80001a0e:	5c3c                	lw	a5,120(s0)
    80001a10:	e781                	bnez	a5,80001a18 <exit+0x2c>
    80001a12:	8305                	srl	a4,a4,0x1
    80001a14:	8b05                	and	a4,a4,1
    80001a16:	dc78                	sw	a4,124(s0)
    80001a18:	4c8c                	lw	a1,24(s1)
    80001a1a:	2785                	addw	a5,a5,1
    80001a1c:	dc3c                	sw	a5,120(s0)
    80001a1e:	4795                	li	a5,5
    80001a20:	c8d0                	sw	a2,20(s1)
    80001a22:	c09c                	sw	a5,0(s1)
    80001a24:	00001517          	auipc	a0,0x1
    80001a28:	b7450513          	add	a0,a0,-1164 # 80002598 <digits+0x560>
    80001a2c:	f2cfe0ef          	jal	80000158 <printf>
    80001a30:	708c                	ld	a1,32(s1)
    80001a32:	10002773          	csrr	a4,sstatus
    80001a36:	100027f3          	csrr	a5,sstatus
    80001a3a:	9bf5                	and	a5,a5,-3
    80001a3c:	10079073          	csrw	sstatus,a5
    80001a40:	5c3c                	lw	a5,120(s0)
    80001a42:	e781                	bnez	a5,80001a4a <exit+0x5e>
    80001a44:	8305                	srl	a4,a4,0x1
    80001a46:	8b05                	and	a4,a4,1
    80001a48:	dc78                	sw	a4,124(s0)
    80001a4a:	2785                	addw	a5,a5,1
    80001a4c:	dc3c                	sw	a5,120(s0)
    80001a4e:	00005617          	auipc	a2,0x5
    80001a52:	f4260613          	add	a2,a2,-190 # 80006990 <__bss_end>
    80001a56:	00002797          	auipc	a5,0x2
    80001a5a:	d3a78793          	add	a5,a5,-710 # 80003790 <procs>
    80001a5e:	4689                	li	a3,2
    80001a60:	450d                	li	a0,3
    80001a62:	a029                	j	80001a6c <exit+0x80>
    80001a64:	0c878793          	add	a5,a5,200
    80001a68:	00f60d63          	beq	a2,a5,80001a82 <exit+0x96>
    80001a6c:	4398                	lw	a4,0(a5)
    80001a6e:	fed71be3          	bne	a4,a3,80001a64 <exit+0x78>
    80001a72:	6798                	ld	a4,8(a5)
    80001a74:	fee598e3          	bne	a1,a4,80001a64 <exit+0x78>
    80001a78:	c388                	sw	a0,0(a5)
    80001a7a:	0c878793          	add	a5,a5,200
    80001a7e:	fef617e3          	bne	a2,a5,80001a6c <exit+0x80>
    80001a82:	95bff0ef          	jal	800013dc <pop_off>
    80001a86:	957ff0ef          	jal	800013dc <pop_off>
    80001a8a:	6008                	ld	a0,0(s0)
    80001a8c:	6442                	ld	s0,16(sp)
    80001a8e:	60e2                	ld	ra,24(sp)
    80001a90:	64a2                	ld	s1,8(sp)
    80001a92:	00002597          	auipc	a1,0x2
    80001a96:	c8658593          	add	a1,a1,-890 # 80003718 <cur_cpu+0x8>
    80001a9a:	04850513          	add	a0,a0,72
    80001a9e:	6105                	add	sp,sp,32
    80001aa0:	a2c5                	j	80001c80 <swtch>

0000000080001aa2 <wait>:
    80001aa2:	7139                	add	sp,sp,-64
    80001aa4:	e456                	sd	s5,8(sp)
    80001aa6:	00002a97          	auipc	s5,0x2
    80001aaa:	c6aa8a93          	add	s5,s5,-918 # 80003710 <cur_cpu>
    80001aae:	f426                	sd	s1,40(sp)
    80001ab0:	000ab483          	ld	s1,0(s5)
    80001ab4:	f04a                	sd	s2,32(sp)
    80001ab6:	ec4e                	sd	s3,24(sp)
    80001ab8:	e852                	sd	s4,16(sp)
    80001aba:	e05a                	sd	s6,0(sp)
    80001abc:	fc06                	sd	ra,56(sp)
    80001abe:	f822                	sd	s0,48(sp)
    80001ac0:	8b2a                	mv	s6,a0
    80001ac2:	00002a17          	auipc	s4,0x2
    80001ac6:	ccea0a13          	add	s4,s4,-818 # 80003790 <procs>
    80001aca:	4995                	li	s3,5
    80001acc:	04000913          	li	s2,64
    80001ad0:	00002797          	auipc	a5,0x2
    80001ad4:	cc078793          	add	a5,a5,-832 # 80003790 <procs>
    80001ad8:	4401                	li	s0,0
    80001ada:	4681                	li	a3,0
    80001adc:	a031                	j	80001ae8 <wait+0x46>
    80001ade:	2405                	addw	s0,s0,1
    80001ae0:	0c878793          	add	a5,a5,200
    80001ae4:	0b240d63          	beq	s0,s2,80001b9e <wait+0xfc>
    80001ae8:	7398                	ld	a4,32(a5)
    80001aea:	fe971ae3          	bne	a4,s1,80001ade <wait+0x3c>
    80001aee:	4398                	lw	a4,0(a5)
    80001af0:	4685                	li	a3,1
    80001af2:	ff3716e3          	bne	a4,s3,80001ade <wait+0x3c>
    80001af6:	0c800793          	li	a5,200
    80001afa:	02f407b3          	mul	a5,s0,a5
    80001afe:	97d2                	add	a5,a5,s4
    80001b00:	0187a903          	lw	s2,24(a5)
    80001b04:	000b0563          	beqz	s6,80001b0e <wait+0x6c>
    80001b08:	4bdc                	lw	a5,20(a5)
    80001b0a:	00fb2023          	sw	a5,0(s6) # 1000 <userret+0xf64>
    80001b0e:	0c800793          	li	a5,200
    80001b12:	02f407b3          	mul	a5,s0,a5
    80001b16:	97d2                	add	a5,a5,s4
    80001b18:	63a8                	ld	a0,64(a5)
    80001b1a:	c119                	beqz	a0,80001b20 <wait+0x7e>
    80001b1c:	de1fe0ef          	jal	800008fc <free_page>
    80001b20:	0c800493          	li	s1,200
    80001b24:	029404b3          	mul	s1,s0,s1
    80001b28:	94d2                	add	s1,s1,s4
    80001b2a:	7c88                	ld	a0,56(s1)
    80001b2c:	0404b023          	sd	zero,64(s1)
    80001b30:	c515                	beqz	a0,80001b5c <wait+0xba>
    80001b32:	040005b7          	lui	a1,0x4000
    80001b36:	15fd                	add	a1,a1,-1 # 3ffffff <userret+0x3ffff63>
    80001b38:	4681                	li	a3,0
    80001b3a:	4605                	li	a2,1
    80001b3c:	05b2                	sll	a1,a1,0xc
    80001b3e:	97cff0ef          	jal	80000cba <remove_user_mappings>
    80001b42:	7c88                	ld	a0,56(s1)
    80001b44:	020005b7          	lui	a1,0x2000
    80001b48:	15fd                	add	a1,a1,-1 # 1ffffff <userret+0x1ffff63>
    80001b4a:	05b6                	sll	a1,a1,0xd
    80001b4c:	4681                	li	a3,0
    80001b4e:	4605                	li	a2,1
    80001b50:	96aff0ef          	jal	80000cba <remove_user_mappings>
    80001b54:	788c                	ld	a1,48(s1)
    80001b56:	7c88                	ld	a0,56(s1)
    80001b58:	a44ff0ef          	jal	80000d9c <free_user_pagetable>
    80001b5c:	0c800793          	li	a5,200
    80001b60:	02f40433          	mul	s0,s0,a5
    80001b64:	008a07b3          	add	a5,s4,s0
    80001b68:	0207bc23          	sd	zero,56(a5)
    80001b6c:	0207b823          	sd	zero,48(a5)
    80001b70:	0007ac23          	sw	zero,24(a5)
    80001b74:	0207b023          	sd	zero,32(a5)
    80001b78:	0a078c23          	sb	zero,184(a5)
    80001b7c:	0007b423          	sd	zero,8(a5)
    80001b80:	0007b823          	sd	zero,16(a5)
    80001b84:	0007a023          	sw	zero,0(a5)
    80001b88:	70e2                	ld	ra,56(sp)
    80001b8a:	7442                	ld	s0,48(sp)
    80001b8c:	74a2                	ld	s1,40(sp)
    80001b8e:	69e2                	ld	s3,24(sp)
    80001b90:	6a42                	ld	s4,16(sp)
    80001b92:	6aa2                	ld	s5,8(sp)
    80001b94:	6b02                	ld	s6,0(sp)
    80001b96:	854a                	mv	a0,s2
    80001b98:	7902                	ld	s2,32(sp)
    80001b9a:	6121                	add	sp,sp,64
    80001b9c:	8082                	ret
    80001b9e:	caa1                	beqz	a3,80001bee <wait+0x14c>
    80001ba0:	000ab683          	ld	a3,0(s5)
    80001ba4:	10002773          	csrr	a4,sstatus
    80001ba8:	100027f3          	csrr	a5,sstatus
    80001bac:	9bf5                	and	a5,a5,-3
    80001bae:	10079073          	csrw	sstatus,a5
    80001bb2:	078aa783          	lw	a5,120(s5)
    80001bb6:	c79d                	beqz	a5,80001be4 <wait+0x142>
    80001bb8:	4298                	lw	a4,0(a3)
    80001bba:	2785                	addw	a5,a5,1
    80001bbc:	06faac23          	sw	a5,120(s5)
    80001bc0:	4791                	li	a5,4
    80001bc2:	00f71463          	bne	a4,a5,80001bca <wait+0x128>
    80001bc6:	478d                	li	a5,3
    80001bc8:	c29c                	sw	a5,0(a3)
    80001bca:	813ff0ef          	jal	800013dc <pop_off>
    80001bce:	000ab503          	ld	a0,0(s5)
    80001bd2:	00002597          	auipc	a1,0x2
    80001bd6:	b4658593          	add	a1,a1,-1210 # 80003718 <cur_cpu+0x8>
    80001bda:	04850513          	add	a0,a0,72
    80001bde:	0a2000ef          	jal	80001c80 <swtch>
    80001be2:	b5fd                	j	80001ad0 <wait+0x2e>
    80001be4:	8305                	srl	a4,a4,0x1
    80001be6:	8b05                	and	a4,a4,1
    80001be8:	06eaae23          	sw	a4,124(s5)
    80001bec:	b7f1                	j	80001bb8 <wait+0x116>
    80001bee:	597d                	li	s2,-1
    80001bf0:	bf61                	j	80001b88 <wait+0xe6>

0000000080001bf2 <kill>:
    80001bf2:	00002717          	auipc	a4,0x2
    80001bf6:	bb670713          	add	a4,a4,-1098 # 800037a8 <procs+0x18>
    80001bfa:	4781                	li	a5,0
    80001bfc:	04000613          	li	a2,64
    80001c00:	a021                	j	80001c08 <kill+0x16>
    80001c02:	2785                	addw	a5,a5,1
    80001c04:	06c78363          	beq	a5,a2,80001c6a <kill+0x78>
    80001c08:	4314                	lw	a3,0(a4)
    80001c0a:	0c870713          	add	a4,a4,200
    80001c0e:	fea69ae3          	bne	a3,a0,80001c02 <kill+0x10>
    80001c12:	1141                	add	sp,sp,-16
    80001c14:	e406                	sd	ra,8(sp)
    80001c16:	10002673          	csrr	a2,sstatus
    80001c1a:	10002773          	csrr	a4,sstatus
    80001c1e:	9b75                	and	a4,a4,-3
    80001c20:	10071073          	csrw	sstatus,a4
    80001c24:	00002697          	auipc	a3,0x2
    80001c28:	aec68693          	add	a3,a3,-1300 # 80003710 <cur_cpu>
    80001c2c:	5eb8                	lw	a4,120(a3)
    80001c2e:	cb15                	beqz	a4,80001c62 <kill+0x70>
    80001c30:	0c800613          	li	a2,200
    80001c34:	02c787b3          	mul	a5,a5,a2
    80001c38:	2705                	addw	a4,a4,1
    80001c3a:	deb8                	sw	a4,120(a3)
    80001c3c:	00002717          	auipc	a4,0x2
    80001c40:	b5470713          	add	a4,a4,-1196 # 80003790 <procs>
    80001c44:	4605                	li	a2,1
    80001c46:	4689                	li	a3,2
    80001c48:	97ba                	add	a5,a5,a4
    80001c4a:	4398                	lw	a4,0(a5)
    80001c4c:	cb90                	sw	a2,16(a5)
    80001c4e:	00d71463          	bne	a4,a3,80001c56 <kill+0x64>
    80001c52:	470d                	li	a4,3
    80001c54:	c398                	sw	a4,0(a5)
    80001c56:	f86ff0ef          	jal	800013dc <pop_off>
    80001c5a:	60a2                	ld	ra,8(sp)
    80001c5c:	4501                	li	a0,0
    80001c5e:	0141                	add	sp,sp,16
    80001c60:	8082                	ret
    80001c62:	8205                	srl	a2,a2,0x1
    80001c64:	8a05                	and	a2,a2,1
    80001c66:	def0                	sw	a2,124(a3)
    80001c68:	b7e1                	j	80001c30 <kill+0x3e>
    80001c6a:	557d                	li	a0,-1
    80001c6c:	8082                	ret

0000000080001c6e <getpid>:
    80001c6e:	00002797          	auipc	a5,0x2
    80001c72:	aa27b783          	ld	a5,-1374(a5) # 80003710 <cur_cpu>
    80001c76:	c399                	beqz	a5,80001c7c <getpid+0xe>
    80001c78:	4f88                	lw	a0,24(a5)
    80001c7a:	8082                	ret
    80001c7c:	557d                	li	a0,-1
    80001c7e:	8082                	ret

0000000080001c80 <swtch>:
    80001c80:	00153023          	sd	ra,0(a0)
    80001c84:	00253423          	sd	sp,8(a0)
    80001c88:	e900                	sd	s0,16(a0)
    80001c8a:	ed04                	sd	s1,24(a0)
    80001c8c:	03253023          	sd	s2,32(a0)
    80001c90:	03353423          	sd	s3,40(a0)
    80001c94:	03453823          	sd	s4,48(a0)
    80001c98:	03553c23          	sd	s5,56(a0)
    80001c9c:	05653023          	sd	s6,64(a0)
    80001ca0:	05753423          	sd	s7,72(a0)
    80001ca4:	05853823          	sd	s8,80(a0)
    80001ca8:	05953c23          	sd	s9,88(a0)
    80001cac:	07a53023          	sd	s10,96(a0)
    80001cb0:	07b53423          	sd	s11,104(a0)
    80001cb4:	0005b083          	ld	ra,0(a1)
    80001cb8:	0085b103          	ld	sp,8(a1)
    80001cbc:	6980                	ld	s0,16(a1)
    80001cbe:	6d84                	ld	s1,24(a1)
    80001cc0:	0205b903          	ld	s2,32(a1)
    80001cc4:	0285b983          	ld	s3,40(a1)
    80001cc8:	0305ba03          	ld	s4,48(a1)
    80001ccc:	0385ba83          	ld	s5,56(a1)
    80001cd0:	0405bb03          	ld	s6,64(a1)
    80001cd4:	0485bb83          	ld	s7,72(a1)
    80001cd8:	0505bc03          	ld	s8,80(a1)
    80001cdc:	0585bc83          	ld	s9,88(a1)
    80001ce0:	0605bd03          	ld	s10,96(a1)
    80001ce4:	0685bd83          	ld	s11,104(a1)
    80001ce8:	8082                	ret

0000000080001cea <sys_getpid>:
    80001cea:	b751                	j	80001c6e <getpid>

0000000080001cec <sys_kill>:
    80001cec:	613c                	ld	a5,64(a0)
    80001cee:	5ba8                	lw	a0,112(a5)
    80001cf0:	b709                	j	80001bf2 <kill>

0000000080001cf2 <sys_wait>:
    80001cf2:	613c                	ld	a5,64(a0)
    80001cf4:	7ba8                	ld	a0,112(a5)
    80001cf6:	b375                	j	80001aa2 <wait>

0000000080001cf8 <sys_exit>:
    80001cf8:	613c                	ld	a5,64(a0)
    80001cfa:	1141                	add	sp,sp,-16
    80001cfc:	e406                	sd	ra,8(sp)
    80001cfe:	5ba8                	lw	a0,112(a5)
    80001d00:	cedff0ef          	jal	800019ec <exit>
    80001d04:	60a2                	ld	ra,8(sp)
    80001d06:	4501                	li	a0,0
    80001d08:	0141                	add	sp,sp,16
    80001d0a:	8082                	ret

0000000080001d0c <sys_fork>:
    80001d0c:	b9f9                	j	800019ea <fork>

0000000080001d0e <syscall_dispatch>:
    80001d0e:	6134                	ld	a3,64(a0)
    80001d10:	4711                	li	a4,4
    80001d12:	76dc                	ld	a5,168(a3)
    80001d14:	fff7861b          	addw	a2,a5,-1
    80001d18:	02c76663          	bltu	a4,a2,80001d44 <syscall_dispatch+0x36>
    80001d1c:	2781                	sext.w	a5,a5
    80001d1e:	078e                	sll	a5,a5,0x3
    80001d20:	00001717          	auipc	a4,0x1
    80001d24:	89070713          	add	a4,a4,-1904 # 800025b0 <sys_table>
    80001d28:	97ba                	add	a5,a5,a4
    80001d2a:	639c                	ld	a5,0(a5)
    80001d2c:	cf81                	beqz	a5,80001d44 <syscall_dispatch+0x36>
    80001d2e:	1141                	add	sp,sp,-16
    80001d30:	e022                	sd	s0,0(sp)
    80001d32:	e406                	sd	ra,8(sp)
    80001d34:	842a                	mv	s0,a0
    80001d36:	9782                	jalr	a5
    80001d38:	603c                	ld	a5,64(s0)
    80001d3a:	60a2                	ld	ra,8(sp)
    80001d3c:	6402                	ld	s0,0(sp)
    80001d3e:	fba8                	sd	a0,112(a5)
    80001d40:	0141                	add	sp,sp,16
    80001d42:	8082                	ret
    80001d44:	57fd                	li	a5,-1
    80001d46:	fabc                	sd	a5,112(a3)
    80001d48:	557d                	li	a0,-1
    80001d4a:	8082                	ret

0000000080001d4c <_start>:
    80001d4c:	4885                	li	a7,1
    80001d4e:	00000073          	ecall
    80001d52:	cd01                	beqz	a0,80001d6a <child>

0000000080001d54 <parent>:
    80001d54:	488d                	li	a7,3
    80001d56:	4501                	li	a0,0
    80001d58:	00000073          	ecall
    80001d5c:	fe054ce3          	bltz	a0,80001d54 <parent>
    80001d60:	4889                	li	a7,2
    80001d62:	4501                	li	a0,0
    80001d64:	00000073          	ecall
    80001d68:	a001                	j	80001d68 <parent+0x14>

0000000080001d6a <child>:
    80001d6a:	4895                	li	a7,5
    80001d6c:	00000073          	ecall
    80001d70:	4889                	li	a7,2
    80001d72:	4501                	li	a0,0
    80001d74:	00000073          	ecall
    80001d78:	a001                	j	80001d78 <child+0xe>

0000000080001d7a <forktest_end>:
	...
