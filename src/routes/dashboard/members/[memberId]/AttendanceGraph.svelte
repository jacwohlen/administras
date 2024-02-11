<script lang="ts">
  import dayjs, { type Dayjs } from 'dayjs';
  import SvelteHeatmap from 'svelte-heatmap';
  import type { Log } from '$lib/models';

  export let logs: Promise<Log[]>;
  export let year: number;

  let startDate: Dayjs = dayjs().subtract(5, 'months');
  let endDate: Dayjs = dayjs();

  let isWideScreen = true; // Assume a wide screen by default

  interface HeatmapData {
    date: Date;
    value: any;
  }

  function convertLogsToHeatmapData(data: Log[]): HeatmapData[] {
    let dateMap = new Map<string, HeatmapData>();

    data.forEach((e: Log) => {
      const dateKey = dayjs(e.date).format('YYYY-MM-DD'); // Convert date to string key
      if (dateMap.has(dateKey)) {
        // If the date already exists, increase its value
        let heatMapData = dateMap.get(dateKey)!;
        heatMapData.value += 1;
        dateMap.set(dateKey, heatMapData);
      } else {
        // If the date does not exist, add it with value 1
        dateMap.set(dateKey, { date: dayjs(e.date).toDate(), value: 1 });
      }
    });

    // Convert the map values back to an array
    return Array.from(dateMap.values());
  }

  function setDatesToView(y: number) {
    startDate = dayjs().year(y).startOf('year');
    endDate = dayjs().year(y).endOf('year');

    if (!isWideScreen) {
      let now: Dayjs = dayjs();
      if (now.year() == year) {
        if (now.isAfter(startDate.add(5, 'months'))) {
          startDate = now.subtract(5, 'months');
          endDate = now;
        } else {
          endDate = startDate.add(5, 'months');
        }
      } else {
        startDate = endDate.subtract(5, 'months');
      }
    }
  }

  function checkViewportWidth() {
    // This example checks for viewport width of 768 pixels
    isWideScreen =
      window.matchMedia('(min-width: 768px)').matches ||
      window.matchMedia('(orientation: landscape)').matches;

    setDatesToView(year);
  }

  onMount(() => {
    checkViewportWidth(); // Check once when the component mounts

    // Listen for changes in viewport size
    window.addEventListener('resize', checkViewportWidth);

    return () => {
      // Remove the event listener when the component is destroyed
      window.removeEventListener('resize', checkViewportWidth);
    };
  });

  $: setDatesToView(year);
</script>

{#await logs}
  <SvelteHeatmap
    data={[]}
    endDate={endDate.toDate()}
    startDate={startDate.toDate()}
    view={'yearly'}
  />
{:then l}
  <SvelteHeatmap
    data={convertLogsToHeatmapData(l)}
    endDate={endDate.toDate()}
    startDate={startDate.toDate()}
    view={'yearly'}
  />
{:catch err}
  {err}
{/await}
