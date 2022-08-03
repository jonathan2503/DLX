
// questo documento sereve per organziare cosa fare per il DLX



class Basic_operation
{
	case std_operation [
    // add    (done)
    // addi   (done)
	sub
	subi
	nop
	]
	case logical_operation[  //done
    and
	andi
	or
	ori
	xor
	xori
	]
	case jump_op [
	beqz
	bnez
	j
	jal

	]
	case shift_op[
	sll
	slli
	srl
	srli
	]
	case LS_OP[
	lw
	sw
	]	
	case comparison_OP[
	sge
	sgei
	sle
	sle
	sne
	snei
	]

}




// _____________________ down here will be do after upper part will be done ______________________
class Pipeline {
	CU
}
class Datapath {
	write smart asm to verify that pipe works
}
class Synthesis {
	--
}
class Physical_design {
	--
}
class report {
	--
}
