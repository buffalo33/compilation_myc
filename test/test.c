int main(){
int *s, p;
int n;
int r1 = 1;
n = r1;
beg_while1:
;
int r2 = n;
int r3 = 0;
int r4 = r2 <= r3;
if (!r4) goto end_while1;
{
beg_while2:
;
int r5 = n;
int r6 = 0;
int r7 = r5 >= r6;
if (!r7) goto end_while2;
{
int r8 = 0;
n = r8;
}
goto beg_while2;
 end_while2:
;
}
goto beg_while1;
 end_while1:
;
int r9 = n;
if (!r9) goto beg_else3;
{
int r10 = 1;
if (!r10) goto beg_else4;
{
int s;
int r11 = 0;
s = r11;
}
beg_else4:
;
}
goto end_if3;
beg_else3:
{
int s;
int r12 = 18;
s = r12;
}
end_if3:
;
int* r13 = s;
int r14 = 1;
int * r15 = r13 + r14;
s = r15;
return 0;
}
