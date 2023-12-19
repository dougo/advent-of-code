=begin

To start, each part is rated in each of four categories:

x: Extremely cool looking
m: Musical (it makes a noise when you hit it)
a: Aerodynamic
s: Shiny

Then, each part is sent through a series of workflows that will ultimately accept or reject the part. Each workflow
has a name and contains a list of rules; each rule specifies a condition and where to send the part if the
condition is true. The first rule that matches the part being considered is applied immediately, and the part moves
on to the destination described by the rule. (The last rule in each workflow has no condition and always applies if
reached.)

Consider the workflow ex{x>10:one,m<20:two,a>30:R,A}. This workflow is named ex and contains four rules. If
workflow ex were considering a specific part, it would perform the following steps in order:

Rule "x>10:one": If the part's x is more than 10, send the part to the workflow named one.
Rule "m<20:two": Otherwise, if the part's m is less than 20, send the part to the workflow named two.
Rule "a>30:R": Otherwise, if the part's a is more than 30, the part is immediately rejected (R).
Rule "A": Otherwise, because no other rules matched the part, the part is immediately accepted (A).

If a part is sent to another workflow, it immediately switches to the start of that workflow instead and never
returns. If a part is accepted (sent to A) or rejected (sent to R), the part immediately stops any further
processing.

The system works, but it's not keeping up with the torrent of weird metal shapes. The Elves ask if you can help
sort a few parts and give you the list of workflows and some part ratings (your puzzle input). For example:

px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}

The workflows are listed first, followed by a blank line, then the ratings of the parts the Elves would like you to
sort. All parts begin in the workflow named in. In this example, the five listed parts go through the following
workflows:

{x=787,m=2655,a=1222,s=2876}: in -> qqz -> qs -> lnx -> A
{x=1679,m=44,a=2067,s=496}: in -> px -> rfg -> gd -> R
{x=2036,m=264,a=79,s=2244}: in -> qqz -> hdj -> pv -> A
{x=2461,m=1339,a=466,s=291}: in -> px -> qkq -> crn -> R
{x=2127,m=1623,a=2188,s=1013}: in -> px -> rfg -> A

Ultimately, three parts are accepted. Adding up the x, m, a, and s rating for each of the accepted parts gives 7540
for the part with x=787, 4623 for the part with x=2036, and 6951 for the part with x=2127. Adding all of the
ratings for all of the accepted parts gives the sum total of 19114.

Sort through all of the parts you've been given; what do you get if you add together all of the rating numbers for
all of the parts that ultimately get accepted?

=end

require_relative '../util'

Aplenty = Data.define(:workflows, :parts) do
  def self.parse(text)
    lines = text.lines(chomp: true)
    blank = lines.index('')
    workflows = lines.take(blank).map { Workflow.parse(_1) }.index_by(&:label)
    parts = lines.drop(blank+1).map { Part.parse(_1) }
    new(workflows, parts)
  end

  Workflow = Data.define(:label, :rules) do
    def self.parse(text)
      text =~ /(.*){(.*)}/
      new($1.to_sym, $2.split(',').map { Rule.parse(_1) })
    end

    Rule = Data.define(:condition, :destination) do
      def self.parse(text)
        condition, destination = text.split(':')
        if destination
          new(Condition.parse(condition), destination.to_sym)
        else
          new(nil, text.to_sym)
        end
      end

      Condition = Data.define(:category, :comparator, :value) do
        def self.parse(text)
          text =~ /(.)([<>])(\d+)/
          new($1.to_sym, $2, $3.to_i)
        end

        def matches?(part)
          rating = part.ratings[category]
          case comparator
          when '<' then rating < value
          when '>' then rating > value
          end
        end
      end

      def process(part)
        destination if !condition || condition.matches?(part)
      end
    end

    def process(part)
      rules.each do |rule|
        destination = rule.process(part)
        return destination if destination
      end
    end
  end

  Part = Data.define(:ratings) do
    def self.parse(text)
      text =~ /{(.*)}/
      pairs = $1.split(',').map do
        _1 =~ /(.)=(\d+)/
        [$1.to_sym, $2.to_i]
      end
      new(Hash[pairs])
    end

    def sum_ratings
      ratings.values.sum
    end
  end

  def accept?(part)
    label = :in
    loop do
      label = workflows[label].process(part)
      case label
      when :A then return true
      when :R then return false
      end
    end
  end

  def sum_accepted_ratings
    parts.filter { accept?(_1) }.sum(&:sum_ratings)
  end
end

if defined? DATA
  input = DATA.read
  obj = Aplenty.parse(input)
  puts obj.sum_accepted_ratings
end

__END__
gv{a>1626:A,x<2292:R,a<1391:R,R}
mz{s>2500:R,a<2822:A,hs}
jnm{m>3195:stc,a>2540:A,A}
jpp{s<2906:A,s>3393:sv,gnh}
pt{x>716:rhp,tdf}
hqn{s<3008:mfs,pq}
rtk{x<2830:A,x<2885:A,A}
kq{a<632:nvf,a<1136:tf,a>1443:th,nhq}
xg{m>1068:qtn,m>402:sn,mdz}
pg{m<1461:dht,mb}
zq{s>2627:xq,m<1357:vj,R}
vdv{s<2390:R,A}
nf{m<3379:R,m>3431:R,s>2954:R,A}
mfs{a<3611:R,m<267:R,R}
jtb{x<2297:rf,x>2400:A,dxt}
th{s>2634:A,s>1406:dr,fb}
mp{x<3510:cft,m>3273:vsz,bb}
bl{m<2278:A,m>2498:zkd,m>2415:cnr,A}
tdd{s<1524:A,a<2977:A,R}
vl{a<370:R,x<3428:rk,m<1778:kz,mv}
xpt{x<2026:R,a>3504:R,a>3286:R,R}
fk{x>3584:A,x>3557:A,s>2393:R,R}
tq{s>2003:R,A}
chq{m>234:A,s<819:R,R}
cl{s<1197:mln,a<1464:lhx,np}
sqv{a>382:gvc,a<201:sbl,x<2009:qqb,rgd}
cfz{s>625:ndm,s<298:A,a<1343:flz,qz}
tg{m>661:rh,x<1070:R,a<1684:lm,qvk}
rmf{a<3342:zll,a<3743:R,R}
xc{x<3180:hvj,ffg}
fgz{x<1151:A,m<3728:R,A}
vn{a>3376:R,a<3159:R,x<2074:R,A}
pp{a<989:A,a>1017:R,A}
fkk{x<2805:A,a>2429:A,s>104:R,A}
jst{m>1546:A,m<1366:A,m<1454:A,R}
zn{s>2488:rnm,nx}
fbc{s<531:ntk,x>2165:A,s<803:rmp,A}
mqm{a>3484:R,x>3693:zj,qmn}
kg{m<746:R,R}
tv{m<1407:R,m<1450:R,qsz}
tzb{a<2926:rv,s<3094:mgv,x<518:tqg,R}
zg{a>3707:A,A}
hb{x>3452:A,R}
ctx{s>2707:A,s>2162:pbp,x<3029:pn,pbd}
xtn{m>2727:R,A}
hq{x<2832:A,A}
fhr{x>2884:R,x>2337:hz,zg}
tdf{m<896:A,dn}
kp{s<2448:A,m<872:R,R}
zp{s<647:A,x<3489:R,A}
cz{s>2577:R,R}
st{a<1428:A,R}
tf{s>2651:vqd,m<1017:R,A}
khc{x<2181:hdp,gp}
mdz{s<1990:kbk,a>3381:hqn,s<2870:bmh,cm}
gr{a>743:gbf,s>1383:hdv,s<822:A,bvc}
sv{x>1784:R,m<1537:A,R}
ts{s<3033:pl,x>2159:nb,skp}
rb{x>1111:A,m<846:R,R}
jjm{x>2823:A,m<1711:A,s<271:R,R}
dpn{x<2704:A,R}
ql{a<3697:R,A}
smn{s>1866:A,A}
dnf{x>3351:R,R}
prt{x<3309:A,R}
bmq{a>1889:ntl,m<633:grk,vg}
kcn{a>572:R,rss}
zfx{x<2779:zf,a>694:rtk,rtb}
jm{a<3682:A,s>1216:R,R}
zzn{x<3858:A,a>2334:A,s<2098:A,A}
nq{m>3453:A,m>3380:R,A}
djf{s<2440:R,lf}
xvn{s>3661:R,s>3377:R,R}
ppx{s>167:R,x>2714:fkk,s>111:jgk,nhl}
kdk{a<3048:R,A}
cs{a>669:R,R}
dht{a<3351:R,a>3650:R,x>3199:A,R}
gp{m<1557:R,x<2343:A,xbp}
hk{x>3834:R,a>2202:A,a>2141:R,R}
fpj{m<2900:R,m>2975:R,m>2938:A,R}
ck{m>1133:nd,m>615:rb,jk}
qr{m<3471:A,m>3716:R,A}
gnx{m>2688:rkp,a>1361:zs,s>1589:ctx,tnh}
vt{x>1602:A,R}
vb{x<662:R,R}
jp{a>3527:R,a<3376:R,x<2781:R,A}
ft{a>2992:jl,R}
jv{s<3113:pg,xvn}
hrn{s>3698:R,R}
qmn{a>3311:R,s>1495:R,s>520:A,A}
xlm{x>3684:A,a<2142:R,sqs}
tp{m<1421:R,x>774:R,A}
zpv{a<1483:R,s<2686:A,A}
tj{m>1508:A,R}
rgd{s>1866:R,x<2211:xvf,cps}
vnb{x<2798:A,x>2879:A,a>567:A,R}
spl{x>694:rz,xbq}
cn{s>927:br,s>601:mf,m>1330:tv,cpq}
gz{x>1390:A,svk}
kj{a<2615:fc,m<2548:R,m<2907:R,bzp}
skx{s>3484:A,R}
lhx{x<2770:mg,m>3200:A,a>816:R,vsl}
mr{s>2938:R,x<3674:hb,kp}
knf{m<1135:A,m>1173:R,a>592:R,R}
zdr{x>2117:A,ql}
ghx{x>3010:nqp,s>2471:hqz,a<2762:R,R}
gbf{s<2015:A,s>3127:A,s>2648:R,A}
ntk{a<1181:R,R}
ntl{x<3135:hfr,a>3109:fh,a>2343:qtf,xr}
tkj{m<2747:cbm,a<3155:ghx,a>3490:gs,md}
dn{m>1478:R,a<2592:R,R}
gzf{a>2840:gfm,x>2139:msr,m<2415:llf,jx}
qjk{a>2045:pk,hf}
rv{m<220:A,s>3309:A,x<455:A,R}
cnr{x<806:A,a>2832:A,m<2462:A,A}
hrr{s<1673:mzg,s>2487:mh,a<854:qfb,jvh}
kpb{x<3345:R,a>3444:R,R}
gx{s>797:R,a>273:R,a>243:R,R}
ph{s<1396:R,s>2092:A,A}
dzd{a<2134:kfb,m<3281:dhp,zrz}
ncm{m>1148:pgc,m>674:js,spl}
sh{a>1318:tg,xlj}
zkd{x>556:A,A}
svk{a>2492:A,x>1348:A,A}
zs{s>2186:A,a<1685:kbx,s<1065:sql,lx}
mss{s<1775:fft,x>3358:ds,R}
kmm{s>2616:A,m>709:R,a<2740:R,A}
kpg{s>1722:jpp,x>1766:vnk,cfz}
gms{x<140:R,x>146:R,a>2696:A,R}
lf{m<585:A,a<974:R,x>433:A,A}
nx{m<1388:stq,fbj}
db{m>2852:dqd,jtb}
br{x<2797:R,pts}
vgf{x<1907:A,R}
jgk{a>2374:A,A}
xzf{a<2888:R,a<2950:R,R}
gb{m<2867:A,a<2297:A,a<2509:R,R}
qp{x<2047:hl,tm}
qz{a>1605:R,m<1490:A,A}
ktg{x<2509:A,x>2602:R,s>2311:A,R}
lv{a<2923:gb,R}
vs{a>2524:R,R}
qh{s>447:lv,a<2728:ppx,dd}
qfh{a>3044:A,A}
fmz{m<3405:R,a<2369:R,x<867:R,R}
tlk{m<1719:R,m<1785:R,a<2848:R,A}
tm{s>2522:tpk,x<2427:cjh,rvg}
pbd{x<3069:A,m<2187:A,A}
jld{m>1023:R,s>1769:A,R}
vgb{s<911:A,m>2462:gh,R}
hqc{a>540:R,a>255:A,R}
fn{m>1673:A,A}
chh{m<650:R,R}
fps{m<786:rj,A}
rz{x<740:R,R}
qj{x<1875:A,R}
nb{m<1754:qs,a>3434:xxk,x>2543:kdk,A}
bp{x<2596:dzd,pc}
vth{x<1156:A,a>2527:R,m>3838:A,R}
mg{m>2653:A,m<2251:R,R}
lkz{x>2734:A,s<2999:R,R}
rmp{s<669:R,s>729:R,A}
shm{x>2778:jv,m<1536:qp,ts}
mlg{x>3474:ct,x<2872:fn,dfp}
lx{m<2181:A,A}
bcl{m>1554:jh,sjk}
qhv{s<3244:stf,a>767:A,tnl}
kr{a>700:A,R}
xk{m>869:zn,m<498:tk,x>696:sh,kfl}
td{x<3850:R,x<3944:A,R}
cdm{a>77:A,R}
nlb{s>3048:A,R}
dks{s>1333:hxf,a>1523:tkk,a<1474:A,R}
lg{s<2612:R,s>3192:A,x>1611:A,R}
fkn{x>2863:R,R}
lhm{x>1956:R,s<1391:A,m<3844:A,R}
rq{m<714:A,R}
qvk{m>572:A,a<2077:R,s>2645:R,R}
tqb{s>1861:R,s>1759:R,a>191:R,R}
ks{x>245:qzm,m>1359:R,a<2637:R,R}
dkt{a<2417:dnf,s<1727:xvs,nr}
mrh{x>370:sq,rr}
mgv{s<2588:A,R}
xcx{x>476:xcn,m>321:mff,A}
pts{x<3285:A,a>3601:R,a<3321:R,R}
nm{a<3287:A,A}
klf{x>2155:nh,s>2623:R,s>2132:R,R}
xr{m<751:xlm,x<3512:qjk,kqg}
nvf{x<1884:ns,sg}
rcv{s>681:zd,s>418:mcb,jjm}
rrr{m<1477:R,tsn}
vg{x>2473:vnl,m>896:kq,zkp}
hvf{m>3747:dlq,x<1527:zfb,nv}
dz{a>3250:R,x>2674:A,A}
gnh{s<3150:A,R}
sz{s<1685:gd,a<2780:cx,shm}
fp{s>1446:R,A}
cbm{a<3323:dxs,s>1846:rnc,R}
gd{a<3166:bkt,m>1626:kkm,m>1496:bcl,cn}
kf{a>1386:R,m>717:R,m>680:A,A}
lzm{a<2106:gnx,tkj}
vnl{s>2268:qhv,s<1395:vbq,x>3003:zdz,tr}
jlv{x>3323:R,m>1009:R,a<3435:A,R}
vsl{x>2859:A,s<1320:A,A}
sj{m>1488:A,m>1393:vvg,x>2519:pz,jj}
jg{a<1262:bxs,a<1478:R,x<2688:ndx,A}
tqg{m<269:A,s<3447:A,s>3675:A,R}
xbp{a>1452:R,a<1241:R,A}
bzp{m<3033:A,m<3173:A,m<3207:R,R}
srt{x<2709:xll,s>493:vnb,kb}
sjj{s<753:A,A}
qd{s>2648:R,A}
hdp{m<1527:lmr,R}
llf{x>1839:gg,s>2585:vt,s<886:A,zb}
tgq{m<3250:qrk,s<2611:mmc,fgz}
mff{s<1188:A,s<1662:R,R}
pjk{s>3076:R,m<164:R,m<298:R,A}
ntm{m<1550:A,a<1304:A,s>2179:A,A}
nk{m>1212:R,a<3575:A,R}
gsc{m>1534:A,m>1362:R,x>2271:R,R}
hqz{m<3210:R,s>3174:A,x>2979:R,A}
skp{a<3307:skx,m>1707:sb,m<1649:A,ptk}
xbg{x>2442:hrr,pkp}
rbt{x<1033:R,m<1140:A,a>1016:A,R}
xcd{s<1765:R,m<3868:R,s>2557:A,R}
srg{a>3563:rq,nm}
dxt{x<2348:R,A}
pbp{s<2390:A,A}
mzg{s>876:tj,mlg}
knc{x>3022:R,s>725:R,a<3816:A,A}
bkt{a<2525:xst,s>605:zvk,sj}
bx{m>1748:kks,s<1956:tqb,a>293:A,qf}
zdz{a>1110:lrk,m>929:knf,m>802:R,mdc}
pmz{x>3446:A,m>1038:qg,m>913:R,A}
lgz{s>1432:rzd,s>754:cl,a<1890:msl,qh}
kc{s>3019:R,s<2792:A,m<101:R,A}
mf{x>2505:A,x>1972:R,a<3484:A,A}
qgm{s>3444:hrn,a<3528:R,A}
gh{x>3678:A,m<2878:A,A}
gk{x>2105:A,R}
zj{a<3250:A,x>3833:A,R}
tb{a>1186:ss,a<424:A,s<1587:R,R}
hxx{m<2783:bl,s<1802:rmf,nbb}
pq{x<929:A,m<191:R,m>299:R,R}
ppb{a>1033:R,pp}
nss{a<1848:R,s<2957:R,R}
ptk{s>3431:R,x<1786:R,s<3264:R,R}
cq{m<2941:R,qr}
zf{x<2692:A,R}
zd{x<2710:A,A}
tr{m>843:jld,x>2741:fkn,R}
dlq{x<1630:xcd,s>2138:R,lhm}
rh{x<1072:R,x<1355:R,x<1466:R,A}
nh{x<2328:A,A}
fh{m<666:mqm,s>1910:mr,s<874:pmz,cb}
nbb{m>3087:R,R}
pkp{a<966:sqv,x<2021:kpg,s>2616:khc,tpc}
px{s>2204:A,a<3606:R,m<1704:R,sjj}
xst{a>2055:jst,A}
dng{a<2679:gz,a<2902:fg,m<820:ft,zq}
qrn{x>1997:sp,m>782:A,kf}
xqz{a<2574:R,A}
qqb{s<1370:gx,R}
nqp{m>3342:A,m<3006:A,A}
sbh{x<3027:R,A}
dqd{x>2249:R,a<1182:R,R}
vv{m>219:R,x<1207:A,fxh}
mln{a<1976:vjx,s>1022:A,s>920:qfh,R}
kgj{a>310:R,x>3755:R,A}
zb{s>1942:A,s<1374:A,R}
ss{x>154:A,R}
rj{m>688:A,m<654:A,R}
dq{m<3179:A,x<3055:R,a<1292:R,A}
hfr{a>3093:zdr,gjg}
flz{a<1095:R,x<1684:A,A}
msr{m>2527:tq,A}
mdc{x>3450:R,a>523:A,x>3277:R,A}
cm{s>3383:R,a>3161:A,a>3097:R,pjk}
xcn{m>325:R,R}
rk{s<2304:A,x<2814:R,x>3059:R,A}
jr{s<1716:A,R}
rn{x<1003:R,R}
rzd{a>1688:jnm,cq}
kfb{x>1713:db,x>576:tgq,mrh}
rkp{x<3009:pr,s<2635:dq,fr}
rr{a<1420:R,R}
rss{s<641:R,a>248:R,A}
rvg{x>2629:R,a<3462:A,A}
kbk{a>3641:R,m>162:nkn,R}
gvc{x<2059:qj,gsc}
in{m<1891:qt,bp}
rfh{x>2463:pkt,a>2387:klf,bj}
gjg{x<2143:A,xp}
zvk{a>2780:nz,R}
nhl{a<2218:R,R}
fgk{s>1732:R,x<53:R,x>107:gms,ffs}
vxm{m>638:bk,a<2796:bq,s<2297:xcx,tzb}
fc{m<2556:A,R}
dfp{x>3235:A,a>910:A,x<3057:R,A}
xmd{a>922:R,x>3732:A,a>743:A,A}
sql{s<597:R,m<2259:R,A}
qzm{a<2814:R,s<3302:A,x>326:A,A}
zfb{s<1480:nq,m<3533:nf,x>907:A,R}
kk{m<319:R,R}
dlr{s<905:R,m>199:A,A}
pb{x>2786:R,x<2666:A,A}
tdv{m<1498:R,x<987:R,A}
kqg{a>2066:hk,s>2631:A,A}
xbx{s>2719:A,a<983:A,R}
zkn{s<1827:A,s<1953:R,s<2024:R,A}
pn{m>2266:R,A}
tnh{s<645:hqc,sbh}
ndx{a>1604:R,A}
zdm{x>3453:R,m>1480:fcm,a>1016:nlb,jds}
dd{s>212:R,x>2759:R,m>2715:dz,dpn}
hbh{a<1872:kk,a>2068:R,x<401:dlr,R}
hx{x<158:fgk,m<860:mxx,s<2196:xs,ks}
lm{s<1385:R,R}
vsz{a>1382:nkh,m<3626:tqv,s<1474:kcn,xnd}
ffs{x>83:R,x<67:R,R}
vd{x<3351:smn,x>3705:A,zkn}
hqb{s>1800:zpv,m>444:gcv,R}
mn{s<3139:R,x<2638:R,R}
stf{s>2786:A,x<3298:R,a<942:A,A}
ffg{a<1170:jz,a<1539:jkn,a<1755:A,R}
cft{m<3274:cc,a<1579:jgj,m<3709:mss,dkt}
bbv{s<500:R,A}
hc{s<295:A,a<3743:R,A}
xnd{x>3792:vdv,a<580:bzc,x<3626:fk,xmd}
dv{s>2596:td,zzn}
tpk{s>3193:R,a>3198:A,A}
md{s<1675:R,x<2991:A,m<3530:clh,A}
sm{m>1770:A,A}
dhp{x<1385:hxx,gzf}
hvj{s>1803:mn,a>1147:gv,R}
hz{m<1646:A,R}
bvc{a>388:R,x<2847:R,x>3356:A,A}
fbj{s<935:A,x<813:R,s>1808:A,R}
fr{s>3419:A,x>3036:A,a>1063:A,R}
cb{x<3487:jlv,m<908:A,x>3694:A,A}
nmj{x<1296:ck,dng}
xs{s<1447:A,s>1941:R,a>2729:jr,R}
bq{s>2522:A,s>1096:A,A}
jh{x<2943:R,kpb}
pz{m>1306:A,s>304:A,s>118:A,R}
xvf{m<1492:A,m>1727:A,R}
cps{m>1502:A,A}
jvh{x<3118:jg,m>1655:nhp,pmc}
kb{m<2564:R,x>2829:R,m<2767:A,R}
xmm{m<1307:A,x>3671:R,R}
nhp{s<1956:R,m>1780:A,rzb}
lgj{m>662:R,A}
xll{a>631:R,R}
zdk{m<3558:fmz,m<3748:ffz,qkr}
lmr{a>1332:A,A}
vjg{a<3287:R,R}
lp{s>2712:A,A}
mvx{a>3496:A,A}
bzc{a>217:R,s<2494:R,m<3820:R,A}
bb{x>3800:zct,a>1748:kj,s>1910:lp,vgb}
rf{m>2452:R,s>1816:A,A}
ffz{m>3651:lg,s>2029:vs,xqz}
mh{x>3134:zdm,lkz}
hcn{s>3451:A,x<253:nss,m>206:A,kc}
stc{a<2673:R,s>2450:A,x>2734:A,A}
trd{s>306:bbv,a>1431:R,m<2986:zhz,R}
vqd{m<1026:R,A}
tnl{x<3010:R,x<3595:R,R}
vbq{a>707:A,R}
nkn{m>266:R,a>3270:A,A}
bj{x<1894:dpp,tn}
xbq{a<2897:R,s<2072:R,m<329:A,A}
stq{a>1300:A,x>986:A,R}
tn{s<3122:R,A}
jgj{s<2083:prt,s>3311:R,xbx}
nmh{m<3178:A,x>2709:A,a>282:R,A}
qg{x>3276:A,A}
pl{a>3242:sm,a<2950:cz,x>2145:ktg,R}
sg{m>1056:R,x<2180:R,A}
kbx{x<2992:R,a>1511:R,s<1196:A,A}
jk{a<2637:rn,xzf}
tpc{a>1385:dks,s<976:fbc,a>1143:gl,ppb}
hf{m>1078:R,x>3374:R,A}
bk{m>1106:R,a>2663:qd,x<531:A,A}
tqv{a>769:R,kgj}
cjh{m<1426:A,m<1475:R,x<2200:R,A}
pgj{m>699:R,m<667:chh,A}
cx{x>3093:jt,rfh}
qs{s>3447:R,m<1644:A,a<3312:R,R}
hxf{x<2293:A,a>1626:A,A}
ndm{s<1203:A,A}
qkr{x<976:ddr,x>1679:R,x<1355:vth,A}
tk{a<1478:fl,x>748:vv,s<2667:hbh,hcn}
kz{s>2355:R,s<2260:R,m>1733:R,A}
bxs{s>2164:A,s<1958:R,s>2075:R,R}
xsx{s>1440:A,R}
qtn{m<1356:pv,x<558:px,zt}
pmc{m>1419:ntm,a>1206:xmm,a<1048:R,R}
fl{s<2105:chq,m<179:A,R}
grk{m>340:jcv,xc}
xvs{a>3120:R,A}
pr{a>1064:R,x<2970:R,R}
pkt{a<2436:sfv,sr}
qsz{x<2988:R,R}
lrk{m>1009:R,a>1604:A,a>1325:A,R}
bc{x<3909:R,m>2644:A,m<2170:A,R}
jl{m<369:R,s>2628:A,m<538:R,R}
rzb{x>3474:A,a>1281:A,x<3312:A,R}
vrc{s<654:A,m>2480:R,A}
sjk{s<1045:R,x>2392:fv,xpt}
hdv{s>2925:R,A}
tt{a<2527:R,s>1636:A,s>916:R,R}
tll{s<1249:A,a>2170:A,a<1912:R,R}
pjv{s>618:R,A}
jkn{s<1488:R,A}
sq{s>1406:frp,x<505:A,A}
pv{s>2304:A,nk}
ld{a<2384:xk,a>3038:xg,x>823:nmj,fq}
pgc{x>747:tp,m<1514:R,a>2901:tdd,tlk}
fb{m<1046:R,s<893:R,A}
jcv{a<1244:gr,hqb}
zct{a>2412:xtn,s<1544:vrc,bc}
kkm{m>1756:rmz,m<1677:fhr,rcv}
mcb{x>3060:R,x>2142:A,s>560:A,R}
hl{s<2879:R,m<1427:pm,A}
jx{x>1738:vgf,tt}
fxh{x>1433:R,x<1356:A,a>1845:R,R}
ct{s>517:R,A}
sqs{s<2400:A,A}
nhq{a>1291:R,A}
rhp{a>2612:A,m<855:A,A}
gcv{s>737:A,m<540:A,R}
kfl{m<671:djf,x<346:tb,kg}
cpq{x>2706:A,a<3596:gk,hc}
js{m>880:R,m>784:fp,s<2170:xsx,A}
jt{x>3646:dv,bs}
qf{m>1719:A,A}
rmz{m<1819:jp,s>570:hq,R}
gg{m<2182:A,R}
tkk{x<2236:A,R}
qfb{m<1669:rrr,s>2111:vl,a>455:vd,bx}
nz{s>1254:A,A}
sp{a>1475:A,m<765:A,m>826:R,R}
dpp{s>3127:R,R}
jds{x>3297:A,R}
dtd{a>462:A,nmh}
fft{a<2577:R,R}
sr{x>2681:A,m>1602:R,m<1476:R,A}
dxs{s>2372:A,R}
zt{m<1692:tdv,a<3450:R,s<2384:jm,R}
qtf{s>1650:mz,jsk}
vvg{s<335:A,R}
jj{x<1979:R,a>2863:R,R}
xp{a>2465:A,A}
vnk{m>1646:A,st}
pc{x>3090:mp,x>2921:lzm,lgz}
dr{x>1968:R,s>2089:R,R}
mv{a<554:A,m>1822:R,s>2348:R,A}
nkh{s>2407:R,s<1385:A,A}
mb{s>2548:A,R}
nv{s>1406:R,a<3369:R,a>3682:pjv,R}
qt{x<1564:ld,m<1244:bmq,a>1794:sz,xbg}
pm{s<3403:A,A}
rtb{m>3627:R,a<354:A,A}
sn{s<2589:srg,x<535:qgm,mvx}
sfv{s<2852:A,a>2177:A,A}
fcm{a<1102:R,s>3124:R,a>1519:A,A}
mxx{m>385:A,m>193:A,qdp}
qrk{x>1013:A,R}
vj{m>1033:R,m<935:R,R}
sgp{a<129:A,m<1642:A,A}
kks{s<1854:A,A}
xlj{s>2558:lgj,cs}
fq{x<369:hx,x<625:vxm,a<2798:pt,ncm}
gs{s>1384:A,m>3389:A,m<3052:fpj,knc}
hs{s>2023:R,R}
msl{a>1176:trd,m<2920:srt,m<3359:dtd,zfx}
vjx{s>998:A,R}
gl{x>2167:R,a>1233:R,m>1615:prv,R}
xxk{a<3754:A,R}
bs{m<1476:R,x>3334:A,R}
pk{m>927:R,s>2188:A,A}
prv{x>2079:R,s>1611:A,A}
clh{a<3338:R,R}
jsk{a>2826:zp,A}
tsn{a<429:A,R}
fv{a>3661:R,s>1447:A,A}
rnm{x<761:R,m>1378:R,rbt}
nr{a<3423:R,x<3246:A,A}
ds{a>3055:R,x>3451:R,A}
zrz{a<2803:zdk,hvf}
fg{a>2787:A,kmm}
mmc{a<1180:kr,m<3684:A,ph}
sb{x>1883:A,a<3704:A,m>1825:A,A}
frp{a<1413:A,R}
qdp{a<2664:R,m>95:A,m<61:R,R}
gfm{m<2817:vn,x>2186:vjg,s<1758:A,R}
sbl{x<1933:A,x>2105:sgp,s>1745:cdm,R}
rnc{s>3265:R,x>3000:A,R}
zhz{a<1284:R,R}
cc{a>2646:A,mk}
ns{x>1705:A,x>1649:R,R}
zll{a>2593:R,m>3102:R,s<796:A,A}
jz{a<396:R,a>742:R,x>3475:R,A}
np{s>1300:R,a>2894:pb,tll}
xq{m>1289:A,a>2951:A,m<1012:A,R}
bmh{a<3174:A,vb}
scs{a>770:A,m<842:A,R}
zkp{a>1024:qrn,a<474:fps,m>780:scs,pgj}
ddr{m<3896:R,m<3956:A,m<3974:A,A}
mk{s<2413:A,x<3330:A,x>3427:A,A}
nd{m>1585:A,R}

{x=1268,m=110,a=246,s=37}
{x=114,m=531,a=756,s=635}
{x=190,m=2840,a=30,s=56}
{x=2344,m=18,a=2231,s=294}
{x=4,m=1314,a=833,s=2704}
{x=1692,m=912,a=961,s=1724}
{x=995,m=11,a=2638,s=2265}
{x=114,m=658,a=9,s=1721}
{x=200,m=2587,a=2538,s=509}
{x=2154,m=1989,a=788,s=417}
{x=1254,m=959,a=286,s=131}
{x=1489,m=1023,a=280,s=54}
{x=1180,m=2777,a=1751,s=122}
{x=589,m=2307,a=309,s=219}
{x=2793,m=1796,a=1072,s=487}
{x=2278,m=2128,a=58,s=1002}
{x=471,m=18,a=1487,s=1880}
{x=1478,m=179,a=1304,s=25}
{x=1502,m=2567,a=1185,s=560}
{x=782,m=732,a=903,s=946}
{x=2989,m=3235,a=1859,s=311}
{x=616,m=563,a=1565,s=525}
{x=293,m=69,a=94,s=1680}
{x=266,m=3369,a=106,s=146}
{x=327,m=414,a=1171,s=2598}
{x=2260,m=3,a=2344,s=491}
{x=701,m=136,a=236,s=584}
{x=2707,m=747,a=801,s=3855}
{x=4,m=692,a=1254,s=1343}
{x=484,m=732,a=1249,s=960}
{x=1268,m=135,a=2984,s=123}
{x=1885,m=436,a=915,s=489}
{x=882,m=266,a=56,s=76}
{x=59,m=588,a=1502,s=885}
{x=2266,m=114,a=684,s=582}
{x=2712,m=1504,a=2065,s=932}
{x=65,m=241,a=521,s=155}
{x=8,m=2106,a=139,s=773}
{x=570,m=1396,a=1548,s=728}
{x=611,m=1829,a=862,s=734}
{x=2242,m=342,a=1019,s=1772}
{x=82,m=764,a=315,s=521}
{x=1453,m=323,a=538,s=2301}
{x=2405,m=443,a=1011,s=612}
{x=360,m=185,a=796,s=1274}
{x=793,m=277,a=2884,s=1709}
{x=245,m=243,a=1847,s=640}
{x=1371,m=190,a=115,s=871}
{x=570,m=238,a=227,s=11}
{x=941,m=463,a=288,s=1476}
{x=1588,m=1008,a=510,s=877}
{x=829,m=124,a=1825,s=208}
{x=1321,m=1388,a=887,s=686}
{x=2156,m=393,a=1058,s=1181}
{x=1100,m=264,a=805,s=39}
{x=366,m=17,a=3016,s=2511}
{x=802,m=2050,a=3,s=2616}
{x=1259,m=603,a=1388,s=987}
{x=2044,m=1204,a=239,s=272}
{x=410,m=675,a=8,s=1050}
{x=841,m=927,a=538,s=47}
{x=1940,m=1050,a=1038,s=2349}
{x=1862,m=506,a=2416,s=202}
{x=1563,m=89,a=3111,s=3049}
{x=274,m=356,a=714,s=2077}
{x=158,m=1288,a=191,s=1151}
{x=1681,m=2576,a=45,s=1645}
{x=475,m=341,a=122,s=286}
{x=734,m=1834,a=516,s=1442}
{x=3645,m=996,a=1290,s=1}
{x=598,m=517,a=26,s=1398}
{x=1171,m=46,a=3459,s=1414}
{x=1124,m=1512,a=2858,s=2184}
{x=1665,m=1981,a=91,s=704}
{x=137,m=1939,a=13,s=309}
{x=1360,m=1024,a=30,s=1189}
{x=1202,m=714,a=328,s=1464}
{x=596,m=936,a=744,s=1127}
{x=692,m=387,a=922,s=2153}
{x=507,m=358,a=1035,s=1638}
{x=319,m=308,a=497,s=727}
{x=3,m=696,a=584,s=490}
{x=1862,m=1218,a=479,s=501}
{x=123,m=63,a=2680,s=2399}
{x=1418,m=517,a=285,s=938}
{x=353,m=1911,a=1486,s=3352}
{x=41,m=30,a=186,s=451}
{x=2749,m=1252,a=3118,s=1685}
{x=456,m=2591,a=672,s=163}
{x=745,m=127,a=2789,s=168}
{x=11,m=2157,a=1552,s=839}
{x=1257,m=173,a=2737,s=446}
{x=224,m=1416,a=566,s=2659}
{x=740,m=54,a=517,s=1859}
{x=1051,m=1894,a=377,s=403}
{x=2224,m=1092,a=443,s=1312}
{x=91,m=1522,a=2392,s=1652}
{x=295,m=1195,a=1097,s=1246}
{x=291,m=153,a=1448,s=318}
{x=3109,m=1365,a=1098,s=743}
{x=40,m=1826,a=2056,s=832}
{x=921,m=3133,a=76,s=1073}
{x=2735,m=658,a=1892,s=2183}
{x=259,m=1473,a=130,s=2}
{x=108,m=2233,a=128,s=1270}
{x=1830,m=609,a=1624,s=873}
{x=50,m=385,a=12,s=251}
{x=399,m=2729,a=70,s=152}
{x=2640,m=745,a=1067,s=2960}
{x=188,m=466,a=1589,s=804}
{x=392,m=236,a=974,s=2101}
{x=100,m=219,a=1403,s=1974}
{x=848,m=1422,a=402,s=907}
{x=410,m=140,a=751,s=224}
{x=1671,m=2152,a=1952,s=2494}
{x=836,m=245,a=104,s=1966}
{x=891,m=45,a=1887,s=638}
{x=878,m=2420,a=57,s=735}
{x=1043,m=36,a=450,s=94}
{x=2749,m=1719,a=1686,s=982}
{x=919,m=27,a=2875,s=760}
{x=2122,m=1117,a=73,s=865}
{x=2500,m=1082,a=2055,s=1518}
{x=166,m=324,a=666,s=12}
{x=765,m=1393,a=3034,s=623}
{x=823,m=262,a=717,s=84}
{x=435,m=2004,a=1258,s=219}
{x=608,m=1011,a=346,s=1862}
{x=723,m=2675,a=842,s=123}
{x=564,m=1473,a=1326,s=2494}
{x=18,m=1262,a=886,s=16}
{x=90,m=1114,a=261,s=152}
{x=1238,m=59,a=2748,s=1056}
{x=1878,m=446,a=1727,s=1213}
{x=1149,m=704,a=119,s=1131}
{x=2257,m=238,a=620,s=3483}
{x=4,m=1454,a=1037,s=492}
{x=274,m=195,a=2975,s=506}
{x=9,m=139,a=220,s=518}
{x=1867,m=2281,a=1511,s=449}
{x=206,m=31,a=2373,s=69}
{x=2928,m=1302,a=193,s=179}
{x=154,m=1330,a=682,s=103}
{x=987,m=12,a=1436,s=90}
{x=42,m=1505,a=55,s=40}
{x=334,m=251,a=2397,s=2604}
{x=969,m=955,a=532,s=666}
{x=1262,m=504,a=1462,s=913}
{x=956,m=289,a=54,s=2957}
{x=1331,m=577,a=454,s=924}
{x=1811,m=409,a=31,s=1283}
{x=94,m=77,a=763,s=1198}
{x=3035,m=2503,a=3456,s=2016}
{x=755,m=1512,a=705,s=1673}
{x=1782,m=2409,a=2654,s=811}
{x=53,m=1605,a=610,s=1289}
{x=1812,m=2328,a=795,s=1950}
{x=1645,m=3593,a=601,s=1416}
{x=1461,m=919,a=917,s=1847}
{x=1398,m=1173,a=287,s=1094}
{x=1087,m=11,a=593,s=929}
{x=2961,m=682,a=1362,s=2424}
{x=1082,m=986,a=160,s=35}
{x=118,m=1017,a=1878,s=787}
{x=1272,m=360,a=3210,s=545}
{x=158,m=90,a=777,s=599}
{x=1740,m=367,a=177,s=513}
{x=46,m=1875,a=2976,s=54}
{x=1162,m=498,a=14,s=75}
{x=22,m=969,a=532,s=711}
{x=1756,m=805,a=3625,s=1804}
{x=50,m=1153,a=2356,s=484}
{x=2376,m=498,a=1035,s=1596}
{x=2493,m=2892,a=41,s=591}
{x=1166,m=859,a=680,s=481}
{x=129,m=2580,a=193,s=995}
{x=113,m=844,a=1070,s=1419}
{x=616,m=395,a=852,s=2865}
{x=2,m=497,a=395,s=2651}
{x=2975,m=3786,a=488,s=1472}
{x=253,m=385,a=568,s=1025}
{x=710,m=176,a=1736,s=191}
{x=124,m=985,a=509,s=368}
{x=2205,m=86,a=2846,s=1277}
{x=2279,m=388,a=13,s=458}
{x=199,m=281,a=3154,s=2316}
{x=1638,m=724,a=155,s=2575}
{x=1080,m=215,a=364,s=86}
{x=845,m=393,a=1126,s=845}
{x=3141,m=339,a=375,s=1122}
{x=26,m=841,a=2851,s=177}
{x=1504,m=585,a=212,s=1622}
{x=1003,m=1783,a=104,s=228}
{x=3159,m=651,a=11,s=2004}
{x=19,m=2002,a=538,s=457}
{x=791,m=3334,a=336,s=363}
{x=1455,m=608,a=2780,s=2278}
{x=754,m=869,a=815,s=2142}
{x=2442,m=838,a=1722,s=158}
{x=1,m=884,a=2237,s=673}
