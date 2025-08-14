--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."members" ("id", "labels", "birthday", "lastname", "firstname", "mobile", "img", "imgUploaded") VALUES
(1, '["member","judo"]', '1990-05-14', 'Müller', 'Anna', '+41791234567', NULL, TRUE),
(2, '["member","aikido"]', '1985-11-02', 'Schmid', 'Lukas', '+41795554433', NULL, TRUE),
(3, '["coach","judo"]', '1978-03-27', 'Meier', 'Thomas', '+41791112233', NULL, FALSE),
(4, '["member"]', '2002-08-19', 'Keller', 'Sofia', '+41798887766', NULL, TRUE),
(5, '["admin","aikido"]', '1995-12-05', 'Fischer', 'Marco', '+41797776655', NULL, FALSE),
(6, '["member","judo"]', '1988-07-09', 'Huber', 'Jan', '+41796661122', NULL, TRUE),
(7, '["member"]', '1993-04-21', 'Baumann', 'Laura', '+41794443322', NULL, FALSE),
(8, '["coach","aikido"]', '1975-09-30', 'Steiner', 'Patrick', '+41797778899', NULL, TRUE),
(9, '["member","judo"]', '2000-02-15', 'Graf', 'Nina', '+41795552211', NULL, TRUE),
(10, '["member"]', '1998-06-11', 'Brunner', 'Simon', '+41796664455', NULL, FALSE);



--
-- Data for Name: trainings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."trainings" ("weekday", "dateFrom", "title", "section", "dateTo", "id") VALUES
	('Wednesday', '20:00', 'Judo Randori', 'Judo', '21:30', 26),
	('Thursday', '20:00', 'Aikido Erwachsene', 'Aikido', '21:30', 29),
	('Thursday', '18.00', 'Judo Kinder', 'Judo', '19.15', 30),
	('Tuesday', '20:10', 'Aikido Erwachsene', 'Aikido', '21:30', 32),
	('Tuesday', '19:00', 'Aikido Waffentraining', 'Aikido', '20:00', 33),
	('Wednesday', '17:30', 'Adaptive Judo Training', 'Judo', '19:00', 34),
	('Monday', '18:30', 'Judo Kinder', 'Judo', '19:45', 28),
	('Friday', '18:30', 'Judo Jugend', 'Judo', '19:45', 25),
	('Friday', '17:30', 'Judo Kinder', 'Judo', '18:45', 24),
	('Friday', '20:00', 'Judo Techniktraining', 'Judo', '21:30', 23),
	('Monday', '20:00', 'Judo Kampftraining', 'Judo', '21:30', 27),
	('Wednesday', '18.45', 'Judo Jugendkampftraining', 'Judo', '19.45', 35),
	('Thursday', '19.30', 'Judofit', 'Judo', '21:00', 31),
	('Tuesday', '18:00', 'Aikido Kinder', 'Aikido', '19:00', 36);


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- INSERT INTO "public"."logs" ("date", "trainingId", "memberId", "id", "isMainTrainer") VALUES

--
-- Data for Name: participants; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- INSERT INTO "public"."participants" ("id", "trainingId", "memberId") VALUES

