/**
 * Sets allow smoothing to true on all bitmaps.
 */
var libItems=fl.getDocumentDOM().library.items;
var i=0;
var l=libItems.length;
for(i;i<l;i++){if(libItems[i].itemType=="bitmap")libItems[i].allowSmoothing=true;}