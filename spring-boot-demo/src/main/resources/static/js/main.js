
function getAndUpdate(){
    tit = document.getElementById('title').value;
    desc = document.getElementById('description').value;
    if (localStorage.getItem('itemsJson') == null) {
        itemJsonArray = [];
        itemJsonArray.push([tit, desc]);
        localStorage.setItem('itemsJson', JSON.stringify(itemJsonArray));
    }
    else {
        itemJsonArrayStr = localStorage.getItem('itemsJson');
        itemJsonArray = JSON.parse(itemJsonArrayStr);
        itemJsonArray.push([tit, desc]);
        localStorage.setItem('itemsJson', JSON.stringify(itemJsonArray));
    }
    update();
}
function update(){
    if (localStorage.getItem('itemsJson') == null) {
        itemJsonArray = [];
        localStorage.setItem('itemsJson', JSON.stringify(itemJsonArray));
    }
    else {
        itemJsonArrayStr = localStorage.getItem('itemsJson');
        itemJsonArray = JSON.parse(itemJsonArrayStr);
    }
    
    //populate table
    let tablebody=document.getElementById("tablebody");
    let str="";
    itemJsonArray.forEach((element,index) => {
        str+=`
        <tr>
                    <th scope="row">${index+1}</th>
                    <td>${element[0]}</td>
                    <td>${element[1]}</td>
                    <td><button class="btn btn-sm btn-primary" onclick="deleted(${index})">Delete</button></td>
                  </tr>`
        
    });
    tablebody.innerHTML=str;
}
add = document.getElementById('add');
add.addEventListener('click', getAndUpdate);
update();

function deleted(itemIndex){
    itemJsonArrayStr = localStorage.getItem('itemsJson');
    itemJsonArray = JSON.parse(itemJsonArrayStr);
    //delete item from the array
    itemJsonArray.splice(itemIndex,1);
    localStorage.setItem('itemsJson', JSON.stringify(itemJsonArray));
    update();
}
function clearStorage(){
    let conf=confirm("do you really want clear entire list?")
    if(conf){
        localStorage.clear();
    update();
    }
    
}