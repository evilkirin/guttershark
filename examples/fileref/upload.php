<?
	if(!isset($_FILES['Filedata']))
	{
		echo "No file";
		die();
	}
	$filename=$_FILES['Filedata']['name'];
	$temp_name=$_FILES['Filedata']['tmp_name'];
	$error=$_FILES['Filedata']['error'];
	$size=$_FILES['Filedata']['size'];
	if(!$error)copy($temp_name,'uploads/'.$filename);
	echo $_FILES['Filedata']['name']; #echoing something is required to get the flash player to correctly trigger the Event.COMPLETE event from a FileReference. It doesn't matter what's echo'd
?>