import "application"
import "chart.js"

function createRatingDistributionGraph(){
    const range = 100
    const graphName1 = $('#ratingDistributionChart').data('date1');
    const ratings1 = $('#ratingDistributionChart').data('ratings1');
    ratings1.sort(function(a, b){return a-b});; // [0, 0, ... 2500]
    const graphName2 = $('#ratingDistributionChart').data('date2');
    const ratings2 = $('#ratingDistributionChart').data('ratings2');
    ratings2.sort(function(a, b){return a-b});; // [0, 0, ... 2500]

    const maxRating = Math.max(ratings1[ratings1.length-1], ratings2[ratings2.length-1])
    const dataLength = Math.floor(maxRating / range) + 2
    const labels = new Array(dataLength)
    for(let i=0;i<dataLength;i++){
        labels[i] = i * range
    }

    const dataList1 = new Array(dataLength).fill(0) // [1~range, range+1~2*range, ... range*i+1~range*(i+1)], ignore 0
    for(let i=0;i<ratings1.length;i++){
        const r = ratings1[i];
        if(r == 0){
            continue
        }
        const a = Math.floor(r / range)
        dataList1[a] += 1
    }
    const dataList2 = new Array(dataLength).fill(0) // [1~range, range+1~2*range, ... range*i+1~range*(i+1)], ignore 0
    for(let i=0;i<ratings2.length;i++){
        const r = ratings2[i];
        if(r == 0){
            continue
        }
        const a = Math.floor(r / range)
        dataList2[a] += 1
    }

    const skipped = (ctx, value) => ctx.p0.skip || ctx.p1.skip ? value : undefined;
    const data = {
      labels: labels,
      datasets: [
        {
            label: graphName1,
            data: dataList1,
            segment: {
              borderColor: ctx => skipped(ctx, 'rgb(0,0,0,0.2)'),
              borderDash: ctx => skipped(ctx, [6, 6]),
            },
            fill: false,
            borderColor: 'rgb(75, 192, 192)',
            backgroundColor: 'rgb(75, 192, 192)',
            tension: 0.1
        },
        {
            label: graphName2,
            data: dataList2,
            segment: {
              borderColor: ctx => skipped(ctx, 'rgb(0,0,0,0.2)'),
              borderDash: ctx => skipped(ctx, [6, 6]),
            },
            fill: false,
            borderColor: 'rgb(192, 75, 75)',
            backgroundColor: 'rgb(192, 75, 75)',
            tension: 0.1
        },
    ]
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