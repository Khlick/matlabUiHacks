// Collect browser information from Navigator
// insert into table on DOM. for
// const nodeID = %s;
function buildRow(name,value){
  //function builds a tr (table row) node
  var tRow = document.createElement('tr');
  var Lcol = document.createElement('td');
  var Rcol = document.createElement('td');
  Lcol.innerHTML = name;
  Rcol.innerHTML = value;
  tRow.appendChild(Lcol);
  tRow.appendChild(Rcol);
  return tRow;
}

// use navigator to grab some browser info
var nav = window.navigator;

// create a table
var tab = document.createElement('table');
tab.classList.add('pure-table');

// build each row from the navigator object
let trElement
for(key in nav){
  trElement = buildRow(key,nav[key]);
  tab.appendChild(trElement);
}

// get matlab uielement dom and remove all inner nodes
var matlabUI = document.querySelectorAll(nodeID)[0];
while (matlabUI.firstChild) {
    matlabUI.removeChild(matlabUI.lastChild);
}

// add our table to the uielement
matlabUI.appendChild(tab);
