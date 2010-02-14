require "fileutils"
asfiles=File.join("./src/as/**","*.as")
d=Dir.glob(asfiles)
final_out="~/dev/flex3sdk/bin/compc "
final_out << "-sp ~/dev/_projects/_git/guttershark/src/as/ "
final_out << "-sp ~/dev/codelibs/as/externals/ "
final_out << "-sp '/Applications/Adobe CS3/Adobe Flash CS3/Configuration/ActionScript 3.0/Classes' "
final_out << "-sp '/Applications/Adobe CS3/Adobe Flash CS3/Configuration/Component Source/ActionScript 3.0/FLVPlayback' "
final_out << "-sp '/Applications/Adobe CS3/Adobe Flash CS3/Configuration/Component Source/ActionScript 3.0/User Interface' "
final_out << "-directory=true -o ./bin/tmplib/ "
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
#puts final_out
final_out << " -compute-digest=false"
system(final_out)
FileUtils.mv("./bin/tmplib/library.swf","./bin/library.swf")
final_out = "~/dev/flex3sdk/bin/optimizer -keep-as3-metadata=\"Bindable,Managed,ChangeEvent,NonCommittingChangeEvent,Transient\" -input ./bin/library.swf -output ./bin/guttershark_#{ARGV[0]}.swf";
system(final_out)
FileUtils.remove_dir("./bin/tmplib",true)
FileUtils.rm("./bin/library.swf")