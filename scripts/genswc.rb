asfiles=File.join("./src/as/**","*.as")
d=Dir.glob(asfiles)
final_out="~/dev/flex3sdk/bin/compc "
final_out << "-sp ~/dev/_projects/_git/guttershark/src/as/ "
final_out << "-sp ~/dev/codelibs/as/externals/ "
final_out << "-sp '/Applications/Adobe CS3/Adobe Flash CS3/Configuration/ActionScript 3.0/Classes' "
final_out << "-sp '/Applications/Adobe CS3/Adobe Flash CS3/Configuration/Component Source/ActionScript 3.0/FLVPlayback' "
final_out << "-sp '/Applications/Adobe CS3/Adobe Flash CS3/Configuration/Component Source/ActionScript 3.0/User Interface' "
final_out << "-o ./bin/guttershark_#{ARGV[0]}.swc "
final_out << "-ic "
d.each do |dir|
  if(dir.match(/support/)) then next end;
  if(dir.match(/akamai/)) then next end;
  s=dir.split("/").join(".")
  j=s.split(".")
  j.pop()
  s=j.join(".")
  s.sub!("..src.as.","")
  final_out << "#{s} "
end
#final_out << "-optimize"
#final_out << " -directory"
#final_out << " -debug=false"
final_out << " -compute-digest=true"
final_out << " -include-lookup-only=true"
final_out << " -verify-digests=true"
system(final_out)