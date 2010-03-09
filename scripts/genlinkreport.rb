asfiles=File.join("./src/as/**","*.as")
d=Dir.glob(asfiles)
final_out="~/Development/lib/flex3sdk/bin/compc "
final_out << "-sp ~/Development/git/guttershark/src/as/ "
final_out << "-sp ~/Development/lib/actionscript/externals/ "
final_out << "-external-library-path '/Applications/Adobe Flash CS4/Common/Configuration/ActionScript 3.0/FP10/playerglobal.swc' "
final_out << "-sp '/Applications/Adobe Flash CS4/Common/Configuration/Component Source/Actionscript 3.0/FLVPlayback/' "
final_out << "-sp '/Applications/Adobe Flash CS4/Common/Configuration/Component Source/Actionscript 3.0/FLVPlaybackCaptioning/' "
#final_out << "-sp '/Applications/Adobe Flash CS4/Common/Configuration/Component Source/Actionscript 3.0/User Interface/' "
final_out << "-link-report libs/report.xml "
final_out << "-o libs/guttershark.swc "
final_out << "-ic "
d.each do |dir|
  s=dir.split("/").join(".")
  j=s.split(".")
  j.pop()
  s=j.join(".")
  s.sub!("..src.as.","")
  final_out << "#{s} "
end
final_out << " -optimize"
final_out << " -debug=false"
final_out << " -compute-digest=true"
final_out << " -include-lookup-only=true"
final_out << " -verify-digests=true"
system(final_out)