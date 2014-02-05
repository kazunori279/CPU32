main:
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	li	$2,32512			# 0x7f00
	sw	$2,20($fp)
$L4:
	li	$2,1			# 0x1
	sw	$2,16($fp)
	j	$L2
	nop

$L3:
	lw	$4,16($fp)
	jal	fib
	nop

	move	$3,$2
	lw	$2,20($fp)
	nop
	sw	$3,0($2)
	lw	$2,16($fp)
	nop
	addiu	$2,$2,1
	sw	$2,16($fp)
$L2:
	lw	$2,16($fp)
	nop
	slt	$2,$2,26
	bne	$2,$0,$L3
	nop

	j	$L4
	nop

fib:
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	sw	$16,20($sp)
	move	$fp,$sp
	sw	$4,32($fp)
	lw	$3,32($fp)
	li	$2,1			# 0x1
	bne	$3,$2,$L6
	nop

	move	$2,$0
	j	$L7
	nop

$L6:
	lw	$3,32($fp)
	li	$2,2			# 0x2
	bne	$3,$2,$L8
	nop

	li	$2,1			# 0x1
	j	$L7
	nop

$L8:
	lw	$2,32($fp)
	nop
	addiu	$2,$2,-2
	move	$4,$2
	jal	fib
	nop

	move	$16,$2
	lw	$2,32($fp)
	nop
	addiu	$2,$2,-1
	move	$4,$2
	jal	fib
	nop

	addu	$2,$16,$2
$L7:
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	lw	$16,20($sp)
	addiu	$sp,$sp,32
	j	$31
	nop
