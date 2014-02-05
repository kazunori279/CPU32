#
# CPU32 instruction verification code
# (each assertion will make an infinite loop if fails)
#

	# sh0
	nop
	addi	$t0,$0,-1
	sw		$t0,0x7f00
	addi	$t0,$0,0x0001
	sh		$t0,0x7f00
assert_sh0:
	lw		$t1,0x7f00
	lui		$t7,0xffff
	ori		$t7,$t7,0x0001
	bne		$t1,$t7,assert_sh0

	# sh2
	nop
	addi	$t0,$0,-1
	sw		$t0,0x7f00
	addi	$t0,$0,0x0001
	sh		$t0,0x7f02
assert_sh2:
	lw		$t1,0x7f00
	lui		$t7,0x0001
	ori		$t7,$t7,0xffff
	bne		$t1,$t7,assert_sh2

	# sb0
	nop
	addi	$t0,$0,-1
	sw		$t0,0x7f00
	addi	$t0,$0,0x01
	sb		$t0,0x7f00
assert_sb0:
	lw		$t1,0x7f00
	lui		$t7,0xffff
	ori		$t7,$t7,0xff01
	bne		$t1,$t7,assert_sb0

	# sb1
	nop
	addi	$t0,$0,-1
	sw		$t0,0x7f00
	addi	$t0,$0,0x01
	sb		$t0,0x7f01
assert_sb1:
	lw		$t1,0x7f00
	lui		$t7,0xffff
	ori		$t7,$t7,0x01ff
	bne		$t1,$t7,assert_sb1

	# sb2
	nop
	addi	$t0,$0,-1
	sw		$t0,0x7f00
	addi	$t0,$0,0x01
	sb		$t0,0x7f02
assert_sb2:
	lw		$t1,0x7f00
	lui		$t7,0xff01
	ori		$t7,$t7,0xffff
	bne		$t1,$t7,assert_sb2

	# sb3
	nop
	addi	$t0,$0,-1
	sw		$t0,0x7f00
	addi	$t0,$0,0x01
	sb		$t0,0x7f03
assert_sb3:
	lw		$t1,0x7f00
	lui		$t7,0x01ff
	ori		$t7,$t7,0xffff
	bne		$t1,$t7,assert_sb3

	# lhu
	nop
	lui		$t0,0x0102
	ori		$t0,$t0,0xf3f4
	sw		$t0,0x7f00
	lhu		$t0,0x7f00
	lhu		$t1,0x7f02
assert_lhu0:
	addi	$t7,$0,0
	ori		$t7,$t7,0xf3f4
	bne		$t0,$t7,assert_lhu0
assert_lhu1:
	addi	$t7,$0,0x0102
	bne		$t1,$t7,assert_lhu1

	# lh
	nop
	lui		$t0,0x0102
	ori		$t0,$t0,0xf3f4
	sw		$t0,0x7f00
	lh		$t0,0x7f00
	lh		$t1,0x7f02
assert_lh0:
	addi	$t7,$0,0xf3f4
	bne		$t0,$t7,assert_lh0
assert_lh1:
	addi	$t7,$0,0x0102
	bne		$t1,$t7,assert_lh1

	# lbu
	nop
	lui		$t0,0xf102
	ori		$t0,$t0,0xf304
	sw		$t0,0x7f00
	lbu		$t0,0x7f00
	lbu		$t1,0x7f01
	lbu		$t2,0x7f02
	lbu		$t3,0x7f03
assert_lbu0:
	addi	$t7,$0,0x0004
	bne		$t0,$t7,assert_lbu0
assert_lbu1:
	addi	$t7,$0,0x00f3
	bne		$t1,$t7,assert_lbu1
assert_lbu2:
	addi	$t7,$0,0x0002
	bne		$t2,$t7,assert_lbu2
assert_lbu3:
	addi	$t7,$0,0x00f1
	bne		$t3,$t7,assert_lbu3

	# lb
	nop
	lui		$t0,0xf102
	ori		$t0,$t0,0xf304
	sw		$t0,0x7f00
	lb		$t0,0x7f00
	lb		$t1,0x7f01
	lb		$t2,0x7f02
	lb		$t3,0x7f03
assert_lb0:
	addi	$t7,$0,0x0004
	bne		$t0,$t7,assert_lb0
assert_lb1:
	addi	$t7,$0,0xfff3
	bne		$t1,$t7,assert_lb1
assert_lb2:
	addi	$t7,$0,0x0002
	bne		$t2,$t7,assert_lb2
assert_lb3:
	addi	$t7,$0,0xfff1
	bne		$t3,$t7,assert_lb3

	# sw, lw
	nop
	addi	$t0,$0,1
	sw		$t0,0x7f00
	lw		$t1,0x7f00
assert_sw:
	addi	$t7,$0,1
	bne		$t1,$t7,assert_sw

	# lui
	nop
	lui		$t0,1
assert_lui:
	addi	$t7,$0,1
	sll		$t7,$t7,16
	bne		$t0,$t7,assert_lui

	# andi, ori, xori
	nop
	addi	$t0,$0,1
	andi	$t1,$t0,0xffff
	ori		$t2,$t0,0xffff
	xori	$t3,$t0,0xffff
assert_andi:
	addi	$t7,$0,1
	bne		$t1,$t7,assert_andi
	lui		$t7,0xffff
	srl		$t7,$t7,16
	bne		$t2,$t7,assert_andi
	lui		$t7,0xfffe
	srl		$t7,$t7,16
	bne		$t3,$t7,assert_andi

	# slti, sltiu
	nop
	addi	$t0,$0,1
	slti	$t1,$t0,-1
	sltiu	$t2,$t0,0
assert_slti:
	bne		$t1,$0,assert_slti
	bne		$t2,$0,assert_slti

	# addi
	nop
	addi	$t0,$0,1
	addi	$t1,$t0,1
assert_addi:
	addi	$t7,$0,2
	bne		$t1,$t7,assert_addi

	# addiu
	nop
	addiu	$t0,$0,1
	addiu	$t1,$t0,1
assert_addiu:
	addi	$t7,$0,2
	bne		$t1,$t7,assert_addiu

	# blez
	nop
	addi	$t0,$0,-1
assert_blez:
	blez	$t0,assert_blez_next
	j		assert_blez
assert_blez_next:

	# bgtz
	nop
	addi	$t0,$0,1
assert_bgtz:
	bgtz	$t0,assert_bgtz_next
	j		assert_bgtz
assert_bgtz_next:

	# bltz
	nop
	addi	$t0,$0,-1
assert_bltz:
	bltz	$t0,assert_bltz_next
	j		assert_bltz
assert_bltz_next:

	# bgez
	nop
	addi	$t0,$0,0
assert_bgez:
	bgez	$t0,assert_bgez_next
	j		assert_bgez
assert_bgez_next:

	# bgez (optimized to b)
	nop
assert_bgez2:
	bgez	$0,assert_bgez2_next
	j		assert_bgez2
assert_bgez2_next:

	# b
	nop
assert_b:
	b		assert_b_next
	j		assert_b
assert_b_next:

	# jr
	nop
	addi	$t0,$0,assert_jr_next
	jr		$t0
assert_jr:
	j		assert_jr
assert_jr_next:

	# jalr
	nop
	addi	$t0,$0,assert_jalr_next
	jalr	$t0
assert_jalr:
	j		assert_jalr
assert_jalr_next:
	addi	$t7,$0,assert_jalr
	bne		$31,$t7,assert_jalr_next

	# jal
	nop
	jal		assert_jal_next
assert_jal:
	nop
	nop
	nop
assert_jal_next:
	addi	$t7,$0,assert_jal
	bne		$31,$t7,assert_jal_next

	# slt, sltu
	nop
	addi	$t0,$0,0
	addi	$t1,$0,-1
	slt		$t2,$t0,$t1
	sltu	$t3,$t1,$t0
assert_slt:
	bne		$t2,$0,assert_slt
	bne		$t3,$0,assert_slt

	# and, or, xor, nor
	nop
	addi	$t0,$0,1
	addi	$t1,$0,-1
	and		$t2,$t0,$t1
	or		$t3,$t0,$t1
	xor		$t4,$t0,$t1
	nor		$t5,$t0,$t1
assert_and:
	addi	$t7,$0,1
	bne		$t2,$t7,assert_and
	addi	$t7,$0,-1
	bne		$t3,$t7,assert_and
	addi	$t7,$0,0xfffe
	bne		$t4,$t7,assert_and
	addi	$t7,$0,0
	bne		$t5,$t7,assert_and

	# sub, subu
	nop
	addi	$t0,$0,1
	addi	$t1,$0,-1
	sub		$t2,$t0,$t1
	subu	$t3,$t0,$t1
assert_sub:
	addi	$t7,$0,2
	bne		$t2,$t7,assert_sub
	bne		$t3,$t7,assert_sub

	# add, addu
	nop
	addi	$t0,$0,1
	addi	$t1,$0,-1
	add		$t2,$t0,$t1
	addu	$t3,$t0,$t1
assert_add:
	bne		$t2,$0,assert_add
	bne		$t3,$0,assert_add

	# divu
	nop
	addi	$t0,$0,3
	addi	$t1,$0,-2
	divu	$0,$t0,$t1
assert_divu_hi:
	nop
	mfhi	$t2
	addi	$t7,$0,3
	bne		$t2,$t7,assert_divu_hi
assert_divu_lo:
	nop
	mflo	$t2
	bne		$t2,$0,assert_divu_lo

	# div
	nop
	addi	$t0,$0,3
	addi	$t1,$0,-2
	div		$0,$t0,$t1
assert_div_hi:
	nop
	mfhi	$t2
	addi	$t7,$0,1
	bne		$t2,$t7,assert_div_hi
assert_div_lo:
	nop
	mflo	$t2
	addi	$t7,$0,-1
	bne		$t2,$t7,assert_div_lo

	# multu
	nop
	addi	$t0,$0,-1
	addi	$t1,$0,-1
	multu	$t0,$t1
assert_multu_hi: # hi should be fffffffe
	mfhi	$t2
	addi	$t2,$t2,2
	bne		$t2,$0,assert_multu_hi 
assert_multu_lo: # lo should be 1
	nop
	mflo	$t2
	addi	$t7,$0,1
	bne		$t2,$t7,assert_multu_lo

	# mult
	nop
	addi	$t0,$0,-1
	addi	$t1,$0,-1
	mult	$t0,$t1
assert_mult_hi:
	mfhi	$t2
	bne		$t2,$0,assert_mult_hi
assert_mult_lo:
	nop
	mflo	$t2
	addi	$t7,$0,1
	bne		$t2,$t7,assert_mult_lo

	# mtlo, mflo
	nop
	addi	$t0,$0,0x1
	mtlo	$t0
	mflo	$t1
assert_mtlo:
	addi	$t7,$0,0x1
	bne		$t1,$t7,assert_mtlo

	# mthi, mfhi
	nop
	addi	$t0,$0,0x1
	mthi	$t0
	mfhi	$t1
assert_mthi:
	addi	$t7,$0,0x1
	bne		$t1,$t7,assert_mthi
	
	# sll
	nop
	addi	$t0,$0,0x1
	sll		$t1,$t0,0x1
assert_sll:
	addi	$t7,$0,0x2
	bne		$t1,$t7,assert_sll

	# srl
	nop
	addi	$t0,$0,0x2
	srl		$t1,$t0,0x1
assert_srl:
	addi	$t7,$0,0x1
	bne		$t1,$t7,assert_srl

	# sra
	nop
	addi	$t0,$0,0x0
	addi	$t1,$0,0x1
	sub		$t0,$t0,$t1
	sra		$t2,$t0,0x1
assert_sra:
	bne		$t2,$t0,assert_sra

	# sllv
	nop
	addi	$t0,$0,0x1
	addi	$t1,$0,0x3
	sllv	$t2,$t0,$t1
assert_sllv:
	addi	$t7,$0,0x8
	bne		$t2,$t7,assert_sllv

	# srav
	nop
	addi	$t0,$0,0x0
	addi	$t1,$0,0x1
	sub		$t0,$t0,$t1
	addi	$t2,$0,0x3
	srav	$t2,$t0,$t2
assert_srav:
	bne		$t2,$t0,assert_srav

assert_finished:
	j		assert_finished

