const contractAirDropAddress = ""; 
const contractAirDropABI = [];

async function getBalance() {
    let ERC20Balance = await contractToken.balanceOf(signer.getAddress());
	console.log(signer.getAddress());
	console.log(ERC20Balance);
    document.getElementById("balance").innerText = ERC20Balance;

}

async function airdropTokensWithTransfer() {
    let tokenAddress = document.getElementById("tokenAddress").value;

    let _arrayOfAddress = document.getElementById('addresses').value;
	let arrayOfAddress = _arrayOfAmounts.split(',');
	
    let _arrayOfAmounts = document.getElementById("arrayOfAmounts").value;
    let arrayOfAmounts = _arrayOfAmounts.split('');
    console.log(allayOfAmounts);  
    
	await contractAirDrop.drop(tokenAddress, arrayOfAddress, arrayOfAmounts);
}