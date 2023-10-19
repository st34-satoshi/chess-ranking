import "application"
import "chart.js"

function createRatingDistributionGraph(){
    const range = 100
    let ratings = $('#ratingDistributionChart').data('ratings');
    ratings.sort(function(a, b){return a-b});; // [0, 0, ... 2500]

    const maxRating = ratings[ratings.length-1]
    const dataLength = Math.floor(maxRating / range) + 2
    let dataList = new Array(dataLength).fill(0) // [1~range, range+1~2*range, ... range*i+1~range*(i+1)], ignore 0
    for(let i=0;i<ratings.length;i++){
        const r = ratings[i];
        if(r == 0){
            continue
        }
        const a = Math.floor(r / range)
        dataList[a] += 1
    }

    const labels = new Array(dataLength)
    for(let i=0;i<dataLength;i++){
        labels[i] = i * range
    }
    const skipped = (ctx, value) => ctx.p0.skip || ctx.p1.skip ? value : undefined;
    const data = {
      labels: labels,
      datasets: [{
        label: 'My First Dataset',
        data: dataList,
        segment: {
          borderColor: ctx => skipped(ctx, 'rgb(0,0,0,0.2)'),
          borderDash: ctx => skipped(ctx, [6, 6]),
        },
        fill: false,
        borderColor: 'rgb(75, 192, 192)',
        tension: 0.1
      }]
    };

    const config = {
      type: 'line',
      data,
      options: {
        scales: {
          y: {
            reverse: false,
            axis: 'r'
          }
        }
      }
    };

    const ratingDistributionChart = new Chart(
      document.getElementById('ratingDistributionChart'),
      config
    );
}

$(function() {
    createRatingDistributionGraph()
});