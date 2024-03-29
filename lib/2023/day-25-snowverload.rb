=begin

--- Day 25: Snowverload ---

Fortunately, someone left a wiring diagram (your puzzle input) that shows how the components are connected. For
example:

jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr

Each line shows the name of a component, a colon, and then a list of other components to which that component is
connected. Connections aren't directional; abc: xyz and xyz: abc both represent the same configuration. Each
connection between two components is represented only once, so some components might only ever appear on the left
or right side of a colon.

In this example, if you disconnect the wire between hfx/pzl, the wire between bvb/cmg, and the wire between
nvd/jqt, you will divide the components into two separate, disconnected groups:

9 components: cmg, frs, lhk, lsr, nvd, pzl, qnr, rsh, and rzs.
6 components: bvb, hfx, jqt, ntq, rhn, and xhk.

Multiplying the sizes of these groups together produces 54.

Find the three wires you need to disconnect in order to divide the components into two separate groups. What do you
get if you multiply the sizes of these two groups together?

=end

require_relative '../util'

class Snowverload
  def self.parse(text)
    new(Graph.parse(text.lines(chomp: true)))
  end

  def initialize(graph)
    @graph = graph
  end

  attr :graph

  class Edge
    def initialize(source, target)
      @source, @target = source, target
    end
    attr :source, :target
    def nodes = [source, target]
    def inspect = "#{source} - #{target}"
    def to_s = inspect
  end

  class Graph
    def self.parse(lines)
      edges = lines.flat_map do |line|
        source, targets_text = line.split(': ')
        targets_text.split(' ').map { Edge.new(source, _1) }
      end
      new(edges)
    end

    def initialize(edges)
      @edges = edges.to_set.dup
      @nodes = Set[]
      @incident_edges = Hash.new { |h,k| h[k] = Set[] }
      edges.each { add_edge!(_1) }
    end

    attr :nodes, :edges, :incident_edges

    def size = nodes.size

    def dup = self.class.new(edges)

    def add_node!(node)
      nodes << node
    end

    def delete_node!(node)
      nodes.delete(node)
      incident_edges[node].each { delete_edge!(_1) }
      incident_edges.delete(node)
    end

    def add_edge!(edge)
      edges << edge
      add_node!(edge.source)
      add_node!(edge.target)
      incident_edges[edge.source] << edge
      incident_edges[edge.target] << edge
    end

    def delete_edge!(edge)
      edges.delete(edge)
      edge.nodes.each { incident_edges[_1].delete(edge) }
    end

    # https://en.wikipedia.org/wiki/Karger%27s_algorithm
    def contract_edge!(edge_to_contract)
      nodes_to_delete = edge_to_contract.nodes
      # TODO: concatenating the names is O(n), and maybe hashing the name string is O(n) too?
      # consider making a Node class with a unique id.
      new_node = nodes_to_delete.join(',')
      edges_to_update = nodes_to_delete.flat_map { incident_edges[_1].to_a }.to_set
      edges_to_update.each do |edge_to_update|
        nodes = edge_to_update.nodes - nodes_to_delete
        add_edge!(Edge.new(nodes.first, new_node)) unless nodes.empty?
      end
      nodes_to_delete.each { delete_node!(_1) }
    end

    def contract!(t)
      contract_edge!(edges.to_a.sample) while size > t
      self
    end

    def contract(t = 2) = dup.contract!(t)

    def fastmincut
      if size <= 6
        contract(2)
      else
        t = (1 + size / Math.sqrt(2)).floor
        graph1 = contract(t).fastmincut
        graph2 = contract(t).fastmincut
        [graph1, graph2].min_by(&:size)
      end
    end

    # A partition of nodes into two sets. (Only useful when size == 2.)
    def cut
      nodes.map { _1.split(',').to_set }
    end

    # The edges that cross between s and t.
    def cutset(s, t)
      s.flat_map { |node| incident_edges[node].filter { t.intersect?(_1.nodes) } }
    end
  end

  def product_disconnected_group_sizes(show_progress: false)
    smallest_cutset = Float::INFINITY
    best_answer = 0
    (graph.nodes.length ** 2).times do |i|
      puts "random try ##{i}, current best answer = #{best_answer}" if show_progress
      # TODO: This seems too slow to ever finish:
      # g = graph.fastmincut
      g = graph.contract
      s, t = g.cut
      cutset = graph.cutset(s, t)
      if cutset.length < smallest_cutset
        smallest_cutset = cutset.length
        best_answer = s.length * t.length
        return best_answer if smallest_cutset == 3
        puts "new best: cutset has #{smallest_cutset} edges" if show_progress
      end
    end
    best_answer
  end
end

if defined? DATA
  input = DATA.read
  obj = Snowverload.parse(input)
  puts obj.product_disconnected_group_sizes(show_progress: true)
end

__END__
bdq: hfr lnm
rfq: jph lqj zrv
vnm: zkl bvx vcx vqt lzp
ptj: pqq
vvq: tkd xxt
kqb: xmj
gdh: lzf qmj vgn frn
gsj: ttz pns
jfk: pfp xbf dqp
scc: xzd kzb czs
fft: ggl jzl fvv
rzx: jqt
mqn: jtb xbl
svf: xpq zvv fpj fkv
mgd: kxn
vzt: dmx mpp fxf bss flr
rnh: sjv hlm vsf gnj mbz
rdn: crr dzr ljz
pjh: lhj jlj
cgx: vqb gdm vzs jdg
dtb: lkk hqf zqn
pbb: dtp cdp lfp
pvv: jzd tjz
qnk: hzp
kxr: kqz gpx
vcr: hld cns mhx vtd
hrk: rjf pmv fcb
jpt: nfg
znb: gsc fcv
tnc: snk rck smc lbj xlg
rmr: jhq tph pbk dbp kmz
drr: fgm sqq
dbp: mzp
vfl: dtp mpz lnv vpl dnk
cph: dmv
jhq: rsl xhm dnh
vhr: djz
tqx: pjh qtz mzp
dzx: fzl
bkn: llf vpl tkd
qcd: zpt
ddx: rjq rct
msb: pxx fvv
psn: spd vcn bjn zzh dlg
sdm: gdh xhs mqg hbq pjn lhv
ppx: bqg hkk glj qzh
ksm: hjc
csd: rsl tnn tlb
kqz: ssq
hfd: xhc vjj xpb trh
bsk: vqf klq rlk rzn rnn
vnq: mzc nrz
mlj: qkp
fzr: fzl qgh grd dbn
xzz: vtr
qmp: slt pvm zsz
xgm: ppz
vhz: ndf
tjz: vph
cbv: vng vrl ncg kdt
rbd: xhd fqn xkz tfk
jqs: kxg
dzj: zgj
sqq: kxn xgd qqr
pvz: vph ssx
qbs: xqt xmg jdp
fxf: hxh lzq
zgr: tpd qvc glj ckn
dkl: jhz bss qsz
trr: sjh qgg djt xgm
knp: tlm lxh
dgr: mgp
xgp: dbl szm jvc
zqz: dxr pts chl
qhz: hgt kgv xhd rjm
vkl: qgm rzm slb rxh
jrn: vzq
grl: grb qrx hbq fkt
bmf: znz mqv
zhq: xrh clp
mgp: fsz
pdf: kxl plc
kkf: tmk hrp hqf xbk dkq
fnt: gvf
bmt: vgp hqx vqq
crh: sbm tkd
qvp: lvt fdv mkb
zgq: hxh qst dss
bzv: dcg jdp qps kxl
thk: hpk
pfp: xdc
qtf: znk nsv gfh
dmb: pdc dqs pqb czn
qmb: tmq
vgc: zmg znh dbn zrk
fpf: gkh zfz qcx
xll: mlj jzr djr
bxk: vfs djt
rmn: qlv
frr: jvm xzp crl kxf
lfl: mvq xsc nln
xts: thh
fbj: ctq
hkf: sqg
flk: xzs jhf
jll: gnz dfd
fxd: nrz
dkj: lpr
nsz: sqp zjf jtb tnb
cvm: jtt bsp
njk: jbd lxh mjm
kmz: gfl
qzq: qzj vhr
trq: jvc
qmt: jfj vqr bjl
slv: xzd
bph: cfj tmq
kpg: vsx jdp jpt
gkl: cnn lfv
msn: znd csv hmg
vbp: jhn bcq hmd
slq: xfl sqg sgb
ktt: jjg
zhk: ggn lvs
ncr: knd nkl hfr tzg
glt: gsj jlp bcn ltd hfd rjq snt
qkf: qlv tkg hlx qqn
klt: crr tbd ssq
dfm: smb bjb
jdg: ndf txm vfx
kff: mpp hbz sjh kkg
brm: ssl kxg crr
ssl: zpt
cml: ggf pts lvm
sdf: gfp xlg jdf
szq: vfs vsx
tkz: kpg cfj rtz jmj
jph: jcj
qmv: szq zvv
djv: rgg zlc
lfp: srq rfs
ttm: vgn lhh
mhg: bps jdf ggl bcn
fhm: hlh nfv jzr hrp jxh
ggr: lgz qlc nvd tkg dnh
rvq: nlb crq
ptc: fms kqr
pph: rgc vls zmg zqz
kjl: bcq
kgm: pzf
gsc: hqc
sqt: vqq qck klt znk slr fdv
kqr: jmz
hfx: mqv jrn
jtb: tcs
gqr: ljq zvs xzq kmv
ttl: qbj glm dzc djv
vgg: qtf pph
hdj: kpf gkt pgf lzq
fcb: pxx lcs
qgn: tcs
vdg: zrt
sxh: fbc xdm gdd
drj: txm fnm gdm
xqf: vpl brj tmk drz
zdl: mmj
glr: ggf
xjf: tnt cnz ltd
nbt: ffh jcm
hpv: cps
bfh: fls lqj
fbz: xzs
ccn: gql dkq jhf
dhj: dnv cbp
lpr: hlx
lqt: fjr phn thk
vpl: kqr
pdd: qlc zpn kcq zkd
ldh: rdq fhc
xzp: pdc pqq
phn: mpz jhf
zvt: mtk txm tjt
lfs: kkg
vxd: jkd mqn lzf
kmv: hlm cnn jnz xxt
gfl: xbl hmg jgl
tfx: qzr lgm cph vgr
ccz: mcg bbg
hvh: qps
hrp: bsl jcj
gxd: cvf skx
lsl: brr
qdh: vkn cfg
zxx: bbd gvv hpv lzp xsc
fpv: fdd sbh nvr
nfg: tcf
zkf: bct
tzg: bjb dnh dkj
kbr: tsc nkx zst znd xhm
ppr: nrp hqb smf bbg
kjs: rjm vfx jlm
jtn: xgc
fzs: npc hcp szc
slr: bfg xsj dlg gdd
vkx: qmd zdh xgm xgv qnd
rvf: hbl cps jhs dtg
kfz: svf rzx jrn tnb
dfd: cfc
vgk: pqp
zdm: jgl tcr
hvl: zxt
ztp: zgj ltp hgm
xjq: plc pvz hbb sbg gkt
vkc: qmb mgp fpj
zrv: sbm
cxl: mpm tcs
xhp: vgr qlv lxp hld
cxf: jhn flr jqj
ctq: qqr fhh
qsj: stm mzc kks qgn
pxv: zfz mrv
sqd: vsx hlx hnc pdh
zjf: mtc
sxj: mmg mjj ksd hfx kdt
msm: cps gpq lmd mjp
ghz: ksr dkc zdf bqg fxf
vzs: vqb kxf
vxp: hjc ksn
lgg: llp crl
vhv: vqq gsc qrd
jqq: kjp jcm nxk rrn
gxn: cdp brr
vdl: ktl bmd djb
jkx: hvb xjb bqm fbp dmf
qgm: hnp
rgj: ktl dhj ncv
kpn: jrb cfc
dgm: vvh mxp drt
bgj: glr crh zvt vqg
rrl: jbm zzp rss ngf
hmf: pnv bjl trf qgc
nvc: bmd
cvn: gmx mtk
hlh: dtp
jfv: dqv jhm ckn gqk sks llz
vqx: rjp pzf pns ccn
zvz: lcg cng csj czm
ztn: jbd xsb vxp
nlb: rhr pjg
fqm: ggn kgg lnr
dcf: ksn
mtg: rjj mbk tff gkl
mjs: ksx nmn dhc
tff: jjr
kkc: rbn kfj
vqt: rxz vdg gvf
hpk: qkp
lvt: nqp
csz: drt fxn rsl
rqc: bxl xvx jrt xjf
tfb: jnz czn gfg
vrz: mdx fdd ksz hmg
xfb: pqp
prn: knp hqc vqp
vqg: qcd ttg ddg jdl
rrt: lhh qhh ztj kjl qsz
dxm: flk szb cnn pzl
bjg: hrk ggn bps slv
xkx: gzx zzg
rhz: fzr gks mfn dtd jlm
lmq: cfc cvk bbb
jss: dnk gks kfj
xpq: plf vbp
bgp: bmd cbp
jhn: czg
mmr: hjg crn
jzp: lfs qdh vph
tgg: jmz jdf
rfs: gsc
kxf: xth llp
fcl: jmz jhf jdm
hjr: czn gvm hln sxq qnf svp
mpp: qfh bss
klp: dzp fvd jpt zrt
dvj: vgk ksx gdt
lrj: ptc tcj nmk thc
cmh: qhf mpg tcr
xjs: cjd sdt chh mpp
fvl: gct nmk
ngf: gfh
mcv: zcx qdh smb
jvf: cvf hbb
czh: bnn kjs thq trh vqq
czq: fls qkp zrv hmh hkm
xjb: tcf
sln: znk kgg
hxb: xsx mjr tlb
xdc: pjh
xzq: qmp dtd
tnt: zmg pzp cnz
tlf: vpp jlj bcq jsh
jhp: pmp nvt hzp
mmp: fft pxv jlb
sjv: xts fhf
flx: lfx dsd kzn rdq
kfd: mjj jjn rmd xkx fdb
npn: vdl bjl fms
csj: mnl
ttn: zgj
gpl: gqk mxt tcs
ggc: rxm qkp xnc ptt
qzh: mzc vcr vdd rbj
zpn: rsl dxb rhl
pth: vqm lmd kds jkd
qgr: dhl qjb
kfm: bfx kjl hgh mqn
zmg: xzz
hnl: dbn sxh
rxz: zst dcg
pnv: njk nmn qzq rdn
jtg: hst lxh
tmq: vvh
mqd: dlr rrt vgn pgt xfl
txc: xzs
pzn: pts
vgp: xhd
bsf: rsd smn kkc gvm
kbm: hnc hpg rzc
xfq: rtz
vqz: lpr mvf rmn
dmx: czg lzp
gdt: djz
ggs: jvf jzp nqz
smt: cmp lgz qfh
bft: jlb bfg
jzd: qss
nms: pvm xmk fms
rkc: qxb tvt bnb rpc
fsl: xxt xvk
jkd: hvl
hgb: xbl kmz pmh
qvt: hbb dnh pqh
ddj: hmh qgh bqd
xsx: gfv ztj hcp
fhh: vfs
xbj: rdj dtb lqk bct
fsr: xcj nvc jxf lxh
kks: hjg sgb xmg fvd
zkd: fkv
prv: jlv fcb qnf
pbk: hhq bvx vsz
tcs: mhx ckn
jdl: vjb xfs zkf dzj
zcs: flr vsv vkq szc
rql: rgc xfd rjf slv
qct: xfl
tzf: hld bfx dlr
dmh: pnc lfx
ckr: cng lsl gxn brj
hbl: jgl
pgg: rjj vls glm zbj
lqv: czg tvm kqb zkl mbs
rbj: khz xdx jqp
sjg: xts vqp nsm
tjt: jxh clp vqr
hvb: bvx lpr vdg
bnh: jzd zdl bnb
dmf: smb zvj kxn
trf: bbh xth rgj
rkr: lhj jdp mpm gqk
mbz: hqc jdm
rnx: qzr cfs
xxg: dsd qps nlg mcv
vqr: jdm ttz
zzg: pdh gcq
hgt: jqs pdc
zrf: jqj xvl lsp llz
vxb: lcg ssl
pnr: jcn xqg mdj mfn
vsf: hjc xzd dcf fdv
kdx: pqb dzj tmf bfg mrv
vdd: vkn plc
sfb: fhf
hvz: bfh hgq zbk
xln: dpp cnz mgx dqc
ckg: vfj hdf glj hgb
mbs: dll pxp
bmh: pdf jpv fxn jbl
zbq: rsd kgn hjt
nsv: lgg ttn kgm pzn
sks: hhq vtj
xvx: pdc svz ddk
xfd: tmf
vqs: cxf bdk nfg
zsz: fpk xhh vsk
vcq: ncv fjr
pdg: mcf mlk zpt lvs
mjl: pjn zcx szm
tpd: kdg rtz
hnp: hjc
djb: ksm csj
xnc: dbn
rnn: fdd rzn
rjq: hlh drg
bxl: jbd
vpq: czn gbc
crz: pkg cth
vmg: pzf
zcr: rmn zgh hcv mmr
zbk: mdc gxn gnj
mjp: cph fsz
kgn: knp jlb nrs
mkl: mpl fsl rct
trp: srt cfs tbb dgm
vgr: jsp mzp
lsp: rzx mhx xvm jvc
sqp: tgm qqr
jvx: mmr hcv tsq lrc
qck: dcf mss lvs
jrf: xps rpc
npl: ltp lkx pbb jmr
qgg: znz sgb cns
xrh: lcs
msp: dbn xzd bnn
mss: sfb dzx
vls: mpz
gmq: sbq rgg ttn
rjf: gpx
krp: ppz qqn cxl cdv
xhf: fzl zrk rct dnv xfs
rmt: mkm kmz kjl hxh
ggn: ktl
zst: npc hlx
zlc: vfx jbt vqp
tvm: khv fdd
czs: vhr xlt
mfn: jqs psx bcp
hcf: fsm pqr fhh qjb qpj
kbc: fbj xrd tsq flp
zgh: cps ksr
jxk: rzx mrk xvl rpt gbd
khd: zjf vsz rmn
jmj: jfk bpt sbg fvn rnx
cdr: grf ddx lvs kdx
hgh: cfs ckn fvd
hds: rxm kbj hdv vqb jxh
fjr: hrs flz jlb
dvf: czj zkf hjc slr
xxk: vfh
zdb: psx szb mcf
bsm: txq qzq mjd
dhc: vvq mss hkm
xmk: txm
ddg: xlt
qps: bbd
crq: hbz znc bjb rxz hbl
gpx: hqc ksm
lct: xlg bps sxh gmx
brr: psg
fmx: gbd rdq
gkh: dpn ttf
vzf: vsx
dzc: vhr phn
bgn: klc gct
mpg: hff prm
rvd: xfq sjx xjs rjh
bfs: rzm lvl dtd
spx: dgr cph rsl qfk xgj
tcb: dmg pxp
ctl: prm fkt nrz fpv
ptv: dnh mvq dsd qmv dgr
qzj: rqp fls
gmx: mnl qnk hlh
tnq: tmf
mfs: vfx
dxk: bbm jlj vng jqp fhc
vcm: gfg ssl sbq
fpd: mhp dkt nqp zbj hqx
zxf: mhr znh lgg fxz ckz
mzf: gbc ndf slt qnk
vcn: gdm dnk
mdq: qnd zdf dlr
ldl: pgf mpm
hqb: sdr ghs gxd
lrh: trq mkm lzf dsp gfv mkg
tlb: hkf rdx
mlk: kgm
dxr: cnk
bjn: jph bqp
mbk: tzc ptj zbj
hhn: ksz rpk pgt fmx
grd: jfj
xvk: mtk clp bgn zvt gmq tld
knr: pxv scm mkb psx
gql: hlh jlm
qvc: ccz hpg
hcp: qmd
pvm: mrv qtr jjr
ghb: qhh sjp
kvc: dhq pxp vhp dmh
nqz: gfj
tzd: zfz fvg
jlp: ffh
kgk: xsj mdc mlj
tph: vnr szc
rck: mtk zdl zzh
hvn: hjg hpg
hgm: dfp mjm
dqc: bzk
xvd: rsz rck dtd
fvn: zjj lls
rmx: pzf pdc mnl
lvl: mjd jmz lnf
rxh: hnl rjm xmk
tjk: rjj grf psx hpn xfb
nlg: rzh fxd fzs
mjd: pqp
fms: kbv
kcq: cfg tmt
rdz: mpg bkr xxk jpv
xtd: fnv xbk fxz njk
bng: hlx jkd vqs
rdx: csz bxk zrt
tmm: pdh bdq vzf tcf
xsb: gxt jbt
vht: tvc txm mss cvm
mvg: pcs bqg lzp dkl mzb
bns: vkq vsz pvz bjs xrp
rsd: fvg sln bcn
qtr: xfs srq kgg
bbg: ncg
vrh: xdx txv fdb lpv
lbr: jhf ddk gnm gks
lrc: vqz bcq jgh bmf
pjd: tkg gzr gvf qgr sjk
ptt: zgj
glm: xzz tff
xmr: kqz
hqs: zzg qsz jkd pcc dbp
qqs: msb ztp jhf xmr
hvm: jbt dzm lnf tss
lxp: npc
fzq: zcl tmk nsr qbv
hbb: qps
sct: pmh mgd
slt: lnf
dqs: rxm
qrx: ghb rsl jfm
lqk: vgp lkx
rgz: zkl
qnb: qps tlt dcg dxh
jdp: vkn vtj
nnk: vgp
rpc: kgg czj
pns: dcf ksn
sjk: zjj ssx flp
lcs: hjc
jsz: dmg pdf smf
mxb: gck rmd
pvg: jrf hgt bgn srq qrd tqp
kdt: rhl zdh
rbn: vsk
vkj: zzp dqc ksx vmg
dpn: dlg gfg
thc: nmk nfv
hpd: bmd sbv pgg vhr
qnn: sqg tbb svb qhh
fnm: rzt gnj nsm
lhv: fkt kzn fgm
nxt: nvd dfm hvn tfx
rmd: kqb bvx
jlb: qgh tjz
pjg: jhm
klx: ttp xnv lkx djs
tbd: mhp txc
tss: vsg dnv
jbl: vzf rlk qpr
tgk: zvh xrh tsn
pcs: bbm gfj
clj: pqq qzp rxh hvc vxb
fdk: msn pcs tbb vxd cqj
zmn: zvh ltd mvp nns crb qzj
zgc: zbk rzm dnj
sql: mgd qht mvf
spd: jfj ndf
dtj: bnb lxh
hjt: rct
txv: ttc
dgz: vzq tpp crz gbd
brn: mpv crn dhq qmb tvp
pts: tjz nsm ktl
tcr: vtd
qfk: kdg bvx
dll: dxb jsp
dsp: hhq
sqh: lft frm ptc vhg
jfz: cns zqb xsc mjr
tnn: pjg rzn
czm: ffh lqk ksn
qvs: pdq dtj ccc dzx
sbs: lhh pmh jts fsz
fqn: hjt zhq xcj
bbm: cfg
xgj: dtg btd fnt
hrs: tgg pzf
mhr: nkh nzf mcf xfd
ggk: bzk vpl ttn
hlt: kpf qxc dmg
xnv: xrt hnp drg sfb
ttf: txc vjj
vqq: kpn zkf gfh kqz
cqh: jzl czh vnj
nkh: zzp xts txq
vnr: qht jpv
klq: vvh
zrk: dnt qgh tzd
vjb: rbn tnq
kdh: skx mpp bbm jvf
hxk: slt nmk vxp ddj
mzx: mrv rqp sbm
drt: fdd ptd
tsl: sqd ktd lfs dxb
nsr: cxz ttp crj
pkc: frn lgm xgc
kqt: dzm xfd jzr tlg
rrq: tfk rqp qtn lsl
dxb: bkr
rtd: qkk cfg jcq bdk
rhl: xbf cjd
jdn: xgd prt lhj
thr: phc zrv rgg bxl
fxz: sbm
nkx: vnr tcb zqj gbd xmj
nlk: sjv gdd mbz
xth: cfc
qhf: jqt dmg
xdx: vkq
rdj: xhh cfc hzp dlg
mzb: vvh dtg tpd
chj: jnz fvl phn vsg
cnz: rqp
bsl: dtd mmj
vnj: mlk xpb lpq crh
rqv: vtd vgr pjg zvv
sjx: dxh pfp bdq crz
xkz: txc djb khj
pkk: jmj vsv tmq xmj
xgd: fxn mjp
tcx: qxv fxn frn qvc
xhh: gsc jjr
zvj: xmj
rgc: jzr
lfx: lzq kdg
hmg: jjn zpn
snd: nzf dzm
ksx: thq
hqx: ssq
snk: rgc cnk tnq
rgg: hln
ttg: nvc vmg thk
qdc: jqt
xhc: bzk pmp rss
vmd: mxt
ctg: hhl rgz flp btd tbb
gvm: jbd
tdp: nvr pzj
jtt: jlp vjq fls
hgk: tvp hvh qmb qdc
jfh: gvv jvf fdd lmd
pqj: pmv pzf srq mrv
kjj: fsl djv kxg zkc
fjs: vpp
tfk: vsg drg
vfh: mqg bqm
xlg: zgb gdt
tsq: sbg
dkq: tkd ddg
pzs: jmr jjg pqp bft
znh: brr zvh
txq: mgb jdf czj
mmt: slb mss lkx
gnj: bnn
dzq: fxz txq fkn dzc vgg
msq: zxt xmj nfg gzr
jls: snb vfs svb xqt
kpf: gfj
rfj: ptj lsl tqp tlm
dkm: dll hdf crq pjn
sjp: bkr
lkj: jjn jmj jbl vtd
pzl: nxb gpx hpk
zkl: mgd sfn
gbc: bqp nsm xqg
rlk: tnb nkl
bcr: vmd gnc fdb
chh: zjj
nqp: vpl psg
nxb: kxf jlm
xff: xjb dfm cjd gnc
fzp: dqp cps hmd
vvk: sks nsz czg lfb
pkm: zxt qdc jcq
xdm: jrb
snt: mbg tvc mlj
vfx: hkm
jgh: qct plf hpg mgp qlt mcg
kvn: ltp cfc lvt psx
qlc: jlz
cdd: clp pmt npn fpf jzl
smf: qpr znd
gkt: bfx
vgt: qvp bnh fhf rlv
svb: zqj
bpp: pqp dzj ttg pvm
ndq: trh hvc pvv ktt
ptr: xgr tpp gkt xxn
tqp: rzm
hbq: tqx zdf
vzj: fbz gfh ddg dzs
rjm: pzf qkp
hmh: dfd
lnm: jgl kkg
cpz: lqt csp vhz jrb gxt bsp
lbj: thc grf qgc
dpp: lnv
dbl: bqm lpv hqz
flc: fdh ttz msp cqh
ljn: smc jxf vqq vnj
xfs: tnq
lls: pnc qhh
bxb: fdv ztn vht jfj
xhs: drr dsp jvc zgh
dnk: mkb
lfb: htg jsh qhh
hdp: pzr jfj vxp bsl
ldn: srt qmv khd gpk pkg zgq
tpn: jfz xpq qht jsz gzx ljk
hss: snd vmg ngm
fxn: pcc
gsr: xnc bnb nbt hln srq
jvc: skx
hlb: fdh gfp bcp kxr
gfv: vnr tpp
tgf: gvm tjz gql mkb
rss: ffh
qss: cfc
qbj: xhf rnh
smc: jzl
ncb: vcx mrk vqs
jjg: hgt dnv
qxc: xdc
jts: prm
zdh: qpr hld lzf qfh
jvm: hgm cvn
tvp: plc hkf rvq
svp: snd ttn bbh
rjh: fpj ghs hvl
sdr: hpv qqn
tsc: mjp mdx vgn
gqk: ncg
qsz: xfq
pqh: hhl rzh bph
xgc: jgl nrz
rnj: pxp qxc xfl vdv
ssx: bbm qkk
gcq: vmd tmq kxl
vsz: fgm hfr
sxq: jxf tzd fqm
pfl: qct tlt zcx
bqp: qss
zqn: vjj fdv
mgx: lkx
llb: ttn cvn rfs bgp
nns: hgq hpk vzs
mbg: mgb rfq xrt
vqf: mqv cfj hhq
rpt: hkk fzp msn
mmg: xmg slm
bnn: vjj
fhr: rlv xxl prv kvn ssl
qxn: qbs lfl ldl slq
srx: qdc nvr mbs nql
fld: sqh fbz crr svz
drc: xvd kbv mvp bnb
grb: dss tmt xfq llz
fsm: vzq hlt jkd
vqm: zvj khv fbp qnd
mcc: fbj tmm fnt
mgb: lfv
fhp: ljz cnn zdl qcc hst
bbc: mxt qht txv
bbb: mfs hcz
lmx: khz xqt xfl
fvv: llp
dkc: bdk tvm kxn
dhg: ptt pnv zmg hkm
bjs: flr jcq mtc mnq
kfj: lvs xlt fqm
mjj: fxn hdf
pdh: vmd
fcv: jnz gbc kxr
ddk: tqp zhk
qtn: nmn dqc sjg
tpf: tkg dmv prz mgd
cnk: kxg
mpl: txc dzx
hst: xdm
pmp: dnj bmd
jnq: csj ngm qgm zdb
qnf: gfg
xfc: flz
mfm: zkd vpp txv
xqv: pkg hqz ncb vzt
rcx: xdc gnc bbm
rlv: drz mpz
vfj: rnx
xfr: phc rrn pjf
mds: mjl ghs vdv rhr pkc bxk
gnd: ksn crm jhp
rhr: zdm
snb: mpg tdp dlr
pdq: klc xps txm
nrp: zqb bfx hdf jjn
bjc: qmb pgf bgz xpq zjj
pqb: mbz
cvk: vjb lvm spd
bqd: dzs
dgq: hdf cvf sct tpd
jsh: znc
ksd: dmf rdq qvt qnd
jtq: jhz vfh csd mdq
rkl: kxg bqd zpt fvl
zdf: prx
sjh: dmx kqc
pmv: ngf zpt
csp: qrv djs
qcx: zzh gbc gkl
ffn: czs xfc bft fhf qxb
tld: jmz dtj
qzd: lhh znz
ppz: hmd zxt
tnb: tcf
mdx: kbm cth
mqv: vsv
dqk: slm kdp jpt dhl
tvc: cnz sln qgc
ggl: dpn pdc
mpm: tmt ksz
crb: bmc bfh kgk lpq
vsg: mhp lcs hst
lqj: qcd
cxz: ksm lnv
vhg: vqp fbc rgc gks
sbq: jdm cml scc
hlm: xrt
shr: gnd gnm hvz csp qbv
cth: dnh
hdv: fvv vcq jrf
prt: ttm rcx dmh
ttp: scm hln
pzj: kdg vcx xrp
ghc: rzt vdl
mdj: qnf xmr vpq jll hnl
crn: mrk rgz
dzm: rpc trh
xvm: lxp jlj
nql: qpj ksr xjb
dss: nvd kdp pkg
rhs: drg bxl ptj tfb xmk
svs: chh qlt rdz
dsv: vkn
cfj: vtj
gnl: tjb mxp prm sql
rjz: nmz rss slv lkx
hpj: hcz vfl smn ttf zgj
gnc: rdq zxt
zvv: zvj qnn
dzp: ldh xkx smf
kgv: lnf fbc
rfx: hhl jqp sjp qct
mvp: pzn
ljz: bcp lnv mgb xpb
qlk: mqg ncg xrp bng
hpg: dll
brs: jbd xrh rsz ndg
lkq: dhl bbc ljk sct vrz sfn
zgb: vjq
tcj: ckz mvn tld xzs prn
jrt: xnc pts fgd
zqb: ldh
hvc: bzk nrs
vhp: fnt jfm vsv rnn
hvp: ktt mvn ghc
glj: lxp
dkt: bkn mzx vls
frd: thq bsf mpl hgq
kds: cxl jpv sdr xgc
mnn: xsj glr dxv fdh npn kxg zbk
tjb: sgs tzg
vlk: dhj vsk qgc fgd
ljq: nfr jsk cdd
nmk: dtp
fpk: vjj
rbq: znc ttm ksr jvx
rrn: zkf jlp
jrx: mpp vhp qkk gxd dsv
lft: dqs xbk clp zvh
tvt: tss ptt qrv ggk bmc mlk
xgr: fnt glj
jmd: stm jlj dgr xqb
bbt: xcp fhc lzq tsq
tlt: fhh fgv
zcg: nfr nbt bbh
nvd: qjb
qrt: dnj hpn slb gdm
xbn: jjn rzh cdv
dmj: bbd pfl qgn mxb
ldj: qhf qbs gpl vzf
gck: rgz jqj tzf
bnf: mxp mrk
sbv: fbl nnk
rvz: fvd qgr jlz dgz
jsk: ggf rgj pbb
bpt: flr lmd nqz
qxv: hbl xgd ctg
xgk: bjl znm mgb jtg
pqr: zqj qzr
qzm: zdm crq trq fxd
dxh: vzf
gfp: tbd bfh
gct: lvm
jfm: cph
tbc: hdf lmx vzf
qpj: tnb
vrk: xcj tzm hst qvs
szb: nxb
lmg: bmt vjj nrs fnv frm zhk mhg qgm
mhp: gct
mdc: fms dzs
rfc: vjq kzb rgj xzs hmh
tkk: chh khz nlb
fzk: nsr hkm cng
crj: fnm vcq thh
csv: jsp
qzr: jqt
dln: vvq fcl mbz zzp
fbl: dcf dtj dfd khj
mkm: dfm
znz: vdd qxc mzp
qjb: vpp
rsz: glr nlk
lcg: ndf
gvt: ltd jcm znb vgt bgp nbv
kqc: tgm xxn lfx
zvs: xzz pxx
xvq: thh dxv cbp dpp
lmc: ttm bcr mrk jfm
mrk: xdx rdq
ljk: tlf mvf
jbn: trq ldl mpp
hbz: jhm pfp
nmn: kpn
xns: dkt cvn fdh hvp
nmz: xrh slt
kzn: jsp
pzr: bfs vcm sbv bjn nms
skp: zrk zbq crh mgx
jpq: ssx dkj jhz
jqj: xsx hvn
dhq: slm hvh
lkk: djz prn
tdj: rmx jcm lvt rjm qhz
ztj: rdq
nkl: mjj bbd
qcc: vqr smc kqr
tlm: mjm
zjj: xvl
djs: fvg tnq xfc
xxt: lvm
tpp: vkq
kxq: fjs xkx pqr mkg fpj fkv
qcs: mzc vdd vkq rzc
prx: xvl dtg
xqt: qqr
bsq: sfb lbj kkc znb dxr xfr qgh
xqg: djz
xxn: dmv cfj mpg
nph: vdv mtc vfh
jxz: xth pxv ljz khj
xsj: mvp vsg
cxg: kpf nqr bmf tph
xmg: csv npc fjs
hnc: vnq pjg
bck: hss cng ssq dvj
jlv: dhj xdm vgk dpp
phc: bmc qss
gnm: zzh bnh
rpk: rlk qqr lgm
xhz: jbm vhz cng ggf jss
mqg: hfr hqz
khv: qkk ksz
xcj: lfp hqx
qlt: qlv mrk
pqc: bjb fhc npr
rjp: xnv xrt kgm
hkk: bnf svf
stm: ctg prx qct
qkt: pnc tbc xgj rnx jtn
tzm: ghc tgg rzt
rvv: xsc plf gkt
qst: lgm jtn sqd
slm: ztj hpv
dfp: hkm mvn
jcj: mlk dzs rjm drg
qrv: vcn kfj
gpk: klq dbp sfn zqb
ddl: hbb rvq pnc svb
frm: xhd flk
tgh: hjt flz lxh
vxg: kcz bsm xsb kbv zhq
ndg: xbk gfh vgk
jjm: qzd vrh lls fgv jtb
gzx: vpp ncg
slk: dqs bfg rjj vsk
xxl: czj tff jtt
dhl: rzn jcq dsv dtl
ccc: rck xzp
tlg: rjz clp kpn drj vgg
ncv: tzd
cmp: fvn jhz hhl qsz
lmd: ptd
dxt: mnl grd hlm kzb
crm: xth bbh rxh sjg
ttz: dpp
knd: qbs qfh xhm jrn
rlb: pcc mdx mcc jdn
rbv: fbj mgd qpr klq
fdb: lpv rtz lzp
ssc: vff zgc ljn jbm
gfq: qbv dfp bqp fbc
lpq: zgb hqf
kjp: qbv
ksr: xrp
jcn: dtp fnv slb
nbv: gdt gkh rfq
vff: jhf hrs pqq mmj
hmd: zjf fkt
fnv: bqd cfc
rdk: xzq rzt rjf xzz
jdm: grd grf
xgv: sdt cth mgp lfl
cbp: dfd
jhs: hvh hfx ptd fxd
nqr: vcx flp plf
djt: csv dqp fgv
dlq: mjr mkm ghb tcr
dnt: lcs
pzp: xmr nvc xpb
pmh: szq
pjf: klx rpc sjg
mvq: qps
rcn: pkm xgm mxt ggs
jzr: nvt
fkv: lnm
sdt: jqp
mfk: nlg dvx dfm dxh mfm
gbn: hqf tzm djb sdf
ckz: kqr xmk
jxd: svs mdx xdx hff qlc
gvv: vfh hfr
sbg: xhm
mcg: lpv
lkb: szb ncv xps mgx jgc nrs
zfh: rxm lmq crm
rtc: rvv qfk pqc rhr
tgm: xbf lhj
hff: kkg sfn
ttc: bdk tnn xgr
gxt: dnj
qmd: qqn
bct: qnf
pmt: xfc bzk vtr nlk nvt
qrd: jjr pqb
pgt: vkc lnr khv
ggp: pzn tgk zgc nfv
htg: vkq vph
hcv: vnq hnc
jhz: jsh
dhp: lfs bgz jts qgn rtz
cmv: kgv jll svz kzb
hcg: jtn kdp fjs vfj skx
bgz: drr kdp
bnb: kbv
sgs: tdp vdg tgm
drz: vxb jdm
kcz: xfb hgq dnv
mkg: ghs xbf mcg pgf
gzr: pcc
zkc: klc jvm djr
ghs: znd
qtz: hdf dll ccz fdb
dqv: jpq vfj grb jts
shv: cdp xfb pts cnk
xlm: dsv hxb kdg szm qqn
jgc: vpq lkk
chl: pvv mjm xqg
pjn: ctq
cjg: zvs lqj hcz fpk ccc
flz: lvm mfs
qzp: nsm zpt
nfr: hnp nnk
jjn: cfs jlz hqz
qmj: kdg qnn cxf
djr: lfv lnr tff
kxl: bbg
kfr: qzd mmg hbb fvd
kdr: qnk cvm dnk jmr
jxf: thk
klc: bsp rbn
vrl: xgp fbp pcs dsp znc
pxs: znz fsz hbq cjd
zbj: jqs nfr
vdv: fhc
llf: xnc fvg jbt
gnz: fzl hcz
fdj: ngf kjp vls bmd
hhq: ktd
hpn: jtg
cdv: htg vfs
pfc: jlm zqn mkl vtr
hgd: mvq dll kzn xcp
fmg: qzp zfh mmf gsj
crl: lcg tlm
hjg: mvf
fgv: rsl
dqp: zqj qpj
dcg: hkf
vqb: psg
gzn: qcd phc psg bzk
fgd: gxt mmj
tmk: xsb
smb: ptd
nzf: bps znk
dmv: ckn
tzc: xlt fpk bsp
rzh: bkr
fbm: hvl pmh hvn gfj
xcp: sbh mcg hcp
tsn: bjl jmz znm
znm: lnr bbb
dzr: xsb zgb pns dnt fbz
vtr: gdd
mpv: rzc sqp zrt
zkt: gfq lfv hpn jhq nnk
zcl: ddx hzp jph cxz
xrd: kcq xhm vtj
fkn: gnz gct psg fzk
vjq: bcp
sqg: lhj
zvh: jfj
svz: hpk llp
thq: hlh
mnq: cph bjb rzc
jkj: hff tmt hxh tsq sbh
srh: qzq lsl brm mvn
dtl: dkj pxp lzq
pqk: dll ktd xdx tph
fcf: tlg nmz frr qtr xll
bqg: sbh
zcx: szc
qrp: tkk vzq pjd pqh mxb
mmf: pxx pzn mmt qmt cng
vvz: ktd cvf mtc qqr
llz: jhm
bcn: kjp
smn: bcn jrt
xqb: nvr bxk npr bnf
npr: sdt nrz
pqz: sjg txm mjm thh
mxp: jlz gkt
dxv: cdp scm
jbm: msb zcg mmp
kbj: mrv xpb djb
sgb: mhx
spj: lsp mjr xbl nph
xrv: tcb jgl khz jhn
btd: vmd xvm
ddb: sjp mcv nkl vmd
xgg: mdx frn jbn qgg qmd
srt: xxk kpf
pnf: rhz gkh hxk jmr
nxk: tmk dnt lct
dvx: gzr jkd cns fbp
str: vhz bct ktt scm qbj
brj: mjd tgh jzd
jmz: ltp
nfv: jxh rfs
lgz: tmq lgm
dsx: vhv bmc mcf pns
jtx: xjs xbn gvf smt
gpq: cmh xgm bss fmx xxk
plc: kqb
ngm: hlh jrb
vng: bqm cxf szm gpk
nln: qxc vdv nqz bph
dsd: mpm
cqj: jkd xdc fgm
zzp: tmf
kvm: nvt jzr bbb ljq xps
qxb: zfz mfs
prz: znz zkd tjb
dfq: dxr jgc mjs mjd
zgj: khj
