const ctx = document.getElementById('speedChart').getContext('2d');
const speedChart = new Chart(ctx, {
  type: 'line',
  data: {
    labels: [],
    datasets: [{
      label: 'Power',
      data: [],
      borderColor: 'rgba(75, 192, 192, 1)',
      borderWidth: 1,
      fill: false
    }]
  },
  options: {
    scales: {
      x: {
        type: 'time',
        time: {
          unit: 'second'
        }
      },
      y: {
        beginAtZero: true
      }
    }
  }
});

async function fetchData() {
  const response = await fetch('http://localhost:10000/data');
  const data = await response.json();
  if (data.length > 0) {
    const { power, timestamp } = data[0];
    speedChart.data.labels.push(new Date(timestamp));
    speedChart.data.datasets[0].data.push(power);
    speedChart.update();
  }
}
setInterval(fetchData, 5000); // Fetch data every 5 second


