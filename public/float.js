async function fetchPower() {
    try {
        const response = await fetch('http://localhost:10000/dataavg');
        const data = await response.json();
        if (data.avgPower) {
            document.querySelector('.item-1').textContent = `Average Consumption: ${data.avgPower} W`;
        } else {
            document.querySelector('.item-1').textContent = 'Error fetching POWER';
        }
    } catch (error) {
        document.querySelector('.item-1').textContent = 'Error fetching POWER';
        console.error('Error:', error);
    }
}
setInterval(fetchPower, 5000); // Fetch data every second


async function fetchestimatedcost(){
    try {
        const response = await fetch('http://localhost:10000/dataavg');
        const data = await response.json();
        if (data.avgPower) {
            const cost = (data.avgPower/1000  * 24 * 21.8 /100).toFixed(2); // Ensure cost is formatted to 2 decimal places
            document.querySelector('.item-2').textContent = `Estimated cost per day(24H): RM${cost}`;
        } else {
            document.querySelector('.item-2').textContent = 'Error fetching POWER';
        }
    } catch (error) {
        document.querySelector('.item-2').textContent = 'Error fetching POWER';
        console.error('Error:', error);
    }

}
setInterval(fetchestimatedcost, 5000); // Fetch data every second