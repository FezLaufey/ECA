async function fetchDevices() {
    const response = await fetch('/devices');
    const devices = await response.json();
    const device1Dropdown = document.getElementById('device1');
    const device2Dropdown = document.getElementById('device2');
    const deleteDeviceDropdown = document.getElementById('deleteDevice');

    // Clear existing options
    device1Dropdown.innerHTML = '';
    device2Dropdown.innerHTML = '';
    deleteDeviceDropdown.innerHTML = '';

    devices.forEach(device => {
        const option1 = document.createElement('option');
        option1.value = device.id;
        option1.text = device.dname;
        device1Dropdown.add(option1);

        const option2 = document.createElement('option');
        option2.value = device.id;
        option2.text = device.dname;
        device2Dropdown.add(option2);

        const deleteOption = document.createElement('option');
        deleteOption.value = device.id;
        deleteOption.text = device.dname;
        deleteDeviceDropdown.add(deleteOption);
    });
}

async function fetchDeviceData(id) {
    const response = await fetch(`/device/${id}`);
    const data = await response.json();
    return data;
}

async function deleteDevice(id) {
    const response = await fetch(`/device/${id}`, {
        method: 'DELETE',
    });
    return response;
}

document.getElementById('compareButton').addEventListener('click', async () => {
    const device1Id = document.getElementById('device1').value;
    const device2Id = document.getElementById('device2').value;

    if (!device1Id || !device2Id) {
        alert('Please select both devices to compare.');
        return;
    }

    const device1Data = await fetchDeviceData(device1Id);
    const device2Data = await fetchDeviceData(device2Id);

    const comparisonResult = document.getElementById('comparisonResult');
    comparisonResult.innerHTML = `
        <table>
            <thead>
                <tr>
                    <th>Device</th>
                    <th>Average Power (kW)</th>
                    <th>Estimated Cost (24H)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>${device1Data.dname}</td>
                    <td>${device1Data.avg_power}</td>
                    <td>RM${device1Data.estimated_cost}</td>
                </tr>
                <tr>
                    <td>${device2Data.dname}</td>
                    <td>${device2Data.avg_power}</td>
                    <td>RM${device2Data.estimated_cost}</td>
                </tr>
                <tr>
                    <td colspan="2">Cost Difference</td>
                    <td>RM${Math.abs(device1Data.estimated_cost - device2Data.estimated_cost).toFixed(2)}</td>
                </tr>
            </tbody>
        </table>
    `;
});

document.getElementById('deleteButton').addEventListener('click', async () => {
    const deleteDeviceId = document.getElementById('deleteDevice').value;
    const confirmation = confirm('It will clear the chosen device data, are you sure?');

    if (!deleteDeviceId) {
        alert('Please select a device to delete.');
        return;
    }
    if (confirmation) {
        try {
            const response = await deleteDevice(deleteDeviceId);
            if (response.ok) {
                alert('Device deleted successfully.');
                location.reload(); // Reload the page after successful deletion
            } else {
                alert('Failed to delete device.')
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Error deleting records');
        }
    }
});

fetchDevices();

let myChart;

async function fetchData() {
    const response = await fetch('/chart');
    const data = await response.json();
    const labels = data.map(item => item.dname);
    const values = data.map(item => item.estimated_cost);

    const ctx = document.getElementById('myChart').getContext('2d');
    myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Estimated Cost (RM)',
                data: values,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            plugins: {
                datalabels: {
                    anchor: 'end',
                    align: 'top',
                    formatter: (value) => `RM ${value}`,
                    color: 'black',
                    font: {
                        weight: 'bold'
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        },
        plugins: [ChartDataLabels]
    });
}

document.getElementById('downloadBtn').addEventListener('click', function() {
    if (myChart) {
        const a = document.createElement('a');
        a.href = myChart.toBase64Image();
        a.download = 'chart.png';
        a.click();
    } else {
        console.error('Chart is not initialized yet.');
    }
});

fetchData();
