<script context="module" lang="ts">
  export type Item = { name: string; data?: any };
  export type GetDataFunction = (text: string) => Promise<Item[]>;
</script>

<script lang="ts">
  import { menu } from '@skeletonlabs/skeleton';
  import AutocompleteBoxItem from './AutocompleteBoxItem.svelte';
  import { createEventDispatcher } from 'svelte';

  export let getData: GetDataFunction = async (t) => {
    return [];
  };
  export let placeholder: string = 'Search';
  export let defaultItemText: string | null = null;

  let filteredData: Item[] = [];

  const filterData = async () => {
    let storageArr: Item[] = [];
    if (inputValue) {
      const res = await getData(inputValue);
      res.forEach((item) => {
        if (item.name.toLowerCase().startsWith(inputValue.toLowerCase())) {
          item.name = makeMatchBold(item.name);
          storageArr = [...storageArr, item];
        }
      });
      if (defaultItemText) {
        storageArr = [...storageArr, { name: defaultItemText }];
      }
    }
    filteredData = storageArr;
  };

  let inputValue = '';

  $: if (!inputValue) {
    filteredData = [];
    hiLiteIndex = -1;
  }

  const clearInput = () => {
    inputValue = '';
  };

  const dispatch = createEventDispatcher();
  const setInputVal = (item: Item) => {
    inputValue = removeBold(item.name);
    filteredData = [];
    hiLiteIndex = -1;
    dispatch('change', item);
    clearInput();
  };

  const makeMatchBold = (str: string) => {
    let matched = str.substring(0, inputValue.length);
    let makeBold = `<strong>${matched}</strong>`;
    let boldedMatch = str.replace(matched, makeBold);
    return boldedMatch;
  };

  const removeBold = (str: string) => {
    return str.replace(/<(.)*?>/g, '');
  };

  let hiLiteIndex: number = -1;

  const navigateList = (e: { key: string }) => {
    if (e.key === 'ArrowDown' && hiLiteIndex <= filteredData.length - 1) {
      hiLiteIndex === filteredData.length - 1 ? (hiLiteIndex = 0) : (hiLiteIndex += 1);
    } else if (e.key === 'ArrowUp' && hiLiteIndex !== -1) {
      hiLiteIndex === 0 ? (hiLiteIndex = filteredData.length - 1) : (hiLiteIndex -= 1);
    } else if (e.key === 'Enter') {
      setInputVal(filteredData[hiLiteIndex]);
    } else {
      return;
    }
  };
</script>

<svelte:window on:keydown={navigateList} />

<input
  type="text"
  {placeholder}
  bind:value={inputValue}
  on:input={filterData}
  use:menu={{ menu: 'itemlist' }}
/>

<div data-menu="itemlist">
  {#if filteredData.length > 0}
    <ul>
      {#each filteredData as item, i}
        <AutocompleteBoxItem
          itemLabel={item.name}
          highlighted={i === hiLiteIndex}
          on:click={() => setInputVal(item)}
        />
      {/each}
    </ul>
  {/if}
</div>
