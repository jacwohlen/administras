import { db } from '$lib/firebase';
import type { PageLoad } from './$types';
import { getDoc, setDoc, doc, DocumentReference } from 'firebase/firestore';
import type { Training, Log, Member } from '$lib/models';
import type { MMember } from './types';
import { supabaseClient } from '$lib/supabase';
import { error as err } from '@sveltejs/kit';

export const load = (async ({ params, parent }) => {
  async function getLoggedMembers(): Promise<Member[]> {
    const { error, data } = await supabaseClient
      .from('logs')
      .select(`members (*)`)
      .eq('trainingId', params.trainingId)
      .eq('date', params.date)
      .maybeSingle<Log>();

    if (error) {
      throw err(404, error);
    }
    if (!data) {
      return [];
    }
    console.log('hihi');
    console.log(data);
    return data.members;
    // TODO : HERE WE ARE
  }

  const loggedMembers = await getLoggedMembers();

  const parentData = (await parent()) as Training;
  const trainingParticipants = parentData.participants;
  const participantsWithPresentStatus: MMember[] = trainingParticipants.map(
    (p) =>
      ({
        ...p,
        isPresent: false
      } as MMember)
  );

  console.log(loggedMembers);
  console.log(participantsWithPresentStatus);

  // Mark Present Members
  loggedMembers.forEach((pMember) => {
    const foundIndex = participantsWithPresentStatus.findIndex((p) => p.id === pMember?.id);
    if (foundIndex !== -1) {
      participantsWithPresentStatus[foundIndex].isPresent = true;
    } else {
      participantsWithPresentStatus.push({ ...pMember, isPresent: true } as MMember);
    }
  });

  // participantsWithPresentStatus.sort((a, b) => {
  //   if (a.lastname === b.lastname) {
  //     return a.firstname.localeCompare(b.firstname);
  //   } else {
  //     return a.lastname.localeCompare(b.lastname);
  //   }
  // });

  console.log('AHAH');
  console.log(participantsWithPresentStatus);

  return {
    trainingId: params.trainingId,
    date: params.date,
    participants: participantsWithPresentStatus
  };
}) satisfies PageLoad;
