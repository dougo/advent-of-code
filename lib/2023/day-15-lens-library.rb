=begin

--- Day 15: Lens Library ---

"Before you begin, please be prepared to use the Holiday ASCII String Helper algorithm (appendix 1A)." You turn to
appendix 1A. The reindeer leans closer with interest.

The HASH algorithm is a way to turn any string of characters into a single number in the range 0 to 255. To run the
HASH algorithm on a string, start with a current value of 0. Then, for each character in the string starting from
the beginning:

  - Determine the ASCII code for the current character of the string.
  - Increase the current value by the ASCII code you just determined.
  - Set the current value to itself multiplied by 17.
  - Set the current value to the remainder of dividing itself by 256.
  - After following these steps for each character in the string in order, the current value is the output of the
    HASH algorithm.

So, to find the result of running the HASH algorithm on the string HASH:

The current value starts at 0.
The first character is H; its ASCII code is 72.
The current value increases to 72.
The current value is multiplied by 17 to become 1224.
The current value becomes 200 (the remainder of 1224 divided by 256).
The next character is A; its ASCII code is 65.
The current value increases to 265.
The current value is multiplied by 17 to become 4505.
The current value becomes 153 (the remainder of 4505 divided by 256).
The next character is S; its ASCII code is 83.
The current value increases to 236.
The current value is multiplied by 17 to become 4012.
The current value becomes 172 (the remainder of 4012 divided by 256).
The next character is H; its ASCII code is 72.
The current value increases to 244.
The current value is multiplied by 17 to become 4148.
The current value becomes 52 (the remainder of 4148 divided by 256).
So, the result of running the HASH algorithm on the string HASH is 52.

The initialization sequence (your puzzle input) is a comma-separated list of steps to start the Lava Production
Facility. Ignore newline characters when parsing the initialization sequence. To verify that your HASH algorithm is
working, the book offers the sum of the result of running the HASH algorithm on each step in the initialization
sequence.

For example:

rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7

This initialization sequence specifies 11 individual steps; the result of running the HASH algorithm on each of the
steps is as follows:

rn=1 becomes 30.
cm- becomes 253.
qp=3 becomes 97.
cm=2 becomes 47.
qp- becomes 14.
pc=4 becomes 180.
ot=9 becomes 9.
ab=5 becomes 197.
pc- becomes 48.
pc=6 becomes 214.
ot=7 becomes 231.

In this example, the sum of these results is 1320. Unfortunately, the reindeer has stolen the page containing the
expected verification number and is currently running around the facility with it excitedly.

Run the HASH algorithm on each step in the initialization sequence. What is the sum of the results? (The
initialization sequence is one long line; be careful when copy-pasting it.)

--- Part Two ---

You convince the reindeer to bring you the page; the page confirms that your HASH algorithm is working.

The book goes on to describe a series of 256 boxes numbered 0 through 255. The boxes are arranged in a line
starting from the point where light enters the facility. The boxes have holes that allow light to pass from one box
to the next all the way down the line.

      +-----+  +-----+         +-----+
Light | Box |  | Box |   ...   | Box |
----------------------------------------->
      |  0  |  |  1  |   ...   | 255 |
      +-----+  +-----+         +-----+

Inside each box, there are several lens slots that will keep a lens correctly positioned to focus light passing
through the box. The side of each box has a panel that opens to allow you to insert or remove lenses as necessary.

Along the wall running parallel to the boxes is a large library containing lenses organized by focal length ranging
from 1 through 9. The reindeer also brings you a small handheld label printer.

The book goes on to explain how to perform each step in the initialization sequence, a process it calls the Holiday
ASCII String Helper Manual Arrangement Procedure, or HASHMAP for short.

Each step begins with a sequence of letters that indicate the label of the lens on which the step operates. The
result of running the HASH algorithm on the label indicates the correct box for that step.

The label will be immediately followed by a character that indicates the operation to perform: either an equals
sign (=) or a dash (-).

If the operation character is a dash (-), go to the relevant box and remove the lens with the given label if it is
present in the box. Then, move any remaining lenses as far forward in the box as they can go without changing their
order, filling any space made by removing the indicated lens. (If no lens in that box has the given label, nothing
happens.)

If the operation character is an equals sign (=), it will be followed by a number indicating the focal length of
the lens that needs to go into the relevant box; be sure to use the label maker to mark the lens with the label
given in the beginning of the step so you can find it later. There are two possible situations:

  - If there is already a lens in the box with the same label, replace the old lens with the new lens: remove the
    old lens and put the new lens in its place, not moving any other lenses in the box.
  - If there is not already a lens in the box with the same label, add the lens to the box immediately behind any
    lenses already in the box. Don't move any of the other lenses when you do this. If there aren't any lenses in
    the box, the new lens goes all the way to the front of the box.

Here is the contents of every box after each step in the example initialization sequence above:

After "rn=1":
Box 0: [rn 1]

After "cm-":
Box 0: [rn 1]

After "qp=3":
Box 0: [rn 1]
Box 1: [qp 3]

After "cm=2":
Box 0: [rn 1] [cm 2]
Box 1: [qp 3]

After "qp-":
Box 0: [rn 1] [cm 2]

After "pc=4":
Box 0: [rn 1] [cm 2]
Box 3: [pc 4]

After "ot=9":
Box 0: [rn 1] [cm 2]
Box 3: [pc 4] [ot 9]

After "ab=5":
Box 0: [rn 1] [cm 2]
Box 3: [pc 4] [ot 9] [ab 5]

After "pc-":
Box 0: [rn 1] [cm 2]
Box 3: [ot 9] [ab 5]

After "pc=6":
Box 0: [rn 1] [cm 2]
Box 3: [ot 9] [ab 5] [pc 6]

After "ot=7":
Box 0: [rn 1] [cm 2]
Box 3: [ot 7] [ab 5] [pc 6]

All 256 boxes are always present; only the boxes that contain any lenses are shown here. Within each box, lenses
are listed from front to back; each lens is shown as its label and focal length in square brackets.

To confirm that all of the lenses are installed correctly, add up the focusing power of all of the lenses. The
focusing power of a single lens is the result of multiplying together:

  - One plus the box number of the lens in question.
  - The slot number of the lens within the box: 1 for the first lens, 2 for the second lens, and so on.
  - The focal length of the lens.

At the end of the above example, the focusing power of each lens is as follows:

rn: 1 (box 0) * 1 (first slot) * 1 (focal length) = 1
cm: 1 (box 0) * 2 (second slot) * 2 (focal length) = 4
ot: 4 (box 3) * 1 (first slot) * 7 (focal length) = 28
ab: 4 (box 3) * 2 (second slot) * 5 (focal length) = 40
pc: 4 (box 3) * 3 (third slot) * 6 (focal length) = 72

So, the above example ends up with a total focusing power of 145.

With the help of an over-enthusiastic reindeer in a hard hat, follow the initialization sequence. What is the
focusing power of the resulting lens configuration?

=end

class LensLibrary
  def self.parse(text)
    new(text.chomp.split(','))
  end

  def initialize(init_seq)
    @init_seq = init_seq
    @boxes = 0.upto(255).map { Box.new(_1, []) }
    perform_hashmap!
  end

  attr :init_seq, :boxes

  def self.hash_algorithm(string)
    cur = 0
    string.codepoints.each do |codepoint|
      cur += codepoint
      cur *= 17
      cur %= 256
    end
    cur
  end

  def hash_results
    init_seq.map { self.class.hash_algorithm(_1) }
  end

  def sum_of_hash_results = hash_results.sum

  Lens = Data.define(:label, :focal_length)

  Box = Data.define(:id, :lenses) do
    def add_lens!(lens)
      index = lenses.index { _1.label == lens.label }
      if index
        lenses[index] = lens
      else
        lenses << lens
      end
    end

    def delete_lens!(label)
      lenses.delete_if { _1.label == label }
    end

    def total_focusing_power
      lenses.each.with_index(1).sum { |lens, i| (id + 1) * i * lens.focal_length }
    end
  end

  def box(label)
    boxes[self.class.hash_algorithm(label)]
  end

  def add_lens!(lens)
    box(lens.label).add_lens!(lens)
  end

  def delete_lens!(label)
    box(label).delete_lens!(label)
  end

  def perform_hashmap!
    init_seq.each do |step|
      if step.end_with? '-'
        label, _ = step.split('-')
        delete_lens!(label)
      elsif step.include? '='
        label, focal_length = step.split('=')
        add_lens!(Lens.new(label, focal_length.to_i))
      end
    end
  end

  def total_focusing_power
    boxes.sum(&:total_focusing_power)
  end
end

if defined? DATA
  lib = LensLibrary.parse(DATA.read)
  puts lib.sum_of_hash_results
  puts lib.total_focusing_power
end

__END__
dm=4,rx=5,hh-,kms=8,qrqh=5,ptxhg-,ckhp=2,qq-,cdzffg=6,dzlzq-,njd=1,zcj=3,jlc=1,dfs=7,lrfkx=7,jk-,tncqjp=8,qj-,cxn=1,fff-,lfz-,vnlrf=7,dfd=2,vhc-,tgdc-,nfnm-,hdp-,pjj=1,cvrx=6,sv-,bg=5,hdn=5,tncqjp-,tmjbj-,plrh-,cxv=5,tdnd=6,cbf-,txgnc-,cj=4,cxqkb=9,ph-,qf=5,ql-,fd-,ptcccz=7,tx=2,zvz-,xxmrh=5,hkk-,bcx=3,qb=2,cvn-,frp=5,lls-,jdjg=9,zg-,kt=8,nv=9,gn-,nx-,jk-,dblkrq-,flfq=1,zcj-,cs=1,xxj=9,klz=5,dhvm-,sc-,tc=5,rjq=7,hkk=5,qgm=9,bjh=7,xpzb=8,cvn=1,vs=5,bz-,xc=1,kdp-,bqh=8,qkb-,lcpg-,mrq-,xnm-,hhnvf-,mnqc-,tdnd=2,mnh-,smj-,smj-,ph=7,sv-,ppj=6,stflrl-,rh-,kxt-,pr=9,dhc-,jxv-,lhz-,cpjjqm=5,jskxb-,ql-,mvl-,lqcv=5,rzzzz=8,ph=1,khq=9,rjq=7,cfl-,st-,smj=1,lfz=4,hvkq-,csnng-,flsjk=5,jxs-,gb=5,zvz=1,cgj=1,fcx=9,zvz=4,bdk=3,hvkq=9,zp=1,llf=1,gs-,jbsp-,jxn-,sqgpgj=8,ps-,dg=7,kzl-,gck=2,lls=8,qjq=7,bb-,bz=8,mg=9,nmxl-,sp=3,tpcr=8,bcx=6,kxt=5,mtqx=3,fxf=7,fbv-,qjq=3,gprt=4,xgd-,tznt=1,rcv=9,llf-,sc=4,tn=3,mjx=6,fqgh=4,fd=7,rh-,tncqjp-,sm-,pk=6,rm-,hdn=2,hkk=8,mtqx-,sn-,dhj=3,npl-,bnt-,ddtm-,rm-,qmg-,nv=6,qgrp=8,ls=3,nsfgvq-,rp-,fxjjmz=4,gc-,lvdp=1,kxt-,hkk-,bt=5,ztb-,qpv=5,fpvl=9,gprt-,ghv=1,cs=7,lfz-,qrqh-,lqcv=6,ppj-,dm-,slx=2,rcd-,kf=8,hl-,tgdc-,lmh-,fbv-,sc-,slbc-,nrrt=7,zvz-,csc=4,gnsk=6,lrxq=2,msvd=6,fxf-,qjq=8,fdk=6,cqx-,vgh=7,nrrt-,gtv=5,csc=6,fpvl=3,rn-,qth=5,bkkkm-,gm=2,st=1,nt-,tpn=9,rzm-,csnng=1,zjx=4,kms-,kms=6,qj-,cs-,dhj=3,gbrv=5,vfrmk=4,gbrv=4,pk=2,qf=2,txlq=6,nbl=6,jt-,jppx=3,rp-,gdp-,qft-,mbd=8,kv=8,pnxcd=9,zsv-,sqg=8,tbqs-,pmjr=7,tdnd-,hd-,fbv-,kk=1,cv=3,jdvq=8,nvfc-,nd=1,dhvm-,cpbppv=3,sth=7,xxt-,htmk-,zg-,hdn=2,fpvl=1,tdnd=5,hzf-,prz=8,fff-,nbhc=3,rkd-,pbq-,bn=8,bjhvv=7,tgdc=4,bqr-,qgm-,crm=2,pr-,ktt-,gnsk-,cpjjqm-,st-,gjsgh=9,bkkkm=3,lt-,gs=2,pkk=2,kbdvdt=2,zs=1,gn=9,kfn-,fm-,vgh=9,cfl=5,kh=9,qcbvm-,qn=6,ggx-,lp=7,cbf-,gnsk=3,cs=4,hdn-,sc-,gb=5,vpv-,zs-,pg-,nn-,bf=1,gplmkr-,nlv-,qm=7,mg=4,xsnz-,lrs-,dblkrq=3,ln-,ftnk-,fnxh=8,kbdvdt-,zmzzs=8,jnrj=7,dhvm-,qjrxp=5,rqlj=8,npl-,hd=5,mtqx-,xcd-,dtx=6,bg=7,cxqkb-,csc=9,gcn=5,dg-,dn-,ks-,bkkkm=4,bzlj=9,gj-,qpv=9,llf=3,gbg-,dxf-,nt-,fm=1,gk-,jppx-,kv=2,bdk-,lrs=1,cs-,ngxt-,hvkq-,nbhc=1,pg=8,dfb-,tgdc=4,bgsflk=1,jx-,gb=6,tdnd-,nmxl-,hj=6,klz-,cbf=7,blgg-,zcpzf=4,dc=7,llclt-,tgdc=4,sxhlxg-,tn=9,rkv=9,cxn-,sth=7,bb-,gpg=5,fxf=3,gpg=9,jbsp-,hhnvf-,vfg-,hvkq=6,fqp=7,ztb=6,klsg=3,bjhvv-,mtqx-,tzjq-,gcz-,bfg=8,fcx=3,gck-,xghv-,vznd-,dns-,hp=8,ch-,cxv=7,fdd-,kdp-,gf=3,cxqkb-,zfrzvf-,nrrt-,gp-,gcz-,gr-,gk-,lj=6,ql-,kzxh=5,fxjjmz=6,mt-,zcj-,hfgcl-,nz=7,sp=9,pjsrpz-,hc-,ckhp=3,cnz-,rkd-,ddd-,jxs-,qcbvm=8,fqp=2,xh-,bjh=9,vhc=5,fqgh-,gck-,cvn-,qkxb-,pkk-,nt=4,qgz-,ktjg=5,gj=7,cdzffg-,lkztb-,jxv=9,dhc=1,gcn-,dhx=7,cv=5,dfd-,lrxq-,cqx-,fbv-,rkd-,sqgx=7,cs=1,qft-,cjkg-,fp=7,jppx-,rjq=4,bkkkm=4,flfk=6,xgd=3,drzx-,hgdm=1,qb=9,qpc-,rkhb-,jdjg-,hl=8,nbbp=3,xhb-,mxzmk-,frg=1,qq=6,lcpg=9,hk-,lhz-,nrg-,sp-,ph-,bs=9,kn=5,txgnc=3,tp=3,cs=4,kf=9,gpxt-,tkkr=9,lcpg-,htxzkm=2,xzt=3,dn=1,gn-,nskc=6,jxn=1,rzzzz-,cvn=7,tzjq=9,zvz=7,jbp-,ngp=3,lls-,nsgv=5,jt-,fbv=7,sxhlxg-,qk=1,gc=7,jhtdh=9,qcbvm-,zdrxq-,cvq=3,gzgkz=7,gjp=8,nrg-,rkv=3,zmsssr-,ndh-,mr-,bc=5,rfp-,sqgpgj-,rm=8,vpv-,prz-,db-,nt=7,ft-,cxn-,kqr-,fqj=1,drzx=2,qk=6,cvn=5,hvn-,tn-,sqgx-,zdrxq=2,qjq=7,hxm-,lxpr-,gr-,gbg-,bfg-,vd-,chnp-,tpn=3,bfg=9,pmjr=9,smj-,rqlj-,lfz-,cpjjqm-,ds=9,mr=3,ckjtz=5,gf-,hhnvf=7,hfgcl-,tdnd=3,pjj-,fpvl-,kmn-,pmjr-,vv=4,qs-,zdrxq=2,qrd-,kbdvdt-,rjq-,qgz-,qcbvm-,jskxb=9,fzq-,jxm-,lfz=2,hgpz=1,mtqx=2,hk=6,ngxt-,cxqkb=6,ch=1,dhvm=8,zl=8,rjq-,khtv=1,xz=8,gs=2,xf-,gplmkr=3,cqx-,qq-,nqnc=4,dm=3,nz=7,cxqkb=8,bkn-,jppx=6,qcbvm=7,gbrv-,nv=2,bt-,xzt=4,fxjjmz-,kv=6,cxn-,vnlrf-,qpc-,fxjjmz-,ckjtz-,tf=8,qb=7,zs=1,sqgx=2,gpg=1,jvhvq=6,tpn=6,zqglp=3,djqcm=1,bb-,gnsk=7,ft=1,gj-,dpr=8,sc=3,kv-,pk-,tc=7,jbsp-,cv=8,pk=8,vc=9,tdn=5,flfq-,lls-,xxt=3,xlj=9,cxqkb-,bn-,sgrkl=2,lfz=1,tc=4,qrqh=3,llf=5,fxjjmz=9,ps=1,bvf=7,jfx=3,kxt=3,xlj-,rkkm-,kdp-,vznd=9,tn=2,plrh=3,vznd=1,nlv-,qm-,hr-,nbhc=2,pzq=2,hdn-,dl-,bxm-,dm=6,hc=8,fz=9,xzt-,ps=8,bkkkm-,lm=8,mvl-,rvcrz=1,fzn-,fxf-,sv-,sth=9,qrd=6,bcs=5,fdd=1,llf=3,rjq-,smmtp=2,fdd=9,nx-,lqcv=1,jhtdh-,fhmcg=7,xztdb=5,pbq=5,kj-,pkk=8,dn-,hlf=3,bgsflk-,fdk=7,ml-,kn=2,dtx-,fcx-,dr-,vbjl=1,xdckv-,lt=9,bgsflk=2,cf-,jxs=6,pdpzb=1,qth-,zvz=4,nlv=4,zt=6,xqg=8,flsjk-,gprv=2,gprt-,bt-,ht=2,cvrx=9,mtk-,pbvl=8,dmn-,dm=3,cqx=3,gv-,llclt=8,bz=5,bnt-,qdl=4,qc=8,rh=3,sqg=8,hvn-,bb=3,nd-,qk=3,tncqjp=6,bnt-,cxqkb=7,dxf=1,tncqjp=9,vv=4,ngp-,jmx=8,klz-,llf-,fxjm-,ddtm-,hvkq-,jmx-,sqg-,djqcm=2,rkhb=6,qq=2,gvl-,vsz=6,nrrt=6,gf-,fpvl-,bs=9,pj=1,lj=1,hj=2,xhb-,lrfkx-,tx=3,cgj=1,vhx-,xc-,ftnk-,ztfkv-,zcpzf-,blgg=6,nvpk-,fc=6,fcx=3,gc=5,bknn-,zcj=3,jjj=2,tdnd=5,nrg=3,zs-,qm=5,dhj=6,xhb-,xqg=7,cpbppv-,slx-,qpv=3,nxt-,qrd=1,tgdc=4,qm-,kk-,zsv=5,vr-,qkb-,bbl-,ml-,qkxb-,fzj=8,bv=2,ls-,flfk-,xpzb=1,nv-,zzsl-,jppx-,cf=4,dzlzq-,vfg=5,gcz-,smj-,fcx-,cvrx-,fc-,jskxb-,gf=2,sxhlxg=2,mg-,tgt-,ht=6,xdckv=1,hhnvf-,qb-,llclt-,qb-,dhj-,gprv-,khq-,gf-,hp=6,rzzzz=8,tzjq=3,rzzzz-,pbq=8,ps=7,hlf=4,pssq-,jrk-,pjj-,lls-,fc=6,cpbppv-,vxx=3,djqcm-,vdbccp-,ktjg=7,tpcr=4,vj-,gb-,sp=4,dsrt-,tbqs-,lcpg=9,hlf=5,gjp=3,tx-,nmptp=7,cgj=3,ddd=6,kf-,hkk=4,lhz-,dhx=6,ptcccz-,nvfc=4,dfd-,sn-,xkm=9,dl=6,nmxl=8,rvcrz=8,zktb=2,cj-,ql-,bqr-,gtv=1,ht=6,jbp-,zfkx=6,fl=5,fxjjmz=2,zqglp-,gprv=5,jxm=4,gck=8,pgn=5,gprt-,dh=5,qgz-,hvn=7,qgm=1,dvdkf=1,hdq=8,fx-,zvz=1,zdrxq=3,mtk-,qkxb-,pnxcd=2,xc=2,kbdvdt=9,pdpzb-,fnxh=6,xxmrh=3,jhtdh-,sv-,cxv-,pbq-,slx=6,txlq-,mjn-,ggx-,cxqkb-,ft=3,hf-,kn-,bnt-,hzf-,scd-,ggx-,jk=4,dr-,dtx-,sqgx-,qj=7,bn=4,tmjbj=4,jx-,qf-,rjq=2,ktt-,rfp-,pzq=2,zsv=3,xsnz=2,lrxq-,jdjg-,qcbvm=9,vc-,xhb-,ngxt=1,lj=7,mvl=2,jjj-,lqcv=5,fxjm=5,qk-,zl=3,kms=9,sgrkl-,ckhp=3,rh-,zqglp=8,kcr-,ch-,nsgv=4,fc-,fh=9,fdh=2,mbd=2,tgt-,qdl=1,qmg-,ckhp-,fzn=3,qj=4,vhx=9,nj-,bv=6,klz-,lvdp-,sk=9,xqg-,gp-,cxqkb=9,sh=4,ml-,rdp=6,tdpc=5,ls=9,nbbp-,hh=7,zfrzvf-,vbjl-,ct=4,bs-,nv=7,kj-,cpjjqm=5,pdpzb=2,kdp=8,pzq=1,jt-,tgt=9,cfnp-,tncqjp=6,jvhvq=7,nknx-,pnx=2,kv=6,dg=8,xh-,mtk-,cxn-,crm=1,kdp=3,khv=7,gjq-,fhlf=8,nx-,cnz=3,nxt=4,bnn-,hdq=2,cpbppv-,kk=3,dfb=7,xqg-,sm=3,qft=3,hxmpn-,vf=3,vc-,tgt-,klsg-,xkm=1,flfq-,nbbp=1,lrs-,zgkm=5,nvpk=4,xdxjxn-,gr-,fxjm-,gplmkr=8,cdzffg=4,ptxhg-,mjn=1,jrk=3,mqxgv=6,fzn-,zvh-,pqkd=7,fxjm=1,tx=6,jkb=5,bv-,lp-,bqr-,bcs-,gck-,txgnc=6,crc=7,ckhp-,zktb=9,hp-,vbjl=3,kcr=5,qrqh=3,fdd-,bfg=3,bn-,qgrp-,lrs=1,fm=7,tgt=2,zf-,bv-,gj-,ntx=1,ghv-,sgrkl-,qmg=1,dblkrq-,tqxxm=9,ptxhg-,qpv=4,sqz=2,xhb-,khq=1,hd=6,rx-,zmsssr-,ht=4,fp=4,qgj=6,crm=6,gd=8,dxf=7,slbc-,ptcccz-,htmk-,pkk-,dmn=5,fp=7,txlq=2,xnb=1,lt=3,khtv=9,nsgv-,lhz=7,bvf-,fh-,cvrx=6,sqg-,jppx-,vhx=7,nfnm=1,ql=4,fz-,fpvl=3,qpv-,hdp=8,mnqc-,bcx-,vd-,fzzvq-,ckhp-,jdvq=3,cdzffg-,bcx=5,fqj=8,gpg=2,xlj=4,fdk-,gj-,rcd=6,tpn-,lfz=1,qrqh-,vsz-,pdpzb=9,qmg-,fqgh-,fzq-,jxn-,bcx=8,qm-,hf=6,nknx-,ntx-,jxv=5,jhtdh=7,gbg-,ckhp=8,vhx=2,rp-,dfs=5,fcfn=6,pdpzb-,hc-,nlv-,pg-,lrvlxq=3,cvn-,hvkq-,tqxxm=6,gjp=2,cvrx-,tgdc=7,tpxz=9,bnn-,vnlrf-,gp-,nbhc=1,jx=6,nmptp-,nmptp=7,qgm-,pbq-,klz=7,ftnk-,mjn-,sqgpgj-,pfzm=4,bn=5,smj=1,khv=3,nsgv-,rh=6,dn=5,gprt=3,pgn-,tncqjp=8,dc=4,nskc=8,jbsp-,lkztb-,zktb-,kmn-,rtpg-,hbpk=6,qdl=6,kmn-,dhvm=6,xdckv=4,zvh-,gtv-,fqp=5,khv-,tf=8,gtv-,mtqx-,dc-,xxt=5,zqglp-,gm-,xq=7,tmjbj=2,zl=1,xgnqq-,qxcgvg=5,bnn-,tf-,fbv=5,dhx=1,gv-,sn-,qkb=8,lm-,dfs=1,gn=5,kxt-,sp=8,mbd=3,rkkm-,zs-,vl=5,pk-,plrh-,hd-,tbqs-,nsfgvq=8,ndft-,lj-,xmg=6,lpfp-,vpm-,zgkm-,bg=6,ngxt=8,gm=2,gp=6,vsz=5,nmxl=1,lj=9,pfzm=5,hvn=1,sqz=6,dhx-,ndft-,qs=1,tncqjp=2,zxg-,dm=1,xlj=1,hvn=1,hc-,tqxxm-,pkk=7,jt=3,rcd-,bkkkm-,nrrt=8,nlv=8,jskxb=2,flsjk-,bf=3,dh=2,jxm-,pnx=6,mjx=7,dblkrq-,gvl=2,xkm=8,kqr=5,tdpc-,gdp=8,vnlrf-,mr-,jk=5,ztb=6,ct-,fx=4,dh=5,djqcm-,djqcm-,tq-,zxssjv-,tkkr=5,zjx-,ssp=9,cmr=4,kt=3,sp=7,qgj-,jjj=3,nfnm=8,pzq=2,ngxt=9,bqh=7,fxjm=7,vgh-,vr-,bfg=7,gvl=9,dg-,blgg=2,db=5,pbq=2,djqcm-,jxv=9,ls-,bbl=7,frp=7,jt=4,rj-,ngxt-,gpg-,fqgh-,sqgpgj-,ntx-,cvn=5,bqh=7,xztdb-,zmsssr=4,sc=7,fdd=8,lp-,zc-,cdzffg=1,jxv=9,qth=1,fp=5,gjsgh-,xztdb-,rm=1,bcx-,kzl=2,vhc=5,slbc=9,fp=4,mjx=9,hr=3,dblkrq-,xkm=3,ktjg=7,gf=3,pg-,xnm=9,sm-,tgdc=6,gnsk=5,kk-,ndft-,ds-,jfx-,mqxgv-,sp=3,ptcccz-,kxt-,vj-,cvq=1,bdk=8,bt=4,pgn-,xq-,xq=7,qk-,cfnp-,ndh-,lpfp=6,sp=4,txgnc-,nmptp=7,nlv=1,prz=5,ml-,xz-,zmzzs=1,llf-,db=3,sxhlxg=8,smj-,gb=8,ks-,bqr-,cq=4,dn-,chnp=9,hfgcl-,qgj=1,rn=1,nbl-,hc-,xh-,cq=8,jdvq-,qxcgvg=4,xghv-,mqxgv-,vh=6,cpjjqm=1,rtpg=8,pz-,qkxb-,rdp=6,mrq-,nrrt-,fdd=9,xz=5,kzxh-,mh-,lj-,lrfkx=7,flfq-,nskc-,cnz=8,cv-,fdx=2,jvhvq-,jxs-,kv-,chnp=1,kxt=4,xc=9,dhx-,hc=7,vl=2,cbf-,dxf-,gtv-,fzj=2,jx=2,sp-,qk=1,lmh-,lls-,lkztb=3,bfg-,slx=4,dhc-,zt-,ngp-,qq=6,slbc=8,kx=3,frp-,jskxb=8,sm=5,cxv-,lcpg=4,gs=5,dfs-,ql-,gprv-,mcd=9,khq=7,hkk=5,zs-,rp=4,fx=9,dxf=9,zcpzf-,frp=4,jvhvq=6,ls-,ml=7,kx=2,cjkg-,crm-,gjsgh=2,fzq=7,fzn=8,rj=9,gr-,sn-,qgrp-,dhvm=9,zgkm-,dxf=3,dc=5,bjhvv=1,plrh=3,rp-,rcv=6,fkb-,scd-,nt=4,nsfgvq-,sth=9,rqlj-,jx-,cq=5,xmg-,nmptp-,sxhlxg=6,vgh-,sqgpgj=5,chnp-,fcfn=2,bjh=6,gs-,flsjk-,tmjbj-,mcd-,ngp=4,jnrj=5,zgkm=6,tpxz=6,sk-,kj=2,tdnd=5,nt=3,xz=5,fn=3,tpxz-,vnlrf=8,qgz-,tn=7,fp=5,jmx=4,llf-,bbl-,cjkg=8,fzn=3,pz=7,dfs=6,zczr-,dfr=2,cxv=8,cvn=1,zmsssr=5,djqcm=6,dc-,nvpk=4,dpr=9,bv=2,slbc=5,mjx=8,db=8,sh=2,rcd=8,dns-,nvfc=6,bdk-,sc-,bc=7,nvpk-,fpvl=4,hfgcl=3,hvkq-,crc-,pr=8,bb=1,bknn-,xnh-,rzm=3,tgdc=7,bf-,xnpxxl=7,lkztb=9,bb=5,ct=2,hhnvf-,ghcqvp-,gprt=5,xdxjxn-,rz=8,dsrt-,ngxt=4,cs-,lpfp=1,bz-,vsz-,bcx-,fbv-,cdzffg-,vl=3,flsjk=7,hd=6,jgl=6,rj=5,tp=5,crm-,mvl-,bxm=3,xzt-,rj=2,gzgkz=7,zs=3,zcpzf=6,cbf=7,ckjtz=7,kx-,sqgx=7,dvdkf=5,gnsk=1,vdbccp=7,pz-,cmr=4,xc=3,zg=7,lt=1,zczr=9,sqgpgj-,dl=4,bknn-,nkqcv-,rj-,cxn=5,gp=2,hxm=7,zcpzf-,hvn=2,vdbccp-,mtk-,gcz=6,gp=1,llclt=2,pk-,gcn=4,xpzb=3,jjj-,zqglp=8,sxhlxg=9,sxhlxg-,ll=5,hbpk-,frg-,fl-,hhnvf-,csc-,fzn-,cf=4,lrxq=5,fdd=6,ll=9,hr=9,ggx-,nbbp-,dfd=1,xc-,cv-,cjkg-,stflrl-,vpv=6,rzzzz=9,nt=7,nrg-,rp=9,tmjbj=6,kqr-,lvdp-,tgt-,zg-,kzl=6,sth=1,jkb=8,ccsj-,ztb=1,rm=1,nd=1,vdbccp-,rz=2,fdk-,rkd-,lqcv-,ktjg=9,ntx=2,fdk-,fm-,ntx-,mqxgv-,llclt-,fxf=4,nz=4,vs-,vh-,prz=7,jgl-,lcpg=9,zzb-,qn-,nknx=9,ssp-,kv=6,sxhlxg-,vh-,pgn-,pjj-,kf=2,cjkg-,jbsp-,hs-,kt=2,hc=7,qth-,nn=4,nknx-,tgdc-,dfr-,gcz-,hdn-,pzq=4,khv-,nn=2,cv-,txgnc-,qpv=4,ccsj-,ps=9,sn-,vpm-,qk-,jbsp-,jk-,hr-,rkd=4,zsv=5,rdp-,xztdb-,djqcm-,qgj=3,dhj=1,zmzzs=3,jskxb=2,mtqx-,hlf-,vl=1,tpcr-,cs-,db-,xxt=3,qs-,lrs=9,fqj=1,mnqc-,dfd-,nbhc-,gr=1,xpzb-,vhx-,mnqc-,vzb=3,frp-,jt-,hk=1,zmzzs=1,mtqx=3,xnpxxl=2,hj-,gj=2,smj-,fzn-,rfp=5,gprv-,jrk=2,fcfn=2,nvpk-,bknn=7,mrq=1,ktt=8,kx=4,tq=3,fx-,fqp-,mr-,zzb=6,lcpg-,gprv-,gv=5,fc=4,bqr=1,hxmpn=2,fkb-,qkb-,rkv-,qdl=7,blgg-,gjp=2,gpg-,kv=1,llf=2,sn-,htxzkm=3,kdp-,sth=3,gf=9,hql-,gjq=2,fzj-,ndh=6,csnng=7,zjx-,pk-,pk-,njd=4,jd=2,ntx=9,qmg=6,pjsrpz-,jd-,dtx=5,mtk=8,cvrx=6,zl=6,ds=8,nsfgvq-,ddd=1,gs=7,jlc-,ph=7,bf=4,fkb-,tf=6,tgt-,jfx=6,npl-,xlj-,jnrj-,gf=6,jd=6,plrh-,rm-,fhlf-,zdrxq=3,kj=5,nj-,tkst=2,tpcr-,qmg-,bkkkm-,bb-,qn-,sh=6,hfgcl-,bz=4,nsfgvq=9,rm-,tbqs=3,zgkm-,drzx=7,xpzb=4,ghcqvp-,bkkkm-,tkst-,zcpzf-,khtv-,lt-,hkk=4,xghv=8,kzl-,gm=4,ppj-,fl-,gs-,gprv-,tp=6,nlv-,tdnd=1,ghv=6,fn-,dhc=4,mnh=6,cs=1,crm-,cxqkb-,gj-,kn-,kxt=4,cgj-,zf-,ktt=7,gr=3,gbg=7,flfk-,nxt-,nlv=1,ch=5,dsrt=9,dfb=8,rkkm=3,qpc-,fzzvq-,lm=4,ls=5,xzt=1,xq-,mxzmk=1,kbdvdt=9,fhlf-,kqr-,dm-,qjq=8,hr=2,vgh-,sk=3,mcd=2,cgj=4,rkv-,gcn=1,ptxhg-,hc=5,csc-,bgsflk-,bvf-,gm=8,gdnfv-,xmg=3,kv=9,pbvl=2,nbbp=6,jppx=5,dtx-,zczr-,ph-,vznd=7,db-,gf-,msvd=6,tp=9,gm=9,cpbppv=9,qkb-,csnng=3,xxmrh=1,ph-,fzj-,gk=5,xlj-,txlq=2,dg=6,jppx=6,fcx-,qb=1,fcx-,dmn=5,kmn-,dpr=7,fdd-,st-,dfr=2,jgl=2,dhj=7,tgt-,bzf=4,lcpg=1,txlq-,frg=3,cqx=2,zvz-,vhx-,jk-,vnlrf-,lrvlxq=5,tp=9,qrd-,ktt-,dns-,jdvq=1,fkb=6,gr-,jkb-,crc=6,vfg=4,dhc-,nrg=5,vpm-,smmtp=1,htxzkm-,xxj-,sc-,mg-,hh=5,xz-,xpzb=6,ml-,ht-,zktb=1,rzm-,dvdkf=5,jbsp-,ft-,ds=1,dhvm-,gcz=2,tpcr=1,xkm-,tzjq=4,hh=4,pk-,ztb=9,ckjtz-,sqg=3,gj-,hfgcl-,lrxq-,xz=5,nbbp=6,nd=1,rh-,fcx-,rj=4,vhx-,vfg-,sth-,xztdb=6,fp-,bz=5,khq=6,npt=5,drzx=6,khtv-,pbvl=9,ccsj=1,rqlj-,rcd=2,jkb-,bqr-,hh=1,dvdkf=2,mjx-,zvz=4,tmjbj=5,zs-,dg=2,ppj=1,fpvl=1,gb=2,tgdc=9,jppx=7,tf-,ptxhg-,tzjq-,jfx-,qft=8,dmn=8,hp-,dh-,lhz-,nrg=3,xnh-,ll=2,pzq-,fhlf-,qrd=4,mt=5,pjj=8,xnb=4,vf=7,ktjg-,pgn-,vd=6,vfg-,ls=8,tpcr-,hbpk-,hj=9,dns-,qpc-,dn-,xh=4,ll-,sn=2,hql=7,zmzzs-,qj-,qrqh=5,qs=9,fcfn=2,hp-,ssp-,zs=2,mr=3,jskxb=6,rh-,dfd=9,sgrkl=3,pnx=6,bkn=2,xqg-,bnn-,vhx-,gprt-,cv=3,hf=6,htmk=8,ngp-,frg-,dfb-,cs-,tkst-,qn-,txlq-,zg=7,mvl-,fzq-,flsjk=2,st-,sk-,cxv=3,mcd=4,jlc=7,kxt=7,vfrmk=5,dhx-,hql=5,cjkg=2,sqz-,gck=9,bzlj=6,ls=7,qpv=9,nqnc=8,csnng-,dn-,zxssjv=1,ccsj=7,khq-,cfnp-,hf-,fm-,dl-,ddd-,hvkq-,lrfkx=2,zfkx-,vh-,tznt-,gdq-,xmg=8,zgkm=6,zqglp-,fzzvq-,ftnk=4,pr-,dtx-,rvcrz-,cs-,kj=4,cvrx=4,jkb=9,fxjjmz-,gzgkz=2,zcpzf=2,fzj=2,rqlj-,zbt-,xgd-,jxm=9,mh=4,kcr=4,sb=5,jskxb-,fzzvq-,pmjr=9,hzf-,hdq-,lp-,sp-,dhvm-,fpvl=4,qgm-,xghv-,qjrxp-,zp=1,qj=5,mt-,bcx=8,gtv-,tdn=9,lrxq-,nrrt=8,fcx=9,vsz-,hhnvf-,sc-,tdpc=3,bv=8,vdbccp-,fdk=6,ks=3,dxf=6,zc-,cbf=9,pssq=3,hxm-,ql=8,cq=6,xhb-,rjq-,qgj-,fzzvq-,fdx=5,xq=3,hfgcl-,tmjbj=7,qrd=9,bjh-,frp=7,gdq-,cjkg=9,xzt-,lxpr=6,lkztb-,ls-,drzx=1,tdpc=1,nknx-,xnm-,nd-,mt=3,sc=3,mjn=1,mr-,nvfc-,ql-,bt-,ptcccz-,jlc=8,pmjr-,fz-,dfb-,nj=3,fc=6,gp-,ppj-,vj=1,fcx-,tgdc=2,tdpc-,cj-,jbp=9,jxn=7,dfd=2,cbf-,fdx-,khq-,tdnd=4,ngp-,khv=9,gprv=9,fzq=1,cn-,xq-,pfzm=4,fhlf-,zczr-,nvpk-,jbp=4,lfz-,cgj-,ktt-,vc=9,pnxcd=4,vs=1,zjx=4,vfrmk=8,xhb=3,mvl=1,mnh=9,kk=7,dg=7,rzm=8,pmjr-,hs-,st=2,zp-,pbvl-,xq=8,qk-,qj-,rqlj-,xz=6,bcs=1,xzt-,ckhp=4,qdl=2,xz=1,cjkg-,bcx=4,bf=8,ks-,fzq-,sn=8,stflrl-,ztfkv=6,tc-,slx-,sxhlxg=5,nbhc-,pz=8,csnng=8,zcpzf=3,vdbccp-,cmr=6,lrvlxq=4,jnrj=7,pjsrpz=3,zvh-,scd=7,kfn=4,qgj-,jkb-,fxjjmz-,ds-,bz=4,hgpz-,fdd=3,fdh=3,tgdc=3,zsv-,qrd=5,nvfc=9,st=5,mqxgv-,tkst-,vfrmk-,fcx=7,csc=4,klsg-,qk=5,zczr-,cjkg=4,mtk=8,hfgcl=1,tp=8,xpzb=7,vnlrf-,bf-,chnp-,zzsl-,hkk=2,pz=6,vs-,qc=8,sgrkl-,crc=2,jk=8,zjx-,cfnp=7,pnxcd=2,nmptp=1,dhvm-,fd=7,kzl-,dzlzq-,ks=6,fxjjmz-,hgdm-,fm-,tzjq-,bzlj-,fd=5,qf-,rx-,nbbp-,dl-,ln=1,gc=2,crc-,qrd=4,vzb-,dn=5,fff=6,jrk-,pgn-,dg=1,zfrzvf=7,ls=4,bvf-,sxhlxg=8,jxm=4,qgz-,zxssjv-,bz-,rz=5,cgj-,fc=2,kh-,gn=4,zfrzvf-,nmptp=3,nmxl=9,tc=1,tdpc=7,fz-,hql-,pg-,kdp=4,fdh=7,jd=4,mjx=1,cvrx=3,nrrt-,zczr-,cvn=7,fzq=8,mxzmk=2,rtpg-,ps=1,dr-,jmx-,tdn-,qn-,jkb=6,gs-,ft=5,rkd-,jd-,fhmcg=4,qf=9,mjn=3,ft-,zmzzs-,cpbppv=1,khtv=4,tbqs=1,qdl=7,zcpzf=1,qdl-,stflrl-,gprt=1,vfg-,nfnm-,ppj=4,fdx=8,fzq-,lfz-,fxjjmz-,dzlzq=7,mjx=9,zvz-,zt=5,lj-,qb-,rzm-,vxx-,rqlj=4,xgd-,gprt=2,gcz-,zcj-,ztfkv=4,nvfc-,kv=1,sxhlxg-,rz-,zp=6,ggx=1,vnlrf=8,cxv-,qjq-,vfrmk-,ntx-,qn-,vfg-,lm-,dvdkf=6,hs=5,hdq-,plrh=8,ndh-,vd-,slbc=9,jd-,hlf=9,mtqx=4,fz-,xkm=5,kk-,xzt-,hvn-,nmxl=9,rqlj-,qb=1,gcz-,jbp-,vr-,jdjg=9,tx=4,smmtp=6,plrh=7,pbvl-,xnm-,zqglp=1,jxv=3,xztdb=7,xdckv=1,fzzvq-,pnxcd-,ch-,frg-,hgpz-,gf=7,jxs=3,gk-,sk-,st-,sxhlxg=1,xnb-,nskc-,qjrxp-,hk-,xnm=4,jgl-,qc-,zp-,pjsrpz=6,fx=6,ddd-,ch=5,fdx-,ddd-,qgz=1,tpn=4,fpvl-,dhc-,qcbvm-,lj=9,hzf-,hdp=3,nbhc=6,lrs-,tdnd-,zvz=6,smmtp-,jfx=7,stflrl-,bvf=1,cxn=1,zcpzf=1,ch=1,cf-,mtk-,ql=1,bnn-,sc=4,cjkg=5,zxg=3,tkkr=3,tn-,xzt=2,zxssjv=3,xh=9,gm=3,tdnd-,ztb-,pg-,kzxh-,jxs=7,qkb-,mjx-,vd-,xf-,gs=2,cj=2,vnlrf=3,dsrt=7,lmh=1,gd=8,bcx=4,fhlf=6,jxn=1,tq-,csnng-,xdckv-,rvcrz=7,vbjl-,nv-,bvf-,zzb-,qrqh=3,jt-,mvl=4,qgrp=5,xlj-,dr=2,qgj=1,pjj=4,dhj-,qgrp-,ccsj=4,hvkq-,vpm=4,qrqh-,cxqkb-,cvrx-,cpbppv-,lrfkx-,fdx-,cfl=8,fn=9,tkkr=6,cdzffg=5,dhj=5,nskc-,qgz=5,kk=1,xzt=2,kv=4,tqxxm-,tdn=3,lrxq=9,bzlj-,mqxgv=3,qk-,dxf=2,vhx-,dfd-,kj=9,nbhc=3,fdd-,fhmcg-,pz=3,pnx-,cqx-,jk=7,bknn=2,vf=1,hf=3,vhx-,jkb=2,tx=8,hzf-,cj-,ggx-,bdk=3,hf-,dfr-,fdh-,zdrxq=9,zfkx-,ngxt-,hh=6,jskxb=4,qpv-,hp-,pkk=4,fxjm-,cs-,vzb-,npt-,zxg-,cvn=8,dhc=8,qs=8,qpc-,mv=3,smj=2,nrg=6,qc-,zt-,kqr=9,hr-,vxx-,bqh-,nn-,xq-,ngxt=6,zf-,npl-,zt=3,sm-,mt-,fnxh-,vhx-,cfnp=2,xlj-,fxf-,jhtdh-,vl-,cf=6,jt=4,xnh-,xnb-,rn=4,bcs=7,pg=1,llclt=7,zxssjv-,jmx=7,ptxhg=6,hdn-,pz=5,ppj-,frp-,sc=2,dns-,xlj-,jxn=1,fnxh-,bt-,ptcccz=7,gp-,tf-,kcr-,pr-,csnng=5,bxm-,hzf-,vznd=1,zdrxq-,jlc-,nknx=8,ghv-,tkst-,sn=1,nx=6,ql-,xgnqq-,nvpk=3,fn-,xhb=7,hd=1,fqgh-,zp=6,klsg-,nkqcv=1,cj=2,gdp-,dfs=5,frg-,npl-,lt-,slbc-,zfkx=3,cpjjqm-,gp-,rcv-,mnh=2,fzzvq-,rkkm=5,blgg=5,kdp=1,fm-,mrq=3,gv-,hdq-,mnqc-,pbq=7,tmjbj=7,xzt=4,jxv-,gvl=5,bqh-,mxzmk=7,rj-,fh=6,gprv-,rfp=3,rtpg-,gck-,khq=8,nvfc=7,gck=2,fh-,lp-,fdx=3,mnqc=8,hql-,cxn-,mvl-,vc=9,gcn-,dfb=3,slx=9,bqr=4,fl-,fnxh=8,klz=6,sc-,zmzzs-,ht=1,jdjg=7,tznt=6,jhtdh-,ghv=2,fhlf=9,qk-,cpjjqm=7,stflrl=4,qs=5,xh=7,zxssjv=6,rm-,sb-,hxm=2,cmr=7,mnh-,sv-,bkkkm-,vl-,khtv=9,fxjm-,kzl=3,mnh-,gr=3,fff=8,dm-,mh-,tdpc=4,ftnk=7,tgdc-,ssp-,bcs-,dr-,fkb-,fzq-,vv=8,jxn=9,hxmpn=4,jxv=5,dpr=6,djqcm-,rdp-,mcd-,jppx-,mqxgv-,zczr-,kmn-,gjq-,xgnqq-,ntx-,slbc=4,zcj=3,nlv-,rkv=2,fdk-,gjsgh-,gplmkr=9,dhx=8,jdjg=7,zl-,fqj-,bjhvv=1,lbmf=7,fdd=2,rtpg-,tznt-,gcz=6,slbc=5,bz=5,gb-,nkqcv=7,kn-,vfg=8,fcx=3,fdd=6,qdl=8,hdp=1,zgkm=6,lrfkx=3,lhz=3,hdn-,jppx-,kk-,lcpg-,dxf-,lj-,npl=6,ddtm=8,hql-,nskc=9,vpm=1,lj-,tmjbj-,pk-,gprv-,jnrj-,kqr-,cnz=3,fp-,gk-,msvd-,qgm-,bg-,jmx-,vzb-,fz-,hgpz-,hgpz=7,rqlj=5,fc=8,qmg-,fzn=5,hs-,ztfkv=9,xzt-,gcn=4,crm-,dxf=6,rdp-,sxhlxg-,qcbvm=5,hc-,vpv=5,ml-,pjj-,djqcm-,ptxhg-,kh-,mtk=5,bjhvv=2,gcn=2,nknx=1,khv-,nt-,jlc=6,jlc=6,sb-,kqr=8,flfq-,dhvm=1,llclt-,vj-,prz=2,jfx-,vsz-,cbf=3,nvpk-,zcpzf=2,dtx-,zfrzvf-,zf=3,pmjr=4,zt-,ptxhg=5,lhz=1,nqnc=3,dh-,dh-,bdk-,hl-,ll-,fxjjmz=8,jskxb=8,zzsl-,hl-,pz-,khv-,khv-,slx=6,qq-,fdk=6,ckjtz=8,ktt=1,pdpzb-,ks=5,bt=7,gn=7,xdckv=9,rz=4,vkx=7,ngxt-,pgn-,sth-,zgkm=3,qrqh-,rcd-,vgh-,tkst=7,nmptp=2,mg-,kf=2,gdp-,cj-,rzzzz=4,qdl-,bjh=9,gtv-,cpjjqm=2,dfb=5,lrfkx=2,txgnc-,csc-,rdp-,fx=8,fhmcg=3,nbhc-,pj=2,kj-,xnpxxl-,dh-,bzlj=4,lhz=9,nkqcv-,jrk-,rkkm-,qjq-,tpxz=8,pfzm=1,jvhvq=4,hxm-,csc-,lhz=2,fdx-,pjj-,xhb-,qxcgvg-,dh-,pk-,hc-,llclt=3,pnxcd-,cmr=7,gcn-,hfgcl=7,xgd=8,zsv-,xq=2,jppx=5,bcs=7,cmr=9,hkk=8,cmr=4,dhj=5,chnp-,kzl-,fzj=8,ktjg=3,dg=7,tkkr-,tbqs=5,bb=3,zvz=3,xxt=1,vnlrf-,zbt-,hgdm-,cf-,fdk=7,lhz=2,crm-,hql=4,ggx-,qgj-,khtv=6,jd=8,nj=8,st=1,ln=5,slbc=3,qft-,xdxjxn-,qq=1,xcd-,dn-,cdzffg-,gr-,rkhb-,lbmf=5,jfx=1,rj=3,ccsj=2,rkv-,csnng=7,vfg=2,jbsp=7,bjhvv=1,hgpz=4,gr-,pbq=8,kn=9,lcpg=2,cn-,dg-,hdp-,xnm=1,gpxt=1,sv-,mxzmk=8,nxt-,flfq-,hbpk-,gcz-,mvl=1,djqcm-,tqxxm-,xxmrh=5,rkkm=6,nj=2,nv=7,crm-,dfd=4,fxjjmz=6,jxm=3,vznd-,vhx-,fdh=3,cqx-,cgj-,jskxb=4,kcr-,vznd-,jlc=4,fxjm-,pdpzb-,htmk-,fff-,gcz=5,smmtp-,nrrt-,ptcccz-,fzq=4,dh=5,ll=7,hh-,nv=3,bvf=5,zl-,tdpc-,rjq-,drzx=5,ll=9,nknx=4,jk-,vbjl=9,bgsflk-,dn=1,ghcqvp-,ppj-,zzsl-,fqgh=2,ngxt=8,rjq-,gprv=5,cvn=2,cqx=9,dhj-,gplmkr=8,fx=4,ghcqvp-,rn=5,ch=8,kx=2,zp-,tn=7,cpjjqm=9,cdzffg=7,cdzffg-,chnp-,hd-,zp=3,dblkrq=3,zdrxq-,tmjbj=1,dhj=8,ml-,hgdm=4,vfg=1,crm=4,ngxt-,pnxcd-,xf=6,lcpg-,rkv=3,kf=8,vhc=9,gdp-,qjq-,pg-,tgdc=6,ztfkv-,jd=1,qgz=1,dhj-,qgj=1,lp-,lhz=4,dfb-,jbsp=1,hgdm=8,dpr-,khv=8,fbv-,bnt-,gvl=6,gbrv=4,bcs=8,qkb-,jjj-,dzlzq=5,crc=3,fxjm-,sn=8,dhx=6,cjkg=7,nv=4,fkb=8,bvf=2,zqglp=3,nbbp-,tpxz=3,smj-,ngxt=9,fx-,fzzvq=5,cv=1,vv-,nt=8,vf-,hbpk=4,ptxhg=7,dm-,lxpr=2,gnsk=8,lp=7,bcs=2,ghv=8,xpzb-,rdp-,mvl=1,hgdm=9,fnxh-,lrs-,ngxt-,zs=7,vfrmk-,rkkm-,hl-,qn-,zp-,nsgv-,dmn-,zcpzf=2,gc=1,fl=2,htmk-,lpfp=7,tqxxm-,rcd-,nkqcv-,gjp-,tdpc-,xcd-,cpbppv-,sqz-,tgdc=3,xqg=3,nqnc-,ntx-,dfb=9,dl=2,tznt=4,frp=6,vf-,zzsl=3,qcbvm=9,flsjk-,xh=2,nn=3,nsfgvq=5,lp-,xh=7,ckjtz-,bdk-,lhz-,flfq-,cpbppv-,bzlj=6,vkx-,bvf-,cq=7,jt=6,gbg-,kj=5,kx-,kt-,csc=9,zktb-,dhx=5,qcbvm=9,ls-,cvn=2,pr=5,nkqcv=3,lj=6,dvdkf-,qcbvm=6,hhnvf-,khtv-,jlc-,fdh-,gcn-,vpm-,tf-,zzb-,tq=8,gzgkz=3,kdp-,hd=1,vhx=4,db-,xcd=7,xhb-,sm-,zs-,kfn-,gtv-,hj-,stflrl-,sqg=7,fz-,pbvl=4,xmg=4,slbc=7,fzq=8,nrg=4,cjkg-,kcr-,dc=6,kdp-,crm-,bnt-,gj=2,bjh=2,gvl-,xq=2,bn-,nqnc=3,cpbppv=1,ph-,sqgx-,jbp=3,gvl-,pgn-,txgnc=9,tgdc=9,gvl=7,llclt=1,hdn-,cq-,ql=2,bqh-,ds=1,rx-,fzj=5,nj=5,bqh-,gjsgh=4,nrrt=8,kzl-,ptxhg-,qft=4,fnxh=7,bcx=3,ll-,qmg=5,fl-,blgg=3,gn=9,rkhb=9,tkkr-,pssq=6,vpv=3,nlv-,lrfkx-,tgdc-,gcn-,dg-,ptcccz=8,zvz-,cpbppv=8,nxt=5,rkd-,xxmrh-,zf=6,gpg=6,qmg=9,jxs-,kqj=2,rn=8,fl=1,cn=7,htxzkm=5,fqp-,bv-,gdp=6,gbg=5,lmh=3,hk-,ngp=2,qj=4,xlj=7,vpm-,qf-,rqlj=8,tn-,dhx=1,plrh-,ghcqvp-,mjx=6,cxqkb=1,prz-,csnng-,nmxl-,jx-,cjkg-,slx-,rvcrz-,prz=5,dzlzq=8,jkb=6,dpr=6,htxzkm=7,qs-,zfkx-,zg-,sxhlxg-,klz=2,sc=7,dfd=3,hc-,xnb=6,zqglp-,nvpk-,hl=8,dhx=8,kcr=2,lt=2,dm=9,hfgcl=3,mbd=2,gdnfv-,drzx=1,rvcrz-,hj-,tpxz-,cxv-,sb=4,qn=9,xmg=8,qrd-,tzjq-,mjx=3,nfnm-,fd-,mrq=3,tpn=9,pssq=8,xnh-,mt=8,sp=7,tncqjp=3,hdn=6,fdx-,ch-,zjx=1,zt=1,dfd-,xztdb=8,mh=1,gvl-,rzzzz-,vv-,qpv=3,zzsl-,lmh-,drzx=3,nd-,gp-,tp=1,tgt-,mvl-,bc-,jxm=6,gjq-,pzq=2,fpvl=7,zfkx=8,xqg-,vh=2,lpfp=4,hj=9,tznt=3,ghcqvp-,xnpxxl-,csc=8,dxf=9,dmn-,hlf=6,hp=3,lkztb=2,nt-,ghcqvp-,ghcqvp-,bkkkm-,ntx-,kqj=1,zzb=8,ht-,bkkkm-,ft=3,gn=9,xz-,xdxjxn-,lmh-,sgrkl-,vd-,fzzvq=5,hgpz-,rz-,pjsrpz=7,gjsgh=8,ch=1,xpzb=7,ps-,nvfc=8,txlq=6,ngp-,kt-,pfzm-,fxjjmz=5,zzsl-,vh-,nz=5,bnn=9,kbdvdt=8,nrrt-,jskxb-,pjsrpz-,rx-,gbrv-,dhx-,fd-,cpbppv-,dfs=6,xq-,lmh=9,nskc-,fhmcg=2,qjrxp=4,cbf=6,hh-,gplmkr-,qkb-,gtv-,lj=4,xhb=6,fxjm=8,hdp-,dtx=7,bc-,kbdvdt-,pbvl-,vdbccp-,kmn-,gvl=6,zcpzf-,tp=6,vgh=6,bknn-,nv-,vznd-,tkkr-,vkx-,flfk=7,hc-,mjx=2,hql-,hd-,tq=4,lvdp=6,bg=8,fdx=7,hvn=2,ckhp-,cdzffg-,ztfkv-,mnh-,fff-,hfgcl-,bbl-,tf=4,cvrx-,hdp=6,lm-,tn=1,rkhb-,mnh=7,txgnc-,mrq=5,frg-,xz=7,qmg=4,sn=1,ql-,dh=6,mt-,xxt=5,ph=3,gn=9,sqz-,txlq-,nt=9,bc-,jfx=1,ztb=8,nbl=2,ptxhg=6,dhvm=2,kzxh=1,fl-,msvd-,dhx=9,gb-,qkb=3,rcd=1,hs=2,xnb=2,jk-,bc-,nn=5,lp=4,dhc=1,scd-,lmh=2,bfg-,zc-,gcz-,zgkm-,pssq=4,lrfkx-,gnsk=2,gpxt-,qjq-,crc=9,bzf-,qkxb=4,hdn-,dzlzq=9,zqglp-,gprv=8,sth-,ps-,gdq-,mh-,ht=4,gn=1,bcx=4,zgkm-,hr=4,lkztb-,mtk-,dsrt-,xz=4,ccsj=6,zvz=9,vbjl=1,zjx=1,sp-,tdn=3,qdl=1,vhx=6,bqh=6,dns-,rdp-,tf=4,bxm-,mbd=4,xsnz-,sm-,nmptp-,vl-,cxqkb-,dl-,xh=3,xmg-,qm=9,gprt=6,rkkm=9,kqj-,gs=3,bxm=2,gk-,vfg-,zt-,dg-,hj=1,mcd=8,ch-,fnxh-,sxhlxg=4,rcv=7,npl-,fqj-,tq-,gnsk=5,nbl-,npl-,xf=4,gvl=3,nvfc=7,vgh=9,fxjm-,jnrj=8,fzj=2,zbt-,xnb-,xgnqq-,mr=9,tn=5,kt=9,nqnc=9,vzb-,qgz-,pjj=5,bbl-,lls=3,fdx=6,hd=7,vh-,kn-,fdk=7,zfrzvf=5,pjj=4,jxm=1,rvcrz=9,xghv-,dg=8,nj-,vhc-,pkk=6,ls=5,vr=6,mv-,sxhlxg=9,kqj-,qkb-,mxzmk-,jkb-,qm=4,xqg-,fhlf-,ftnk=6,vdbccp-,htmk=2,cv=8,bfg-,jxv=5,tkst-,bzlj=1,mh-,fz=3,xs-,dn-,dhc-,sv-,nqnc-,tkst=4,kqj-,cnz-,kmn-,qrd=1,fzzvq=5,smj-,tp-,khq-,lp-,fhmcg=5,gjsgh-,gprt=5,nz-,jdvq=3,cbf-,sm-,bcx-,vv-,kqj-,gvl-,fx-,gs-,cvq=2,gs-,hd-,cbf-,lrvlxq-,ch-,nqnc=4,npl-,kn-,vznd-,dzlzq-,rfp=6,qkxb=3,ztb=6,nmxl=2,cbf=1,kdp-,hdp-,vl=9,dxf=3,zvz=1,ptcccz-,qcbvm-,dg-,gj-,vnlrf=9,bs=7,gtv=1,vv=6,zsv-,kf=3,ngp-,tgt-,xdxjxn-,bzf-,ch=9,ggx-,cvrx-,dg=3,ds-,vpm-,pfzm-,mg-,gcz-,kxt-,kf-,fff-,cfl-,fzj-,qjrxp-,gn-,bnn=4,rj=1,htxzkm=8,mv=8,zzsl-,cv=8,bf=3,kfn=2,bz=4,jxn=1,dzq-,ls=9,qgj=8,zgkm=3,fxf=4,xdckv=1,cvn-,hgpz=7,xgd=6,vpm-,vv=4,pfzm-,cmr-,cf-,gbg=9,rzm=2,llclt=4,cn-,tkkr=2,nbbp-,fnxh-,sxhlxg=4,rzm-,bcx-,vbjl-,mcd=4,crc=8,dblkrq=9,ds=4,tn=3,ckjtz=8,zfrzvf-,rtpg-,bkn=8,zbt-,ct=5,ptcccz-,bnn-,mjn-,qft=7,rm-,fm=6,ssp=9,mqxgv=3,nknx=3,xnm-,tkkr-,ddd-,lp-,bc-,dfr-,gzgkz-,pgn=4,slbc=4,qxcgvg=2,gplmkr-,qm-,bz-,qn-,cpbppv=8,csc=5,kmn=8,xf=3,khv-,bjh=1,rzzzz-,xdckv-,rvcrz=8,st-,pnxcd=8,lrfkx=2,gs-,nknx-,qk-,gc-,ddd-,cpjjqm=5,mbd-,vdbccp=6,nlv=6,ftnk=1,csc=6,lt-,gzgkz-,qjq-,ml-,rcv=2,hd-,kcr=2,nmxl-,zt-,rvcrz=2,frp-,njd-,ddd=7,bjhvv=4,kzxh=1,hh=7,qmg-,sqz=1,rkd=7,sk-,ppj=5,cv=2,vj-,tx=3,nbbp-,rcv=4,gbrv-,ktt=5,sn-,kqr=6,jxn-,db-,kx=8,nx=7,xlj=3,rvcrz-,pdpzb-,pbq-,nmptp=8,qcbvm-,tkst-,dn=7,bnt=9,xdckv=2,bnn=4,qm-,ds=2,cdzffg-,qj=1,fn-,fn-,jfx-,qb=7,cdzffg-,pssq=7,rx=1,klsg-,cgj-,vhc=8,ll-,zzb-,pg=1,vd=4,kt-,dn-,gprv-,dr-,ps-,bjhvv-,sxhlxg-,hzf-,kbdvdt-
