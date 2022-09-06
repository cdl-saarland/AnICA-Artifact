add qword ptr [rbx + 0x40], 0x2b

cmovge r14, qword ptr [rbx + 0x40]

shl r13d, cl

vaddpd ymm5, ymm5, ymmword ptr [rbx + 0x40]

xor r14, r13

add qword ptr [rbx + 0x40], 0x2b
cmovge r14, qword ptr [rbx + 0x40]
shl r13d, cl
vaddpd ymm5, ymm5, ymmword ptr [rbx + 0x40]
xor r14, r13
