import type { Member } from '$lib/models';

export interface MMember extends Member {
  isPresent: boolean;
}
