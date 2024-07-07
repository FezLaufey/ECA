async function fetchAvgPower() {
    const response = await fetch('http://localhost:10000/dataavg');
    const data = await response.json();
    return data.avgPower;
}

async function fetchEstimatedCost() {
    const response = await fetch('http://localhost:10000/edataavg');
    const data = await response.json();
    return data.avgPower;
}

document.getElementById('saveDeviceButton').addEventListener('click', async () => {
    const deviceName = document.getElementById('deviceName').value;
    if (!deviceName) {
        alert('Please enter a device name');
        return;
    }

    try {
        const avgPower = await fetchAvgPower();
        const estimatedCost = await fetchEstimatedCost();

        const response = await fetch('http://localhost:10000/saveDevice', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                dname: deviceName,
                avgPower: avgPower,
                estimatedCost: estimatedCost
            })
        });

        if (response.ok) {
            alert('Device data saved successfully');
        } else {
            alert('Error saving device data');
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error saving device data');
    }
});