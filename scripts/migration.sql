-- ============================================
-- Talent-IA Migration SQL (safe re-run: cleanup + insert)
-- Generated: 2026-02-13T20:19:31.019Z
-- Mode: FULL
-- ============================================

-- ========== CLEANUP ==========
DELETE FROM public.test_results WHERE user_id IN (SELECT id FROM auth.users WHERE email IN ('operacoes@buscarid.com', 'rodrigonormandia@buscarid.com', 'kaw@buscarid.com', 'jussara@buscarid.com', 'draflaviareumatobh@gmail.com', 'rodrigo@sabecomo.com.br', 'nicholsongp@gmail.com', 'andrewafonso@gmail.com', 'anie.karenina@buffalodigital.com.br', 'fernandojin@gmail.com', 'danielgaia13@gmail.com', 'filipejclopes@gmail.com', 'sura.carvalho@gmail.com', 'renatolopesevolve@gmail.com', 'leticia@maxupconsultoria.com.br', 'rbetasim@gmail.com', 'evalarissa157@gmail.com', 'lalacorrea@gmail.com', 'henriquehamerski@gmail.com', 'leodavidrotela91@gmail.com', 'maia.jpm@gmail.com', 'dayane@maxupconsultoria.com.br', 'christianobsr@gmail.com', 'andradegoval2013@gmail.com', 'maugustocand@gmail.com', 'raquel@albanezemaia.adv.br', 'francis@maxupconsultoria.com.br', 'admin@teste.com', 'carol@buscarid.com', 'rodrigo@buscarid.com', 'duponce.mcc@gmail.com', 'lukedepaulo@gmail.com', 'jessica.maia@fundacaocdlbh.org.br', 'guilherme@ctrl.cnt.br', 'renato_godinho@hotmail.com', 'augustoizac@gmail.con', 'alysson.guimaraes@cdlbh.com.br', 'emelygaspar@gmail.com', 'adrianoboscatte@gmail.com', 'luisa@cpbellaperfumes.com.br', 'gabriel.junqueira@avancoinfo.com.br', 'joas_pessoa@hotmail.com', 'marlucio.silva@fundacaocdlbh.org', 'brunarpn@gmail.com', 'debora.com.mkt@gmail.com', 'brenoduarte@hotmail.com', 'wadir@bellaboticario.com.br', 'joseangelo@bellaboticario.com.br', 'junioramerico@atsinformatica.com.br', 'ulissessamarone@gmail.com', 'carloseduardo.cacaushowbh@gmail.com', 'carloeduardo@gmail.com', 'joaovictor@cdlbh.com.br', 'analaraest@icloud.com', 'hitalocarvalho@gmail.com', 'anakarlamoraisg@gmail.com', 'isis.or.natural@gmail.com', 'aquilis.moreira@oktz.com.br', 'k.raquelferreira@gmail.com', 'gabrielvfalci@gmail.com', 'hellenmr87@yahoo.com.br', 'alexandresantos@smcit.com.br', 'faustocasabranca@gmail.com', 'camilarvalentim@gmail.com', 'nayaralcampos@gmail.com', 'vilson.mayrink@gmail.com', 'mflaviocs@gmail.com', 'leocamargo@yahoo.com', 'contato@uaiviajei.com.br', 'joel.souza@cdlbh.com.br', 'joseangelo.melo@cdlbh.com.br', 'rcheiricatti@gmail.com', 'breendon.almeida@gmail.com', 'flavioizac@gmail.com', 'bruno.sbraletta@gmail.com', 'hg.leticia@gmail.com', 'lucaspitta@targetfroras.com.br', 'ana.arrunategui@buffalodigital.com.br', 'ana.souza@buffalodigital.com.br', 'andy.monterei@buffalodigital.com.br', 'andre.doyle@buffalodigital.com.br', 'filippe.leite@buffalodigital.com.br', 'francis.willian@buffalodigital.com.br', 'jordana.ferreira@buffalodigital.com.br', 'larissa.soares@buffalodigital.com.br', 'lucas.vilasboas@buffalodigital.com.br', 'mayra.abeki@buffalodigital.com.br', 'patricia.oliveira@buffalodigital.com.br', 'rafael.guilherme@buffalodigital.com.br', 'samira.dias@buffalodigital.com.br', 'thais.barbian@buffalodigital.com.br', 'claudio.batitucci@partners360.com.br', 'analuisaarrunategui@gmail.com', 'clayton.lisboa@buffalodigital.com.br', 'bruno.henrique@repetreciclagem.com.br', 'np@healthsafetytech.com', 'alexsandrarmatos@gmail.com', 'alexa@etcetal.com.br', 'adm01@healthsafetytech.com', 'hylderosa@gmail.com', 'mayaradias.tur@gmail.com', 'digowars@gmail.com', 'daniel.gaia@varejaodastintas.com.br', 'aangrisano@gmail.com', 'test_with_password_1768589940269@example.com', 'test_without_password_1768589940874@example.com', 'rnrsouza@hotmail.com', 'kawbicalho@gmail.com', 'GABIDIASJ@GMAIL.COM', 'financeiro01@healthsafetytech.com', 'comercial01@healthsafetytech.com', 'qualidade01@healthsafetytech.com', 'servicos01@healthsafetytech.com', 'laboratorio01@healthsafetytech.com', 'expedicao01@healthsafetytech.com', 'ti@healthsafetytech.com', 'expedicao02@healthsafetytech.com', 'comercial02@healthsafetytech.com', 'ti02@healthsafetytech.com', 'comercial03@healthsafetytech.com', 'comercial04@healthsafetytech.com', 'qualidade02@healthsafetytech.com', 'servicos02@healthsafetytech.com', 'laboratorio02@healthsafetytech.com', 'expedicao03@healthsafetytech.com', 'suporte01@healthsafetytech.com', 'comercial05@healthsafetytech.com', 'suporte02@healthsafetytech.com', 'ti03@healthsafetytech.com', 'surama@etcetal.com.br', 'walbertsantos@gmail.com', 'sdr3@healthsafety.com.br', 'adriana_diana_oliveira@hotmail.com', 'gynunes62@gmail.com', 'djalmanetobeto@gmail.com', 'sandraa.cristina@hotmail.com', 'gopme12@gmail.com', 'weltonkellyson24@gmail.com', 'sdr1@healthsafety.com.br', 'gmswanderley@gmail.com', 'suelenpatricia957@gmail.com', 'rickelmepe@gmail.com', 'suelenpatricia957@gmai.com', 'ellenelis87@gmail.com', 'lucas.azevedo3009@gmail.com', 'leandroepronto3.1lvs@gmail.com', 'fabianodinizsantos@gmail.com', 'rgcaetanofujitsu@gmail.com', 'giancarlodalmulin@gmail.com', 'ronetju2019@gmail.com', 'valeria.educacional@gmail.com', 'dede_rangel@yahoo.com.br', 'renato.correa@oktz.com.br', 'institutoalupo@gmail.com', 'fabio.marfer@gmail.com', 'welintonsilva690@gmail.com', 'jrmagrafil@gmail.com', 'lua77@uol.com.br', 'Marcoamojr@gmail.com', 'julianacosta_15@hotmail.com', 'fernanda_arceno@hotmail.com', 'mauriciosilva1590@gmail.com', 'amiltonguedes2009@gmail.com', 'viniciusleal@ymail.com', 'gilberto.maranhao78@gmail.com', 'jocemarmartinscalado@gmail.com', 'ricardo.a.m.tomita@gmail.com', 'ljordaosilva@gmail.com', 'marpugliesi@gmail.com', 'pedro@reclick.com.br', 'fabmontsant@gmail.com', 'europalugares@gmail.com', 'gildevamjunior@hotmail.com', 'alexandre.diniz.cesar@gmail.com', 'gabrieladauer@gmail.com', 'claudenice_lem@hotmail.com', 'art3dstd@gmail.com', 'valdeirsantos891@gmail.com', 'ta.993810275@gmail.com', 'ruiterfidencio@gmail.com', 'eliemarbueno@gmail.com', 'andreiacbarreto@gmail.com', 'doromarra@hotmail.com', 'suelenribeiro@gestaomatriz.com.br', 'grodriguez@piattino.com.br', 'lcsxavier@hotmail.com', 'brunaarruda1712@gmail.com', 'maisahfm@gmail.com', 'gccotia.combate@gmail.com', 'jubettini@gmail.com', 'rmatoscarina@gmail.com', 'gkgloballink@gmail.com', 'mariaeduardabranco1991@gmail.com', 'jornalistapatriciateixeira@gmail.com', 'elisapj@hotmail.com', 'harmonia5x.mentorias@gmail.com', 'savanazamai@gmail.com', 'phabioliveira@gmail.com', 'frs8176@gmail.com', 'unapackembalagens@gmail.com', 'taisfaria1@gmail.com', 'ronetju@yahoo.com.br', 'lilianc21@yahoo.com', 'getulioairescorretorimoveis@gmail.com', 'kimberly_suellen@hotmail.com', 'giselleas@hotmail.com', 'maurina26mbk@gmail.com', 'helenafcr@gmail.com', 'alle-lima2011@hotmail.com', 'larissa21_assis@outlook.com', 'junioalmeida1994@gmail.com', 'turossizah@gmail.com', 'patriciaas.antao@gmail.com', 'rosellirozendo@gmail.com', 'juliane.vieira@claro.com.br', 'mariribeiro14071982@gmail.com', 'dennilsonjl@gmail.com', 'liliane.soberana@gmail.com', 'isaacgomesrdf@gmail.com', 'RODRIGOFERNANDESCONTABILIDADE@GMAIL.COM', 'carloscerbbinno@gmail.com', 'esmirnacv@yahoo.com.br', 'phaty17@gmail.com', 'marceloffranco@glook.com.br', 'ribeiroola@gmail.com', 'larissa.almeida@grupomultilaser.com.br', 'marcela@artesacramoda.com.br', 'milamreis@hotmail.com', 'rafaelfarreb@gmail.com', 'marcosdelnero.apps@gmail.com', 'or-debora@outlook.com', 'joaoricardodinizsilva@gmail.com', 'leandrotsmachado@gmail.com', 'luiza.deschamps@hotmail.com', 'brunnacampos01@hotmail.com', 'buenocurador@gmail.com', 'joaovicenterf@gmail.com', 'izabela.sdutra@gmail.com', 'alessandra.cso@gmail.com', 'giboanapaula@hotmail.com', 'gladyslimabio@yahoo.com.br', 'julietanferreira@gmail.com', 'mariannarezende@gmail.com', 'mialine_vale@yahoo.com.br', 'edmilsonrossi@gmail.com', 'profpedromarcio@hotmail.com', 'heronguatiello@gmail.com', 'alexsandra@dnia.ai', 'rodrigoferreira077@gmail.com', 'lanich2014@gmail.com', 'heitorfrancisco2005@hotmail.com', 'ketlenmac@gmail.com', 'ttjpopo@gmail.com', 'Alaideoliveiralongo@hotmail.com', 'barbarabenvenu@gmail.com', 'janecpq76@gmail.com', 'lalla.nathania@gmail.com', 'mendesana39@gmail.com', 'bertellojulia@gmail.com', 'carolina@artesacramoda.com.br', 'reporterivane@yahoo.com.br', 'rmartins.2306@gmail.com', 'marcelalazza@gmail.com', 'carlatutschkeanalistacorporal@gmail.com', 'carla.mariana70@hotmail.com', 'assislarissa2023@gmail.com', 'paollacolli@gmail.com', 'santogabriel13@gmail.com', 'mssuribeiro@yahoo.com.br', 'vivi.noronha2009@hotmail.com', 'caiofran746@gmail.com', 'caredufisio@gmail.com', 'adrianavidal@flourish.com.br', 'setrini@uol.com.br', 'danianemd@yahoo.com.br', 'cmartire@hotmail.com', 'izaloredo.mkt@gmail.com', 'priscilasoares02@yahoo.com.br', 'ariane.santiago0112@gmail.com', 'rafael6ptc@hotmail.com', 'mulherrealeza01@gmail.com', 'patriciarezende22@hotmail.com', 'aniekarenina@gmail.com', 'esleycastelar@gmail.com', 'frankybarbosa56@gmail.com', 'gracekpassos@gmail.com', 'Thalia.dahora@outlook.com', 'luizfernando.maluf@gmail.com', 'djesmi@hotmail.com', 'jsepifanio2@gmail.com', 'normandia@dnaia.ai', 'teste.1770407502698.295.1@loadtest.com', 'teste.1770407502828.1808.65@loadtest.com', 'teste.1770407502776.3720.3@loadtest.com', 'teste.1770407502835.7735.75@loadtest.com', 'teste.1770407502840.1592.82@loadtest.com', 'teste.1770407502778.6251.4@loadtest.com', 'teste.1770407502832.9984.70@loadtest.com', 'teste.1770407502780.1844.6@loadtest.com', 'teste.1770407502781.2325.7@loadtest.com', 'teste.1770407502787.4792.10@loadtest.com', 'teste.1770407502838.7504.79@loadtest.com', 'teste.1770407502790.5763.14@loadtest.com', 'teste.1770407502774.8536.2@loadtest.com', 'teste.1770407502794.8959.19@loadtest.com', 'teste.1770407502779.6787.5@loadtest.com', 'teste.1770407502783.5086.9@loadtest.com', 'teste.1770407502791.8698.15@loadtest.com', 'teste.1770407502788.3329.11@loadtest.com', 'teste.1770407502793.4788.18@loadtest.com', 'teste.1770407502799.9290.26@loadtest.com', 'teste.1770407502792.1908.16@loadtest.com', 'teste.1770407502790.6360.13@loadtest.com', 'teste.1770407502782.1842.8@loadtest.com', 'teste.1770407502794.2994.20@loadtest.com', 'teste.1770407502792.5820.17@loadtest.com', 'teste.1770407502797.9054.24@loadtest.com', 'teste.1770407502789.2226.12@loadtest.com', 'teste.1770407502795.633.21@loadtest.com', 'teste.1770407502799.4935.27@loadtest.com', 'teste.1770407502797.88.23@loadtest.com', 'teste.1770407502800.3937.28@loadtest.com', 'teste.1770407502809.8639.40@loadtest.com', 'teste.1770407502796.2487.22@loadtest.com', 'teste.1770407502798.3500.25@loadtest.com', 'teste.1770407502844.9283.85@loadtest.com', 'teste.1770407502812.7425.44@loadtest.com', 'teste.1770407502817.1818.51@loadtest.com', 'teste.1770407502801.7249.29@loadtest.com', 'teste.1770407502804.838.33@loadtest.com', 'teste.1770407502807.2556.38@loadtest.com', 'teste.1770407502802.5574.31@loadtest.com', 'teste.1770407502807.8803.37@loadtest.com', 'teste.1770407502805.3595.34@loadtest.com', 'teste.1770407502810.1305.42@loadtest.com', 'teste.1770407502803.639.32@loadtest.com', 'teste.1770407502813.4674.46@loadtest.com', 'teste.1770407502814.5100.48@loadtest.com', 'teste.1770407502814.91.47@loadtest.com', 'teste.1770407502812.6317.45@loadtest.com', 'teste.1770407502821.686.55@loadtest.com', 'teste.1770407502802.9551.30@loadtest.com', 'teste.1770407502824.6799.59@loadtest.com', 'teste.1770407502825.7736.61@loadtest.com', 'teste.1770407502854.3743.100@loadtest.com', 'teste.1770407502837.7792.77@loadtest.com', 'teste.1770407502820.3572.53@loadtest.com', 'teste.1770407502816.7977.50@loadtest.com', 'teste.1770407502822.3591.56@loadtest.com', 'teste.1770407502848.3271.91@loadtest.com', 'teste.1770407502820.7427.54@loadtest.com', 'teste.1770407502806.7146.36@loadtest.com', 'teste.1770407502823.5604.58@loadtest.com', 'teste.1770407502815.8109.49@loadtest.com', 'teste.1770407502829.7652.66@loadtest.com', 'teste.1770407502831.8929.69@loadtest.com', 'teste.1770407502830.6365.68@loadtest.com', 'teste.1770407502849.6833.93@loadtest.com', 'teste.1770407502852.4811.96@loadtest.com', 'teste.1770407502822.2671.57@loadtest.com', 'teste.1770407502828.3342.64@loadtest.com', 'teste.1770407502836.5557.76@loadtest.com', 'teste.1770407502838.1172.78@loadtest.com', 'teste.1770407502833.6207.71@loadtest.com', 'teste.1770407502808.6910.39@loadtest.com', 'teste.1770407502809.9820.41@loadtest.com', 'teste.1770407502833.5914.72@loadtest.com', 'teste.1770407502830.2584.67@loadtest.com', 'teste.1770407502834.8835.73@loadtest.com', 'teste.1770407502843.5992.83@loadtest.com', 'teste.1770407502811.3994.43@loadtest.com', 'teste.1770407502826.6293.62@loadtest.com', 'teste.1770407502819.622.52@loadtest.com', 'teste.1770407502840.9087.81@loadtest.com', 'teste.1770407502845.1246.86@loadtest.com', 'teste.1770407502835.7276.74@loadtest.com', 'teste.1770407502851.9235.95@loadtest.com', 'teste.1770407502850.4530.94@loadtest.com', 'teste.1770407502843.6905.84@loadtest.com', 'teste.1770407502805.4344.35@loadtest.com', 'teste.1770407502845.4977.87@loadtest.com', 'teste.1770407502847.5521.89@loadtest.com', 'teste.1770407502827.3784.63@loadtest.com', 'teste.1770407502853.9817.98@loadtest.com', 'teste.1770407502852.2289.97@loadtest.com', 'teste.1770407502846.2061.88@loadtest.com', 'teste.1770407502854.7936.99@loadtest.com', 'teste.1770407502825.8057.60@loadtest.com', 'teste.1770407502839.4597.80@loadtest.com', 'teste.1770407502849.994.92@loadtest.com', 'teste.1770407502847.5668.90@loadtest.com', 'teste.1770407690211.1531.3@loadtest.com', 'teste.1770407690212.586.4@loadtest.com', 'teste.1770407690243.8803.37@loadtest.com', 'teste.1770407690209.3334.2@loadtest.com', 'teste.1770407690235.1067.26@loadtest.com', 'teste.1770407690227.6234.15@loadtest.com', 'teste.1770407690241.4133.35@loadtest.com', 'teste.1770407690276.7795.79@loadtest.com', 'teste.1770407690215.2245.6@loadtest.com', 'teste.1770407690244.3322.38@loadtest.com', 'teste.1770407690216.9743.7@loadtest.com', 'teste.1770407690227.9576.16@loadtest.com', 'teste.1770407690219.4381.9@loadtest.com', 'teste.1770407690228.9114.17@loadtest.com', 'teste.1770407690214.3263.5@loadtest.com', 'teste.1770407690217.3651.8@loadtest.com', 'teste.1770407690223.2026.11@loadtest.com', 'teste.1770407690232.3655.23@loadtest.com', 'teste.1770407690225.8671.13@loadtest.com', 'teste.1770407690226.6602.14@loadtest.com', 'teste.1770407690133.9371.1@loadtest.com', 'teste.1770407690224.7187.12@loadtest.com', 'teste.1770407690222.1109.10@loadtest.com', 'teste.1770407690229.7066.18@loadtest.com', 'teste.1770407690233.7493.24@loadtest.com', 'teste.1770407690238.2076.30@loadtest.com', 'teste.1770407690231.9376.21@loadtest.com', 'teste.1770407690237.9313.29@loadtest.com', 'teste.1770407690234.1856.25@loadtest.com', 'teste.1770407690230.669.19@loadtest.com', 'teste.1770407690240.3703.33@loadtest.com', 'teste.1770407690241.5217.34@loadtest.com', 'teste.1770407690230.664.20@loadtest.com', 'teste.1770407690235.9352.27@loadtest.com', 'teste.1770407690261.2597.59@loadtest.com', 'teste.1770407690250.1441.47@loadtest.com', 'teste.1770407690242.5416.36@loadtest.com', 'teste.1770407690236.9777.28@loadtest.com', 'teste.1770407690244.4796.39@loadtest.com', 'teste.1770407690262.4676.60@loadtest.com', 'teste.1770407690256.6181.52@loadtest.com', 'teste.1770407690249.4124.45@loadtest.com', 'teste.1770407690251.2476.48@loadtest.com', 'teste.1770407690252.6543.49@loadtest.com', 'teste.1770407690263.5572.62@loadtest.com', 'teste.1770407690279.5335.83@loadtest.com', 'teste.1770407690245.4292.40@loadtest.com', 'teste.1770407690246.9634.41@loadtest.com', 'teste.1770407690254.2193.51@loadtest.com', 'teste.1770407690257.7651.54@loadtest.com', 'teste.1770407690232.2707.22@loadtest.com', 'teste.1770407690258.7258.55@loadtest.com', 'teste.1770407690247.3088.43@loadtest.com', 'teste.1770407690274.1180.76@loadtest.com', 'teste.1770407690253.8130.50@loadtest.com', 'teste.1770407690250.8937.46@loadtest.com', 'teste.1770407690265.4490.64@loadtest.com', 'teste.1770407690248.2256.44@loadtest.com', 'teste.1770407690281.7460.84@loadtest.com', 'teste.1770407690283.8010.86@loadtest.com', 'teste.1770407690275.4523.77@loadtest.com', 'teste.1770407690257.5140.53@loadtest.com', 'teste.1770407690293.9610.99@loadtest.com', 'teste.1770407690266.5394.65@loadtest.com', 'teste.1770407690285.707.89@loadtest.com', 'teste.1770407690259.3613.57@loadtest.com', 'teste.1770407690239.8981.32@loadtest.com', 'teste.1770407690269.2108.69@loadtest.com', 'teste.1770407690266.1306.66@loadtest.com', 'teste.1770407690260.2867.58@loadtest.com', 'teste.1770407690272.7699.73@loadtest.com', 'teste.1770407690292.4846.98@loadtest.com', 'teste.1770407690268.1461.68@loadtest.com', 'teste.1770407690259.896.56@loadtest.com', 'teste.1770407690275.2336.78@loadtest.com', 'teste.1770407690286.1329.90@loadtest.com', 'teste.1770407690269.3864.70@loadtest.com', 'teste.1770407690267.8922.67@loadtest.com', 'teste.1770407690284.5400.88@loadtest.com', 'teste.1770407690284.3688.87@loadtest.com', 'teste.1770407690288.1226.92@loadtest.com', 'teste.1770407690287.6472.91@loadtest.com', 'teste.1770407690272.6007.74@loadtest.com', 'teste.1770407690278.7691.81@loadtest.com', 'teste.1770407690273.133.75@loadtest.com', 'teste.1770407690277.315.80@loadtest.com', 'teste.1770407690271.6031.72@loadtest.com', 'teste.1770407690288.5286.93@loadtest.com', 'teste.1770407690263.6656.61@loadtest.com', 'teste.1770407690270.4469.71@loadtest.com', 'teste.1770407690293.7925.100@loadtest.com', 'teste.1770407690278.9123.82@loadtest.com', 'teste.1770407690238.7458.31@loadtest.com', 'teste.1770407690289.3187.94@loadtest.com', 'teste.1770407690290.3492.95@loadtest.com', 'teste.1770407690247.4761.42@loadtest.com', 'teste.1770407690290.8948.96@loadtest.com', 'teste.1770407690291.1591.97@loadtest.com', 'teste.1770407690264.6182.63@loadtest.com', 'teste.1770407690282.2169.85@loadtest.com', 'rcantareira@gmail.com', 'brunarbsemijoias@com.br'));
DELETE FROM public.user_roles WHERE user_id IN (SELECT id FROM auth.users WHERE email IN ('operacoes@buscarid.com', 'rodrigonormandia@buscarid.com', 'kaw@buscarid.com', 'jussara@buscarid.com', 'draflaviareumatobh@gmail.com', 'rodrigo@sabecomo.com.br', 'nicholsongp@gmail.com', 'andrewafonso@gmail.com', 'anie.karenina@buffalodigital.com.br', 'fernandojin@gmail.com', 'danielgaia13@gmail.com', 'filipejclopes@gmail.com', 'sura.carvalho@gmail.com', 'renatolopesevolve@gmail.com', 'leticia@maxupconsultoria.com.br', 'rbetasim@gmail.com', 'evalarissa157@gmail.com', 'lalacorrea@gmail.com', 'henriquehamerski@gmail.com', 'leodavidrotela91@gmail.com', 'maia.jpm@gmail.com', 'dayane@maxupconsultoria.com.br', 'christianobsr@gmail.com', 'andradegoval2013@gmail.com', 'maugustocand@gmail.com', 'raquel@albanezemaia.adv.br', 'francis@maxupconsultoria.com.br', 'admin@teste.com', 'carol@buscarid.com', 'rodrigo@buscarid.com', 'duponce.mcc@gmail.com', 'lukedepaulo@gmail.com', 'jessica.maia@fundacaocdlbh.org.br', 'guilherme@ctrl.cnt.br', 'renato_godinho@hotmail.com', 'augustoizac@gmail.con', 'alysson.guimaraes@cdlbh.com.br', 'emelygaspar@gmail.com', 'adrianoboscatte@gmail.com', 'luisa@cpbellaperfumes.com.br', 'gabriel.junqueira@avancoinfo.com.br', 'joas_pessoa@hotmail.com', 'marlucio.silva@fundacaocdlbh.org', 'brunarpn@gmail.com', 'debora.com.mkt@gmail.com', 'brenoduarte@hotmail.com', 'wadir@bellaboticario.com.br', 'joseangelo@bellaboticario.com.br', 'junioramerico@atsinformatica.com.br', 'ulissessamarone@gmail.com', 'carloseduardo.cacaushowbh@gmail.com', 'carloeduardo@gmail.com', 'joaovictor@cdlbh.com.br', 'analaraest@icloud.com', 'hitalocarvalho@gmail.com', 'anakarlamoraisg@gmail.com', 'isis.or.natural@gmail.com', 'aquilis.moreira@oktz.com.br', 'k.raquelferreira@gmail.com', 'gabrielvfalci@gmail.com', 'hellenmr87@yahoo.com.br', 'alexandresantos@smcit.com.br', 'faustocasabranca@gmail.com', 'camilarvalentim@gmail.com', 'nayaralcampos@gmail.com', 'vilson.mayrink@gmail.com', 'mflaviocs@gmail.com', 'leocamargo@yahoo.com', 'contato@uaiviajei.com.br', 'joel.souza@cdlbh.com.br', 'joseangelo.melo@cdlbh.com.br', 'rcheiricatti@gmail.com', 'breendon.almeida@gmail.com', 'flavioizac@gmail.com', 'bruno.sbraletta@gmail.com', 'hg.leticia@gmail.com', 'lucaspitta@targetfroras.com.br', 'ana.arrunategui@buffalodigital.com.br', 'ana.souza@buffalodigital.com.br', 'andy.monterei@buffalodigital.com.br', 'andre.doyle@buffalodigital.com.br', 'filippe.leite@buffalodigital.com.br', 'francis.willian@buffalodigital.com.br', 'jordana.ferreira@buffalodigital.com.br', 'larissa.soares@buffalodigital.com.br', 'lucas.vilasboas@buffalodigital.com.br', 'mayra.abeki@buffalodigital.com.br', 'patricia.oliveira@buffalodigital.com.br', 'rafael.guilherme@buffalodigital.com.br', 'samira.dias@buffalodigital.com.br', 'thais.barbian@buffalodigital.com.br', 'claudio.batitucci@partners360.com.br', 'analuisaarrunategui@gmail.com', 'clayton.lisboa@buffalodigital.com.br', 'bruno.henrique@repetreciclagem.com.br', 'np@healthsafetytech.com', 'alexsandrarmatos@gmail.com', 'alexa@etcetal.com.br', 'adm01@healthsafetytech.com', 'hylderosa@gmail.com', 'mayaradias.tur@gmail.com', 'digowars@gmail.com', 'daniel.gaia@varejaodastintas.com.br', 'aangrisano@gmail.com', 'test_with_password_1768589940269@example.com', 'test_without_password_1768589940874@example.com', 'rnrsouza@hotmail.com', 'kawbicalho@gmail.com', 'GABIDIASJ@GMAIL.COM', 'financeiro01@healthsafetytech.com', 'comercial01@healthsafetytech.com', 'qualidade01@healthsafetytech.com', 'servicos01@healthsafetytech.com', 'laboratorio01@healthsafetytech.com', 'expedicao01@healthsafetytech.com', 'ti@healthsafetytech.com', 'expedicao02@healthsafetytech.com', 'comercial02@healthsafetytech.com', 'ti02@healthsafetytech.com', 'comercial03@healthsafetytech.com', 'comercial04@healthsafetytech.com', 'qualidade02@healthsafetytech.com', 'servicos02@healthsafetytech.com', 'laboratorio02@healthsafetytech.com', 'expedicao03@healthsafetytech.com', 'suporte01@healthsafetytech.com', 'comercial05@healthsafetytech.com', 'suporte02@healthsafetytech.com', 'ti03@healthsafetytech.com', 'surama@etcetal.com.br', 'walbertsantos@gmail.com', 'sdr3@healthsafety.com.br', 'adriana_diana_oliveira@hotmail.com', 'gynunes62@gmail.com', 'djalmanetobeto@gmail.com', 'sandraa.cristina@hotmail.com', 'gopme12@gmail.com', 'weltonkellyson24@gmail.com', 'sdr1@healthsafety.com.br', 'gmswanderley@gmail.com', 'suelenpatricia957@gmail.com', 'rickelmepe@gmail.com', 'suelenpatricia957@gmai.com', 'ellenelis87@gmail.com', 'lucas.azevedo3009@gmail.com', 'leandroepronto3.1lvs@gmail.com', 'fabianodinizsantos@gmail.com', 'rgcaetanofujitsu@gmail.com', 'giancarlodalmulin@gmail.com', 'ronetju2019@gmail.com', 'valeria.educacional@gmail.com', 'dede_rangel@yahoo.com.br', 'renato.correa@oktz.com.br', 'institutoalupo@gmail.com', 'fabio.marfer@gmail.com', 'welintonsilva690@gmail.com', 'jrmagrafil@gmail.com', 'lua77@uol.com.br', 'Marcoamojr@gmail.com', 'julianacosta_15@hotmail.com', 'fernanda_arceno@hotmail.com', 'mauriciosilva1590@gmail.com', 'amiltonguedes2009@gmail.com', 'viniciusleal@ymail.com', 'gilberto.maranhao78@gmail.com', 'jocemarmartinscalado@gmail.com', 'ricardo.a.m.tomita@gmail.com', 'ljordaosilva@gmail.com', 'marpugliesi@gmail.com', 'pedro@reclick.com.br', 'fabmontsant@gmail.com', 'europalugares@gmail.com', 'gildevamjunior@hotmail.com', 'alexandre.diniz.cesar@gmail.com', 'gabrieladauer@gmail.com', 'claudenice_lem@hotmail.com', 'art3dstd@gmail.com', 'valdeirsantos891@gmail.com', 'ta.993810275@gmail.com', 'ruiterfidencio@gmail.com', 'eliemarbueno@gmail.com', 'andreiacbarreto@gmail.com', 'doromarra@hotmail.com', 'suelenribeiro@gestaomatriz.com.br', 'grodriguez@piattino.com.br', 'lcsxavier@hotmail.com', 'brunaarruda1712@gmail.com', 'maisahfm@gmail.com', 'gccotia.combate@gmail.com', 'jubettini@gmail.com', 'rmatoscarina@gmail.com', 'gkgloballink@gmail.com', 'mariaeduardabranco1991@gmail.com', 'jornalistapatriciateixeira@gmail.com', 'elisapj@hotmail.com', 'harmonia5x.mentorias@gmail.com', 'savanazamai@gmail.com', 'phabioliveira@gmail.com', 'frs8176@gmail.com', 'unapackembalagens@gmail.com', 'taisfaria1@gmail.com', 'ronetju@yahoo.com.br', 'lilianc21@yahoo.com', 'getulioairescorretorimoveis@gmail.com', 'kimberly_suellen@hotmail.com', 'giselleas@hotmail.com', 'maurina26mbk@gmail.com', 'helenafcr@gmail.com', 'alle-lima2011@hotmail.com', 'larissa21_assis@outlook.com', 'junioalmeida1994@gmail.com', 'turossizah@gmail.com', 'patriciaas.antao@gmail.com', 'rosellirozendo@gmail.com', 'juliane.vieira@claro.com.br', 'mariribeiro14071982@gmail.com', 'dennilsonjl@gmail.com', 'liliane.soberana@gmail.com', 'isaacgomesrdf@gmail.com', 'RODRIGOFERNANDESCONTABILIDADE@GMAIL.COM', 'carloscerbbinno@gmail.com', 'esmirnacv@yahoo.com.br', 'phaty17@gmail.com', 'marceloffranco@glook.com.br', 'ribeiroola@gmail.com', 'larissa.almeida@grupomultilaser.com.br', 'marcela@artesacramoda.com.br', 'milamreis@hotmail.com', 'rafaelfarreb@gmail.com', 'marcosdelnero.apps@gmail.com', 'or-debora@outlook.com', 'joaoricardodinizsilva@gmail.com', 'leandrotsmachado@gmail.com', 'luiza.deschamps@hotmail.com', 'brunnacampos01@hotmail.com', 'buenocurador@gmail.com', 'joaovicenterf@gmail.com', 'izabela.sdutra@gmail.com', 'alessandra.cso@gmail.com', 'giboanapaula@hotmail.com', 'gladyslimabio@yahoo.com.br', 'julietanferreira@gmail.com', 'mariannarezende@gmail.com', 'mialine_vale@yahoo.com.br', 'edmilsonrossi@gmail.com', 'profpedromarcio@hotmail.com', 'heronguatiello@gmail.com', 'alexsandra@dnia.ai', 'rodrigoferreira077@gmail.com', 'lanich2014@gmail.com', 'heitorfrancisco2005@hotmail.com', 'ketlenmac@gmail.com', 'ttjpopo@gmail.com', 'Alaideoliveiralongo@hotmail.com', 'barbarabenvenu@gmail.com', 'janecpq76@gmail.com', 'lalla.nathania@gmail.com', 'mendesana39@gmail.com', 'bertellojulia@gmail.com', 'carolina@artesacramoda.com.br', 'reporterivane@yahoo.com.br', 'rmartins.2306@gmail.com', 'marcelalazza@gmail.com', 'carlatutschkeanalistacorporal@gmail.com', 'carla.mariana70@hotmail.com', 'assislarissa2023@gmail.com', 'paollacolli@gmail.com', 'santogabriel13@gmail.com', 'mssuribeiro@yahoo.com.br', 'vivi.noronha2009@hotmail.com', 'caiofran746@gmail.com', 'caredufisio@gmail.com', 'adrianavidal@flourish.com.br', 'setrini@uol.com.br', 'danianemd@yahoo.com.br', 'cmartire@hotmail.com', 'izaloredo.mkt@gmail.com', 'priscilasoares02@yahoo.com.br', 'ariane.santiago0112@gmail.com', 'rafael6ptc@hotmail.com', 'mulherrealeza01@gmail.com', 'patriciarezende22@hotmail.com', 'aniekarenina@gmail.com', 'esleycastelar@gmail.com', 'frankybarbosa56@gmail.com', 'gracekpassos@gmail.com', 'Thalia.dahora@outlook.com', 'luizfernando.maluf@gmail.com', 'djesmi@hotmail.com', 'jsepifanio2@gmail.com', 'normandia@dnaia.ai', 'teste.1770407502698.295.1@loadtest.com', 'teste.1770407502828.1808.65@loadtest.com', 'teste.1770407502776.3720.3@loadtest.com', 'teste.1770407502835.7735.75@loadtest.com', 'teste.1770407502840.1592.82@loadtest.com', 'teste.1770407502778.6251.4@loadtest.com', 'teste.1770407502832.9984.70@loadtest.com', 'teste.1770407502780.1844.6@loadtest.com', 'teste.1770407502781.2325.7@loadtest.com', 'teste.1770407502787.4792.10@loadtest.com', 'teste.1770407502838.7504.79@loadtest.com', 'teste.1770407502790.5763.14@loadtest.com', 'teste.1770407502774.8536.2@loadtest.com', 'teste.1770407502794.8959.19@loadtest.com', 'teste.1770407502779.6787.5@loadtest.com', 'teste.1770407502783.5086.9@loadtest.com', 'teste.1770407502791.8698.15@loadtest.com', 'teste.1770407502788.3329.11@loadtest.com', 'teste.1770407502793.4788.18@loadtest.com', 'teste.1770407502799.9290.26@loadtest.com', 'teste.1770407502792.1908.16@loadtest.com', 'teste.1770407502790.6360.13@loadtest.com', 'teste.1770407502782.1842.8@loadtest.com', 'teste.1770407502794.2994.20@loadtest.com', 'teste.1770407502792.5820.17@loadtest.com', 'teste.1770407502797.9054.24@loadtest.com', 'teste.1770407502789.2226.12@loadtest.com', 'teste.1770407502795.633.21@loadtest.com', 'teste.1770407502799.4935.27@loadtest.com', 'teste.1770407502797.88.23@loadtest.com', 'teste.1770407502800.3937.28@loadtest.com', 'teste.1770407502809.8639.40@loadtest.com', 'teste.1770407502796.2487.22@loadtest.com', 'teste.1770407502798.3500.25@loadtest.com', 'teste.1770407502844.9283.85@loadtest.com', 'teste.1770407502812.7425.44@loadtest.com', 'teste.1770407502817.1818.51@loadtest.com', 'teste.1770407502801.7249.29@loadtest.com', 'teste.1770407502804.838.33@loadtest.com', 'teste.1770407502807.2556.38@loadtest.com', 'teste.1770407502802.5574.31@loadtest.com', 'teste.1770407502807.8803.37@loadtest.com', 'teste.1770407502805.3595.34@loadtest.com', 'teste.1770407502810.1305.42@loadtest.com', 'teste.1770407502803.639.32@loadtest.com', 'teste.1770407502813.4674.46@loadtest.com', 'teste.1770407502814.5100.48@loadtest.com', 'teste.1770407502814.91.47@loadtest.com', 'teste.1770407502812.6317.45@loadtest.com', 'teste.1770407502821.686.55@loadtest.com', 'teste.1770407502802.9551.30@loadtest.com', 'teste.1770407502824.6799.59@loadtest.com', 'teste.1770407502825.7736.61@loadtest.com', 'teste.1770407502854.3743.100@loadtest.com', 'teste.1770407502837.7792.77@loadtest.com', 'teste.1770407502820.3572.53@loadtest.com', 'teste.1770407502816.7977.50@loadtest.com', 'teste.1770407502822.3591.56@loadtest.com', 'teste.1770407502848.3271.91@loadtest.com', 'teste.1770407502820.7427.54@loadtest.com', 'teste.1770407502806.7146.36@loadtest.com', 'teste.1770407502823.5604.58@loadtest.com', 'teste.1770407502815.8109.49@loadtest.com', 'teste.1770407502829.7652.66@loadtest.com', 'teste.1770407502831.8929.69@loadtest.com', 'teste.1770407502830.6365.68@loadtest.com', 'teste.1770407502849.6833.93@loadtest.com', 'teste.1770407502852.4811.96@loadtest.com', 'teste.1770407502822.2671.57@loadtest.com', 'teste.1770407502828.3342.64@loadtest.com', 'teste.1770407502836.5557.76@loadtest.com', 'teste.1770407502838.1172.78@loadtest.com', 'teste.1770407502833.6207.71@loadtest.com', 'teste.1770407502808.6910.39@loadtest.com', 'teste.1770407502809.9820.41@loadtest.com', 'teste.1770407502833.5914.72@loadtest.com', 'teste.1770407502830.2584.67@loadtest.com', 'teste.1770407502834.8835.73@loadtest.com', 'teste.1770407502843.5992.83@loadtest.com', 'teste.1770407502811.3994.43@loadtest.com', 'teste.1770407502826.6293.62@loadtest.com', 'teste.1770407502819.622.52@loadtest.com', 'teste.1770407502840.9087.81@loadtest.com', 'teste.1770407502845.1246.86@loadtest.com', 'teste.1770407502835.7276.74@loadtest.com', 'teste.1770407502851.9235.95@loadtest.com', 'teste.1770407502850.4530.94@loadtest.com', 'teste.1770407502843.6905.84@loadtest.com', 'teste.1770407502805.4344.35@loadtest.com', 'teste.1770407502845.4977.87@loadtest.com', 'teste.1770407502847.5521.89@loadtest.com', 'teste.1770407502827.3784.63@loadtest.com', 'teste.1770407502853.9817.98@loadtest.com', 'teste.1770407502852.2289.97@loadtest.com', 'teste.1770407502846.2061.88@loadtest.com', 'teste.1770407502854.7936.99@loadtest.com', 'teste.1770407502825.8057.60@loadtest.com', 'teste.1770407502839.4597.80@loadtest.com', 'teste.1770407502849.994.92@loadtest.com', 'teste.1770407502847.5668.90@loadtest.com', 'teste.1770407690211.1531.3@loadtest.com', 'teste.1770407690212.586.4@loadtest.com', 'teste.1770407690243.8803.37@loadtest.com', 'teste.1770407690209.3334.2@loadtest.com', 'teste.1770407690235.1067.26@loadtest.com', 'teste.1770407690227.6234.15@loadtest.com', 'teste.1770407690241.4133.35@loadtest.com', 'teste.1770407690276.7795.79@loadtest.com', 'teste.1770407690215.2245.6@loadtest.com', 'teste.1770407690244.3322.38@loadtest.com', 'teste.1770407690216.9743.7@loadtest.com', 'teste.1770407690227.9576.16@loadtest.com', 'teste.1770407690219.4381.9@loadtest.com', 'teste.1770407690228.9114.17@loadtest.com', 'teste.1770407690214.3263.5@loadtest.com', 'teste.1770407690217.3651.8@loadtest.com', 'teste.1770407690223.2026.11@loadtest.com', 'teste.1770407690232.3655.23@loadtest.com', 'teste.1770407690225.8671.13@loadtest.com', 'teste.1770407690226.6602.14@loadtest.com', 'teste.1770407690133.9371.1@loadtest.com', 'teste.1770407690224.7187.12@loadtest.com', 'teste.1770407690222.1109.10@loadtest.com', 'teste.1770407690229.7066.18@loadtest.com', 'teste.1770407690233.7493.24@loadtest.com', 'teste.1770407690238.2076.30@loadtest.com', 'teste.1770407690231.9376.21@loadtest.com', 'teste.1770407690237.9313.29@loadtest.com', 'teste.1770407690234.1856.25@loadtest.com', 'teste.1770407690230.669.19@loadtest.com', 'teste.1770407690240.3703.33@loadtest.com', 'teste.1770407690241.5217.34@loadtest.com', 'teste.1770407690230.664.20@loadtest.com', 'teste.1770407690235.9352.27@loadtest.com', 'teste.1770407690261.2597.59@loadtest.com', 'teste.1770407690250.1441.47@loadtest.com', 'teste.1770407690242.5416.36@loadtest.com', 'teste.1770407690236.9777.28@loadtest.com', 'teste.1770407690244.4796.39@loadtest.com', 'teste.1770407690262.4676.60@loadtest.com', 'teste.1770407690256.6181.52@loadtest.com', 'teste.1770407690249.4124.45@loadtest.com', 'teste.1770407690251.2476.48@loadtest.com', 'teste.1770407690252.6543.49@loadtest.com', 'teste.1770407690263.5572.62@loadtest.com', 'teste.1770407690279.5335.83@loadtest.com', 'teste.1770407690245.4292.40@loadtest.com', 'teste.1770407690246.9634.41@loadtest.com', 'teste.1770407690254.2193.51@loadtest.com', 'teste.1770407690257.7651.54@loadtest.com', 'teste.1770407690232.2707.22@loadtest.com', 'teste.1770407690258.7258.55@loadtest.com', 'teste.1770407690247.3088.43@loadtest.com', 'teste.1770407690274.1180.76@loadtest.com', 'teste.1770407690253.8130.50@loadtest.com', 'teste.1770407690250.8937.46@loadtest.com', 'teste.1770407690265.4490.64@loadtest.com', 'teste.1770407690248.2256.44@loadtest.com', 'teste.1770407690281.7460.84@loadtest.com', 'teste.1770407690283.8010.86@loadtest.com', 'teste.1770407690275.4523.77@loadtest.com', 'teste.1770407690257.5140.53@loadtest.com', 'teste.1770407690293.9610.99@loadtest.com', 'teste.1770407690266.5394.65@loadtest.com', 'teste.1770407690285.707.89@loadtest.com', 'teste.1770407690259.3613.57@loadtest.com', 'teste.1770407690239.8981.32@loadtest.com', 'teste.1770407690269.2108.69@loadtest.com', 'teste.1770407690266.1306.66@loadtest.com', 'teste.1770407690260.2867.58@loadtest.com', 'teste.1770407690272.7699.73@loadtest.com', 'teste.1770407690292.4846.98@loadtest.com', 'teste.1770407690268.1461.68@loadtest.com', 'teste.1770407690259.896.56@loadtest.com', 'teste.1770407690275.2336.78@loadtest.com', 'teste.1770407690286.1329.90@loadtest.com', 'teste.1770407690269.3864.70@loadtest.com', 'teste.1770407690267.8922.67@loadtest.com', 'teste.1770407690284.5400.88@loadtest.com', 'teste.1770407690284.3688.87@loadtest.com', 'teste.1770407690288.1226.92@loadtest.com', 'teste.1770407690287.6472.91@loadtest.com', 'teste.1770407690272.6007.74@loadtest.com', 'teste.1770407690278.7691.81@loadtest.com', 'teste.1770407690273.133.75@loadtest.com', 'teste.1770407690277.315.80@loadtest.com', 'teste.1770407690271.6031.72@loadtest.com', 'teste.1770407690288.5286.93@loadtest.com', 'teste.1770407690263.6656.61@loadtest.com', 'teste.1770407690270.4469.71@loadtest.com', 'teste.1770407690293.7925.100@loadtest.com', 'teste.1770407690278.9123.82@loadtest.com', 'teste.1770407690238.7458.31@loadtest.com', 'teste.1770407690289.3187.94@loadtest.com', 'teste.1770407690290.3492.95@loadtest.com', 'teste.1770407690247.4761.42@loadtest.com', 'teste.1770407690290.8948.96@loadtest.com', 'teste.1770407690291.1591.97@loadtest.com', 'teste.1770407690264.6182.63@loadtest.com', 'teste.1770407690282.2169.85@loadtest.com', 'rcantareira@gmail.com', 'brunarbsemijoias@com.br'));
DELETE FROM public.profiles WHERE user_id IN (SELECT id FROM auth.users WHERE email IN ('operacoes@buscarid.com', 'rodrigonormandia@buscarid.com', 'kaw@buscarid.com', 'jussara@buscarid.com', 'draflaviareumatobh@gmail.com', 'rodrigo@sabecomo.com.br', 'nicholsongp@gmail.com', 'andrewafonso@gmail.com', 'anie.karenina@buffalodigital.com.br', 'fernandojin@gmail.com', 'danielgaia13@gmail.com', 'filipejclopes@gmail.com', 'sura.carvalho@gmail.com', 'renatolopesevolve@gmail.com', 'leticia@maxupconsultoria.com.br', 'rbetasim@gmail.com', 'evalarissa157@gmail.com', 'lalacorrea@gmail.com', 'henriquehamerski@gmail.com', 'leodavidrotela91@gmail.com', 'maia.jpm@gmail.com', 'dayane@maxupconsultoria.com.br', 'christianobsr@gmail.com', 'andradegoval2013@gmail.com', 'maugustocand@gmail.com', 'raquel@albanezemaia.adv.br', 'francis@maxupconsultoria.com.br', 'admin@teste.com', 'carol@buscarid.com', 'rodrigo@buscarid.com', 'duponce.mcc@gmail.com', 'lukedepaulo@gmail.com', 'jessica.maia@fundacaocdlbh.org.br', 'guilherme@ctrl.cnt.br', 'renato_godinho@hotmail.com', 'augustoizac@gmail.con', 'alysson.guimaraes@cdlbh.com.br', 'emelygaspar@gmail.com', 'adrianoboscatte@gmail.com', 'luisa@cpbellaperfumes.com.br', 'gabriel.junqueira@avancoinfo.com.br', 'joas_pessoa@hotmail.com', 'marlucio.silva@fundacaocdlbh.org', 'brunarpn@gmail.com', 'debora.com.mkt@gmail.com', 'brenoduarte@hotmail.com', 'wadir@bellaboticario.com.br', 'joseangelo@bellaboticario.com.br', 'junioramerico@atsinformatica.com.br', 'ulissessamarone@gmail.com', 'carloseduardo.cacaushowbh@gmail.com', 'carloeduardo@gmail.com', 'joaovictor@cdlbh.com.br', 'analaraest@icloud.com', 'hitalocarvalho@gmail.com', 'anakarlamoraisg@gmail.com', 'isis.or.natural@gmail.com', 'aquilis.moreira@oktz.com.br', 'k.raquelferreira@gmail.com', 'gabrielvfalci@gmail.com', 'hellenmr87@yahoo.com.br', 'alexandresantos@smcit.com.br', 'faustocasabranca@gmail.com', 'camilarvalentim@gmail.com', 'nayaralcampos@gmail.com', 'vilson.mayrink@gmail.com', 'mflaviocs@gmail.com', 'leocamargo@yahoo.com', 'contato@uaiviajei.com.br', 'joel.souza@cdlbh.com.br', 'joseangelo.melo@cdlbh.com.br', 'rcheiricatti@gmail.com', 'breendon.almeida@gmail.com', 'flavioizac@gmail.com', 'bruno.sbraletta@gmail.com', 'hg.leticia@gmail.com', 'lucaspitta@targetfroras.com.br', 'ana.arrunategui@buffalodigital.com.br', 'ana.souza@buffalodigital.com.br', 'andy.monterei@buffalodigital.com.br', 'andre.doyle@buffalodigital.com.br', 'filippe.leite@buffalodigital.com.br', 'francis.willian@buffalodigital.com.br', 'jordana.ferreira@buffalodigital.com.br', 'larissa.soares@buffalodigital.com.br', 'lucas.vilasboas@buffalodigital.com.br', 'mayra.abeki@buffalodigital.com.br', 'patricia.oliveira@buffalodigital.com.br', 'rafael.guilherme@buffalodigital.com.br', 'samira.dias@buffalodigital.com.br', 'thais.barbian@buffalodigital.com.br', 'claudio.batitucci@partners360.com.br', 'analuisaarrunategui@gmail.com', 'clayton.lisboa@buffalodigital.com.br', 'bruno.henrique@repetreciclagem.com.br', 'np@healthsafetytech.com', 'alexsandrarmatos@gmail.com', 'alexa@etcetal.com.br', 'adm01@healthsafetytech.com', 'hylderosa@gmail.com', 'mayaradias.tur@gmail.com', 'digowars@gmail.com', 'daniel.gaia@varejaodastintas.com.br', 'aangrisano@gmail.com', 'test_with_password_1768589940269@example.com', 'test_without_password_1768589940874@example.com', 'rnrsouza@hotmail.com', 'kawbicalho@gmail.com', 'GABIDIASJ@GMAIL.COM', 'financeiro01@healthsafetytech.com', 'comercial01@healthsafetytech.com', 'qualidade01@healthsafetytech.com', 'servicos01@healthsafetytech.com', 'laboratorio01@healthsafetytech.com', 'expedicao01@healthsafetytech.com', 'ti@healthsafetytech.com', 'expedicao02@healthsafetytech.com', 'comercial02@healthsafetytech.com', 'ti02@healthsafetytech.com', 'comercial03@healthsafetytech.com', 'comercial04@healthsafetytech.com', 'qualidade02@healthsafetytech.com', 'servicos02@healthsafetytech.com', 'laboratorio02@healthsafetytech.com', 'expedicao03@healthsafetytech.com', 'suporte01@healthsafetytech.com', 'comercial05@healthsafetytech.com', 'suporte02@healthsafetytech.com', 'ti03@healthsafetytech.com', 'surama@etcetal.com.br', 'walbertsantos@gmail.com', 'sdr3@healthsafety.com.br', 'adriana_diana_oliveira@hotmail.com', 'gynunes62@gmail.com', 'djalmanetobeto@gmail.com', 'sandraa.cristina@hotmail.com', 'gopme12@gmail.com', 'weltonkellyson24@gmail.com', 'sdr1@healthsafety.com.br', 'gmswanderley@gmail.com', 'suelenpatricia957@gmail.com', 'rickelmepe@gmail.com', 'suelenpatricia957@gmai.com', 'ellenelis87@gmail.com', 'lucas.azevedo3009@gmail.com', 'leandroepronto3.1lvs@gmail.com', 'fabianodinizsantos@gmail.com', 'rgcaetanofujitsu@gmail.com', 'giancarlodalmulin@gmail.com', 'ronetju2019@gmail.com', 'valeria.educacional@gmail.com', 'dede_rangel@yahoo.com.br', 'renato.correa@oktz.com.br', 'institutoalupo@gmail.com', 'fabio.marfer@gmail.com', 'welintonsilva690@gmail.com', 'jrmagrafil@gmail.com', 'lua77@uol.com.br', 'Marcoamojr@gmail.com', 'julianacosta_15@hotmail.com', 'fernanda_arceno@hotmail.com', 'mauriciosilva1590@gmail.com', 'amiltonguedes2009@gmail.com', 'viniciusleal@ymail.com', 'gilberto.maranhao78@gmail.com', 'jocemarmartinscalado@gmail.com', 'ricardo.a.m.tomita@gmail.com', 'ljordaosilva@gmail.com', 'marpugliesi@gmail.com', 'pedro@reclick.com.br', 'fabmontsant@gmail.com', 'europalugares@gmail.com', 'gildevamjunior@hotmail.com', 'alexandre.diniz.cesar@gmail.com', 'gabrieladauer@gmail.com', 'claudenice_lem@hotmail.com', 'art3dstd@gmail.com', 'valdeirsantos891@gmail.com', 'ta.993810275@gmail.com', 'ruiterfidencio@gmail.com', 'eliemarbueno@gmail.com', 'andreiacbarreto@gmail.com', 'doromarra@hotmail.com', 'suelenribeiro@gestaomatriz.com.br', 'grodriguez@piattino.com.br', 'lcsxavier@hotmail.com', 'brunaarruda1712@gmail.com', 'maisahfm@gmail.com', 'gccotia.combate@gmail.com', 'jubettini@gmail.com', 'rmatoscarina@gmail.com', 'gkgloballink@gmail.com', 'mariaeduardabranco1991@gmail.com', 'jornalistapatriciateixeira@gmail.com', 'elisapj@hotmail.com', 'harmonia5x.mentorias@gmail.com', 'savanazamai@gmail.com', 'phabioliveira@gmail.com', 'frs8176@gmail.com', 'unapackembalagens@gmail.com', 'taisfaria1@gmail.com', 'ronetju@yahoo.com.br', 'lilianc21@yahoo.com', 'getulioairescorretorimoveis@gmail.com', 'kimberly_suellen@hotmail.com', 'giselleas@hotmail.com', 'maurina26mbk@gmail.com', 'helenafcr@gmail.com', 'alle-lima2011@hotmail.com', 'larissa21_assis@outlook.com', 'junioalmeida1994@gmail.com', 'turossizah@gmail.com', 'patriciaas.antao@gmail.com', 'rosellirozendo@gmail.com', 'juliane.vieira@claro.com.br', 'mariribeiro14071982@gmail.com', 'dennilsonjl@gmail.com', 'liliane.soberana@gmail.com', 'isaacgomesrdf@gmail.com', 'RODRIGOFERNANDESCONTABILIDADE@GMAIL.COM', 'carloscerbbinno@gmail.com', 'esmirnacv@yahoo.com.br', 'phaty17@gmail.com', 'marceloffranco@glook.com.br', 'ribeiroola@gmail.com', 'larissa.almeida@grupomultilaser.com.br', 'marcela@artesacramoda.com.br', 'milamreis@hotmail.com', 'rafaelfarreb@gmail.com', 'marcosdelnero.apps@gmail.com', 'or-debora@outlook.com', 'joaoricardodinizsilva@gmail.com', 'leandrotsmachado@gmail.com', 'luiza.deschamps@hotmail.com', 'brunnacampos01@hotmail.com', 'buenocurador@gmail.com', 'joaovicenterf@gmail.com', 'izabela.sdutra@gmail.com', 'alessandra.cso@gmail.com', 'giboanapaula@hotmail.com', 'gladyslimabio@yahoo.com.br', 'julietanferreira@gmail.com', 'mariannarezende@gmail.com', 'mialine_vale@yahoo.com.br', 'edmilsonrossi@gmail.com', 'profpedromarcio@hotmail.com', 'heronguatiello@gmail.com', 'alexsandra@dnia.ai', 'rodrigoferreira077@gmail.com', 'lanich2014@gmail.com', 'heitorfrancisco2005@hotmail.com', 'ketlenmac@gmail.com', 'ttjpopo@gmail.com', 'Alaideoliveiralongo@hotmail.com', 'barbarabenvenu@gmail.com', 'janecpq76@gmail.com', 'lalla.nathania@gmail.com', 'mendesana39@gmail.com', 'bertellojulia@gmail.com', 'carolina@artesacramoda.com.br', 'reporterivane@yahoo.com.br', 'rmartins.2306@gmail.com', 'marcelalazza@gmail.com', 'carlatutschkeanalistacorporal@gmail.com', 'carla.mariana70@hotmail.com', 'assislarissa2023@gmail.com', 'paollacolli@gmail.com', 'santogabriel13@gmail.com', 'mssuribeiro@yahoo.com.br', 'vivi.noronha2009@hotmail.com', 'caiofran746@gmail.com', 'caredufisio@gmail.com', 'adrianavidal@flourish.com.br', 'setrini@uol.com.br', 'danianemd@yahoo.com.br', 'cmartire@hotmail.com', 'izaloredo.mkt@gmail.com', 'priscilasoares02@yahoo.com.br', 'ariane.santiago0112@gmail.com', 'rafael6ptc@hotmail.com', 'mulherrealeza01@gmail.com', 'patriciarezende22@hotmail.com', 'aniekarenina@gmail.com', 'esleycastelar@gmail.com', 'frankybarbosa56@gmail.com', 'gracekpassos@gmail.com', 'Thalia.dahora@outlook.com', 'luizfernando.maluf@gmail.com', 'djesmi@hotmail.com', 'jsepifanio2@gmail.com', 'normandia@dnaia.ai', 'teste.1770407502698.295.1@loadtest.com', 'teste.1770407502828.1808.65@loadtest.com', 'teste.1770407502776.3720.3@loadtest.com', 'teste.1770407502835.7735.75@loadtest.com', 'teste.1770407502840.1592.82@loadtest.com', 'teste.1770407502778.6251.4@loadtest.com', 'teste.1770407502832.9984.70@loadtest.com', 'teste.1770407502780.1844.6@loadtest.com', 'teste.1770407502781.2325.7@loadtest.com', 'teste.1770407502787.4792.10@loadtest.com', 'teste.1770407502838.7504.79@loadtest.com', 'teste.1770407502790.5763.14@loadtest.com', 'teste.1770407502774.8536.2@loadtest.com', 'teste.1770407502794.8959.19@loadtest.com', 'teste.1770407502779.6787.5@loadtest.com', 'teste.1770407502783.5086.9@loadtest.com', 'teste.1770407502791.8698.15@loadtest.com', 'teste.1770407502788.3329.11@loadtest.com', 'teste.1770407502793.4788.18@loadtest.com', 'teste.1770407502799.9290.26@loadtest.com', 'teste.1770407502792.1908.16@loadtest.com', 'teste.1770407502790.6360.13@loadtest.com', 'teste.1770407502782.1842.8@loadtest.com', 'teste.1770407502794.2994.20@loadtest.com', 'teste.1770407502792.5820.17@loadtest.com', 'teste.1770407502797.9054.24@loadtest.com', 'teste.1770407502789.2226.12@loadtest.com', 'teste.1770407502795.633.21@loadtest.com', 'teste.1770407502799.4935.27@loadtest.com', 'teste.1770407502797.88.23@loadtest.com', 'teste.1770407502800.3937.28@loadtest.com', 'teste.1770407502809.8639.40@loadtest.com', 'teste.1770407502796.2487.22@loadtest.com', 'teste.1770407502798.3500.25@loadtest.com', 'teste.1770407502844.9283.85@loadtest.com', 'teste.1770407502812.7425.44@loadtest.com', 'teste.1770407502817.1818.51@loadtest.com', 'teste.1770407502801.7249.29@loadtest.com', 'teste.1770407502804.838.33@loadtest.com', 'teste.1770407502807.2556.38@loadtest.com', 'teste.1770407502802.5574.31@loadtest.com', 'teste.1770407502807.8803.37@loadtest.com', 'teste.1770407502805.3595.34@loadtest.com', 'teste.1770407502810.1305.42@loadtest.com', 'teste.1770407502803.639.32@loadtest.com', 'teste.1770407502813.4674.46@loadtest.com', 'teste.1770407502814.5100.48@loadtest.com', 'teste.1770407502814.91.47@loadtest.com', 'teste.1770407502812.6317.45@loadtest.com', 'teste.1770407502821.686.55@loadtest.com', 'teste.1770407502802.9551.30@loadtest.com', 'teste.1770407502824.6799.59@loadtest.com', 'teste.1770407502825.7736.61@loadtest.com', 'teste.1770407502854.3743.100@loadtest.com', 'teste.1770407502837.7792.77@loadtest.com', 'teste.1770407502820.3572.53@loadtest.com', 'teste.1770407502816.7977.50@loadtest.com', 'teste.1770407502822.3591.56@loadtest.com', 'teste.1770407502848.3271.91@loadtest.com', 'teste.1770407502820.7427.54@loadtest.com', 'teste.1770407502806.7146.36@loadtest.com', 'teste.1770407502823.5604.58@loadtest.com', 'teste.1770407502815.8109.49@loadtest.com', 'teste.1770407502829.7652.66@loadtest.com', 'teste.1770407502831.8929.69@loadtest.com', 'teste.1770407502830.6365.68@loadtest.com', 'teste.1770407502849.6833.93@loadtest.com', 'teste.1770407502852.4811.96@loadtest.com', 'teste.1770407502822.2671.57@loadtest.com', 'teste.1770407502828.3342.64@loadtest.com', 'teste.1770407502836.5557.76@loadtest.com', 'teste.1770407502838.1172.78@loadtest.com', 'teste.1770407502833.6207.71@loadtest.com', 'teste.1770407502808.6910.39@loadtest.com', 'teste.1770407502809.9820.41@loadtest.com', 'teste.1770407502833.5914.72@loadtest.com', 'teste.1770407502830.2584.67@loadtest.com', 'teste.1770407502834.8835.73@loadtest.com', 'teste.1770407502843.5992.83@loadtest.com', 'teste.1770407502811.3994.43@loadtest.com', 'teste.1770407502826.6293.62@loadtest.com', 'teste.1770407502819.622.52@loadtest.com', 'teste.1770407502840.9087.81@loadtest.com', 'teste.1770407502845.1246.86@loadtest.com', 'teste.1770407502835.7276.74@loadtest.com', 'teste.1770407502851.9235.95@loadtest.com', 'teste.1770407502850.4530.94@loadtest.com', 'teste.1770407502843.6905.84@loadtest.com', 'teste.1770407502805.4344.35@loadtest.com', 'teste.1770407502845.4977.87@loadtest.com', 'teste.1770407502847.5521.89@loadtest.com', 'teste.1770407502827.3784.63@loadtest.com', 'teste.1770407502853.9817.98@loadtest.com', 'teste.1770407502852.2289.97@loadtest.com', 'teste.1770407502846.2061.88@loadtest.com', 'teste.1770407502854.7936.99@loadtest.com', 'teste.1770407502825.8057.60@loadtest.com', 'teste.1770407502839.4597.80@loadtest.com', 'teste.1770407502849.994.92@loadtest.com', 'teste.1770407502847.5668.90@loadtest.com', 'teste.1770407690211.1531.3@loadtest.com', 'teste.1770407690212.586.4@loadtest.com', 'teste.1770407690243.8803.37@loadtest.com', 'teste.1770407690209.3334.2@loadtest.com', 'teste.1770407690235.1067.26@loadtest.com', 'teste.1770407690227.6234.15@loadtest.com', 'teste.1770407690241.4133.35@loadtest.com', 'teste.1770407690276.7795.79@loadtest.com', 'teste.1770407690215.2245.6@loadtest.com', 'teste.1770407690244.3322.38@loadtest.com', 'teste.1770407690216.9743.7@loadtest.com', 'teste.1770407690227.9576.16@loadtest.com', 'teste.1770407690219.4381.9@loadtest.com', 'teste.1770407690228.9114.17@loadtest.com', 'teste.1770407690214.3263.5@loadtest.com', 'teste.1770407690217.3651.8@loadtest.com', 'teste.1770407690223.2026.11@loadtest.com', 'teste.1770407690232.3655.23@loadtest.com', 'teste.1770407690225.8671.13@loadtest.com', 'teste.1770407690226.6602.14@loadtest.com', 'teste.1770407690133.9371.1@loadtest.com', 'teste.1770407690224.7187.12@loadtest.com', 'teste.1770407690222.1109.10@loadtest.com', 'teste.1770407690229.7066.18@loadtest.com', 'teste.1770407690233.7493.24@loadtest.com', 'teste.1770407690238.2076.30@loadtest.com', 'teste.1770407690231.9376.21@loadtest.com', 'teste.1770407690237.9313.29@loadtest.com', 'teste.1770407690234.1856.25@loadtest.com', 'teste.1770407690230.669.19@loadtest.com', 'teste.1770407690240.3703.33@loadtest.com', 'teste.1770407690241.5217.34@loadtest.com', 'teste.1770407690230.664.20@loadtest.com', 'teste.1770407690235.9352.27@loadtest.com', 'teste.1770407690261.2597.59@loadtest.com', 'teste.1770407690250.1441.47@loadtest.com', 'teste.1770407690242.5416.36@loadtest.com', 'teste.1770407690236.9777.28@loadtest.com', 'teste.1770407690244.4796.39@loadtest.com', 'teste.1770407690262.4676.60@loadtest.com', 'teste.1770407690256.6181.52@loadtest.com', 'teste.1770407690249.4124.45@loadtest.com', 'teste.1770407690251.2476.48@loadtest.com', 'teste.1770407690252.6543.49@loadtest.com', 'teste.1770407690263.5572.62@loadtest.com', 'teste.1770407690279.5335.83@loadtest.com', 'teste.1770407690245.4292.40@loadtest.com', 'teste.1770407690246.9634.41@loadtest.com', 'teste.1770407690254.2193.51@loadtest.com', 'teste.1770407690257.7651.54@loadtest.com', 'teste.1770407690232.2707.22@loadtest.com', 'teste.1770407690258.7258.55@loadtest.com', 'teste.1770407690247.3088.43@loadtest.com', 'teste.1770407690274.1180.76@loadtest.com', 'teste.1770407690253.8130.50@loadtest.com', 'teste.1770407690250.8937.46@loadtest.com', 'teste.1770407690265.4490.64@loadtest.com', 'teste.1770407690248.2256.44@loadtest.com', 'teste.1770407690281.7460.84@loadtest.com', 'teste.1770407690283.8010.86@loadtest.com', 'teste.1770407690275.4523.77@loadtest.com', 'teste.1770407690257.5140.53@loadtest.com', 'teste.1770407690293.9610.99@loadtest.com', 'teste.1770407690266.5394.65@loadtest.com', 'teste.1770407690285.707.89@loadtest.com', 'teste.1770407690259.3613.57@loadtest.com', 'teste.1770407690239.8981.32@loadtest.com', 'teste.1770407690269.2108.69@loadtest.com', 'teste.1770407690266.1306.66@loadtest.com', 'teste.1770407690260.2867.58@loadtest.com', 'teste.1770407690272.7699.73@loadtest.com', 'teste.1770407690292.4846.98@loadtest.com', 'teste.1770407690268.1461.68@loadtest.com', 'teste.1770407690259.896.56@loadtest.com', 'teste.1770407690275.2336.78@loadtest.com', 'teste.1770407690286.1329.90@loadtest.com', 'teste.1770407690269.3864.70@loadtest.com', 'teste.1770407690267.8922.67@loadtest.com', 'teste.1770407690284.5400.88@loadtest.com', 'teste.1770407690284.3688.87@loadtest.com', 'teste.1770407690288.1226.92@loadtest.com', 'teste.1770407690287.6472.91@loadtest.com', 'teste.1770407690272.6007.74@loadtest.com', 'teste.1770407690278.7691.81@loadtest.com', 'teste.1770407690273.133.75@loadtest.com', 'teste.1770407690277.315.80@loadtest.com', 'teste.1770407690271.6031.72@loadtest.com', 'teste.1770407690288.5286.93@loadtest.com', 'teste.1770407690263.6656.61@loadtest.com', 'teste.1770407690270.4469.71@loadtest.com', 'teste.1770407690293.7925.100@loadtest.com', 'teste.1770407690278.9123.82@loadtest.com', 'teste.1770407690238.7458.31@loadtest.com', 'teste.1770407690289.3187.94@loadtest.com', 'teste.1770407690290.3492.95@loadtest.com', 'teste.1770407690247.4761.42@loadtest.com', 'teste.1770407690290.8948.96@loadtest.com', 'teste.1770407690291.1591.97@loadtest.com', 'teste.1770407690264.6182.63@loadtest.com', 'teste.1770407690282.2169.85@loadtest.com', 'rcantareira@gmail.com', 'brunarbsemijoias@com.br'));
DELETE FROM auth.identities WHERE user_id IN (SELECT id FROM auth.users WHERE email IN ('operacoes@buscarid.com', 'rodrigonormandia@buscarid.com', 'kaw@buscarid.com', 'jussara@buscarid.com', 'draflaviareumatobh@gmail.com', 'rodrigo@sabecomo.com.br', 'nicholsongp@gmail.com', 'andrewafonso@gmail.com', 'anie.karenina@buffalodigital.com.br', 'fernandojin@gmail.com', 'danielgaia13@gmail.com', 'filipejclopes@gmail.com', 'sura.carvalho@gmail.com', 'renatolopesevolve@gmail.com', 'leticia@maxupconsultoria.com.br', 'rbetasim@gmail.com', 'evalarissa157@gmail.com', 'lalacorrea@gmail.com', 'henriquehamerski@gmail.com', 'leodavidrotela91@gmail.com', 'maia.jpm@gmail.com', 'dayane@maxupconsultoria.com.br', 'christianobsr@gmail.com', 'andradegoval2013@gmail.com', 'maugustocand@gmail.com', 'raquel@albanezemaia.adv.br', 'francis@maxupconsultoria.com.br', 'admin@teste.com', 'carol@buscarid.com', 'rodrigo@buscarid.com', 'duponce.mcc@gmail.com', 'lukedepaulo@gmail.com', 'jessica.maia@fundacaocdlbh.org.br', 'guilherme@ctrl.cnt.br', 'renato_godinho@hotmail.com', 'augustoizac@gmail.con', 'alysson.guimaraes@cdlbh.com.br', 'emelygaspar@gmail.com', 'adrianoboscatte@gmail.com', 'luisa@cpbellaperfumes.com.br', 'gabriel.junqueira@avancoinfo.com.br', 'joas_pessoa@hotmail.com', 'marlucio.silva@fundacaocdlbh.org', 'brunarpn@gmail.com', 'debora.com.mkt@gmail.com', 'brenoduarte@hotmail.com', 'wadir@bellaboticario.com.br', 'joseangelo@bellaboticario.com.br', 'junioramerico@atsinformatica.com.br', 'ulissessamarone@gmail.com', 'carloseduardo.cacaushowbh@gmail.com', 'carloeduardo@gmail.com', 'joaovictor@cdlbh.com.br', 'analaraest@icloud.com', 'hitalocarvalho@gmail.com', 'anakarlamoraisg@gmail.com', 'isis.or.natural@gmail.com', 'aquilis.moreira@oktz.com.br', 'k.raquelferreira@gmail.com', 'gabrielvfalci@gmail.com', 'hellenmr87@yahoo.com.br', 'alexandresantos@smcit.com.br', 'faustocasabranca@gmail.com', 'camilarvalentim@gmail.com', 'nayaralcampos@gmail.com', 'vilson.mayrink@gmail.com', 'mflaviocs@gmail.com', 'leocamargo@yahoo.com', 'contato@uaiviajei.com.br', 'joel.souza@cdlbh.com.br', 'joseangelo.melo@cdlbh.com.br', 'rcheiricatti@gmail.com', 'breendon.almeida@gmail.com', 'flavioizac@gmail.com', 'bruno.sbraletta@gmail.com', 'hg.leticia@gmail.com', 'lucaspitta@targetfroras.com.br', 'ana.arrunategui@buffalodigital.com.br', 'ana.souza@buffalodigital.com.br', 'andy.monterei@buffalodigital.com.br', 'andre.doyle@buffalodigital.com.br', 'filippe.leite@buffalodigital.com.br', 'francis.willian@buffalodigital.com.br', 'jordana.ferreira@buffalodigital.com.br', 'larissa.soares@buffalodigital.com.br', 'lucas.vilasboas@buffalodigital.com.br', 'mayra.abeki@buffalodigital.com.br', 'patricia.oliveira@buffalodigital.com.br', 'rafael.guilherme@buffalodigital.com.br', 'samira.dias@buffalodigital.com.br', 'thais.barbian@buffalodigital.com.br', 'claudio.batitucci@partners360.com.br', 'analuisaarrunategui@gmail.com', 'clayton.lisboa@buffalodigital.com.br', 'bruno.henrique@repetreciclagem.com.br', 'np@healthsafetytech.com', 'alexsandrarmatos@gmail.com', 'alexa@etcetal.com.br', 'adm01@healthsafetytech.com', 'hylderosa@gmail.com', 'mayaradias.tur@gmail.com', 'digowars@gmail.com', 'daniel.gaia@varejaodastintas.com.br', 'aangrisano@gmail.com', 'test_with_password_1768589940269@example.com', 'test_without_password_1768589940874@example.com', 'rnrsouza@hotmail.com', 'kawbicalho@gmail.com', 'GABIDIASJ@GMAIL.COM', 'financeiro01@healthsafetytech.com', 'comercial01@healthsafetytech.com', 'qualidade01@healthsafetytech.com', 'servicos01@healthsafetytech.com', 'laboratorio01@healthsafetytech.com', 'expedicao01@healthsafetytech.com', 'ti@healthsafetytech.com', 'expedicao02@healthsafetytech.com', 'comercial02@healthsafetytech.com', 'ti02@healthsafetytech.com', 'comercial03@healthsafetytech.com', 'comercial04@healthsafetytech.com', 'qualidade02@healthsafetytech.com', 'servicos02@healthsafetytech.com', 'laboratorio02@healthsafetytech.com', 'expedicao03@healthsafetytech.com', 'suporte01@healthsafetytech.com', 'comercial05@healthsafetytech.com', 'suporte02@healthsafetytech.com', 'ti03@healthsafetytech.com', 'surama@etcetal.com.br', 'walbertsantos@gmail.com', 'sdr3@healthsafety.com.br', 'adriana_diana_oliveira@hotmail.com', 'gynunes62@gmail.com', 'djalmanetobeto@gmail.com', 'sandraa.cristina@hotmail.com', 'gopme12@gmail.com', 'weltonkellyson24@gmail.com', 'sdr1@healthsafety.com.br', 'gmswanderley@gmail.com', 'suelenpatricia957@gmail.com', 'rickelmepe@gmail.com', 'suelenpatricia957@gmai.com', 'ellenelis87@gmail.com', 'lucas.azevedo3009@gmail.com', 'leandroepronto3.1lvs@gmail.com', 'fabianodinizsantos@gmail.com', 'rgcaetanofujitsu@gmail.com', 'giancarlodalmulin@gmail.com', 'ronetju2019@gmail.com', 'valeria.educacional@gmail.com', 'dede_rangel@yahoo.com.br', 'renato.correa@oktz.com.br', 'institutoalupo@gmail.com', 'fabio.marfer@gmail.com', 'welintonsilva690@gmail.com', 'jrmagrafil@gmail.com', 'lua77@uol.com.br', 'Marcoamojr@gmail.com', 'julianacosta_15@hotmail.com', 'fernanda_arceno@hotmail.com', 'mauriciosilva1590@gmail.com', 'amiltonguedes2009@gmail.com', 'viniciusleal@ymail.com', 'gilberto.maranhao78@gmail.com', 'jocemarmartinscalado@gmail.com', 'ricardo.a.m.tomita@gmail.com', 'ljordaosilva@gmail.com', 'marpugliesi@gmail.com', 'pedro@reclick.com.br', 'fabmontsant@gmail.com', 'europalugares@gmail.com', 'gildevamjunior@hotmail.com', 'alexandre.diniz.cesar@gmail.com', 'gabrieladauer@gmail.com', 'claudenice_lem@hotmail.com', 'art3dstd@gmail.com', 'valdeirsantos891@gmail.com', 'ta.993810275@gmail.com', 'ruiterfidencio@gmail.com', 'eliemarbueno@gmail.com', 'andreiacbarreto@gmail.com', 'doromarra@hotmail.com', 'suelenribeiro@gestaomatriz.com.br', 'grodriguez@piattino.com.br', 'lcsxavier@hotmail.com', 'brunaarruda1712@gmail.com', 'maisahfm@gmail.com', 'gccotia.combate@gmail.com', 'jubettini@gmail.com', 'rmatoscarina@gmail.com', 'gkgloballink@gmail.com', 'mariaeduardabranco1991@gmail.com', 'jornalistapatriciateixeira@gmail.com', 'elisapj@hotmail.com', 'harmonia5x.mentorias@gmail.com', 'savanazamai@gmail.com', 'phabioliveira@gmail.com', 'frs8176@gmail.com', 'unapackembalagens@gmail.com', 'taisfaria1@gmail.com', 'ronetju@yahoo.com.br', 'lilianc21@yahoo.com', 'getulioairescorretorimoveis@gmail.com', 'kimberly_suellen@hotmail.com', 'giselleas@hotmail.com', 'maurina26mbk@gmail.com', 'helenafcr@gmail.com', 'alle-lima2011@hotmail.com', 'larissa21_assis@outlook.com', 'junioalmeida1994@gmail.com', 'turossizah@gmail.com', 'patriciaas.antao@gmail.com', 'rosellirozendo@gmail.com', 'juliane.vieira@claro.com.br', 'mariribeiro14071982@gmail.com', 'dennilsonjl@gmail.com', 'liliane.soberana@gmail.com', 'isaacgomesrdf@gmail.com', 'RODRIGOFERNANDESCONTABILIDADE@GMAIL.COM', 'carloscerbbinno@gmail.com', 'esmirnacv@yahoo.com.br', 'phaty17@gmail.com', 'marceloffranco@glook.com.br', 'ribeiroola@gmail.com', 'larissa.almeida@grupomultilaser.com.br', 'marcela@artesacramoda.com.br', 'milamreis@hotmail.com', 'rafaelfarreb@gmail.com', 'marcosdelnero.apps@gmail.com', 'or-debora@outlook.com', 'joaoricardodinizsilva@gmail.com', 'leandrotsmachado@gmail.com', 'luiza.deschamps@hotmail.com', 'brunnacampos01@hotmail.com', 'buenocurador@gmail.com', 'joaovicenterf@gmail.com', 'izabela.sdutra@gmail.com', 'alessandra.cso@gmail.com', 'giboanapaula@hotmail.com', 'gladyslimabio@yahoo.com.br', 'julietanferreira@gmail.com', 'mariannarezende@gmail.com', 'mialine_vale@yahoo.com.br', 'edmilsonrossi@gmail.com', 'profpedromarcio@hotmail.com', 'heronguatiello@gmail.com', 'alexsandra@dnia.ai', 'rodrigoferreira077@gmail.com', 'lanich2014@gmail.com', 'heitorfrancisco2005@hotmail.com', 'ketlenmac@gmail.com', 'ttjpopo@gmail.com', 'Alaideoliveiralongo@hotmail.com', 'barbarabenvenu@gmail.com', 'janecpq76@gmail.com', 'lalla.nathania@gmail.com', 'mendesana39@gmail.com', 'bertellojulia@gmail.com', 'carolina@artesacramoda.com.br', 'reporterivane@yahoo.com.br', 'rmartins.2306@gmail.com', 'marcelalazza@gmail.com', 'carlatutschkeanalistacorporal@gmail.com', 'carla.mariana70@hotmail.com', 'assislarissa2023@gmail.com', 'paollacolli@gmail.com', 'santogabriel13@gmail.com', 'mssuribeiro@yahoo.com.br', 'vivi.noronha2009@hotmail.com', 'caiofran746@gmail.com', 'caredufisio@gmail.com', 'adrianavidal@flourish.com.br', 'setrini@uol.com.br', 'danianemd@yahoo.com.br', 'cmartire@hotmail.com', 'izaloredo.mkt@gmail.com', 'priscilasoares02@yahoo.com.br', 'ariane.santiago0112@gmail.com', 'rafael6ptc@hotmail.com', 'mulherrealeza01@gmail.com', 'patriciarezende22@hotmail.com', 'aniekarenina@gmail.com', 'esleycastelar@gmail.com', 'frankybarbosa56@gmail.com', 'gracekpassos@gmail.com', 'Thalia.dahora@outlook.com', 'luizfernando.maluf@gmail.com', 'djesmi@hotmail.com', 'jsepifanio2@gmail.com', 'normandia@dnaia.ai', 'teste.1770407502698.295.1@loadtest.com', 'teste.1770407502828.1808.65@loadtest.com', 'teste.1770407502776.3720.3@loadtest.com', 'teste.1770407502835.7735.75@loadtest.com', 'teste.1770407502840.1592.82@loadtest.com', 'teste.1770407502778.6251.4@loadtest.com', 'teste.1770407502832.9984.70@loadtest.com', 'teste.1770407502780.1844.6@loadtest.com', 'teste.1770407502781.2325.7@loadtest.com', 'teste.1770407502787.4792.10@loadtest.com', 'teste.1770407502838.7504.79@loadtest.com', 'teste.1770407502790.5763.14@loadtest.com', 'teste.1770407502774.8536.2@loadtest.com', 'teste.1770407502794.8959.19@loadtest.com', 'teste.1770407502779.6787.5@loadtest.com', 'teste.1770407502783.5086.9@loadtest.com', 'teste.1770407502791.8698.15@loadtest.com', 'teste.1770407502788.3329.11@loadtest.com', 'teste.1770407502793.4788.18@loadtest.com', 'teste.1770407502799.9290.26@loadtest.com', 'teste.1770407502792.1908.16@loadtest.com', 'teste.1770407502790.6360.13@loadtest.com', 'teste.1770407502782.1842.8@loadtest.com', 'teste.1770407502794.2994.20@loadtest.com', 'teste.1770407502792.5820.17@loadtest.com', 'teste.1770407502797.9054.24@loadtest.com', 'teste.1770407502789.2226.12@loadtest.com', 'teste.1770407502795.633.21@loadtest.com', 'teste.1770407502799.4935.27@loadtest.com', 'teste.1770407502797.88.23@loadtest.com', 'teste.1770407502800.3937.28@loadtest.com', 'teste.1770407502809.8639.40@loadtest.com', 'teste.1770407502796.2487.22@loadtest.com', 'teste.1770407502798.3500.25@loadtest.com', 'teste.1770407502844.9283.85@loadtest.com', 'teste.1770407502812.7425.44@loadtest.com', 'teste.1770407502817.1818.51@loadtest.com', 'teste.1770407502801.7249.29@loadtest.com', 'teste.1770407502804.838.33@loadtest.com', 'teste.1770407502807.2556.38@loadtest.com', 'teste.1770407502802.5574.31@loadtest.com', 'teste.1770407502807.8803.37@loadtest.com', 'teste.1770407502805.3595.34@loadtest.com', 'teste.1770407502810.1305.42@loadtest.com', 'teste.1770407502803.639.32@loadtest.com', 'teste.1770407502813.4674.46@loadtest.com', 'teste.1770407502814.5100.48@loadtest.com', 'teste.1770407502814.91.47@loadtest.com', 'teste.1770407502812.6317.45@loadtest.com', 'teste.1770407502821.686.55@loadtest.com', 'teste.1770407502802.9551.30@loadtest.com', 'teste.1770407502824.6799.59@loadtest.com', 'teste.1770407502825.7736.61@loadtest.com', 'teste.1770407502854.3743.100@loadtest.com', 'teste.1770407502837.7792.77@loadtest.com', 'teste.1770407502820.3572.53@loadtest.com', 'teste.1770407502816.7977.50@loadtest.com', 'teste.1770407502822.3591.56@loadtest.com', 'teste.1770407502848.3271.91@loadtest.com', 'teste.1770407502820.7427.54@loadtest.com', 'teste.1770407502806.7146.36@loadtest.com', 'teste.1770407502823.5604.58@loadtest.com', 'teste.1770407502815.8109.49@loadtest.com', 'teste.1770407502829.7652.66@loadtest.com', 'teste.1770407502831.8929.69@loadtest.com', 'teste.1770407502830.6365.68@loadtest.com', 'teste.1770407502849.6833.93@loadtest.com', 'teste.1770407502852.4811.96@loadtest.com', 'teste.1770407502822.2671.57@loadtest.com', 'teste.1770407502828.3342.64@loadtest.com', 'teste.1770407502836.5557.76@loadtest.com', 'teste.1770407502838.1172.78@loadtest.com', 'teste.1770407502833.6207.71@loadtest.com', 'teste.1770407502808.6910.39@loadtest.com', 'teste.1770407502809.9820.41@loadtest.com', 'teste.1770407502833.5914.72@loadtest.com', 'teste.1770407502830.2584.67@loadtest.com', 'teste.1770407502834.8835.73@loadtest.com', 'teste.1770407502843.5992.83@loadtest.com', 'teste.1770407502811.3994.43@loadtest.com', 'teste.1770407502826.6293.62@loadtest.com', 'teste.1770407502819.622.52@loadtest.com', 'teste.1770407502840.9087.81@loadtest.com', 'teste.1770407502845.1246.86@loadtest.com', 'teste.1770407502835.7276.74@loadtest.com', 'teste.1770407502851.9235.95@loadtest.com', 'teste.1770407502850.4530.94@loadtest.com', 'teste.1770407502843.6905.84@loadtest.com', 'teste.1770407502805.4344.35@loadtest.com', 'teste.1770407502845.4977.87@loadtest.com', 'teste.1770407502847.5521.89@loadtest.com', 'teste.1770407502827.3784.63@loadtest.com', 'teste.1770407502853.9817.98@loadtest.com', 'teste.1770407502852.2289.97@loadtest.com', 'teste.1770407502846.2061.88@loadtest.com', 'teste.1770407502854.7936.99@loadtest.com', 'teste.1770407502825.8057.60@loadtest.com', 'teste.1770407502839.4597.80@loadtest.com', 'teste.1770407502849.994.92@loadtest.com', 'teste.1770407502847.5668.90@loadtest.com', 'teste.1770407690211.1531.3@loadtest.com', 'teste.1770407690212.586.4@loadtest.com', 'teste.1770407690243.8803.37@loadtest.com', 'teste.1770407690209.3334.2@loadtest.com', 'teste.1770407690235.1067.26@loadtest.com', 'teste.1770407690227.6234.15@loadtest.com', 'teste.1770407690241.4133.35@loadtest.com', 'teste.1770407690276.7795.79@loadtest.com', 'teste.1770407690215.2245.6@loadtest.com', 'teste.1770407690244.3322.38@loadtest.com', 'teste.1770407690216.9743.7@loadtest.com', 'teste.1770407690227.9576.16@loadtest.com', 'teste.1770407690219.4381.9@loadtest.com', 'teste.1770407690228.9114.17@loadtest.com', 'teste.1770407690214.3263.5@loadtest.com', 'teste.1770407690217.3651.8@loadtest.com', 'teste.1770407690223.2026.11@loadtest.com', 'teste.1770407690232.3655.23@loadtest.com', 'teste.1770407690225.8671.13@loadtest.com', 'teste.1770407690226.6602.14@loadtest.com', 'teste.1770407690133.9371.1@loadtest.com', 'teste.1770407690224.7187.12@loadtest.com', 'teste.1770407690222.1109.10@loadtest.com', 'teste.1770407690229.7066.18@loadtest.com', 'teste.1770407690233.7493.24@loadtest.com', 'teste.1770407690238.2076.30@loadtest.com', 'teste.1770407690231.9376.21@loadtest.com', 'teste.1770407690237.9313.29@loadtest.com', 'teste.1770407690234.1856.25@loadtest.com', 'teste.1770407690230.669.19@loadtest.com', 'teste.1770407690240.3703.33@loadtest.com', 'teste.1770407690241.5217.34@loadtest.com', 'teste.1770407690230.664.20@loadtest.com', 'teste.1770407690235.9352.27@loadtest.com', 'teste.1770407690261.2597.59@loadtest.com', 'teste.1770407690250.1441.47@loadtest.com', 'teste.1770407690242.5416.36@loadtest.com', 'teste.1770407690236.9777.28@loadtest.com', 'teste.1770407690244.4796.39@loadtest.com', 'teste.1770407690262.4676.60@loadtest.com', 'teste.1770407690256.6181.52@loadtest.com', 'teste.1770407690249.4124.45@loadtest.com', 'teste.1770407690251.2476.48@loadtest.com', 'teste.1770407690252.6543.49@loadtest.com', 'teste.1770407690263.5572.62@loadtest.com', 'teste.1770407690279.5335.83@loadtest.com', 'teste.1770407690245.4292.40@loadtest.com', 'teste.1770407690246.9634.41@loadtest.com', 'teste.1770407690254.2193.51@loadtest.com', 'teste.1770407690257.7651.54@loadtest.com', 'teste.1770407690232.2707.22@loadtest.com', 'teste.1770407690258.7258.55@loadtest.com', 'teste.1770407690247.3088.43@loadtest.com', 'teste.1770407690274.1180.76@loadtest.com', 'teste.1770407690253.8130.50@loadtest.com', 'teste.1770407690250.8937.46@loadtest.com', 'teste.1770407690265.4490.64@loadtest.com', 'teste.1770407690248.2256.44@loadtest.com', 'teste.1770407690281.7460.84@loadtest.com', 'teste.1770407690283.8010.86@loadtest.com', 'teste.1770407690275.4523.77@loadtest.com', 'teste.1770407690257.5140.53@loadtest.com', 'teste.1770407690293.9610.99@loadtest.com', 'teste.1770407690266.5394.65@loadtest.com', 'teste.1770407690285.707.89@loadtest.com', 'teste.1770407690259.3613.57@loadtest.com', 'teste.1770407690239.8981.32@loadtest.com', 'teste.1770407690269.2108.69@loadtest.com', 'teste.1770407690266.1306.66@loadtest.com', 'teste.1770407690260.2867.58@loadtest.com', 'teste.1770407690272.7699.73@loadtest.com', 'teste.1770407690292.4846.98@loadtest.com', 'teste.1770407690268.1461.68@loadtest.com', 'teste.1770407690259.896.56@loadtest.com', 'teste.1770407690275.2336.78@loadtest.com', 'teste.1770407690286.1329.90@loadtest.com', 'teste.1770407690269.3864.70@loadtest.com', 'teste.1770407690267.8922.67@loadtest.com', 'teste.1770407690284.5400.88@loadtest.com', 'teste.1770407690284.3688.87@loadtest.com', 'teste.1770407690288.1226.92@loadtest.com', 'teste.1770407690287.6472.91@loadtest.com', 'teste.1770407690272.6007.74@loadtest.com', 'teste.1770407690278.7691.81@loadtest.com', 'teste.1770407690273.133.75@loadtest.com', 'teste.1770407690277.315.80@loadtest.com', 'teste.1770407690271.6031.72@loadtest.com', 'teste.1770407690288.5286.93@loadtest.com', 'teste.1770407690263.6656.61@loadtest.com', 'teste.1770407690270.4469.71@loadtest.com', 'teste.1770407690293.7925.100@loadtest.com', 'teste.1770407690278.9123.82@loadtest.com', 'teste.1770407690238.7458.31@loadtest.com', 'teste.1770407690289.3187.94@loadtest.com', 'teste.1770407690290.3492.95@loadtest.com', 'teste.1770407690247.4761.42@loadtest.com', 'teste.1770407690290.8948.96@loadtest.com', 'teste.1770407690291.1591.97@loadtest.com', 'teste.1770407690264.6182.63@loadtest.com', 'teste.1770407690282.2169.85@loadtest.com', 'rcantareira@gmail.com', 'brunarbsemijoias@com.br'));
DELETE FROM auth.users WHERE email IN ('operacoes@buscarid.com', 'rodrigonormandia@buscarid.com', 'kaw@buscarid.com', 'jussara@buscarid.com', 'draflaviareumatobh@gmail.com', 'rodrigo@sabecomo.com.br', 'nicholsongp@gmail.com', 'andrewafonso@gmail.com', 'anie.karenina@buffalodigital.com.br', 'fernandojin@gmail.com', 'danielgaia13@gmail.com', 'filipejclopes@gmail.com', 'sura.carvalho@gmail.com', 'renatolopesevolve@gmail.com', 'leticia@maxupconsultoria.com.br', 'rbetasim@gmail.com', 'evalarissa157@gmail.com', 'lalacorrea@gmail.com', 'henriquehamerski@gmail.com', 'leodavidrotela91@gmail.com', 'maia.jpm@gmail.com', 'dayane@maxupconsultoria.com.br', 'christianobsr@gmail.com', 'andradegoval2013@gmail.com', 'maugustocand@gmail.com', 'raquel@albanezemaia.adv.br', 'francis@maxupconsultoria.com.br', 'admin@teste.com', 'carol@buscarid.com', 'rodrigo@buscarid.com', 'duponce.mcc@gmail.com', 'lukedepaulo@gmail.com', 'jessica.maia@fundacaocdlbh.org.br', 'guilherme@ctrl.cnt.br', 'renato_godinho@hotmail.com', 'augustoizac@gmail.con', 'alysson.guimaraes@cdlbh.com.br', 'emelygaspar@gmail.com', 'adrianoboscatte@gmail.com', 'luisa@cpbellaperfumes.com.br', 'gabriel.junqueira@avancoinfo.com.br', 'joas_pessoa@hotmail.com', 'marlucio.silva@fundacaocdlbh.org', 'brunarpn@gmail.com', 'debora.com.mkt@gmail.com', 'brenoduarte@hotmail.com', 'wadir@bellaboticario.com.br', 'joseangelo@bellaboticario.com.br', 'junioramerico@atsinformatica.com.br', 'ulissessamarone@gmail.com', 'carloseduardo.cacaushowbh@gmail.com', 'carloeduardo@gmail.com', 'joaovictor@cdlbh.com.br', 'analaraest@icloud.com', 'hitalocarvalho@gmail.com', 'anakarlamoraisg@gmail.com', 'isis.or.natural@gmail.com', 'aquilis.moreira@oktz.com.br', 'k.raquelferreira@gmail.com', 'gabrielvfalci@gmail.com', 'hellenmr87@yahoo.com.br', 'alexandresantos@smcit.com.br', 'faustocasabranca@gmail.com', 'camilarvalentim@gmail.com', 'nayaralcampos@gmail.com', 'vilson.mayrink@gmail.com', 'mflaviocs@gmail.com', 'leocamargo@yahoo.com', 'contato@uaiviajei.com.br', 'joel.souza@cdlbh.com.br', 'joseangelo.melo@cdlbh.com.br', 'rcheiricatti@gmail.com', 'breendon.almeida@gmail.com', 'flavioizac@gmail.com', 'bruno.sbraletta@gmail.com', 'hg.leticia@gmail.com', 'lucaspitta@targetfroras.com.br', 'ana.arrunategui@buffalodigital.com.br', 'ana.souza@buffalodigital.com.br', 'andy.monterei@buffalodigital.com.br', 'andre.doyle@buffalodigital.com.br', 'filippe.leite@buffalodigital.com.br', 'francis.willian@buffalodigital.com.br', 'jordana.ferreira@buffalodigital.com.br', 'larissa.soares@buffalodigital.com.br', 'lucas.vilasboas@buffalodigital.com.br', 'mayra.abeki@buffalodigital.com.br', 'patricia.oliveira@buffalodigital.com.br', 'rafael.guilherme@buffalodigital.com.br', 'samira.dias@buffalodigital.com.br', 'thais.barbian@buffalodigital.com.br', 'claudio.batitucci@partners360.com.br', 'analuisaarrunategui@gmail.com', 'clayton.lisboa@buffalodigital.com.br', 'bruno.henrique@repetreciclagem.com.br', 'np@healthsafetytech.com', 'alexsandrarmatos@gmail.com', 'alexa@etcetal.com.br', 'adm01@healthsafetytech.com', 'hylderosa@gmail.com', 'mayaradias.tur@gmail.com', 'digowars@gmail.com', 'daniel.gaia@varejaodastintas.com.br', 'aangrisano@gmail.com', 'test_with_password_1768589940269@example.com', 'test_without_password_1768589940874@example.com', 'rnrsouza@hotmail.com', 'kawbicalho@gmail.com', 'GABIDIASJ@GMAIL.COM', 'financeiro01@healthsafetytech.com', 'comercial01@healthsafetytech.com', 'qualidade01@healthsafetytech.com', 'servicos01@healthsafetytech.com', 'laboratorio01@healthsafetytech.com', 'expedicao01@healthsafetytech.com', 'ti@healthsafetytech.com', 'expedicao02@healthsafetytech.com', 'comercial02@healthsafetytech.com', 'ti02@healthsafetytech.com', 'comercial03@healthsafetytech.com', 'comercial04@healthsafetytech.com', 'qualidade02@healthsafetytech.com', 'servicos02@healthsafetytech.com', 'laboratorio02@healthsafetytech.com', 'expedicao03@healthsafetytech.com', 'suporte01@healthsafetytech.com', 'comercial05@healthsafetytech.com', 'suporte02@healthsafetytech.com', 'ti03@healthsafetytech.com', 'surama@etcetal.com.br', 'walbertsantos@gmail.com', 'sdr3@healthsafety.com.br', 'adriana_diana_oliveira@hotmail.com', 'gynunes62@gmail.com', 'djalmanetobeto@gmail.com', 'sandraa.cristina@hotmail.com', 'gopme12@gmail.com', 'weltonkellyson24@gmail.com', 'sdr1@healthsafety.com.br', 'gmswanderley@gmail.com', 'suelenpatricia957@gmail.com', 'rickelmepe@gmail.com', 'suelenpatricia957@gmai.com', 'ellenelis87@gmail.com', 'lucas.azevedo3009@gmail.com', 'leandroepronto3.1lvs@gmail.com', 'fabianodinizsantos@gmail.com', 'rgcaetanofujitsu@gmail.com', 'giancarlodalmulin@gmail.com', 'ronetju2019@gmail.com', 'valeria.educacional@gmail.com', 'dede_rangel@yahoo.com.br', 'renato.correa@oktz.com.br', 'institutoalupo@gmail.com', 'fabio.marfer@gmail.com', 'welintonsilva690@gmail.com', 'jrmagrafil@gmail.com', 'lua77@uol.com.br', 'Marcoamojr@gmail.com', 'julianacosta_15@hotmail.com', 'fernanda_arceno@hotmail.com', 'mauriciosilva1590@gmail.com', 'amiltonguedes2009@gmail.com', 'viniciusleal@ymail.com', 'gilberto.maranhao78@gmail.com', 'jocemarmartinscalado@gmail.com', 'ricardo.a.m.tomita@gmail.com', 'ljordaosilva@gmail.com', 'marpugliesi@gmail.com', 'pedro@reclick.com.br', 'fabmontsant@gmail.com', 'europalugares@gmail.com', 'gildevamjunior@hotmail.com', 'alexandre.diniz.cesar@gmail.com', 'gabrieladauer@gmail.com', 'claudenice_lem@hotmail.com', 'art3dstd@gmail.com', 'valdeirsantos891@gmail.com', 'ta.993810275@gmail.com', 'ruiterfidencio@gmail.com', 'eliemarbueno@gmail.com', 'andreiacbarreto@gmail.com', 'doromarra@hotmail.com', 'suelenribeiro@gestaomatriz.com.br', 'grodriguez@piattino.com.br', 'lcsxavier@hotmail.com', 'brunaarruda1712@gmail.com', 'maisahfm@gmail.com', 'gccotia.combate@gmail.com', 'jubettini@gmail.com', 'rmatoscarina@gmail.com', 'gkgloballink@gmail.com', 'mariaeduardabranco1991@gmail.com', 'jornalistapatriciateixeira@gmail.com', 'elisapj@hotmail.com', 'harmonia5x.mentorias@gmail.com', 'savanazamai@gmail.com', 'phabioliveira@gmail.com', 'frs8176@gmail.com', 'unapackembalagens@gmail.com', 'taisfaria1@gmail.com', 'ronetju@yahoo.com.br', 'lilianc21@yahoo.com', 'getulioairescorretorimoveis@gmail.com', 'kimberly_suellen@hotmail.com', 'giselleas@hotmail.com', 'maurina26mbk@gmail.com', 'helenafcr@gmail.com', 'alle-lima2011@hotmail.com', 'larissa21_assis@outlook.com', 'junioalmeida1994@gmail.com', 'turossizah@gmail.com', 'patriciaas.antao@gmail.com', 'rosellirozendo@gmail.com', 'juliane.vieira@claro.com.br', 'mariribeiro14071982@gmail.com', 'dennilsonjl@gmail.com', 'liliane.soberana@gmail.com', 'isaacgomesrdf@gmail.com', 'RODRIGOFERNANDESCONTABILIDADE@GMAIL.COM', 'carloscerbbinno@gmail.com', 'esmirnacv@yahoo.com.br', 'phaty17@gmail.com', 'marceloffranco@glook.com.br', 'ribeiroola@gmail.com', 'larissa.almeida@grupomultilaser.com.br', 'marcela@artesacramoda.com.br', 'milamreis@hotmail.com', 'rafaelfarreb@gmail.com', 'marcosdelnero.apps@gmail.com', 'or-debora@outlook.com', 'joaoricardodinizsilva@gmail.com', 'leandrotsmachado@gmail.com', 'luiza.deschamps@hotmail.com', 'brunnacampos01@hotmail.com', 'buenocurador@gmail.com', 'joaovicenterf@gmail.com', 'izabela.sdutra@gmail.com', 'alessandra.cso@gmail.com', 'giboanapaula@hotmail.com', 'gladyslimabio@yahoo.com.br', 'julietanferreira@gmail.com', 'mariannarezende@gmail.com', 'mialine_vale@yahoo.com.br', 'edmilsonrossi@gmail.com', 'profpedromarcio@hotmail.com', 'heronguatiello@gmail.com', 'alexsandra@dnia.ai', 'rodrigoferreira077@gmail.com', 'lanich2014@gmail.com', 'heitorfrancisco2005@hotmail.com', 'ketlenmac@gmail.com', 'ttjpopo@gmail.com', 'Alaideoliveiralongo@hotmail.com', 'barbarabenvenu@gmail.com', 'janecpq76@gmail.com', 'lalla.nathania@gmail.com', 'mendesana39@gmail.com', 'bertellojulia@gmail.com', 'carolina@artesacramoda.com.br', 'reporterivane@yahoo.com.br', 'rmartins.2306@gmail.com', 'marcelalazza@gmail.com', 'carlatutschkeanalistacorporal@gmail.com', 'carla.mariana70@hotmail.com', 'assislarissa2023@gmail.com', 'paollacolli@gmail.com', 'santogabriel13@gmail.com', 'mssuribeiro@yahoo.com.br', 'vivi.noronha2009@hotmail.com', 'caiofran746@gmail.com', 'caredufisio@gmail.com', 'adrianavidal@flourish.com.br', 'setrini@uol.com.br', 'danianemd@yahoo.com.br', 'cmartire@hotmail.com', 'izaloredo.mkt@gmail.com', 'priscilasoares02@yahoo.com.br', 'ariane.santiago0112@gmail.com', 'rafael6ptc@hotmail.com', 'mulherrealeza01@gmail.com', 'patriciarezende22@hotmail.com', 'aniekarenina@gmail.com', 'esleycastelar@gmail.com', 'frankybarbosa56@gmail.com', 'gracekpassos@gmail.com', 'Thalia.dahora@outlook.com', 'luizfernando.maluf@gmail.com', 'djesmi@hotmail.com', 'jsepifanio2@gmail.com', 'normandia@dnaia.ai', 'teste.1770407502698.295.1@loadtest.com', 'teste.1770407502828.1808.65@loadtest.com', 'teste.1770407502776.3720.3@loadtest.com', 'teste.1770407502835.7735.75@loadtest.com', 'teste.1770407502840.1592.82@loadtest.com', 'teste.1770407502778.6251.4@loadtest.com', 'teste.1770407502832.9984.70@loadtest.com', 'teste.1770407502780.1844.6@loadtest.com', 'teste.1770407502781.2325.7@loadtest.com', 'teste.1770407502787.4792.10@loadtest.com', 'teste.1770407502838.7504.79@loadtest.com', 'teste.1770407502790.5763.14@loadtest.com', 'teste.1770407502774.8536.2@loadtest.com', 'teste.1770407502794.8959.19@loadtest.com', 'teste.1770407502779.6787.5@loadtest.com', 'teste.1770407502783.5086.9@loadtest.com', 'teste.1770407502791.8698.15@loadtest.com', 'teste.1770407502788.3329.11@loadtest.com', 'teste.1770407502793.4788.18@loadtest.com', 'teste.1770407502799.9290.26@loadtest.com', 'teste.1770407502792.1908.16@loadtest.com', 'teste.1770407502790.6360.13@loadtest.com', 'teste.1770407502782.1842.8@loadtest.com', 'teste.1770407502794.2994.20@loadtest.com', 'teste.1770407502792.5820.17@loadtest.com', 'teste.1770407502797.9054.24@loadtest.com', 'teste.1770407502789.2226.12@loadtest.com', 'teste.1770407502795.633.21@loadtest.com', 'teste.1770407502799.4935.27@loadtest.com', 'teste.1770407502797.88.23@loadtest.com', 'teste.1770407502800.3937.28@loadtest.com', 'teste.1770407502809.8639.40@loadtest.com', 'teste.1770407502796.2487.22@loadtest.com', 'teste.1770407502798.3500.25@loadtest.com', 'teste.1770407502844.9283.85@loadtest.com', 'teste.1770407502812.7425.44@loadtest.com', 'teste.1770407502817.1818.51@loadtest.com', 'teste.1770407502801.7249.29@loadtest.com', 'teste.1770407502804.838.33@loadtest.com', 'teste.1770407502807.2556.38@loadtest.com', 'teste.1770407502802.5574.31@loadtest.com', 'teste.1770407502807.8803.37@loadtest.com', 'teste.1770407502805.3595.34@loadtest.com', 'teste.1770407502810.1305.42@loadtest.com', 'teste.1770407502803.639.32@loadtest.com', 'teste.1770407502813.4674.46@loadtest.com', 'teste.1770407502814.5100.48@loadtest.com', 'teste.1770407502814.91.47@loadtest.com', 'teste.1770407502812.6317.45@loadtest.com', 'teste.1770407502821.686.55@loadtest.com', 'teste.1770407502802.9551.30@loadtest.com', 'teste.1770407502824.6799.59@loadtest.com', 'teste.1770407502825.7736.61@loadtest.com', 'teste.1770407502854.3743.100@loadtest.com', 'teste.1770407502837.7792.77@loadtest.com', 'teste.1770407502820.3572.53@loadtest.com', 'teste.1770407502816.7977.50@loadtest.com', 'teste.1770407502822.3591.56@loadtest.com', 'teste.1770407502848.3271.91@loadtest.com', 'teste.1770407502820.7427.54@loadtest.com', 'teste.1770407502806.7146.36@loadtest.com', 'teste.1770407502823.5604.58@loadtest.com', 'teste.1770407502815.8109.49@loadtest.com', 'teste.1770407502829.7652.66@loadtest.com', 'teste.1770407502831.8929.69@loadtest.com', 'teste.1770407502830.6365.68@loadtest.com', 'teste.1770407502849.6833.93@loadtest.com', 'teste.1770407502852.4811.96@loadtest.com', 'teste.1770407502822.2671.57@loadtest.com', 'teste.1770407502828.3342.64@loadtest.com', 'teste.1770407502836.5557.76@loadtest.com', 'teste.1770407502838.1172.78@loadtest.com', 'teste.1770407502833.6207.71@loadtest.com', 'teste.1770407502808.6910.39@loadtest.com', 'teste.1770407502809.9820.41@loadtest.com', 'teste.1770407502833.5914.72@loadtest.com', 'teste.1770407502830.2584.67@loadtest.com', 'teste.1770407502834.8835.73@loadtest.com', 'teste.1770407502843.5992.83@loadtest.com', 'teste.1770407502811.3994.43@loadtest.com', 'teste.1770407502826.6293.62@loadtest.com', 'teste.1770407502819.622.52@loadtest.com', 'teste.1770407502840.9087.81@loadtest.com', 'teste.1770407502845.1246.86@loadtest.com', 'teste.1770407502835.7276.74@loadtest.com', 'teste.1770407502851.9235.95@loadtest.com', 'teste.1770407502850.4530.94@loadtest.com', 'teste.1770407502843.6905.84@loadtest.com', 'teste.1770407502805.4344.35@loadtest.com', 'teste.1770407502845.4977.87@loadtest.com', 'teste.1770407502847.5521.89@loadtest.com', 'teste.1770407502827.3784.63@loadtest.com', 'teste.1770407502853.9817.98@loadtest.com', 'teste.1770407502852.2289.97@loadtest.com', 'teste.1770407502846.2061.88@loadtest.com', 'teste.1770407502854.7936.99@loadtest.com', 'teste.1770407502825.8057.60@loadtest.com', 'teste.1770407502839.4597.80@loadtest.com', 'teste.1770407502849.994.92@loadtest.com', 'teste.1770407502847.5668.90@loadtest.com', 'teste.1770407690211.1531.3@loadtest.com', 'teste.1770407690212.586.4@loadtest.com', 'teste.1770407690243.8803.37@loadtest.com', 'teste.1770407690209.3334.2@loadtest.com', 'teste.1770407690235.1067.26@loadtest.com', 'teste.1770407690227.6234.15@loadtest.com', 'teste.1770407690241.4133.35@loadtest.com', 'teste.1770407690276.7795.79@loadtest.com', 'teste.1770407690215.2245.6@loadtest.com', 'teste.1770407690244.3322.38@loadtest.com', 'teste.1770407690216.9743.7@loadtest.com', 'teste.1770407690227.9576.16@loadtest.com', 'teste.1770407690219.4381.9@loadtest.com', 'teste.1770407690228.9114.17@loadtest.com', 'teste.1770407690214.3263.5@loadtest.com', 'teste.1770407690217.3651.8@loadtest.com', 'teste.1770407690223.2026.11@loadtest.com', 'teste.1770407690232.3655.23@loadtest.com', 'teste.1770407690225.8671.13@loadtest.com', 'teste.1770407690226.6602.14@loadtest.com', 'teste.1770407690133.9371.1@loadtest.com', 'teste.1770407690224.7187.12@loadtest.com', 'teste.1770407690222.1109.10@loadtest.com', 'teste.1770407690229.7066.18@loadtest.com', 'teste.1770407690233.7493.24@loadtest.com', 'teste.1770407690238.2076.30@loadtest.com', 'teste.1770407690231.9376.21@loadtest.com', 'teste.1770407690237.9313.29@loadtest.com', 'teste.1770407690234.1856.25@loadtest.com', 'teste.1770407690230.669.19@loadtest.com', 'teste.1770407690240.3703.33@loadtest.com', 'teste.1770407690241.5217.34@loadtest.com', 'teste.1770407690230.664.20@loadtest.com', 'teste.1770407690235.9352.27@loadtest.com', 'teste.1770407690261.2597.59@loadtest.com', 'teste.1770407690250.1441.47@loadtest.com', 'teste.1770407690242.5416.36@loadtest.com', 'teste.1770407690236.9777.28@loadtest.com', 'teste.1770407690244.4796.39@loadtest.com', 'teste.1770407690262.4676.60@loadtest.com', 'teste.1770407690256.6181.52@loadtest.com', 'teste.1770407690249.4124.45@loadtest.com', 'teste.1770407690251.2476.48@loadtest.com', 'teste.1770407690252.6543.49@loadtest.com', 'teste.1770407690263.5572.62@loadtest.com', 'teste.1770407690279.5335.83@loadtest.com', 'teste.1770407690245.4292.40@loadtest.com', 'teste.1770407690246.9634.41@loadtest.com', 'teste.1770407690254.2193.51@loadtest.com', 'teste.1770407690257.7651.54@loadtest.com', 'teste.1770407690232.2707.22@loadtest.com', 'teste.1770407690258.7258.55@loadtest.com', 'teste.1770407690247.3088.43@loadtest.com', 'teste.1770407690274.1180.76@loadtest.com', 'teste.1770407690253.8130.50@loadtest.com', 'teste.1770407690250.8937.46@loadtest.com', 'teste.1770407690265.4490.64@loadtest.com', 'teste.1770407690248.2256.44@loadtest.com', 'teste.1770407690281.7460.84@loadtest.com', 'teste.1770407690283.8010.86@loadtest.com', 'teste.1770407690275.4523.77@loadtest.com', 'teste.1770407690257.5140.53@loadtest.com', 'teste.1770407690293.9610.99@loadtest.com', 'teste.1770407690266.5394.65@loadtest.com', 'teste.1770407690285.707.89@loadtest.com', 'teste.1770407690259.3613.57@loadtest.com', 'teste.1770407690239.8981.32@loadtest.com', 'teste.1770407690269.2108.69@loadtest.com', 'teste.1770407690266.1306.66@loadtest.com', 'teste.1770407690260.2867.58@loadtest.com', 'teste.1770407690272.7699.73@loadtest.com', 'teste.1770407690292.4846.98@loadtest.com', 'teste.1770407690268.1461.68@loadtest.com', 'teste.1770407690259.896.56@loadtest.com', 'teste.1770407690275.2336.78@loadtest.com', 'teste.1770407690286.1329.90@loadtest.com', 'teste.1770407690269.3864.70@loadtest.com', 'teste.1770407690267.8922.67@loadtest.com', 'teste.1770407690284.5400.88@loadtest.com', 'teste.1770407690284.3688.87@loadtest.com', 'teste.1770407690288.1226.92@loadtest.com', 'teste.1770407690287.6472.91@loadtest.com', 'teste.1770407690272.6007.74@loadtest.com', 'teste.1770407690278.7691.81@loadtest.com', 'teste.1770407690273.133.75@loadtest.com', 'teste.1770407690277.315.80@loadtest.com', 'teste.1770407690271.6031.72@loadtest.com', 'teste.1770407690288.5286.93@loadtest.com', 'teste.1770407690263.6656.61@loadtest.com', 'teste.1770407690270.4469.71@loadtest.com', 'teste.1770407690293.7925.100@loadtest.com', 'teste.1770407690278.9123.82@loadtest.com', 'teste.1770407690238.7458.31@loadtest.com', 'teste.1770407690289.3187.94@loadtest.com', 'teste.1770407690290.3492.95@loadtest.com', 'teste.1770407690247.4761.42@loadtest.com', 'teste.1770407690290.8948.96@loadtest.com', 'teste.1770407690291.1591.97@loadtest.com', 'teste.1770407690264.6182.63@loadtest.com', 'teste.1770407690282.2169.85@loadtest.com', 'rcantareira@gmail.com', 'brunarbsemijoias@com.br');
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Buscar ID - Oficial');
DELETE FROM public.companies WHERE name = 'Buscar ID - Oficial';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Empresa Teste LTDA');
DELETE FROM public.companies WHERE name = 'Empresa Teste LTDA';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Leads Buscar ID');
DELETE FROM public.companies WHERE name = 'Leads Buscar ID';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'V1G Hub');
DELETE FROM public.companies WHERE name = 'V1G Hub';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'MTIA');
DELETE FROM public.companies WHERE name = 'MTIA';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'CDL BH');
DELETE FROM public.companies WHERE name = 'CDL BH';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Buffalo Digital');
DELETE FROM public.companies WHERE name = 'Buffalo Digital';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'One - Only Network Experts');
DELETE FROM public.companies WHERE name = 'One - Only Network Experts';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Grupo Partners - Teste');
DELETE FROM public.companies WHERE name = 'Grupo Partners - Teste';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Repet Reciclagem');
DELETE FROM public.companies WHERE name = 'Repet Reciclagem';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Health & Safety');
DELETE FROM public.companies WHERE name = 'Health & Safety';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Etc & Tal Live Marketing');
DELETE FROM public.companies WHERE name = 'Etc & Tal Live Marketing';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Empresa Teste Senha');
DELETE FROM public.companies WHERE name = 'Empresa Teste Senha';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Digowars');
DELETE FROM public.companies WHERE name = 'Digowars';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Teste Link Admin');
DELETE FROM public.companies WHERE name = 'Teste Link Admin';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Digowars');
DELETE FROM public.companies WHERE name = 'Digowars';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Teste URL Correta');
DELETE FROM public.companies WHERE name = 'Teste URL Correta';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Digowars');
DELETE FROM public.companies WHERE name = 'Digowars';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Teste Login');
DELETE FROM public.companies WHERE name = 'Teste Login';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Cristal e Cores');
DELETE FROM public.companies WHERE name = 'Cristal e Cores';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Grupo OKTZ');
DELETE FROM public.companies WHERE name = 'Grupo OKTZ';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Varejão das Tintas');
DELETE FROM public.companies WHERE name = 'Varejão das Tintas';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Test Company for Invite');
DELETE FROM public.companies WHERE name = 'Test Company for Invite';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Test Company for Invite');
DELETE FROM public.companies WHERE name = 'Test Company for Invite';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Teste Kaw ');
DELETE FROM public.companies WHERE name = 'Teste Kaw ';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Teste Normandia');
DELETE FROM public.companies WHERE name = 'Teste Normandia';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Imersão P. Dominando IA');
DELETE FROM public.companies WHERE name = 'Imersão P. Dominando IA';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Sala Secreta <dn.ai> | 07.02');
DELETE FROM public.companies WHERE name = 'Sala Secreta <dn.ai> | 07.02';
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'OKTZ');
DELETE FROM public.companies WHERE name = 'OKTZ';

-- ========== COMPANIES ==========
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('b950f7ce-926b-47fe-8a2e-3f48ccaffa73', 'Buscar ID - Oficial', NULL, 'active', '2025-11-16T21:51:30.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('925c3a0d-79b7-443a-9906-e4102af49f54', 'Empresa Teste LTDA', '00.000.000/0001-00', 'active', '2025-11-16T21:52:10.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('aface7a1-e0e5-4af4-854b-437da0d54b5b', 'Leads Buscar ID', NULL, 'active', '2025-11-17T12:59:39.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('111349f1-e042-437f-beea-a5d6687eaf69', 'V1G Hub', NULL, 'active', '2025-11-19T05:02:04.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('69fea6be-8e37-48be-b5a2-5acb189f7287', 'MTIA', NULL, 'active', '2025-11-20T18:08:53.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('a4d47ab7-096f-41d1-b358-194d6790311e', 'CDL BH', NULL, 'active', '2025-12-02T17:57:47.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('aaca7b06-6896-4015-bd0a-0809fccb24bb', 'Buffalo Digital', NULL, 'active', '2025-12-03T17:57:00.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('4ca89e4d-4d74-4b54-b5b8-a246d4bd7eb8', 'One - Only Network Experts', NULL, 'active', '2025-12-05T19:18:07.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('cbe18e88-1702-43de-a6ab-0f664ab2947c', 'Grupo Partners - Teste', NULL, 'active', '2025-12-05T22:52:30.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('4a8923c2-dcee-4570-a106-3ef24d1832f7', 'Repet Reciclagem', NULL, 'active', '2025-12-10T16:26:35.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('e349848b-85c5-4c7d-ad62-f781381a0f1f', 'Health & Safety', NULL, 'active', '2025-12-12T19:53:08.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('8fc25820-2603-4988-a69f-d5f2ad72d711', 'Etc & Tal Live Marketing', NULL, 'active', '2026-01-05T16:52:51.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('2a708066-ff89-4c9f-b080-47ba162fbcce', 'Empresa Teste Senha', '12.345.678/0001-90', 'inactive', '2026-01-14T15:01:51.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('0f830a01-d31a-43ea-9426-5dcf53bfe837', 'Digowars', NULL, 'inactive', '2026-01-14T15:21:08.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('88e21ff8-72cc-48ba-b2c4-cb6ac71118df', 'Teste Link Admin', '99.999.999/0001-99', 'inactive', '2026-01-14T15:25:00.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('fac3c1b8-030b-4d30-ae6f-ecf7a3fc18d0', 'Digowars', NULL, 'inactive', '2026-01-14T16:29:36.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('f405ab0c-8159-4d93-862e-1d44c48d9ff6', 'Teste URL Correta', NULL, 'inactive', '2026-01-14T16:31:48.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('582b4903-1b1a-4594-9e5e-64bb32223c41', 'Digowars', NULL, 'inactive', '2026-01-14T18:04:56.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('24a360c7-2480-4b27-af3f-7a05b9b1b744', 'Teste Login', NULL, 'inactive', '2026-01-14T18:19:57.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('85af0406-9809-4d6e-af30-b119ab7578c7', 'Cristal e Cores', NULL, 'active', '2026-01-16T15:57:19.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('df49686e-23bb-4464-8e06-e6d6d794962c', 'Grupo OKTZ', NULL, 'active', '2026-01-16T16:07:23.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('5f45b92a-77d4-4e18-85aa-2961dc373425', 'Varejão das Tintas', NULL, 'active', '2026-01-16T16:39:40.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('a51d5768-b603-445a-9ccc-9bf29e084a28', 'Test Company for Invite', NULL, 'active', '2026-01-16T21:58:36.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('6c619694-29f3-4389-9a4b-7b077d473315', 'Test Company for Invite', NULL, 'active', '2026-01-16T21:59:00.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('d013c83f-9094-45b9-8e6b-514e0e388370', 'Teste Kaw ', NULL, 'inactive', '2026-01-20T19:43:23.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('ef683772-4f88-4ac0-9a90-122b4d7d27bb', 'Teste Normandia', NULL, 'inactive', '2026-01-20T19:57:15.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee', 'Imersão P. Dominando IA', NULL, 'active', '2026-01-24T05:36:16.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('ad233833-52a6-4ec9-b0ab-1bbcf1b89f52', 'Sala Secreta <dn.ai> | 07.02', NULL, 'active', '2026-02-06T22:39:10.000Z');
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('5e44429d-8c62-49f7-bc7f-46561f7feb2d', 'OKTZ', NULL, 'active', '2026-02-13T04:15:03.000Z');

-- ========== DEPARTMENTS ==========
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('01ec8a2e-121f-454c-8bd9-70dd47ef09c3', 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73', 'Direção', '2025-11-17T02:18:44.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('4d375066-9fe4-4878-9574-8373c547ab20', 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73', 'CS/CX', '2025-11-17T17:32:50.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('8b213a2b-fb8e-4e66-947d-47387a72205a', 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73', 'Marketing', '2025-11-17T17:33:01.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('47dcfddc-cac5-40ac-95d0-ad5e9da70dad', 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73', 'Vendas', '2025-11-17T17:33:06.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('ae3a6260-9ad2-4f9d-940f-10c0b0c6de8b', 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73', 'Inteligência Artificial', '2025-11-17T17:39:00.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('3d6323ac-03d0-40d8-8394-9b0d8096fa92', '69fea6be-8e37-48be-b5a2-5acb189f7287', 'Mentorados', '2025-11-28T19:40:36.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('0a3227d0-3551-440a-868c-7ec29edd06f1', 'aaca7b06-6896-4015-bd0a-0809fccb24bb', 'Diretoria', '2025-12-03T17:58:45.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('cfbccefd-30cc-4687-81d4-7ca1839ea923', 'aaca7b06-6896-4015-bd0a-0809fccb24bb', 'Atendimento', '2025-12-03T20:42:27.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('70a64145-7ef6-4f3b-8c38-18b30f18e0f5', 'aaca7b06-6896-4015-bd0a-0809fccb24bb', 'Redação', '2025-12-03T20:42:36.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('c51ae03f-a2d1-4b85-a3fe-e1c1232a15cc', 'aaca7b06-6896-4015-bd0a-0809fccb24bb', 'Criação', '2025-12-03T20:42:41.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('1de66b4e-5350-43b1-a7e9-09705f2b79f0', 'aaca7b06-6896-4015-bd0a-0809fccb24bb', 'Produção', '2025-12-03T20:42:47.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('8ae7e209-12c3-40c8-b0ca-f2140e86355b', 'aaca7b06-6896-4015-bd0a-0809fccb24bb', 'Edição', '2025-12-03T20:42:53.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('748546e8-830b-4e8c-bf01-ab7218fb5835', 'aaca7b06-6896-4015-bd0a-0809fccb24bb', 'Financeiro', '2025-12-03T20:43:03.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('feef56de-5b24-4ec7-a490-14e640e260bd', 'aaca7b06-6896-4015-bd0a-0809fccb24bb', 'Motion', '2025-12-03T20:52:41.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('2e1234ce-cbd8-4fee-91df-09eba1810e3d', 'aaca7b06-6896-4015-bd0a-0809fccb24bb', 'Tráfego', '2025-12-03T21:01:48.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('14b9a7fa-b094-4638-976b-57ced6420ae9', 'aaca7b06-6896-4015-bd0a-0809fccb24bb', 'Vaga - Comercial', '2026-01-16T16:52:35.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('362bcbe4-c0c6-407b-b5dc-8f9d236efaa7', '5f45b92a-77d4-4e18-85aa-2961dc373425', 'Geral', '2026-01-20T19:31:26.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('ae8e2bd1-b0ef-498f-a64b-6805bef6359e', 'e349848b-85c5-4c7d-ad62-f781381a0f1f', 'Vendas', '2026-01-23T17:49:05.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('5d08258b-57ec-4010-a809-e9e6c1fb226c', 'e349848b-85c5-4c7d-ad62-f781381a0f1f', 'Serviços', '2026-01-23T17:49:19.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('bb3ad87b-0cf4-4da0-a063-6b943b9cc49c', 'e349848b-85c5-4c7d-ad62-f781381a0f1f', 'TI', '2026-01-23T17:49:23.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('7f2222de-abe1-4f1b-8f94-794ec29d1e89', 'e349848b-85c5-4c7d-ad62-f781381a0f1f', 'Suporte', '2026-01-23T17:49:28.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('bb0eb89b-0b76-4d1d-9b3b-f376c39e8dc2', 'e349848b-85c5-4c7d-ad62-f781381a0f1f', 'RH', '2026-01-23T17:49:32.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('7d498608-9b57-44a5-a080-d4e81047b201', 'e349848b-85c5-4c7d-ad62-f781381a0f1f', 'Financeiro', '2026-01-23T17:49:40.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('aaece373-5f02-4eea-9c73-46bebe4a4a81', 'e349848b-85c5-4c7d-ad62-f781381a0f1f', 'Expedição', '2026-01-23T17:49:45.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('495fcb85-585a-46a0-bc46-9c65e8e51915', 'e349848b-85c5-4c7d-ad62-f781381a0f1f', 'Laboratório', '2026-01-23T17:49:53.000Z');
INSERT INTO public.departments (id, company_id, name, created_at)
VALUES ('d1d09e8a-a4f5-494e-a4ee-9b9734fc96cb', 'e349848b-85c5-4c7d-ad62-f781381a0f1f', 'Qualidade', '2026-01-23T17:49:58.000Z');

-- ========== USERS ==========
-- Buscar ID (operacoes@buscarid.com) | Role: master_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0f7cf7a3-cecd-43c3-9977-d77d247c0491', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'operacoes@buscarid.com', '', '2025-11-07T21:26:33.000Z', '2025-11-07T21:26:33.000Z', '2026-02-06T22:15:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Buscar ID"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2bda57d8-0e6e-4ab3-a8bc-0ca7853cb080', '0f7cf7a3-cecd-43c3-9977-d77d247c0491', '{"sub":"0f7cf7a3-cecd-43c3-9977-d77d247c0491","email":"operacoes@buscarid.com","email_verified":true}', 'email', '0f7cf7a3-cecd-43c3-9977-d77d247c0491', '2025-11-07T21:26:33.000Z', '2026-02-06T22:15:53.000Z', '2026-02-06T22:15:52.000Z');
UPDATE public.profiles SET name = 'Buscar ID', company_id = 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73' WHERE user_id = '0f7cf7a3-cecd-43c3-9977-d77d247c0491';
UPDATE public.user_roles SET role = 'master_admin'::public.app_role, company_id = 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73' WHERE user_id = '0f7cf7a3-cecd-43c3-9977-d77d247c0491';

-- Rodrigo Normandia (rodrigonormandia@buscarid.com) | Role: master_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('80eea104-0ebe-4d84-9740-436bddbe7c65', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rodrigonormandia@buscarid.com', '', '2025-11-07T22:27:44.000Z', '2025-11-07T22:27:44.000Z', '2026-02-07T18:21:44.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Normandia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8247d8c2-1b58-4789-8a6d-d75e6b448abe', '80eea104-0ebe-4d84-9740-436bddbe7c65', '{"sub":"80eea104-0ebe-4d84-9740-436bddbe7c65","email":"rodrigonormandia@buscarid.com","email_verified":true}', 'email', '80eea104-0ebe-4d84-9740-436bddbe7c65', '2025-11-07T22:27:44.000Z', '2026-02-07T18:21:44.000Z', '2026-01-25T22:21:46.000Z');
UPDATE public.profiles SET name = 'Rodrigo Normandia', company_id = 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73', department_id = 'ae3a6260-9ad2-4f9d-940f-10c0b0c6de8b' WHERE user_id = '80eea104-0ebe-4d84-9740-436bddbe7c65';
UPDATE public.user_roles SET role = 'master_admin'::public.app_role, company_id = 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73' WHERE user_id = '80eea104-0ebe-4d84-9740-436bddbe7c65';

-- Kaw Bicalho (kaw@buscarid.com) | Role: master_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a696585b-c272-4792-9f5a-9b3bd16faf66', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'kaw@buscarid.com', '', '2025-11-07T22:28:11.000Z', '2025-11-07T22:28:11.000Z', '2026-01-25T19:59:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Kaw Bicalho"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ba2fa4ee-b085-4439-a259-01cb9ae4f60c', 'a696585b-c272-4792-9f5a-9b3bd16faf66', '{"sub":"a696585b-c272-4792-9f5a-9b3bd16faf66","email":"kaw@buscarid.com","email_verified":true}', 'email', 'a696585b-c272-4792-9f5a-9b3bd16faf66', '2025-11-07T22:28:11.000Z', '2026-01-25T19:59:48.000Z', '2026-01-25T19:59:48.000Z');
UPDATE public.profiles SET name = 'Kaw Bicalho', company_id = 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73', department_id = '4d375066-9fe4-4878-9574-8373c547ab20' WHERE user_id = 'a696585b-c272-4792-9f5a-9b3bd16faf66';
UPDATE public.user_roles SET role = 'master_admin'::public.app_role, company_id = 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73' WHERE user_id = 'a696585b-c272-4792-9f5a-9b3bd16faf66';

-- Jussara Rodrigues (jussara@buscarid.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7ba2b83e-8cc0-460f-bfd2-1a379869a08c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jussara@buscarid.com', '', '2025-11-08T21:07:04.000Z', '2025-11-08T21:07:04.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Jussara Rodrigues"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c259b30b-3cf6-43cb-a8e2-ce30a28641d3', '7ba2b83e-8cc0-460f-bfd2-1a379869a08c', '{"sub":"7ba2b83e-8cc0-460f-bfd2-1a379869a08c","email":"jussara@buscarid.com","email_verified":true}', 'email', '7ba2b83e-8cc0-460f-bfd2-1a379869a08c', '2025-11-08T21:07:04.000Z', '2025-11-17T05:57:01.000Z', '2025-11-08T21:36:24.000Z');
UPDATE public.profiles SET name = 'Jussara Rodrigues', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '7ba2b83e-8cc0-460f-bfd2-1a379869a08c';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '7ba2b83e-8cc0-460f-bfd2-1a379869a08c';

-- Flávia Nascimento (draflaviareumatobh@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d7b75313-d88e-4c41-b8cf-2a940b643b84', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'draflaviareumatobh@gmail.com', '', '2025-11-08T21:51:02.000Z', '2025-11-08T21:51:02.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Flávia Nascimento"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e0b2053a-4f8b-4482-913c-2b3a0c455a83', 'd7b75313-d88e-4c41-b8cf-2a940b643b84', '{"sub":"d7b75313-d88e-4c41-b8cf-2a940b643b84","email":"draflaviareumatobh@gmail.com","email_verified":true}', 'email', 'd7b75313-d88e-4c41-b8cf-2a940b643b84', '2025-11-08T21:51:02.000Z', '2025-11-17T05:57:01.000Z', '2025-11-08T21:55:24.000Z');
UPDATE public.profiles SET name = 'Flávia Nascimento', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'd7b75313-d88e-4c41-b8cf-2a940b643b84';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'd7b75313-d88e-4c41-b8cf-2a940b643b84';

-- Rodrigo Teixeira (rodrigo@sabecomo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('60f3ceef-3d79-4a74-a034-b3af82211952', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rodrigo@sabecomo.com.br', '', '2025-11-08T21:59:35.000Z', '2025-11-08T21:59:35.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Teixeira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('08c02b0f-c3e6-4392-8185-e79aa15fb41e', '60f3ceef-3d79-4a74-a034-b3af82211952', '{"sub":"60f3ceef-3d79-4a74-a034-b3af82211952","email":"rodrigo@sabecomo.com.br","email_verified":true}', 'email', '60f3ceef-3d79-4a74-a034-b3af82211952', '2025-11-08T21:59:35.000Z', '2025-11-17T05:57:01.000Z', '2025-11-17T02:04:14.000Z');
UPDATE public.profiles SET name = 'Rodrigo Teixeira', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '60f3ceef-3d79-4a74-a034-b3af82211952';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '60f3ceef-3d79-4a74-a034-b3af82211952';

-- Nicholson Pimentel (nicholsongp@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6f984f4c-1d13-48e2-9a4a-b72f014e9795', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'nicholsongp@gmail.com', '', '2025-11-11T19:55:35.000Z', '2025-11-11T19:55:35.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Nicholson Pimentel"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e1940b27-e3d5-4fb3-9cb4-e5f01715cded', '6f984f4c-1d13-48e2-9a4a-b72f014e9795', '{"sub":"6f984f4c-1d13-48e2-9a4a-b72f014e9795","email":"nicholsongp@gmail.com","email_verified":true}', 'email', '6f984f4c-1d13-48e2-9a4a-b72f014e9795', '2025-11-11T19:55:35.000Z', '2025-11-17T05:57:01.000Z', '2025-11-11T20:22:27.000Z');
UPDATE public.profiles SET name = 'Nicholson Pimentel', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '6f984f4c-1d13-48e2-9a4a-b72f014e9795';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '6f984f4c-1d13-48e2-9a4a-b72f014e9795';

-- Andre Wandenkolken Afonso (andrewafonso@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f95dcfa5-06df-4ab7-9c48-f12c80d04da8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'andrewafonso@gmail.com', '', '2025-11-12T02:43:15.000Z', '2025-11-12T02:43:15.000Z', '2026-01-14T19:58:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Andre Wandenkolken Afonso"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9e29453e-ebfa-46a0-9817-82a0b9ed1589', 'f95dcfa5-06df-4ab7-9c48-f12c80d04da8', '{"sub":"f95dcfa5-06df-4ab7-9c48-f12c80d04da8","email":"andrewafonso@gmail.com","email_verified":true}', 'email', 'f95dcfa5-06df-4ab7-9c48-f12c80d04da8', '2025-11-12T02:43:15.000Z', '2026-01-14T19:58:20.000Z', '2026-01-14T19:58:21.000Z');
UPDATE public.profiles SET name = 'Andre Wandenkolken Afonso', company_id = '8fc25820-2603-4988-a69f-d5f2ad72d711' WHERE user_id = 'f95dcfa5-06df-4ab7-9c48-f12c80d04da8';
UPDATE public.user_roles SET company_id = '8fc25820-2603-4988-a69f-d5f2ad72d711' WHERE user_id = 'f95dcfa5-06df-4ab7-9c48-f12c80d04da8';

-- Anie Karenina (anie.karenina@buffalodigital.com.br) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7da6e83d-97f2-4f82-8dfe-742642267901', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'anie.karenina@buffalodigital.com.br', '', '2025-11-12T02:43:29.000Z', '2025-11-12T02:43:29.000Z', '2026-01-30T21:55:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Anie Karenina"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a5271a33-8688-46ae-b526-dad0019c527d', '7da6e83d-97f2-4f82-8dfe-742642267901', '{"sub":"7da6e83d-97f2-4f82-8dfe-742642267901","email":"anie.karenina@buffalodigital.com.br","email_verified":true}', 'email', '7da6e83d-97f2-4f82-8dfe-742642267901', '2025-11-12T02:43:29.000Z', '2026-01-30T21:55:53.000Z', '2026-01-30T21:55:53.000Z');
UPDATE public.profiles SET name = 'Anie Karenina', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '0a3227d0-3551-440a-868c-7ec29edd06f1' WHERE user_id = '7da6e83d-97f2-4f82-8dfe-742642267901';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '7da6e83d-97f2-4f82-8dfe-742642267901';

-- Fernando Jin (fernandojin@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('eeadd660-9bad-4b87-aab1-bcf262d418d7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'fernandojin@gmail.com', '', '2025-11-12T02:43:37.000Z', '2025-11-12T02:43:37.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fernando Jin"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8da87da9-16cf-4e05-9bdf-8f79245a4405', 'eeadd660-9bad-4b87-aab1-bcf262d418d7', '{"sub":"eeadd660-9bad-4b87-aab1-bcf262d418d7","email":"fernandojin@gmail.com","email_verified":true}', 'email', 'eeadd660-9bad-4b87-aab1-bcf262d418d7', '2025-11-12T02:43:37.000Z', '2025-11-17T05:57:01.000Z', '2025-11-12T12:31:06.000Z');
UPDATE public.profiles SET name = 'Fernando Jin', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'eeadd660-9bad-4b87-aab1-bcf262d418d7';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'eeadd660-9bad-4b87-aab1-bcf262d418d7';

-- Daniel Gaia (danielgaia13@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('da971798-2501-45e6-9c0e-0b82fc49ff3c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'danielgaia13@gmail.com', '', '2025-11-12T03:02:43.000Z', '2025-11-12T03:02:43.000Z', '2026-01-16T17:29:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Daniel Gaia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d8b5abb5-4be6-42a8-b2ad-568c425cae58', 'da971798-2501-45e6-9c0e-0b82fc49ff3c', '{"sub":"da971798-2501-45e6-9c0e-0b82fc49ff3c","email":"danielgaia13@gmail.com","email_verified":true}', 'email', 'da971798-2501-45e6-9c0e-0b82fc49ff3c', '2025-11-12T03:02:43.000Z', '2026-01-16T17:29:20.000Z', '2026-01-16T17:29:21.000Z');
UPDATE public.profiles SET name = 'Daniel Gaia', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'da971798-2501-45e6-9c0e-0b82fc49ff3c';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'da971798-2501-45e6-9c0e-0b82fc49ff3c';

-- Filipe Lopes (filipejclopes@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5a216530-3da8-449b-a2f8-66ed599682a1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'filipejclopes@gmail.com', '', '2025-11-12T15:26:04.000Z', '2025-11-12T15:26:04.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Filipe Lopes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cc43afb1-215f-4250-bc6e-9f02dfb33f9e', '5a216530-3da8-449b-a2f8-66ed599682a1', '{"sub":"5a216530-3da8-449b-a2f8-66ed599682a1","email":"filipejclopes@gmail.com","email_verified":true}', 'email', '5a216530-3da8-449b-a2f8-66ed599682a1', '2025-11-12T15:26:04.000Z', '2025-11-17T05:57:01.000Z', '2025-11-12T15:39:49.000Z');
UPDATE public.profiles SET name = 'Filipe Lopes', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '5a216530-3da8-449b-a2f8-66ed599682a1';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '5a216530-3da8-449b-a2f8-66ed599682a1';

-- Surama Carvalho (sura.carvalho@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2ddf42a0-f0c7-4e82-a2e6-31cdc0c41519', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'sura.carvalho@gmail.com', '', '2025-11-12T15:27:11.000Z', '2025-11-12T15:27:11.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Surama Carvalho"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c6be0c52-d0e5-441b-adac-bd235cc5ca4d', '2ddf42a0-f0c7-4e82-a2e6-31cdc0c41519', '{"sub":"2ddf42a0-f0c7-4e82-a2e6-31cdc0c41519","email":"sura.carvalho@gmail.com","email_verified":true}', 'email', '2ddf42a0-f0c7-4e82-a2e6-31cdc0c41519', '2025-11-12T15:27:11.000Z', '2025-11-17T05:57:01.000Z', '2025-11-12T15:27:13.000Z');
UPDATE public.profiles SET name = 'Surama Carvalho', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '2ddf42a0-f0c7-4e82-a2e6-31cdc0c41519';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '2ddf42a0-f0c7-4e82-a2e6-31cdc0c41519';

-- Renato Lopes (renatolopesevolve@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ba635eca-0400-45b1-bf1f-29e083e9c2fe', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'renatolopesevolve@gmail.com', '', '2025-11-14T20:00:29.000Z', '2025-11-14T20:00:29.000Z', '2025-12-05T19:36:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Renato Lopes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('71601534-d661-43f1-83d0-92967a543192', 'ba635eca-0400-45b1-bf1f-29e083e9c2fe', '{"sub":"ba635eca-0400-45b1-bf1f-29e083e9c2fe","email":"renatolopesevolve@gmail.com","email_verified":true}', 'email', 'ba635eca-0400-45b1-bf1f-29e083e9c2fe', '2025-11-14T20:00:29.000Z', '2025-12-05T19:36:23.000Z', '2025-12-05T19:36:22.000Z');
UPDATE public.profiles SET name = 'Renato Lopes', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'ba635eca-0400-45b1-bf1f-29e083e9c2fe';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'ba635eca-0400-45b1-bf1f-29e083e9c2fe';

-- Letícia Morelli (leticia@maxupconsultoria.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a645d647-73c6-460b-acec-e95751b767b2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'leticia@maxupconsultoria.com.br', '', '2025-11-15T21:15:41.000Z', '2025-11-15T21:15:41.000Z', '2025-12-02T23:44:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Letícia Morelli"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ee817f01-39cd-4819-8776-1d2b6cf16950', 'a645d647-73c6-460b-acec-e95751b767b2', '{"sub":"a645d647-73c6-460b-acec-e95751b767b2","email":"leticia@maxupconsultoria.com.br","email_verified":true}', 'email', 'a645d647-73c6-460b-acec-e95751b767b2', '2025-11-15T21:15:41.000Z', '2025-12-02T23:44:27.000Z', '2025-12-02T23:44:28.000Z');
UPDATE public.profiles SET name = 'Letícia Morelli', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'a645d647-73c6-460b-acec-e95751b767b2';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'a645d647-73c6-460b-acec-e95751b767b2';

-- Roberta Caldas Simões (rbetasim@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5456311d-64bf-4690-bf7a-f0295d133bd4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rbetasim@gmail.com', '', '2025-11-15T21:15:43.000Z', '2025-11-15T21:15:43.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Roberta Caldas Simões"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('06786432-f36c-41a5-874f-64e03011fdb2', '5456311d-64bf-4690-bf7a-f0295d133bd4', '{"sub":"5456311d-64bf-4690-bf7a-f0295d133bd4","email":"rbetasim@gmail.com","email_verified":true}', 'email', '5456311d-64bf-4690-bf7a-f0295d133bd4', '2025-11-15T21:15:43.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T21:46:28.000Z');
UPDATE public.profiles SET name = 'Roberta Caldas Simões', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '5456311d-64bf-4690-bf7a-f0295d133bd4';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '5456311d-64bf-4690-bf7a-f0295d133bd4';

-- Eva Lariss (evalarissa157@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5891c86b-f0df-453d-ba2f-73ee9df30d4b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'evalarissa157@gmail.com', '', '2025-11-15T21:15:48.000Z', '2025-11-15T21:15:48.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Eva Lariss"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('230bd340-7dca-4247-b36c-a9cfcde445fb', '5891c86b-f0df-453d-ba2f-73ee9df30d4b', '{"sub":"5891c86b-f0df-453d-ba2f-73ee9df30d4b","email":"evalarissa157@gmail.com","email_verified":true}', 'email', '5891c86b-f0df-453d-ba2f-73ee9df30d4b', '2025-11-15T21:15:48.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T23:13:13.000Z');
UPDATE public.profiles SET name = 'Eva Lariss', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '5891c86b-f0df-453d-ba2f-73ee9df30d4b';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '5891c86b-f0df-453d-ba2f-73ee9df30d4b';

-- LAURA DOMINGUES (lalacorrea@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c6e199ed-6036-4df7-b108-0f52f79967a3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lalacorrea@gmail.com', '', '2025-11-15T21:15:57.000Z', '2025-11-15T21:15:57.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"LAURA DOMINGUES"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('855ed02e-7649-4aa7-a393-a12dfde5844f', 'c6e199ed-6036-4df7-b108-0f52f79967a3', '{"sub":"c6e199ed-6036-4df7-b108-0f52f79967a3","email":"lalacorrea@gmail.com","email_verified":true}', 'email', 'c6e199ed-6036-4df7-b108-0f52f79967a3', '2025-11-15T21:15:57.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T23:12:02.000Z');
UPDATE public.profiles SET name = 'LAURA DOMINGUES', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'c6e199ed-6036-4df7-b108-0f52f79967a3';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'c6e199ed-6036-4df7-b108-0f52f79967a3';

-- Henrique Hamerski (henriquehamerski@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c0a6636d-3dff-4b1a-8a89-655c8b182614', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'henriquehamerski@gmail.com', '', '2025-11-15T21:16:06.000Z', '2025-11-15T21:16:06.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Henrique Hamerski"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1a782983-06f9-4dc9-b46c-92412aab853c', 'c0a6636d-3dff-4b1a-8a89-655c8b182614', '{"sub":"c0a6636d-3dff-4b1a-8a89-655c8b182614","email":"henriquehamerski@gmail.com","email_verified":true}', 'email', 'c0a6636d-3dff-4b1a-8a89-655c8b182614', '2025-11-15T21:16:06.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T21:29:33.000Z');
UPDATE public.profiles SET name = 'Henrique Hamerski', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'c0a6636d-3dff-4b1a-8a89-655c8b182614';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'c0a6636d-3dff-4b1a-8a89-655c8b182614';

-- Leonardo Rotela (leodavidrotela91@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('75f1fd81-9b52-4b31-ab03-f0420a875bfd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'leodavidrotela91@gmail.com', '', '2025-11-15T21:16:11.000Z', '2025-11-15T21:16:11.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Leonardo Rotela"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3b961eb8-53df-4faf-8c44-ac5c3846f67c', '75f1fd81-9b52-4b31-ab03-f0420a875bfd', '{"sub":"75f1fd81-9b52-4b31-ab03-f0420a875bfd","email":"leodavidrotela91@gmail.com","email_verified":true}', 'email', '75f1fd81-9b52-4b31-ab03-f0420a875bfd', '2025-11-15T21:16:11.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T22:51:22.000Z');
UPDATE public.profiles SET name = 'Leonardo Rotela', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '75f1fd81-9b52-4b31-ab03-f0420a875bfd';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '75f1fd81-9b52-4b31-ab03-f0420a875bfd';

-- Júlia Maia (maia.jpm@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a48b63bc-5784-4535-9b2f-1cc204419c1f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'maia.jpm@gmail.com', '', '2025-11-15T21:16:12.000Z', '2025-11-15T21:16:12.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Júlia Maia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e9ccb257-1e8b-4736-be25-8de91a0c4439', 'a48b63bc-5784-4535-9b2f-1cc204419c1f', '{"sub":"a48b63bc-5784-4535-9b2f-1cc204419c1f","email":"maia.jpm@gmail.com","email_verified":true}', 'email', 'a48b63bc-5784-4535-9b2f-1cc204419c1f', '2025-11-15T21:16:12.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T22:58:58.000Z');
UPDATE public.profiles SET name = 'Júlia Maia', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'a48b63bc-5784-4535-9b2f-1cc204419c1f';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'a48b63bc-5784-4535-9b2f-1cc204419c1f';

-- Dayane Sousa (dayane@maxupconsultoria.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4c1e0d69-ffeb-4942-a9bc-6b809980531a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dayane@maxupconsultoria.com.br', '', '2025-11-15T21:16:13.000Z', '2025-11-15T21:16:13.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Dayane Sousa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1fcb712d-046f-423b-816c-6a07ca65f9aa', '4c1e0d69-ffeb-4942-a9bc-6b809980531a', '{"sub":"4c1e0d69-ffeb-4942-a9bc-6b809980531a","email":"dayane@maxupconsultoria.com.br","email_verified":true}', 'email', '4c1e0d69-ffeb-4942-a9bc-6b809980531a', '2025-11-15T21:16:13.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T21:26:00.000Z');
UPDATE public.profiles SET name = 'Dayane Sousa', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '4c1e0d69-ffeb-4942-a9bc-6b809980531a';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '4c1e0d69-ffeb-4942-a9bc-6b809980531a';

-- Christiano Soares (christianobsr@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ba519c12-810e-465f-8b5a-c62420376889', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'christianobsr@gmail.com', '', '2025-11-15T21:16:16.000Z', '2025-11-15T21:16:16.000Z', '2026-01-28T16:09:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Christiano Soares"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3690f0c2-63a6-4b30-a286-490d42ebf847', 'ba519c12-810e-465f-8b5a-c62420376889', '{"sub":"ba519c12-810e-465f-8b5a-c62420376889","email":"christianobsr@gmail.com","email_verified":true}', 'email', 'ba519c12-810e-465f-8b5a-c62420376889', '2025-11-15T21:16:16.000Z', '2026-01-28T16:09:54.000Z', '2026-01-28T16:09:54.000Z');
UPDATE public.profiles SET name = 'Christiano Soares', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'ba519c12-810e-465f-8b5a-c62420376889';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'ba519c12-810e-465f-8b5a-c62420376889';

-- Gabriel Andrade (andradegoval2013@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dce6e769-fc4c-4f6c-ac6b-16d37f157321', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'andradegoval2013@gmail.com', '', '2025-11-15T21:16:33.000Z', '2025-11-15T21:16:33.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gabriel Andrade"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a6b2b4aa-896d-446e-b729-ce07226d0c58', 'dce6e769-fc4c-4f6c-ac6b-16d37f157321', '{"sub":"dce6e769-fc4c-4f6c-ac6b-16d37f157321","email":"andradegoval2013@gmail.com","email_verified":true}', 'email', 'dce6e769-fc4c-4f6c-ac6b-16d37f157321', '2025-11-15T21:16:33.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T22:12:22.000Z');
UPDATE public.profiles SET name = 'Gabriel Andrade', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'dce6e769-fc4c-4f6c-ac6b-16d37f157321';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'dce6e769-fc4c-4f6c-ac6b-16d37f157321';

-- Marcos Augusto Cândido (maugustocand@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d4c25ae6-7b63-464e-a644-dbae193b5588', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'maugustocand@gmail.com', '', '2025-11-15T21:16:38.000Z', '2025-11-15T21:16:38.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marcos Augusto Cândido"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d2967569-138f-4f0f-88df-e658551a40a6', 'd4c25ae6-7b63-464e-a644-dbae193b5588', '{"sub":"d4c25ae6-7b63-464e-a644-dbae193b5588","email":"maugustocand@gmail.com","email_verified":true}', 'email', 'd4c25ae6-7b63-464e-a644-dbae193b5588', '2025-11-15T21:16:38.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T21:34:28.000Z');
UPDATE public.profiles SET name = 'Marcos Augusto Cândido', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'd4c25ae6-7b63-464e-a644-dbae193b5588';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'd4c25ae6-7b63-464e-a644-dbae193b5588';

-- Setor Financeiro Albanez e Maia Advogados (raquel@albanezemaia.adv.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('adf2af6f-4c3d-4115-a601-19830be203b3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'raquel@albanezemaia.adv.br', '', '2025-11-15T21:28:55.000Z', '2025-11-15T21:28:55.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Setor Financeiro Albanez e Maia Advogados"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('546a8a6f-1354-4a13-af4b-44dced4b711c', 'adf2af6f-4c3d-4115-a601-19830be203b3', '{"sub":"adf2af6f-4c3d-4115-a601-19830be203b3","email":"raquel@albanezemaia.adv.br","email_verified":true}', 'email', 'adf2af6f-4c3d-4115-a601-19830be203b3', '2025-11-15T21:28:55.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T22:41:40.000Z');
UPDATE public.profiles SET name = 'Setor Financeiro Albanez e Maia Advogados', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'adf2af6f-4c3d-4115-a601-19830be203b3';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = 'adf2af6f-4c3d-4115-a601-19830be203b3';

-- Francis Angeli (francis@maxupconsultoria.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3907c44d-18fe-4e68-b5b8-5e989fabcd6d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'francis@maxupconsultoria.com.br', '', '2025-11-15T22:23:49.000Z', '2025-11-15T22:23:49.000Z', '2025-11-17T05:49:42.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Francis Angeli"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('16dbec34-8d31-4d47-899b-272bea35cd2b', '3907c44d-18fe-4e68-b5b8-5e989fabcd6d', '{"sub":"3907c44d-18fe-4e68-b5b8-5e989fabcd6d","email":"francis@maxupconsultoria.com.br","email_verified":true}', 'email', '3907c44d-18fe-4e68-b5b8-5e989fabcd6d', '2025-11-15T22:23:49.000Z', '2025-11-17T05:49:42.000Z', '2025-11-15T22:24:50.000Z');
UPDATE public.profiles SET name = 'Francis Angeli', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '3907c44d-18fe-4e68-b5b8-5e989fabcd6d';
UPDATE public.user_roles SET company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '3907c44d-18fe-4e68-b5b8-5e989fabcd6d';

-- Admin Teste (admin@teste.com) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9f6b6903-d723-41dd-abdb-3af008e10aaa', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'admin@teste.com', '', '2025-11-16T21:58:13.000Z', '2025-11-16T21:58:13.000Z', '2025-11-16T21:58:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Admin Teste"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2bfa6db0-9f01-41b5-8080-67745f31d89c', '9f6b6903-d723-41dd-abdb-3af008e10aaa', '{"sub":"9f6b6903-d723-41dd-abdb-3af008e10aaa","email":"admin@teste.com","email_verified":true}', 'email', '9f6b6903-d723-41dd-abdb-3af008e10aaa', '2025-11-16T21:58:13.000Z', '2025-11-16T21:58:13.000Z', '2025-11-16T21:58:13.000Z');
UPDATE public.profiles SET name = 'Admin Teste', cpf = '000.000.000-00', phone = '(00) 00000-0000', company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '9f6b6903-d723-41dd-abdb-3af008e10aaa';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = '925c3a0d-79b7-443a-9906-e4102af49f54' WHERE user_id = '9f6b6903-d723-41dd-abdb-3af008e10aaa';

-- Ana Carolina Frescurato da Silva (carol@buscarid.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5d9ec5be-f9a0-4b81-a1ab-e546ab705be8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carol@buscarid.com', '', '2025-11-17T17:40:37.000Z', '2025-11-17T17:40:37.000Z', '2025-11-17T17:40:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Carolina Frescurato da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('274d540b-c6ce-4aab-a874-afbafcbf462d', '5d9ec5be-f9a0-4b81-a1ab-e546ab705be8', '{"sub":"5d9ec5be-f9a0-4b81-a1ab-e546ab705be8","email":"carol@buscarid.com","email_verified":true}', 'email', '5d9ec5be-f9a0-4b81-a1ab-e546ab705be8', '2025-11-17T17:40:37.000Z', '2025-11-17T17:40:37.000Z', '2025-11-17T17:40:38.000Z');
UPDATE public.profiles SET name = 'Ana Carolina Frescurato da Silva', cpf = '13860554689', phone = '31994419120', company_id = 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73', department_id = '8b213a2b-fb8e-4e66-947d-47387a72205a' WHERE user_id = '5d9ec5be-f9a0-4b81-a1ab-e546ab705be8';
UPDATE public.user_roles SET company_id = 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73' WHERE user_id = '5d9ec5be-f9a0-4b81-a1ab-e546ab705be8';

-- Rodrigo Nascimento (rodrigo@buscarid.com) | Role: master_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('253e2e3f-787f-454f-91d6-63e490909334', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rodrigo@buscarid.com', '', '2025-11-18T02:21:31.000Z', '2025-11-18T02:21:31.000Z', '2026-01-26T02:49:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Nascimento"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('632ce22c-e3c4-48f9-aadc-1841610e9293', '253e2e3f-787f-454f-91d6-63e490909334', '{"sub":"253e2e3f-787f-454f-91d6-63e490909334","email":"rodrigo@buscarid.com","email_verified":true}', 'email', '253e2e3f-787f-454f-91d6-63e490909334', '2025-11-18T02:21:31.000Z', '2026-01-26T02:49:37.000Z', '2026-01-26T02:49:37.000Z');
UPDATE public.profiles SET name = 'Rodrigo Nascimento', company_id = 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73' WHERE user_id = '253e2e3f-787f-454f-91d6-63e490909334';
UPDATE public.user_roles SET role = 'master_admin'::public.app_role, company_id = 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73' WHERE user_id = '253e2e3f-787f-454f-91d6-63e490909334';

-- Eduardo Ponce (duponce.mcc@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('be2867ea-495a-4bc3-bada-334540c4a869', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'duponce.mcc@gmail.com', '', '2025-11-21T00:10:40.000Z', '2025-11-21T00:10:40.000Z', '2025-11-21T00:14:41.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Eduardo Ponce"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('be81d2f9-1fc4-4c2b-9c6c-5d8c1b56616b', 'be2867ea-495a-4bc3-bada-334540c4a869', '{"sub":"be2867ea-495a-4bc3-bada-334540c4a869","email":"duponce.mcc@gmail.com","email_verified":true}', 'email', 'be2867ea-495a-4bc3-bada-334540c4a869', '2025-11-21T00:10:40.000Z', '2025-11-21T00:14:41.000Z', '2025-11-21T00:14:42.000Z');
UPDATE public.profiles SET name = 'Eduardo Ponce', cpf = '00147107652', phone = '31984301334', company_id = 'aface7a1-e0e5-4af4-854b-437da0d54b5b' WHERE user_id = 'be2867ea-495a-4bc3-bada-334540c4a869';
UPDATE public.user_roles SET company_id = 'aface7a1-e0e5-4af4-854b-437da0d54b5b' WHERE user_id = 'be2867ea-495a-4bc3-bada-334540c4a869';

-- Lucas de Paulo Chaves (lukedepaulo@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8e898ac1-f0ba-4868-a0f4-5f8fb207fea5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lukedepaulo@gmail.com', '', '2025-12-02T23:17:16.000Z', '2025-12-02T23:17:16.000Z', '2025-12-14T02:12:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lucas de Paulo Chaves"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cc479984-e105-41c8-87c1-fbd8521493ef', '8e898ac1-f0ba-4868-a0f4-5f8fb207fea5', '{"sub":"8e898ac1-f0ba-4868-a0f4-5f8fb207fea5","email":"lukedepaulo@gmail.com","email_verified":true}', 'email', '8e898ac1-f0ba-4868-a0f4-5f8fb207fea5', '2025-12-02T23:17:16.000Z', '2025-12-14T02:12:33.000Z', '2025-12-14T02:12:32.000Z');
UPDATE public.profiles SET name = 'Lucas de Paulo Chaves', cpf = '11247430650', phone = '31984738582', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '8e898ac1-f0ba-4868-a0f4-5f8fb207fea5';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '8e898ac1-f0ba-4868-a0f4-5f8fb207fea5';

-- Jéssica Lisboa Maia (jessica.maia@fundacaocdlbh.org.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6f0a8c00-062c-4d5a-9f90-f72a6984dd84', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jessica.maia@fundacaocdlbh.org.br', '', '2025-12-02T23:17:18.000Z', '2025-12-02T23:17:18.000Z', '2025-12-02T23:47:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Jéssica Lisboa Maia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c651a678-1f48-4fe8-b6be-5a30230ab018', '6f0a8c00-062c-4d5a-9f90-f72a6984dd84', '{"sub":"6f0a8c00-062c-4d5a-9f90-f72a6984dd84","email":"jessica.maia@fundacaocdlbh.org.br","email_verified":true}', 'email', '6f0a8c00-062c-4d5a-9f90-f72a6984dd84', '2025-12-02T23:17:18.000Z', '2025-12-02T23:47:37.000Z', '2025-12-02T23:47:38.000Z');
UPDATE public.profiles SET name = 'Jéssica Lisboa Maia', cpf = '12602572667', phone = '31991200680', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '6f0a8c00-062c-4d5a-9f90-f72a6984dd84';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '6f0a8c00-062c-4d5a-9f90-f72a6984dd84';

-- Guilherme Augusto de Melo Almeida (guilherme@ctrl.cnt.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1933b24f-1615-41fe-a236-7a487a71455b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'guilherme@ctrl.cnt.br', '', '2025-12-02T23:17:19.000Z', '2025-12-02T23:17:19.000Z', '2025-12-02T23:52:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Guilherme Augusto de Melo Almeida"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('aafa2f17-a0e2-4687-b37e-38e717cca62b', '1933b24f-1615-41fe-a236-7a487a71455b', '{"sub":"1933b24f-1615-41fe-a236-7a487a71455b","email":"guilherme@ctrl.cnt.br","email_verified":true}', 'email', '1933b24f-1615-41fe-a236-7a487a71455b', '2025-12-02T23:17:19.000Z', '2025-12-02T23:52:49.000Z', '2025-12-02T23:52:50.000Z');
UPDATE public.profiles SET name = 'Guilherme Augusto de Melo Almeida', cpf = '08879350609', phone = '31999161871', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '1933b24f-1615-41fe-a236-7a487a71455b';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '1933b24f-1615-41fe-a236-7a487a71455b';

-- Renato Dias Godinho Junior (renato_godinho@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a4d1456b-1d91-4b28-a91f-63df3ee176ea', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'renato_godinho@hotmail.com', '', '2025-12-02T23:17:21.000Z', '2025-12-02T23:17:21.000Z', '2025-12-03T00:21:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Renato Dias Godinho Junior"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0dba7d9b-3dc6-41b2-8b65-a31596a6e093', 'a4d1456b-1d91-4b28-a91f-63df3ee176ea', '{"sub":"a4d1456b-1d91-4b28-a91f-63df3ee176ea","email":"renato_godinho@hotmail.com","email_verified":true}', 'email', 'a4d1456b-1d91-4b28-a91f-63df3ee176ea', '2025-12-02T23:17:21.000Z', '2025-12-03T00:21:03.000Z', '2025-12-03T00:21:04.000Z');
UPDATE public.profiles SET name = 'Renato Dias Godinho Junior', cpf = '23085040803', phone = '31988682245', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'a4d1456b-1d91-4b28-a91f-63df3ee176ea';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'a4d1456b-1d91-4b28-a91f-63df3ee176ea';

-- Augusto Cezar Oliveira Izac  (augustoizac@gmail.con) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('eac4ba19-05e7-43f6-abfd-c7e782b3cdac', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'augustoizac@gmail.con', '', '2025-12-02T23:17:23.000Z', '2025-12-02T23:17:23.000Z', '2025-12-03T12:34:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Augusto Cezar Oliveira Izac "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cb5e0fc9-678c-4e49-91bd-ca45b2fa8d7a', 'eac4ba19-05e7-43f6-abfd-c7e782b3cdac', '{"sub":"eac4ba19-05e7-43f6-abfd-c7e782b3cdac","email":"augustoizac@gmail.con","email_verified":true}', 'email', 'eac4ba19-05e7-43f6-abfd-c7e782b3cdac', '2025-12-02T23:17:23.000Z', '2025-12-03T12:34:01.000Z', '2025-12-03T12:34:01.000Z');
UPDATE public.profiles SET name = 'Augusto Cezar Oliveira Izac ', cpf = '09116522648', phone = '31984245873', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'eac4ba19-05e7-43f6-abfd-c7e782b3cdac';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'eac4ba19-05e7-43f6-abfd-c7e782b3cdac';

-- ALYSSON VINICIUS LIMA GUIMARAES (alysson.guimaraes@cdlbh.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f2e6cfa0-1a6d-42b7-bb19-ba459a7aada9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alysson.guimaraes@cdlbh.com.br', '', '2025-12-02T23:17:24.000Z', '2025-12-02T23:17:24.000Z', '2025-12-03T03:20:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ALYSSON VINICIUS LIMA GUIMARAES"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b129d3d2-7896-448c-b4e2-ebb241b1f325', 'f2e6cfa0-1a6d-42b7-bb19-ba459a7aada9', '{"sub":"f2e6cfa0-1a6d-42b7-bb19-ba459a7aada9","email":"alysson.guimaraes@cdlbh.com.br","email_verified":true}', 'email', 'f2e6cfa0-1a6d-42b7-bb19-ba459a7aada9', '2025-12-02T23:17:24.000Z', '2025-12-03T03:20:48.000Z', '2025-12-03T03:20:49.000Z');
UPDATE public.profiles SET name = 'ALYSSON VINICIUS LIMA GUIMARAES', cpf = '05222714640', phone = '31992135858', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'f2e6cfa0-1a6d-42b7-bb19-ba459a7aada9';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'f2e6cfa0-1a6d-42b7-bb19-ba459a7aada9';

-- Emely Gaspar Teles (emelygaspar@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b9dbbeaf-6db0-49ec-b74f-8987cabf81e9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'emelygaspar@gmail.com', '', '2025-12-02T23:17:25.000Z', '2025-12-02T23:17:25.000Z', '2025-12-03T03:20:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Emely Gaspar Teles"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7344807e-956e-4347-bd03-1dc789f80792', 'b9dbbeaf-6db0-49ec-b74f-8987cabf81e9', '{"sub":"b9dbbeaf-6db0-49ec-b74f-8987cabf81e9","email":"emelygaspar@gmail.com","email_verified":true}', 'email', 'b9dbbeaf-6db0-49ec-b74f-8987cabf81e9', '2025-12-02T23:17:25.000Z', '2025-12-03T03:20:32.000Z', '2025-12-03T03:20:32.000Z');
UPDATE public.profiles SET name = 'Emely Gaspar Teles', cpf = '07786678638', phone = '31999426153', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'b9dbbeaf-6db0-49ec-b74f-8987cabf81e9';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'b9dbbeaf-6db0-49ec-b74f-8987cabf81e9';

-- Adriano dos Santos Boscatte  (adrianoboscatte@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('77914e82-ea17-4f92-8517-169a469fb5e1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'adrianoboscatte@gmail.com', '', '2025-12-02T23:17:26.000Z', '2025-12-02T23:17:26.000Z', '2025-12-05T04:33:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Adriano dos Santos Boscatte "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0e258f31-4bdb-43d0-821a-123e772b14ae', '77914e82-ea17-4f92-8517-169a469fb5e1', '{"sub":"77914e82-ea17-4f92-8517-169a469fb5e1","email":"adrianoboscatte@gmail.com","email_verified":true}', 'email', '77914e82-ea17-4f92-8517-169a469fb5e1', '2025-12-02T23:17:26.000Z', '2025-12-05T04:33:47.000Z', '2025-12-05T04:33:47.000Z');
UPDATE public.profiles SET name = 'Adriano dos Santos Boscatte ', cpf = '00138760667', phone = '31987374686', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '77914e82-ea17-4f92-8517-169a469fb5e1';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '77914e82-ea17-4f92-8517-169a469fb5e1';

-- Luísa Meneghetti Almeida Melo (luisa@cpbellaperfumes.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5d445a43-ff6f-4be8-a5f4-9cd1ce29d794', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'luisa@cpbellaperfumes.com.br', '', '2025-12-02T23:17:28.000Z', '2025-12-02T23:17:28.000Z', '2025-12-02T23:50:11.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Luísa Meneghetti Almeida Melo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('570beba0-c143-45a5-9216-39c565238a68', '5d445a43-ff6f-4be8-a5f4-9cd1ce29d794', '{"sub":"5d445a43-ff6f-4be8-a5f4-9cd1ce29d794","email":"luisa@cpbellaperfumes.com.br","email_verified":true}', 'email', '5d445a43-ff6f-4be8-a5f4-9cd1ce29d794', '2025-12-02T23:17:28.000Z', '2025-12-02T23:50:11.000Z', '2025-12-02T23:50:11.000Z');
UPDATE public.profiles SET name = 'Luísa Meneghetti Almeida Melo', cpf = '13794575644', phone = '31999289667', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '5d445a43-ff6f-4be8-a5f4-9cd1ce29d794';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '5d445a43-ff6f-4be8-a5f4-9cd1ce29d794';

-- Gabriel Junqueira (gabriel.junqueira@avancoinfo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6a313c0a-f144-4d45-88a9-7c5991e2c86e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gabriel.junqueira@avancoinfo.com.br', '', '2025-12-02T23:17:31.000Z', '2025-12-02T23:17:31.000Z', '2025-12-02T23:36:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gabriel Junqueira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('359cc3ec-6955-409a-afb7-90beb5d9e878', '6a313c0a-f144-4d45-88a9-7c5991e2c86e', '{"sub":"6a313c0a-f144-4d45-88a9-7c5991e2c86e","email":"gabriel.junqueira@avancoinfo.com.br","email_verified":true}', 'email', '6a313c0a-f144-4d45-88a9-7c5991e2c86e', '2025-12-02T23:17:31.000Z', '2025-12-02T23:36:07.000Z', '2025-12-02T23:36:08.000Z');
UPDATE public.profiles SET name = 'Gabriel Junqueira', cpf = '01560949678', phone = '31982819736', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '6a313c0a-f144-4d45-88a9-7c5991e2c86e';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '6a313c0a-f144-4d45-88a9-7c5991e2c86e';

-- Joás Pessoa da Cruz (joas_pessoa@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f7c0adcc-b720-4ebd-b01c-dad91d999830', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joas_pessoa@hotmail.com', '', '2025-12-02T23:17:31.000Z', '2025-12-02T23:17:31.000Z', '2025-12-02T23:33:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Joás Pessoa da Cruz"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('eae7fdca-a3af-4179-8c2e-61dfd41602b0', 'f7c0adcc-b720-4ebd-b01c-dad91d999830', '{"sub":"f7c0adcc-b720-4ebd-b01c-dad91d999830","email":"joas_pessoa@hotmail.com","email_verified":true}', 'email', 'f7c0adcc-b720-4ebd-b01c-dad91d999830', '2025-12-02T23:17:31.000Z', '2025-12-02T23:33:51.000Z', '2025-12-02T23:33:51.000Z');
UPDATE public.profiles SET name = 'Joás Pessoa da Cruz', cpf = '08607452444', phone = '31982152280', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'f7c0adcc-b720-4ebd-b01c-dad91d999830';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'f7c0adcc-b720-4ebd-b01c-dad91d999830';

-- Marlucio Rodrigues da silva  (marlucio.silva@fundacaocdlbh.org) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('52f25ede-65d4-4f0d-a681-884136bbe613', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'marlucio.silva@fundacaocdlbh.org', '', '2025-12-02T23:17:32.000Z', '2025-12-02T23:17:32.000Z', '2025-12-02T23:41:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marlucio Rodrigues da silva "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('86bde7c8-d5d6-4d73-a193-9c5f968f4b62', '52f25ede-65d4-4f0d-a681-884136bbe613', '{"sub":"52f25ede-65d4-4f0d-a681-884136bbe613","email":"marlucio.silva@fundacaocdlbh.org","email_verified":true}', 'email', '52f25ede-65d4-4f0d-a681-884136bbe613', '2025-12-02T23:17:32.000Z', '2025-12-02T23:41:36.000Z', '2025-12-02T23:41:36.000Z');
UPDATE public.profiles SET name = 'Marlucio Rodrigues da silva ', cpf = '05791659652', phone = '31987547509', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '52f25ede-65d4-4f0d-a681-884136bbe613';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '52f25ede-65d4-4f0d-a681-884136bbe613';

-- Bruna Silva (brunarpn@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('87778b25-7cac-41fb-a9ef-32ef172a2dba', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'brunarpn@gmail.com', '', '2025-12-02T23:17:36.000Z', '2025-12-02T23:17:36.000Z', '2026-01-01T08:48:46.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Bruna Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5dccd04b-5f02-44b9-a14a-d3e5fd7ae306', '87778b25-7cac-41fb-a9ef-32ef172a2dba', '{"sub":"87778b25-7cac-41fb-a9ef-32ef172a2dba","email":"brunarpn@gmail.com","email_verified":true}', 'email', '87778b25-7cac-41fb-a9ef-32ef172a2dba', '2025-12-02T23:17:36.000Z', '2026-01-01T08:48:46.000Z', '2026-01-01T08:48:47.000Z');
UPDATE public.profiles SET name = 'Bruna Silva', cpf = '01551315670', phone = '31989795140', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '87778b25-7cac-41fb-a9ef-32ef172a2dba';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '87778b25-7cac-41fb-a9ef-32ef172a2dba';

-- Débora Franciele goncalves  Drumond  (debora.com.mkt@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a09ca078-b45f-4f00-abf2-bc72429725a4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'debora.com.mkt@gmail.com', '', '2025-12-02T23:17:38.000Z', '2025-12-02T23:17:38.000Z', '2025-12-02T23:29:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Débora Franciele goncalves  Drumond "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('87155efa-a61c-4e4b-ac80-69c109d8fe58', 'a09ca078-b45f-4f00-abf2-bc72429725a4', '{"sub":"a09ca078-b45f-4f00-abf2-bc72429725a4","email":"debora.com.mkt@gmail.com","email_verified":true}', 'email', 'a09ca078-b45f-4f00-abf2-bc72429725a4', '2025-12-02T23:17:38.000Z', '2025-12-02T23:29:19.000Z', '2025-12-02T23:29:20.000Z');
UPDATE public.profiles SET name = 'Débora Franciele goncalves  Drumond ', cpf = '12180551622', phone = '31972487091', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'a09ca078-b45f-4f00-abf2-bc72429725a4';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'a09ca078-b45f-4f00-abf2-bc72429725a4';

-- BRENO FERREIRA DUARTE (brenoduarte@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d2bae856-ee2e-4ec8-a923-2cb455820d53', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'brenoduarte@hotmail.com', '', '2025-12-02T23:17:41.000Z', '2025-12-02T23:17:41.000Z', '2025-12-03T00:51:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"BRENO FERREIRA DUARTE"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2c8a0a58-3e6d-4b5c-982d-3a2ff57acabd', 'd2bae856-ee2e-4ec8-a923-2cb455820d53', '{"sub":"d2bae856-ee2e-4ec8-a923-2cb455820d53","email":"brenoduarte@hotmail.com","email_verified":true}', 'email', 'd2bae856-ee2e-4ec8-a923-2cb455820d53', '2025-12-02T23:17:41.000Z', '2025-12-03T00:51:51.000Z', '2025-12-03T00:51:52.000Z');
UPDATE public.profiles SET name = 'BRENO FERREIRA DUARTE', cpf = '04745961685', phone = '31999519555', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'd2bae856-ee2e-4ec8-a923-2cb455820d53';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'd2bae856-ee2e-4ec8-a923-2cb455820d53';

-- Wadir Proença Simão (wadir@bellaboticario.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7c06cf8e-37e4-4ad0-8aaa-f34b794c206e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'wadir@bellaboticario.com.br', '', '2025-12-02T23:17:43.000Z', '2025-12-02T23:17:43.000Z', '2025-12-03T03:43:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Wadir Proença Simão"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('79f77104-51ac-44d0-9112-994982361e33', '7c06cf8e-37e4-4ad0-8aaa-f34b794c206e', '{"sub":"7c06cf8e-37e4-4ad0-8aaa-f34b794c206e","email":"wadir@bellaboticario.com.br","email_verified":true}', 'email', '7c06cf8e-37e4-4ad0-8aaa-f34b794c206e', '2025-12-02T23:17:43.000Z', '2025-12-03T03:43:06.000Z', '2025-12-03T03:43:07.000Z');
UPDATE public.profiles SET name = 'Wadir Proença Simão', cpf = '50873210620', phone = '3199769621', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '7c06cf8e-37e4-4ad0-8aaa-f34b794c206e';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '7c06cf8e-37e4-4ad0-8aaa-f34b794c206e';

-- José Ângelo de melo (joseangelo@bellaboticario.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f49d67ac-3b99-4504-b85c-d3a2721e98e5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joseangelo@bellaboticario.com.br', '', '2025-12-02T23:17:48.000Z', '2025-12-02T23:17:48.000Z', '2025-12-02T23:18:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"José Ângelo de melo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1c16549e-b433-424c-acbb-3e4c364ea33c', 'f49d67ac-3b99-4504-b85c-d3a2721e98e5', '{"sub":"f49d67ac-3b99-4504-b85c-d3a2721e98e5","email":"joseangelo@bellaboticario.com.br","email_verified":true}', 'email', 'f49d67ac-3b99-4504-b85c-d3a2721e98e5', '2025-12-02T23:17:48.000Z', '2025-12-02T23:18:57.000Z', '2025-12-02T23:18:58.000Z');
UPDATE public.profiles SET name = 'José Ângelo de melo', cpf = '37527274620', phone = '31999353010', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'f49d67ac-3b99-4504-b85c-d3a2721e98e5';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'f49d67ac-3b99-4504-b85c-d3a2721e98e5';

-- José Américo de Andrade Júnior (junioramerico@atsinformatica.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9c9e672f-e1c4-407c-9529-bdf05a58039d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'junioramerico@atsinformatica.com.br', '', '2025-12-02T23:17:51.000Z', '2025-12-02T23:17:51.000Z', '2025-12-03T04:22:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"José Américo de Andrade Júnior"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1bb4c324-ea23-4ed8-a6f5-b859aa49d884', '9c9e672f-e1c4-407c-9529-bdf05a58039d', '{"sub":"9c9e672f-e1c4-407c-9529-bdf05a58039d","email":"junioramerico@atsinformatica.com.br","email_verified":true}', 'email', '9c9e672f-e1c4-407c-9529-bdf05a58039d', '2025-12-02T23:17:51.000Z', '2025-12-03T04:22:33.000Z', '2025-12-03T04:22:33.000Z');
UPDATE public.profiles SET name = 'José Américo de Andrade Júnior', cpf = '01234567890', phone = '31982243281', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '9c9e672f-e1c4-407c-9529-bdf05a58039d';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '9c9e672f-e1c4-407c-9529-bdf05a58039d';

-- Ulisses Samarone Pereira Coelho  (ulissessamarone@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fb1a55db-0dbc-4439-97c7-01dbb172d4db', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ulissessamarone@gmail.com', '', '2025-12-02T23:17:55.000Z', '2025-12-02T23:17:55.000Z', '2025-12-03T02:01:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ulisses Samarone Pereira Coelho "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('86e4603e-3582-4105-97ec-3bb6f4a18e74', 'fb1a55db-0dbc-4439-97c7-01dbb172d4db', '{"sub":"fb1a55db-0dbc-4439-97c7-01dbb172d4db","email":"ulissessamarone@gmail.com","email_verified":true}', 'email', 'fb1a55db-0dbc-4439-97c7-01dbb172d4db', '2025-12-02T23:17:55.000Z', '2025-12-03T02:01:48.000Z', '2025-12-03T02:01:48.000Z');
UPDATE public.profiles SET name = 'Ulisses Samarone Pereira Coelho ', cpf = '06650909602', phone = '31989572995', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'fb1a55db-0dbc-4439-97c7-01dbb172d4db';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'fb1a55db-0dbc-4439-97c7-01dbb172d4db';

-- Carlos Eduardo Machado de Almeida e Sousa (carloseduardo.cacaushowbh@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('af360b43-078e-4982-955c-d1fe3d50db77', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carloseduardo.cacaushowbh@gmail.com', '', '2025-12-02T23:17:57.000Z', '2025-12-02T23:17:57.000Z', '2025-12-03T15:17:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carlos Eduardo Machado de Almeida e Sousa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c84e38df-0b6d-40e3-8b5b-f28ecfe63f43', 'af360b43-078e-4982-955c-d1fe3d50db77', '{"sub":"af360b43-078e-4982-955c-d1fe3d50db77","email":"carloseduardo.cacaushowbh@gmail.com","email_verified":true}', 'email', 'af360b43-078e-4982-955c-d1fe3d50db77', '2025-12-02T23:17:57.000Z', '2025-12-03T15:17:03.000Z', '2025-12-03T15:17:01.000Z');
UPDATE public.profiles SET name = 'Carlos Eduardo Machado de Almeida e Sousa', cpf = '01453193693', phone = '31993409349', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'af360b43-078e-4982-955c-d1fe3d50db77';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'af360b43-078e-4982-955c-d1fe3d50db77';

-- Carlo Eduardo Grimaldi  (carloeduardo@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('67ad35fb-1c70-400b-86fd-deabcd585914', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carloeduardo@gmail.com', '', '2025-12-02T23:18:07.000Z', '2025-12-02T23:18:07.000Z', '2025-12-03T03:41:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carlo Eduardo Grimaldi "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('27efec85-a581-4382-92c5-76d3c6973443', '67ad35fb-1c70-400b-86fd-deabcd585914', '{"sub":"67ad35fb-1c70-400b-86fd-deabcd585914","email":"carloeduardo@gmail.com","email_verified":true}', 'email', '67ad35fb-1c70-400b-86fd-deabcd585914', '2025-12-02T23:18:07.000Z', '2025-12-03T03:41:02.000Z', '2025-12-03T03:41:02.000Z');
UPDATE public.profiles SET name = 'Carlo Eduardo Grimaldi ', cpf = '06241362640', phone = '31994310008', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '67ad35fb-1c70-400b-86fd-deabcd585914';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '67ad35fb-1c70-400b-86fd-deabcd585914';

-- Joao Victor Renault (joaovictor@cdlbh.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d7676920-9d95-44ad-bab6-4fd6dab3c831', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joaovictor@cdlbh.com.br', '', '2025-12-02T23:18:07.000Z', '2025-12-02T23:18:07.000Z', '2025-12-02T23:42:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Joao Victor Renault"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5c5b5a5b-946c-4997-8a17-c037c9940ec4', 'd7676920-9d95-44ad-bab6-4fd6dab3c831', '{"sub":"d7676920-9d95-44ad-bab6-4fd6dab3c831","email":"joaovictor@cdlbh.com.br","email_verified":true}', 'email', 'd7676920-9d95-44ad-bab6-4fd6dab3c831', '2025-12-02T23:18:07.000Z', '2025-12-02T23:42:33.000Z', '2025-12-02T23:42:33.000Z');
UPDATE public.profiles SET name = 'Joao Victor Renault', cpf = '45524696653', phone = '31992421638', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'd7676920-9d95-44ad-bab6-4fd6dab3c831';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'd7676920-9d95-44ad-bab6-4fd6dab3c831';

-- Ana Lara Mendonça  (analaraest@icloud.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bb0d84d0-6522-4232-b529-be7578cc7384', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'analaraest@icloud.com', '', '2025-12-02T23:18:16.000Z', '2025-12-02T23:18:16.000Z', '2025-12-02T23:39:40.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Lara Mendonça "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b6949b77-9987-483d-b979-4e6f1d1199fc', 'bb0d84d0-6522-4232-b529-be7578cc7384', '{"sub":"bb0d84d0-6522-4232-b529-be7578cc7384","email":"analaraest@icloud.com","email_verified":true}', 'email', 'bb0d84d0-6522-4232-b529-be7578cc7384', '2025-12-02T23:18:16.000Z', '2025-12-02T23:39:40.000Z', '2025-12-02T23:39:41.000Z');
UPDATE public.profiles SET name = 'Ana Lara Mendonça ', cpf = '13635598690', phone = '31986179499', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'bb0d84d0-6522-4232-b529-be7578cc7384';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'bb0d84d0-6522-4232-b529-be7578cc7384';

-- Hitalo Carvalho (hitalocarvalho@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('109fa513-81c6-4f07-bb68-62585c5b5b0b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'hitalocarvalho@gmail.com', '', '2025-12-02T23:18:22.000Z', '2025-12-02T23:18:22.000Z', '2025-12-02T23:53:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Hitalo Carvalho"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fef5ca8b-cd19-448a-b1ec-9d6518d8134e', '109fa513-81c6-4f07-bb68-62585c5b5b0b', '{"sub":"109fa513-81c6-4f07-bb68-62585c5b5b0b","email":"hitalocarvalho@gmail.com","email_verified":true}', 'email', '109fa513-81c6-4f07-bb68-62585c5b5b0b', '2025-12-02T23:18:22.000Z', '2025-12-02T23:53:36.000Z', '2025-12-02T23:53:36.000Z');
UPDATE public.profiles SET name = 'Hitalo Carvalho', cpf = '12923589637', phone = '38992292662', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '109fa513-81c6-4f07-bb68-62585c5b5b0b';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '109fa513-81c6-4f07-bb68-62585c5b5b0b';

-- Ana Karla  Morais Goncalves (anakarlamoraisg@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('72924e46-2260-4783-8114-4f9e1c52b702', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'anakarlamoraisg@gmail.com', '', '2025-12-02T23:18:34.000Z', '2025-12-02T23:18:34.000Z', '2025-12-08T01:57:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Karla  Morais Goncalves"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('05402e53-da55-4628-81f8-b33357f59d01', '72924e46-2260-4783-8114-4f9e1c52b702', '{"sub":"72924e46-2260-4783-8114-4f9e1c52b702","email":"anakarlamoraisg@gmail.com","email_verified":true}', 'email', '72924e46-2260-4783-8114-4f9e1c52b702', '2025-12-02T23:18:34.000Z', '2025-12-08T01:57:55.000Z', '2025-12-08T01:57:54.000Z');
UPDATE public.profiles SET name = 'Ana Karla  Morais Goncalves', cpf = '11665188685', phone = '31991535483', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '72924e46-2260-4783-8114-4f9e1c52b702';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '72924e46-2260-4783-8114-4f9e1c52b702';

-- Isis dos Santos Kroeff (isis.or.natural@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f5d1c05a-8121-430c-844d-8def02d973f8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'isis.or.natural@gmail.com', '', '2025-12-02T23:18:40.000Z', '2025-12-02T23:18:40.000Z', '2025-12-02T23:28:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Isis dos Santos Kroeff"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9aa53c01-3770-403f-89db-1721640ad5bc', 'f5d1c05a-8121-430c-844d-8def02d973f8', '{"sub":"f5d1c05a-8121-430c-844d-8def02d973f8","email":"isis.or.natural@gmail.com","email_verified":true}', 'email', 'f5d1c05a-8121-430c-844d-8def02d973f8', '2025-12-02T23:18:40.000Z', '2025-12-02T23:28:12.000Z', '2025-12-02T23:28:12.000Z');
UPDATE public.profiles SET name = 'Isis dos Santos Kroeff', cpf = '07316813636', phone = '31995570620', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'f5d1c05a-8121-430c-844d-8def02d973f8';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'f5d1c05a-8121-430c-844d-8def02d973f8';

-- Aquilis Dictis Moreira Kilão (aquilis.moreira@oktz.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('020ed065-fca5-4ff0-96de-60e47310bc0d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'aquilis.moreira@oktz.com.br', '', '2025-12-02T23:18:45.000Z', '2025-12-02T23:18:45.000Z', '2026-01-28T00:42:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Aquilis Dictis Moreira Kilão"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2d9ae5ca-86df-4ca5-b5e4-b82d91d34d78', '020ed065-fca5-4ff0-96de-60e47310bc0d', '{"sub":"020ed065-fca5-4ff0-96de-60e47310bc0d","email":"aquilis.moreira@oktz.com.br","email_verified":true}', 'email', '020ed065-fca5-4ff0-96de-60e47310bc0d', '2025-12-02T23:18:45.000Z', '2026-01-28T00:42:07.000Z', '2026-01-28T00:42:06.000Z');
UPDATE public.profiles SET name = 'Aquilis Dictis Moreira Kilão', cpf = '03673160648', phone = '31996793230', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '020ed065-fca5-4ff0-96de-60e47310bc0d';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '020ed065-fca5-4ff0-96de-60e47310bc0d';

-- Raquel Ferreira (k.raquelferreira@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('709e5120-cb8a-43b5-9411-540e7ebc2520', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'k.raquelferreira@gmail.com', '', '2025-12-02T23:18:47.000Z', '2025-12-02T23:18:47.000Z', '2025-12-03T00:18:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Raquel Ferreira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3ea673c5-a0a7-4298-93fc-1aba33855897', '709e5120-cb8a-43b5-9411-540e7ebc2520', '{"sub":"709e5120-cb8a-43b5-9411-540e7ebc2520","email":"k.raquelferreira@gmail.com","email_verified":true}', 'email', '709e5120-cb8a-43b5-9411-540e7ebc2520', '2025-12-02T23:18:47.000Z', '2025-12-03T00:18:59.000Z', '2025-12-03T00:19:00.000Z');
UPDATE public.profiles SET name = 'Raquel Ferreira', cpf = '07542443690', phone = '31984589455', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '709e5120-cb8a-43b5-9411-540e7ebc2520';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '709e5120-cb8a-43b5-9411-540e7ebc2520';

-- Gabriel Falci (gabrielvfalci@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bbdfdc2d-6ff1-4b70-9f4f-5f74b136b778', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gabrielvfalci@gmail.com', '', '2025-12-02T23:18:57.000Z', '2025-12-02T23:18:57.000Z', '2025-12-02T23:44:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gabriel Falci"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('aa47b2b7-723f-49ae-9932-cdaf1428f072', 'bbdfdc2d-6ff1-4b70-9f4f-5f74b136b778', '{"sub":"bbdfdc2d-6ff1-4b70-9f4f-5f74b136b778","email":"gabrielvfalci@gmail.com","email_verified":true}', 'email', 'bbdfdc2d-6ff1-4b70-9f4f-5f74b136b778', '2025-12-02T23:18:57.000Z', '2025-12-02T23:44:19.000Z', '2025-12-02T23:44:20.000Z');
UPDATE public.profiles SET name = 'Gabriel Falci', cpf = '01266795685', phone = '31988351958', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'bbdfdc2d-6ff1-4b70-9f4f-5f74b136b778';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'bbdfdc2d-6ff1-4b70-9f4f-5f74b136b778';

-- Hellen Machado Ramos Xavier (hellenmr87@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1f698d37-9797-457f-bb05-e4b8f09eeced', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'hellenmr87@yahoo.com.br', '', '2025-12-02T23:19:06.000Z', '2025-12-02T23:19:06.000Z', '2025-12-02T23:45:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Hellen Machado Ramos Xavier"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b8cfb3eb-7a4f-4b77-ac48-6bee99ebcc2b', '1f698d37-9797-457f-bb05-e4b8f09eeced', '{"sub":"1f698d37-9797-457f-bb05-e4b8f09eeced","email":"hellenmr87@yahoo.com.br","email_verified":true}', 'email', '1f698d37-9797-457f-bb05-e4b8f09eeced', '2025-12-02T23:19:06.000Z', '2025-12-02T23:45:10.000Z', '2025-12-02T23:45:10.000Z');
UPDATE public.profiles SET name = 'Hellen Machado Ramos Xavier', cpf = '01597557609', phone = '31991348917', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '1f698d37-9797-457f-bb05-e4b8f09eeced';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '1f698d37-9797-457f-bb05-e4b8f09eeced';

-- Alexandre Santos (alexandresantos@smcit.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('100cef08-f201-4d2c-a8b4-8b72fbe5bf1d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alexandresantos@smcit.com.br', '', '2025-12-02T23:19:13.000Z', '2025-12-02T23:19:13.000Z', '2025-12-02T23:47:30.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alexandre Santos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('50d43493-b450-4bcd-8032-9971e1e23c00', '100cef08-f201-4d2c-a8b4-8b72fbe5bf1d', '{"sub":"100cef08-f201-4d2c-a8b4-8b72fbe5bf1d","email":"alexandresantos@smcit.com.br","email_verified":true}', 'email', '100cef08-f201-4d2c-a8b4-8b72fbe5bf1d', '2025-12-02T23:19:13.000Z', '2025-12-02T23:47:30.000Z', '2025-12-02T23:47:30.000Z');
UPDATE public.profiles SET name = 'Alexandre Santos', cpf = '01603722670', phone = '31993968637', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '100cef08-f201-4d2c-a8b4-8b72fbe5bf1d';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '100cef08-f201-4d2c-a8b4-8b72fbe5bf1d';

-- Fausto Sebastião Izac (faustocasabranca@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7720709b-be36-45c5-b7c5-8ff16d8e372e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'faustocasabranca@gmail.com', '', '2025-12-02T23:19:25.000Z', '2025-12-02T23:19:25.000Z', '2025-12-02T23:36:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fausto Sebastião Izac"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('229076c3-3f1b-4d81-b04b-5372ec509916', '7720709b-be36-45c5-b7c5-8ff16d8e372e', '{"sub":"7720709b-be36-45c5-b7c5-8ff16d8e372e","email":"faustocasabranca@gmail.com","email_verified":true}', 'email', '7720709b-be36-45c5-b7c5-8ff16d8e372e', '2025-12-02T23:19:25.000Z', '2025-12-02T23:36:35.000Z', '2025-12-02T23:36:35.000Z');
UPDATE public.profiles SET name = 'Fausto Sebastião Izac', cpf = '29339090659', phone = '31984242621', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '7720709b-be36-45c5-b7c5-8ff16d8e372e';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '7720709b-be36-45c5-b7c5-8ff16d8e372e';

-- Camila  (camilarvalentim@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b80b1268-9bc5-4761-8372-eb7ce8670c5a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'camilarvalentim@gmail.com', '', '2025-12-02T23:19:32.000Z', '2025-12-02T23:19:32.000Z', '2025-12-02T23:35:30.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Camila "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2302640f-942d-4769-8025-84e9823d2433', 'b80b1268-9bc5-4761-8372-eb7ce8670c5a', '{"sub":"b80b1268-9bc5-4761-8372-eb7ce8670c5a","email":"camilarvalentim@gmail.com","email_verified":true}', 'email', 'b80b1268-9bc5-4761-8372-eb7ce8670c5a', '2025-12-02T23:19:32.000Z', '2025-12-02T23:35:30.000Z', '2025-12-02T23:35:31.000Z');
UPDATE public.profiles SET name = 'Camila ', cpf = '11089162600', phone = '31993972597', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'b80b1268-9bc5-4761-8372-eb7ce8670c5a';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'b80b1268-9bc5-4761-8372-eb7ce8670c5a';

-- Nayara Campos  (nayaralcampos@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('186d25fe-6bea-4e34-bd5a-b046ba1fb208', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'nayaralcampos@gmail.com', '', '2025-12-02T23:19:44.000Z', '2025-12-02T23:19:44.000Z', '2025-12-02T23:34:46.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Nayara Campos "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f9472725-41ff-4700-b0ed-e7d9ea5b963b', '186d25fe-6bea-4e34-bd5a-b046ba1fb208', '{"sub":"186d25fe-6bea-4e34-bd5a-b046ba1fb208","email":"nayaralcampos@gmail.com","email_verified":true}', 'email', '186d25fe-6bea-4e34-bd5a-b046ba1fb208', '2025-12-02T23:19:44.000Z', '2025-12-02T23:34:46.000Z', '2025-12-02T23:34:47.000Z');
UPDATE public.profiles SET name = 'Nayara Campos ', cpf = '09712858618', phone = '31999197296', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '186d25fe-6bea-4e34-bd5a-b046ba1fb208';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '186d25fe-6bea-4e34-bd5a-b046ba1fb208';

-- Vilson da Silva Mayrink (vilson.mayrink@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('35c84f0e-a14e-457f-bb6f-5bfb12ae457b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'vilson.mayrink@gmail.com', '', '2025-12-02T23:19:56.000Z', '2025-12-02T23:19:56.000Z', '2025-12-02T23:35:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Vilson da Silva Mayrink"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('aa13987d-a3b7-494a-919e-2ef059fee50d', '35c84f0e-a14e-457f-bb6f-5bfb12ae457b', '{"sub":"35c84f0e-a14e-457f-bb6f-5bfb12ae457b","email":"vilson.mayrink@gmail.com","email_verified":true}', 'email', '35c84f0e-a14e-457f-bb6f-5bfb12ae457b', '2025-12-02T23:19:56.000Z', '2025-12-02T23:35:02.000Z', '2025-12-02T23:35:03.000Z');
UPDATE public.profiles SET name = 'Vilson da Silva Mayrink', cpf = '80885187687', phone = '31992421943', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '35c84f0e-a14e-457f-bb6f-5bfb12ae457b';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '35c84f0e-a14e-457f-bb6f-5bfb12ae457b';

-- Marcos Flavio (mflaviocs@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('662b9247-9977-4ef8-929b-18a3f71edfed', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mflaviocs@gmail.com', '', '2025-12-02T23:19:59.000Z', '2025-12-02T23:19:59.000Z', '2025-12-02T23:26:38.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marcos Flavio"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4243b1a9-5440-420c-845f-5b0ebbe186af', '662b9247-9977-4ef8-929b-18a3f71edfed', '{"sub":"662b9247-9977-4ef8-929b-18a3f71edfed","email":"mflaviocs@gmail.com","email_verified":true}', 'email', '662b9247-9977-4ef8-929b-18a3f71edfed', '2025-12-02T23:19:59.000Z', '2025-12-02T23:26:38.000Z', '2025-12-02T23:26:38.000Z');
UPDATE public.profiles SET name = 'Marcos Flavio', cpf = '04593619610', phone = '31999056051', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '662b9247-9977-4ef8-929b-18a3f71edfed';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '662b9247-9977-4ef8-929b-18a3f71edfed';

-- LEONARDO CORREA CAMARGO (leocamargo@yahoo.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3fbcd55d-9d47-4e3e-b1a6-cc303aed5a9d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'leocamargo@yahoo.com', '', '2025-12-02T23:20:18.000Z', '2025-12-02T23:20:18.000Z', '2025-12-02T23:39:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"LEONARDO CORREA CAMARGO"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('75b76b64-0267-4603-a68d-673b6365581d', '3fbcd55d-9d47-4e3e-b1a6-cc303aed5a9d', '{"sub":"3fbcd55d-9d47-4e3e-b1a6-cc303aed5a9d","email":"leocamargo@yahoo.com","email_verified":true}', 'email', '3fbcd55d-9d47-4e3e-b1a6-cc303aed5a9d', '2025-12-02T23:20:18.000Z', '2025-12-02T23:39:21.000Z', '2025-12-02T23:39:21.000Z');
UPDATE public.profiles SET name = 'LEONARDO CORREA CAMARGO', cpf = '69477647691', phone = '31995721387', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '3fbcd55d-9d47-4e3e-b1a6-cc303aed5a9d';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '3fbcd55d-9d47-4e3e-b1a6-cc303aed5a9d';

-- João Augusto  (contato@uaiviajei.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bcaf7ba6-5a09-45fa-92da-cd1a200e6efe', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'contato@uaiviajei.com.br', '', '2025-12-02T23:20:21.000Z', '2025-12-02T23:20:21.000Z', '2025-12-03T17:25:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"João Augusto "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d970ccb2-2572-4b29-96f8-98afaf6b12cb', 'bcaf7ba6-5a09-45fa-92da-cd1a200e6efe', '{"sub":"bcaf7ba6-5a09-45fa-92da-cd1a200e6efe","email":"contato@uaiviajei.com.br","email_verified":true}', 'email', 'bcaf7ba6-5a09-45fa-92da-cd1a200e6efe', '2025-12-02T23:20:21.000Z', '2025-12-03T17:25:03.000Z', '2025-12-03T17:25:04.000Z');
UPDATE public.profiles SET name = 'João Augusto ', cpf = '08789574648', phone = '31991326834', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'bcaf7ba6-5a09-45fa-92da-cd1a200e6efe';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'bcaf7ba6-5a09-45fa-92da-cd1a200e6efe';

-- Joel Henrique de Souza Matos  (joel.souza@cdlbh.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d829258e-1851-4b17-853f-08112f340f1e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joel.souza@cdlbh.com.br', '', '2025-12-02T23:21:39.000Z', '2025-12-02T23:21:39.000Z', '2025-12-02T23:42:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Joel Henrique de Souza Matos "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2aac7a6c-a5da-4ecd-aec3-bfb3ca48e47b', 'd829258e-1851-4b17-853f-08112f340f1e', '{"sub":"d829258e-1851-4b17-853f-08112f340f1e","email":"joel.souza@cdlbh.com.br","email_verified":true}', 'email', 'd829258e-1851-4b17-853f-08112f340f1e', '2025-12-02T23:21:39.000Z', '2025-12-02T23:42:13.000Z', '2025-12-02T23:42:13.000Z');
UPDATE public.profiles SET name = 'Joel Henrique de Souza Matos ', cpf = '01497793645', phone = '31992850092', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'd829258e-1851-4b17-853f-08112f340f1e';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'd829258e-1851-4b17-853f-08112f340f1e';

-- jose angelo de melo (joseangelo.melo@cdlbh.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fda63257-34fd-4daf-a368-869d6b3d40a0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joseangelo.melo@cdlbh.com.br', '', '2025-12-02T23:21:41.000Z', '2025-12-02T23:21:41.000Z', '2025-12-02T23:39:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"jose angelo de melo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('53d4c0be-7af4-463c-a958-31e96a9f2f9a', 'fda63257-34fd-4daf-a368-869d6b3d40a0', '{"sub":"fda63257-34fd-4daf-a368-869d6b3d40a0","email":"joseangelo.melo@cdlbh.com.br","email_verified":true}', 'email', 'fda63257-34fd-4daf-a368-869d6b3d40a0', '2025-12-02T23:21:41.000Z', '2025-12-02T23:39:23.000Z', '2025-12-02T23:39:24.000Z');
UPDATE public.profiles SET name = 'jose angelo de melo', cpf = '37527274620', phone = '31999353060', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'fda63257-34fd-4daf-a368-869d6b3d40a0';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'fda63257-34fd-4daf-a368-869d6b3d40a0';

-- RODRIGO CHEIRICATTI DE CARVALHO  (rcheiricatti@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('85bf13eb-0833-40a2-9953-3deffc5fcda4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rcheiricatti@gmail.com', '', '2025-12-02T23:22:33.000Z', '2025-12-02T23:22:33.000Z', '2025-12-02T23:34:38.000Z', '{"provider":"email","providers":["email"]}', '{"name":"RODRIGO CHEIRICATTI DE CARVALHO "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6a2a66bf-3d32-447e-bbcc-d5e97c799fc6', '85bf13eb-0833-40a2-9953-3deffc5fcda4', '{"sub":"85bf13eb-0833-40a2-9953-3deffc5fcda4","email":"rcheiricatti@gmail.com","email_verified":true}', 'email', '85bf13eb-0833-40a2-9953-3deffc5fcda4', '2025-12-02T23:22:33.000Z', '2025-12-02T23:34:38.000Z', '2025-12-02T23:34:38.000Z');
UPDATE public.profiles SET name = 'RODRIGO CHEIRICATTI DE CARVALHO ', cpf = '03666282679', phone = '31984406999', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '85bf13eb-0833-40a2-9953-3deffc5fcda4';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '85bf13eb-0833-40a2-9953-3deffc5fcda4';

-- Breendon Costa (breendon.almeida@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6ea1e59b-45d3-4a12-b410-9a8b6b69cf1c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'breendon.almeida@gmail.com', '', '2025-12-02T23:23:12.000Z', '2025-12-02T23:23:12.000Z', '2025-12-03T02:36:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Breendon Costa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f94f5060-7c6e-42d9-b412-5e408a0d037b', '6ea1e59b-45d3-4a12-b410-9a8b6b69cf1c', '{"sub":"6ea1e59b-45d3-4a12-b410-9a8b6b69cf1c","email":"breendon.almeida@gmail.com","email_verified":true}', 'email', '6ea1e59b-45d3-4a12-b410-9a8b6b69cf1c', '2025-12-02T23:23:12.000Z', '2025-12-03T02:36:12.000Z', '2025-12-03T02:36:12.000Z');
UPDATE public.profiles SET name = 'Breendon Costa', cpf = '03247424016', phone = '31984471012', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '6ea1e59b-45d3-4a12-b410-9a8b6b69cf1c';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '6ea1e59b-45d3-4a12-b410-9a8b6b69cf1c';

-- FLAVIO OLIVEIRA IZAC (flavioizac@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bd782bae-4375-4f8c-81ec-dbc2fab48454', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'flavioizac@gmail.com', '', '2025-12-02T23:23:40.000Z', '2025-12-02T23:23:40.000Z', '2025-12-02T23:53:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"FLAVIO OLIVEIRA IZAC"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a41c282d-9082-42b3-b4c7-c9f699723f93', 'bd782bae-4375-4f8c-81ec-dbc2fab48454', '{"sub":"bd782bae-4375-4f8c-81ec-dbc2fab48454","email":"flavioizac@gmail.com","email_verified":true}', 'email', 'bd782bae-4375-4f8c-81ec-dbc2fab48454', '2025-12-02T23:23:40.000Z', '2025-12-02T23:53:32.000Z', '2025-12-02T23:53:33.000Z');
UPDATE public.profiles SET name = 'FLAVIO OLIVEIRA IZAC', cpf = '07816578652', phone = '31995355247', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'bd782bae-4375-4f8c-81ec-dbc2fab48454';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'bd782bae-4375-4f8c-81ec-dbc2fab48454';

-- Bruno Sbraletta (bruno.sbraletta@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4ba11c14-16e5-4f95-a03a-1b8f634faa56', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'bruno.sbraletta@gmail.com', '', '2025-12-02T23:25:04.000Z', '2025-12-02T23:25:04.000Z', '2025-12-03T15:06:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Bruno Sbraletta"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7ff18cb7-365d-49d1-9959-8e5dc296f632', '4ba11c14-16e5-4f95-a03a-1b8f634faa56', '{"sub":"4ba11c14-16e5-4f95-a03a-1b8f634faa56","email":"bruno.sbraletta@gmail.com","email_verified":true}', 'email', '4ba11c14-16e5-4f95-a03a-1b8f634faa56', '2025-12-02T23:25:04.000Z', '2025-12-03T15:06:49.000Z', '2025-12-03T15:06:49.000Z');
UPDATE public.profiles SET name = 'Bruno Sbraletta', cpf = '10967536693', phone = '31971260118', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '4ba11c14-16e5-4f95-a03a-1b8f634faa56';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '4ba11c14-16e5-4f95-a03a-1b8f634faa56';

-- Letícia  (hg.leticia@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('790211b4-6402-4a72-ba6a-9ba906e36a91', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'hg.leticia@gmail.com', '', '2025-12-02T23:29:10.000Z', '2025-12-02T23:29:10.000Z', '2025-12-02T23:52:42.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Letícia "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('644ad10c-afcb-4664-8537-06074036b64e', '790211b4-6402-4a72-ba6a-9ba906e36a91', '{"sub":"790211b4-6402-4a72-ba6a-9ba906e36a91","email":"hg.leticia@gmail.com","email_verified":true}', 'email', '790211b4-6402-4a72-ba6a-9ba906e36a91', '2025-12-02T23:29:10.000Z', '2025-12-02T23:52:42.000Z', '2025-12-02T23:52:42.000Z');
UPDATE public.profiles SET name = 'Letícia ', cpf = '11068032642', phone = '31997575605', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '790211b4-6402-4a72-ba6a-9ba906e36a91';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = '790211b4-6402-4a72-ba6a-9ba906e36a91';

-- Lucas  (lucaspitta@targetfroras.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a598f57e-1c0d-4d31-9624-964478b15f27', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lucaspitta@targetfroras.com.br', '', '2025-12-02T23:32:16.000Z', '2025-12-02T23:32:16.000Z', '2025-12-03T00:55:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lucas "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ef9f1817-9eb3-4a2f-84b6-ccd09d30e1af', 'a598f57e-1c0d-4d31-9624-964478b15f27', '{"sub":"a598f57e-1c0d-4d31-9624-964478b15f27","email":"lucaspitta@targetfroras.com.br","email_verified":true}', 'email', 'a598f57e-1c0d-4d31-9624-964478b15f27', '2025-12-02T23:32:16.000Z', '2025-12-03T00:55:01.000Z', '2025-12-03T00:55:01.000Z');
UPDATE public.profiles SET name = 'Lucas ', cpf = '03977395670', phone = '31993071013', company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'a598f57e-1c0d-4d31-9624-964478b15f27';
UPDATE public.user_roles SET company_id = 'a4d47ab7-096f-41d1-b358-194d6790311e' WHERE user_id = 'a598f57e-1c0d-4d31-9624-964478b15f27';

-- Ana Luísa Assis Arrunátegui (ana.arrunategui@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('27cba9be-4107-47a5-9844-989ff9b76c7f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ana.arrunategui@buffalodigital.com.br', '', '2025-12-03T20:46:57.000Z', '2025-12-03T20:46:57.000Z', '2025-12-03T20:46:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Luísa Assis Arrunátegui"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8cd08945-83f2-440f-96f0-e2f4f12754c5', '27cba9be-4107-47a5-9844-989ff9b76c7f', '{"sub":"27cba9be-4107-47a5-9844-989ff9b76c7f","email":"ana.arrunategui@buffalodigital.com.br","email_verified":true}', 'email', '27cba9be-4107-47a5-9844-989ff9b76c7f', '2025-12-03T20:46:57.000Z', '2025-12-03T20:46:57.000Z', '2025-12-03T20:46:57.000Z');
UPDATE public.profiles SET name = 'Ana Luísa Assis Arrunátegui', cpf = '111.066.766.37', phone = '31-99661-3864', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '8ae7e209-12c3-40c8-b0ca-f2140e86355b' WHERE user_id = '27cba9be-4107-47a5-9844-989ff9b76c7f';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '27cba9be-4107-47a5-9844-989ff9b76c7f';

-- Ana Paula Souza Teixeira (ana.souza@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('462b5eeb-71ab-48c1-8543-a4882085353c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ana.souza@buffalodigital.com.br', '', '2025-12-03T20:48:15.000Z', '2025-12-03T20:48:15.000Z', '2025-12-18T17:05:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Paula Souza Teixeira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1ff3c0a5-c3e6-4953-8cd7-bcc0896e8673', '462b5eeb-71ab-48c1-8543-a4882085353c', '{"sub":"462b5eeb-71ab-48c1-8543-a4882085353c","email":"ana.souza@buffalodigital.com.br","email_verified":true}', 'email', '462b5eeb-71ab-48c1-8543-a4882085353c', '2025-12-03T20:48:15.000Z', '2025-12-18T17:05:03.000Z', '2025-12-18T17:05:04.000Z');
UPDATE public.profiles SET name = 'Ana Paula Souza Teixeira', cpf = '114.192.336-02', phone = '31992963605', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = 'cfbccefd-30cc-4687-81d4-7ca1839ea923' WHERE user_id = '462b5eeb-71ab-48c1-8543-a4882085353c';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '462b5eeb-71ab-48c1-8543-a4882085353c';

-- Anderson Bazilio Monte Rei (andy.monterei@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('cb0e9777-8ac8-457f-b31c-e0ef98d3b444', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'andy.monterei@buffalodigital.com.br', '', '2025-12-03T20:49:03.000Z', '2025-12-03T20:49:03.000Z', '2025-12-04T21:25:52.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Anderson Bazilio Monte Rei"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1e8d16e3-5357-4926-97a3-fb273b3f727f', 'cb0e9777-8ac8-457f-b31c-e0ef98d3b444', '{"sub":"cb0e9777-8ac8-457f-b31c-e0ef98d3b444","email":"andy.monterei@buffalodigital.com.br","email_verified":true}', 'email', 'cb0e9777-8ac8-457f-b31c-e0ef98d3b444', '2025-12-03T20:49:03.000Z', '2025-12-04T21:25:52.000Z', '2025-12-04T21:25:51.000Z');
UPDATE public.profiles SET name = 'Anderson Bazilio Monte Rei', cpf = '405.772.418-14', phone = '16992416963', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '70a64145-7ef6-4f3b-8c38-18b30f18e0f5' WHERE user_id = 'cb0e9777-8ac8-457f-b31c-e0ef98d3b444';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = 'cb0e9777-8ac8-457f-b31c-e0ef98d3b444';

-- André Proença Doyle Oliva (andre.doyle@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('786759bc-3871-46ef-b327-69cc33680cc3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'andre.doyle@buffalodigital.com.br', '', '2025-12-03T20:49:53.000Z', '2025-12-03T20:49:53.000Z', '2025-12-16T07:18:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"André Proença Doyle Oliva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('20bc0c1b-54bb-4769-be0e-8dc8d60621fb', '786759bc-3871-46ef-b327-69cc33680cc3', '{"sub":"786759bc-3871-46ef-b327-69cc33680cc3","email":"andre.doyle@buffalodigital.com.br","email_verified":true}', 'email', '786759bc-3871-46ef-b327-69cc33680cc3', '2025-12-03T20:49:53.000Z', '2025-12-16T07:18:23.000Z', '2025-12-16T07:18:23.000Z');
UPDATE public.profiles SET name = 'André Proença Doyle Oliva', cpf = '054.318.066-29', phone = '31988283811', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '0a3227d0-3551-440a-868c-7ec29edd06f1' WHERE user_id = '786759bc-3871-46ef-b327-69cc33680cc3';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '786759bc-3871-46ef-b327-69cc33680cc3';

-- Filippe Nilo Souza Leite (filippe.leite@buffalodigital.com.br) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d115cc32-45f4-412d-a64c-191fddbd8cb7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'filippe.leite@buffalodigital.com.br', '', '2025-12-03T20:51:11.000Z', '2025-12-03T20:51:11.000Z', '2025-12-15T15:31:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Filippe Nilo Souza Leite"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1cadb08d-375e-43ee-8641-4939160c1ae6', 'd115cc32-45f4-412d-a64c-191fddbd8cb7', '{"sub":"d115cc32-45f4-412d-a64c-191fddbd8cb7","email":"filippe.leite@buffalodigital.com.br","email_verified":true}', 'email', 'd115cc32-45f4-412d-a64c-191fddbd8cb7', '2025-12-03T20:51:11.000Z', '2025-12-15T15:31:53.000Z', '2025-12-15T15:31:54.000Z');
UPDATE public.profiles SET name = 'Filippe Nilo Souza Leite', cpf = '080.605.626-65', phone = '31983092244', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '0a3227d0-3551-440a-868c-7ec29edd06f1' WHERE user_id = 'd115cc32-45f4-412d-a64c-191fddbd8cb7';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = 'd115cc32-45f4-412d-a64c-191fddbd8cb7';

-- Francis William Oliveira da Silva (francis.willian@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4787fe4d-fc1a-47f1-93fb-59f3c1ad6706', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'francis.willian@buffalodigital.com.br', '', '2025-12-03T20:52:33.000Z', '2025-12-03T20:52:33.000Z', '2025-12-11T15:37:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Francis William Oliveira da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('18ca8649-4db5-4de0-aa73-6746f238d8bf', '4787fe4d-fc1a-47f1-93fb-59f3c1ad6706', '{"sub":"4787fe4d-fc1a-47f1-93fb-59f3c1ad6706","email":"francis.willian@buffalodigital.com.br","email_verified":true}', 'email', '4787fe4d-fc1a-47f1-93fb-59f3c1ad6706', '2025-12-03T20:52:33.000Z', '2025-12-11T15:37:55.000Z', '2025-12-11T15:37:56.000Z');
UPDATE public.profiles SET name = 'Francis William Oliveira da Silva', cpf = '084.368.596-42', phone = '31995474697', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = 'feef56de-5b24-4ec7-a490-14e640e260bd' WHERE user_id = '4787fe4d-fc1a-47f1-93fb-59f3c1ad6706';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '4787fe4d-fc1a-47f1-93fb-59f3c1ad6706';

-- Jordana Ferreira Vieira de Souza (jordana.ferreira@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('309ef7e1-4e22-40f6-a7a5-c54ddccde030', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jordana.ferreira@buffalodigital.com.br', '', '2025-12-03T20:55:45.000Z', '2025-12-03T20:55:45.000Z', '2025-12-12T15:54:39.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Jordana Ferreira Vieira de Souza"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('92a48777-8218-4dcd-9ae2-9250512f72fe', '309ef7e1-4e22-40f6-a7a5-c54ddccde030', '{"sub":"309ef7e1-4e22-40f6-a7a5-c54ddccde030","email":"jordana.ferreira@buffalodigital.com.br","email_verified":true}', 'email', '309ef7e1-4e22-40f6-a7a5-c54ddccde030', '2025-12-03T20:55:45.000Z', '2025-12-12T15:54:39.000Z', '2025-12-12T15:54:37.000Z');
UPDATE public.profiles SET name = 'Jordana Ferreira Vieira de Souza', cpf = '149.168.097-00', phone = '32984244050', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = 'c51ae03f-a2d1-4b85-a3fe-e1c1232a15cc' WHERE user_id = '309ef7e1-4e22-40f6-a7a5-c54ddccde030';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '309ef7e1-4e22-40f6-a7a5-c54ddccde030';

-- Larissa Soares Rios (larissa.soares@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f25418e4-d0d0-4515-ab5e-a6b7b27c8fc1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'larissa.soares@buffalodigital.com.br', '', '2025-12-03T20:56:43.000Z', '2025-12-03T20:56:43.000Z', '2025-12-04T20:53:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Larissa Soares Rios"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6ea73f4f-bd07-4556-9509-6556072d9ae0', 'f25418e4-d0d0-4515-ab5e-a6b7b27c8fc1', '{"sub":"f25418e4-d0d0-4515-ab5e-a6b7b27c8fc1","email":"larissa.soares@buffalodigital.com.br","email_verified":true}', 'email', 'f25418e4-d0d0-4515-ab5e-a6b7b27c8fc1', '2025-12-03T20:56:43.000Z', '2025-12-04T20:53:48.000Z', '2025-12-04T20:53:49.000Z');
UPDATE public.profiles SET name = 'Larissa Soares Rios', cpf = '134.171.096-39', phone = '31993554953', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '8ae7e209-12c3-40c8-b0ca-f2140e86355b' WHERE user_id = 'f25418e4-d0d0-4515-ab5e-a6b7b27c8fc1';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = 'f25418e4-d0d0-4515-ab5e-a6b7b27c8fc1';

-- Lucas dos Santos Vilas Boas (lucas.vilasboas@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c17a7da2-cc93-4c63-a8f3-6c56fc516c5b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lucas.vilasboas@buffalodigital.com.br', '', '2025-12-03T20:57:36.000Z', '2025-12-03T20:57:36.000Z', '2025-12-12T22:15:45.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lucas dos Santos Vilas Boas"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('997e70ef-b7d4-4aec-8def-e4f1edf206e3', 'c17a7da2-cc93-4c63-a8f3-6c56fc516c5b', '{"sub":"c17a7da2-cc93-4c63-a8f3-6c56fc516c5b","email":"lucas.vilasboas@buffalodigital.com.br","email_verified":true}', 'email', 'c17a7da2-cc93-4c63-a8f3-6c56fc516c5b', '2025-12-03T20:57:36.000Z', '2025-12-12T22:15:45.000Z', '2025-12-12T22:15:46.000Z');
UPDATE public.profiles SET name = 'Lucas dos Santos Vilas Boas', cpf = '380.015.338-67', phone = '19992554041', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = 'feef56de-5b24-4ec7-a490-14e640e260bd' WHERE user_id = 'c17a7da2-cc93-4c63-a8f3-6c56fc516c5b';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = 'c17a7da2-cc93-4c63-a8f3-6c56fc516c5b';

-- Mayra Hitomi Abeki de Oliveira (mayra.abeki@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('97875b1a-2d1d-4bb7-9e75-76d9ba668344', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mayra.abeki@buffalodigital.com.br', '', '2025-12-03T20:58:28.000Z', '2025-12-03T20:58:28.000Z', '2026-01-25T06:55:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Mayra Hitomi Abeki de Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('65dcde3b-7a9b-4fd2-a3a7-43de8624c398', '97875b1a-2d1d-4bb7-9e75-76d9ba668344', '{"sub":"97875b1a-2d1d-4bb7-9e75-76d9ba668344","email":"mayra.abeki@buffalodigital.com.br","email_verified":true}', 'email', '97875b1a-2d1d-4bb7-9e75-76d9ba668344', '2025-12-03T20:58:28.000Z', '2026-01-25T06:55:49.000Z', '2026-01-25T06:55:50.000Z');
UPDATE public.profiles SET name = 'Mayra Hitomi Abeki de Oliveira', cpf = '082.573.946-29', phone = '31993196062', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '97875b1a-2d1d-4bb7-9e75-76d9ba668344';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '97875b1a-2d1d-4bb7-9e75-76d9ba668344';

-- Patricia de Oliveira e Silva (patricia.oliveira@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9c3e6975-83e5-4e96-8994-aafacc04d9a8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patricia.oliveira@buffalodigital.com.br', '', '2025-12-03T20:59:28.000Z', '2025-12-03T20:59:28.000Z', '2025-12-04T01:30:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Patricia de Oliveira e Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('287c902f-e114-46dd-8184-f9ea2109ede0', '9c3e6975-83e5-4e96-8994-aafacc04d9a8', '{"sub":"9c3e6975-83e5-4e96-8994-aafacc04d9a8","email":"patricia.oliveira@buffalodigital.com.br","email_verified":true}', 'email', '9c3e6975-83e5-4e96-8994-aafacc04d9a8', '2025-12-03T20:59:28.000Z', '2025-12-04T01:30:47.000Z', '2025-12-04T01:30:47.000Z');
UPDATE public.profiles SET name = 'Patricia de Oliveira e Silva', cpf = '780.321.996-91', phone = '31987483407', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '748546e8-830b-4e8c-bf01-ab7218fb5835' WHERE user_id = '9c3e6975-83e5-4e96-8994-aafacc04d9a8';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '9c3e6975-83e5-4e96-8994-aafacc04d9a8';

-- Rafael Guilherme de Sousa (rafael.guilherme@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('59850e2b-3c87-4435-b73c-7e6a0db185b5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rafael.guilherme@buffalodigital.com.br', '', '2025-12-03T21:01:31.000Z', '2025-12-03T21:01:31.000Z', '2025-12-16T16:31:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rafael Guilherme de Sousa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8c7703b1-55cf-42b2-87cd-82563697cce7', '59850e2b-3c87-4435-b73c-7e6a0db185b5', '{"sub":"59850e2b-3c87-4435-b73c-7e6a0db185b5","email":"rafael.guilherme@buffalodigital.com.br","email_verified":true}', 'email', '59850e2b-3c87-4435-b73c-7e6a0db185b5', '2025-12-03T21:01:31.000Z', '2025-12-16T16:31:16.000Z', '2025-12-16T16:31:16.000Z');
UPDATE public.profiles SET name = 'Rafael Guilherme de Sousa', cpf = '115.359.346-70', phone = '37991796090', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = 'c51ae03f-a2d1-4b85-a3fe-e1c1232a15cc' WHERE user_id = '59850e2b-3c87-4435-b73c-7e6a0db185b5';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '59850e2b-3c87-4435-b73c-7e6a0db185b5';

-- Samira Dias Ribeiro (samira.dias@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1edd6bd5-d00b-4b85-b564-cfc38cddbbf0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'samira.dias@buffalodigital.com.br', '', '2025-12-03T21:02:39.000Z', '2025-12-03T21:02:39.000Z', '2025-12-04T15:53:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Samira Dias Ribeiro"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cead4cb9-e215-48b1-a673-4b0c157404f5', '1edd6bd5-d00b-4b85-b564-cfc38cddbbf0', '{"sub":"1edd6bd5-d00b-4b85-b564-cfc38cddbbf0","email":"samira.dias@buffalodigital.com.br","email_verified":true}', 'email', '1edd6bd5-d00b-4b85-b564-cfc38cddbbf0', '2025-12-03T21:02:39.000Z', '2025-12-04T15:53:25.000Z', '2025-12-04T15:53:25.000Z');
UPDATE public.profiles SET name = 'Samira Dias Ribeiro', cpf = '112.864.466-51', phone = '31998197789', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '2e1234ce-cbd8-4fee-91df-09eba1810e3d' WHERE user_id = '1edd6bd5-d00b-4b85-b564-cfc38cddbbf0';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '1edd6bd5-d00b-4b85-b564-cfc38cddbbf0';

-- Thais Elisa Barbian de Souza (thais.barbian@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b080d8ca-3677-41d6-81f7-890fe9102a1f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'thais.barbian@buffalodigital.com.br', '', '2025-12-03T21:03:33.000Z', '2025-12-03T21:03:33.000Z', '2025-12-04T01:19:26.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Thais Elisa Barbian de Souza"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('58350dc6-3d8e-4792-b208-44064776a550', 'b080d8ca-3677-41d6-81f7-890fe9102a1f', '{"sub":"b080d8ca-3677-41d6-81f7-890fe9102a1f","email":"thais.barbian@buffalodigital.com.br","email_verified":true}', 'email', 'b080d8ca-3677-41d6-81f7-890fe9102a1f', '2025-12-03T21:03:33.000Z', '2025-12-04T01:19:26.000Z', '2025-12-04T01:19:26.000Z');
UPDATE public.profiles SET name = 'Thais Elisa Barbian de Souza', cpf = '089.133.046-19', phone = '31998068202', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = 'cfbccefd-30cc-4687-81d4-7ca1839ea923' WHERE user_id = 'b080d8ca-3677-41d6-81f7-890fe9102a1f';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = 'b080d8ca-3677-41d6-81f7-890fe9102a1f';

-- Claudio Moura Batitucci (claudio.batitucci@partners360.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('21cd6cfe-f48b-4cdc-a758-450af63642ea', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'claudio.batitucci@partners360.com.br', '', '2025-12-08T13:57:52.000Z', '2025-12-08T13:57:52.000Z', '2025-12-08T15:36:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Claudio Moura Batitucci"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6c30cea9-5cff-4bfa-8e8e-fe36830fdf4d', '21cd6cfe-f48b-4cdc-a758-450af63642ea', '{"sub":"21cd6cfe-f48b-4cdc-a758-450af63642ea","email":"claudio.batitucci@partners360.com.br","email_verified":true}', 'email', '21cd6cfe-f48b-4cdc-a758-450af63642ea', '2025-12-08T13:57:52.000Z', '2025-12-08T15:36:09.000Z', '2025-12-08T15:36:08.000Z');
UPDATE public.profiles SET name = 'Claudio Moura Batitucci', cpf = '81640226672', phone = '31997370505', company_id = 'cbe18e88-1702-43de-a6ab-0f664ab2947c' WHERE user_id = '21cd6cfe-f48b-4cdc-a758-450af63642ea';
UPDATE public.user_roles SET company_id = 'cbe18e88-1702-43de-a6ab-0f664ab2947c' WHERE user_id = '21cd6cfe-f48b-4cdc-a758-450af63642ea';

-- Ana luisa assis arrunategui (analuisaarrunategui@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('07b2b22e-146d-48e4-8bb5-033f8c527736', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'analuisaarrunategui@gmail.com', '', '2025-12-09T22:51:33.000Z', '2025-12-09T22:51:33.000Z', '2025-12-09T23:11:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana luisa assis arrunategui"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5a71a4f9-6ae2-48a7-a85b-4311bcd05e05', '07b2b22e-146d-48e4-8bb5-033f8c527736', '{"sub":"07b2b22e-146d-48e4-8bb5-033f8c527736","email":"analuisaarrunategui@gmail.com","email_verified":true}', 'email', '07b2b22e-146d-48e4-8bb5-033f8c527736', '2025-12-09T22:51:33.000Z', '2025-12-09T23:11:18.000Z', '2025-12-09T23:11:18.000Z');
UPDATE public.profiles SET name = 'Ana luisa assis arrunategui', cpf = '11106676637', phone = '31983353315', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '8ae7e209-12c3-40c8-b0ca-f2140e86355b' WHERE user_id = '07b2b22e-146d-48e4-8bb5-033f8c527736';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '07b2b22e-146d-48e4-8bb5-033f8c527736';

-- Clayton Lisboa (clayton.lisboa@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7ee1d4d2-cea8-4764-8011-aa7e4645c7c1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'clayton.lisboa@buffalodigital.com.br', '', '2025-12-10T15:28:57.000Z', '2025-12-10T15:28:57.000Z', '2025-12-10T15:46:38.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Clayton Lisboa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fe9c9b7e-1362-4f05-bf4f-3dffae8e3627', '7ee1d4d2-cea8-4764-8011-aa7e4645c7c1', '{"sub":"7ee1d4d2-cea8-4764-8011-aa7e4645c7c1","email":"clayton.lisboa@buffalodigital.com.br","email_verified":true}', 'email', '7ee1d4d2-cea8-4764-8011-aa7e4645c7c1', '2025-12-10T15:28:57.000Z', '2025-12-10T15:46:38.000Z', '2025-12-10T15:46:39.000Z');
UPDATE public.profiles SET name = 'Clayton Lisboa', cpf = '11212453662', phone = '31973549980', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '1de66b4e-5350-43b1-a7e9-09705f2b79f0' WHERE user_id = '7ee1d4d2-cea8-4764-8011-aa7e4645c7c1';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '7ee1d4d2-cea8-4764-8011-aa7e4645c7c1';

-- Bruno Henrique Rezende (bruno.henrique@repetreciclagem.com.br) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b485dec7-238e-4949-8511-cfed217f4dd6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'bruno.henrique@repetreciclagem.com.br', '', '2025-12-11T16:20:45.000Z', '2025-12-11T16:20:45.000Z', '2025-12-11T16:20:45.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Bruno Henrique Rezende"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('286158cc-2119-4ebb-a6ae-6e943325593d', 'b485dec7-238e-4949-8511-cfed217f4dd6', '{"sub":"b485dec7-238e-4949-8511-cfed217f4dd6","email":"bruno.henrique@repetreciclagem.com.br","email_verified":true}', 'email', 'b485dec7-238e-4949-8511-cfed217f4dd6', '2025-12-11T16:20:45.000Z', '2025-12-11T16:20:45.000Z', '2025-12-11T16:20:45.000Z');
UPDATE public.profiles SET name = 'Bruno Henrique Rezende', cpf = '03814542665', phone = '31995000184', company_id = '4a8923c2-dcee-4570-a106-3ef24d1832f7' WHERE user_id = 'b485dec7-238e-4949-8511-cfed217f4dd6';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = '4a8923c2-dcee-4570-a106-3ef24d1832f7' WHERE user_id = 'b485dec7-238e-4949-8511-cfed217f4dd6';

-- Nicholson Pimentel (np@healthsafetytech.com) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('40e04d84-ec46-4e6b-a3cc-e7093b52a107', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'np@healthsafetytech.com', '', '2025-12-15T23:06:22.000Z', '2025-12-15T23:06:22.000Z', '2026-01-23T22:47:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Nicholson Pimentel"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8f4408f8-37bc-44c7-bb74-5617ac7f8f51', '40e04d84-ec46-4e6b-a3cc-e7093b52a107', '{"sub":"40e04d84-ec46-4e6b-a3cc-e7093b52a107","email":"np@healthsafetytech.com","email_verified":true}', 'email', '40e04d84-ec46-4e6b-a3cc-e7093b52a107', '2025-12-15T23:06:22.000Z', '2026-01-23T22:47:20.000Z', '2026-01-23T22:47:20.000Z');
UPDATE public.profiles SET name = 'Nicholson Pimentel', cpf = '02153079411', phone = '81 8844-1145', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '40e04d84-ec46-4e6b-a3cc-e7093b52a107';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '40e04d84-ec46-4e6b-a3cc-e7093b52a107';

-- Alexsandra Rodrigues Matos (alexsandrarmatos@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('37732461-7afb-404f-841d-6c655cd269af', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alexsandrarmatos@gmail.com', '', '2025-12-18T00:28:15.000Z', '2025-12-18T00:28:15.000Z', '2026-01-06T04:21:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alexsandra Rodrigues Matos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dbdb3408-8337-4f7b-b252-a51de4644223', '37732461-7afb-404f-841d-6c655cd269af', '{"sub":"37732461-7afb-404f-841d-6c655cd269af","email":"alexsandrarmatos@gmail.com","email_verified":true}', 'email', '37732461-7afb-404f-841d-6c655cd269af', '2025-12-18T00:28:15.000Z', '2026-01-06T04:21:36.000Z', '2025-12-18T01:02:05.000Z');
UPDATE public.profiles SET name = 'Alexsandra Rodrigues Matos', cpf = '12657408605', phone = '31991111739', company_id = 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73' WHERE user_id = '37732461-7afb-404f-841d-6c655cd269af';
UPDATE public.user_roles SET company_id = 'b950f7ce-926b-47fe-8a2e-3f48ccaffa73' WHERE user_id = '37732461-7afb-404f-841d-6c655cd269af';

-- Alexa Carvalho (alexa@etcetal.com.br) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0c56388b-110a-4a00-a0a5-4a57e9d5821d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alexa@etcetal.com.br', '', '2026-01-05T17:01:18.000Z', '2026-01-05T17:01:18.000Z', '2026-02-03T15:05:46.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alexa Carvalho"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('56da61b7-af9d-402a-ac18-d302d2f6fc33', '0c56388b-110a-4a00-a0a5-4a57e9d5821d', '{"sub":"0c56388b-110a-4a00-a0a5-4a57e9d5821d","email":"alexa@etcetal.com.br","email_verified":true}', 'email', '0c56388b-110a-4a00-a0a5-4a57e9d5821d', '2026-01-05T17:01:18.000Z', '2026-02-03T15:05:46.000Z', '2026-02-03T15:05:47.000Z');
UPDATE public.profiles SET name = 'Alexa Carvalho', cpf = '758.184.506-00', phone = '(31) 99116-5380', company_id = '8fc25820-2603-4988-a69f-d5f2ad72d711' WHERE user_id = '0c56388b-110a-4a00-a0a5-4a57e9d5821d';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = '8fc25820-2603-4988-a69f-d5f2ad72d711' WHERE user_id = '0c56388b-110a-4a00-a0a5-4a57e9d5821d';

-- Lidisay Sena (adm01@healthsafetytech.com) | Role: leader
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('aa93e5ae-89d9-4946-9420-7bc4278d0d32', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'adm01@healthsafetytech.com', '', '2026-01-13T21:54:30.000Z', '2026-01-13T21:54:30.000Z', '2026-01-23T17:52:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lidisay Sena"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('957bb540-43b4-4586-8031-8a3b58a84d18', 'aa93e5ae-89d9-4946-9420-7bc4278d0d32', '{"sub":"aa93e5ae-89d9-4946-9420-7bc4278d0d32","email":"adm01@healthsafetytech.com","email_verified":true}', 'email', 'aa93e5ae-89d9-4946-9420-7bc4278d0d32', '2026-01-13T21:54:30.000Z', '2026-01-23T17:52:31.000Z', '2026-01-22T20:47:16.000Z');
UPDATE public.profiles SET name = 'Lidisay Sena', cpf = '08162660429', phone = '81998817938', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'bb0eb89b-0b76-4d1d-9b3b-f376c39e8dc2' WHERE user_id = 'aa93e5ae-89d9-4946-9420-7bc4278d0d32';
UPDATE public.user_roles SET role = 'leader'::public.app_role, company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'aa93e5ae-89d9-4946-9420-7bc4278d0d32';

-- Hylde Rosa (hylderosa@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f5917f28-6737-4da7-9128-ec67812b16db', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'hylderosa@gmail.com', '', '2026-01-14T00:10:29.000Z', '2026-01-14T00:10:29.000Z', '2026-01-14T00:17:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Hylde Rosa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c5ab3666-07f4-4148-8071-4087203063dd', 'f5917f28-6737-4da7-9128-ec67812b16db', '{"sub":"f5917f28-6737-4da7-9128-ec67812b16db","email":"hylderosa@gmail.com","email_verified":true}', 'email', 'f5917f28-6737-4da7-9128-ec67812b16db', '2026-01-14T00:10:29.000Z', '2026-01-14T00:17:35.000Z', '2026-01-14T00:17:35.000Z');
UPDATE public.profiles SET name = 'Hylde Rosa', cpf = '88799743787', phone = '11990238688', company_id = '8fc25820-2603-4988-a69f-d5f2ad72d711' WHERE user_id = 'f5917f28-6737-4da7-9128-ec67812b16db';
UPDATE public.user_roles SET company_id = '8fc25820-2603-4988-a69f-d5f2ad72d711' WHERE user_id = 'f5917f28-6737-4da7-9128-ec67812b16db';

-- Mayara Dias (mayaradias.tur@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('87545455-0484-428f-af89-3530545ec859', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mayaradias.tur@gmail.com', '', '2026-01-14T01:20:09.000Z', '2026-01-14T01:20:09.000Z', '2026-01-14T15:05:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Mayara Dias"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2fb56655-d9ab-4aa9-aaea-c2dff4dc65ef', '87545455-0484-428f-af89-3530545ec859', '{"sub":"87545455-0484-428f-af89-3530545ec859","email":"mayaradias.tur@gmail.com","email_verified":true}', 'email', '87545455-0484-428f-af89-3530545ec859', '2026-01-14T01:20:09.000Z', '2026-01-14T15:05:37.000Z', '2026-01-14T15:05:37.000Z');
UPDATE public.profiles SET name = 'Mayara Dias', cpf = '13680526652', phone = '31996952207', company_id = '8fc25820-2603-4988-a69f-d5f2ad72d711' WHERE user_id = '87545455-0484-428f-af89-3530545ec859';
UPDATE public.user_roles SET company_id = '8fc25820-2603-4988-a69f-d5f2ad72d711' WHERE user_id = '87545455-0484-428f-af89-3530545ec859';

-- Rodrigo Nascimento (digowars@gmail.com) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d8c56b7b-c5f5-4f6e-a1a9-428a6e73acf2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'digowars@gmail.com', '', '2026-01-14T18:05:37.000Z', '2026-01-14T18:05:37.000Z', '2026-01-24T05:37:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Nascimento"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('90642cea-91a8-4f67-859d-83524aae5536', 'd8c56b7b-c5f5-4f6e-a1a9-428a6e73acf2', '{"sub":"d8c56b7b-c5f5-4f6e-a1a9-428a6e73acf2","email":"digowars@gmail.com","email_verified":true}', 'email', 'd8c56b7b-c5f5-4f6e-a1a9-428a6e73acf2', '2026-01-14T18:05:37.000Z', '2026-01-24T05:37:56.000Z', '2026-01-24T05:37:56.000Z');
UPDATE public.profiles SET name = 'Rodrigo Nascimento', cpf = '06748391610', phone = '31991249442', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd8c56b7b-c5f5-4f6e-a1a9-428a6e73acf2';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd8c56b7b-c5f5-4f6e-a1a9-428a6e73acf2';

-- DANIEL GAIA DA SILVA (daniel.gaia@varejaodastintas.com.br) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ac16975b-cf01-4bed-8f73-58c76f47f57b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'daniel.gaia@varejaodastintas.com.br', '', '2026-01-16T17:09:02.000Z', '2026-01-16T17:09:02.000Z', '2026-01-20T19:31:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"DANIEL GAIA DA SILVA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7f13d03f-ea8f-4c82-9993-74b8e7ae84b7', 'ac16975b-cf01-4bed-8f73-58c76f47f57b', '{"sub":"ac16975b-cf01-4bed-8f73-58c76f47f57b","email":"daniel.gaia@varejaodastintas.com.br","email_verified":true}', 'email', 'ac16975b-cf01-4bed-8f73-58c76f47f57b', '2026-01-16T17:09:02.000Z', '2026-01-20T19:31:36.000Z', '2026-01-16T17:09:02.000Z');
UPDATE public.profiles SET name = 'DANIEL GAIA DA SILVA', cpf = '06266026619', phone = '31986492310', company_id = '5f45b92a-77d4-4e18-85aa-2961dc373425', department_id = '362bcbe4-c0c6-407b-b5dc-8f9d236efaa7' WHERE user_id = 'ac16975b-cf01-4bed-8f73-58c76f47f57b';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = '5f45b92a-77d4-4e18-85aa-2961dc373425' WHERE user_id = 'ac16975b-cf01-4bed-8f73-58c76f47f57b';

-- Alberto Angrisano Costa  (aangrisano@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('556e6fd1-32bc-450b-849f-6cfd6d8275b7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'aangrisano@gmail.com', '', '2026-01-16T20:39:54.000Z', '2026-01-16T20:39:54.000Z', '2026-01-19T15:39:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alberto Angrisano Costa "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8261f93d-1ca1-4e2a-8442-6952b6f0e31a', '556e6fd1-32bc-450b-849f-6cfd6d8275b7', '{"sub":"556e6fd1-32bc-450b-849f-6cfd6d8275b7","email":"aangrisano@gmail.com","email_verified":true}', 'email', '556e6fd1-32bc-450b-849f-6cfd6d8275b7', '2026-01-16T20:39:54.000Z', '2026-01-19T15:39:16.000Z', '2026-01-19T15:39:16.000Z');
UPDATE public.profiles SET name = 'Alberto Angrisano Costa ', cpf = '06106484708', phone = '21983987190', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '14b9a7fa-b094-4638-976b-57ced6420ae9' WHERE user_id = '556e6fd1-32bc-450b-849f-6cfd6d8275b7';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '556e6fd1-32bc-450b-849f-6cfd6d8275b7';

-- Test User With Password (test_with_password_1768589940269@example.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8dfc8de7-ad67-4434-a59c-d9455fb64289', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'test_with_password_1768589940269@example.com', '', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Test User With Password"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('82ab377e-d3d1-4864-a986-71df95ddcf05', '8dfc8de7-ad67-4434-a59c-d9455fb64289', '{"sub":"8dfc8de7-ad67-4434-a59c-d9455fb64289","email":"test_with_password_1768589940269@example.com","email_verified":true}', 'email', '8dfc8de7-ad67-4434-a59c-d9455fb64289', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:01.000Z');
UPDATE public.profiles SET name = 'Test User With Password', cpf = '12345678901', phone = '11999999999', company_id = '6c619694-29f3-4389-9a4b-7b077d473315' WHERE user_id = '8dfc8de7-ad67-4434-a59c-d9455fb64289';
UPDATE public.user_roles SET company_id = '6c619694-29f3-4389-9a4b-7b077d473315' WHERE user_id = '8dfc8de7-ad67-4434-a59c-d9455fb64289';

-- Test User Without Password (test_without_password_1768589940874@example.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('aec73dd5-35e6-4782-8152-368f60e791f4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'test_without_password_1768589940874@example.com', '', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Test User Without Password"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('556afe6b-5bae-4caa-81bc-3bfd4b578389', 'aec73dd5-35e6-4782-8152-368f60e791f4', '{"sub":"aec73dd5-35e6-4782-8152-368f60e791f4","email":"test_without_password_1768589940874@example.com","email_verified":true}', 'email', 'aec73dd5-35e6-4782-8152-368f60e791f4', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:01.000Z');
UPDATE public.profiles SET name = 'Test User Without Password', cpf = '12345678902', phone = '11988888888', company_id = '6c619694-29f3-4389-9a4b-7b077d473315' WHERE user_id = 'aec73dd5-35e6-4782-8152-368f60e791f4';
UPDATE public.user_roles SET company_id = '6c619694-29f3-4389-9a4b-7b077d473315' WHERE user_id = 'aec73dd5-35e6-4782-8152-368f60e791f4';

-- Normandia teste (rnrsouza@hotmail.com) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ccc296b6-8e68-4992-8e83-71bc0c652fdf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rnrsouza@hotmail.com', '', '2026-01-20T20:05:36.000Z', '2026-01-20T20:05:36.000Z', '2026-01-25T15:33:42.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Normandia teste"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0d4c8b76-cc9d-431a-ac19-b72fbc93b747', 'ccc296b6-8e68-4992-8e83-71bc0c652fdf', '{"sub":"ccc296b6-8e68-4992-8e83-71bc0c652fdf","email":"rnrsouza@hotmail.com","email_verified":true}', 'email', 'ccc296b6-8e68-4992-8e83-71bc0c652fdf', '2026-01-20T20:05:36.000Z', '2026-01-25T15:33:42.000Z', '2026-01-25T15:33:43.000Z');
UPDATE public.profiles SET name = 'Normandia teste', cpf = '06847654627', phone = '31984499268', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'ccc296b6-8e68-4992-8e83-71bc0c652fdf';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'ccc296b6-8e68-4992-8e83-71bc0c652fdf';

-- Kaw Bicalho (kawbicalho@gmail.com) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f17f7c9a-0cab-4867-b2a7-ee572ae8ba64', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'kawbicalho@gmail.com', '', '2026-01-20T20:16:57.000Z', '2026-01-20T20:16:57.000Z', '2026-01-20T20:17:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Kaw Bicalho"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fd079236-47f9-4105-83a4-275f98169f6a', 'f17f7c9a-0cab-4867-b2a7-ee572ae8ba64', '{"sub":"f17f7c9a-0cab-4867-b2a7-ee572ae8ba64","email":"kawbicalho@gmail.com","email_verified":true}', 'email', 'f17f7c9a-0cab-4867-b2a7-ee572ae8ba64', '2026-01-20T20:16:57.000Z', '2026-01-20T20:17:25.000Z', '2026-01-20T20:17:26.000Z');
UPDATE public.profiles SET name = 'Kaw Bicalho', cpf = '09244736659', phone = '31992171438', company_id = 'd013c83f-9094-45b9-8e6b-514e0e388370' WHERE user_id = 'f17f7c9a-0cab-4867-b2a7-ee572ae8ba64';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = 'd013c83f-9094-45b9-8e6b-514e0e388370' WHERE user_id = 'f17f7c9a-0cab-4867-b2a7-ee572ae8ba64';

-- GABRIELA DIAS (GABIDIASJ@GMAIL.COM) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('77cc8e3c-f5b2-4aa8-bc90-1e2ca12a7326', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'GABIDIASJ@GMAIL.COM', '', '2026-01-21T17:21:36.000Z', '2026-01-21T17:21:36.000Z', '2026-01-23T17:59:44.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GABRIELA DIAS"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('05d2d73d-8ea3-40fa-bb61-ddb9cfc46df1', '77cc8e3c-f5b2-4aa8-bc90-1e2ca12a7326', '{"sub":"77cc8e3c-f5b2-4aa8-bc90-1e2ca12a7326","email":"GABIDIASJ@GMAIL.COM","email_verified":true}', 'email', '77cc8e3c-f5b2-4aa8-bc90-1e2ca12a7326', '2026-01-21T17:21:36.000Z', '2026-01-23T17:59:44.000Z', '2026-01-23T17:59:45.000Z');
UPDATE public.profiles SET name = 'GABRIELA DIAS', cpf = '40293442835', phone = '11947461837', company_id = '85af0406-9809-4d6e-af30-b119ab7578c7' WHERE user_id = '77cc8e3c-f5b2-4aa8-bc90-1e2ca12a7326';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = '85af0406-9809-4d6e-af30-b119ab7578c7' WHERE user_id = '77cc8e3c-f5b2-4aa8-bc90-1e2ca12a7326';

-- Djalma Neto (financeiro01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('846153a4-d079-4640-ae56-89e4fd4fc393', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'financeiro01@healthsafetytech.com', '', '2026-01-22T20:55:12.000Z', '2026-01-22T20:55:12.000Z', '2026-01-23T17:52:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Djalma Neto"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b0f9847c-f879-4882-94f0-0b5f207aeb40', '846153a4-d079-4640-ae56-89e4fd4fc393', '{"sub":"846153a4-d079-4640-ae56-89e4fd4fc393","email":"financeiro01@healthsafetytech.com","email_verified":true}', 'email', '846153a4-d079-4640-ae56-89e4fd4fc393', '2026-01-22T20:55:12.000Z', '2026-01-23T17:52:25.000Z', '2026-01-22T20:55:12.000Z');
UPDATE public.profiles SET name = 'Djalma Neto', cpf = '12249648450', phone = '81997107258', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '7d498608-9b57-44a5-a080-d4e81047b201' WHERE user_id = '846153a4-d079-4640-ae56-89e4fd4fc393';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '846153a4-d079-4640-ae56-89e4fd4fc393';

-- Gislayne Nunes (comercial01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1e648467-4350-46fc-8820-c223abe7455f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'comercial01@healthsafetytech.com', '', '2026-01-22T21:01:00.000Z', '2026-01-22T21:01:00.000Z', '2026-01-23T17:52:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gislayne Nunes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0ab9124c-5775-4ece-a8be-d8a56ef95fbb', '1e648467-4350-46fc-8820-c223abe7455f', '{"sub":"1e648467-4350-46fc-8820-c223abe7455f","email":"comercial01@healthsafetytech.com","email_verified":true}', 'email', '1e648467-4350-46fc-8820-c223abe7455f', '2026-01-22T21:01:00.000Z', '2026-01-23T17:52:18.000Z', '2026-01-22T21:01:00.000Z');
UPDATE public.profiles SET name = 'Gislayne Nunes', cpf = '087597534-80', phone = '819 8343 0721', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'ae8e2bd1-b0ef-498f-a64b-6805bef6359e' WHERE user_id = '1e648467-4350-46fc-8820-c223abe7455f';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '1e648467-4350-46fc-8820-c223abe7455f';

-- Hyago Guimaraes (qualidade01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f247c4d7-cdbf-4068-a211-e249828ed816', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'qualidade01@healthsafetytech.com', '', '2026-01-22T21:02:00.000Z', '2026-01-22T21:02:00.000Z', '2026-01-23T17:52:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Hyago Guimaraes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5d8aae06-62f6-4162-88d0-357f3c8a3e2f', 'f247c4d7-cdbf-4068-a211-e249828ed816', '{"sub":"f247c4d7-cdbf-4068-a211-e249828ed816","email":"qualidade01@healthsafetytech.com","email_verified":true}', 'email', 'f247c4d7-cdbf-4068-a211-e249828ed816', '2026-01-22T21:02:00.000Z', '2026-01-23T17:52:13.000Z', '2026-01-22T21:02:00.000Z');
UPDATE public.profiles SET name = 'Hyago Guimaraes', cpf = '083972964-25', phone = '819 9762 7512', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'd1d09e8a-a4f5-494e-a4ee-9b9734fc96cb' WHERE user_id = 'f247c4d7-cdbf-4068-a211-e249828ed816';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'f247c4d7-cdbf-4068-a211-e249828ed816';

-- Ellen Elis (servicos01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d0f7f4f6-d0c8-4952-ae02-82de0053104b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'servicos01@healthsafetytech.com', '', '2026-01-22T21:04:05.000Z', '2026-01-22T21:04:05.000Z', '2026-01-23T17:52:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ellen Elis"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c7e5a616-f454-4fd5-9e65-378ab0e046b4', 'd0f7f4f6-d0c8-4952-ae02-82de0053104b', '{"sub":"d0f7f4f6-d0c8-4952-ae02-82de0053104b","email":"servicos01@healthsafetytech.com","email_verified":true}', 'email', 'd0f7f4f6-d0c8-4952-ae02-82de0053104b', '2026-01-22T21:04:05.000Z', '2026-01-23T17:52:06.000Z', '2026-01-22T21:04:05.000Z');
UPDATE public.profiles SET name = 'Ellen Elis', cpf = '707884864-03', phone = '819 9667 8651', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '5d08258b-57ec-4010-a809-e9e6c1fb226c' WHERE user_id = 'd0f7f4f6-d0c8-4952-ae02-82de0053104b';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'd0f7f4f6-d0c8-4952-ae02-82de0053104b';

-- Walbert Santos (laboratorio01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9c940ae6-1178-4cc0-8401-4ac1969f6fb4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'laboratorio01@healthsafetytech.com', '', '2026-01-22T21:46:59.000Z', '2026-01-22T21:46:59.000Z', '2026-01-23T17:52:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Walbert Santos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2c527038-fbd4-433e-8088-51e4ce154294', '9c940ae6-1178-4cc0-8401-4ac1969f6fb4', '{"sub":"9c940ae6-1178-4cc0-8401-4ac1969f6fb4","email":"laboratorio01@healthsafetytech.com","email_verified":true}', 'email', '9c940ae6-1178-4cc0-8401-4ac1969f6fb4', '2026-01-22T21:46:59.000Z', '2026-01-23T17:52:02.000Z', '2026-01-22T21:46:59.000Z');
UPDATE public.profiles SET name = 'Walbert Santos', cpf = '029491124-39', phone = '819 9184 5653', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '495fcb85-585a-46a0-bc46-9c65e8e51915' WHERE user_id = '9c940ae6-1178-4cc0-8401-4ac1969f6fb4';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '9c940ae6-1178-4cc0-8401-4ac1969f6fb4';

-- Leandro Victor (expedicao01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0d827572-3b90-4f28-96c7-b80243ecca68', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'expedicao01@healthsafetytech.com', '', '2026-01-22T21:52:56.000Z', '2026-01-22T21:52:56.000Z', '2026-01-23T17:51:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Leandro Victor"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('88536156-42b1-4eb0-9333-803aed48a1e2', '0d827572-3b90-4f28-96c7-b80243ecca68', '{"sub":"0d827572-3b90-4f28-96c7-b80243ecca68","email":"expedicao01@healthsafetytech.com","email_verified":true}', 'email', '0d827572-3b90-4f28-96c7-b80243ecca68', '2026-01-22T21:52:56.000Z', '2026-01-23T17:51:54.000Z', '2026-01-22T21:52:56.000Z');
UPDATE public.profiles SET name = 'Leandro Victor', cpf = '033910544-50', phone = '819 8872 0636', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'aaece373-5f02-4eea-9c73-46bebe4a4a81' WHERE user_id = '0d827572-3b90-4f28-96c7-b80243ecca68';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '0d827572-3b90-4f28-96c7-b80243ecca68';

-- Erick Dantas (ti@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8a3b9b6c-6342-4e63-8d08-ca9a0f32f91b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ti@healthsafetytech.com', '', '2026-01-22T22:18:48.000Z', '2026-01-22T22:18:48.000Z', '2026-01-23T21:01:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Erick Dantas"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e51c5280-0468-4a46-8dd4-84cebab76729', '8a3b9b6c-6342-4e63-8d08-ca9a0f32f91b', '{"sub":"8a3b9b6c-6342-4e63-8d08-ca9a0f32f91b","email":"ti@healthsafetytech.com","email_verified":true}', 'email', '8a3b9b6c-6342-4e63-8d08-ca9a0f32f91b', '2026-01-22T22:18:48.000Z', '2026-01-23T21:01:32.000Z', '2026-01-23T21:01:32.000Z');
UPDATE public.profiles SET name = 'Erick Dantas', cpf = '715017244-01', phone = '819 8864 0445', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'bb3ad87b-0cf4-4da0-a063-6b943b9cc49c' WHERE user_id = '8a3b9b6c-6342-4e63-8d08-ca9a0f32f91b';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '8a3b9b6c-6342-4e63-8d08-ca9a0f32f91b';

-- Rafael Pontes (expedicao02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('013c051c-c900-42b8-863f-11fd1eac6ffc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'expedicao02@healthsafetytech.com', '', '2026-01-22T22:19:35.000Z', '2026-01-22T22:19:35.000Z', '2026-01-23T17:51:41.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rafael Pontes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1e7eb835-e53b-4749-8c8a-691e305e8b36', '013c051c-c900-42b8-863f-11fd1eac6ffc', '{"sub":"013c051c-c900-42b8-863f-11fd1eac6ffc","email":"expedicao02@healthsafetytech.com","email_verified":true}', 'email', '013c051c-c900-42b8-863f-11fd1eac6ffc', '2026-01-22T22:19:35.000Z', '2026-01-23T17:51:41.000Z', '2026-01-22T22:19:35.000Z');
UPDATE public.profiles SET name = 'Rafael Pontes', cpf = '032831414-52', phone = '819 9827 6203', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'aaece373-5f02-4eea-9c73-46bebe4a4a81' WHERE user_id = '013c051c-c900-42b8-863f-11fd1eac6ffc';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '013c051c-c900-42b8-863f-11fd1eac6ffc';

-- Adriana Oliveira (comercial02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e1cb91cb-7205-44b5-a3aa-6a81337b4082', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'comercial02@healthsafetytech.com', '', '2026-01-22T22:20:10.000Z', '2026-01-22T22:20:10.000Z', '2026-01-23T17:51:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Adriana Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('341a1feb-9b11-4adf-9952-5d4f8ee15a91', 'e1cb91cb-7205-44b5-a3aa-6a81337b4082', '{"sub":"e1cb91cb-7205-44b5-a3aa-6a81337b4082","email":"comercial02@healthsafetytech.com","email_verified":true}', 'email', 'e1cb91cb-7205-44b5-a3aa-6a81337b4082', '2026-01-22T22:20:10.000Z', '2026-01-23T17:51:33.000Z', '2026-01-22T22:20:10.000Z');
UPDATE public.profiles SET name = 'Adriana Oliveira', cpf = '105096534-56', phone = '819 8960-7280', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'ae8e2bd1-b0ef-498f-a64b-6805bef6359e' WHERE user_id = 'e1cb91cb-7205-44b5-a3aa-6a81337b4082';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'e1cb91cb-7205-44b5-a3aa-6a81337b4082';

-- Welton Kellyson (ti02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9011cacc-adc2-437b-bb88-c2ccdfa5de50', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ti02@healthsafetytech.com', '', '2026-01-22T22:22:11.000Z', '2026-01-22T22:22:11.000Z', '2026-01-23T17:51:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Welton Kellyson"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('32cbbd4c-1c6d-4375-893d-a4924603851f', '9011cacc-adc2-437b-bb88-c2ccdfa5de50', '{"sub":"9011cacc-adc2-437b-bb88-c2ccdfa5de50","email":"ti02@healthsafetytech.com","email_verified":true}', 'email', '9011cacc-adc2-437b-bb88-c2ccdfa5de50', '2026-01-22T22:22:11.000Z', '2026-01-23T17:51:27.000Z', '2026-01-22T22:22:11.000Z');
UPDATE public.profiles SET name = 'Welton Kellyson', cpf = '140763664-25', phone = '819 9901-8603', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'bb3ad87b-0cf4-4da0-a063-6b943b9cc49c' WHERE user_id = '9011cacc-adc2-437b-bb88-c2ccdfa5de50';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '9011cacc-adc2-437b-bb88-c2ccdfa5de50';

-- Sandra Cristina (comercial03@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('56e03551-d17f-496d-bfaa-d60b1b19456a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'comercial03@healthsafetytech.com', '', '2026-01-22T22:22:38.000Z', '2026-01-22T22:22:38.000Z', '2026-01-23T17:51:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Sandra Cristina"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('af976b58-4e22-420d-bc89-d996d3706966', '56e03551-d17f-496d-bfaa-d60b1b19456a', '{"sub":"56e03551-d17f-496d-bfaa-d60b1b19456a","email":"comercial03@healthsafetytech.com","email_verified":true}', 'email', '56e03551-d17f-496d-bfaa-d60b1b19456a', '2026-01-22T22:22:38.000Z', '2026-01-23T17:51:19.000Z', '2026-01-22T22:22:38.000Z');
UPDATE public.profiles SET name = 'Sandra Cristina', cpf = '027935014-76', phone = '819 9802-3555', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'ae8e2bd1-b0ef-498f-a64b-6805bef6359e' WHERE user_id = '56e03551-d17f-496d-bfaa-d60b1b19456a';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '56e03551-d17f-496d-bfaa-d60b1b19456a';

-- Eduardo Luna (comercial04@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0dd7aad3-c488-4f56-b6a0-7f908a3b3afb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'comercial04@healthsafetytech.com', '', '2026-01-22T22:23:11.000Z', '2026-01-22T22:23:11.000Z', '2026-01-23T17:51:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Eduardo Luna"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('21b3c358-9553-44d1-8945-61d28f5b2569', '0dd7aad3-c488-4f56-b6a0-7f908a3b3afb', '{"sub":"0dd7aad3-c488-4f56-b6a0-7f908a3b3afb","email":"comercial04@healthsafetytech.com","email_verified":true}', 'email', '0dd7aad3-c488-4f56-b6a0-7f908a3b3afb', '2026-01-22T22:23:11.000Z', '2026-01-23T17:51:08.000Z', '2026-01-22T22:23:11.000Z');
UPDATE public.profiles SET name = 'Eduardo Luna', cpf = '014353694-08', phone = '819 9919-7982', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'ae8e2bd1-b0ef-498f-a64b-6805bef6359e' WHERE user_id = '0dd7aad3-c488-4f56-b6a0-7f908a3b3afb';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '0dd7aad3-c488-4f56-b6a0-7f908a3b3afb';

-- Gustavo Oliveira (qualidade02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('71c50fc0-9ddd-4224-9229-4ef87bccf438', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'qualidade02@healthsafetytech.com', '', '2026-01-22T22:24:25.000Z', '2026-01-22T22:24:25.000Z', '2026-01-23T17:50:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gustavo Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b44e836c-67e7-4bce-b782-8f1beeaa101a', '71c50fc0-9ddd-4224-9229-4ef87bccf438', '{"sub":"71c50fc0-9ddd-4224-9229-4ef87bccf438","email":"qualidade02@healthsafetytech.com","email_verified":true}', 'email', '71c50fc0-9ddd-4224-9229-4ef87bccf438', '2026-01-22T22:24:25.000Z', '2026-01-23T17:50:59.000Z', '2026-01-22T22:24:25.000Z');
UPDATE public.profiles SET name = 'Gustavo Oliveira', cpf = '137994054-02', phone = '81 98337-9094', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'd1d09e8a-a4f5-494e-a4ee-9b9734fc96cb' WHERE user_id = '71c50fc0-9ddd-4224-9229-4ef87bccf438';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '71c50fc0-9ddd-4224-9229-4ef87bccf438';

-- Letícia Nunes (servicos02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9c75a655-ca59-447e-bceb-898a027ca3b1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'servicos02@healthsafetytech.com', '', '2026-01-22T22:24:49.000Z', '2026-01-22T22:24:49.000Z', '2026-01-23T21:48:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Letícia Nunes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('045251e3-0dfa-4f40-8299-972927f3374d', '9c75a655-ca59-447e-bceb-898a027ca3b1', '{"sub":"9c75a655-ca59-447e-bceb-898a027ca3b1","email":"servicos02@healthsafetytech.com","email_verified":true}', 'email', '9c75a655-ca59-447e-bceb-898a027ca3b1', '2026-01-22T22:24:49.000Z', '2026-01-23T21:48:20.000Z', '2026-01-23T21:48:20.000Z');
UPDATE public.profiles SET name = 'Letícia Nunes', cpf = '092986114-04', phone = '81 97314-0645', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '5d08258b-57ec-4010-a809-e9e6c1fb226c' WHERE user_id = '9c75a655-ca59-447e-bceb-898a027ca3b1';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '9c75a655-ca59-447e-bceb-898a027ca3b1';

-- Paulo Henrique (laboratorio02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('975ff991-5f9b-4f20-9aa3-e14eda3984e4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'laboratorio02@healthsafetytech.com', '', '2026-01-22T22:25:10.000Z', '2026-01-22T22:25:10.000Z', '2026-01-23T17:50:45.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Paulo Henrique"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('95497572-43d0-4de8-be9b-8ac2557a0257', '975ff991-5f9b-4f20-9aa3-e14eda3984e4', '{"sub":"975ff991-5f9b-4f20-9aa3-e14eda3984e4","email":"laboratorio02@healthsafetytech.com","email_verified":true}', 'email', '975ff991-5f9b-4f20-9aa3-e14eda3984e4', '2026-01-22T22:25:10.000Z', '2026-01-23T17:50:45.000Z', '2026-01-22T22:25:10.000Z');
UPDATE public.profiles SET name = 'Paulo Henrique', cpf = '110681254-97', phone = '81 99526-6217', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '495fcb85-585a-46a0-bc46-9c65e8e51915' WHERE user_id = '975ff991-5f9b-4f20-9aa3-e14eda3984e4';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '975ff991-5f9b-4f20-9aa3-e14eda3984e4';

-- Lucas Azevedo (expedicao03@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f9d53d39-62d7-4191-a9f0-ae77f5633239', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'expedicao03@healthsafetytech.com', '', '2026-01-22T22:25:38.000Z', '2026-01-22T22:25:38.000Z', '2026-01-23T17:50:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lucas Azevedo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4d58d440-b515-4ec7-a091-40979587a4fe', 'f9d53d39-62d7-4191-a9f0-ae77f5633239', '{"sub":"f9d53d39-62d7-4191-a9f0-ae77f5633239","email":"expedicao03@healthsafetytech.com","email_verified":true}', 'email', 'f9d53d39-62d7-4191-a9f0-ae77f5633239', '2026-01-22T22:25:38.000Z', '2026-01-23T17:50:37.000Z', '2026-01-22T22:25:38.000Z');
UPDATE public.profiles SET name = 'Lucas Azevedo', cpf = '108327804-56', phone = '81 98873-6755', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'aaece373-5f02-4eea-9c73-46bebe4a4a81' WHERE user_id = 'f9d53d39-62d7-4191-a9f0-ae77f5633239';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'f9d53d39-62d7-4191-a9f0-ae77f5633239';

-- Gabriel Moura (suporte01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f60872e8-50eb-483c-b67a-b27f1f7a0c3b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'suporte01@healthsafetytech.com', '', '2026-01-22T22:26:07.000Z', '2026-01-22T22:26:07.000Z', '2026-01-23T17:50:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gabriel Moura"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4ab3fbb1-f9c3-4b20-97d5-ffe5aaa6ef75', 'f60872e8-50eb-483c-b67a-b27f1f7a0c3b', '{"sub":"f60872e8-50eb-483c-b67a-b27f1f7a0c3b","email":"suporte01@healthsafetytech.com","email_verified":true}', 'email', 'f60872e8-50eb-483c-b67a-b27f1f7a0c3b', '2026-01-22T22:26:07.000Z', '2026-01-23T17:50:31.000Z', '2026-01-22T22:26:07.000Z');
UPDATE public.profiles SET name = 'Gabriel Moura', cpf = '131086264-85', phone = '81 99677-7334', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '7f2222de-abe1-4f1b-8f94-794ec29d1e89' WHERE user_id = 'f60872e8-50eb-483c-b67a-b27f1f7a0c3b';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'f60872e8-50eb-483c-b67a-b27f1f7a0c3b';

-- Lara Cocri (comercial05@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f2f9d7f7-9cb1-4b19-88c3-974729fe8da5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'comercial05@healthsafetytech.com', '', '2026-01-22T22:26:26.000Z', '2026-01-22T22:26:26.000Z', '2026-01-23T17:50:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lara Cocri"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dce9db2f-6a1e-434d-a9f1-4b80b9688df8', 'f2f9d7f7-9cb1-4b19-88c3-974729fe8da5', '{"sub":"f2f9d7f7-9cb1-4b19-88c3-974729fe8da5","email":"comercial05@healthsafetytech.com","email_verified":true}', 'email', 'f2f9d7f7-9cb1-4b19-88c3-974729fe8da5', '2026-01-22T22:26:26.000Z', '2026-01-23T17:50:25.000Z', '2026-01-22T22:26:26.000Z');
UPDATE public.profiles SET name = 'Lara Cocri', cpf = '711439414-46', phone = '81 99829-9288', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'ae8e2bd1-b0ef-498f-a64b-6805bef6359e' WHERE user_id = 'f2f9d7f7-9cb1-4b19-88c3-974729fe8da5';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'f2f9d7f7-9cb1-4b19-88c3-974729fe8da5';

-- Suelen Patrícia (suporte02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bbf761c7-fe2c-4435-b56b-7f8feb818875', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'suporte02@healthsafetytech.com', '', '2026-01-22T22:30:45.000Z', '2026-01-22T22:30:45.000Z', '2026-01-23T17:50:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Suelen Patrícia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a1662abd-d6ff-4af0-a8c2-5b7790401c17', 'bbf761c7-fe2c-4435-b56b-7f8feb818875', '{"sub":"bbf761c7-fe2c-4435-b56b-7f8feb818875","email":"suporte02@healthsafetytech.com","email_verified":true}', 'email', 'bbf761c7-fe2c-4435-b56b-7f8feb818875', '2026-01-22T22:30:45.000Z', '2026-01-23T17:50:18.000Z', '2026-01-22T22:30:45.000Z');
UPDATE public.profiles SET name = 'Suelen Patrícia', cpf = '073031404-92', phone = '81 98691-3498', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '7f2222de-abe1-4f1b-8f94-794ec29d1e89' WHERE user_id = 'bbf761c7-fe2c-4435-b56b-7f8feb818875';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'bbf761c7-fe2c-4435-b56b-7f8feb818875';

-- Rickelme David (ti03@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e025e7f7-8e40-4dbb-b237-c63f2810e5c6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ti03@healthsafetytech.com', '', '2026-01-22T22:31:18.000Z', '2026-01-22T22:31:18.000Z', '2026-01-23T17:50:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rickelme David"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a6ebf556-339a-4f5d-b9cd-bb843ef79164', 'e025e7f7-8e40-4dbb-b237-c63f2810e5c6', '{"sub":"e025e7f7-8e40-4dbb-b237-c63f2810e5c6","email":"ti03@healthsafetytech.com","email_verified":true}', 'email', 'e025e7f7-8e40-4dbb-b237-c63f2810e5c6', '2026-01-22T22:31:18.000Z', '2026-01-23T17:50:10.000Z', '2026-01-22T22:31:18.000Z');
UPDATE public.profiles SET name = 'Rickelme David', cpf = '131460544-50', phone = '81 99801-7466', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'bb3ad87b-0cf4-4da0-a063-6b943b9cc49c' WHERE user_id = 'e025e7f7-8e40-4dbb-b237-c63f2810e5c6';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'e025e7f7-8e40-4dbb-b237-c63f2810e5c6';

-- Surama Carvalho Pereira (surama@etcetal.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4e128193-9aeb-4f3b-bd2f-c6bb3dd1170d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'surama@etcetal.com.br', '', '2026-01-22T23:13:06.000Z', '2026-01-22T23:13:06.000Z', '2026-01-23T23:11:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Surama Carvalho Pereira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('580a72a7-20a7-4f5f-9fd9-c4ef4c25c850', '4e128193-9aeb-4f3b-bd2f-c6bb3dd1170d', '{"sub":"4e128193-9aeb-4f3b-bd2f-c6bb3dd1170d","email":"surama@etcetal.com.br","email_verified":true}', 'email', '4e128193-9aeb-4f3b-bd2f-c6bb3dd1170d', '2026-01-22T23:13:06.000Z', '2026-01-23T23:11:06.000Z', '2026-01-23T23:11:07.000Z');
UPDATE public.profiles SET name = 'Surama Carvalho Pereira', cpf = '75818477649', phone = '31991337120', company_id = '8fc25820-2603-4988-a69f-d5f2ad72d711' WHERE user_id = '4e128193-9aeb-4f3b-bd2f-c6bb3dd1170d';
UPDATE public.user_roles SET company_id = '8fc25820-2603-4988-a69f-d5f2ad72d711' WHERE user_id = '4e128193-9aeb-4f3b-bd2f-c6bb3dd1170d';

-- walbert santos (walbertsantos@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('cb1c199f-ba1d-438d-afb3-8e5ae031cc2b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'walbertsantos@gmail.com', '', '2026-01-23T19:48:17.000Z', '2026-01-23T19:48:17.000Z', '2026-01-23T20:07:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"walbert santos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9dd7e804-7370-4888-bb8b-e366d33ae06e', 'cb1c199f-ba1d-438d-afb3-8e5ae031cc2b', '{"sub":"cb1c199f-ba1d-438d-afb3-8e5ae031cc2b","email":"walbertsantos@gmail.com","email_verified":true}', 'email', 'cb1c199f-ba1d-438d-afb3-8e5ae031cc2b', '2026-01-23T19:48:17.000Z', '2026-01-23T20:07:16.000Z', '2026-01-23T20:07:17.000Z');
UPDATE public.profiles SET name = 'walbert santos', cpf = '02949112439', phone = '8199184565', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '495fcb85-585a-46a0-bc46-9c65e8e51915' WHERE user_id = 'cb1c199f-ba1d-438d-afb3-8e5ae031cc2b';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'cb1c199f-ba1d-438d-afb3-8e5ae031cc2b';

-- Lara Leite Duarte Cocri (sdr3@healthsafety.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a7ead495-1c9d-47c9-ac28-d2fb643972c7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'sdr3@healthsafety.com.br', '', '2026-01-23T20:07:14.000Z', '2026-01-23T20:07:14.000Z', '2026-01-23T20:51:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lara Leite Duarte Cocri"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('eae1c755-20ca-42ad-b1a3-3f0ddde5e550', 'a7ead495-1c9d-47c9-ac28-d2fb643972c7', '{"sub":"a7ead495-1c9d-47c9-ac28-d2fb643972c7","email":"sdr3@healthsafety.com.br","email_verified":true}', 'email', 'a7ead495-1c9d-47c9-ac28-d2fb643972c7', '2026-01-23T20:07:14.000Z', '2026-01-23T20:51:08.000Z', '2026-01-23T20:51:08.000Z');
UPDATE public.profiles SET name = 'Lara Leite Duarte Cocri', cpf = '71143941446', phone = '81998299288', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'ae8e2bd1-b0ef-498f-a64b-6805bef6359e' WHERE user_id = 'a7ead495-1c9d-47c9-ac28-d2fb643972c7';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'a7ead495-1c9d-47c9-ac28-d2fb643972c7';

-- Adriana Oliveira da paz  (adriana_diana_oliveira@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fb02fbd4-d670-4539-bce3-2952804623b8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'adriana_diana_oliveira@hotmail.com', '', '2026-01-23T20:15:24.000Z', '2026-01-23T20:15:24.000Z', '2026-01-23T20:48:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Adriana Oliveira da paz "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('50a15cbf-0a45-4d22-915e-8981d5d3a0d3', 'fb02fbd4-d670-4539-bce3-2952804623b8', '{"sub":"fb02fbd4-d670-4539-bce3-2952804623b8","email":"adriana_diana_oliveira@hotmail.com","email_verified":true}', 'email', 'fb02fbd4-d670-4539-bce3-2952804623b8', '2026-01-23T20:15:24.000Z', '2026-01-23T20:48:51.000Z', '2026-01-23T20:48:51.000Z');
UPDATE public.profiles SET name = 'Adriana Oliveira da paz ', cpf = '10509653456', phone = '81989607280', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'ae8e2bd1-b0ef-498f-a64b-6805bef6359e' WHERE user_id = 'fb02fbd4-d670-4539-bce3-2952804623b8';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'fb02fbd4-d670-4539-bce3-2952804623b8';

-- GISLAYNE NUNES  (gynunes62@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('357032a0-4399-4bfb-a9b1-9cde290e14f6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gynunes62@gmail.com', '', '2026-01-23T20:20:54.000Z', '2026-01-23T20:20:54.000Z', '2026-01-23T21:36:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GISLAYNE NUNES "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('00fb6ca6-815c-40b9-a52b-fe6a4c62dda1', '357032a0-4399-4bfb-a9b1-9cde290e14f6', '{"sub":"357032a0-4399-4bfb-a9b1-9cde290e14f6","email":"gynunes62@gmail.com","email_verified":true}', 'email', '357032a0-4399-4bfb-a9b1-9cde290e14f6', '2026-01-23T20:20:54.000Z', '2026-01-23T21:36:27.000Z', '2026-01-23T21:36:27.000Z');
UPDATE public.profiles SET name = 'GISLAYNE NUNES ', cpf = '08759753480', phone = '81999359090', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'ae8e2bd1-b0ef-498f-a64b-6805bef6359e' WHERE user_id = '357032a0-4399-4bfb-a9b1-9cde290e14f6';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '357032a0-4399-4bfb-a9b1-9cde290e14f6';

-- Djalma Neto  (djalmanetobeto@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dd24126f-d378-4e02-a923-aca3e79c890f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'djalmanetobeto@gmail.com', '', '2026-01-23T20:28:44.000Z', '2026-01-23T20:28:44.000Z', '2026-01-23T20:41:40.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Djalma Neto "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('afa73bca-d44d-4d7b-995c-88dd5f54a704', 'dd24126f-d378-4e02-a923-aca3e79c890f', '{"sub":"dd24126f-d378-4e02-a923-aca3e79c890f","email":"djalmanetobeto@gmail.com","email_verified":true}', 'email', 'dd24126f-d378-4e02-a923-aca3e79c890f', '2026-01-23T20:28:44.000Z', '2026-01-23T20:41:40.000Z', '2026-01-23T20:41:41.000Z');
UPDATE public.profiles SET name = 'Djalma Neto ', cpf = '12249648450', phone = '81997107258', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '7d498608-9b57-44a5-a080-d4e81047b201' WHERE user_id = 'dd24126f-d378-4e02-a923-aca3e79c890f';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'dd24126f-d378-4e02-a923-aca3e79c890f';

-- Sandra Cristina Araujo Silva (sandraa.cristina@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('45628319-f9b1-4aba-ab31-76651ceff33f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'sandraa.cristina@hotmail.com', '', '2026-01-23T20:31:11.000Z', '2026-01-23T20:31:11.000Z', '2026-01-23T22:01:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Sandra Cristina Araujo Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b37ea728-a932-4162-8145-5fbca61cc9f0', '45628319-f9b1-4aba-ab31-76651ceff33f', '{"sub":"45628319-f9b1-4aba-ab31-76651ceff33f","email":"sandraa.cristina@hotmail.com","email_verified":true}', 'email', '45628319-f9b1-4aba-ab31-76651ceff33f', '2026-01-23T20:31:11.000Z', '2026-01-23T22:01:17.000Z', '2026-01-23T22:01:18.000Z');
UPDATE public.profiles SET name = 'Sandra Cristina Araujo Silva', cpf = '02793501476', phone = '81998023555', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'ae8e2bd1-b0ef-498f-a64b-6805bef6359e' WHERE user_id = '45628319-f9b1-4aba-ab31-76651ceff33f';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '45628319-f9b1-4aba-ab31-76651ceff33f';

-- Gustavo Oliveira dos Prazeres (gopme12@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('68b498f9-72c2-4389-94d2-26522fb71a97', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gopme12@gmail.com', '', '2026-01-23T20:35:10.000Z', '2026-01-23T20:35:10.000Z', '2026-01-23T21:25:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gustavo Oliveira dos Prazeres"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c4ee97e5-1cf7-4762-a816-aa4d2aa40ef0', '68b498f9-72c2-4389-94d2-26522fb71a97', '{"sub":"68b498f9-72c2-4389-94d2-26522fb71a97","email":"gopme12@gmail.com","email_verified":true}', 'email', '68b498f9-72c2-4389-94d2-26522fb71a97', '2026-01-23T20:35:10.000Z', '2026-01-23T21:25:23.000Z', '2026-01-23T21:25:23.000Z');
UPDATE public.profiles SET name = 'Gustavo Oliveira dos Prazeres', cpf = '13799405402', phone = '81983379094', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'd1d09e8a-a4f5-494e-a4ee-9b9734fc96cb' WHERE user_id = '68b498f9-72c2-4389-94d2-26522fb71a97';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '68b498f9-72c2-4389-94d2-26522fb71a97';

-- Welton kellyson da Silva Alves (weltonkellyson24@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e940269d-46f1-4b31-9810-d9b7e6076633', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'weltonkellyson24@gmail.com', '', '2026-01-23T20:41:18.000Z', '2026-01-23T20:41:18.000Z', '2026-01-23T20:59:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Welton kellyson da Silva Alves"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7e5f3f7b-720f-492a-a586-846933b97e19', 'e940269d-46f1-4b31-9810-d9b7e6076633', '{"sub":"e940269d-46f1-4b31-9810-d9b7e6076633","email":"weltonkellyson24@gmail.com","email_verified":true}', 'email', 'e940269d-46f1-4b31-9810-d9b7e6076633', '2026-01-23T20:41:18.000Z', '2026-01-23T20:59:59.000Z', '2026-01-23T21:00:00.000Z');
UPDATE public.profiles SET name = 'Welton kellyson da Silva Alves', cpf = '14076366425', phone = '81999018603', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'bb3ad87b-0cf4-4da0-a063-6b943b9cc49c' WHERE user_id = 'e940269d-46f1-4b31-9810-d9b7e6076633';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'e940269d-46f1-4b31-9810-d9b7e6076633';

-- Eduardo Luna (sdr1@healthsafety.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d3e17d0e-861c-4fb3-9a07-3c48e9d3533d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'sdr1@healthsafety.com.br', '', '2026-01-23T20:48:16.000Z', '2026-01-23T20:48:16.000Z', '2026-01-23T21:07:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Eduardo Luna"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a5b60abb-646d-4a58-9c29-461fb69beb93', 'd3e17d0e-861c-4fb3-9a07-3c48e9d3533d', '{"sub":"d3e17d0e-861c-4fb3-9a07-3c48e9d3533d","email":"sdr1@healthsafety.com.br","email_verified":true}', 'email', 'd3e17d0e-861c-4fb3-9a07-3c48e9d3533d', '2026-01-23T20:48:16.000Z', '2026-01-23T21:07:09.000Z', '2026-01-23T21:07:09.000Z');
UPDATE public.profiles SET name = 'Eduardo Luna', cpf = '01435369408', phone = '81999197982', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'ae8e2bd1-b0ef-498f-a64b-6805bef6359e' WHERE user_id = 'd3e17d0e-861c-4fb3-9a07-3c48e9d3533d';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'd3e17d0e-861c-4fb3-9a07-3c48e9d3533d';

-- GABRIEL MOURA WANDERLEY DA SILVA (gmswanderley@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a8aedc17-a0e2-42a0-8329-819e24027a45', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gmswanderley@gmail.com', '', '2026-01-23T21:00:14.000Z', '2026-01-23T21:00:14.000Z', '2026-01-23T22:11:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GABRIEL MOURA WANDERLEY DA SILVA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('97706884-0525-411f-bf60-c5430ca16652', 'a8aedc17-a0e2-42a0-8329-819e24027a45', '{"sub":"a8aedc17-a0e2-42a0-8329-819e24027a45","email":"gmswanderley@gmail.com","email_verified":true}', 'email', 'a8aedc17-a0e2-42a0-8329-819e24027a45', '2026-01-23T21:00:14.000Z', '2026-01-23T22:11:37.000Z', '2026-01-23T22:11:37.000Z');
UPDATE public.profiles SET name = 'GABRIEL MOURA WANDERLEY DA SILVA', cpf = '13108626485', phone = '81996774334', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '7f2222de-abe1-4f1b-8f94-794ec29d1e89' WHERE user_id = 'a8aedc17-a0e2-42a0-8329-819e24027a45';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'a8aedc17-a0e2-42a0-8329-819e24027a45';

-- Suelen Patricia Batista De Santana (suelenpatricia957@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d3880e42-34c8-4043-90fc-34aeba4740c6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'suelenpatricia957@gmail.com', '', '2026-01-23T21:01:31.000Z', '2026-01-23T21:01:31.000Z', '2026-01-24T01:36:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Suelen Patricia Batista De Santana"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('58293aa1-29e8-4e1c-ab92-f47df67e001e', 'd3880e42-34c8-4043-90fc-34aeba4740c6', '{"sub":"d3880e42-34c8-4043-90fc-34aeba4740c6","email":"suelenpatricia957@gmail.com","email_verified":true}', 'email', 'd3880e42-34c8-4043-90fc-34aeba4740c6', '2026-01-23T21:01:31.000Z', '2026-01-24T01:36:59.000Z', '2026-01-24T01:36:58.000Z');
UPDATE public.profiles SET name = 'Suelen Patricia Batista De Santana', cpf = '07303140492', phone = '81981562774', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '7f2222de-abe1-4f1b-8f94-794ec29d1e89' WHERE user_id = 'd3880e42-34c8-4043-90fc-34aeba4740c6';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'd3880e42-34c8-4043-90fc-34aeba4740c6';

-- Rickelme David Silva Cavalcante (rickelmepe@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6ae5f0b2-bf2d-4493-b37a-1c2a83901686', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rickelmepe@gmail.com', '', '2026-01-23T21:03:45.000Z', '2026-01-23T21:03:45.000Z', '2026-01-26T20:20:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rickelme David Silva Cavalcante"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3f933aaf-dbeb-45bc-a6ae-7ad518efc1a1', '6ae5f0b2-bf2d-4493-b37a-1c2a83901686', '{"sub":"6ae5f0b2-bf2d-4493-b37a-1c2a83901686","email":"rickelmepe@gmail.com","email_verified":true}', 'email', '6ae5f0b2-bf2d-4493-b37a-1c2a83901686', '2026-01-23T21:03:45.000Z', '2026-01-26T20:20:02.000Z', '2026-01-26T20:20:02.000Z');
UPDATE public.profiles SET name = 'Rickelme David Silva Cavalcante', cpf = '13146054450', phone = '81998017466', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'bb3ad87b-0cf4-4da0-a063-6b943b9cc49c' WHERE user_id = '6ae5f0b2-bf2d-4493-b37a-1c2a83901686';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '6ae5f0b2-bf2d-4493-b37a-1c2a83901686';

-- Suelen patricia batista de santana (suelenpatricia957@gmai.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('cb7cf473-80f9-4f09-8640-a5123c3c907e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'suelenpatricia957@gmai.com', '', '2026-01-23T21:03:57.000Z', '2026-01-23T21:03:57.000Z', '2026-01-23T21:12:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Suelen patricia batista de santana"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f5a626e1-81b0-4e9a-8885-ce5a090668ad', 'cb7cf473-80f9-4f09-8640-a5123c3c907e', '{"sub":"cb7cf473-80f9-4f09-8640-a5123c3c907e","email":"suelenpatricia957@gmai.com","email_verified":true}', 'email', 'cb7cf473-80f9-4f09-8640-a5123c3c907e', '2026-01-23T21:03:57.000Z', '2026-01-23T21:12:23.000Z', '2026-01-23T21:12:23.000Z');
UPDATE public.profiles SET name = 'Suelen patricia batista de santana', cpf = '07303140492', phone = '81986913498', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '7f2222de-abe1-4f1b-8f94-794ec29d1e89' WHERE user_id = 'cb7cf473-80f9-4f09-8640-a5123c3c907e';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'cb7cf473-80f9-4f09-8640-a5123c3c907e';

-- Ellen Elis (ellenelis87@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d9ea1710-f54f-4dc9-8804-fc4a570b3594', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ellenelis87@gmail.com', '', '2026-01-23T21:04:11.000Z', '2026-01-23T21:04:11.000Z', '2026-01-23T22:21:40.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ellen Elis"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0984e29a-ec92-41b6-bfc4-6384134b17e1', 'd9ea1710-f54f-4dc9-8804-fc4a570b3594', '{"sub":"d9ea1710-f54f-4dc9-8804-fc4a570b3594","email":"ellenelis87@gmail.com","email_verified":true}', 'email', 'd9ea1710-f54f-4dc9-8804-fc4a570b3594', '2026-01-23T21:04:11.000Z', '2026-01-23T22:21:40.000Z', '2026-01-23T22:21:41.000Z');
UPDATE public.profiles SET name = 'Ellen Elis', cpf = '70788486403', phone = '81988198651', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = '5d08258b-57ec-4010-a809-e9e6c1fb226c' WHERE user_id = 'd9ea1710-f54f-4dc9-8804-fc4a570b3594';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = 'd9ea1710-f54f-4dc9-8804-fc4a570b3594';

-- Lucas azevedo da silva  (lucas.azevedo3009@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5c9fa029-5bca-4a83-9b20-361b119045b8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lucas.azevedo3009@gmail.com', '', '2026-01-23T21:06:27.000Z', '2026-01-23T21:06:27.000Z', '2026-01-23T21:20:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lucas azevedo da silva "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3ecbcb16-dfef-4f5b-9408-994cac67edcb', '5c9fa029-5bca-4a83-9b20-361b119045b8', '{"sub":"5c9fa029-5bca-4a83-9b20-361b119045b8","email":"lucas.azevedo3009@gmail.com","email_verified":true}', 'email', '5c9fa029-5bca-4a83-9b20-361b119045b8', '2026-01-23T21:06:27.000Z', '2026-01-23T21:20:18.000Z', '2026-01-23T21:20:18.000Z');
UPDATE public.profiles SET name = 'Lucas azevedo da silva ', cpf = '10832780456', phone = '81988736755', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'aaece373-5f02-4eea-9c73-46bebe4a4a81' WHERE user_id = '5c9fa029-5bca-4a83-9b20-361b119045b8';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '5c9fa029-5bca-4a83-9b20-361b119045b8';

-- Leandro Victor Da Silva (leandroepronto3.1lvs@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7b1abe1a-126a-4981-b8f6-a7310e534e81', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'leandroepronto3.1lvs@gmail.com', '', '2026-01-23T22:20:24.000Z', '2026-01-23T22:20:24.000Z', '2026-01-25T01:51:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Leandro Victor Da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b90a5a03-1b8d-4cb6-a2a4-590988e21ed0', '7b1abe1a-126a-4981-b8f6-a7310e534e81', '{"sub":"7b1abe1a-126a-4981-b8f6-a7310e534e81","email":"leandroepronto3.1lvs@gmail.com","email_verified":true}', 'email', '7b1abe1a-126a-4981-b8f6-a7310e534e81', '2026-01-23T22:20:24.000Z', '2026-01-25T01:51:07.000Z', '2026-01-25T01:51:07.000Z');
UPDATE public.profiles SET name = 'Leandro Victor Da Silva', cpf = '03391054450', phone = '81988720636', company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f', department_id = 'aaece373-5f02-4eea-9c73-46bebe4a4a81' WHERE user_id = '7b1abe1a-126a-4981-b8f6-a7310e534e81';
UPDATE public.user_roles SET company_id = 'e349848b-85c5-4c7d-ad62-f781381a0f1f' WHERE user_id = '7b1abe1a-126a-4981-b8f6-a7310e534e81';

-- Fabiano diniz santos (fabianodinizsantos@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d2f8c824-6b9c-4223-a540-c9c77da79fd9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'fabianodinizsantos@gmail.com', '', '2026-01-24T23:30:31.000Z', '2026-01-24T23:30:31.000Z', '2026-01-24T23:32:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fabiano diniz santos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f7d33579-4490-48de-9dc0-c3d2c153f48b', 'd2f8c824-6b9c-4223-a540-c9c77da79fd9', '{"sub":"d2f8c824-6b9c-4223-a540-c9c77da79fd9","email":"fabianodinizsantos@gmail.com","email_verified":true}', 'email', 'd2f8c824-6b9c-4223-a540-c9c77da79fd9', '2026-01-24T23:30:31.000Z', '2026-01-24T23:32:18.000Z', '2026-01-24T23:32:18.000Z');
UPDATE public.profiles SET name = 'Fabiano diniz santos', cpf = '00826320651', phone = '31991845450', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd2f8c824-6b9c-4223-a540-c9c77da79fd9';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd2f8c824-6b9c-4223-a540-c9c77da79fd9';

-- Rogério Caetano (rgcaetanofujitsu@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('266b4311-2702-43b5-93dd-880249dc919d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rgcaetanofujitsu@gmail.com', '', '2026-01-24T23:30:34.000Z', '2026-01-24T23:30:34.000Z', '2026-01-25T15:34:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rogério Caetano"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('278f640e-7b9f-4b22-9a5f-a28d541038cb', '266b4311-2702-43b5-93dd-880249dc919d', '{"sub":"266b4311-2702-43b5-93dd-880249dc919d","email":"rgcaetanofujitsu@gmail.com","email_verified":true}', 'email', '266b4311-2702-43b5-93dd-880249dc919d', '2026-01-24T23:30:34.000Z', '2026-01-25T15:34:36.000Z', '2026-01-25T15:34:37.000Z');
UPDATE public.profiles SET name = 'Rogério Caetano', cpf = '12504640803', phone = '11940847476', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '266b4311-2702-43b5-93dd-880249dc919d';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '266b4311-2702-43b5-93dd-880249dc919d';

-- GIANCARLO DAL MULIN (giancarlodalmulin@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c1f8fe80-3973-44c6-ad01-4a7b4c968126', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'giancarlodalmulin@gmail.com', '', '2026-01-24T23:30:41.000Z', '2026-01-24T23:30:41.000Z', '2026-01-28T23:21:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GIANCARLO DAL MULIN"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c3f8d109-d450-41e7-adae-dd1aa971c43a', 'c1f8fe80-3973-44c6-ad01-4a7b4c968126', '{"sub":"c1f8fe80-3973-44c6-ad01-4a7b4c968126","email":"giancarlodalmulin@gmail.com","email_verified":true}', 'email', 'c1f8fe80-3973-44c6-ad01-4a7b4c968126', '2026-01-24T23:30:41.000Z', '2026-01-28T23:21:17.000Z', '2026-01-28T23:21:17.000Z');
UPDATE public.profiles SET name = 'GIANCARLO DAL MULIN', cpf = '95307982020', phone = '51997075248', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c1f8fe80-3973-44c6-ad01-4a7b4c968126';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c1f8fe80-3973-44c6-ad01-4a7b4c968126';

-- Rodrigo Araujo (ronetju2019@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('49a2a2ad-7527-4d49-9cdd-39fc090e84a9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ronetju2019@gmail.com', '', '2026-01-24T23:30:46.000Z', '2026-01-24T23:30:46.000Z', '2026-01-25T15:30:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Araujo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('91ce7404-8b2f-4e38-997a-7b09b08c24a7', '49a2a2ad-7527-4d49-9cdd-39fc090e84a9', '{"sub":"49a2a2ad-7527-4d49-9cdd-39fc090e84a9","email":"ronetju2019@gmail.com","email_verified":true}', 'email', '49a2a2ad-7527-4d49-9cdd-39fc090e84a9', '2026-01-24T23:30:46.000Z', '2026-01-25T15:30:01.000Z', '2026-01-25T15:30:02.000Z');
UPDATE public.profiles SET name = 'Rodrigo Araujo', cpf = '08131149773', phone = '27997300312', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '49a2a2ad-7527-4d49-9cdd-39fc090e84a9';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '49a2a2ad-7527-4d49-9cdd-39fc090e84a9';

-- VALERIA MARTA  (valeria.educacional@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5e252ce6-305f-4fee-baea-43248b18631b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'valeria.educacional@gmail.com', '', '2026-01-24T23:30:49.000Z', '2026-01-24T23:30:49.000Z', '2026-01-24T23:32:40.000Z', '{"provider":"email","providers":["email"]}', '{"name":"VALERIA MARTA "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d0791a64-a0b5-436a-a8dc-4b6dd99da172', '5e252ce6-305f-4fee-baea-43248b18631b', '{"sub":"5e252ce6-305f-4fee-baea-43248b18631b","email":"valeria.educacional@gmail.com","email_verified":true}', 'email', '5e252ce6-305f-4fee-baea-43248b18631b', '2026-01-24T23:30:49.000Z', '2026-01-24T23:32:40.000Z', '2026-01-24T23:32:40.000Z');
UPDATE public.profiles SET name = 'VALERIA MARTA ', cpf = '95609172691', phone = '31996218864', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '5e252ce6-305f-4fee-baea-43248b18631b';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '5e252ce6-305f-4fee-baea-43248b18631b';

-- Andreia Aparecida Rangel Santos (dede_rangel@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('28926187-b441-47dd-9b16-4ec129c24ad5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dede_rangel@yahoo.com.br', '', '2026-01-24T23:30:50.000Z', '2026-01-24T23:30:50.000Z', '2026-01-26T15:19:30.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Andreia Aparecida Rangel Santos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e5db7f6e-5def-4aeb-a701-38a53d89cdf1', '28926187-b441-47dd-9b16-4ec129c24ad5', '{"sub":"28926187-b441-47dd-9b16-4ec129c24ad5","email":"dede_rangel@yahoo.com.br","email_verified":true}', 'email', '28926187-b441-47dd-9b16-4ec129c24ad5', '2026-01-24T23:30:50.000Z', '2026-01-26T15:19:30.000Z', '2026-01-26T15:19:30.000Z');
UPDATE public.profiles SET name = 'Andreia Aparecida Rangel Santos', cpf = '32985600812', phone = '11975952053', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '28926187-b441-47dd-9b16-4ec129c24ad5';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '28926187-b441-47dd-9b16-4ec129c24ad5';

-- Renato Corrêa Magalhães de Paula (renato.correa@oktz.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('908c263c-9533-4822-b44c-eeeacb55f535', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'renato.correa@oktz.com.br', '', '2026-01-24T23:30:51.000Z', '2026-01-24T23:30:51.000Z', '2026-01-27T17:21:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Renato Corrêa Magalhães de Paula"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b8fb5924-7e79-410b-91cb-c9580885d4df', '908c263c-9533-4822-b44c-eeeacb55f535', '{"sub":"908c263c-9533-4822-b44c-eeeacb55f535","email":"renato.correa@oktz.com.br","email_verified":true}', 'email', '908c263c-9533-4822-b44c-eeeacb55f535', '2026-01-24T23:30:51.000Z', '2026-01-27T17:21:59.000Z', '2026-01-27T17:21:58.000Z');
UPDATE public.profiles SET name = 'Renato Corrêa Magalhães de Paula', cpf = '05451677603', phone = '31996161869', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '908c263c-9533-4822-b44c-eeeacb55f535';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '908c263c-9533-4822-b44c-eeeacb55f535';

-- Eduardo Guietti (institutoalupo@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7376eac9-6ca7-4e8b-a361-785787860177', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'institutoalupo@gmail.com', '', '2026-01-24T23:30:59.000Z', '2026-01-24T23:30:59.000Z', '2026-01-24T23:36:28.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Eduardo Guietti"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('38c8f8eb-658d-493d-ba84-dfc576503e36', '7376eac9-6ca7-4e8b-a361-785787860177', '{"sub":"7376eac9-6ca7-4e8b-a361-785787860177","email":"institutoalupo@gmail.com","email_verified":true}', 'email', '7376eac9-6ca7-4e8b-a361-785787860177', '2026-01-24T23:30:59.000Z', '2026-01-24T23:36:28.000Z', '2026-01-24T23:36:29.000Z');
UPDATE public.profiles SET name = 'Eduardo Guietti', cpf = '34930836883', phone = '31997024172', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '7376eac9-6ca7-4e8b-a361-785787860177';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '7376eac9-6ca7-4e8b-a361-785787860177';

-- Fabio Marques Ferreira (fabio.marfer@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4dcd560d-73ae-4c67-a6c2-06a6f7b2da2c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'fabio.marfer@gmail.com', '', '2026-01-24T23:31:05.000Z', '2026-01-24T23:31:05.000Z', '2026-01-25T19:49:50.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fabio Marques Ferreira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e9fe8b74-3780-4105-a822-893768e3309a', '4dcd560d-73ae-4c67-a6c2-06a6f7b2da2c', '{"sub":"4dcd560d-73ae-4c67-a6c2-06a6f7b2da2c","email":"fabio.marfer@gmail.com","email_verified":true}', 'email', '4dcd560d-73ae-4c67-a6c2-06a6f7b2da2c', '2026-01-24T23:31:05.000Z', '2026-01-25T19:49:50.000Z', '2026-01-25T19:49:50.000Z');
UPDATE public.profiles SET name = 'Fabio Marques Ferreira', cpf = '37892348859', phone = '11985214694', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '4dcd560d-73ae-4c67-a6c2-06a6f7b2da2c';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '4dcd560d-73ae-4c67-a6c2-06a6f7b2da2c';

-- José Welinton da Silva  (welintonsilva690@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('90d542b8-e008-475b-86cf-8f0a4d7307da', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'welintonsilva690@gmail.com', '', '2026-01-24T23:31:09.000Z', '2026-01-24T23:31:09.000Z', '2026-01-25T16:25:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"José Welinton da Silva "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dfcf6f4b-53ce-41f2-bacd-6cc554d32518', '90d542b8-e008-475b-86cf-8f0a4d7307da', '{"sub":"90d542b8-e008-475b-86cf-8f0a4d7307da","email":"welintonsilva690@gmail.com","email_verified":true}', 'email', '90d542b8-e008-475b-86cf-8f0a4d7307da', '2026-01-24T23:31:09.000Z', '2026-01-25T16:25:12.000Z', '2026-01-25T16:25:12.000Z');
UPDATE public.profiles SET name = 'José Welinton da Silva ', cpf = '12363680456', phone = '84988077198', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '90d542b8-e008-475b-86cf-8f0a4d7307da';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '90d542b8-e008-475b-86cf-8f0a4d7307da';

-- Manoel Juarez de Alencar Souza Junior (jrmagrafil@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d046f034-e491-4c66-8b12-d5f668903bfa', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jrmagrafil@gmail.com', '', '2026-01-24T23:31:14.000Z', '2026-01-24T23:31:14.000Z', '2026-01-25T00:15:41.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Manoel Juarez de Alencar Souza Junior"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('861e4de9-7170-4a42-92b2-90e19216acfc', 'd046f034-e491-4c66-8b12-d5f668903bfa', '{"sub":"d046f034-e491-4c66-8b12-d5f668903bfa","email":"jrmagrafil@gmail.com","email_verified":true}', 'email', 'd046f034-e491-4c66-8b12-d5f668903bfa', '2026-01-24T23:31:14.000Z', '2026-01-25T00:15:41.000Z', '2026-01-25T00:15:42.000Z');
UPDATE public.profiles SET name = 'Manoel Juarez de Alencar Souza Junior', cpf = '03665748330', phone = '86999010947', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd046f034-e491-4c66-8b12-d5f668903bfa';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd046f034-e491-4c66-8b12-d5f668903bfa';

-- Maria Regina Alcantara (lua77@uol.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('25d40c6a-7919-4d70-9824-d5366f0a8ac0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lua77@uol.com.br', '', '2026-01-24T23:31:18.000Z', '2026-01-24T23:31:18.000Z', '2026-01-26T01:23:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maria Regina Alcantara"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6b810c82-edd3-420c-9e00-ff069902d682', '25d40c6a-7919-4d70-9824-d5366f0a8ac0', '{"sub":"25d40c6a-7919-4d70-9824-d5366f0a8ac0","email":"lua77@uol.com.br","email_verified":true}', 'email', '25d40c6a-7919-4d70-9824-d5366f0a8ac0', '2026-01-24T23:31:18.000Z', '2026-01-26T01:23:51.000Z', '2026-01-26T01:23:51.000Z');
UPDATE public.profiles SET name = 'Maria Regina Alcantara', cpf = '10580544818', phone = '11949917008', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '25d40c6a-7919-4d70-9824-d5366f0a8ac0';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '25d40c6a-7919-4d70-9824-d5366f0a8ac0';

-- MARCO ANTONIO MARTINS DE OLIVEIRA JUNIOR (Marcoamojr@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('41810d44-bc73-4a56-9b70-4253634820e0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'Marcoamojr@gmail.com', '', '2026-01-24T23:31:25.000Z', '2026-01-24T23:31:25.000Z', '2026-01-25T15:21:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"MARCO ANTONIO MARTINS DE OLIVEIRA JUNIOR"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3fb4b3b2-c551-4a9e-97e4-2f130fe74f5a', '41810d44-bc73-4a56-9b70-4253634820e0', '{"sub":"41810d44-bc73-4a56-9b70-4253634820e0","email":"Marcoamojr@gmail.com","email_verified":true}', 'email', '41810d44-bc73-4a56-9b70-4253634820e0', '2026-01-24T23:31:25.000Z', '2026-01-25T15:21:58.000Z', '2026-01-25T15:21:58.000Z');
UPDATE public.profiles SET name = 'MARCO ANTONIO MARTINS DE OLIVEIRA JUNIOR', cpf = '02589640579', phone = '73998100641', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '41810d44-bc73-4a56-9b70-4253634820e0';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '41810d44-bc73-4a56-9b70-4253634820e0';

-- JULIANA COSTA CAMPOS (julianacosta_15@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8db7cd7b-ffea-49f7-97d9-97d74412284d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'julianacosta_15@hotmail.com', '', '2026-01-24T23:31:34.000Z', '2026-01-24T23:31:34.000Z', '2026-01-24T23:58:39.000Z', '{"provider":"email","providers":["email"]}', '{"name":"JULIANA COSTA CAMPOS"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('13c9febb-5f56-4200-b6cf-e23af97f0971', '8db7cd7b-ffea-49f7-97d9-97d74412284d', '{"sub":"8db7cd7b-ffea-49f7-97d9-97d74412284d","email":"julianacosta_15@hotmail.com","email_verified":true}', 'email', '8db7cd7b-ffea-49f7-97d9-97d74412284d', '2026-01-24T23:31:34.000Z', '2026-01-24T23:58:39.000Z', '2026-01-24T23:58:39.000Z');
UPDATE public.profiles SET name = 'JULIANA COSTA CAMPOS', cpf = '00949081175', phone = '62993056929', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '8db7cd7b-ffea-49f7-97d9-97d74412284d';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '8db7cd7b-ffea-49f7-97d9-97d74412284d';

-- Fernanda Arceno (fernanda_arceno@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('57cc967c-6a5f-4463-a4a3-1326e53c01ae', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'fernanda_arceno@hotmail.com', '', '2026-01-24T23:31:43.000Z', '2026-01-24T23:31:43.000Z', '2026-01-25T21:28:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fernanda Arceno"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c9e8eecf-f49c-4eea-adab-64131b2804e8', '57cc967c-6a5f-4463-a4a3-1326e53c01ae', '{"sub":"57cc967c-6a5f-4463-a4a3-1326e53c01ae","email":"fernanda_arceno@hotmail.com","email_verified":true}', 'email', '57cc967c-6a5f-4463-a4a3-1326e53c01ae', '2026-01-24T23:31:43.000Z', '2026-01-25T21:28:00.000Z', '2026-01-25T21:28:00.000Z');
UPDATE public.profiles SET name = 'Fernanda Arceno', cpf = '11319701957', phone = '48991606346', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '57cc967c-6a5f-4463-a4a3-1326e53c01ae';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '57cc967c-6a5f-4463-a4a3-1326e53c01ae';

-- Mauricio Silva (mauriciosilva1590@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('88fa54fa-f33c-407c-ad9d-bf77d424c847', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mauriciosilva1590@gmail.com', '', '2026-01-24T23:31:45.000Z', '2026-01-24T23:31:45.000Z', '2026-01-25T04:21:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Mauricio Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('df016583-1358-4b7a-899d-3387e73dcb92', '88fa54fa-f33c-407c-ad9d-bf77d424c847', '{"sub":"88fa54fa-f33c-407c-ad9d-bf77d424c847","email":"mauriciosilva1590@gmail.com","email_verified":true}', 'email', '88fa54fa-f33c-407c-ad9d-bf77d424c847', '2026-01-24T23:31:45.000Z', '2026-01-25T04:21:33.000Z', '2026-01-25T04:21:33.000Z');
UPDATE public.profiles SET name = 'Mauricio Silva', cpf = '86288960586', phone = '71992781850', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '88fa54fa-f33c-407c-ad9d-bf77d424c847';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '88fa54fa-f33c-407c-ad9d-bf77d424c847';

-- AMILTON GUEDES SOARES FREITAS (amiltonguedes2009@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a5537963-d26c-4f76-bcca-b9a07a890194', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'amiltonguedes2009@gmail.com', '', '2026-01-24T23:31:47.000Z', '2026-01-24T23:31:47.000Z', '2026-01-26T22:58:39.000Z', '{"provider":"email","providers":["email"]}', '{"name":"AMILTON GUEDES SOARES FREITAS"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('010ee305-c218-4f0b-a208-3444b55c7d2d', 'a5537963-d26c-4f76-bcca-b9a07a890194', '{"sub":"a5537963-d26c-4f76-bcca-b9a07a890194","email":"amiltonguedes2009@gmail.com","email_verified":true}', 'email', 'a5537963-d26c-4f76-bcca-b9a07a890194', '2026-01-24T23:31:47.000Z', '2026-01-26T22:58:39.000Z', '2026-01-26T22:58:39.000Z');
UPDATE public.profiles SET name = 'AMILTON GUEDES SOARES FREITAS', cpf = '29549473813', phone = '41998325865', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a5537963-d26c-4f76-bcca-b9a07a890194';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a5537963-d26c-4f76-bcca-b9a07a890194';

-- Vinícius Leal Faria (viniciusleal@ymail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('463220b6-9300-4a92-81ba-821d82a7a778', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'viniciusleal@ymail.com', '', '2026-01-24T23:31:48.000Z', '2026-01-24T23:31:48.000Z', '2026-01-24T23:33:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Vinícius Leal Faria"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a16d8221-577f-498b-85e3-b3b9690b5e80', '463220b6-9300-4a92-81ba-821d82a7a778', '{"sub":"463220b6-9300-4a92-81ba-821d82a7a778","email":"viniciusleal@ymail.com","email_verified":true}', 'email', '463220b6-9300-4a92-81ba-821d82a7a778', '2026-01-24T23:31:48.000Z', '2026-01-24T23:33:16.000Z', '2026-01-24T23:33:17.000Z');
UPDATE public.profiles SET name = 'Vinícius Leal Faria', cpf = '05134634610', phone = '32988434656', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '463220b6-9300-4a92-81ba-821d82a7a778';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '463220b6-9300-4a92-81ba-821d82a7a778';

-- Gilberto Luis maranhao (gilberto.maranhao78@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('45472bde-e555-4485-9319-75173986813a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gilberto.maranhao78@gmail.com', '', '2026-01-24T23:32:01.000Z', '2026-01-24T23:32:01.000Z', '2026-01-26T18:28:44.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gilberto Luis maranhao"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('77fb032b-1084-479f-8b94-04f0078677da', '45472bde-e555-4485-9319-75173986813a', '{"sub":"45472bde-e555-4485-9319-75173986813a","email":"gilberto.maranhao78@gmail.com","email_verified":true}', 'email', '45472bde-e555-4485-9319-75173986813a', '2026-01-24T23:32:01.000Z', '2026-01-26T18:28:44.000Z', '2026-01-26T18:28:43.000Z');
UPDATE public.profiles SET name = 'Gilberto Luis maranhao', cpf = '27262598805', phone = '12991842761', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '45472bde-e555-4485-9319-75173986813a';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '45472bde-e555-4485-9319-75173986813a';

-- Jocemar Martins Calado (jocemarmartinscalado@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bb5e022f-821c-4eb3-a46f-fc12e0fca028', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jocemarmartinscalado@gmail.com', '', '2026-01-24T23:32:10.000Z', '2026-01-24T23:32:10.000Z', '2026-01-25T17:00:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Jocemar Martins Calado"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8559dee6-4e4b-4747-9a22-6cb3b5f6e054', 'bb5e022f-821c-4eb3-a46f-fc12e0fca028', '{"sub":"bb5e022f-821c-4eb3-a46f-fc12e0fca028","email":"jocemarmartinscalado@gmail.com","email_verified":true}', 'email', 'bb5e022f-821c-4eb3-a46f-fc12e0fca028', '2026-01-24T23:32:10.000Z', '2026-01-25T17:00:47.000Z', '2026-01-25T17:00:47.000Z');
UPDATE public.profiles SET name = 'Jocemar Martins Calado', cpf = '62279181487', phone = '85999565378', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'bb5e022f-821c-4eb3-a46f-fc12e0fca028';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'bb5e022f-821c-4eb3-a46f-fc12e0fca028';

-- Ricardo Akiyo Minasse Tomita  (ricardo.a.m.tomita@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dbc4126c-3393-43f8-8466-87a31bf40f23', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ricardo.a.m.tomita@gmail.com', '', '2026-01-24T23:32:11.000Z', '2026-01-24T23:32:11.000Z', '2026-01-29T00:41:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ricardo Akiyo Minasse Tomita "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('aff18c34-ca7f-4ba4-8e90-cbcf53842a92', 'dbc4126c-3393-43f8-8466-87a31bf40f23', '{"sub":"dbc4126c-3393-43f8-8466-87a31bf40f23","email":"ricardo.a.m.tomita@gmail.com","email_verified":true}', 'email', 'dbc4126c-3393-43f8-8466-87a31bf40f23', '2026-01-24T23:32:11.000Z', '2026-01-29T00:41:19.000Z', '2026-01-29T00:41:18.000Z');
UPDATE public.profiles SET name = 'Ricardo Akiyo Minasse Tomita ', cpf = '46886895869', phone = '11993918554', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'dbc4126c-3393-43f8-8466-87a31bf40f23';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'dbc4126c-3393-43f8-8466-87a31bf40f23';

-- Livia (ljordaosilva@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('94c0b7a1-2ab4-4e6a-93c7-9514c51cfbc6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ljordaosilva@gmail.com', '', '2026-01-24T23:32:16.000Z', '2026-01-24T23:32:16.000Z', '2026-01-24T23:32:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Livia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e5743953-0416-4283-8b17-f8f857046b3d', '94c0b7a1-2ab4-4e6a-93c7-9514c51cfbc6', '{"sub":"94c0b7a1-2ab4-4e6a-93c7-9514c51cfbc6","email":"ljordaosilva@gmail.com","email_verified":true}', 'email', '94c0b7a1-2ab4-4e6a-93c7-9514c51cfbc6', '2026-01-24T23:32:16.000Z', '2026-01-24T23:32:23.000Z', '2026-01-24T23:32:24.000Z');
UPDATE public.profiles SET name = 'Livia', cpf = '08974814617', phone = '3291197382', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '94c0b7a1-2ab4-4e6a-93c7-9514c51cfbc6';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '94c0b7a1-2ab4-4e6a-93c7-9514c51cfbc6';

-- MARCELO NOVAES PUGLIESI (marpugliesi@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('aea602b3-b6f6-45d3-b41b-1d8e4d3fe6f2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'marpugliesi@gmail.com', '', '2026-01-24T23:32:19.000Z', '2026-01-24T23:32:19.000Z', '2026-01-24T23:32:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"MARCELO NOVAES PUGLIESI"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7abac360-0862-4129-a134-3b972ccb70fc', 'aea602b3-b6f6-45d3-b41b-1d8e4d3fe6f2', '{"sub":"aea602b3-b6f6-45d3-b41b-1d8e4d3fe6f2","email":"marpugliesi@gmail.com","email_verified":true}', 'email', 'aea602b3-b6f6-45d3-b41b-1d8e4d3fe6f2', '2026-01-24T23:32:19.000Z', '2026-01-24T23:32:29.000Z', '2026-01-24T23:32:29.000Z');
UPDATE public.profiles SET name = 'MARCELO NOVAES PUGLIESI', cpf = '71879005115', phone = '67992218655', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'aea602b3-b6f6-45d3-b41b-1d8e4d3fe6f2';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'aea602b3-b6f6-45d3-b41b-1d8e4d3fe6f2';

-- Pedro Victor Silva Moraes (pedro@reclick.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3681d6ff-00dd-486a-82a4-20e9bde7daf2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'pedro@reclick.com.br', '', '2026-01-24T23:32:19.000Z', '2026-01-24T23:32:19.000Z', '2026-01-24T23:36:34.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Pedro Victor Silva Moraes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('30ee491c-43e6-43e5-bfa6-a173f341c9f4', '3681d6ff-00dd-486a-82a4-20e9bde7daf2', '{"sub":"3681d6ff-00dd-486a-82a4-20e9bde7daf2","email":"pedro@reclick.com.br","email_verified":true}', 'email', '3681d6ff-00dd-486a-82a4-20e9bde7daf2', '2026-01-24T23:32:19.000Z', '2026-01-24T23:36:34.000Z', '2026-01-24T23:36:35.000Z');
UPDATE public.profiles SET name = 'Pedro Victor Silva Moraes', cpf = '10724912657', phone = '31991208164', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3681d6ff-00dd-486a-82a4-20e9bde7daf2';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3681d6ff-00dd-486a-82a4-20e9bde7daf2';

-- Fabiana Monteiro Santiago Cardoso (fabmontsant@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5d46d8ff-d04b-440a-bda2-5ae69d556b64', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'fabmontsant@gmail.com', '', '2026-01-24T23:32:22.000Z', '2026-01-24T23:32:22.000Z', '2026-01-27T23:34:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fabiana Monteiro Santiago Cardoso"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d6eadfc5-37a7-4ce3-9c3c-7f1f71648866', '5d46d8ff-d04b-440a-bda2-5ae69d556b64', '{"sub":"5d46d8ff-d04b-440a-bda2-5ae69d556b64","email":"fabmontsant@gmail.com","email_verified":true}', 'email', '5d46d8ff-d04b-440a-bda2-5ae69d556b64', '2026-01-24T23:32:22.000Z', '2026-01-27T23:34:15.000Z', '2026-01-27T23:34:14.000Z');
UPDATE public.profiles SET name = 'Fabiana Monteiro Santiago Cardoso', cpf = '03075862606', phone = '35999726850', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '5d46d8ff-d04b-440a-bda2-5ae69d556b64';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '5d46d8ff-d04b-440a-bda2-5ae69d556b64';

-- ANDRE RODRIGUES MANGINI (europalugares@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d3fb4d68-ae06-4afc-a33d-44850a861a91', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'europalugares@gmail.com', '', '2026-01-24T23:32:22.000Z', '2026-01-24T23:32:22.000Z', '2026-01-24T23:56:24.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ANDRE RODRIGUES MANGINI"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c232a28c-b031-4e05-be27-e0811625889b', 'd3fb4d68-ae06-4afc-a33d-44850a861a91', '{"sub":"d3fb4d68-ae06-4afc-a33d-44850a861a91","email":"europalugares@gmail.com","email_verified":true}', 'email', 'd3fb4d68-ae06-4afc-a33d-44850a861a91', '2026-01-24T23:32:22.000Z', '2026-01-24T23:56:24.000Z', '2026-01-24T23:56:24.000Z');
UPDATE public.profiles SET name = 'ANDRE RODRIGUES MANGINI', cpf = '02813680745', phone = '21981406866', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd3fb4d68-ae06-4afc-a33d-44850a861a91';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd3fb4d68-ae06-4afc-a33d-44850a861a91';

-- Luis Gildevam Rodrigues de Lima Junior (gildevamjunior@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('09fd25c9-d505-44dc-a353-90e64097b59e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gildevamjunior@hotmail.com', '', '2026-01-24T23:32:23.000Z', '2026-01-24T23:32:23.000Z', '2026-01-25T09:28:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Luis Gildevam Rodrigues de Lima Junior"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f72e40e0-e9bf-43a5-8862-06f203fc2e0e', '09fd25c9-d505-44dc-a353-90e64097b59e', '{"sub":"09fd25c9-d505-44dc-a353-90e64097b59e","email":"gildevamjunior@hotmail.com","email_verified":true}', 'email', '09fd25c9-d505-44dc-a353-90e64097b59e', '2026-01-24T23:32:23.000Z', '2026-01-25T09:28:03.000Z', '2026-01-25T09:28:03.000Z');
UPDATE public.profiles SET name = 'Luis Gildevam Rodrigues de Lima Junior', cpf = '02829039335', phone = '85991835460', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '09fd25c9-d505-44dc-a353-90e64097b59e';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '09fd25c9-d505-44dc-a353-90e64097b59e';

-- Alexandre Diniz César (alexandre.diniz.cesar@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('67941b9d-ecf2-4ad5-81e4-81a2ecb4bd76', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alexandre.diniz.cesar@gmail.com', '', '2026-01-24T23:32:24.000Z', '2026-01-24T23:32:24.000Z', '2026-01-24T23:57:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alexandre Diniz César"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('123fb4c4-b5da-4401-8680-54e795d2c380', '67941b9d-ecf2-4ad5-81e4-81a2ecb4bd76', '{"sub":"67941b9d-ecf2-4ad5-81e4-81a2ecb4bd76","email":"alexandre.diniz.cesar@gmail.com","email_verified":true}', 'email', '67941b9d-ecf2-4ad5-81e4-81a2ecb4bd76', '2026-01-24T23:32:24.000Z', '2026-01-24T23:57:29.000Z', '2026-01-24T23:57:29.000Z');
UPDATE public.profiles SET name = 'Alexandre Diniz César', cpf = '85948241653', phone = '31988581060', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '67941b9d-ecf2-4ad5-81e4-81a2ecb4bd76';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '67941b9d-ecf2-4ad5-81e4-81a2ecb4bd76';

-- Gabriela Mariana Dauer Rodrigues (gabrieladauer@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('42ef1700-8989-4057-b5c8-9f81a34af7c2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gabrieladauer@gmail.com', '', '2026-01-24T23:32:27.000Z', '2026-01-24T23:32:27.000Z', '2026-01-25T22:56:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gabriela Mariana Dauer Rodrigues"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c68242ae-90a5-4066-aa65-576ca14ef2db', '42ef1700-8989-4057-b5c8-9f81a34af7c2', '{"sub":"42ef1700-8989-4057-b5c8-9f81a34af7c2","email":"gabrieladauer@gmail.com","email_verified":true}', 'email', '42ef1700-8989-4057-b5c8-9f81a34af7c2', '2026-01-24T23:32:27.000Z', '2026-01-25T22:56:35.000Z', '2026-01-25T22:56:35.000Z');
UPDATE public.profiles SET name = 'Gabriela Mariana Dauer Rodrigues', cpf = '36647957847', phone = '11989398959', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '42ef1700-8989-4057-b5c8-9f81a34af7c2';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '42ef1700-8989-4057-b5c8-9f81a34af7c2';

-- Claudenice Carvalho dos Santos Souza (claudenice_lem@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c62587dd-2940-4bbf-aea3-cc2a8e832d02', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'claudenice_lem@hotmail.com', '', '2026-01-24T23:32:32.000Z', '2026-01-24T23:32:32.000Z', '2026-01-24T23:34:43.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Claudenice Carvalho dos Santos Souza"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('bc86fb6e-43d6-4155-af5e-55c1e34c6dcb', 'c62587dd-2940-4bbf-aea3-cc2a8e832d02', '{"sub":"c62587dd-2940-4bbf-aea3-cc2a8e832d02","email":"claudenice_lem@hotmail.com","email_verified":true}', 'email', 'c62587dd-2940-4bbf-aea3-cc2a8e832d02', '2026-01-24T23:32:32.000Z', '2026-01-24T23:34:43.000Z', '2026-01-24T23:34:43.000Z');
UPDATE public.profiles SET name = 'Claudenice Carvalho dos Santos Souza', cpf = '62777190178', phone = '77998156272', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c62587dd-2940-4bbf-aea3-cc2a8e832d02';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c62587dd-2940-4bbf-aea3-cc2a8e832d02';

-- Erika Christina Berner Vieira Weinberg  (art3dstd@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5cf575ef-eeac-422e-9023-f6d7908e2abd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'art3dstd@gmail.com', '', '2026-01-24T23:32:33.000Z', '2026-01-24T23:32:33.000Z', '2026-01-26T02:10:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Erika Christina Berner Vieira Weinberg "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('11d532fa-f496-4e04-91db-f7f31ecda9e1', '5cf575ef-eeac-422e-9023-f6d7908e2abd', '{"sub":"5cf575ef-eeac-422e-9023-f6d7908e2abd","email":"art3dstd@gmail.com","email_verified":true}', 'email', '5cf575ef-eeac-422e-9023-f6d7908e2abd', '2026-01-24T23:32:33.000Z', '2026-01-26T02:10:53.000Z', '2026-01-26T02:10:54.000Z');
UPDATE public.profiles SET name = 'Erika Christina Berner Vieira Weinberg ', cpf = '07585044704', phone = '24988571977', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '5cf575ef-eeac-422e-9023-f6d7908e2abd';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '5cf575ef-eeac-422e-9023-f6d7908e2abd';

-- VALDEIR PEREIRA DOS SANTOS (valdeirsantos891@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4829012e-90c3-4b14-875e-4acd61a6b569', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'valdeirsantos891@gmail.com', '', '2026-01-24T23:32:34.000Z', '2026-01-24T23:32:34.000Z', '2026-01-25T22:50:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"VALDEIR PEREIRA DOS SANTOS"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4bb0a681-f501-409e-a774-98ea77acb7cc', '4829012e-90c3-4b14-875e-4acd61a6b569', '{"sub":"4829012e-90c3-4b14-875e-4acd61a6b569","email":"valdeirsantos891@gmail.com","email_verified":true}', 'email', '4829012e-90c3-4b14-875e-4acd61a6b569', '2026-01-24T23:32:34.000Z', '2026-01-25T22:50:35.000Z', '2026-01-25T22:50:35.000Z');
UPDATE public.profiles SET name = 'VALDEIR PEREIRA DOS SANTOS', cpf = '04817263148', phone = '67981179342', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '4829012e-90c3-4b14-875e-4acd61a6b569';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '4829012e-90c3-4b14-875e-4acd61a6b569';

-- TAELIO SOUZA ALBUQUERQUE (ta.993810275@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c31192b1-3712-4fa7-9e89-d1f53b81796a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ta.993810275@gmail.com', '', '2026-01-24T23:32:39.000Z', '2026-01-24T23:32:39.000Z', '2026-01-24T23:34:52.000Z', '{"provider":"email","providers":["email"]}', '{"name":"TAELIO SOUZA ALBUQUERQUE"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('570ed58f-1dac-4a7e-a434-5f8727365a9c', 'c31192b1-3712-4fa7-9e89-d1f53b81796a', '{"sub":"c31192b1-3712-4fa7-9e89-d1f53b81796a","email":"ta.993810275@gmail.com","email_verified":true}', 'email', 'c31192b1-3712-4fa7-9e89-d1f53b81796a', '2026-01-24T23:32:39.000Z', '2026-01-24T23:34:52.000Z', '2026-01-24T23:34:52.000Z');
UPDATE public.profiles SET name = 'TAELIO SOUZA ALBUQUERQUE', cpf = '02073577229', phone = '91992638279', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c31192b1-3712-4fa7-9e89-d1f53b81796a';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c31192b1-3712-4fa7-9e89-d1f53b81796a';

-- Ruiter Fi (ruiterfidencio@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bfd7e198-981f-4786-982c-1a6fe29f3f45', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ruiterfidencio@gmail.com', '', '2026-01-24T23:32:41.000Z', '2026-01-24T23:32:41.000Z', '2026-01-24T23:50:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ruiter Fi"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('663a45a2-6a9d-48b6-a972-53566e6ed67c', 'bfd7e198-981f-4786-982c-1a6fe29f3f45', '{"sub":"bfd7e198-981f-4786-982c-1a6fe29f3f45","email":"ruiterfidencio@gmail.com","email_verified":true}', 'email', 'bfd7e198-981f-4786-982c-1a6fe29f3f45', '2026-01-24T23:32:41.000Z', '2026-01-24T23:50:35.000Z', '2026-01-24T23:50:36.000Z');
UPDATE public.profiles SET name = 'Ruiter Fi', cpf = '78630495120', phone = '64999633454', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'bfd7e198-981f-4786-982c-1a6fe29f3f45';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'bfd7e198-981f-4786-982c-1a6fe29f3f45';

-- Eliemar Bueno (eliemarbueno@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('21e8ff62-8043-4aad-ad9d-ea76bfb85ca6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'eliemarbueno@gmail.com', '', '2026-01-24T23:32:43.000Z', '2026-01-24T23:32:43.000Z', '2026-02-02T03:28:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Eliemar Bueno"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8a7654d9-7788-4ef2-a04a-50b52829a361', '21e8ff62-8043-4aad-ad9d-ea76bfb85ca6', '{"sub":"21e8ff62-8043-4aad-ad9d-ea76bfb85ca6","email":"eliemarbueno@gmail.com","email_verified":true}', 'email', '21e8ff62-8043-4aad-ad9d-ea76bfb85ca6', '2026-01-24T23:32:43.000Z', '2026-02-02T03:28:35.000Z', '2026-02-02T03:28:35.000Z');
UPDATE public.profiles SET name = 'Eliemar Bueno', cpf = '09631715779', phone = '27999935213', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '21e8ff62-8043-4aad-ad9d-ea76bfb85ca6';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '21e8ff62-8043-4aad-ad9d-ea76bfb85ca6';

-- Andreia Barreto (andreiacbarreto@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fd3c8676-231e-4910-941f-7ca4fa0fda2f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'andreiacbarreto@gmail.com', '', '2026-01-24T23:32:45.000Z', '2026-01-24T23:32:45.000Z', '2026-01-26T17:47:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Andreia Barreto"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1f011b1c-f773-476e-abfc-378cd7463b93', 'fd3c8676-231e-4910-941f-7ca4fa0fda2f', '{"sub":"fd3c8676-231e-4910-941f-7ca4fa0fda2f","email":"andreiacbarreto@gmail.com","email_verified":true}', 'email', 'fd3c8676-231e-4910-941f-7ca4fa0fda2f', '2026-01-24T23:32:45.000Z', '2026-01-26T17:47:01.000Z', '2026-01-26T17:47:01.000Z');
UPDATE public.profiles SET name = 'Andreia Barreto', cpf = '04142156640', phone = '31987482732', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'fd3c8676-231e-4910-941f-7ca4fa0fda2f';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'fd3c8676-231e-4910-941f-7ca4fa0fda2f';

-- Dorotéia Marra  (doromarra@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9bb6b2fe-1387-4a54-aed4-edb279bf0ade', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'doromarra@hotmail.com', '', '2026-01-24T23:32:46.000Z', '2026-01-24T23:32:46.000Z', '2026-01-24T23:43:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Dorotéia Marra "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1fe49a9d-bed5-4d26-93d8-d4b586c4aa81', '9bb6b2fe-1387-4a54-aed4-edb279bf0ade', '{"sub":"9bb6b2fe-1387-4a54-aed4-edb279bf0ade","email":"doromarra@hotmail.com","email_verified":true}', 'email', '9bb6b2fe-1387-4a54-aed4-edb279bf0ade', '2026-01-24T23:32:46.000Z', '2026-01-24T23:43:32.000Z', '2026-01-24T23:43:32.000Z');
UPDATE public.profiles SET name = 'Dorotéia Marra ', cpf = '00538007885', phone = '17981514798', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '9bb6b2fe-1387-4a54-aed4-edb279bf0ade';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '9bb6b2fe-1387-4a54-aed4-edb279bf0ade';

-- Suelen Ribeiro (suelenribeiro@gestaomatriz.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3fd68952-8845-436e-b2a6-012470a46294', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'suelenribeiro@gestaomatriz.com.br', '', '2026-01-24T23:32:48.000Z', '2026-01-24T23:32:48.000Z', '2026-01-25T22:14:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Suelen Ribeiro"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d50921ee-00c8-47f3-8fd0-cd8070813642', '3fd68952-8845-436e-b2a6-012470a46294', '{"sub":"3fd68952-8845-436e-b2a6-012470a46294","email":"suelenribeiro@gestaomatriz.com.br","email_verified":true}', 'email', '3fd68952-8845-436e-b2a6-012470a46294', '2026-01-24T23:32:48.000Z', '2026-01-25T22:14:01.000Z', '2026-01-25T22:14:01.000Z');
UPDATE public.profiles SET name = 'Suelen Ribeiro', cpf = '00036046086', phone = '51980630525', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3fd68952-8845-436e-b2a6-012470a46294';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3fd68952-8845-436e-b2a6-012470a46294';

-- Giliardi Rodriguez (grodriguez@piattino.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2325ee16-5059-4264-a368-f55873dab7ad', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'grodriguez@piattino.com.br', '', '2026-01-24T23:32:49.000Z', '2026-01-24T23:32:49.000Z', '2026-01-24T23:34:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Giliardi Rodriguez"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('223f0379-a85d-4cd9-b50c-6ec125f8b0ef', '2325ee16-5059-4264-a368-f55873dab7ad', '{"sub":"2325ee16-5059-4264-a368-f55873dab7ad","email":"grodriguez@piattino.com.br","email_verified":true}', 'email', '2325ee16-5059-4264-a368-f55873dab7ad', '2026-01-24T23:32:49.000Z', '2026-01-24T23:34:49.000Z', '2026-01-24T23:34:49.000Z');
UPDATE public.profiles SET name = 'Giliardi Rodriguez', cpf = '21375662813', phone = '11982860424', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '2325ee16-5059-4264-a368-f55873dab7ad';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '2325ee16-5059-4264-a368-f55873dab7ad';

-- LEANDRO CARLOS SPENER XAVIER (lcsxavier@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('aa97bb87-2ddb-4623-b7f8-52b797e23930', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lcsxavier@hotmail.com', '', '2026-01-24T23:32:49.000Z', '2026-01-24T23:32:49.000Z', '2026-01-24T23:35:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"LEANDRO CARLOS SPENER XAVIER"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d3266e1d-b566-430c-8fe3-fe1c5f0222f7', 'aa97bb87-2ddb-4623-b7f8-52b797e23930', '{"sub":"aa97bb87-2ddb-4623-b7f8-52b797e23930","email":"lcsxavier@hotmail.com","email_verified":true}', 'email', 'aa97bb87-2ddb-4623-b7f8-52b797e23930', '2026-01-24T23:32:49.000Z', '2026-01-24T23:35:18.000Z', '2026-01-24T23:35:18.000Z');
UPDATE public.profiles SET name = 'LEANDRO CARLOS SPENER XAVIER', cpf = '02185525727', phone = '92994962739', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'aa97bb87-2ddb-4623-b7f8-52b797e23930';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'aa97bb87-2ddb-4623-b7f8-52b797e23930';

-- Bruna Arruda Capeloa (brunaarruda1712@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('75359f5c-7077-416e-a213-9a9318107355', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'brunaarruda1712@gmail.com', '', '2026-01-24T23:32:49.000Z', '2026-01-24T23:32:49.000Z', '2026-01-25T22:52:42.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Bruna Arruda Capeloa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c76bd41f-3ac9-4b58-9d00-faab5908e8e3', '75359f5c-7077-416e-a213-9a9318107355', '{"sub":"75359f5c-7077-416e-a213-9a9318107355","email":"brunaarruda1712@gmail.com","email_verified":true}', 'email', '75359f5c-7077-416e-a213-9a9318107355', '2026-01-24T23:32:49.000Z', '2026-01-25T22:52:42.000Z', '2026-01-25T22:52:43.000Z');
UPDATE public.profiles SET name = 'Bruna Arruda Capeloa', cpf = '41362028819', phone = '11957939767', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '75359f5c-7077-416e-a213-9a9318107355';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '75359f5c-7077-416e-a213-9a9318107355';

-- Maisa de A Forster Machado (maisahfm@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8e442685-72ce-47c9-9de2-c20183652f31', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'maisahfm@gmail.com', '', '2026-01-24T23:32:51.000Z', '2026-01-24T23:32:51.000Z', '2026-01-24T23:54:43.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maisa de A Forster Machado"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6946c243-c36c-4a55-b513-6a17ddd04c42', '8e442685-72ce-47c9-9de2-c20183652f31', '{"sub":"8e442685-72ce-47c9-9de2-c20183652f31","email":"maisahfm@gmail.com","email_verified":true}', 'email', '8e442685-72ce-47c9-9de2-c20183652f31', '2026-01-24T23:32:51.000Z', '2026-01-24T23:54:43.000Z', '2026-01-24T23:54:44.000Z');
UPDATE public.profiles SET name = 'Maisa de A Forster Machado', cpf = '01441610871', phone = '11995249246', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '8e442685-72ce-47c9-9de2-c20183652f31';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '8e442685-72ce-47c9-9de2-c20183652f31';

-- Júlio César Salvador (gccotia.combate@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0d1df299-f9a1-4b69-9ee6-d03b9ef72016', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gccotia.combate@gmail.com', '', '2026-01-24T23:32:59.000Z', '2026-01-24T23:32:59.000Z', '2026-01-25T22:33:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Júlio César Salvador"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a7a97f87-1777-4f9f-b775-b2eacc85c8f8', '0d1df299-f9a1-4b69-9ee6-d03b9ef72016', '{"sub":"0d1df299-f9a1-4b69-9ee6-d03b9ef72016","email":"gccotia.combate@gmail.com","email_verified":true}', 'email', '0d1df299-f9a1-4b69-9ee6-d03b9ef72016', '2026-01-24T23:32:59.000Z', '2026-01-25T22:33:13.000Z', '2026-01-25T22:33:14.000Z');
UPDATE public.profiles SET name = 'Júlio César Salvador', cpf = '12255060850', phone = '11978918514', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '0d1df299-f9a1-4b69-9ee6-d03b9ef72016';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '0d1df299-f9a1-4b69-9ee6-d03b9ef72016';

-- JULIANA ARAUJO BOTELHO BETTINI (jubettini@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0daa0edc-f585-4e67-bdd7-8bba34530b05', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jubettini@gmail.com', '', '2026-01-24T23:32:59.000Z', '2026-01-24T23:32:59.000Z', '2026-01-26T15:58:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"JULIANA ARAUJO BOTELHO BETTINI"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('924f614f-87bc-4650-b0de-7c28992c09e5', '0daa0edc-f585-4e67-bdd7-8bba34530b05', '{"sub":"0daa0edc-f585-4e67-bdd7-8bba34530b05","email":"jubettini@gmail.com","email_verified":true}', 'email', '0daa0edc-f585-4e67-bdd7-8bba34530b05', '2026-01-24T23:32:59.000Z', '2026-01-26T15:58:23.000Z', '2026-01-26T15:58:23.000Z');
UPDATE public.profiles SET name = 'JULIANA ARAUJO BOTELHO BETTINI', cpf = '98752464920', phone = '47992071502', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '0daa0edc-f585-4e67-bdd7-8bba34530b05';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '0daa0edc-f585-4e67-bdd7-8bba34530b05';

-- Carina Reis de Mattos (rmatoscarina@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5cae6e11-b6e4-42f4-9916-b26520645caf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rmatoscarina@gmail.com', '', '2026-01-24T23:33:02.000Z', '2026-01-24T23:33:02.000Z', '2026-01-24T23:58:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carina Reis de Mattos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8ac6f823-1839-434e-ba4b-cededecd7f73', '5cae6e11-b6e4-42f4-9916-b26520645caf', '{"sub":"5cae6e11-b6e4-42f4-9916-b26520645caf","email":"rmatoscarina@gmail.com","email_verified":true}', 'email', '5cae6e11-b6e4-42f4-9916-b26520645caf', '2026-01-24T23:33:02.000Z', '2026-01-24T23:58:07.000Z', '2026-01-24T23:58:08.000Z');
UPDATE public.profiles SET name = 'Carina Reis de Mattos', cpf = '10737754613', phone = '31988371414', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '5cae6e11-b6e4-42f4-9916-b26520645caf';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '5cae6e11-b6e4-42f4-9916-b26520645caf';

-- Gisele kelermam (gkgloballink@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('294e0268-ebfb-4398-80e6-c9bded18123b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gkgloballink@gmail.com', '', '2026-01-24T23:33:04.000Z', '2026-01-24T23:33:04.000Z', '2026-01-25T16:10:39.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gisele kelermam"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3ed52b5b-9066-4a7d-995a-b45ba1f68d7b', '294e0268-ebfb-4398-80e6-c9bded18123b', '{"sub":"294e0268-ebfb-4398-80e6-c9bded18123b","email":"gkgloballink@gmail.com","email_verified":true}', 'email', '294e0268-ebfb-4398-80e6-c9bded18123b', '2026-01-24T23:33:04.000Z', '2026-01-25T16:10:39.000Z', '2026-01-25T16:10:39.000Z');
UPDATE public.profiles SET name = 'Gisele kelermam', cpf = '00837028060', phone = '11989157816', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '294e0268-ebfb-4398-80e6-c9bded18123b';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '294e0268-ebfb-4398-80e6-c9bded18123b';

-- Maria Eduarda Souza Branco (mariaeduardabranco1991@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6c5c8288-c099-4f33-b723-98489a459aa9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mariaeduardabranco1991@gmail.com', '', '2026-01-24T23:33:12.000Z', '2026-01-24T23:33:12.000Z', '2026-01-25T18:37:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maria Eduarda Souza Branco"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f8ddae42-37eb-4b91-96f4-71b4e5c11ab0', '6c5c8288-c099-4f33-b723-98489a459aa9', '{"sub":"6c5c8288-c099-4f33-b723-98489a459aa9","email":"mariaeduardabranco1991@gmail.com","email_verified":true}', 'email', '6c5c8288-c099-4f33-b723-98489a459aa9', '2026-01-24T23:33:12.000Z', '2026-01-25T18:37:23.000Z', '2026-01-25T18:37:23.000Z');
UPDATE public.profiles SET name = 'Maria Eduarda Souza Branco', cpf = '41102829854', phone = '18996221356', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '6c5c8288-c099-4f33-b723-98489a459aa9';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '6c5c8288-c099-4f33-b723-98489a459aa9';

-- PATRICIA DE ANDRADE FIGUEIRA TEIXEIRA (jornalistapatriciateixeira@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('22dbab4a-6d3f-4732-a2b4-1d4f895829a7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jornalistapatriciateixeira@gmail.com', '', '2026-01-24T23:33:13.000Z', '2026-01-24T23:33:13.000Z', '2026-01-26T20:32:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"PATRICIA DE ANDRADE FIGUEIRA TEIXEIRA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cc2c753a-dbd9-4a8d-869d-c2cdbae2e482', '22dbab4a-6d3f-4732-a2b4-1d4f895829a7', '{"sub":"22dbab4a-6d3f-4732-a2b4-1d4f895829a7","email":"jornalistapatriciateixeira@gmail.com","email_verified":true}', 'email', '22dbab4a-6d3f-4732-a2b4-1d4f895829a7', '2026-01-24T23:33:13.000Z', '2026-01-26T20:32:20.000Z', '2026-01-26T20:32:21.000Z');
UPDATE public.profiles SET name = 'PATRICIA DE ANDRADE FIGUEIRA TEIXEIRA', cpf = '10114925712', phone = '21987156685', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '22dbab4a-6d3f-4732-a2b4-1d4f895829a7';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '22dbab4a-6d3f-4732-a2b4-1d4f895829a7';

-- ELISA PEREIRA DE JESUS BARBOSA (elisapj@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('03695483-60ba-4467-aa49-fa97f70d00c5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'elisapj@hotmail.com', '', '2026-01-24T23:33:13.000Z', '2026-01-24T23:33:13.000Z', '2026-01-24T23:34:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ELISA PEREIRA DE JESUS BARBOSA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3dee68d9-9d3e-4361-bfe3-5333929655d4', '03695483-60ba-4467-aa49-fa97f70d00c5', '{"sub":"03695483-60ba-4467-aa49-fa97f70d00c5","email":"elisapj@hotmail.com","email_verified":true}', 'email', '03695483-60ba-4467-aa49-fa97f70d00c5', '2026-01-24T23:33:13.000Z', '2026-01-24T23:34:15.000Z', '2026-01-24T23:34:15.000Z');
UPDATE public.profiles SET name = 'ELISA PEREIRA DE JESUS BARBOSA', cpf = '02705173595', phone = '71991311657', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '03695483-60ba-4467-aa49-fa97f70d00c5';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '03695483-60ba-4467-aa49-fa97f70d00c5';

-- Carla Tutschke  (harmonia5x.mentorias@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('61f34258-98e2-4460-8472-d77722f3c169', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'harmonia5x.mentorias@gmail.com', '', '2026-01-24T23:33:13.000Z', '2026-01-24T23:33:13.000Z', '2026-01-25T18:42:40.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carla Tutschke "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4743829f-2ecd-429b-9149-8db22346ff3c', '61f34258-98e2-4460-8472-d77722f3c169', '{"sub":"61f34258-98e2-4460-8472-d77722f3c169","email":"harmonia5x.mentorias@gmail.com","email_verified":true}', 'email', '61f34258-98e2-4460-8472-d77722f3c169', '2026-01-24T23:33:13.000Z', '2026-01-25T18:42:40.000Z', '2026-01-25T18:42:41.000Z');
UPDATE public.profiles SET name = 'Carla Tutschke ', cpf = '05119431992', phone = '41984518385', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '61f34258-98e2-4460-8472-d77722f3c169';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '61f34258-98e2-4460-8472-d77722f3c169';

-- Savana Danuza Zamai  (savanazamai@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a45e8bd7-70fb-4ad0-8613-63485c45da8c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'savanazamai@gmail.com', '', '2026-01-24T23:33:16.000Z', '2026-01-24T23:33:16.000Z', '2026-01-25T22:45:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Savana Danuza Zamai "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ebd02700-d2f5-4e26-913b-7000060cc360', 'a45e8bd7-70fb-4ad0-8613-63485c45da8c', '{"sub":"a45e8bd7-70fb-4ad0-8613-63485c45da8c","email":"savanazamai@gmail.com","email_verified":true}', 'email', 'a45e8bd7-70fb-4ad0-8613-63485c45da8c', '2026-01-24T23:33:16.000Z', '2026-01-25T22:45:02.000Z', '2026-01-25T22:45:03.000Z');
UPDATE public.profiles SET name = 'Savana Danuza Zamai ', cpf = '31317301889', phone = '16993253819', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a45e8bd7-70fb-4ad0-8613-63485c45da8c';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a45e8bd7-70fb-4ad0-8613-63485c45da8c';

-- Fabio Oliveira (phabioliveira@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a0da46d5-c0d0-4710-b56f-3619b7d1bf6c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'phabioliveira@gmail.com', '', '2026-01-24T23:33:21.000Z', '2026-01-24T23:33:21.000Z', '2026-01-25T00:13:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fabio Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b14bc02e-f54e-4a48-be2a-0b748470fb1a', 'a0da46d5-c0d0-4710-b56f-3619b7d1bf6c', '{"sub":"a0da46d5-c0d0-4710-b56f-3619b7d1bf6c","email":"phabioliveira@gmail.com","email_verified":true}', 'email', 'a0da46d5-c0d0-4710-b56f-3619b7d1bf6c', '2026-01-24T23:33:21.000Z', '2026-01-25T00:13:19.000Z', '2026-01-25T00:13:20.000Z');
UPDATE public.profiles SET name = 'Fabio Oliveira', cpf = '94232245553', phone = '71981234489', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a0da46d5-c0d0-4710-b56f-3619b7d1bf6c';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a0da46d5-c0d0-4710-b56f-3619b7d1bf6c';

-- FERNANDA ALVES ROCHA (frs8176@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ef2377da-13fc-4626-b3ea-333fd0875931', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'frs8176@gmail.com', '', '2026-01-24T23:33:22.000Z', '2026-01-24T23:33:22.000Z', '2026-01-24T23:33:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"FERNANDA ALVES ROCHA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('bfc4bfaa-64c3-4a7b-beac-fdf1d5cfc25d', 'ef2377da-13fc-4626-b3ea-333fd0875931', '{"sub":"ef2377da-13fc-4626-b3ea-333fd0875931","email":"frs8176@gmail.com","email_verified":true}', 'email', 'ef2377da-13fc-4626-b3ea-333fd0875931', '2026-01-24T23:33:22.000Z', '2026-01-24T23:33:47.000Z', '2026-01-24T23:33:48.000Z');
UPDATE public.profiles SET name = 'FERNANDA ALVES ROCHA', cpf = '04767277744', phone = '21968049699', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'ef2377da-13fc-4626-b3ea-333fd0875931';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'ef2377da-13fc-4626-b3ea-333fd0875931';

-- Rose Mary martins (unapackembalagens@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bd90f83a-a015-4aa2-bc7b-cd9514da435d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'unapackembalagens@gmail.com', '', '2026-01-24T23:33:27.000Z', '2026-01-24T23:33:27.000Z', '2026-01-24T23:51:11.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rose Mary martins"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('bcd93193-df09-4e85-9f3b-b32a1c55255c', 'bd90f83a-a015-4aa2-bc7b-cd9514da435d', '{"sub":"bd90f83a-a015-4aa2-bc7b-cd9514da435d","email":"unapackembalagens@gmail.com","email_verified":true}', 'email', 'bd90f83a-a015-4aa2-bc7b-cd9514da435d', '2026-01-24T23:33:27.000Z', '2026-01-24T23:51:11.000Z', '2026-01-24T23:51:12.000Z');
UPDATE public.profiles SET name = 'Rose Mary martins', cpf = '04417894809', phone = '11956008186', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'bd90f83a-a015-4aa2-bc7b-cd9514da435d';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'bd90f83a-a015-4aa2-bc7b-cd9514da435d';

-- Taís Faria (taisfaria1@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3e31233f-a122-4fb1-9cbb-6e40703d07b5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'taisfaria1@gmail.com', '', '2026-01-24T23:33:29.000Z', '2026-01-24T23:33:29.000Z', '2026-01-24T23:33:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Taís Faria"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('512563c6-4ea9-4374-ba4a-e08fe6f9bd6b', '3e31233f-a122-4fb1-9cbb-6e40703d07b5', '{"sub":"3e31233f-a122-4fb1-9cbb-6e40703d07b5","email":"taisfaria1@gmail.com","email_verified":true}', 'email', '3e31233f-a122-4fb1-9cbb-6e40703d07b5', '2026-01-24T23:33:29.000Z', '2026-01-24T23:33:31.000Z', '2026-01-24T23:33:32.000Z');
UPDATE public.profiles SET name = 'Taís Faria', cpf = '23093787807', phone = '11982365730', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3e31233f-a122-4fb1-9cbb-6e40703d07b5';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3e31233f-a122-4fb1-9cbb-6e40703d07b5';

-- Rodrigo Alves de Araujo (ronetju@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4d93963c-0c00-4d01-a7c7-0efa1f210412', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ronetju@yahoo.com.br', '', '2026-01-24T23:33:37.000Z', '2026-01-24T23:33:37.000Z', '2026-01-25T19:58:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Alves de Araujo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7bae5541-f1cb-4970-8042-2884503ea6be', '4d93963c-0c00-4d01-a7c7-0efa1f210412', '{"sub":"4d93963c-0c00-4d01-a7c7-0efa1f210412","email":"ronetju@yahoo.com.br","email_verified":true}', 'email', '4d93963c-0c00-4d01-a7c7-0efa1f210412', '2026-01-24T23:33:37.000Z', '2026-01-25T19:58:36.000Z', '2026-01-25T19:58:36.000Z');
UPDATE public.profiles SET name = 'Rodrigo Alves de Araujo', cpf = '08131149773', phone = '27997300312', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '4d93963c-0c00-4d01-a7c7-0efa1f210412';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '4d93963c-0c00-4d01-a7c7-0efa1f210412';

-- lilian ribeiro coelho (lilianc21@yahoo.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('63de46ec-059c-4408-9701-b2e1f169d9d6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lilianc21@yahoo.com', '', '2026-01-24T23:33:41.000Z', '2026-01-24T23:33:41.000Z', '2026-01-24T23:49:38.000Z', '{"provider":"email","providers":["email"]}', '{"name":"lilian ribeiro coelho"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3775c9e1-5dc8-426a-badb-edddcd0690d1', '63de46ec-059c-4408-9701-b2e1f169d9d6', '{"sub":"63de46ec-059c-4408-9701-b2e1f169d9d6","email":"lilianc21@yahoo.com","email_verified":true}', 'email', '63de46ec-059c-4408-9701-b2e1f169d9d6', '2026-01-24T23:33:41.000Z', '2026-01-24T23:49:38.000Z', '2026-01-24T23:49:39.000Z');
UPDATE public.profiles SET name = 'lilian ribeiro coelho', cpf = '73834025704', phone = '21992297693', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '63de46ec-059c-4408-9701-b2e1f169d9d6';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '63de46ec-059c-4408-9701-b2e1f169d9d6';

-- GETULIO AIRES (getulioairescorretorimoveis@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('69b26a0a-6129-4c87-b0a0-bfebb1b44822', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'getulioairescorretorimoveis@gmail.com', '', '2026-01-24T23:33:41.000Z', '2026-01-24T23:33:41.000Z', '2026-01-25T22:11:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GETULIO AIRES"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('daf87426-3fd4-4a0f-aea9-7f031163be32', '69b26a0a-6129-4c87-b0a0-bfebb1b44822', '{"sub":"69b26a0a-6129-4c87-b0a0-bfebb1b44822","email":"getulioairescorretorimoveis@gmail.com","email_verified":true}', 'email', '69b26a0a-6129-4c87-b0a0-bfebb1b44822', '2026-01-24T23:33:41.000Z', '2026-01-25T22:11:49.000Z', '2026-01-25T22:11:50.000Z');
UPDATE public.profiles SET name = 'GETULIO AIRES', cpf = '26265575104', phone = '62996715383', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '69b26a0a-6129-4c87-b0a0-bfebb1b44822';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '69b26a0a-6129-4c87-b0a0-bfebb1b44822';

-- Kimberly Suellen Bueno (kimberly_suellen@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('86d75fad-84a4-4c15-820a-5c3d3a945775', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'kimberly_suellen@hotmail.com', '', '2026-01-24T23:33:44.000Z', '2026-01-24T23:33:44.000Z', '2026-01-24T23:43:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Kimberly Suellen Bueno"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a97e859f-0ce0-4670-845d-e35e14a310ba', '86d75fad-84a4-4c15-820a-5c3d3a945775', '{"sub":"86d75fad-84a4-4c15-820a-5c3d3a945775","email":"kimberly_suellen@hotmail.com","email_verified":true}', 'email', '86d75fad-84a4-4c15-820a-5c3d3a945775', '2026-01-24T23:33:44.000Z', '2026-01-24T23:43:31.000Z', '2026-01-24T23:43:31.000Z');
UPDATE public.profiles SET name = 'Kimberly Suellen Bueno', cpf = '08819414929', phone = '44998331341', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '86d75fad-84a4-4c15-820a-5c3d3a945775';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '86d75fad-84a4-4c15-820a-5c3d3a945775';

-- GISELLE APARECIDA DA SILVA LAGE (giselleas@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('761aae85-192f-4bc9-92e6-10d8306ece5e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'giselleas@hotmail.com', '', '2026-01-24T23:33:49.000Z', '2026-01-24T23:33:49.000Z', '2026-01-25T22:50:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GISELLE APARECIDA DA SILVA LAGE"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('01066ed3-79d4-42bd-8028-d8e9b0f70d0d', '761aae85-192f-4bc9-92e6-10d8306ece5e', '{"sub":"761aae85-192f-4bc9-92e6-10d8306ece5e","email":"giselleas@hotmail.com","email_verified":true}', 'email', '761aae85-192f-4bc9-92e6-10d8306ece5e', '2026-01-24T23:33:49.000Z', '2026-01-25T22:50:13.000Z', '2026-01-25T22:50:14.000Z');
UPDATE public.profiles SET name = 'GISELLE APARECIDA DA SILVA LAGE', cpf = '28719229852', phone = '11995595867', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '761aae85-192f-4bc9-92e6-10d8306ece5e';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '761aae85-192f-4bc9-92e6-10d8306ece5e';

-- Maurina da silveira  (maurina26mbk@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3884ac3d-4f7b-411d-97a8-be2b61cbb87c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'maurina26mbk@gmail.com', '', '2026-01-24T23:33:50.000Z', '2026-01-24T23:33:50.000Z', '2026-01-24T23:42:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maurina da silveira "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('172feb65-7588-4e50-97a1-bffb6b122b07', '3884ac3d-4f7b-411d-97a8-be2b61cbb87c', '{"sub":"3884ac3d-4f7b-411d-97a8-be2b61cbb87c","email":"maurina26mbk@gmail.com","email_verified":true}', 'email', '3884ac3d-4f7b-411d-97a8-be2b61cbb87c', '2026-01-24T23:33:50.000Z', '2026-01-24T23:42:55.000Z', '2026-01-24T23:42:56.000Z');
UPDATE public.profiles SET name = 'Maurina da silveira ', cpf = '02732713937', phone = '47984081443', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3884ac3d-4f7b-411d-97a8-be2b61cbb87c';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3884ac3d-4f7b-411d-97a8-be2b61cbb87c';

-- Maria Helena Rocha (helenafcr@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0480243c-b8f1-49c4-97cf-9190abd41f2b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'helenafcr@gmail.com', '', '2026-01-24T23:33:54.000Z', '2026-01-24T23:33:54.000Z', '2026-01-24T23:40:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maria Helena Rocha"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('49017000-9b0a-4593-a8fc-834aba4b3fb9', '0480243c-b8f1-49c4-97cf-9190abd41f2b', '{"sub":"0480243c-b8f1-49c4-97cf-9190abd41f2b","email":"helenafcr@gmail.com","email_verified":true}', 'email', '0480243c-b8f1-49c4-97cf-9190abd41f2b', '2026-01-24T23:33:54.000Z', '2026-01-24T23:40:35.000Z', '2026-01-24T23:40:35.000Z');
UPDATE public.profiles SET name = 'Maria Helena Rocha', cpf = '06349297636', phone = '31999978050', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '0480243c-b8f1-49c4-97cf-9190abd41f2b';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '0480243c-b8f1-49c4-97cf-9190abd41f2b';

-- ALESSANDRA LIMA DOS SANTOS (alle-lima2011@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3636b423-8de9-49d3-9d94-2ec5ccf5340a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alle-lima2011@hotmail.com', '', '2026-01-24T23:33:59.000Z', '2026-01-24T23:33:59.000Z', '2026-01-24T23:35:44.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ALESSANDRA LIMA DOS SANTOS"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ef8116d9-5eaf-4397-967b-ae9ab4cc76e4', '3636b423-8de9-49d3-9d94-2ec5ccf5340a', '{"sub":"3636b423-8de9-49d3-9d94-2ec5ccf5340a","email":"alle-lima2011@hotmail.com","email_verified":true}', 'email', '3636b423-8de9-49d3-9d94-2ec5ccf5340a', '2026-01-24T23:33:59.000Z', '2026-01-24T23:35:44.000Z', '2026-01-24T23:35:45.000Z');
UPDATE public.profiles SET name = 'ALESSANDRA LIMA DOS SANTOS', cpf = '02079824902', phone = '41988712614', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3636b423-8de9-49d3-9d94-2ec5ccf5340a';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3636b423-8de9-49d3-9d94-2ec5ccf5340a';

-- Larissa de Assis  (larissa21_assis@outlook.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('87e2e78f-1daf-44bf-a934-94df08b8655c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'larissa21_assis@outlook.com', '', '2026-01-24T23:34:02.000Z', '2026-01-24T23:34:02.000Z', '2026-01-24T23:35:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Larissa de Assis "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d32ffeb0-c449-4bef-b411-650a23d14238', '87e2e78f-1daf-44bf-a934-94df08b8655c', '{"sub":"87e2e78f-1daf-44bf-a934-94df08b8655c","email":"larissa21_assis@outlook.com","email_verified":true}', 'email', '87e2e78f-1daf-44bf-a934-94df08b8655c', '2026-01-24T23:34:02.000Z', '2026-01-24T23:35:15.000Z', '2026-01-24T23:35:16.000Z');
UPDATE public.profiles SET name = 'Larissa de Assis ', cpf = '12960652606', phone = '31982310103', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '87e2e78f-1daf-44bf-a934-94df08b8655c';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '87e2e78f-1daf-44bf-a934-94df08b8655c';

-- WANDERLEY ALMEIDA DOS REIS JUNIOR (junioalmeida1994@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b7015ef2-5ca1-4c7b-9488-f84bf514c76d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'junioalmeida1994@gmail.com', '', '2026-01-24T23:34:04.000Z', '2026-01-24T23:34:04.000Z', '2026-01-25T23:38:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"WANDERLEY ALMEIDA DOS REIS JUNIOR"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('07075110-01e6-4ef9-9090-7915ec9fa405', 'b7015ef2-5ca1-4c7b-9488-f84bf514c76d', '{"sub":"b7015ef2-5ca1-4c7b-9488-f84bf514c76d","email":"junioalmeida1994@gmail.com","email_verified":true}', 'email', 'b7015ef2-5ca1-4c7b-9488-f84bf514c76d', '2026-01-24T23:34:04.000Z', '2026-01-25T23:38:47.000Z', '2026-01-25T23:38:48.000Z');
UPDATE public.profiles SET name = 'WANDERLEY ALMEIDA DOS REIS JUNIOR', cpf = '11976516676', phone = '32998191606', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'b7015ef2-5ca1-4c7b-9488-f84bf514c76d';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'b7015ef2-5ca1-4c7b-9488-f84bf514c76d';

-- Amanda zahdi pessuti Turossi  (turossizah@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('376c6da1-abf3-4f11-867b-61dd3844d294', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'turossizah@gmail.com', '', '2026-01-24T23:34:06.000Z', '2026-01-24T23:34:06.000Z', '2026-01-25T02:26:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Amanda zahdi pessuti Turossi "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('679b5b23-6de4-409b-9c37-8d3cbf0f644b', '376c6da1-abf3-4f11-867b-61dd3844d294', '{"sub":"376c6da1-abf3-4f11-867b-61dd3844d294","email":"turossizah@gmail.com","email_verified":true}', 'email', '376c6da1-abf3-4f11-867b-61dd3844d294', '2026-01-24T23:34:06.000Z', '2026-01-25T02:26:29.000Z', '2026-01-25T02:26:30.000Z');
UPDATE public.profiles SET name = 'Amanda zahdi pessuti Turossi ', cpf = '08920229902', phone = '41997473317', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '376c6da1-abf3-4f11-867b-61dd3844d294';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '376c6da1-abf3-4f11-867b-61dd3844d294';

-- PATRICIA SANTOS ANTAO DA SILVA (patriciaas.antao@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e2eb01b8-9dab-460b-b483-9761105355a9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patriciaas.antao@gmail.com', '', '2026-01-24T23:34:19.000Z', '2026-01-24T23:34:19.000Z', '2026-01-24T23:35:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"PATRICIA SANTOS ANTAO DA SILVA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('aa6bb2c2-ce3c-4d15-8d92-718d85c29d45', 'e2eb01b8-9dab-460b-b483-9761105355a9', '{"sub":"e2eb01b8-9dab-460b-b483-9761105355a9","email":"patriciaas.antao@gmail.com","email_verified":true}', 'email', 'e2eb01b8-9dab-460b-b483-9761105355a9', '2026-01-24T23:34:19.000Z', '2026-01-24T23:35:08.000Z', '2026-01-24T23:35:08.000Z');
UPDATE public.profiles SET name = 'PATRICIA SANTOS ANTAO DA SILVA', cpf = '18299987814', phone = '11996679548', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'e2eb01b8-9dab-460b-b483-9761105355a9';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'e2eb01b8-9dab-460b-b483-9761105355a9';

-- ROSELI ROSENDO LIMA DE BENEDITO (rosellirozendo@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a526fdc7-3993-4e4f-959a-cd3ab73cf86b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rosellirozendo@gmail.com', '', '2026-01-24T23:34:19.000Z', '2026-01-24T23:34:19.000Z', '2026-01-24T23:34:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ROSELI ROSENDO LIMA DE BENEDITO"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('26ca8124-9abe-40ff-ac0a-e35faa956ec9', 'a526fdc7-3993-4e4f-959a-cd3ab73cf86b', '{"sub":"a526fdc7-3993-4e4f-959a-cd3ab73cf86b","email":"rosellirozendo@gmail.com","email_verified":true}', 'email', 'a526fdc7-3993-4e4f-959a-cd3ab73cf86b', '2026-01-24T23:34:19.000Z', '2026-01-24T23:34:23.000Z', '2026-01-24T23:34:23.000Z');
UPDATE public.profiles SET name = 'ROSELI ROSENDO LIMA DE BENEDITO', cpf = '18644567870', phone = '16991129375', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a526fdc7-3993-4e4f-959a-cd3ab73cf86b';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a526fdc7-3993-4e4f-959a-cd3ab73cf86b';

-- Juliane cristina gurgel vieira  (juliane.vieira@claro.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('06b0ce80-678f-465a-b895-acf86e9ad6d7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'juliane.vieira@claro.com.br', '', '2026-01-24T23:34:24.000Z', '2026-01-24T23:34:24.000Z', '2026-01-24T23:35:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Juliane cristina gurgel vieira "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('79a4ad79-a407-4173-a22a-11095d0f562b', '06b0ce80-678f-465a-b895-acf86e9ad6d7', '{"sub":"06b0ce80-678f-465a-b895-acf86e9ad6d7","email":"juliane.vieira@claro.com.br","email_verified":true}', 'email', '06b0ce80-678f-465a-b895-acf86e9ad6d7', '2026-01-24T23:34:24.000Z', '2026-01-24T23:35:57.000Z', '2026-01-24T23:35:58.000Z');
UPDATE public.profiles SET name = 'Juliane cristina gurgel vieira ', cpf = '34452232892', phone = '15991284181', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '06b0ce80-678f-465a-b895-acf86e9ad6d7';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '06b0ce80-678f-465a-b895-acf86e9ad6d7';

-- Mariana Ribeiro (mariribeiro14071982@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fe5ce9ad-872d-4238-9216-f3cacf392f26', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mariribeiro14071982@gmail.com', '', '2026-01-24T23:34:27.000Z', '2026-01-24T23:34:27.000Z', '2026-01-24T23:34:44.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Mariana Ribeiro"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('440e7c2e-aac7-4247-84bf-3e395cb92764', 'fe5ce9ad-872d-4238-9216-f3cacf392f26', '{"sub":"fe5ce9ad-872d-4238-9216-f3cacf392f26","email":"mariribeiro14071982@gmail.com","email_verified":true}', 'email', 'fe5ce9ad-872d-4238-9216-f3cacf392f26', '2026-01-24T23:34:27.000Z', '2026-01-24T23:34:44.000Z', '2026-01-24T23:34:44.000Z');
UPDATE public.profiles SET name = 'Mariana Ribeiro', cpf = '29116253825', phone = '16991280437', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'fe5ce9ad-872d-4238-9216-f3cacf392f26';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'fe5ce9ad-872d-4238-9216-f3cacf392f26';

-- Denilson jose de lima (dennilsonjl@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4f7f97f7-d841-4b3a-b43b-d1dd4abfbd59', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dennilsonjl@gmail.com', '', '2026-01-24T23:34:27.000Z', '2026-01-24T23:34:27.000Z', '2026-01-25T22:46:50.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Denilson jose de lima"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f50c7968-cc46-4ff5-9722-917cba9ba802', '4f7f97f7-d841-4b3a-b43b-d1dd4abfbd59', '{"sub":"4f7f97f7-d841-4b3a-b43b-d1dd4abfbd59","email":"dennilsonjl@gmail.com","email_verified":true}', 'email', '4f7f97f7-d841-4b3a-b43b-d1dd4abfbd59', '2026-01-24T23:34:27.000Z', '2026-01-25T22:46:50.000Z', '2026-01-25T22:46:51.000Z');
UPDATE public.profiles SET name = 'Denilson jose de lima', cpf = '48415480415', phone = '81999090744', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '4f7f97f7-d841-4b3a-b43b-d1dd4abfbd59';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '4f7f97f7-d841-4b3a-b43b-d1dd4abfbd59';

-- Liliane Barbosa da Silva (liliane.soberana@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a104307e-e862-419a-a17f-5055b1b2c1ee', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'liliane.soberana@gmail.com', '', '2026-01-24T23:34:36.000Z', '2026-01-24T23:34:36.000Z', '2026-02-01T19:49:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Liliane Barbosa da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ba0e528e-3d42-4e69-b76f-1d0c1573f5fe', 'a104307e-e862-419a-a17f-5055b1b2c1ee', '{"sub":"a104307e-e862-419a-a17f-5055b1b2c1ee","email":"liliane.soberana@gmail.com","email_verified":true}', 'email', 'a104307e-e862-419a-a17f-5055b1b2c1ee', '2026-01-24T23:34:36.000Z', '2026-02-01T19:49:02.000Z', '2026-02-01T19:49:01.000Z');
UPDATE public.profiles SET name = 'Liliane Barbosa da Silva', cpf = '25917562873', phone = '11957006407', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a104307e-e862-419a-a17f-5055b1b2c1ee';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a104307e-e862-419a-a17f-5055b1b2c1ee';

-- Isaac Gomes de Oliveira (isaacgomesrdf@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('694fab48-6123-4b21-aced-4aac0a21fc04', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'isaacgomesrdf@gmail.com', '', '2026-01-24T23:34:58.000Z', '2026-01-24T23:34:58.000Z', '2026-01-24T23:50:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Isaac Gomes de Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('525e26b2-454b-4d04-b5b2-b905252751f6', '694fab48-6123-4b21-aced-4aac0a21fc04', '{"sub":"694fab48-6123-4b21-aced-4aac0a21fc04","email":"isaacgomesrdf@gmail.com","email_verified":true}', 'email', '694fab48-6123-4b21-aced-4aac0a21fc04', '2026-01-24T23:34:58.000Z', '2026-01-24T23:50:18.000Z', '2026-01-24T23:50:18.000Z');
UPDATE public.profiles SET name = 'Isaac Gomes de Oliveira', cpf = '05132691692', phone = '32998137022', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '694fab48-6123-4b21-aced-4aac0a21fc04';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '694fab48-6123-4b21-aced-4aac0a21fc04';

-- Rodrigo Fernandes da Silva (RODRIGOFERNANDESCONTABILIDADE@GMAIL.COM) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a4cea920-cb75-4f16-936d-9fcef8c94c1f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'RODRIGOFERNANDESCONTABILIDADE@GMAIL.COM', '', '2026-01-24T23:35:05.000Z', '2026-01-24T23:35:05.000Z', '2026-02-02T01:14:41.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Fernandes da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('57163003-7b44-4f11-a83f-1959ed00a67b', 'a4cea920-cb75-4f16-936d-9fcef8c94c1f', '{"sub":"a4cea920-cb75-4f16-936d-9fcef8c94c1f","email":"RODRIGOFERNANDESCONTABILIDADE@GMAIL.COM","email_verified":true}', 'email', 'a4cea920-cb75-4f16-936d-9fcef8c94c1f', '2026-01-24T23:35:05.000Z', '2026-02-02T01:14:41.000Z', '2026-02-02T01:14:40.000Z');
UPDATE public.profiles SET name = 'Rodrigo Fernandes da Silva', cpf = '11837083789', phone = '62999998844', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a4cea920-cb75-4f16-936d-9fcef8c94c1f';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a4cea920-cb75-4f16-936d-9fcef8c94c1f';

-- Carlos Cerbbinno (carloscerbbinno@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('eb57a308-5e90-4e94-b6e3-34dbfbe0dfbe', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carloscerbbinno@gmail.com', '', '2026-01-24T23:35:28.000Z', '2026-01-24T23:35:28.000Z', '2026-02-03T01:19:45.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carlos Cerbbinno"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('63ff5b4f-ed31-408a-840d-59c740a827de', 'eb57a308-5e90-4e94-b6e3-34dbfbe0dfbe', '{"sub":"eb57a308-5e90-4e94-b6e3-34dbfbe0dfbe","email":"carloscerbbinno@gmail.com","email_verified":true}', 'email', 'eb57a308-5e90-4e94-b6e3-34dbfbe0dfbe', '2026-01-24T23:35:28.000Z', '2026-02-03T01:19:45.000Z', '2026-02-03T01:19:45.000Z');
UPDATE public.profiles SET name = 'Carlos Cerbbinno', cpf = '06604957837', phone = '62993969388', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'eb57a308-5e90-4e94-b6e3-34dbfbe0dfbe';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'eb57a308-5e90-4e94-b6e3-34dbfbe0dfbe';

-- ESMIRNA DA COSTA VIANNA (esmirnacv@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8694a9f6-a456-4743-a8e5-0325cbe0c542', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'esmirnacv@yahoo.com.br', '', '2026-01-24T23:35:40.000Z', '2026-01-24T23:35:40.000Z', '2026-01-25T04:55:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ESMIRNA DA COSTA VIANNA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ac75198a-ba28-4589-bc64-e3241230e855', '8694a9f6-a456-4743-a8e5-0325cbe0c542', '{"sub":"8694a9f6-a456-4743-a8e5-0325cbe0c542","email":"esmirnacv@yahoo.com.br","email_verified":true}', 'email', '8694a9f6-a456-4743-a8e5-0325cbe0c542', '2026-01-24T23:35:40.000Z', '2026-01-25T04:55:55.000Z', '2026-01-25T04:55:56.000Z');
UPDATE public.profiles SET name = 'ESMIRNA DA COSTA VIANNA', cpf = '03019723701', phone = '21997214622', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '8694a9f6-a456-4743-a8e5-0325cbe0c542';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '8694a9f6-a456-4743-a8e5-0325cbe0c542';

-- PATRICIA MARTINS DA SILVA CRUZ (phaty17@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9da08f8b-a6ab-436b-b837-7891cafe574f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'phaty17@gmail.com', '', '2026-01-24T23:35:43.000Z', '2026-01-24T23:35:43.000Z', '2026-02-02T13:19:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"PATRICIA MARTINS DA SILVA CRUZ"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c4c0be53-2da3-492c-83cc-ca84ae8a8a0e', '9da08f8b-a6ab-436b-b837-7891cafe574f', '{"sub":"9da08f8b-a6ab-436b-b837-7891cafe574f","email":"phaty17@gmail.com","email_verified":true}', 'email', '9da08f8b-a6ab-436b-b837-7891cafe574f', '2026-01-24T23:35:43.000Z', '2026-02-02T13:19:56.000Z', '2026-02-02T13:19:55.000Z');
UPDATE public.profiles SET name = 'PATRICIA MARTINS DA SILVA CRUZ', cpf = '25976858880', phone = '11999511946', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '9da08f8b-a6ab-436b-b837-7891cafe574f';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '9da08f8b-a6ab-436b-b837-7891cafe574f';

-- Marcelo Fernandes Franco (marceloffranco@glook.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6df4eb13-17a8-4b4a-b168-cd77429d502d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'marceloffranco@glook.com.br', '', '2026-01-24T23:36:16.000Z', '2026-01-24T23:36:16.000Z', '2026-01-25T00:10:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marcelo Fernandes Franco"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('67df182b-afcd-4cad-8f27-e5360fb51290', '6df4eb13-17a8-4b4a-b168-cd77429d502d', '{"sub":"6df4eb13-17a8-4b4a-b168-cd77429d502d","email":"marceloffranco@glook.com.br","email_verified":true}', 'email', '6df4eb13-17a8-4b4a-b168-cd77429d502d', '2026-01-24T23:36:16.000Z', '2026-01-25T00:10:14.000Z', '2026-01-25T00:10:14.000Z');
UPDATE public.profiles SET name = 'Marcelo Fernandes Franco', cpf = '16189357806', phone = '11986955090', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '6df4eb13-17a8-4b4a-b168-cd77429d502d';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '6df4eb13-17a8-4b4a-b168-cd77429d502d';

-- ELIO OLA RIBEIRO (ribeiroola@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5d7c9600-d6ee-48bc-b63b-81a2a87ffcbd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ribeiroola@gmail.com', '', '2026-01-24T23:36:56.000Z', '2026-01-24T23:36:56.000Z', '2026-02-03T14:30:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ELIO OLA RIBEIRO"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('249c161a-6d1f-4795-a1d6-9bfedff2a355', '5d7c9600-d6ee-48bc-b63b-81a2a87ffcbd', '{"sub":"5d7c9600-d6ee-48bc-b63b-81a2a87ffcbd","email":"ribeiroola@gmail.com","email_verified":true}', 'email', '5d7c9600-d6ee-48bc-b63b-81a2a87ffcbd', '2026-01-24T23:36:56.000Z', '2026-02-03T14:30:16.000Z', '2026-02-03T14:30:15.000Z');
UPDATE public.profiles SET name = 'ELIO OLA RIBEIRO', cpf = '07855841881', phone = '17997231288', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '5d7c9600-d6ee-48bc-b63b-81a2a87ffcbd';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '5d7c9600-d6ee-48bc-b63b-81a2a87ffcbd';

-- Larissa Almeida Silva (larissa.almeida@grupomultilaser.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('cafb6907-0135-485b-aaff-024f0a53682c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'larissa.almeida@grupomultilaser.com.br', '', '2026-01-24T23:36:59.000Z', '2026-01-24T23:36:59.000Z', '2026-01-24T23:51:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Larissa Almeida Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('62ad5f34-5c5c-4132-a44a-185d9ff5d4c5', 'cafb6907-0135-485b-aaff-024f0a53682c', '{"sub":"cafb6907-0135-485b-aaff-024f0a53682c","email":"larissa.almeida@grupomultilaser.com.br","email_verified":true}', 'email', 'cafb6907-0135-485b-aaff-024f0a53682c', '2026-01-24T23:36:59.000Z', '2026-01-24T23:51:08.000Z', '2026-01-24T23:51:09.000Z');
UPDATE public.profiles SET name = 'Larissa Almeida Silva', cpf = '12629031659', phone = '31988638110', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'cafb6907-0135-485b-aaff-024f0a53682c';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'cafb6907-0135-485b-aaff-024f0a53682c';

-- Marcela Malloy Dias  (marcela@artesacramoda.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b55d0215-1b0d-4bfd-a3a7-80690b68e8cc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'marcela@artesacramoda.com.br', '', '2026-01-24T23:37:22.000Z', '2026-01-24T23:37:22.000Z', '2026-01-25T00:06:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marcela Malloy Dias "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('767f224b-17f1-4b3e-9dbc-ba986ac77b41', 'b55d0215-1b0d-4bfd-a3a7-80690b68e8cc', '{"sub":"b55d0215-1b0d-4bfd-a3a7-80690b68e8cc","email":"marcela@artesacramoda.com.br","email_verified":true}', 'email', 'b55d0215-1b0d-4bfd-a3a7-80690b68e8cc', '2026-01-24T23:37:22.000Z', '2026-01-25T00:06:00.000Z', '2026-01-25T00:06:00.000Z');
UPDATE public.profiles SET name = 'Marcela Malloy Dias ', cpf = '04540960628', phone = '31986610031', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'b55d0215-1b0d-4bfd-a3a7-80690b68e8cc';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'b55d0215-1b0d-4bfd-a3a7-80690b68e8cc';

-- Camila de Mattos Reis  (milamreis@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('34aa768c-1c66-400a-9dfc-8651878f5ec3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'milamreis@hotmail.com', '', '2026-01-24T23:37:37.000Z', '2026-01-24T23:37:37.000Z', '2026-01-26T17:31:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Camila de Mattos Reis "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('074e8674-efcf-4063-8b0d-f5fd05426922', '34aa768c-1c66-400a-9dfc-8651878f5ec3', '{"sub":"34aa768c-1c66-400a-9dfc-8651878f5ec3","email":"milamreis@hotmail.com","email_verified":true}', 'email', '34aa768c-1c66-400a-9dfc-8651878f5ec3', '2026-01-24T23:37:37.000Z', '2026-01-26T17:31:02.000Z', '2026-01-26T17:31:03.000Z');
UPDATE public.profiles SET name = 'Camila de Mattos Reis ', cpf = '10737670606', phone = '31985738116', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '34aa768c-1c66-400a-9dfc-8651878f5ec3';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '34aa768c-1c66-400a-9dfc-8651878f5ec3';

-- Rafael Freitas (rafaelfarreb@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fa832f7b-05df-4a78-ae56-a5d4ef916561', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rafaelfarreb@gmail.com', '', '2026-01-24T23:37:39.000Z', '2026-01-24T23:37:39.000Z', '2026-01-27T02:55:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rafael Freitas"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('79c974bd-c04c-45e7-8e55-1a5d45ba67de', 'fa832f7b-05df-4a78-ae56-a5d4ef916561', '{"sub":"fa832f7b-05df-4a78-ae56-a5d4ef916561","email":"rafaelfarreb@gmail.com","email_verified":true}', 'email', 'fa832f7b-05df-4a78-ae56-a5d4ef916561', '2026-01-24T23:37:39.000Z', '2026-01-27T02:55:18.000Z', '2026-01-27T02:55:17.000Z');
UPDATE public.profiles SET name = 'Rafael Freitas', cpf = '14715003813', phone = '11981050388', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'fa832f7b-05df-4a78-ae56-a5d4ef916561';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'fa832f7b-05df-4a78-ae56-a5d4ef916561';

-- Marcos Del Nero  (marcosdelnero.apps@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('34b040b4-d3aa-4ab0-be41-06d6ee3e1fd6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'marcosdelnero.apps@gmail.com', '', '2026-01-24T23:38:49.000Z', '2026-01-24T23:38:49.000Z', '2026-01-25T20:10:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marcos Del Nero "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c0cccd60-6ce3-48e4-a754-6bf2a51e2cb8', '34b040b4-d3aa-4ab0-be41-06d6ee3e1fd6', '{"sub":"34b040b4-d3aa-4ab0-be41-06d6ee3e1fd6","email":"marcosdelnero.apps@gmail.com","email_verified":true}', 'email', '34b040b4-d3aa-4ab0-be41-06d6ee3e1fd6', '2026-01-24T23:38:49.000Z', '2026-01-25T20:10:53.000Z', '2026-01-25T20:10:54.000Z');
UPDATE public.profiles SET name = 'Marcos Del Nero ', cpf = '83655654804', phone = '11997879825', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '34b040b4-d3aa-4ab0-be41-06d6ee3e1fd6';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '34b040b4-d3aa-4ab0-be41-06d6ee3e1fd6';

-- Debora Oliveira Ramos (or-debora@outlook.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f19c82b3-81ec-4d5c-8c01-34b4e93c46ff', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'or-debora@outlook.com', '', '2026-01-24T23:46:41.000Z', '2026-01-24T23:46:41.000Z', '2026-01-25T04:07:30.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Debora Oliveira Ramos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3ebf2301-fd41-4901-ac0d-40fb370094fc', 'f19c82b3-81ec-4d5c-8c01-34b4e93c46ff', '{"sub":"f19c82b3-81ec-4d5c-8c01-34b4e93c46ff","email":"or-debora@outlook.com","email_verified":true}', 'email', 'f19c82b3-81ec-4d5c-8c01-34b4e93c46ff', '2026-01-24T23:46:41.000Z', '2026-01-25T04:07:30.000Z', '2026-01-25T04:07:30.000Z');
UPDATE public.profiles SET name = 'Debora Oliveira Ramos', cpf = '12486788697', phone = '31975031629', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'f19c82b3-81ec-4d5c-8c01-34b4e93c46ff';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'f19c82b3-81ec-4d5c-8c01-34b4e93c46ff';

-- Joao Ricardo Diniz Silva (joaoricardodinizsilva@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c2472bee-fdc3-4509-80c7-4bb1aa45bfbe', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joaoricardodinizsilva@gmail.com', '', '2026-01-25T00:05:01.000Z', '2026-01-25T00:05:01.000Z', '2026-01-25T18:45:04.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Joao Ricardo Diniz Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('384d36bb-8e70-48cf-a009-ae776a104190', 'c2472bee-fdc3-4509-80c7-4bb1aa45bfbe', '{"sub":"c2472bee-fdc3-4509-80c7-4bb1aa45bfbe","email":"joaoricardodinizsilva@gmail.com","email_verified":true}', 'email', 'c2472bee-fdc3-4509-80c7-4bb1aa45bfbe', '2026-01-25T00:05:01.000Z', '2026-01-25T18:45:04.000Z', '2026-01-25T18:45:04.000Z');
UPDATE public.profiles SET name = 'Joao Ricardo Diniz Silva', cpf = '10571687695', phone = '31991404322', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c2472bee-fdc3-4509-80c7-4bb1aa45bfbe';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c2472bee-fdc3-4509-80c7-4bb1aa45bfbe';

-- Leandro Machado (leandrotsmachado@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8f6f7bcd-147b-4f4d-b6a3-7425a2f2582c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'leandrotsmachado@gmail.com', '', '2026-01-25T00:21:37.000Z', '2026-01-25T00:21:37.000Z', '2026-01-25T00:35:46.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Leandro Machado"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('631101cf-cdc4-4502-b231-d6dcc3323654', '8f6f7bcd-147b-4f4d-b6a3-7425a2f2582c', '{"sub":"8f6f7bcd-147b-4f4d-b6a3-7425a2f2582c","email":"leandrotsmachado@gmail.com","email_verified":true}', 'email', '8f6f7bcd-147b-4f4d-b6a3-7425a2f2582c', '2026-01-25T00:21:37.000Z', '2026-01-25T00:35:46.000Z', '2026-01-25T00:35:46.000Z');
UPDATE public.profiles SET name = 'Leandro Machado', cpf = '08085178648', phone = '31986941462', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '8f6f7bcd-147b-4f4d-b6a3-7425a2f2582c';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '8f6f7bcd-147b-4f4d-b6a3-7425a2f2582c';

-- Luiza Caldeira Sena Deschamps (luiza.deschamps@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8ce98814-f707-4ddc-ba1c-ef44bd65063d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'luiza.deschamps@hotmail.com', '', '2026-01-25T00:36:42.000Z', '2026-01-25T00:36:42.000Z', '2026-01-25T00:58:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Luiza Caldeira Sena Deschamps"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9de446a0-fa6b-4dbd-a602-95ca9215bedb', '8ce98814-f707-4ddc-ba1c-ef44bd65063d', '{"sub":"8ce98814-f707-4ddc-ba1c-ef44bd65063d","email":"luiza.deschamps@hotmail.com","email_verified":true}', 'email', '8ce98814-f707-4ddc-ba1c-ef44bd65063d', '2026-01-25T00:36:42.000Z', '2026-01-25T00:58:37.000Z', '2026-01-25T00:58:37.000Z');
UPDATE public.profiles SET name = 'Luiza Caldeira Sena Deschamps', cpf = '04967325107', phone = '31992041860', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '8ce98814-f707-4ddc-ba1c-ef44bd65063d';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '8ce98814-f707-4ddc-ba1c-ef44bd65063d';

-- Brunna Soalheiro Campos  (brunnacampos01@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2e51a2a9-bdf2-4b28-a593-edcd590305be', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'brunnacampos01@hotmail.com', '', '2026-01-25T01:08:16.000Z', '2026-01-25T01:08:16.000Z', '2026-01-25T02:31:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Brunna Soalheiro Campos "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('62c80962-a3ea-4aa0-aecf-f1472e88fb61', '2e51a2a9-bdf2-4b28-a593-edcd590305be', '{"sub":"2e51a2a9-bdf2-4b28-a593-edcd590305be","email":"brunnacampos01@hotmail.com","email_verified":true}', 'email', '2e51a2a9-bdf2-4b28-a593-edcd590305be', '2026-01-25T01:08:16.000Z', '2026-01-25T02:31:23.000Z', '2026-01-25T02:31:23.000Z');
UPDATE public.profiles SET name = 'Brunna Soalheiro Campos ', cpf = '11494952602', phone = '31998445927', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '2e51a2a9-bdf2-4b28-a593-edcd590305be';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '2e51a2a9-bdf2-4b28-a593-edcd590305be';

-- luciano bueno francsco (buenocurador@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a6a3724e-6c3c-4019-be6f-034e7a9b5589', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'buenocurador@gmail.com', '', '2026-01-25T02:57:40.000Z', '2026-01-25T02:57:40.000Z', '2026-01-27T05:11:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"luciano bueno francsco"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fcb8e32b-fe40-4909-bae7-fa6113293a24', 'a6a3724e-6c3c-4019-be6f-034e7a9b5589', '{"sub":"a6a3724e-6c3c-4019-be6f-034e7a9b5589","email":"buenocurador@gmail.com","email_verified":true}', 'email', 'a6a3724e-6c3c-4019-be6f-034e7a9b5589', '2026-01-25T02:57:40.000Z', '2026-01-27T05:11:56.000Z', '2026-01-27T05:11:55.000Z');
UPDATE public.profiles SET name = 'luciano bueno francsco', cpf = '10975494880', phone = '12981471260', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a6a3724e-6c3c-4019-be6f-034e7a9b5589';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'a6a3724e-6c3c-4019-be6f-034e7a9b5589';

-- João Vicente Ribeiro Ferreira (joaovicenterf@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('84b3666a-551e-44e0-bac5-dce969dc2e51', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joaovicenterf@gmail.com', '', '2026-01-25T14:54:29.000Z', '2026-01-25T14:54:29.000Z', '2026-01-25T23:03:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"João Vicente Ribeiro Ferreira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('648e8a48-b88c-4c10-9e33-7f3dbd967d81', '84b3666a-551e-44e0-bac5-dce969dc2e51', '{"sub":"84b3666a-551e-44e0-bac5-dce969dc2e51","email":"joaovicenterf@gmail.com","email_verified":true}', 'email', '84b3666a-551e-44e0-bac5-dce969dc2e51', '2026-01-25T14:54:29.000Z', '2026-01-25T23:03:15.000Z', '2026-01-25T23:03:16.000Z');
UPDATE public.profiles SET name = 'João Vicente Ribeiro Ferreira', cpf = '16177646808', phone = '13996126409', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '84b3666a-551e-44e0-bac5-dce969dc2e51';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '84b3666a-551e-44e0-bac5-dce969dc2e51';

-- Izabela Dutra (izabela.sdutra@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3bd54002-cc52-4b7e-a529-89bb1d4493cf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'izabela.sdutra@gmail.com', '', '2026-01-25T15:17:39.000Z', '2026-01-25T15:17:39.000Z', '2026-01-25T15:24:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Izabela Dutra"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f7ba1df2-fae5-44bc-81bc-67a5d8217f10', '3bd54002-cc52-4b7e-a529-89bb1d4493cf', '{"sub":"3bd54002-cc52-4b7e-a529-89bb1d4493cf","email":"izabela.sdutra@gmail.com","email_verified":true}', 'email', '3bd54002-cc52-4b7e-a529-89bb1d4493cf', '2026-01-25T15:17:39.000Z', '2026-01-25T15:24:14.000Z', '2026-01-25T15:24:14.000Z');
UPDATE public.profiles SET name = 'Izabela Dutra', cpf = '09789927681', phone = '31996264311', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3bd54002-cc52-4b7e-a529-89bb1d4493cf';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3bd54002-cc52-4b7e-a529-89bb1d4493cf';

-- Alessandra Oliveira (alessandra.cso@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9a98d7ba-0282-4607-91c7-6ef7cfcf537e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alessandra.cso@gmail.com', '', '2026-01-25T15:18:54.000Z', '2026-01-25T15:18:54.000Z', '2026-01-27T00:48:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alessandra Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fd6d4d4f-f13b-4237-85c8-ec18f77f3848', '9a98d7ba-0282-4607-91c7-6ef7cfcf537e', '{"sub":"9a98d7ba-0282-4607-91c7-6ef7cfcf537e","email":"alessandra.cso@gmail.com","email_verified":true}', 'email', '9a98d7ba-0282-4607-91c7-6ef7cfcf537e', '2026-01-25T15:18:54.000Z', '2026-01-27T00:48:07.000Z', '2026-01-27T00:48:06.000Z');
UPDATE public.profiles SET name = 'Alessandra Oliveira', cpf = '30902707817', phone = '11992048999', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '9a98d7ba-0282-4607-91c7-6ef7cfcf537e';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '9a98d7ba-0282-4607-91c7-6ef7cfcf537e';

-- Ana Paula Gibo Segeti (giboanapaula@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c7e82261-a26c-4ab9-849e-6e6c18c702f2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'giboanapaula@hotmail.com', '', '2026-01-25T15:19:00.000Z', '2026-01-25T15:19:00.000Z', '2026-01-26T14:48:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Paula Gibo Segeti"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2fc86bd6-7aca-4966-8daa-e7aedc8dd8ff', 'c7e82261-a26c-4ab9-849e-6e6c18c702f2', '{"sub":"c7e82261-a26c-4ab9-849e-6e6c18c702f2","email":"giboanapaula@hotmail.com","email_verified":true}', 'email', 'c7e82261-a26c-4ab9-849e-6e6c18c702f2', '2026-01-25T15:19:00.000Z', '2026-01-26T14:48:12.000Z', '2026-01-26T14:48:12.000Z');
UPDATE public.profiles SET name = 'Ana Paula Gibo Segeti', cpf = '22729609873', phone = '11998049980', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c7e82261-a26c-4ab9-849e-6e6c18c702f2';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c7e82261-a26c-4ab9-849e-6e6c18c702f2';

-- GLADYS SYLVIA COSTA TOLEDANO CORREIA LIMA (gladyslimabio@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bc7658f0-33ec-485b-a626-12757e23c56d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gladyslimabio@yahoo.com.br', '', '2026-01-25T15:20:04.000Z', '2026-01-25T15:20:04.000Z', '2026-01-25T19:07:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GLADYS SYLVIA COSTA TOLEDANO CORREIA LIMA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4f920420-4f9b-4322-a667-de0934be18ba', 'bc7658f0-33ec-485b-a626-12757e23c56d', '{"sub":"bc7658f0-33ec-485b-a626-12757e23c56d","email":"gladyslimabio@yahoo.com.br","email_verified":true}', 'email', 'bc7658f0-33ec-485b-a626-12757e23c56d', '2026-01-25T15:20:04.000Z', '2026-01-25T19:07:31.000Z', '2026-01-25T19:07:32.000Z');
UPDATE public.profiles SET name = 'GLADYS SYLVIA COSTA TOLEDANO CORREIA LIMA', cpf = '77520262987', phone = '12997142708', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'bc7658f0-33ec-485b-a626-12757e23c56d';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'bc7658f0-33ec-485b-a626-12757e23c56d';

-- Julieta Nogueira (julietanferreira@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d6eef8ce-703d-4753-ad96-b01104d00f44', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'julietanferreira@gmail.com', '', '2026-01-25T15:20:49.000Z', '2026-01-25T15:20:49.000Z', '2026-01-25T15:21:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Julieta Nogueira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8c3a9db7-39a5-4d77-8a86-f1c4dd914f7f', 'd6eef8ce-703d-4753-ad96-b01104d00f44', '{"sub":"d6eef8ce-703d-4753-ad96-b01104d00f44","email":"julietanferreira@gmail.com","email_verified":true}', 'email', 'd6eef8ce-703d-4753-ad96-b01104d00f44', '2026-01-25T15:20:49.000Z', '2026-01-25T15:21:02.000Z', '2026-01-25T15:21:03.000Z');
UPDATE public.profiles SET name = 'Julieta Nogueira', cpf = '07301183801', phone = '11968331442', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd6eef8ce-703d-4753-ad96-b01104d00f44';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd6eef8ce-703d-4753-ad96-b01104d00f44';

-- Marianna Rezende Costa (mariannarezende@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('79812f83-0984-4dc2-b502-36f544dd47f7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mariannarezende@gmail.com', '', '2026-01-25T15:21:38.000Z', '2026-01-25T15:21:38.000Z', '2026-01-25T23:27:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marianna Rezende Costa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4d9296b3-da0c-4f17-bbdb-f1ddb24aff3e', '79812f83-0984-4dc2-b502-36f544dd47f7', '{"sub":"79812f83-0984-4dc2-b502-36f544dd47f7","email":"mariannarezende@gmail.com","email_verified":true}', 'email', '79812f83-0984-4dc2-b502-36f544dd47f7', '2026-01-25T15:21:38.000Z', '2026-01-25T23:27:19.000Z', '2026-01-25T23:27:20.000Z');
UPDATE public.profiles SET name = 'Marianna Rezende Costa', cpf = '04973858641', phone = '64992233242', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '79812f83-0984-4dc2-b502-36f544dd47f7';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '79812f83-0984-4dc2-b502-36f544dd47f7';

-- Michelle Aline Pereira do Vale Sanros (mialine_vale@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6939a06b-ac3a-494c-b5a5-5b42ee0ea65c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mialine_vale@yahoo.com.br', '', '2026-01-25T15:21:55.000Z', '2026-01-25T15:21:55.000Z', '2026-01-25T20:10:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Michelle Aline Pereira do Vale Sanros"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5446a787-db1d-48e1-9d13-402a10053c00', '6939a06b-ac3a-494c-b5a5-5b42ee0ea65c', '{"sub":"6939a06b-ac3a-494c-b5a5-5b42ee0ea65c","email":"mialine_vale@yahoo.com.br","email_verified":true}', 'email', '6939a06b-ac3a-494c-b5a5-5b42ee0ea65c', '2026-01-25T15:21:55.000Z', '2026-01-25T20:10:06.000Z', '2026-01-25T20:10:07.000Z');
UPDATE public.profiles SET name = 'Michelle Aline Pereira do Vale Sanros', cpf = '07948858610', phone = '31993070320', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '6939a06b-ac3a-494c-b5a5-5b42ee0ea65c';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '6939a06b-ac3a-494c-b5a5-5b42ee0ea65c';

-- EDMILSON ROSSI (edmilsonrossi@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('73cea33e-fc75-4a83-adf8-cf8414211deb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'edmilsonrossi@gmail.com', '', '2026-01-25T15:22:19.000Z', '2026-01-25T15:22:19.000Z', '2026-01-25T17:44:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"EDMILSON ROSSI"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('bd5a5b3c-678b-4328-87fa-c36bb9a572f3', '73cea33e-fc75-4a83-adf8-cf8414211deb', '{"sub":"73cea33e-fc75-4a83-adf8-cf8414211deb","email":"edmilsonrossi@gmail.com","email_verified":true}', 'email', '73cea33e-fc75-4a83-adf8-cf8414211deb', '2026-01-25T15:22:19.000Z', '2026-01-25T17:44:49.000Z', '2026-01-25T17:44:50.000Z');
UPDATE public.profiles SET name = 'EDMILSON ROSSI', cpf = '28750504860', phone = '19993095474', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '73cea33e-fc75-4a83-adf8-cf8414211deb';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '73cea33e-fc75-4a83-adf8-cf8414211deb';

-- Pedro Márcio Pinto de Oliveira (profpedromarcio@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2aa8a601-5cf0-4aaa-a507-f8b55de62cf3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'profpedromarcio@hotmail.com', '', '2026-01-25T15:22:28.000Z', '2026-01-25T15:22:28.000Z', '2026-01-25T16:14:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Pedro Márcio Pinto de Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('29b93ddb-8fa3-41f6-9b48-0096383c221f', '2aa8a601-5cf0-4aaa-a507-f8b55de62cf3', '{"sub":"2aa8a601-5cf0-4aaa-a507-f8b55de62cf3","email":"profpedromarcio@hotmail.com","email_verified":true}', 'email', '2aa8a601-5cf0-4aaa-a507-f8b55de62cf3', '2026-01-25T15:22:28.000Z', '2026-01-25T16:14:08.000Z', '2026-01-25T16:14:09.000Z');
UPDATE public.profiles SET name = 'Pedro Márcio Pinto de Oliveira', cpf = '03216503526', phone = '75991104818', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '2aa8a601-5cf0-4aaa-a507-f8b55de62cf3';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '2aa8a601-5cf0-4aaa-a507-f8b55de62cf3';

-- HERON GUATIELLO (heronguatiello@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8e441f29-fa22-4386-812a-27a9734cddc2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'heronguatiello@gmail.com', '', '2026-01-25T15:28:29.000Z', '2026-01-25T15:28:29.000Z', '2026-02-05T01:33:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"HERON GUATIELLO"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0ae78b57-e384-4f76-94e3-adc2dfd973cf', '8e441f29-fa22-4386-812a-27a9734cddc2', '{"sub":"8e441f29-fa22-4386-812a-27a9734cddc2","email":"heronguatiello@gmail.com","email_verified":true}', 'email', '8e441f29-fa22-4386-812a-27a9734cddc2', '2026-01-25T15:28:29.000Z', '2026-02-05T01:33:36.000Z', '2026-02-05T01:33:36.000Z');
UPDATE public.profiles SET name = 'HERON GUATIELLO', cpf = '72749911753', phone = '21971481180', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '8e441f29-fa22-4386-812a-27a9734cddc2';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '8e441f29-fa22-4386-812a-27a9734cddc2';

-- Alexsandra Matos Teste (alexsandra@dnia.ai) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('faf7c808-eca6-4faf-a64e-6ee1954b714d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alexsandra@dnia.ai', '', '2026-01-25T15:30:30.000Z', '2026-01-25T15:30:30.000Z', '2026-01-25T15:34:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alexsandra Matos Teste"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('963374e5-f47f-4b57-bf1a-67dab4a54e57', 'faf7c808-eca6-4faf-a64e-6ee1954b714d', '{"sub":"faf7c808-eca6-4faf-a64e-6ee1954b714d","email":"alexsandra@dnia.ai","email_verified":true}', 'email', 'faf7c808-eca6-4faf-a64e-6ee1954b714d', '2026-01-25T15:30:30.000Z', '2026-01-25T15:34:35.000Z', '2026-01-25T15:34:35.000Z');
UPDATE public.profiles SET name = 'Alexsandra Matos Teste', cpf = '12657408605', phone = '31991111739', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'faf7c808-eca6-4faf-a64e-6ee1954b714d';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'faf7c808-eca6-4faf-a64e-6ee1954b714d';

-- Rodrigo (rodrigoferreira077@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('21e9e85e-6ba6-419d-b4c6-682c50cfc542', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rodrigoferreira077@gmail.com', '', '2026-01-25T15:31:04.000Z', '2026-01-25T15:31:04.000Z', '2026-01-25T19:11:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('be9d5d0a-5dce-4892-8d36-278e15c3ae1f', '21e9e85e-6ba6-419d-b4c6-682c50cfc542', '{"sub":"21e9e85e-6ba6-419d-b4c6-682c50cfc542","email":"rodrigoferreira077@gmail.com","email_verified":true}', 'email', '21e9e85e-6ba6-419d-b4c6-682c50cfc542', '2026-01-25T15:31:04.000Z', '2026-01-25T19:11:29.000Z', '2026-01-25T19:11:30.000Z');
UPDATE public.profiles SET name = 'Rodrigo', cpf = '01855584700', phone = '21988850178', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '21e9e85e-6ba6-419d-b4c6-682c50cfc542';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '21e9e85e-6ba6-419d-b4c6-682c50cfc542';

-- luiz nichele (lanich2014@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('460f9a24-f7b4-4ea1-a2de-bced0399f6a4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lanich2014@gmail.com', '', '2026-01-25T15:32:07.000Z', '2026-01-25T15:32:07.000Z', '2026-01-26T14:47:39.000Z', '{"provider":"email","providers":["email"]}', '{"name":"luiz nichele"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7283bf8e-99bd-42c1-9f22-721d46717c7f', '460f9a24-f7b4-4ea1-a2de-bced0399f6a4', '{"sub":"460f9a24-f7b4-4ea1-a2de-bced0399f6a4","email":"lanich2014@gmail.com","email_verified":true}', 'email', '460f9a24-f7b4-4ea1-a2de-bced0399f6a4', '2026-01-25T15:32:07.000Z', '2026-01-26T14:47:39.000Z', '2026-01-26T14:47:39.000Z');
UPDATE public.profiles SET name = 'luiz nichele', cpf = '53597745920', phone = '41999962535', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '460f9a24-f7b4-4ea1-a2de-bced0399f6a4';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '460f9a24-f7b4-4ea1-a2de-bced0399f6a4';

-- Heitor Francisco Costa Xavier (heitorfrancisco2005@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1698bd08-75d2-4767-a7a7-cc7282ff3e8e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'heitorfrancisco2005@hotmail.com', '', '2026-01-25T15:32:16.000Z', '2026-01-25T15:32:16.000Z', '2026-01-25T15:38:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Heitor Francisco Costa Xavier"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1770fce4-ebdc-4607-b040-b9a97d35ceea', '1698bd08-75d2-4767-a7a7-cc7282ff3e8e', '{"sub":"1698bd08-75d2-4767-a7a7-cc7282ff3e8e","email":"heitorfrancisco2005@hotmail.com","email_verified":true}', 'email', '1698bd08-75d2-4767-a7a7-cc7282ff3e8e', '2026-01-25T15:32:16.000Z', '2026-01-25T15:38:21.000Z', '2026-01-25T15:38:21.000Z');
UPDATE public.profiles SET name = 'Heitor Francisco Costa Xavier', cpf = '03138920160', phone = '31991666057', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '1698bd08-75d2-4767-a7a7-cc7282ff3e8e';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '1698bd08-75d2-4767-a7a7-cc7282ff3e8e';

-- Ketlen Machado (ketlenmac@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('73a38d43-ad79-42b0-8f6e-745f20ffa210', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ketlenmac@gmail.com', '', '2026-01-25T15:34:34.000Z', '2026-01-25T15:34:34.000Z', '2026-01-26T16:36:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ketlen Machado"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1658f73d-68ef-4d7e-a3e3-fc34e5fba57f', '73a38d43-ad79-42b0-8f6e-745f20ffa210', '{"sub":"73a38d43-ad79-42b0-8f6e-745f20ffa210","email":"ketlenmac@gmail.com","email_verified":true}', 'email', '73a38d43-ad79-42b0-8f6e-745f20ffa210', '2026-01-25T15:34:34.000Z', '2026-01-26T16:36:58.000Z', '2026-01-26T16:36:58.000Z');
UPDATE public.profiles SET name = 'Ketlen Machado', cpf = '39998206839', phone = '47992506634', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '73a38d43-ad79-42b0-8f6e-745f20ffa210';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '73a38d43-ad79-42b0-8f6e-745f20ffa210';

-- Marcos Cesar Rodrigues de Oliveira (ttjpopo@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7544aaf5-7a63-43e9-be3d-b10f4d2f80ec', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ttjpopo@gmail.com', '', '2026-01-25T15:38:35.000Z', '2026-01-25T15:38:35.000Z', '2026-01-25T15:39:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marcos Cesar Rodrigues de Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('717997f2-b944-470f-84ed-73abc496eb3d', '7544aaf5-7a63-43e9-be3d-b10f4d2f80ec', '{"sub":"7544aaf5-7a63-43e9-be3d-b10f4d2f80ec","email":"ttjpopo@gmail.com","email_verified":true}', 'email', '7544aaf5-7a63-43e9-be3d-b10f4d2f80ec', '2026-01-25T15:38:35.000Z', '2026-01-25T15:39:10.000Z', '2026-01-25T15:39:10.000Z');
UPDATE public.profiles SET name = 'Marcos Cesar Rodrigues de Oliveira', cpf = '03231596807', phone = '19988089880', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '7544aaf5-7a63-43e9-be3d-b10f4d2f80ec';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '7544aaf5-7a63-43e9-be3d-b10f4d2f80ec';

-- Alaide  (Alaideoliveiralongo@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f3329685-3219-4cac-b709-9e5917551c04', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'Alaideoliveiralongo@hotmail.com', '', '2026-01-25T15:43:37.000Z', '2026-01-25T15:43:37.000Z', '2026-01-25T15:46:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alaide "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d25e0f30-8d9f-46de-a2c3-e4e0d8a93645', 'f3329685-3219-4cac-b709-9e5917551c04', '{"sub":"f3329685-3219-4cac-b709-9e5917551c04","email":"Alaideoliveiralongo@hotmail.com","email_verified":true}', 'email', 'f3329685-3219-4cac-b709-9e5917551c04', '2026-01-25T15:43:37.000Z', '2026-01-25T15:46:08.000Z', '2026-01-25T15:46:08.000Z');
UPDATE public.profiles SET name = 'Alaide ', cpf = '14583328885', phone = '14996468503', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'f3329685-3219-4cac-b709-9e5917551c04';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'f3329685-3219-4cac-b709-9e5917551c04';

-- Barbara Benvenu (barbarabenvenu@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('052eeb8c-9678-469f-ac39-ee300deb70e1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'barbarabenvenu@gmail.com', '', '2026-01-25T15:49:05.000Z', '2026-01-25T15:49:05.000Z', '2026-01-25T16:20:34.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Barbara Benvenu"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('74305b8c-30b0-407a-851f-0012f81e939b', '052eeb8c-9678-469f-ac39-ee300deb70e1', '{"sub":"052eeb8c-9678-469f-ac39-ee300deb70e1","email":"barbarabenvenu@gmail.com","email_verified":true}', 'email', '052eeb8c-9678-469f-ac39-ee300deb70e1', '2026-01-25T15:49:05.000Z', '2026-01-25T16:20:34.000Z', '2026-01-25T16:20:35.000Z');
UPDATE public.profiles SET name = 'Barbara Benvenu', cpf = '37315958851', phone = '19989847997', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '052eeb8c-9678-469f-ac39-ee300deb70e1';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '052eeb8c-9678-469f-ac39-ee300deb70e1';

-- Jane Rodrigues (janecpq76@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9d7c838e-1a44-4f4d-8198-94cff962abf5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'janecpq76@gmail.com', '', '2026-01-25T16:17:56.000Z', '2026-01-25T16:17:56.000Z', '2026-02-01T03:29:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Jane Rodrigues"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a9970c06-6016-4e2f-a8c3-a590723a612d', '9d7c838e-1a44-4f4d-8198-94cff962abf5', '{"sub":"9d7c838e-1a44-4f4d-8198-94cff962abf5","email":"janecpq76@gmail.com","email_verified":true}', 'email', '9d7c838e-1a44-4f4d-8198-94cff962abf5', '2026-01-25T16:17:56.000Z', '2026-02-01T03:29:36.000Z', '2026-02-01T03:29:36.000Z');
UPDATE public.profiles SET name = 'Jane Rodrigues', cpf = '17891669856', phone = '19981678639', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '9d7c838e-1a44-4f4d-8198-94cff962abf5';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '9d7c838e-1a44-4f4d-8198-94cff962abf5';

-- Layla Nathânia Teixeira (lalla.nathania@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d23fcaaa-5d12-4821-9cd9-825a0917518c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lalla.nathania@gmail.com', '', '2026-01-25T16:41:40.000Z', '2026-01-25T16:41:40.000Z', '2026-01-25T16:44:34.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Layla Nathânia Teixeira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b3f21e1a-0685-44eb-853e-94a0a11c772c', 'd23fcaaa-5d12-4821-9cd9-825a0917518c', '{"sub":"d23fcaaa-5d12-4821-9cd9-825a0917518c","email":"lalla.nathania@gmail.com","email_verified":true}', 'email', 'd23fcaaa-5d12-4821-9cd9-825a0917518c', '2026-01-25T16:41:40.000Z', '2026-01-25T16:44:34.000Z', '2026-01-25T16:44:35.000Z');
UPDATE public.profiles SET name = 'Layla Nathânia Teixeira', cpf = '08409832631', phone = '38999072632', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd23fcaaa-5d12-4821-9cd9-825a0917518c';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd23fcaaa-5d12-4821-9cd9-825a0917518c';

-- Ana Carla  (mendesana39@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('80e4b312-8e24-4e18-9899-64562262fb83', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mendesana39@gmail.com', '', '2026-01-25T16:42:28.000Z', '2026-01-25T16:42:28.000Z', '2026-01-25T16:47:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Carla "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a069538f-40aa-474b-8f28-6cf2f120b246', '80e4b312-8e24-4e18-9899-64562262fb83', '{"sub":"80e4b312-8e24-4e18-9899-64562262fb83","email":"mendesana39@gmail.com","email_verified":true}', 'email', '80e4b312-8e24-4e18-9899-64562262fb83', '2026-01-25T16:42:28.000Z', '2026-01-25T16:47:36.000Z', '2026-01-25T16:47:36.000Z');
UPDATE public.profiles SET name = 'Ana Carla ', cpf = '09300550370', phone = '81986519653', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '80e4b312-8e24-4e18-9899-64562262fb83';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '80e4b312-8e24-4e18-9899-64562262fb83';

-- Julia Bertello (bertellojulia@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e01b3564-fec0-434c-8a08-c6553eb67d45', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'bertellojulia@gmail.com', '', '2026-01-25T16:46:58.000Z', '2026-01-25T16:46:58.000Z', '2026-01-25T17:18:44.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Julia Bertello"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3e8e5be1-8fcf-4889-9a92-4ff887c37a9d', 'e01b3564-fec0-434c-8a08-c6553eb67d45', '{"sub":"e01b3564-fec0-434c-8a08-c6553eb67d45","email":"bertellojulia@gmail.com","email_verified":true}', 'email', 'e01b3564-fec0-434c-8a08-c6553eb67d45', '2026-01-25T16:46:58.000Z', '2026-01-25T17:18:44.000Z', '2026-01-25T17:18:44.000Z');
UPDATE public.profiles SET name = 'Julia Bertello', cpf = '08609618935', phone = '43998657038', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'e01b3564-fec0-434c-8a08-c6553eb67d45';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'e01b3564-fec0-434c-8a08-c6553eb67d45';

-- Carolina Malloy Dias (carolina@artesacramoda.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f0c5ffc9-7946-4694-b35a-a3ef3fdf19db', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carolina@artesacramoda.com.br', '', '2026-01-25T17:50:18.000Z', '2026-01-25T17:50:18.000Z', '2026-01-25T19:50:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carolina Malloy Dias"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ec75fe17-1981-4fd3-9c10-cb75854f9eff', 'f0c5ffc9-7946-4694-b35a-a3ef3fdf19db', '{"sub":"f0c5ffc9-7946-4694-b35a-a3ef3fdf19db","email":"carolina@artesacramoda.com.br","email_verified":true}', 'email', 'f0c5ffc9-7946-4694-b35a-a3ef3fdf19db', '2026-01-25T17:50:18.000Z', '2026-01-25T19:50:17.000Z', '2026-01-25T19:50:17.000Z');
UPDATE public.profiles SET name = 'Carolina Malloy Dias', cpf = '04517965600', phone = '31988029716', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'f0c5ffc9-7946-4694-b35a-a3ef3fdf19db';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'f0c5ffc9-7946-4694-b35a-a3ef3fdf19db';

-- Ivane Ferreira da Silva (reporterivane@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c05d39d0-fd53-40bc-9076-b33a4c50ba67', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'reporterivane@yahoo.com.br', '', '2026-01-25T17:59:22.000Z', '2026-01-25T17:59:22.000Z', '2026-01-25T22:52:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ivane Ferreira da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cf539874-8133-4ab6-ae6b-e64cbfd440be', 'c05d39d0-fd53-40bc-9076-b33a4c50ba67', '{"sub":"c05d39d0-fd53-40bc-9076-b33a4c50ba67","email":"reporterivane@yahoo.com.br","email_verified":true}', 'email', 'c05d39d0-fd53-40bc-9076-b33a4c50ba67', '2026-01-25T17:59:22.000Z', '2026-01-25T22:52:36.000Z', '2026-01-25T22:52:37.000Z');
UPDATE public.profiles SET name = 'Ivane Ferreira da Silva', cpf = '05603464682', phone = '3798451516', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c05d39d0-fd53-40bc-9076-b33a4c50ba67';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c05d39d0-fd53-40bc-9076-b33a4c50ba67';

-- Rosr martins (rmartins.2306@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4a901241-14a5-4e66-8165-9e20785f06df', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rmartins.2306@gmail.com', '', '2026-01-25T18:42:21.000Z', '2026-01-25T18:42:21.000Z', '2026-02-01T00:26:40.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rosr martins"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f452d0fd-8a59-4044-9119-827714f9ae5e', '4a901241-14a5-4e66-8165-9e20785f06df', '{"sub":"4a901241-14a5-4e66-8165-9e20785f06df","email":"rmartins.2306@gmail.com","email_verified":true}', 'email', '4a901241-14a5-4e66-8165-9e20785f06df', '2026-01-25T18:42:21.000Z', '2026-02-01T00:26:40.000Z', '2026-02-01T00:26:41.000Z');
UPDATE public.profiles SET name = 'Rosr martins', cpf = '04417894809', phone = '11956008186', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '4a901241-14a5-4e66-8165-9e20785f06df';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '4a901241-14a5-4e66-8165-9e20785f06df';

-- MARCELA MARTINS DE OLIVEIRA (marcelalazza@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('de8fe340-5aad-4822-a667-30a2a1ac4156', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'marcelalazza@gmail.com', '', '2026-01-25T19:15:45.000Z', '2026-01-25T19:15:45.000Z', '2026-02-01T22:28:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"MARCELA MARTINS DE OLIVEIRA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3410b0f5-14bd-4069-99bd-7334ddedc7c6', 'de8fe340-5aad-4822-a667-30a2a1ac4156', '{"sub":"de8fe340-5aad-4822-a667-30a2a1ac4156","email":"marcelalazza@gmail.com","email_verified":true}', 'email', 'de8fe340-5aad-4822-a667-30a2a1ac4156', '2026-01-25T19:15:45.000Z', '2026-02-01T22:28:18.000Z', '2026-02-01T22:28:19.000Z');
UPDATE public.profiles SET name = 'MARCELA MARTINS DE OLIVEIRA', cpf = '97561924615', phone = '32988216831', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'de8fe340-5aad-4822-a667-30a2a1ac4156';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'de8fe340-5aad-4822-a667-30a2a1ac4156';

-- carla Tutschke  (carlatutschkeanalistacorporal@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('17fd8527-928b-4996-ade4-9b7f69e976f4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carlatutschkeanalistacorporal@gmail.com', '', '2026-01-25T19:51:53.000Z', '2026-01-25T19:51:53.000Z', '2026-01-25T19:52:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"carla Tutschke "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('00b3f2e2-da17-4e63-af0c-65359efc15f8', '17fd8527-928b-4996-ade4-9b7f69e976f4', '{"sub":"17fd8527-928b-4996-ade4-9b7f69e976f4","email":"carlatutschkeanalistacorporal@gmail.com","email_verified":true}', 'email', '17fd8527-928b-4996-ade4-9b7f69e976f4', '2026-01-25T19:51:53.000Z', '2026-01-25T19:52:27.000Z', '2026-01-25T19:52:27.000Z');
UPDATE public.profiles SET name = 'carla Tutschke ', cpf = '05119431992', phone = '41998667758', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '17fd8527-928b-4996-ade4-9b7f69e976f4';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '17fd8527-928b-4996-ade4-9b7f69e976f4';

-- CARLA MARIANA RODRIGUES DA SILVA (carla.mariana70@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('42585758-a17b-414c-8343-699b3550ba6b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carla.mariana70@hotmail.com', '', '2026-01-25T19:51:54.000Z', '2026-01-25T19:51:54.000Z', '2026-01-25T20:08:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"CARLA MARIANA RODRIGUES DA SILVA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('52864ab8-4b08-47f6-8951-bcc9645bb592', '42585758-a17b-414c-8343-699b3550ba6b', '{"sub":"42585758-a17b-414c-8343-699b3550ba6b","email":"carla.mariana70@hotmail.com","email_verified":true}', 'email', '42585758-a17b-414c-8343-699b3550ba6b', '2026-01-25T19:51:54.000Z', '2026-01-25T20:08:00.000Z', '2026-01-25T20:08:01.000Z');
UPDATE public.profiles SET name = 'CARLA MARIANA RODRIGUES DA SILVA', cpf = '34379452204', phone = '92994697428', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '42585758-a17b-414c-8343-699b3550ba6b';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '42585758-a17b-414c-8343-699b3550ba6b';

-- Larissa de assis germano  (assislarissa2023@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7aa11085-6b5e-45c4-ad01-a29770d0db1e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'assislarissa2023@gmail.com', '', '2026-01-25T20:03:08.000Z', '2026-01-25T20:03:08.000Z', '2026-01-25T20:15:34.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Larissa de assis germano "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6db647db-1dff-46b1-8ed3-b1835b182663', '7aa11085-6b5e-45c4-ad01-a29770d0db1e', '{"sub":"7aa11085-6b5e-45c4-ad01-a29770d0db1e","email":"assislarissa2023@gmail.com","email_verified":true}', 'email', '7aa11085-6b5e-45c4-ad01-a29770d0db1e', '2026-01-25T20:03:08.000Z', '2026-01-25T20:15:34.000Z', '2026-01-25T20:15:35.000Z');
UPDATE public.profiles SET name = 'Larissa de assis germano ', cpf = '12960652606', phone = '31982310103', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '7aa11085-6b5e-45c4-ad01-a29770d0db1e';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '7aa11085-6b5e-45c4-ad01-a29770d0db1e';

-- Paola Cristina Leal Colli (paollacolli@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1af2e0bc-7cbd-4c24-a129-32e18bd20ad1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'paollacolli@gmail.com', '', '2026-01-25T20:03:32.000Z', '2026-01-25T20:03:32.000Z', '2026-01-25T20:49:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Paola Cristina Leal Colli"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f78bc48e-d9a8-42a6-a80e-5bea98848d9f', '1af2e0bc-7cbd-4c24-a129-32e18bd20ad1', '{"sub":"1af2e0bc-7cbd-4c24-a129-32e18bd20ad1","email":"paollacolli@gmail.com","email_verified":true}', 'email', '1af2e0bc-7cbd-4c24-a129-32e18bd20ad1', '2026-01-25T20:03:32.000Z', '2026-01-25T20:49:47.000Z', '2026-01-25T20:49:47.000Z');
UPDATE public.profiles SET name = 'Paola Cristina Leal Colli', cpf = '08048011930', phone = '41995483462', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '1af2e0bc-7cbd-4c24-a129-32e18bd20ad1';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '1af2e0bc-7cbd-4c24-a129-32e18bd20ad1';

-- Edson Gabriel dos Santos (santogabriel13@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bfff5e2a-7c01-4833-8602-63a0786b1a81', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'santogabriel13@gmail.com', '', '2026-01-25T20:52:22.000Z', '2026-01-25T20:52:22.000Z', '2026-02-05T04:21:43.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Edson Gabriel dos Santos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('58f65937-3ef0-4208-bc4c-65fc28517d7c', 'bfff5e2a-7c01-4833-8602-63a0786b1a81', '{"sub":"bfff5e2a-7c01-4833-8602-63a0786b1a81","email":"santogabriel13@gmail.com","email_verified":true}', 'email', 'bfff5e2a-7c01-4833-8602-63a0786b1a81', '2026-01-25T20:52:22.000Z', '2026-02-05T04:21:43.000Z', '2026-02-05T04:21:43.000Z');
UPDATE public.profiles SET name = 'Edson Gabriel dos Santos', cpf = '61536296953', phone = '12997717152', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'bfff5e2a-7c01-4833-8602-63a0786b1a81';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'bfff5e2a-7c01-4833-8602-63a0786b1a81';

-- Maria Sueli Ribeiro da Silva  (mssuribeiro@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fe5b87ac-a9b6-4b31-8f34-4f64fdcd3472', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mssuribeiro@yahoo.com.br', '', '2026-01-25T21:29:16.000Z', '2026-01-25T21:29:16.000Z', '2026-01-25T21:49:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maria Sueli Ribeiro da Silva "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9f2649ca-3fb1-4fca-b852-670d6b024081', 'fe5b87ac-a9b6-4b31-8f34-4f64fdcd3472', '{"sub":"fe5b87ac-a9b6-4b31-8f34-4f64fdcd3472","email":"mssuribeiro@yahoo.com.br","email_verified":true}', 'email', 'fe5b87ac-a9b6-4b31-8f34-4f64fdcd3472', '2026-01-25T21:29:16.000Z', '2026-01-25T21:49:02.000Z', '2026-01-25T21:49:03.000Z');
UPDATE public.profiles SET name = 'Maria Sueli Ribeiro da Silva ', cpf = '13340618828', phone = '17991109538', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'fe5b87ac-a9b6-4b31-8f34-4f64fdcd3472';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'fe5b87ac-a9b6-4b31-8f34-4f64fdcd3472';

-- Viviane Noronha (vivi.noronha2009@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6b1f02fa-a53d-4aa0-b5f6-7bc6e816aabf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'vivi.noronha2009@hotmail.com', '', '2026-01-25T21:51:02.000Z', '2026-01-25T21:51:02.000Z', '2026-01-25T22:15:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Viviane Noronha"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0fb1f95d-3a7f-4f64-b826-0cdd64105633', '6b1f02fa-a53d-4aa0-b5f6-7bc6e816aabf', '{"sub":"6b1f02fa-a53d-4aa0-b5f6-7bc6e816aabf","email":"vivi.noronha2009@hotmail.com","email_verified":true}', 'email', '6b1f02fa-a53d-4aa0-b5f6-7bc6e816aabf', '2026-01-25T21:51:02.000Z', '2026-01-25T22:15:51.000Z', '2026-01-25T22:15:52.000Z');
UPDATE public.profiles SET name = 'Viviane Noronha', cpf = '09526239784', phone = '21998116822', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '6b1f02fa-a53d-4aa0-b5f6-7bc6e816aabf';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '6b1f02fa-a53d-4aa0-b5f6-7bc6e816aabf';

-- Caio França Ricciardi (caiofran746@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('51e3f54c-6154-40ef-b6c9-cf53aa1db585', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'caiofran746@gmail.com', '', '2026-01-25T22:25:26.000Z', '2026-01-25T22:25:26.000Z', '2026-01-25T22:52:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Caio França Ricciardi"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('08908b57-432f-4ee5-8b4e-281baa95c0da', '51e3f54c-6154-40ef-b6c9-cf53aa1db585', '{"sub":"51e3f54c-6154-40ef-b6c9-cf53aa1db585","email":"caiofran746@gmail.com","email_verified":true}', 'email', '51e3f54c-6154-40ef-b6c9-cf53aa1db585', '2026-01-25T22:25:26.000Z', '2026-01-25T22:52:23.000Z', '2026-01-25T22:52:23.000Z');
UPDATE public.profiles SET name = 'Caio França Ricciardi', cpf = '14903004732', phone = '21973993220', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '51e3f54c-6154-40ef-b6c9-cf53aa1db585';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '51e3f54c-6154-40ef-b6c9-cf53aa1db585';

-- Carlos Eduardo Montenegro da Silva (caredufisio@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('41110640-209b-4133-b45c-96bc716c6f66', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'caredufisio@gmail.com', '', '2026-01-25T22:26:24.000Z', '2026-01-25T22:26:24.000Z', '2026-01-25T22:36:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carlos Eduardo Montenegro da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f36c9155-14a6-4a9a-af11-fe7c96f32e51', '41110640-209b-4133-b45c-96bc716c6f66', '{"sub":"41110640-209b-4133-b45c-96bc716c6f66","email":"caredufisio@gmail.com","email_verified":true}', 'email', '41110640-209b-4133-b45c-96bc716c6f66', '2026-01-25T22:26:24.000Z', '2026-01-25T22:36:31.000Z', '2026-01-25T22:36:31.000Z');
UPDATE public.profiles SET name = 'Carlos Eduardo Montenegro da Silva', cpf = '04304839705', phone = '21988317432', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '41110640-209b-4133-b45c-96bc716c6f66';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '41110640-209b-4133-b45c-96bc716c6f66';

-- ADRIANA COELHO VIDAL (adrianavidal@flourish.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3dd19c06-0038-4ba1-ae4a-0d5119668b8d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'adrianavidal@flourish.com.br', '', '2026-01-25T22:51:57.000Z', '2026-01-25T22:51:57.000Z', '2026-01-25T23:04:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ADRIANA COELHO VIDAL"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('59c23d3c-8024-4899-8462-e08e86b8bd67', '3dd19c06-0038-4ba1-ae4a-0d5119668b8d', '{"sub":"3dd19c06-0038-4ba1-ae4a-0d5119668b8d","email":"adrianavidal@flourish.com.br","email_verified":true}', 'email', '3dd19c06-0038-4ba1-ae4a-0d5119668b8d', '2026-01-25T22:51:57.000Z', '2026-01-25T23:04:19.000Z', '2026-01-25T23:04:20.000Z');
UPDATE public.profiles SET name = 'ADRIANA COELHO VIDAL', cpf = '03517001619', phone = '31999792277', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3dd19c06-0038-4ba1-ae4a-0d5119668b8d';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3dd19c06-0038-4ba1-ae4a-0d5119668b8d';

-- ROBERTA SETRINI (setrini@uol.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1112ee24-07aa-4a39-8176-5f8209794d26', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'setrini@uol.com.br', '', '2026-01-25T22:52:34.000Z', '2026-01-25T22:52:34.000Z', '2026-01-25T23:03:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ROBERTA SETRINI"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2b426f07-5898-435d-b49e-f8b866a9bc0d', '1112ee24-07aa-4a39-8176-5f8209794d26', '{"sub":"1112ee24-07aa-4a39-8176-5f8209794d26","email":"setrini@uol.com.br","email_verified":true}', 'email', '1112ee24-07aa-4a39-8176-5f8209794d26', '2026-01-25T22:52:34.000Z', '2026-01-25T23:03:03.000Z', '2026-01-25T23:03:04.000Z');
UPDATE public.profiles SET name = 'ROBERTA SETRINI', cpf = '02808185723', phone = '5521995497707', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '1112ee24-07aa-4a39-8176-5f8209794d26';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '1112ee24-07aa-4a39-8176-5f8209794d26';

-- Maria Daniane Moraes Dantas Abicair (danianemd@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('655cf09f-8c99-45bd-b505-1b26ec3c6022', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'danianemd@yahoo.com.br', '', '2026-01-25T22:53:17.000Z', '2026-01-25T22:53:17.000Z', '2026-02-05T18:01:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maria Daniane Moraes Dantas Abicair"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ccbd6516-4942-4045-a40d-292e8f706b1d', '655cf09f-8c99-45bd-b505-1b26ec3c6022', '{"sub":"655cf09f-8c99-45bd-b505-1b26ec3c6022","email":"danianemd@yahoo.com.br","email_verified":true}', 'email', '655cf09f-8c99-45bd-b505-1b26ec3c6022', '2026-01-25T22:53:17.000Z', '2026-02-05T18:01:07.000Z', '2026-02-05T18:01:07.000Z');
UPDATE public.profiles SET name = 'Maria Daniane Moraes Dantas Abicair', cpf = '05822308619', phone = '19983217733', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '655cf09f-8c99-45bd-b505-1b26ec3c6022';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '655cf09f-8c99-45bd-b505-1b26ec3c6022';

-- Claudio Luciano Martire  (cmartire@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('57b64a16-910b-4b68-8e09-666bae9b1e3f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'cmartire@hotmail.com', '', '2026-01-25T22:53:48.000Z', '2026-01-25T22:53:48.000Z', '2026-01-26T00:09:38.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Claudio Luciano Martire "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b36a9793-13d0-4792-b3ac-eef62e15b82a', '57b64a16-910b-4b68-8e09-666bae9b1e3f', '{"sub":"57b64a16-910b-4b68-8e09-666bae9b1e3f","email":"cmartire@hotmail.com","email_verified":true}', 'email', '57b64a16-910b-4b68-8e09-666bae9b1e3f', '2026-01-25T22:53:48.000Z', '2026-01-26T00:09:38.000Z', '2026-01-26T00:09:38.000Z');
UPDATE public.profiles SET name = 'Claudio Luciano Martire ', cpf = '03346319636', phone = '31988594152', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '57b64a16-910b-4b68-8e09-666bae9b1e3f';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '57b64a16-910b-4b68-8e09-666bae9b1e3f';

-- Izabela Ferreira Loredo (izaloredo.mkt@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5b045217-45d0-42a1-ac31-6e067af8fcd5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'izaloredo.mkt@gmail.com', '', '2026-01-25T23:04:29.000Z', '2026-01-25T23:04:29.000Z', '2026-01-26T16:26:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Izabela Ferreira Loredo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ed58193b-c402-4117-85d1-b85024deab08', '5b045217-45d0-42a1-ac31-6e067af8fcd5', '{"sub":"5b045217-45d0-42a1-ac31-6e067af8fcd5","email":"izaloredo.mkt@gmail.com","email_verified":true}', 'email', '5b045217-45d0-42a1-ac31-6e067af8fcd5', '2026-01-25T23:04:29.000Z', '2026-01-26T16:26:12.000Z', '2026-01-26T16:26:13.000Z');
UPDATE public.profiles SET name = 'Izabela Ferreira Loredo', cpf = '09056759671', phone = '31992525718', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '5b045217-45d0-42a1-ac31-6e067af8fcd5';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '5b045217-45d0-42a1-ac31-6e067af8fcd5';

-- Priscila Soares  (priscilasoares02@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3c95f351-be74-4b06-8fd9-c892d2bc04ef', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'priscilasoares02@yahoo.com.br', '', '2026-01-25T23:04:49.000Z', '2026-01-25T23:04:49.000Z', '2026-01-27T17:06:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Priscila Soares "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4143dfc9-3764-472a-aebb-3369cb730476', '3c95f351-be74-4b06-8fd9-c892d2bc04ef', '{"sub":"3c95f351-be74-4b06-8fd9-c892d2bc04ef","email":"priscilasoares02@yahoo.com.br","email_verified":true}', 'email', '3c95f351-be74-4b06-8fd9-c892d2bc04ef', '2026-01-25T23:04:49.000Z', '2026-01-27T17:06:02.000Z', '2026-01-27T17:06:03.000Z');
UPDATE public.profiles SET name = 'Priscila Soares ', cpf = '30873192877', phone = '12981378555', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3c95f351-be74-4b06-8fd9-c892d2bc04ef';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '3c95f351-be74-4b06-8fd9-c892d2bc04ef';

-- Ariane Roberta Santiago Freitas (ariane.santiago0112@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c3b54dbe-65df-4c7a-a8a8-8ec2fbbe69be', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ariane.santiago0112@gmail.com', '', '2026-01-25T23:55:33.000Z', '2026-01-25T23:55:33.000Z', '2026-01-26T23:28:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ariane Roberta Santiago Freitas"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('21a97e87-69ca-4360-840e-24725597c68d', 'c3b54dbe-65df-4c7a-a8a8-8ec2fbbe69be', '{"sub":"c3b54dbe-65df-4c7a-a8a8-8ec2fbbe69be","email":"ariane.santiago0112@gmail.com","email_verified":true}', 'email', 'c3b54dbe-65df-4c7a-a8a8-8ec2fbbe69be', '2026-01-25T23:55:33.000Z', '2026-01-26T23:28:49.000Z', '2026-01-26T23:28:49.000Z');
UPDATE public.profiles SET name = 'Ariane Roberta Santiago Freitas', cpf = '40040957861', phone = '41995445221', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c3b54dbe-65df-4c7a-a8a8-8ec2fbbe69be';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'c3b54dbe-65df-4c7a-a8a8-8ec2fbbe69be';

-- Rafael Victor de Oliveira (rafael6ptc@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ce4904cc-6feb-4c57-9c78-49f9095c6126', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rafael6ptc@hotmail.com', '', '2026-01-26T01:50:37.000Z', '2026-01-26T01:50:37.000Z', '2026-01-26T01:58:05.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rafael Victor de Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c96a2c40-c915-48ae-9718-807fa217c033', 'ce4904cc-6feb-4c57-9c78-49f9095c6126', '{"sub":"ce4904cc-6feb-4c57-9c78-49f9095c6126","email":"rafael6ptc@hotmail.com","email_verified":true}', 'email', 'ce4904cc-6feb-4c57-9c78-49f9095c6126', '2026-01-26T01:50:37.000Z', '2026-01-26T01:58:05.000Z', '2026-01-26T01:58:05.000Z');
UPDATE public.profiles SET name = 'Rafael Victor de Oliveira', cpf = '10484427644', phone = '34988360256', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'ce4904cc-6feb-4c57-9c78-49f9095c6126';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'ce4904cc-6feb-4c57-9c78-49f9095c6126';

-- CARLA TUTSCHKE DA SILVA RIBEIRO (mulherrealeza01@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('27452cbd-4523-4fce-8cd4-459db97b9abf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mulherrealeza01@gmail.com', '', '2026-01-26T22:58:10.000Z', '2026-01-26T22:58:10.000Z', '2026-01-26T22:58:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"CARLA TUTSCHKE DA SILVA RIBEIRO"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3fd1ff0f-716d-492d-9f61-97a7d0483ae6', '27452cbd-4523-4fce-8cd4-459db97b9abf', '{"sub":"27452cbd-4523-4fce-8cd4-459db97b9abf","email":"mulherrealeza01@gmail.com","email_verified":true}', 'email', '27452cbd-4523-4fce-8cd4-459db97b9abf', '2026-01-26T22:58:10.000Z', '2026-01-26T22:58:21.000Z', '2026-01-26T22:58:21.000Z');
UPDATE public.profiles SET name = 'CARLA TUTSCHKE DA SILVA RIBEIRO', cpf = '05119431992', phone = '41998776658', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '27452cbd-4523-4fce-8cd4-459db97b9abf';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '27452cbd-4523-4fce-8cd4-459db97b9abf';

-- Patrícia do Carmo Rezende Tomé (patriciarezende22@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('868b19ec-50c4-4739-9fce-24cde71de86b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patriciarezende22@hotmail.com', '', '2026-01-27T17:32:12.000Z', '2026-01-27T17:32:12.000Z', '2026-01-30T20:36:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Patrícia do Carmo Rezende Tomé"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('77f13333-8055-4ac4-9eeb-9908de38d539', '868b19ec-50c4-4739-9fce-24cde71de86b', '{"sub":"868b19ec-50c4-4739-9fce-24cde71de86b","email":"patriciarezende22@hotmail.com","email_verified":true}', 'email', '868b19ec-50c4-4739-9fce-24cde71de86b', '2026-01-27T17:32:12.000Z', '2026-01-30T20:36:54.000Z', '2026-01-30T20:36:54.000Z');
UPDATE public.profiles SET name = 'Patrícia do Carmo Rezende Tomé', cpf = '07257116636', phone = '12996449509', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '868b19ec-50c4-4739-9fce-24cde71de86b';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '868b19ec-50c4-4739-9fce-24cde71de86b';

-- Anie Karenina (aniekarenina@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('489d0f0f-d2f1-46c8-ac5a-af48cd2d1b70', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'aniekarenina@gmail.com', '', '2026-01-28T20:10:14.000Z', '2026-01-28T20:10:14.000Z', '2026-01-29T20:16:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Anie Karenina"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ecf86a50-cead-482d-bd1a-1354e666afeb', '489d0f0f-d2f1-46c8-ac5a-af48cd2d1b70', '{"sub":"489d0f0f-d2f1-46c8-ac5a-af48cd2d1b70","email":"aniekarenina@gmail.com","email_verified":true}', 'email', '489d0f0f-d2f1-46c8-ac5a-af48cd2d1b70', '2026-01-28T20:10:14.000Z', '2026-01-29T20:16:09.000Z', '2026-01-29T20:16:09.000Z');
UPDATE public.profiles SET name = 'Anie Karenina', cpf = '07554595636', phone = '31984958570', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '489d0f0f-d2f1-46c8-ac5a-af48cd2d1b70';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '489d0f0f-d2f1-46c8-ac5a-af48cd2d1b70';

-- Esley Castelar Rodrigues (esleycastelar@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8f2d4051-695a-4c37-a3d7-283bf195a1fd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'esleycastelar@gmail.com', '', '2026-01-28T20:54:57.000Z', '2026-01-28T20:54:57.000Z', '2026-01-29T21:31:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Esley Castelar Rodrigues"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('69417322-b502-47b8-a114-d2dbe6e37a44', '8f2d4051-695a-4c37-a3d7-283bf195a1fd', '{"sub":"8f2d4051-695a-4c37-a3d7-283bf195a1fd","email":"esleycastelar@gmail.com","email_verified":true}', 'email', '8f2d4051-695a-4c37-a3d7-283bf195a1fd', '2026-01-28T20:54:57.000Z', '2026-01-29T21:31:02.000Z', '2026-01-29T21:31:02.000Z');
UPDATE public.profiles SET name = 'Esley Castelar Rodrigues', cpf = '04132055680', phone = '31992704326', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '14b9a7fa-b094-4638-976b-57ced6420ae9' WHERE user_id = '8f2d4051-695a-4c37-a3d7-283bf195a1fd';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '8f2d4051-695a-4c37-a3d7-283bf195a1fd';

-- FRANKY LUCIO VALERIO BARBOSA (frankybarbosa56@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1c8c5994-6fd5-448b-9b11-2b98548628e6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'frankybarbosa56@gmail.com', '', '2026-01-28T23:07:21.000Z', '2026-01-28T23:07:21.000Z', '2026-01-29T00:50:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"FRANKY LUCIO VALERIO BARBOSA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('938a3611-04d3-4d84-8340-1d9f00c55cfc', '1c8c5994-6fd5-448b-9b11-2b98548628e6', '{"sub":"1c8c5994-6fd5-448b-9b11-2b98548628e6","email":"frankybarbosa56@gmail.com","email_verified":true}', 'email', '1c8c5994-6fd5-448b-9b11-2b98548628e6', '2026-01-28T23:07:21.000Z', '2026-01-29T00:50:09.000Z', '2026-01-29T00:50:10.000Z');
UPDATE public.profiles SET name = 'FRANKY LUCIO VALERIO BARBOSA', cpf = '13111814661', phone = '31992183319', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '14b9a7fa-b094-4638-976b-57ced6420ae9' WHERE user_id = '1c8c5994-6fd5-448b-9b11-2b98548628e6';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '1c8c5994-6fd5-448b-9b11-2b98548628e6';

-- Grace Kelly dos Passos  (gracekpassos@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d06ae83e-fa21-4cfd-b131-7c8e683efdd7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gracekpassos@gmail.com', '', '2026-01-28T23:13:16.000Z', '2026-01-28T23:13:16.000Z', '2026-01-29T03:54:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Grace Kelly dos Passos "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0557feb7-f8b7-4df4-aced-9351899e60dc', 'd06ae83e-fa21-4cfd-b131-7c8e683efdd7', '{"sub":"d06ae83e-fa21-4cfd-b131-7c8e683efdd7","email":"gracekpassos@gmail.com","email_verified":true}', 'email', 'd06ae83e-fa21-4cfd-b131-7c8e683efdd7', '2026-01-28T23:13:16.000Z', '2026-01-29T03:54:25.000Z', '2026-01-29T03:54:26.000Z');
UPDATE public.profiles SET name = 'Grace Kelly dos Passos ', cpf = '00058922016', phone = '47991465013', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd06ae83e-fa21-4cfd-b131-7c8e683efdd7';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'd06ae83e-fa21-4cfd-b131-7c8e683efdd7';

-- Thalia de jesus da hora da silva  (Thalia.dahora@outlook.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ed18b059-2236-4d6f-b081-6d27c1bf3068', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'Thalia.dahora@outlook.com', '', '2026-01-29T01:30:06.000Z', '2026-01-29T01:30:06.000Z', '2026-01-29T01:53:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Thalia de jesus da hora da silva "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e5d2af76-ed6a-4070-824d-e92d91296590', 'ed18b059-2236-4d6f-b081-6d27c1bf3068', '{"sub":"ed18b059-2236-4d6f-b081-6d27c1bf3068","email":"Thalia.dahora@outlook.com","email_verified":true}', 'email', 'ed18b059-2236-4d6f-b081-6d27c1bf3068', '2026-01-29T01:30:06.000Z', '2026-01-29T01:53:55.000Z', '2026-01-29T01:53:55.000Z');
UPDATE public.profiles SET name = 'Thalia de jesus da hora da silva ', cpf = '44686003814', phone = '2299610631', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'ed18b059-2236-4d6f-b081-6d27c1bf3068';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'ed18b059-2236-4d6f-b081-6d27c1bf3068';

-- Luiz Fernando Maluf (luizfernando.maluf@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3bf278fb-3f79-4b56-8179-acc51e114b7f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'luizfernando.maluf@gmail.com', '', '2026-01-29T20:07:51.000Z', '2026-01-29T20:07:51.000Z', '2026-01-29T20:11:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Luiz Fernando Maluf"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a5c054e7-e73b-44aa-adec-aaee82077c3e', '3bf278fb-3f79-4b56-8179-acc51e114b7f', '{"sub":"3bf278fb-3f79-4b56-8179-acc51e114b7f","email":"luizfernando.maluf@gmail.com","email_verified":true}', 'email', '3bf278fb-3f79-4b56-8179-acc51e114b7f', '2026-01-29T20:07:51.000Z', '2026-01-29T20:11:53.000Z', '2026-01-29T20:11:53.000Z');
UPDATE public.profiles SET name = 'Luiz Fernando Maluf', cpf = '18709384880', phone = '11991437693', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '14b9a7fa-b094-4638-976b-57ced6420ae9' WHERE user_id = '3bf278fb-3f79-4b56-8179-acc51e114b7f';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = '3bf278fb-3f79-4b56-8179-acc51e114b7f';

-- DJESMI TOMÉ (djesmi@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9ebdfa95-88ef-465c-9388-5c6dc2a57ad9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'djesmi@hotmail.com', '', '2026-01-29T20:56:46.000Z', '2026-01-29T20:56:46.000Z', '2026-02-05T19:47:45.000Z', '{"provider":"email","providers":["email"]}', '{"name":"DJESMI TOMÉ"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ef3b2daa-b620-41c1-9902-71f3c4bc3f11', '9ebdfa95-88ef-465c-9388-5c6dc2a57ad9', '{"sub":"9ebdfa95-88ef-465c-9388-5c6dc2a57ad9","email":"djesmi@hotmail.com","email_verified":true}', 'email', '9ebdfa95-88ef-465c-9388-5c6dc2a57ad9', '2026-01-29T20:56:46.000Z', '2026-02-05T19:47:45.000Z', '2026-02-05T19:47:44.000Z');
UPDATE public.profiles SET name = 'DJESMI TOMÉ', cpf = '06494867662', phone = '12981449453', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '9ebdfa95-88ef-465c-9388-5c6dc2a57ad9';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '9ebdfa95-88ef-465c-9388-5c6dc2a57ad9';

-- Jaqueline Sousa Epifanio (jsepifanio2@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b16f2716-48a9-4dad-9ae1-6105e91f5706', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jsepifanio2@gmail.com', '', '2026-01-30T23:14:17.000Z', '2026-01-30T23:14:17.000Z', '2026-01-30T23:17:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Jaqueline Sousa Epifanio"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d0868a72-ea23-4704-8295-3daaa0674774', 'b16f2716-48a9-4dad-9ae1-6105e91f5706', '{"sub":"b16f2716-48a9-4dad-9ae1-6105e91f5706","email":"jsepifanio2@gmail.com","email_verified":true}', 'email', 'b16f2716-48a9-4dad-9ae1-6105e91f5706', '2026-01-30T23:14:17.000Z', '2026-01-30T23:17:47.000Z', '2026-01-30T23:17:48.000Z');
UPDATE public.profiles SET name = 'Jaqueline Sousa Epifanio', cpf = '11781633690', phone = '37999616845', company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb', department_id = '14b9a7fa-b094-4638-976b-57ced6420ae9' WHERE user_id = 'b16f2716-48a9-4dad-9ae1-6105e91f5706';
UPDATE public.user_roles SET company_id = 'aaca7b06-6896-4015-bd0a-0809fccb24bb' WHERE user_id = 'b16f2716-48a9-4dad-9ae1-6105e91f5706';

-- Normandia (normandia@dnaia.ai) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('84b1fe65-fd39-4b66-a5e9-9fa762f619e6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'normandia@dnaia.ai', '', '2026-02-06T22:41:48.000Z', '2026-02-06T22:41:48.000Z', '2026-02-06T22:41:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Normandia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('91f3f50d-0460-4299-b0d9-9499b57da44b', '84b1fe65-fd39-4b66-a5e9-9fa762f619e6', '{"sub":"84b1fe65-fd39-4b66-a5e9-9fa762f619e6","email":"normandia@dnaia.ai","email_verified":true}', 'email', '84b1fe65-fd39-4b66-a5e9-9fa762f619e6', '2026-02-06T22:41:48.000Z', '2026-02-06T22:41:48.000Z', '2026-02-06T22:41:48.000Z');
UPDATE public.profiles SET name = 'Normandia', cpf = '06847654627', phone = '31984499268', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '84b1fe65-fd39-4b66-a5e9-9fa762f619e6';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '84b1fe65-fd39-4b66-a5e9-9fa762f619e6';

-- Teste Usuario 1 (teste.1770407502698.295.1@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('185bfe3e-9e62-462a-aeb7-29fdb864e206', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502698.295.1@loadtest.com', '', '2026-02-06T22:51:45.000Z', '2026-02-06T22:51:45.000Z', '2026-02-06T22:51:45.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 1"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('386b2657-5ea8-4c6b-9fbe-5b3e1588e1e8', '185bfe3e-9e62-462a-aeb7-29fdb864e206', '{"sub":"185bfe3e-9e62-462a-aeb7-29fdb864e206","email":"teste.1770407502698.295.1@loadtest.com","email_verified":true}', 'email', '185bfe3e-9e62-462a-aeb7-29fdb864e206', '2026-02-06T22:51:45.000Z', '2026-02-06T22:51:45.000Z', '2026-02-06T22:51:46.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 1', cpf = '10000000001', phone = '11900000001', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '185bfe3e-9e62-462a-aeb7-29fdb864e206';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '185bfe3e-9e62-462a-aeb7-29fdb864e206';

-- Teste Usuario 65 (teste.1770407502828.1808.65@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0626a25f-fcda-4a5b-9e75-a862e7d77627', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502828.1808.65@loadtest.com', '', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 65"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8ffa47bc-e077-4b20-86ca-7e0cc455a147', '0626a25f-fcda-4a5b-9e75-a862e7d77627', '{"sub":"0626a25f-fcda-4a5b-9e75-a862e7d77627","email":"teste.1770407502828.1808.65@loadtest.com","email_verified":true}', 'email', '0626a25f-fcda-4a5b-9e75-a862e7d77627', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 65', cpf = '10000000065', phone = '11900000065', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '0626a25f-fcda-4a5b-9e75-a862e7d77627';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '0626a25f-fcda-4a5b-9e75-a862e7d77627';

-- Teste Usuario 3 (teste.1770407502776.3720.3@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0420599c-5d92-4c30-bacf-04e18e0e5a55', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502776.3720.3@loadtest.com', '', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 3"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b1a7703d-f174-42a2-a7bf-3717318647f2', '0420599c-5d92-4c30-bacf-04e18e0e5a55', '{"sub":"0420599c-5d92-4c30-bacf-04e18e0e5a55","email":"teste.1770407502776.3720.3@loadtest.com","email_verified":true}', 'email', '0420599c-5d92-4c30-bacf-04e18e0e5a55', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:47.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 3', cpf = '10000000003', phone = '11900000003', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '0420599c-5d92-4c30-bacf-04e18e0e5a55';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '0420599c-5d92-4c30-bacf-04e18e0e5a55';

-- Teste Usuario 75 (teste.1770407502835.7735.75@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5cdc15e5-4cdf-434f-9eac-82dacf443e93', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502835.7735.75@loadtest.com', '', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 75"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5551ba1e-990c-446a-975a-c69637f0a362', '5cdc15e5-4cdf-434f-9eac-82dacf443e93', '{"sub":"5cdc15e5-4cdf-434f-9eac-82dacf443e93","email":"teste.1770407502835.7735.75@loadtest.com","email_verified":true}', 'email', '5cdc15e5-4cdf-434f-9eac-82dacf443e93', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 75', cpf = '10000000075', phone = '11900000075', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '5cdc15e5-4cdf-434f-9eac-82dacf443e93';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '5cdc15e5-4cdf-434f-9eac-82dacf443e93';

-- Teste Usuario 82 (teste.1770407502840.1592.82@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7ab55248-2e36-4339-ab3f-d58239a8f3aa', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502840.1592.82@loadtest.com', '', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 82"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('970a2978-b807-4682-af64-f879ee93c371', '7ab55248-2e36-4339-ab3f-d58239a8f3aa', '{"sub":"7ab55248-2e36-4339-ab3f-d58239a8f3aa","email":"teste.1770407502840.1592.82@loadtest.com","email_verified":true}', 'email', '7ab55248-2e36-4339-ab3f-d58239a8f3aa', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 82', cpf = '10000000082', phone = '11900000082', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '7ab55248-2e36-4339-ab3f-d58239a8f3aa';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '7ab55248-2e36-4339-ab3f-d58239a8f3aa';

-- Teste Usuario 4 (teste.1770407502778.6251.4@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fa827305-50c8-4142-bfae-62db12268a2b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502778.6251.4@loadtest.com', '', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 4"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('696b5540-d445-42b5-88ad-4ce1682978c9', 'fa827305-50c8-4142-bfae-62db12268a2b', '{"sub":"fa827305-50c8-4142-bfae-62db12268a2b","email":"teste.1770407502778.6251.4@loadtest.com","email_verified":true}', 'email', 'fa827305-50c8-4142-bfae-62db12268a2b', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 4', cpf = '10000000004', phone = '11900000004', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'fa827305-50c8-4142-bfae-62db12268a2b';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'fa827305-50c8-4142-bfae-62db12268a2b';

-- Teste Usuario 70 (teste.1770407502832.9984.70@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1edbb468-7a5f-4fb2-9aa2-6259bbba39e0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502832.9984.70@loadtest.com', '', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 70"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0b0a38b3-e27c-4734-9751-5d5d2e722844', '1edbb468-7a5f-4fb2-9aa2-6259bbba39e0', '{"sub":"1edbb468-7a5f-4fb2-9aa2-6259bbba39e0","email":"teste.1770407502832.9984.70@loadtest.com","email_verified":true}', 'email', '1edbb468-7a5f-4fb2-9aa2-6259bbba39e0', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 70', cpf = '10000000070', phone = '11900000070', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1edbb468-7a5f-4fb2-9aa2-6259bbba39e0';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1edbb468-7a5f-4fb2-9aa2-6259bbba39e0';

-- Teste Usuario 6 (teste.1770407502780.1844.6@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c885a492-5aaa-418e-b2bc-147c0d896534', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502780.1844.6@loadtest.com', '', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 6"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5fd26ee6-0c9a-4448-9e78-c94af9218ba7', 'c885a492-5aaa-418e-b2bc-147c0d896534', '{"sub":"c885a492-5aaa-418e-b2bc-147c0d896534","email":"teste.1770407502780.1844.6@loadtest.com","email_verified":true}', 'email', 'c885a492-5aaa-418e-b2bc-147c0d896534', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:49.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 6', cpf = '10000000006', phone = '11900000006', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c885a492-5aaa-418e-b2bc-147c0d896534';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c885a492-5aaa-418e-b2bc-147c0d896534';

-- Teste Usuario 7 (teste.1770407502781.2325.7@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('88ce765d-da50-4c41-93ef-eeec4e921cb1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502781.2325.7@loadtest.com', '', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 7"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('284bf120-f4be-460d-8fd0-23bcabe7ca56', '88ce765d-da50-4c41-93ef-eeec4e921cb1', '{"sub":"88ce765d-da50-4c41-93ef-eeec4e921cb1","email":"teste.1770407502781.2325.7@loadtest.com","email_verified":true}', 'email', '88ce765d-da50-4c41-93ef-eeec4e921cb1', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 7', cpf = '10000000007', phone = '11900000007', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '88ce765d-da50-4c41-93ef-eeec4e921cb1';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '88ce765d-da50-4c41-93ef-eeec4e921cb1';

-- Teste Usuario 10 (teste.1770407502787.4792.10@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c63af079-e39d-4350-9eb4-9b49e20e59b4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502787.4792.10@loadtest.com', '', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 10"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5d0b3528-143c-48f2-ad07-6d76b3e392c4', 'c63af079-e39d-4350-9eb4-9b49e20e59b4', '{"sub":"c63af079-e39d-4350-9eb4-9b49e20e59b4","email":"teste.1770407502787.4792.10@loadtest.com","email_verified":true}', 'email', 'c63af079-e39d-4350-9eb4-9b49e20e59b4', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:50.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 10', cpf = '10000000010', phone = '11900000010', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c63af079-e39d-4350-9eb4-9b49e20e59b4';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c63af079-e39d-4350-9eb4-9b49e20e59b4';

-- Teste Usuario 79 (teste.1770407502838.7504.79@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9c74eaf8-74b0-4a82-9c73-23fd11a70d84', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502838.7504.79@loadtest.com', '', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 79"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ff89332f-a11b-48f6-bdee-2d9047a4406e', '9c74eaf8-74b0-4a82-9c73-23fd11a70d84', '{"sub":"9c74eaf8-74b0-4a82-9c73-23fd11a70d84","email":"teste.1770407502838.7504.79@loadtest.com","email_verified":true}', 'email', '9c74eaf8-74b0-4a82-9c73-23fd11a70d84', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 79', cpf = '10000000079', phone = '11900000079', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9c74eaf8-74b0-4a82-9c73-23fd11a70d84';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9c74eaf8-74b0-4a82-9c73-23fd11a70d84';

-- Teste Usuario 14 (teste.1770407502790.5763.14@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d538e6af-1e69-4e70-b8f5-1e7caebb0244', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502790.5763.14@loadtest.com', '', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 14"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1633160f-8376-4ba4-b949-31e845c7402c', 'd538e6af-1e69-4e70-b8f5-1e7caebb0244', '{"sub":"d538e6af-1e69-4e70-b8f5-1e7caebb0244","email":"teste.1770407502790.5763.14@loadtest.com","email_verified":true}', 'email', 'd538e6af-1e69-4e70-b8f5-1e7caebb0244', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:51.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 14', cpf = '10000000014', phone = '11900000014', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd538e6af-1e69-4e70-b8f5-1e7caebb0244';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd538e6af-1e69-4e70-b8f5-1e7caebb0244';

-- Teste Usuario 2 (teste.1770407502774.8536.2@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1dc81ed6-cc89-4264-8b49-dae12f1ab668', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502774.8536.2@loadtest.com', '', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 2"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('68fd06ed-eea0-4a50-8310-dd084d6c5467', '1dc81ed6-cc89-4264-8b49-dae12f1ab668', '{"sub":"1dc81ed6-cc89-4264-8b49-dae12f1ab668","email":"teste.1770407502774.8536.2@loadtest.com","email_verified":true}', 'email', '1dc81ed6-cc89-4264-8b49-dae12f1ab668', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 2', cpf = '10000000002', phone = '11900000002', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1dc81ed6-cc89-4264-8b49-dae12f1ab668';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1dc81ed6-cc89-4264-8b49-dae12f1ab668';

-- Teste Usuario 19 (teste.1770407502794.8959.19@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('97f7e8ac-043f-419d-9054-c3075901201a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502794.8959.19@loadtest.com', '', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 19"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f481d380-1844-4fc0-990a-474808dd1ad5', '97f7e8ac-043f-419d-9054-c3075901201a', '{"sub":"97f7e8ac-043f-419d-9054-c3075901201a","email":"teste.1770407502794.8959.19@loadtest.com","email_verified":true}', 'email', '97f7e8ac-043f-419d-9054-c3075901201a', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 19', cpf = '10000000019', phone = '11900000019', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '97f7e8ac-043f-419d-9054-c3075901201a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '97f7e8ac-043f-419d-9054-c3075901201a';

-- Teste Usuario 5 (teste.1770407502779.6787.5@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('48eeaa66-bbcf-4659-a1b0-5939270f77de', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502779.6787.5@loadtest.com', '', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 5"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('edef63fb-523e-4432-bb5d-aac786bfdc69', '48eeaa66-bbcf-4659-a1b0-5939270f77de', '{"sub":"48eeaa66-bbcf-4659-a1b0-5939270f77de","email":"teste.1770407502779.6787.5@loadtest.com","email_verified":true}', 'email', '48eeaa66-bbcf-4659-a1b0-5939270f77de', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:52.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 5', cpf = '10000000005', phone = '11900000005', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '48eeaa66-bbcf-4659-a1b0-5939270f77de';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '48eeaa66-bbcf-4659-a1b0-5939270f77de';

-- Teste Usuario 9 (teste.1770407502783.5086.9@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('cf67b5d2-8a0b-426a-8a11-a9ba4b627f46', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502783.5086.9@loadtest.com', '', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 9"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5700325d-8db1-436f-aab3-13f31712e2a6', 'cf67b5d2-8a0b-426a-8a11-a9ba4b627f46', '{"sub":"cf67b5d2-8a0b-426a-8a11-a9ba4b627f46","email":"teste.1770407502783.5086.9@loadtest.com","email_verified":true}', 'email', 'cf67b5d2-8a0b-426a-8a11-a9ba4b627f46', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 9', cpf = '10000000009', phone = '11900000009', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'cf67b5d2-8a0b-426a-8a11-a9ba4b627f46';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'cf67b5d2-8a0b-426a-8a11-a9ba4b627f46';

-- Teste Usuario 15 (teste.1770407502791.8698.15@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c1fd56be-8c9b-46ed-80f4-743fdab183e8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502791.8698.15@loadtest.com', '', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 15"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('77ec4d0f-138e-4f83-85f3-0722b81bd87c', 'c1fd56be-8c9b-46ed-80f4-743fdab183e8', '{"sub":"c1fd56be-8c9b-46ed-80f4-743fdab183e8","email":"teste.1770407502791.8698.15@loadtest.com","email_verified":true}', 'email', 'c1fd56be-8c9b-46ed-80f4-743fdab183e8', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:53.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 15', cpf = '10000000015', phone = '11900000015', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c1fd56be-8c9b-46ed-80f4-743fdab183e8';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c1fd56be-8c9b-46ed-80f4-743fdab183e8';

-- Teste Usuario 11 (teste.1770407502788.3329.11@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('425492fe-875d-421a-8ba2-079fa3c083a5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502788.3329.11@loadtest.com', '', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 11"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('692c6ea9-621d-4a83-9056-5dc977a9eba0', '425492fe-875d-421a-8ba2-079fa3c083a5', '{"sub":"425492fe-875d-421a-8ba2-079fa3c083a5","email":"teste.1770407502788.3329.11@loadtest.com","email_verified":true}', 'email', '425492fe-875d-421a-8ba2-079fa3c083a5', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 11', cpf = '10000000011', phone = '11900000011', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '425492fe-875d-421a-8ba2-079fa3c083a5';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '425492fe-875d-421a-8ba2-079fa3c083a5';

-- Teste Usuario 18 (teste.1770407502793.4788.18@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1f83b5b2-de45-4265-a733-bc47f9793468', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502793.4788.18@loadtest.com', '', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 18"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6b8ef485-c255-45b3-824a-58197013176c', '1f83b5b2-de45-4265-a733-bc47f9793468', '{"sub":"1f83b5b2-de45-4265-a733-bc47f9793468","email":"teste.1770407502793.4788.18@loadtest.com","email_verified":true}', 'email', '1f83b5b2-de45-4265-a733-bc47f9793468', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:54.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 18', cpf = '10000000018', phone = '11900000018', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1f83b5b2-de45-4265-a733-bc47f9793468';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1f83b5b2-de45-4265-a733-bc47f9793468';

-- Teste Usuario 26 (teste.1770407502799.9290.26@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e859a906-f082-4817-acf0-b21d840ca8b1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502799.9290.26@loadtest.com', '', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 26"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('24a46eb6-45e3-4208-9f53-7de61a9e3825', 'e859a906-f082-4817-acf0-b21d840ca8b1', '{"sub":"e859a906-f082-4817-acf0-b21d840ca8b1","email":"teste.1770407502799.9290.26@loadtest.com","email_verified":true}', 'email', 'e859a906-f082-4817-acf0-b21d840ca8b1', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 26', cpf = '10000000026', phone = '11900000026', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'e859a906-f082-4817-acf0-b21d840ca8b1';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'e859a906-f082-4817-acf0-b21d840ca8b1';

-- Teste Usuario 16 (teste.1770407502792.1908.16@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9d71d3ee-41b1-46c4-9d3e-e46a4c1d091d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502792.1908.16@loadtest.com', '', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 16"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2f73b1a3-7f55-4553-b794-f969aa9af41c', '9d71d3ee-41b1-46c4-9d3e-e46a4c1d091d', '{"sub":"9d71d3ee-41b1-46c4-9d3e-e46a4c1d091d","email":"teste.1770407502792.1908.16@loadtest.com","email_verified":true}', 'email', '9d71d3ee-41b1-46c4-9d3e-e46a4c1d091d', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 16', cpf = '10000000016', phone = '11900000016', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9d71d3ee-41b1-46c4-9d3e-e46a4c1d091d';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9d71d3ee-41b1-46c4-9d3e-e46a4c1d091d';

-- Teste Usuario 13 (teste.1770407502790.6360.13@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6c16228b-8b5f-44a0-89e9-3b3af51b5471', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502790.6360.13@loadtest.com', '', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 13"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2eaf1434-9311-42b9-b9cf-833238d74aa9', '6c16228b-8b5f-44a0-89e9-3b3af51b5471', '{"sub":"6c16228b-8b5f-44a0-89e9-3b3af51b5471","email":"teste.1770407502790.6360.13@loadtest.com","email_verified":true}', 'email', '6c16228b-8b5f-44a0-89e9-3b3af51b5471', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 13', cpf = '10000000013', phone = '11900000013', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '6c16228b-8b5f-44a0-89e9-3b3af51b5471';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '6c16228b-8b5f-44a0-89e9-3b3af51b5471';

-- Teste Usuario 8 (teste.1770407502782.1842.8@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ad606af1-90d1-4c8f-9024-9d8bdf35f787', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502782.1842.8@loadtest.com', '', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 8"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('17da940a-283d-4abb-a224-22df33decda8', 'ad606af1-90d1-4c8f-9024-9d8bdf35f787', '{"sub":"ad606af1-90d1-4c8f-9024-9d8bdf35f787","email":"teste.1770407502782.1842.8@loadtest.com","email_verified":true}', 'email', 'ad606af1-90d1-4c8f-9024-9d8bdf35f787', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 8', cpf = '10000000008', phone = '11900000008', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ad606af1-90d1-4c8f-9024-9d8bdf35f787';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ad606af1-90d1-4c8f-9024-9d8bdf35f787';

-- Teste Usuario 20 (teste.1770407502794.2994.20@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4426d727-731a-4733-9de1-cb7fbe5db8a2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502794.2994.20@loadtest.com', '', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 20"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fe7f7988-ee05-410f-abd1-cf1d7fd6d162', '4426d727-731a-4733-9de1-cb7fbe5db8a2', '{"sub":"4426d727-731a-4733-9de1-cb7fbe5db8a2","email":"teste.1770407502794.2994.20@loadtest.com","email_verified":true}', 'email', '4426d727-731a-4733-9de1-cb7fbe5db8a2', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:56.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 20', cpf = '10000000020', phone = '11900000020', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4426d727-731a-4733-9de1-cb7fbe5db8a2';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4426d727-731a-4733-9de1-cb7fbe5db8a2';

-- Teste Usuario 17 (teste.1770407502792.5820.17@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('edbb7859-07b6-475b-bd2e-46cb877e3706', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502792.5820.17@loadtest.com', '', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 17"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c1be97ea-838f-440a-ac16-3bd3d318b2ee', 'edbb7859-07b6-475b-bd2e-46cb877e3706', '{"sub":"edbb7859-07b6-475b-bd2e-46cb877e3706","email":"teste.1770407502792.5820.17@loadtest.com","email_verified":true}', 'email', 'edbb7859-07b6-475b-bd2e-46cb877e3706', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 17', cpf = '10000000017', phone = '11900000017', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'edbb7859-07b6-475b-bd2e-46cb877e3706';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'edbb7859-07b6-475b-bd2e-46cb877e3706';

-- Teste Usuario 24 (teste.1770407502797.9054.24@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a6752490-b968-4c7d-99ca-a626cb72fcd1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502797.9054.24@loadtest.com', '', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 24"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0982be9b-1b3b-4b86-8b73-bc192c309ab6', 'a6752490-b968-4c7d-99ca-a626cb72fcd1', '{"sub":"a6752490-b968-4c7d-99ca-a626cb72fcd1","email":"teste.1770407502797.9054.24@loadtest.com","email_verified":true}', 'email', 'a6752490-b968-4c7d-99ca-a626cb72fcd1', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:57.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 24', cpf = '10000000024', phone = '11900000024', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a6752490-b968-4c7d-99ca-a626cb72fcd1';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a6752490-b968-4c7d-99ca-a626cb72fcd1';

-- Teste Usuario 12 (teste.1770407502789.2226.12@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e2034a14-5fd7-4060-9511-17f398b7b2aa', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502789.2226.12@loadtest.com', '', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 12"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('10703422-a156-4611-830c-451f0027e501', 'e2034a14-5fd7-4060-9511-17f398b7b2aa', '{"sub":"e2034a14-5fd7-4060-9511-17f398b7b2aa","email":"teste.1770407502789.2226.12@loadtest.com","email_verified":true}', 'email', 'e2034a14-5fd7-4060-9511-17f398b7b2aa', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 12', cpf = '10000000012', phone = '11900000012', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'e2034a14-5fd7-4060-9511-17f398b7b2aa';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'e2034a14-5fd7-4060-9511-17f398b7b2aa';

-- Teste Usuario 21 (teste.1770407502795.633.21@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e814f7d9-c5cd-4c5a-add0-97f5074db424', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502795.633.21@loadtest.com', '', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 21"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a25fcf2a-ad49-4ca7-8a44-dfcc00d32121', 'e814f7d9-c5cd-4c5a-add0-97f5074db424', '{"sub":"e814f7d9-c5cd-4c5a-add0-97f5074db424","email":"teste.1770407502795.633.21@loadtest.com","email_verified":true}', 'email', 'e814f7d9-c5cd-4c5a-add0-97f5074db424', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:58.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 21', cpf = '10000000021', phone = '11900000021', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'e814f7d9-c5cd-4c5a-add0-97f5074db424';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'e814f7d9-c5cd-4c5a-add0-97f5074db424';

-- Teste Usuario 27 (teste.1770407502799.4935.27@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c1fa1ce3-fb8d-4234-9bcd-c728e3075097', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502799.4935.27@loadtest.com', '', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 27"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('23b0784b-564e-4d6e-831d-b3849688df33', 'c1fa1ce3-fb8d-4234-9bcd-c728e3075097', '{"sub":"c1fa1ce3-fb8d-4234-9bcd-c728e3075097","email":"teste.1770407502799.4935.27@loadtest.com","email_verified":true}', 'email', 'c1fa1ce3-fb8d-4234-9bcd-c728e3075097', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 27', cpf = '10000000027', phone = '11900000027', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c1fa1ce3-fb8d-4234-9bcd-c728e3075097';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c1fa1ce3-fb8d-4234-9bcd-c728e3075097';

-- Teste Usuario 23 (teste.1770407502797.88.23@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4a3287e1-699d-457c-bf83-6d6faaa29a17', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502797.88.23@loadtest.com', '', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 23"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fa658bab-4f91-49e2-9a2f-ae7cf66fe2b1', '4a3287e1-699d-457c-bf83-6d6faaa29a17', '{"sub":"4a3287e1-699d-457c-bf83-6d6faaa29a17","email":"teste.1770407502797.88.23@loadtest.com","email_verified":true}', 'email', '4a3287e1-699d-457c-bf83-6d6faaa29a17', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 23', cpf = '10000000023', phone = '11900000023', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4a3287e1-699d-457c-bf83-6d6faaa29a17';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4a3287e1-699d-457c-bf83-6d6faaa29a17';

-- Teste Usuario 28 (teste.1770407502800.3937.28@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('35b2979a-0a0c-4ec3-a0a3-32f46a4873d7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502800.3937.28@loadtest.com', '', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 28"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2ab2410d-3848-4f9b-bc9c-4e8f00784873', '35b2979a-0a0c-4ec3-a0a3-32f46a4873d7', '{"sub":"35b2979a-0a0c-4ec3-a0a3-32f46a4873d7","email":"teste.1770407502800.3937.28@loadtest.com","email_verified":true}', 'email', '35b2979a-0a0c-4ec3-a0a3-32f46a4873d7', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:59.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 28', cpf = '10000000028', phone = '11900000028', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '35b2979a-0a0c-4ec3-a0a3-32f46a4873d7';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '35b2979a-0a0c-4ec3-a0a3-32f46a4873d7';

-- Teste Usuario 40 (teste.1770407502809.8639.40@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9d2da671-cff6-4ed5-87ea-e37c225e35c6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502809.8639.40@loadtest.com', '', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 40"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5b124c70-ca13-4dbb-8923-d16f743ea634', '9d2da671-cff6-4ed5-87ea-e37c225e35c6', '{"sub":"9d2da671-cff6-4ed5-87ea-e37c225e35c6","email":"teste.1770407502809.8639.40@loadtest.com","email_verified":true}', 'email', '9d2da671-cff6-4ed5-87ea-e37c225e35c6', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 40', cpf = '10000000040', phone = '11900000040', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9d2da671-cff6-4ed5-87ea-e37c225e35c6';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9d2da671-cff6-4ed5-87ea-e37c225e35c6';

-- Teste Usuario 22 (teste.1770407502796.2487.22@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ee18ad8a-c302-4df1-ad2e-602d4eb9f68c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502796.2487.22@loadtest.com', '', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 22"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1c121d6f-6957-4893-b16b-4be71a678549', 'ee18ad8a-c302-4df1-ad2e-602d4eb9f68c', '{"sub":"ee18ad8a-c302-4df1-ad2e-602d4eb9f68c","email":"teste.1770407502796.2487.22@loadtest.com","email_verified":true}', 'email', 'ee18ad8a-c302-4df1-ad2e-602d4eb9f68c', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z', '2026-02-06T22:52:00.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 22', cpf = '10000000022', phone = '11900000022', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ee18ad8a-c302-4df1-ad2e-602d4eb9f68c';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ee18ad8a-c302-4df1-ad2e-602d4eb9f68c';

-- Teste Usuario 25 (teste.1770407502798.3500.25@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f44e5712-f8ec-43b6-9730-f790f3344ef1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502798.3500.25@loadtest.com', '', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 25"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('20a4a737-307e-434c-9269-35e4064b1e1a', 'f44e5712-f8ec-43b6-9730-f790f3344ef1', '{"sub":"f44e5712-f8ec-43b6-9730-f790f3344ef1","email":"teste.1770407502798.3500.25@loadtest.com","email_verified":true}', 'email', 'f44e5712-f8ec-43b6-9730-f790f3344ef1', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 25', cpf = '10000000025', phone = '11900000025', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'f44e5712-f8ec-43b6-9730-f790f3344ef1';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'f44e5712-f8ec-43b6-9730-f790f3344ef1';

-- Teste Usuario 85 (teste.1770407502844.9283.85@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1f9526fe-6132-4429-b940-e32d71d91a67', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502844.9283.85@loadtest.com', '', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 85"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b8992f44-9ed4-49ed-9faa-10a133aaeeca', '1f9526fe-6132-4429-b940-e32d71d91a67', '{"sub":"1f9526fe-6132-4429-b940-e32d71d91a67","email":"teste.1770407502844.9283.85@loadtest.com","email_verified":true}', 'email', '1f9526fe-6132-4429-b940-e32d71d91a67', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:01.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 85', cpf = '10000000085', phone = '11900000085', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1f9526fe-6132-4429-b940-e32d71d91a67';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1f9526fe-6132-4429-b940-e32d71d91a67';

-- Teste Usuario 44 (teste.1770407502812.7425.44@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('281b93ff-6bb6-486a-b7bb-20224e2b2ddc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502812.7425.44@loadtest.com', '', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 44"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5cd8e4d4-c9fe-42db-a17e-2b9ab4b503bf', '281b93ff-6bb6-486a-b7bb-20224e2b2ddc', '{"sub":"281b93ff-6bb6-486a-b7bb-20224e2b2ddc","email":"teste.1770407502812.7425.44@loadtest.com","email_verified":true}', 'email', '281b93ff-6bb6-486a-b7bb-20224e2b2ddc', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 44', cpf = '10000000044', phone = '11900000044', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '281b93ff-6bb6-486a-b7bb-20224e2b2ddc';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '281b93ff-6bb6-486a-b7bb-20224e2b2ddc';

-- Teste Usuario 51 (teste.1770407502817.1818.51@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ab9350e7-dc2c-4c12-ba12-122c877fba3e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502817.1818.51@loadtest.com', '', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 51"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('db085ec5-67a2-46d0-a4d0-554e49fa5e62', 'ab9350e7-dc2c-4c12-ba12-122c877fba3e', '{"sub":"ab9350e7-dc2c-4c12-ba12-122c877fba3e","email":"teste.1770407502817.1818.51@loadtest.com","email_verified":true}', 'email', 'ab9350e7-dc2c-4c12-ba12-122c877fba3e', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:02.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 51', cpf = '10000000051', phone = '11900000051', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ab9350e7-dc2c-4c12-ba12-122c877fba3e';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ab9350e7-dc2c-4c12-ba12-122c877fba3e';

-- Teste Usuario 29 (teste.1770407502801.7249.29@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6f759e14-66c5-4009-aee8-c851a897cb38', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502801.7249.29@loadtest.com', '', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 29"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c0695672-c298-4366-a1f7-757f2722a376', '6f759e14-66c5-4009-aee8-c851a897cb38', '{"sub":"6f759e14-66c5-4009-aee8-c851a897cb38","email":"teste.1770407502801.7249.29@loadtest.com","email_verified":true}', 'email', '6f759e14-66c5-4009-aee8-c851a897cb38', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 29', cpf = '10000000029', phone = '11900000029', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '6f759e14-66c5-4009-aee8-c851a897cb38';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '6f759e14-66c5-4009-aee8-c851a897cb38';

-- Teste Usuario 33 (teste.1770407502804.838.33@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1ffc30c9-03c6-4610-8f7a-4f8e573d3460', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502804.838.33@loadtest.com', '', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 33"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('083a6db6-37cd-414d-87f6-1dee5571f778', '1ffc30c9-03c6-4610-8f7a-4f8e573d3460', '{"sub":"1ffc30c9-03c6-4610-8f7a-4f8e573d3460","email":"teste.1770407502804.838.33@loadtest.com","email_verified":true}', 'email', '1ffc30c9-03c6-4610-8f7a-4f8e573d3460', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 33', cpf = '10000000033', phone = '11900000033', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1ffc30c9-03c6-4610-8f7a-4f8e573d3460';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1ffc30c9-03c6-4610-8f7a-4f8e573d3460';

-- Teste Usuario 38 (teste.1770407502807.2556.38@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1311471c-7f45-4351-8d24-6fa5b7209cf1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502807.2556.38@loadtest.com', '', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 38"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a20cd539-cdf2-466f-8c25-bf6df1bc1621', '1311471c-7f45-4351-8d24-6fa5b7209cf1', '{"sub":"1311471c-7f45-4351-8d24-6fa5b7209cf1","email":"teste.1770407502807.2556.38@loadtest.com","email_verified":true}', 'email', '1311471c-7f45-4351-8d24-6fa5b7209cf1', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:03.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 38', cpf = '10000000038', phone = '11900000038', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1311471c-7f45-4351-8d24-6fa5b7209cf1';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1311471c-7f45-4351-8d24-6fa5b7209cf1';

-- Teste Usuario 31 (teste.1770407502802.5574.31@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('021117ce-53da-426a-a3ae-cb799505ff0a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502802.5574.31@loadtest.com', '', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 31"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('75342a12-1698-44cb-aed4-91f419f84ef1', '021117ce-53da-426a-a3ae-cb799505ff0a', '{"sub":"021117ce-53da-426a-a3ae-cb799505ff0a","email":"teste.1770407502802.5574.31@loadtest.com","email_verified":true}', 'email', '021117ce-53da-426a-a3ae-cb799505ff0a', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 31', cpf = '10000000031', phone = '11900000031', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '021117ce-53da-426a-a3ae-cb799505ff0a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '021117ce-53da-426a-a3ae-cb799505ff0a';

-- Teste Usuario 37 (teste.1770407502807.8803.37@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ef48949c-0571-417d-860d-95592fb657cb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502807.8803.37@loadtest.com', '', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 37"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4d317bc4-5e22-4cd1-9106-6c521e1da251', 'ef48949c-0571-417d-860d-95592fb657cb', '{"sub":"ef48949c-0571-417d-860d-95592fb657cb","email":"teste.1770407502807.8803.37@loadtest.com","email_verified":true}', 'email', 'ef48949c-0571-417d-860d-95592fb657cb', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:04.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 37', cpf = '10000000037', phone = '11900000037', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ef48949c-0571-417d-860d-95592fb657cb';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ef48949c-0571-417d-860d-95592fb657cb';

-- Teste Usuario 34 (teste.1770407502805.3595.34@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('62199f2b-98e2-4c5c-9e78-fcef7dcd6ac7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502805.3595.34@loadtest.com', '', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 34"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1112d036-e2db-42dd-b60c-42bf2c4174ab', '62199f2b-98e2-4c5c-9e78-fcef7dcd6ac7', '{"sub":"62199f2b-98e2-4c5c-9e78-fcef7dcd6ac7","email":"teste.1770407502805.3595.34@loadtest.com","email_verified":true}', 'email', '62199f2b-98e2-4c5c-9e78-fcef7dcd6ac7', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 34', cpf = '10000000034', phone = '11900000034', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '62199f2b-98e2-4c5c-9e78-fcef7dcd6ac7';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '62199f2b-98e2-4c5c-9e78-fcef7dcd6ac7';

-- Teste Usuario 42 (teste.1770407502810.1305.42@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dc210a64-a8aa-4455-8f71-b0f2a67ef5dd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502810.1305.42@loadtest.com', '', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 42"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a94200d6-7761-430d-9c51-7b9f675878d3', 'dc210a64-a8aa-4455-8f71-b0f2a67ef5dd', '{"sub":"dc210a64-a8aa-4455-8f71-b0f2a67ef5dd","email":"teste.1770407502810.1305.42@loadtest.com","email_verified":true}', 'email', 'dc210a64-a8aa-4455-8f71-b0f2a67ef5dd', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:05.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 42', cpf = '10000000042', phone = '11900000042', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'dc210a64-a8aa-4455-8f71-b0f2a67ef5dd';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'dc210a64-a8aa-4455-8f71-b0f2a67ef5dd';

-- Teste Usuario 32 (teste.1770407502803.639.32@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('112796a0-c843-4185-8eb5-98be79bed73a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502803.639.32@loadtest.com', '', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 32"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('01facd32-c3c2-47b2-89d3-3534c2c57698', '112796a0-c843-4185-8eb5-98be79bed73a', '{"sub":"112796a0-c843-4185-8eb5-98be79bed73a","email":"teste.1770407502803.639.32@loadtest.com","email_verified":true}', 'email', '112796a0-c843-4185-8eb5-98be79bed73a', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 32', cpf = '10000000032', phone = '11900000032', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '112796a0-c843-4185-8eb5-98be79bed73a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '112796a0-c843-4185-8eb5-98be79bed73a';

-- Teste Usuario 46 (teste.1770407502813.4674.46@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('106bd09c-e7c4-4ae9-bb6f-5aa5924f32f9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502813.4674.46@loadtest.com', '', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 46"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('32946dd9-6377-4ff8-8831-d2dc5416ad9a', '106bd09c-e7c4-4ae9-bb6f-5aa5924f32f9', '{"sub":"106bd09c-e7c4-4ae9-bb6f-5aa5924f32f9","email":"teste.1770407502813.4674.46@loadtest.com","email_verified":true}', 'email', '106bd09c-e7c4-4ae9-bb6f-5aa5924f32f9', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 46', cpf = '10000000046', phone = '11900000046', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '106bd09c-e7c4-4ae9-bb6f-5aa5924f32f9';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '106bd09c-e7c4-4ae9-bb6f-5aa5924f32f9';

-- Teste Usuario 48 (teste.1770407502814.5100.48@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f05a53dd-4a85-4334-9d41-d0194d36ee24', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502814.5100.48@loadtest.com', '', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 48"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cf9ae6a1-5103-4999-ba74-1debd4bbdc82', 'f05a53dd-4a85-4334-9d41-d0194d36ee24', '{"sub":"f05a53dd-4a85-4334-9d41-d0194d36ee24","email":"teste.1770407502814.5100.48@loadtest.com","email_verified":true}', 'email', 'f05a53dd-4a85-4334-9d41-d0194d36ee24', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 48', cpf = '10000000048', phone = '11900000048', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'f05a53dd-4a85-4334-9d41-d0194d36ee24';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'f05a53dd-4a85-4334-9d41-d0194d36ee24';

-- Teste Usuario 47 (teste.1770407502814.91.47@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d95a1bb5-579a-4266-9f63-77e8dd7209ad', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502814.91.47@loadtest.com', '', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 47"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('91a2605d-1305-4144-b310-0a52003274cf', 'd95a1bb5-579a-4266-9f63-77e8dd7209ad', '{"sub":"d95a1bb5-579a-4266-9f63-77e8dd7209ad","email":"teste.1770407502814.91.47@loadtest.com","email_verified":true}', 'email', 'd95a1bb5-579a-4266-9f63-77e8dd7209ad', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 47', cpf = '10000000047', phone = '11900000047', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd95a1bb5-579a-4266-9f63-77e8dd7209ad';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd95a1bb5-579a-4266-9f63-77e8dd7209ad';

-- Teste Usuario 45 (teste.1770407502812.6317.45@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1270933f-ab47-4462-ac03-c0592908a6ed', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502812.6317.45@loadtest.com', '', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 45"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1c232706-3dd2-40ec-b226-b73a106c970d', '1270933f-ab47-4462-ac03-c0592908a6ed', '{"sub":"1270933f-ab47-4462-ac03-c0592908a6ed","email":"teste.1770407502812.6317.45@loadtest.com","email_verified":true}', 'email', '1270933f-ab47-4462-ac03-c0592908a6ed', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:07.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 45', cpf = '10000000045', phone = '11900000045', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1270933f-ab47-4462-ac03-c0592908a6ed';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1270933f-ab47-4462-ac03-c0592908a6ed';

-- Teste Usuario 55 (teste.1770407502821.686.55@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('564edccd-7ace-421e-945e-f5787ca1c560', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502821.686.55@loadtest.com', '', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 55"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c854d6f3-0235-46c0-946b-14c66be7b73f', '564edccd-7ace-421e-945e-f5787ca1c560', '{"sub":"564edccd-7ace-421e-945e-f5787ca1c560","email":"teste.1770407502821.686.55@loadtest.com","email_verified":true}', 'email', '564edccd-7ace-421e-945e-f5787ca1c560', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 55', cpf = '10000000055', phone = '11900000055', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '564edccd-7ace-421e-945e-f5787ca1c560';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '564edccd-7ace-421e-945e-f5787ca1c560';

-- Teste Usuario 30 (teste.1770407502802.9551.30@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c24145ed-2904-4dfe-8e6f-bd1501f076cf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502802.9551.30@loadtest.com', '', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 30"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dd229df5-d783-4fe7-b14b-d5c761dbda8e', 'c24145ed-2904-4dfe-8e6f-bd1501f076cf', '{"sub":"c24145ed-2904-4dfe-8e6f-bd1501f076cf","email":"teste.1770407502802.9551.30@loadtest.com","email_verified":true}', 'email', 'c24145ed-2904-4dfe-8e6f-bd1501f076cf', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:08.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 30', cpf = '10000000030', phone = '11900000030', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c24145ed-2904-4dfe-8e6f-bd1501f076cf';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c24145ed-2904-4dfe-8e6f-bd1501f076cf';

-- Teste Usuario 59 (teste.1770407502824.6799.59@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c6b42192-f4eb-4aa3-a30e-9ba19b501951', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502824.6799.59@loadtest.com', '', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 59"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e4286982-75cc-44ed-90c4-4854cdc13752', 'c6b42192-f4eb-4aa3-a30e-9ba19b501951', '{"sub":"c6b42192-f4eb-4aa3-a30e-9ba19b501951","email":"teste.1770407502824.6799.59@loadtest.com","email_verified":true}', 'email', 'c6b42192-f4eb-4aa3-a30e-9ba19b501951', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 59', cpf = '10000000059', phone = '11900000059', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c6b42192-f4eb-4aa3-a30e-9ba19b501951';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c6b42192-f4eb-4aa3-a30e-9ba19b501951';

-- Teste Usuario 61 (teste.1770407502825.7736.61@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a8fdc7cd-28c6-4a7a-afdc-a522257b2d95', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502825.7736.61@loadtest.com', '', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 61"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f7f3872f-885e-4689-9882-50b3a3a51ee0', 'a8fdc7cd-28c6-4a7a-afdc-a522257b2d95', '{"sub":"a8fdc7cd-28c6-4a7a-afdc-a522257b2d95","email":"teste.1770407502825.7736.61@loadtest.com","email_verified":true}', 'email', 'a8fdc7cd-28c6-4a7a-afdc-a522257b2d95', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:09.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 61', cpf = '10000000061', phone = '11900000061', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a8fdc7cd-28c6-4a7a-afdc-a522257b2d95';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a8fdc7cd-28c6-4a7a-afdc-a522257b2d95';

-- Teste Usuario 100 (teste.1770407502854.3743.100@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('02b3c0f4-0adf-40c1-a200-9ff5db8f2334', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502854.3743.100@loadtest.com', '', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 100"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8933ae65-84e1-4adb-8aa6-c5dea2c43a15', '02b3c0f4-0adf-40c1-a200-9ff5db8f2334', '{"sub":"02b3c0f4-0adf-40c1-a200-9ff5db8f2334","email":"teste.1770407502854.3743.100@loadtest.com","email_verified":true}', 'email', '02b3c0f4-0adf-40c1-a200-9ff5db8f2334', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 100', cpf = '10000000100', phone = '11900000100', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '02b3c0f4-0adf-40c1-a200-9ff5db8f2334';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '02b3c0f4-0adf-40c1-a200-9ff5db8f2334';

-- Teste Usuario 77 (teste.1770407502837.7792.77@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5f347b10-8daa-4963-abd6-22b3fc22257a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502837.7792.77@loadtest.com', '', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 77"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('67b27a1a-12fe-4b66-a0a5-0f3e65a75bbe', '5f347b10-8daa-4963-abd6-22b3fc22257a', '{"sub":"5f347b10-8daa-4963-abd6-22b3fc22257a","email":"teste.1770407502837.7792.77@loadtest.com","email_verified":true}', 'email', '5f347b10-8daa-4963-abd6-22b3fc22257a', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 77', cpf = '10000000077', phone = '11900000077', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '5f347b10-8daa-4963-abd6-22b3fc22257a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '5f347b10-8daa-4963-abd6-22b3fc22257a';

-- Teste Usuario 53 (teste.1770407502820.3572.53@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('88bfc278-9869-4243-8919-065304a66dcd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502820.3572.53@loadtest.com', '', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 53"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9f103acd-cf7d-46b7-bf10-695f2a2922eb', '88bfc278-9869-4243-8919-065304a66dcd', '{"sub":"88bfc278-9869-4243-8919-065304a66dcd","email":"teste.1770407502820.3572.53@loadtest.com","email_verified":true}', 'email', '88bfc278-9869-4243-8919-065304a66dcd', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:10.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 53', cpf = '10000000053', phone = '11900000053', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '88bfc278-9869-4243-8919-065304a66dcd';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '88bfc278-9869-4243-8919-065304a66dcd';

-- Teste Usuario 50 (teste.1770407502816.7977.50@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('52879576-c8d8-4df1-945f-26f1794dcf70', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502816.7977.50@loadtest.com', '', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 50"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5117d155-034a-4a84-8d3a-9f46e8e7e404', '52879576-c8d8-4df1-945f-26f1794dcf70', '{"sub":"52879576-c8d8-4df1-945f-26f1794dcf70","email":"teste.1770407502816.7977.50@loadtest.com","email_verified":true}', 'email', '52879576-c8d8-4df1-945f-26f1794dcf70', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 50', cpf = '10000000050', phone = '11900000050', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '52879576-c8d8-4df1-945f-26f1794dcf70';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '52879576-c8d8-4df1-945f-26f1794dcf70';

-- Teste Usuario 56 (teste.1770407502822.3591.56@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('af7be88a-a93c-4089-9062-25c9769c2303', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502822.3591.56@loadtest.com', '', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 56"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('171c7115-ed8f-4005-ada1-27bb67e94d79', 'af7be88a-a93c-4089-9062-25c9769c2303', '{"sub":"af7be88a-a93c-4089-9062-25c9769c2303","email":"teste.1770407502822.3591.56@loadtest.com","email_verified":true}', 'email', 'af7be88a-a93c-4089-9062-25c9769c2303', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:11.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 56', cpf = '10000000056', phone = '11900000056', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'af7be88a-a93c-4089-9062-25c9769c2303';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'af7be88a-a93c-4089-9062-25c9769c2303';

-- Teste Usuario 91 (teste.1770407502848.3271.91@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ae08aac3-f19f-4750-b2b2-73c0e0310604', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502848.3271.91@loadtest.com', '', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 91"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d477e777-3b4d-4c9d-b67f-546d09aa1393', 'ae08aac3-f19f-4750-b2b2-73c0e0310604', '{"sub":"ae08aac3-f19f-4750-b2b2-73c0e0310604","email":"teste.1770407502848.3271.91@loadtest.com","email_verified":true}', 'email', 'ae08aac3-f19f-4750-b2b2-73c0e0310604', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 91', cpf = '10000000091', phone = '11900000091', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ae08aac3-f19f-4750-b2b2-73c0e0310604';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ae08aac3-f19f-4750-b2b2-73c0e0310604';

-- Teste Usuario 54 (teste.1770407502820.7427.54@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('df53b0fe-7993-44fe-bfd6-f3221064b7e7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502820.7427.54@loadtest.com', '', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 54"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('583b3411-e0ef-41f4-a8b7-c4786f7123ef', 'df53b0fe-7993-44fe-bfd6-f3221064b7e7', '{"sub":"df53b0fe-7993-44fe-bfd6-f3221064b7e7","email":"teste.1770407502820.7427.54@loadtest.com","email_verified":true}', 'email', 'df53b0fe-7993-44fe-bfd6-f3221064b7e7', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:12.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 54', cpf = '10000000054', phone = '11900000054', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'df53b0fe-7993-44fe-bfd6-f3221064b7e7';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'df53b0fe-7993-44fe-bfd6-f3221064b7e7';

-- Teste Usuario 36 (teste.1770407502806.7146.36@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9d7c92f5-da32-4e96-9463-e0122b645271', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502806.7146.36@loadtest.com', '', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 36"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('520d7f1d-f951-4862-8ced-169bb45372f8', '9d7c92f5-da32-4e96-9463-e0122b645271', '{"sub":"9d7c92f5-da32-4e96-9463-e0122b645271","email":"teste.1770407502806.7146.36@loadtest.com","email_verified":true}', 'email', '9d7c92f5-da32-4e96-9463-e0122b645271', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 36', cpf = '10000000036', phone = '11900000036', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9d7c92f5-da32-4e96-9463-e0122b645271';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9d7c92f5-da32-4e96-9463-e0122b645271';

-- Teste Usuario 58 (teste.1770407502823.5604.58@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c55a6960-1916-4b33-a5b2-f63d8dc753ec', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502823.5604.58@loadtest.com', '', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 58"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('94b2fd95-c167-4208-b03f-a7984c92c86c', 'c55a6960-1916-4b33-a5b2-f63d8dc753ec', '{"sub":"c55a6960-1916-4b33-a5b2-f63d8dc753ec","email":"teste.1770407502823.5604.58@loadtest.com","email_verified":true}', 'email', 'c55a6960-1916-4b33-a5b2-f63d8dc753ec', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 58', cpf = '10000000058', phone = '11900000058', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c55a6960-1916-4b33-a5b2-f63d8dc753ec';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c55a6960-1916-4b33-a5b2-f63d8dc753ec';

-- Teste Usuario 49 (teste.1770407502815.8109.49@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6c9a54b8-3f0f-467e-876b-a63b058dd7ee', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502815.8109.49@loadtest.com', '', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 49"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e8a1e603-e4d8-4ce4-b00a-9a041aa59088', '6c9a54b8-3f0f-467e-876b-a63b058dd7ee', '{"sub":"6c9a54b8-3f0f-467e-876b-a63b058dd7ee","email":"teste.1770407502815.8109.49@loadtest.com","email_verified":true}', 'email', '6c9a54b8-3f0f-467e-876b-a63b058dd7ee', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 49', cpf = '10000000049', phone = '11900000049', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '6c9a54b8-3f0f-467e-876b-a63b058dd7ee';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '6c9a54b8-3f0f-467e-876b-a63b058dd7ee';

-- Teste Usuario 66 (teste.1770407502829.7652.66@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5ea700e2-160f-46e2-9ee6-4cab312aa31f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502829.7652.66@loadtest.com', '', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 66"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0095ac6c-99e4-464c-9546-fc5f55620bb3', '5ea700e2-160f-46e2-9ee6-4cab312aa31f', '{"sub":"5ea700e2-160f-46e2-9ee6-4cab312aa31f","email":"teste.1770407502829.7652.66@loadtest.com","email_verified":true}', 'email', '5ea700e2-160f-46e2-9ee6-4cab312aa31f', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 66', cpf = '10000000066', phone = '11900000066', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '5ea700e2-160f-46e2-9ee6-4cab312aa31f';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '5ea700e2-160f-46e2-9ee6-4cab312aa31f';

-- Teste Usuario 69 (teste.1770407502831.8929.69@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8a4d96d3-efeb-4064-ae04-494131008bc3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502831.8929.69@loadtest.com', '', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 69"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9e1f9ce5-5d48-40d4-802a-af2d51afff10', '8a4d96d3-efeb-4064-ae04-494131008bc3', '{"sub":"8a4d96d3-efeb-4064-ae04-494131008bc3","email":"teste.1770407502831.8929.69@loadtest.com","email_verified":true}', 'email', '8a4d96d3-efeb-4064-ae04-494131008bc3', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:14.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 69', cpf = '10000000069', phone = '11900000069', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '8a4d96d3-efeb-4064-ae04-494131008bc3';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '8a4d96d3-efeb-4064-ae04-494131008bc3';

-- Teste Usuario 68 (teste.1770407502830.6365.68@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b789abc7-32fc-43df-bf63-b624823c982e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502830.6365.68@loadtest.com', '', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 68"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('551dfb97-df66-442c-8c30-9dba3df1deef', 'b789abc7-32fc-43df-bf63-b624823c982e', '{"sub":"b789abc7-32fc-43df-bf63-b624823c982e","email":"teste.1770407502830.6365.68@loadtest.com","email_verified":true}', 'email', 'b789abc7-32fc-43df-bf63-b624823c982e', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 68', cpf = '10000000068', phone = '11900000068', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'b789abc7-32fc-43df-bf63-b624823c982e';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'b789abc7-32fc-43df-bf63-b624823c982e';

-- Teste Usuario 93 (teste.1770407502849.6833.93@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dd3e424b-3724-45bd-86f6-830b9d984ca7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502849.6833.93@loadtest.com', '', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 93"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('40611a86-5183-4b3e-8de4-af830da63644', 'dd3e424b-3724-45bd-86f6-830b9d984ca7', '{"sub":"dd3e424b-3724-45bd-86f6-830b9d984ca7","email":"teste.1770407502849.6833.93@loadtest.com","email_verified":true}', 'email', 'dd3e424b-3724-45bd-86f6-830b9d984ca7', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:15.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 93', cpf = '10000000093', phone = '11900000093', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'dd3e424b-3724-45bd-86f6-830b9d984ca7';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'dd3e424b-3724-45bd-86f6-830b9d984ca7';

-- Teste Usuario 96 (teste.1770407502852.4811.96@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ba0c5a8f-f1ed-4f91-a938-81d2e00474dc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502852.4811.96@loadtest.com', '', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 96"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('56bc2795-42e7-4fe2-a615-9ced848208ec', 'ba0c5a8f-f1ed-4f91-a938-81d2e00474dc', '{"sub":"ba0c5a8f-f1ed-4f91-a938-81d2e00474dc","email":"teste.1770407502852.4811.96@loadtest.com","email_verified":true}', 'email', 'ba0c5a8f-f1ed-4f91-a938-81d2e00474dc', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 96', cpf = '10000000096', phone = '11900000096', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ba0c5a8f-f1ed-4f91-a938-81d2e00474dc';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ba0c5a8f-f1ed-4f91-a938-81d2e00474dc';

-- Teste Usuario 57 (teste.1770407502822.2671.57@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a06c474a-b2c2-4c49-8f43-28be6cb072c8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502822.2671.57@loadtest.com', '', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 57"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dd0181ed-5a64-4f28-8727-8a9ec93f0635', 'a06c474a-b2c2-4c49-8f43-28be6cb072c8', '{"sub":"a06c474a-b2c2-4c49-8f43-28be6cb072c8","email":"teste.1770407502822.2671.57@loadtest.com","email_verified":true}', 'email', 'a06c474a-b2c2-4c49-8f43-28be6cb072c8', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:16.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 57', cpf = '10000000057', phone = '11900000057', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a06c474a-b2c2-4c49-8f43-28be6cb072c8';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a06c474a-b2c2-4c49-8f43-28be6cb072c8';

-- Teste Usuario 64 (teste.1770407502828.3342.64@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('446e3e6b-735b-4c01-b5d7-b7b25f97c41f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502828.3342.64@loadtest.com', '', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 64"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('67d82cc8-e572-4bd1-b04d-7c9322bf50bd', '446e3e6b-735b-4c01-b5d7-b7b25f97c41f', '{"sub":"446e3e6b-735b-4c01-b5d7-b7b25f97c41f","email":"teste.1770407502828.3342.64@loadtest.com","email_verified":true}', 'email', '446e3e6b-735b-4c01-b5d7-b7b25f97c41f', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 64', cpf = '10000000064', phone = '11900000064', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '446e3e6b-735b-4c01-b5d7-b7b25f97c41f';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '446e3e6b-735b-4c01-b5d7-b7b25f97c41f';

-- Teste Usuario 76 (teste.1770407502836.5557.76@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0c9933cb-1874-44d1-9c99-242eab7dac2b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502836.5557.76@loadtest.com', '', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 76"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1dc8d42d-b940-4bbf-a1f4-75923641e5a1', '0c9933cb-1874-44d1-9c99-242eab7dac2b', '{"sub":"0c9933cb-1874-44d1-9c99-242eab7dac2b","email":"teste.1770407502836.5557.76@loadtest.com","email_verified":true}', 'email', '0c9933cb-1874-44d1-9c99-242eab7dac2b', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 76', cpf = '10000000076', phone = '11900000076', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '0c9933cb-1874-44d1-9c99-242eab7dac2b';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '0c9933cb-1874-44d1-9c99-242eab7dac2b';

-- Teste Usuario 78 (teste.1770407502838.1172.78@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('da21642e-15a8-4a42-a6cb-574133904d31', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502838.1172.78@loadtest.com', '', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 78"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('62c5db60-094a-4350-9533-0dbf8af40488', 'da21642e-15a8-4a42-a6cb-574133904d31', '{"sub":"da21642e-15a8-4a42-a6cb-574133904d31","email":"teste.1770407502838.1172.78@loadtest.com","email_verified":true}', 'email', 'da21642e-15a8-4a42-a6cb-574133904d31', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:17.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 78', cpf = '10000000078', phone = '11900000078', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'da21642e-15a8-4a42-a6cb-574133904d31';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'da21642e-15a8-4a42-a6cb-574133904d31';

-- Teste Usuario 71 (teste.1770407502833.6207.71@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('caf650f1-e91c-46f6-9ceb-cae598590797', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502833.6207.71@loadtest.com', '', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 71"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3821c947-74c9-4763-9127-64ef80990e3c', 'caf650f1-e91c-46f6-9ceb-cae598590797', '{"sub":"caf650f1-e91c-46f6-9ceb-cae598590797","email":"teste.1770407502833.6207.71@loadtest.com","email_verified":true}', 'email', 'caf650f1-e91c-46f6-9ceb-cae598590797', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 71', cpf = '10000000071', phone = '11900000071', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'caf650f1-e91c-46f6-9ceb-cae598590797';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'caf650f1-e91c-46f6-9ceb-cae598590797';

-- Teste Usuario 39 (teste.1770407502808.6910.39@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('88ce51ba-8a03-459b-981b-fc28adcd3079', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502808.6910.39@loadtest.com', '', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 39"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('99bf3b04-d933-4934-8a1e-18a61174339c', '88ce51ba-8a03-459b-981b-fc28adcd3079', '{"sub":"88ce51ba-8a03-459b-981b-fc28adcd3079","email":"teste.1770407502808.6910.39@loadtest.com","email_verified":true}', 'email', '88ce51ba-8a03-459b-981b-fc28adcd3079', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:18.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 39', cpf = '10000000039', phone = '11900000039', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '88ce51ba-8a03-459b-981b-fc28adcd3079';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '88ce51ba-8a03-459b-981b-fc28adcd3079';

-- Teste Usuario 41 (teste.1770407502809.9820.41@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d85e61d6-d09a-4438-a376-40930c8baf33', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502809.9820.41@loadtest.com', '', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 41"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('df5313fd-0f63-4099-9cfb-a4e979f9da0b', 'd85e61d6-d09a-4438-a376-40930c8baf33', '{"sub":"d85e61d6-d09a-4438-a376-40930c8baf33","email":"teste.1770407502809.9820.41@loadtest.com","email_verified":true}', 'email', 'd85e61d6-d09a-4438-a376-40930c8baf33', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 41', cpf = '10000000041', phone = '11900000041', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd85e61d6-d09a-4438-a376-40930c8baf33';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd85e61d6-d09a-4438-a376-40930c8baf33';

-- Teste Usuario 72 (teste.1770407502833.5914.72@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fedb3580-7c94-429b-af9f-516e44747248', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502833.5914.72@loadtest.com', '', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 72"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('acc66a19-5035-414d-b6d3-35006ebaf655', 'fedb3580-7c94-429b-af9f-516e44747248', '{"sub":"fedb3580-7c94-429b-af9f-516e44747248","email":"teste.1770407502833.5914.72@loadtest.com","email_verified":true}', 'email', 'fedb3580-7c94-429b-af9f-516e44747248', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:19.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 72', cpf = '10000000072', phone = '11900000072', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'fedb3580-7c94-429b-af9f-516e44747248';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'fedb3580-7c94-429b-af9f-516e44747248';

-- Teste Usuario 67 (teste.1770407502830.2584.67@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('93af5920-08b2-4989-992f-057a79d0243a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502830.2584.67@loadtest.com', '', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 67"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9b1ef299-6d78-457c-89f8-1447a72f76b6', '93af5920-08b2-4989-992f-057a79d0243a', '{"sub":"93af5920-08b2-4989-992f-057a79d0243a","email":"teste.1770407502830.2584.67@loadtest.com","email_verified":true}', 'email', '93af5920-08b2-4989-992f-057a79d0243a', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 67', cpf = '10000000067', phone = '11900000067', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '93af5920-08b2-4989-992f-057a79d0243a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '93af5920-08b2-4989-992f-057a79d0243a';

-- Teste Usuario 73 (teste.1770407502834.8835.73@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4d9567f4-fe98-4694-a928-eea3090985d0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502834.8835.73@loadtest.com', '', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 73"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7a620bcd-ce4f-4853-85b6-875b2b60a3c9', '4d9567f4-fe98-4694-a928-eea3090985d0', '{"sub":"4d9567f4-fe98-4694-a928-eea3090985d0","email":"teste.1770407502834.8835.73@loadtest.com","email_verified":true}', 'email', '4d9567f4-fe98-4694-a928-eea3090985d0', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 73', cpf = '10000000073', phone = '11900000073', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4d9567f4-fe98-4694-a928-eea3090985d0';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4d9567f4-fe98-4694-a928-eea3090985d0';

-- Teste Usuario 83 (teste.1770407502843.5992.83@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('86337600-8529-42f8-85c7-8bdcf7e8e86d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502843.5992.83@loadtest.com', '', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 83"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5f4fc047-1f19-4dad-a5f7-ea78fbead2ed', '86337600-8529-42f8-85c7-8bdcf7e8e86d', '{"sub":"86337600-8529-42f8-85c7-8bdcf7e8e86d","email":"teste.1770407502843.5992.83@loadtest.com","email_verified":true}', 'email', '86337600-8529-42f8-85c7-8bdcf7e8e86d', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 83', cpf = '10000000083', phone = '11900000083', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '86337600-8529-42f8-85c7-8bdcf7e8e86d';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '86337600-8529-42f8-85c7-8bdcf7e8e86d';

-- Teste Usuario 43 (teste.1770407502811.3994.43@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a17aaafe-fdf1-473f-b372-eac1897ab8c6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502811.3994.43@loadtest.com', '', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 43"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cf32a921-ec34-4d42-b9ee-b07313676f58', 'a17aaafe-fdf1-473f-b372-eac1897ab8c6', '{"sub":"a17aaafe-fdf1-473f-b372-eac1897ab8c6","email":"teste.1770407502811.3994.43@loadtest.com","email_verified":true}', 'email', 'a17aaafe-fdf1-473f-b372-eac1897ab8c6', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 43', cpf = '10000000043', phone = '11900000043', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a17aaafe-fdf1-473f-b372-eac1897ab8c6';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a17aaafe-fdf1-473f-b372-eac1897ab8c6';

-- Teste Usuario 62 (teste.1770407502826.6293.62@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c6e6dc08-4ad2-4a87-876f-4ffbfbb5932c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502826.6293.62@loadtest.com', '', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 62"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('45ce0096-8e58-4d39-92f0-82c34c2abe20', 'c6e6dc08-4ad2-4a87-876f-4ffbfbb5932c', '{"sub":"c6e6dc08-4ad2-4a87-876f-4ffbfbb5932c","email":"teste.1770407502826.6293.62@loadtest.com","email_verified":true}', 'email', 'c6e6dc08-4ad2-4a87-876f-4ffbfbb5932c', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:21.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 62', cpf = '10000000062', phone = '11900000062', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c6e6dc08-4ad2-4a87-876f-4ffbfbb5932c';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c6e6dc08-4ad2-4a87-876f-4ffbfbb5932c';

-- Teste Usuario 52 (teste.1770407502819.622.52@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('75344b90-07ee-4008-b873-28f15acc4d1a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502819.622.52@loadtest.com', '', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 52"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f7bb498a-0139-462d-a465-ddcb15dafbd6', '75344b90-07ee-4008-b873-28f15acc4d1a', '{"sub":"75344b90-07ee-4008-b873-28f15acc4d1a","email":"teste.1770407502819.622.52@loadtest.com","email_verified":true}', 'email', '75344b90-07ee-4008-b873-28f15acc4d1a', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 52', cpf = '10000000052', phone = '11900000052', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '75344b90-07ee-4008-b873-28f15acc4d1a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '75344b90-07ee-4008-b873-28f15acc4d1a';

-- Teste Usuario 81 (teste.1770407502840.9087.81@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dbe3554e-6ed5-42a1-94cc-487714369bbb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502840.9087.81@loadtest.com', '', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 81"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('16397e01-e0c9-4c5d-ab83-23be11ac4900', 'dbe3554e-6ed5-42a1-94cc-487714369bbb', '{"sub":"dbe3554e-6ed5-42a1-94cc-487714369bbb","email":"teste.1770407502840.9087.81@loadtest.com","email_verified":true}', 'email', 'dbe3554e-6ed5-42a1-94cc-487714369bbb', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:22.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 81', cpf = '10000000081', phone = '11900000081', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'dbe3554e-6ed5-42a1-94cc-487714369bbb';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'dbe3554e-6ed5-42a1-94cc-487714369bbb';

-- Teste Usuario 86 (teste.1770407502845.1246.86@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('676c611e-de70-4352-a0ef-bac599bfc951', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502845.1246.86@loadtest.com', '', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 86"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fb07ae8d-ba8e-406d-85d5-d50182b130d6', '676c611e-de70-4352-a0ef-bac599bfc951', '{"sub":"676c611e-de70-4352-a0ef-bac599bfc951","email":"teste.1770407502845.1246.86@loadtest.com","email_verified":true}', 'email', '676c611e-de70-4352-a0ef-bac599bfc951', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 86', cpf = '10000000086', phone = '11900000086', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '676c611e-de70-4352-a0ef-bac599bfc951';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '676c611e-de70-4352-a0ef-bac599bfc951';

-- Teste Usuario 74 (teste.1770407502835.7276.74@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('512bac95-2d85-42a6-9e40-2a6e81397b70', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502835.7276.74@loadtest.com', '', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 74"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('33a2ecae-96ad-47a8-8db6-91def724d2b3', '512bac95-2d85-42a6-9e40-2a6e81397b70', '{"sub":"512bac95-2d85-42a6-9e40-2a6e81397b70","email":"teste.1770407502835.7276.74@loadtest.com","email_verified":true}', 'email', '512bac95-2d85-42a6-9e40-2a6e81397b70', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:23.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 74', cpf = '10000000074', phone = '11900000074', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '512bac95-2d85-42a6-9e40-2a6e81397b70';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '512bac95-2d85-42a6-9e40-2a6e81397b70';

-- Teste Usuario 95 (teste.1770407502851.9235.95@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d4c515c2-db7b-4c28-a221-1d0aefb499d2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502851.9235.95@loadtest.com', '', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 95"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('78a9d5bf-ca59-4839-901f-b2483cff3a31', 'd4c515c2-db7b-4c28-a221-1d0aefb499d2', '{"sub":"d4c515c2-db7b-4c28-a221-1d0aefb499d2","email":"teste.1770407502851.9235.95@loadtest.com","email_verified":true}', 'email', 'd4c515c2-db7b-4c28-a221-1d0aefb499d2', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 95', cpf = '10000000095', phone = '11900000095', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd4c515c2-db7b-4c28-a221-1d0aefb499d2';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd4c515c2-db7b-4c28-a221-1d0aefb499d2';

-- Teste Usuario 94 (teste.1770407502850.4530.94@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('99d6acc6-01b2-4dfa-9d7b-17b41dc48f11', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502850.4530.94@loadtest.com', '', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 94"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('18e4b1f8-c514-4b60-9ba5-4d50c0241712', '99d6acc6-01b2-4dfa-9d7b-17b41dc48f11', '{"sub":"99d6acc6-01b2-4dfa-9d7b-17b41dc48f11","email":"teste.1770407502850.4530.94@loadtest.com","email_verified":true}', 'email', '99d6acc6-01b2-4dfa-9d7b-17b41dc48f11', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 94', cpf = '10000000094', phone = '11900000094', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '99d6acc6-01b2-4dfa-9d7b-17b41dc48f11';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '99d6acc6-01b2-4dfa-9d7b-17b41dc48f11';

-- Teste Usuario 84 (teste.1770407502843.6905.84@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('994a4c08-2c96-432d-a18a-e6b6417b323b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502843.6905.84@loadtest.com', '', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 84"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('280fe549-38b2-4f5e-97be-a62602dd81b4', '994a4c08-2c96-432d-a18a-e6b6417b323b', '{"sub":"994a4c08-2c96-432d-a18a-e6b6417b323b","email":"teste.1770407502843.6905.84@loadtest.com","email_verified":true}', 'email', '994a4c08-2c96-432d-a18a-e6b6417b323b', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:24.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 84', cpf = '10000000084', phone = '11900000084', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '994a4c08-2c96-432d-a18a-e6b6417b323b';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '994a4c08-2c96-432d-a18a-e6b6417b323b';

-- Teste Usuario 35 (teste.1770407502805.4344.35@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5a2d4f95-fb67-4834-8541-aaa8c7f81cbd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502805.4344.35@loadtest.com', '', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 35"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cf8bb735-6d1c-405e-8901-bd7117428008', '5a2d4f95-fb67-4834-8541-aaa8c7f81cbd', '{"sub":"5a2d4f95-fb67-4834-8541-aaa8c7f81cbd","email":"teste.1770407502805.4344.35@loadtest.com","email_verified":true}', 'email', '5a2d4f95-fb67-4834-8541-aaa8c7f81cbd', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 35', cpf = '10000000035', phone = '11900000035', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '5a2d4f95-fb67-4834-8541-aaa8c7f81cbd';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '5a2d4f95-fb67-4834-8541-aaa8c7f81cbd';

-- Teste Usuario 87 (teste.1770407502845.4977.87@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7f9f6983-542a-4b26-bc69-c3a036419dbb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502845.4977.87@loadtest.com', '', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 87"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('90453ed7-6db2-4958-8e70-ff9821247448', '7f9f6983-542a-4b26-bc69-c3a036419dbb', '{"sub":"7f9f6983-542a-4b26-bc69-c3a036419dbb","email":"teste.1770407502845.4977.87@loadtest.com","email_verified":true}', 'email', '7f9f6983-542a-4b26-bc69-c3a036419dbb', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:25.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 87', cpf = '10000000087', phone = '11900000087', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '7f9f6983-542a-4b26-bc69-c3a036419dbb';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '7f9f6983-542a-4b26-bc69-c3a036419dbb';

-- Teste Usuario 89 (teste.1770407502847.5521.89@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3469784a-c0cb-4cac-96a9-f41306ac259a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502847.5521.89@loadtest.com', '', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 89"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2b97aea0-5051-407c-97ca-489581ef2fcc', '3469784a-c0cb-4cac-96a9-f41306ac259a', '{"sub":"3469784a-c0cb-4cac-96a9-f41306ac259a","email":"teste.1770407502847.5521.89@loadtest.com","email_verified":true}', 'email', '3469784a-c0cb-4cac-96a9-f41306ac259a', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 89', cpf = '10000000089', phone = '11900000089', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '3469784a-c0cb-4cac-96a9-f41306ac259a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '3469784a-c0cb-4cac-96a9-f41306ac259a';

-- Teste Usuario 63 (teste.1770407502827.3784.63@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c8f2a211-fb51-499c-93fa-6534bcf4a81d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502827.3784.63@loadtest.com', '', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 63"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ece1f683-6508-4109-9428-a4f6a6244562', 'c8f2a211-fb51-499c-93fa-6534bcf4a81d', '{"sub":"c8f2a211-fb51-499c-93fa-6534bcf4a81d","email":"teste.1770407502827.3784.63@loadtest.com","email_verified":true}', 'email', 'c8f2a211-fb51-499c-93fa-6534bcf4a81d', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:26.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 63', cpf = '10000000063', phone = '11900000063', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c8f2a211-fb51-499c-93fa-6534bcf4a81d';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c8f2a211-fb51-499c-93fa-6534bcf4a81d';

-- Teste Usuario 98 (teste.1770407502853.9817.98@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9717fb6b-5b65-4b26-8d30-3bbdbef0fec4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502853.9817.98@loadtest.com', '', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 98"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('58bb5d74-7720-44dd-9939-e4373bc8fed6', '9717fb6b-5b65-4b26-8d30-3bbdbef0fec4', '{"sub":"9717fb6b-5b65-4b26-8d30-3bbdbef0fec4","email":"teste.1770407502853.9817.98@loadtest.com","email_verified":true}', 'email', '9717fb6b-5b65-4b26-8d30-3bbdbef0fec4', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 98', cpf = '10000000098', phone = '11900000098', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9717fb6b-5b65-4b26-8d30-3bbdbef0fec4';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9717fb6b-5b65-4b26-8d30-3bbdbef0fec4';

-- Teste Usuario 97 (teste.1770407502852.2289.97@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('94c834fa-8fc6-488e-b004-63d5e53d2e70', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502852.2289.97@loadtest.com', '', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 97"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('508eb84a-b419-419d-a42e-af5280e1c812', '94c834fa-8fc6-488e-b004-63d5e53d2e70', '{"sub":"94c834fa-8fc6-488e-b004-63d5e53d2e70","email":"teste.1770407502852.2289.97@loadtest.com","email_verified":true}', 'email', '94c834fa-8fc6-488e-b004-63d5e53d2e70', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 97', cpf = '10000000097', phone = '11900000097', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '94c834fa-8fc6-488e-b004-63d5e53d2e70';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '94c834fa-8fc6-488e-b004-63d5e53d2e70';

-- Teste Usuario 88 (teste.1770407502846.2061.88@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9d3b82b8-accc-445c-b9c7-c3022649a0c4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502846.2061.88@loadtest.com', '', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 88"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b9902a50-cf4e-4a3c-af9a-267929a4364f', '9d3b82b8-accc-445c-b9c7-c3022649a0c4', '{"sub":"9d3b82b8-accc-445c-b9c7-c3022649a0c4","email":"teste.1770407502846.2061.88@loadtest.com","email_verified":true}', 'email', '9d3b82b8-accc-445c-b9c7-c3022649a0c4', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:27.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 88', cpf = '10000000088', phone = '11900000088', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9d3b82b8-accc-445c-b9c7-c3022649a0c4';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9d3b82b8-accc-445c-b9c7-c3022649a0c4';

-- Teste Usuario 99 (teste.1770407502854.7936.99@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8ad53027-ebf9-4191-aaad-bc10fd921f28', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502854.7936.99@loadtest.com', '', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 99"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('06e68d5e-0682-490a-b331-affd569d5858', '8ad53027-ebf9-4191-aaad-bc10fd921f28', '{"sub":"8ad53027-ebf9-4191-aaad-bc10fd921f28","email":"teste.1770407502854.7936.99@loadtest.com","email_verified":true}', 'email', '8ad53027-ebf9-4191-aaad-bc10fd921f28', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 99', cpf = '10000000099', phone = '11900000099', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '8ad53027-ebf9-4191-aaad-bc10fd921f28';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '8ad53027-ebf9-4191-aaad-bc10fd921f28';

-- Teste Usuario 60 (teste.1770407502825.8057.60@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('65394d12-80cd-466e-82a7-6eff5344bbb5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502825.8057.60@loadtest.com', '', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 60"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2e61273e-399c-4f2a-aec4-d92d201ca6f5', '65394d12-80cd-466e-82a7-6eff5344bbb5', '{"sub":"65394d12-80cd-466e-82a7-6eff5344bbb5","email":"teste.1770407502825.8057.60@loadtest.com","email_verified":true}', 'email', '65394d12-80cd-466e-82a7-6eff5344bbb5', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:28.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 60', cpf = '10000000060', phone = '11900000060', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '65394d12-80cd-466e-82a7-6eff5344bbb5';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '65394d12-80cd-466e-82a7-6eff5344bbb5';

-- Teste Usuario 80 (teste.1770407502839.4597.80@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2db35a8c-e3b4-46d2-ae51-61019ca9ffad', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502839.4597.80@loadtest.com', '', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 80"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('bf158d0b-bc17-4c62-9129-75c26ba83a42', '2db35a8c-e3b4-46d2-ae51-61019ca9ffad', '{"sub":"2db35a8c-e3b4-46d2-ae51-61019ca9ffad","email":"teste.1770407502839.4597.80@loadtest.com","email_verified":true}', 'email', '2db35a8c-e3b4-46d2-ae51-61019ca9ffad', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 80', cpf = '10000000080', phone = '11900000080', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '2db35a8c-e3b4-46d2-ae51-61019ca9ffad';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '2db35a8c-e3b4-46d2-ae51-61019ca9ffad';

-- Teste Usuario 92 (teste.1770407502849.994.92@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2fed9371-8030-47ee-87c4-43964fb72b50', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502849.994.92@loadtest.com', '', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 92"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d09c2243-d15d-477f-94a9-d09d0d0c455f', '2fed9371-8030-47ee-87c4-43964fb72b50', '{"sub":"2fed9371-8030-47ee-87c4-43964fb72b50","email":"teste.1770407502849.994.92@loadtest.com","email_verified":true}', 'email', '2fed9371-8030-47ee-87c4-43964fb72b50', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:29.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 92', cpf = '10000000092', phone = '11900000092', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '2fed9371-8030-47ee-87c4-43964fb72b50';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '2fed9371-8030-47ee-87c4-43964fb72b50';

-- Teste Usuario 90 (teste.1770407502847.5668.90@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('67ef1332-b53d-47d4-b1e5-c574928715d6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502847.5668.90@loadtest.com', '', '2026-02-06T22:52:29.000Z', '2026-02-06T22:52:29.000Z', '2026-02-06T22:52:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 90"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8f7cc696-9fae-4102-8521-42eea1669b07', '67ef1332-b53d-47d4-b1e5-c574928715d6', '{"sub":"67ef1332-b53d-47d4-b1e5-c574928715d6","email":"teste.1770407502847.5668.90@loadtest.com","email_verified":true}', 'email', '67ef1332-b53d-47d4-b1e5-c574928715d6', '2026-02-06T22:52:29.000Z', '2026-02-06T22:52:29.000Z', '2026-02-06T22:52:29.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 90', cpf = '10000000090', phone = '11900000090', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '67ef1332-b53d-47d4-b1e5-c574928715d6';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '67ef1332-b53d-47d4-b1e5-c574928715d6';

-- Teste Usuario 3 (teste.1770407690211.1531.3@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1b9fcc3b-7b28-4c51-9699-4ebe42658e8c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690211.1531.3@loadtest.com', '', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 3"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b0876a01-b18a-43e1-ae30-c40f935ea4d6', '1b9fcc3b-7b28-4c51-9699-4ebe42658e8c', '{"sub":"1b9fcc3b-7b28-4c51-9699-4ebe42658e8c","email":"teste.1770407690211.1531.3@loadtest.com","email_verified":true}', 'email', '1b9fcc3b-7b28-4c51-9699-4ebe42658e8c', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 3', cpf = '10000000003', phone = '11900000003', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1b9fcc3b-7b28-4c51-9699-4ebe42658e8c';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1b9fcc3b-7b28-4c51-9699-4ebe42658e8c';

-- Teste Usuario 4 (teste.1770407690212.586.4@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('06e6a752-d682-4394-b7ae-9a83fd100f94', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690212.586.4@loadtest.com', '', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 4"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('de5f9c04-d16f-42ed-9cb0-c71e2e1cf6cd', '06e6a752-d682-4394-b7ae-9a83fd100f94', '{"sub":"06e6a752-d682-4394-b7ae-9a83fd100f94","email":"teste.1770407690212.586.4@loadtest.com","email_verified":true}', 'email', '06e6a752-d682-4394-b7ae-9a83fd100f94', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:54.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 4', cpf = '10000000004', phone = '11900000004', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '06e6a752-d682-4394-b7ae-9a83fd100f94';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '06e6a752-d682-4394-b7ae-9a83fd100f94';

-- Teste Usuario 37 (teste.1770407690243.8803.37@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2d562173-1039-4bcd-b973-ddd3f2547cec', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690243.8803.37@loadtest.com', '', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 37"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2201f69e-78d1-4bf0-a295-e117f74a6e4f', '2d562173-1039-4bcd-b973-ddd3f2547cec', '{"sub":"2d562173-1039-4bcd-b973-ddd3f2547cec","email":"teste.1770407690243.8803.37@loadtest.com","email_verified":true}', 'email', '2d562173-1039-4bcd-b973-ddd3f2547cec', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 37', cpf = '10000000037', phone = '11900000037', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '2d562173-1039-4bcd-b973-ddd3f2547cec';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '2d562173-1039-4bcd-b973-ddd3f2547cec';

-- Teste Usuario 2 (teste.1770407690209.3334.2@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a930c3b7-c9ca-4095-b640-4628a305d608', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690209.3334.2@loadtest.com', '', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 2"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c25b4958-a8a5-4ac0-8ff9-de9a1c0f249f', 'a930c3b7-c9ca-4095-b640-4628a305d608', '{"sub":"a930c3b7-c9ca-4095-b640-4628a305d608","email":"teste.1770407690209.3334.2@loadtest.com","email_verified":true}', 'email', 'a930c3b7-c9ca-4095-b640-4628a305d608', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 2', cpf = '10000000002', phone = '11900000002', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a930c3b7-c9ca-4095-b640-4628a305d608';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a930c3b7-c9ca-4095-b640-4628a305d608';

-- Teste Usuario 26 (teste.1770407690235.1067.26@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4864b7ce-552e-4aea-867e-ee4481f0423a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690235.1067.26@loadtest.com', '', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 26"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9ebb290e-9a85-4046-9f91-13bfc8c0325e', '4864b7ce-552e-4aea-867e-ee4481f0423a', '{"sub":"4864b7ce-552e-4aea-867e-ee4481f0423a","email":"teste.1770407690235.1067.26@loadtest.com","email_verified":true}', 'email', '4864b7ce-552e-4aea-867e-ee4481f0423a', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 26', cpf = '10000000026', phone = '11900000026', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4864b7ce-552e-4aea-867e-ee4481f0423a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4864b7ce-552e-4aea-867e-ee4481f0423a';

-- Teste Usuario 15 (teste.1770407690227.6234.15@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b38abf89-f140-417d-8cce-3fa61c06dd76', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690227.6234.15@loadtest.com', '', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 15"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f17b9291-8dbc-4271-a52b-86508f8272a2', 'b38abf89-f140-417d-8cce-3fa61c06dd76', '{"sub":"b38abf89-f140-417d-8cce-3fa61c06dd76","email":"teste.1770407690227.6234.15@loadtest.com","email_verified":true}', 'email', 'b38abf89-f140-417d-8cce-3fa61c06dd76', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 15', cpf = '10000000015', phone = '11900000015', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'b38abf89-f140-417d-8cce-3fa61c06dd76';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'b38abf89-f140-417d-8cce-3fa61c06dd76';

-- Teste Usuario 35 (teste.1770407690241.4133.35@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c6a70ee6-114b-4c52-8ec8-75b56cccae5f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690241.4133.35@loadtest.com', '', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 35"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('70a45d7d-02b4-40fa-a05b-0428469d1fcc', 'c6a70ee6-114b-4c52-8ec8-75b56cccae5f', '{"sub":"c6a70ee6-114b-4c52-8ec8-75b56cccae5f","email":"teste.1770407690241.4133.35@loadtest.com","email_verified":true}', 'email', 'c6a70ee6-114b-4c52-8ec8-75b56cccae5f', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:56.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 35', cpf = '10000000035', phone = '11900000035', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c6a70ee6-114b-4c52-8ec8-75b56cccae5f';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c6a70ee6-114b-4c52-8ec8-75b56cccae5f';

-- Teste Usuario 79 (teste.1770407690276.7795.79@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('51761dbe-6d5e-4d09-a840-41cf037b7376', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690276.7795.79@loadtest.com', '', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 79"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c980f286-dc08-4ecb-9043-0b605ea64be7', '51761dbe-6d5e-4d09-a840-41cf037b7376', '{"sub":"51761dbe-6d5e-4d09-a840-41cf037b7376","email":"teste.1770407690276.7795.79@loadtest.com","email_verified":true}', 'email', '51761dbe-6d5e-4d09-a840-41cf037b7376', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 79', cpf = '10000000079', phone = '11900000079', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '51761dbe-6d5e-4d09-a840-41cf037b7376';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '51761dbe-6d5e-4d09-a840-41cf037b7376';

-- Teste Usuario 6 (teste.1770407690215.2245.6@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1ebcd88e-590e-4792-af48-6dd7098daa7e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690215.2245.6@loadtest.com', '', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 6"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('47dcc4de-210d-4c7e-88c1-7e795f507a2d', '1ebcd88e-590e-4792-af48-6dd7098daa7e', '{"sub":"1ebcd88e-590e-4792-af48-6dd7098daa7e","email":"teste.1770407690215.2245.6@loadtest.com","email_verified":true}', 'email', '1ebcd88e-590e-4792-af48-6dd7098daa7e', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:57.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 6', cpf = '10000000006', phone = '11900000006', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1ebcd88e-590e-4792-af48-6dd7098daa7e';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1ebcd88e-590e-4792-af48-6dd7098daa7e';

-- Teste Usuario 38 (teste.1770407690244.3322.38@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ba0369db-224e-4c7e-a6af-2bc109b6e33d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690244.3322.38@loadtest.com', '', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 38"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('369660e1-651a-496a-b2c1-c764cb41fa97', 'ba0369db-224e-4c7e-a6af-2bc109b6e33d', '{"sub":"ba0369db-224e-4c7e-a6af-2bc109b6e33d","email":"teste.1770407690244.3322.38@loadtest.com","email_verified":true}', 'email', 'ba0369db-224e-4c7e-a6af-2bc109b6e33d', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 38', cpf = '10000000038', phone = '11900000038', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ba0369db-224e-4c7e-a6af-2bc109b6e33d';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ba0369db-224e-4c7e-a6af-2bc109b6e33d';

-- Teste Usuario 7 (teste.1770407690216.9743.7@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('97629cd0-c538-45d0-b2f2-7fa6479d0149', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690216.9743.7@loadtest.com', '', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 7"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ccdd85b3-a680-4cd9-9a40-0d13f07b9c6d', '97629cd0-c538-45d0-b2f2-7fa6479d0149', '{"sub":"97629cd0-c538-45d0-b2f2-7fa6479d0149","email":"teste.1770407690216.9743.7@loadtest.com","email_verified":true}', 'email', '97629cd0-c538-45d0-b2f2-7fa6479d0149', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:58.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 7', cpf = '10000000007', phone = '11900000007', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '97629cd0-c538-45d0-b2f2-7fa6479d0149';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '97629cd0-c538-45d0-b2f2-7fa6479d0149';

-- Teste Usuario 16 (teste.1770407690227.9576.16@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('adf04198-31cc-4360-9bf1-1e8165baf1f7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690227.9576.16@loadtest.com', '', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 16"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7598750c-e6ed-49c1-ba2f-45abf711913e', 'adf04198-31cc-4360-9bf1-1e8165baf1f7', '{"sub":"adf04198-31cc-4360-9bf1-1e8165baf1f7","email":"teste.1770407690227.9576.16@loadtest.com","email_verified":true}', 'email', 'adf04198-31cc-4360-9bf1-1e8165baf1f7', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 16', cpf = '10000000016', phone = '11900000016', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'adf04198-31cc-4360-9bf1-1e8165baf1f7';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'adf04198-31cc-4360-9bf1-1e8165baf1f7';

-- Teste Usuario 9 (teste.1770407690219.4381.9@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('885dfa03-58c5-44e5-a11e-926e6a98fbd0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690219.4381.9@loadtest.com', '', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 9"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4ee3c0ae-bb4e-47d8-8b68-cb22d3b8a2bf', '885dfa03-58c5-44e5-a11e-926e6a98fbd0', '{"sub":"885dfa03-58c5-44e5-a11e-926e6a98fbd0","email":"teste.1770407690219.4381.9@loadtest.com","email_verified":true}', 'email', '885dfa03-58c5-44e5-a11e-926e6a98fbd0', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 9', cpf = '10000000009', phone = '11900000009', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '885dfa03-58c5-44e5-a11e-926e6a98fbd0';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '885dfa03-58c5-44e5-a11e-926e6a98fbd0';

-- Teste Usuario 17 (teste.1770407690228.9114.17@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fcc522f8-8c8a-400e-830f-d4897251d5ac', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690228.9114.17@loadtest.com', '', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 17"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1161e659-d183-4edb-a5db-7c30cbc094f6', 'fcc522f8-8c8a-400e-830f-d4897251d5ac', '{"sub":"fcc522f8-8c8a-400e-830f-d4897251d5ac","email":"teste.1770407690228.9114.17@loadtest.com","email_verified":true}', 'email', 'fcc522f8-8c8a-400e-830f-d4897251d5ac', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:59.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 17', cpf = '10000000017', phone = '11900000017', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'fcc522f8-8c8a-400e-830f-d4897251d5ac';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'fcc522f8-8c8a-400e-830f-d4897251d5ac';

-- Teste Usuario 5 (teste.1770407690214.3263.5@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('44a4d7f2-966f-4da3-b29e-555e66e93bac', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690214.3263.5@loadtest.com', '', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 5"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ec907f99-1cb7-4e51-bbcd-e5643a7dd7d6', '44a4d7f2-966f-4da3-b29e-555e66e93bac', '{"sub":"44a4d7f2-966f-4da3-b29e-555e66e93bac","email":"teste.1770407690214.3263.5@loadtest.com","email_verified":true}', 'email', '44a4d7f2-966f-4da3-b29e-555e66e93bac', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 5', cpf = '10000000005', phone = '11900000005', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '44a4d7f2-966f-4da3-b29e-555e66e93bac';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '44a4d7f2-966f-4da3-b29e-555e66e93bac';

-- Teste Usuario 8 (teste.1770407690217.3651.8@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3452d9cc-41c6-46b4-b502-0464cd789285', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690217.3651.8@loadtest.com', '', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 8"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('769948ea-dbbf-4130-bea6-9e32b3c58825', '3452d9cc-41c6-46b4-b502-0464cd789285', '{"sub":"3452d9cc-41c6-46b4-b502-0464cd789285","email":"teste.1770407690217.3651.8@loadtest.com","email_verified":true}', 'email', '3452d9cc-41c6-46b4-b502-0464cd789285', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z', '2026-02-06T22:55:00.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 8', cpf = '10000000008', phone = '11900000008', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '3452d9cc-41c6-46b4-b502-0464cd789285';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '3452d9cc-41c6-46b4-b502-0464cd789285';

-- Teste Usuario 11 (teste.1770407690223.2026.11@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bf478d63-9372-4d53-a538-7bbb3dcbe010', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690223.2026.11@loadtest.com', '', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 11"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('65f8b08c-aa78-4a9d-9dd2-ad22dcb1f2ab', 'bf478d63-9372-4d53-a538-7bbb3dcbe010', '{"sub":"bf478d63-9372-4d53-a538-7bbb3dcbe010","email":"teste.1770407690223.2026.11@loadtest.com","email_verified":true}', 'email', 'bf478d63-9372-4d53-a538-7bbb3dcbe010', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 11', cpf = '10000000011', phone = '11900000011', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'bf478d63-9372-4d53-a538-7bbb3dcbe010';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'bf478d63-9372-4d53-a538-7bbb3dcbe010';

-- Teste Usuario 23 (teste.1770407690232.3655.23@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6ef53b8d-57a7-4a19-a07f-5d6d1da59300', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690232.3655.23@loadtest.com', '', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 23"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4662972c-39a6-4080-97e3-f354c0d5c3b3', '6ef53b8d-57a7-4a19-a07f-5d6d1da59300', '{"sub":"6ef53b8d-57a7-4a19-a07f-5d6d1da59300","email":"teste.1770407690232.3655.23@loadtest.com","email_verified":true}', 'email', '6ef53b8d-57a7-4a19-a07f-5d6d1da59300', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:01.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 23', cpf = '10000000023', phone = '11900000023', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '6ef53b8d-57a7-4a19-a07f-5d6d1da59300';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '6ef53b8d-57a7-4a19-a07f-5d6d1da59300';

-- Teste Usuario 13 (teste.1770407690225.8671.13@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1244b92c-8272-4b24-a761-c704afbb9e7d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690225.8671.13@loadtest.com', '', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 13"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ae4d9124-c634-4870-895b-1148e76a235c', '1244b92c-8272-4b24-a761-c704afbb9e7d', '{"sub":"1244b92c-8272-4b24-a761-c704afbb9e7d","email":"teste.1770407690225.8671.13@loadtest.com","email_verified":true}', 'email', '1244b92c-8272-4b24-a761-c704afbb9e7d', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 13', cpf = '10000000013', phone = '11900000013', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1244b92c-8272-4b24-a761-c704afbb9e7d';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1244b92c-8272-4b24-a761-c704afbb9e7d';

-- Teste Usuario 14 (teste.1770407690226.6602.14@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a071a373-7f2d-46c9-9781-68d637b1683c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690226.6602.14@loadtest.com', '', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 14"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('84b3ebb7-6dd7-4356-9308-ba02837fa5e3', 'a071a373-7f2d-46c9-9781-68d637b1683c', '{"sub":"a071a373-7f2d-46c9-9781-68d637b1683c","email":"teste.1770407690226.6602.14@loadtest.com","email_verified":true}', 'email', 'a071a373-7f2d-46c9-9781-68d637b1683c', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:02.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 14', cpf = '10000000014', phone = '11900000014', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a071a373-7f2d-46c9-9781-68d637b1683c';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a071a373-7f2d-46c9-9781-68d637b1683c';

-- Teste Usuario 1 (teste.1770407690133.9371.1@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4c8fa2cc-1814-469a-b859-d30fec5789a4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690133.9371.1@loadtest.com', '', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 1"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('751f979f-ce37-4278-b5bd-100443c75116', '4c8fa2cc-1814-469a-b859-d30fec5789a4', '{"sub":"4c8fa2cc-1814-469a-b859-d30fec5789a4","email":"teste.1770407690133.9371.1@loadtest.com","email_verified":true}', 'email', '4c8fa2cc-1814-469a-b859-d30fec5789a4', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 1', cpf = '10000000001', phone = '11900000001', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4c8fa2cc-1814-469a-b859-d30fec5789a4';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4c8fa2cc-1814-469a-b859-d30fec5789a4';

-- Teste Usuario 12 (teste.1770407690224.7187.12@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('57424ef5-6e94-47c7-b4dd-c990dafac6b9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690224.7187.12@loadtest.com', '', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 12"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0cac381e-74be-421f-94a2-e61d336a9cf2', '57424ef5-6e94-47c7-b4dd-c990dafac6b9', '{"sub":"57424ef5-6e94-47c7-b4dd-c990dafac6b9","email":"teste.1770407690224.7187.12@loadtest.com","email_verified":true}', 'email', '57424ef5-6e94-47c7-b4dd-c990dafac6b9', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:03.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 12', cpf = '10000000012', phone = '11900000012', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '57424ef5-6e94-47c7-b4dd-c990dafac6b9';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '57424ef5-6e94-47c7-b4dd-c990dafac6b9';

-- Teste Usuario 10 (teste.1770407690222.1109.10@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('47ed1d9f-17d8-49c1-ab2a-625903b19881', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690222.1109.10@loadtest.com', '', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 10"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('07216643-daba-4f50-8b88-354a8b68912a', '47ed1d9f-17d8-49c1-ab2a-625903b19881', '{"sub":"47ed1d9f-17d8-49c1-ab2a-625903b19881","email":"teste.1770407690222.1109.10@loadtest.com","email_verified":true}', 'email', '47ed1d9f-17d8-49c1-ab2a-625903b19881', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 10', cpf = '10000000010', phone = '11900000010', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '47ed1d9f-17d8-49c1-ab2a-625903b19881';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '47ed1d9f-17d8-49c1-ab2a-625903b19881';

-- Teste Usuario 18 (teste.1770407690229.7066.18@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('21a20fb5-f6ae-484f-b6f4-c43baf1dfedb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690229.7066.18@loadtest.com', '', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 18"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2a642dff-474f-4f78-b0d0-6e118e6c0564', '21a20fb5-f6ae-484f-b6f4-c43baf1dfedb', '{"sub":"21a20fb5-f6ae-484f-b6f4-c43baf1dfedb","email":"teste.1770407690229.7066.18@loadtest.com","email_verified":true}', 'email', '21a20fb5-f6ae-484f-b6f4-c43baf1dfedb', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 18', cpf = '10000000018', phone = '11900000018', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '21a20fb5-f6ae-484f-b6f4-c43baf1dfedb';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '21a20fb5-f6ae-484f-b6f4-c43baf1dfedb';

-- Teste Usuario 24 (teste.1770407690233.7493.24@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bc6fd430-976f-4989-a65f-01720fdecd75', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690233.7493.24@loadtest.com', '', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 24"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cdd6941b-d0e0-4e07-8a34-02bf107cbd0a', 'bc6fd430-976f-4989-a65f-01720fdecd75', '{"sub":"bc6fd430-976f-4989-a65f-01720fdecd75","email":"teste.1770407690233.7493.24@loadtest.com","email_verified":true}', 'email', 'bc6fd430-976f-4989-a65f-01720fdecd75', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:04.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 24', cpf = '10000000024', phone = '11900000024', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'bc6fd430-976f-4989-a65f-01720fdecd75';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'bc6fd430-976f-4989-a65f-01720fdecd75';

-- Teste Usuario 30 (teste.1770407690238.2076.30@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f134fc1a-f2c0-442a-82c4-f104adc12ae3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690238.2076.30@loadtest.com', '', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 30"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('43051f97-8e4a-4d23-a836-bc91617a4e05', 'f134fc1a-f2c0-442a-82c4-f104adc12ae3', '{"sub":"f134fc1a-f2c0-442a-82c4-f104adc12ae3","email":"teste.1770407690238.2076.30@loadtest.com","email_verified":true}', 'email', 'f134fc1a-f2c0-442a-82c4-f104adc12ae3', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 30', cpf = '10000000030', phone = '11900000030', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'f134fc1a-f2c0-442a-82c4-f104adc12ae3';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'f134fc1a-f2c0-442a-82c4-f104adc12ae3';

-- Teste Usuario 21 (teste.1770407690231.9376.21@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('eb8311e1-c842-4076-8dd2-15ec96574e3e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690231.9376.21@loadtest.com', '', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 21"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1b5cf49d-466a-47c4-ba57-a0ed222f7b77', 'eb8311e1-c842-4076-8dd2-15ec96574e3e', '{"sub":"eb8311e1-c842-4076-8dd2-15ec96574e3e","email":"teste.1770407690231.9376.21@loadtest.com","email_verified":true}', 'email', 'eb8311e1-c842-4076-8dd2-15ec96574e3e', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:05.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 21', cpf = '10000000021', phone = '11900000021', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'eb8311e1-c842-4076-8dd2-15ec96574e3e';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'eb8311e1-c842-4076-8dd2-15ec96574e3e';

-- Teste Usuario 29 (teste.1770407690237.9313.29@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('41678193-c974-43cb-b18d-a3ac86611862', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690237.9313.29@loadtest.com', '', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 29"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1b3b2ca9-6005-41af-8717-ee90421e7d50', '41678193-c974-43cb-b18d-a3ac86611862', '{"sub":"41678193-c974-43cb-b18d-a3ac86611862","email":"teste.1770407690237.9313.29@loadtest.com","email_verified":true}', 'email', '41678193-c974-43cb-b18d-a3ac86611862', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 29', cpf = '10000000029', phone = '11900000029', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '41678193-c974-43cb-b18d-a3ac86611862';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '41678193-c974-43cb-b18d-a3ac86611862';

-- Teste Usuario 25 (teste.1770407690234.1856.25@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6aac75ee-e2df-4885-b96c-fe13116ed8ac', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690234.1856.25@loadtest.com', '', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 25"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('55eb62a0-89f3-4a41-b66a-e91e7c9dfdd9', '6aac75ee-e2df-4885-b96c-fe13116ed8ac', '{"sub":"6aac75ee-e2df-4885-b96c-fe13116ed8ac","email":"teste.1770407690234.1856.25@loadtest.com","email_verified":true}', 'email', '6aac75ee-e2df-4885-b96c-fe13116ed8ac', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:06.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 25', cpf = '10000000025', phone = '11900000025', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '6aac75ee-e2df-4885-b96c-fe13116ed8ac';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '6aac75ee-e2df-4885-b96c-fe13116ed8ac';

-- Teste Usuario 19 (teste.1770407690230.669.19@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('852b851a-0ed3-42ea-b4d5-1fe7f26de1ce', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690230.669.19@loadtest.com', '', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 19"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7aaa0b51-9331-4e7f-b84c-9366e52b7688', '852b851a-0ed3-42ea-b4d5-1fe7f26de1ce', '{"sub":"852b851a-0ed3-42ea-b4d5-1fe7f26de1ce","email":"teste.1770407690230.669.19@loadtest.com","email_verified":true}', 'email', '852b851a-0ed3-42ea-b4d5-1fe7f26de1ce', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 19', cpf = '10000000019', phone = '11900000019', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '852b851a-0ed3-42ea-b4d5-1fe7f26de1ce';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '852b851a-0ed3-42ea-b4d5-1fe7f26de1ce';

-- Teste Usuario 33 (teste.1770407690240.3703.33@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('03e2f1ec-0bbd-4545-817a-5c1604935876', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690240.3703.33@loadtest.com', '', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 33"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dcf787d8-4250-4ba5-9775-14cceccebf6d', '03e2f1ec-0bbd-4545-817a-5c1604935876', '{"sub":"03e2f1ec-0bbd-4545-817a-5c1604935876","email":"teste.1770407690240.3703.33@loadtest.com","email_verified":true}', 'email', '03e2f1ec-0bbd-4545-817a-5c1604935876', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 33', cpf = '10000000033', phone = '11900000033', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '03e2f1ec-0bbd-4545-817a-5c1604935876';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '03e2f1ec-0bbd-4545-817a-5c1604935876';

-- Teste Usuario 34 (teste.1770407690241.5217.34@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5c2343a8-0169-4071-990b-d4a44e170431', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690241.5217.34@loadtest.com', '', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 34"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e29da3e4-ee42-43da-9d8a-63cae700deca', '5c2343a8-0169-4071-990b-d4a44e170431', '{"sub":"5c2343a8-0169-4071-990b-d4a44e170431","email":"teste.1770407690241.5217.34@loadtest.com","email_verified":true}', 'email', '5c2343a8-0169-4071-990b-d4a44e170431', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 34', cpf = '10000000034', phone = '11900000034', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '5c2343a8-0169-4071-990b-d4a44e170431';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '5c2343a8-0169-4071-990b-d4a44e170431';

-- Teste Usuario 20 (teste.1770407690230.664.20@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b33e278c-00c0-44d0-9df6-f66b5d4c486d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690230.664.20@loadtest.com', '', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 20"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9bb10b5f-302b-47ff-a47d-a5bd863fe486', 'b33e278c-00c0-44d0-9df6-f66b5d4c486d', '{"sub":"b33e278c-00c0-44d0-9df6-f66b5d4c486d","email":"teste.1770407690230.664.20@loadtest.com","email_verified":true}', 'email', 'b33e278c-00c0-44d0-9df6-f66b5d4c486d', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 20', cpf = '10000000020', phone = '11900000020', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'b33e278c-00c0-44d0-9df6-f66b5d4c486d';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'b33e278c-00c0-44d0-9df6-f66b5d4c486d';

-- Teste Usuario 27 (teste.1770407690235.9352.27@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('43b115bd-7252-40d4-a6e9-26fd5ee8beb8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690235.9352.27@loadtest.com', '', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 27"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c70ed502-310f-470f-9ab1-3d8901b6771c', '43b115bd-7252-40d4-a6e9-26fd5ee8beb8', '{"sub":"43b115bd-7252-40d4-a6e9-26fd5ee8beb8","email":"teste.1770407690235.9352.27@loadtest.com","email_verified":true}', 'email', '43b115bd-7252-40d4-a6e9-26fd5ee8beb8', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:08.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 27', cpf = '10000000027', phone = '11900000027', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '43b115bd-7252-40d4-a6e9-26fd5ee8beb8';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '43b115bd-7252-40d4-a6e9-26fd5ee8beb8';

-- Teste Usuario 59 (teste.1770407690261.2597.59@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d9e419ca-b006-458f-9d24-5c03f3141073', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690261.2597.59@loadtest.com', '', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 59"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8b319b0d-36b3-432c-b883-bde483c2448b', 'd9e419ca-b006-458f-9d24-5c03f3141073', '{"sub":"d9e419ca-b006-458f-9d24-5c03f3141073","email":"teste.1770407690261.2597.59@loadtest.com","email_verified":true}', 'email', 'd9e419ca-b006-458f-9d24-5c03f3141073', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 59', cpf = '10000000059', phone = '11900000059', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd9e419ca-b006-458f-9d24-5c03f3141073';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd9e419ca-b006-458f-9d24-5c03f3141073';

-- Teste Usuario 47 (teste.1770407690250.1441.47@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bbf9db02-ae2d-4030-b449-5fd1202a0fc6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690250.1441.47@loadtest.com', '', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 47"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8ffb3e06-daa9-4e19-ba72-581446c6cb3e', 'bbf9db02-ae2d-4030-b449-5fd1202a0fc6', '{"sub":"bbf9db02-ae2d-4030-b449-5fd1202a0fc6","email":"teste.1770407690250.1441.47@loadtest.com","email_verified":true}', 'email', 'bbf9db02-ae2d-4030-b449-5fd1202a0fc6', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:09.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 47', cpf = '10000000047', phone = '11900000047', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'bbf9db02-ae2d-4030-b449-5fd1202a0fc6';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'bbf9db02-ae2d-4030-b449-5fd1202a0fc6';

-- Teste Usuario 36 (teste.1770407690242.5416.36@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('458adcc0-fc7d-4eab-8034-77d45978c1c6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690242.5416.36@loadtest.com', '', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 36"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('90dd4a4e-e8a9-4a16-9101-f283a93cc320', '458adcc0-fc7d-4eab-8034-77d45978c1c6', '{"sub":"458adcc0-fc7d-4eab-8034-77d45978c1c6","email":"teste.1770407690242.5416.36@loadtest.com","email_verified":true}', 'email', '458adcc0-fc7d-4eab-8034-77d45978c1c6', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 36', cpf = '10000000036', phone = '11900000036', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '458adcc0-fc7d-4eab-8034-77d45978c1c6';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '458adcc0-fc7d-4eab-8034-77d45978c1c6';

-- Teste Usuario 28 (teste.1770407690236.9777.28@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('42ab47e7-fae7-4db6-a3ef-4bfb324a0be2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690236.9777.28@loadtest.com', '', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 28"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('94337ba9-6c85-4a9c-b929-89884f20d970', '42ab47e7-fae7-4db6-a3ef-4bfb324a0be2', '{"sub":"42ab47e7-fae7-4db6-a3ef-4bfb324a0be2","email":"teste.1770407690236.9777.28@loadtest.com","email_verified":true}', 'email', '42ab47e7-fae7-4db6-a3ef-4bfb324a0be2', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:10.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 28', cpf = '10000000028', phone = '11900000028', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '42ab47e7-fae7-4db6-a3ef-4bfb324a0be2';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '42ab47e7-fae7-4db6-a3ef-4bfb324a0be2';

-- Teste Usuario 39 (teste.1770407690244.4796.39@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0071b282-d549-45b2-90ac-7c96c6b1eda9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690244.4796.39@loadtest.com', '', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 39"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('33518210-9af5-4803-a0cd-f7366bb8f70b', '0071b282-d549-45b2-90ac-7c96c6b1eda9', '{"sub":"0071b282-d549-45b2-90ac-7c96c6b1eda9","email":"teste.1770407690244.4796.39@loadtest.com","email_verified":true}', 'email', '0071b282-d549-45b2-90ac-7c96c6b1eda9', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 39', cpf = '10000000039', phone = '11900000039', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '0071b282-d549-45b2-90ac-7c96c6b1eda9';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '0071b282-d549-45b2-90ac-7c96c6b1eda9';

-- Teste Usuario 60 (teste.1770407690262.4676.60@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ec7b70d7-7f5a-4694-9ac3-b556e81db039', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690262.4676.60@loadtest.com', '', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 60"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('94b7dd09-354f-41b1-80d6-e2fe15187deb', 'ec7b70d7-7f5a-4694-9ac3-b556e81db039', '{"sub":"ec7b70d7-7f5a-4694-9ac3-b556e81db039","email":"teste.1770407690262.4676.60@loadtest.com","email_verified":true}', 'email', 'ec7b70d7-7f5a-4694-9ac3-b556e81db039', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 60', cpf = '10000000060', phone = '11900000060', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ec7b70d7-7f5a-4694-9ac3-b556e81db039';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ec7b70d7-7f5a-4694-9ac3-b556e81db039';

-- Teste Usuario 52 (teste.1770407690256.6181.52@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d464505e-75ea-4404-82d3-63c8fb05a5d4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690256.6181.52@loadtest.com', '', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 52"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e64edeba-55f9-4119-a106-9255f6ed71f2', 'd464505e-75ea-4404-82d3-63c8fb05a5d4', '{"sub":"d464505e-75ea-4404-82d3-63c8fb05a5d4","email":"teste.1770407690256.6181.52@loadtest.com","email_verified":true}', 'email', 'd464505e-75ea-4404-82d3-63c8fb05a5d4', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:11.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 52', cpf = '10000000052', phone = '11900000052', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd464505e-75ea-4404-82d3-63c8fb05a5d4';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd464505e-75ea-4404-82d3-63c8fb05a5d4';

-- Teste Usuario 45 (teste.1770407690249.4124.45@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dd057469-b161-4ba5-bf0e-4a74118e971b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690249.4124.45@loadtest.com', '', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 45"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6ea4351b-8818-4c5f-908f-3ceac3b0db43', 'dd057469-b161-4ba5-bf0e-4a74118e971b', '{"sub":"dd057469-b161-4ba5-bf0e-4a74118e971b","email":"teste.1770407690249.4124.45@loadtest.com","email_verified":true}', 'email', 'dd057469-b161-4ba5-bf0e-4a74118e971b', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 45', cpf = '10000000045', phone = '11900000045', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'dd057469-b161-4ba5-bf0e-4a74118e971b';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'dd057469-b161-4ba5-bf0e-4a74118e971b';

-- Teste Usuario 48 (teste.1770407690251.2476.48@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c19d3e72-87e8-4957-b9da-61be9a214818', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690251.2476.48@loadtest.com', '', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 48"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('386e225d-4c3b-44fe-bedb-2a74fd0fbc66', 'c19d3e72-87e8-4957-b9da-61be9a214818', '{"sub":"c19d3e72-87e8-4957-b9da-61be9a214818","email":"teste.1770407690251.2476.48@loadtest.com","email_verified":true}', 'email', 'c19d3e72-87e8-4957-b9da-61be9a214818', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:12.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 48', cpf = '10000000048', phone = '11900000048', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c19d3e72-87e8-4957-b9da-61be9a214818';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c19d3e72-87e8-4957-b9da-61be9a214818';

-- Teste Usuario 49 (teste.1770407690252.6543.49@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('56652bfe-7962-426b-88ea-d44fb9288bb2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690252.6543.49@loadtest.com', '', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 49"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('65dd129f-bcc2-4cea-8993-ebd13dd95238', '56652bfe-7962-426b-88ea-d44fb9288bb2', '{"sub":"56652bfe-7962-426b-88ea-d44fb9288bb2","email":"teste.1770407690252.6543.49@loadtest.com","email_verified":true}', 'email', '56652bfe-7962-426b-88ea-d44fb9288bb2', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 49', cpf = '10000000049', phone = '11900000049', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '56652bfe-7962-426b-88ea-d44fb9288bb2';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '56652bfe-7962-426b-88ea-d44fb9288bb2';

-- Teste Usuario 62 (teste.1770407690263.5572.62@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('22cdd2b6-b277-4151-802d-417860536577', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690263.5572.62@loadtest.com', '', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 62"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4d0fa107-1d35-47f6-bf63-d55b017bd3a8', '22cdd2b6-b277-4151-802d-417860536577', '{"sub":"22cdd2b6-b277-4151-802d-417860536577","email":"teste.1770407690263.5572.62@loadtest.com","email_verified":true}', 'email', '22cdd2b6-b277-4151-802d-417860536577', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:13.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 62', cpf = '10000000062', phone = '11900000062', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '22cdd2b6-b277-4151-802d-417860536577';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '22cdd2b6-b277-4151-802d-417860536577';

-- Teste Usuario 83 (teste.1770407690279.5335.83@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a28015ea-6ac7-4d50-81ff-b5b3ae1f7c72', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690279.5335.83@loadtest.com', '', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 83"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2f56971f-a495-4830-a23e-c2a02a0bf636', 'a28015ea-6ac7-4d50-81ff-b5b3ae1f7c72', '{"sub":"a28015ea-6ac7-4d50-81ff-b5b3ae1f7c72","email":"teste.1770407690279.5335.83@loadtest.com","email_verified":true}', 'email', 'a28015ea-6ac7-4d50-81ff-b5b3ae1f7c72', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 83', cpf = '10000000083', phone = '11900000083', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a28015ea-6ac7-4d50-81ff-b5b3ae1f7c72';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a28015ea-6ac7-4d50-81ff-b5b3ae1f7c72';

-- Teste Usuario 40 (teste.1770407690245.4292.40@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('080a3db4-067b-4885-8f05-d8a948492c1a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690245.4292.40@loadtest.com', '', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 40"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('673f34bd-56b1-4220-9790-08c9286730aa', '080a3db4-067b-4885-8f05-d8a948492c1a', '{"sub":"080a3db4-067b-4885-8f05-d8a948492c1a","email":"teste.1770407690245.4292.40@loadtest.com","email_verified":true}', 'email', '080a3db4-067b-4885-8f05-d8a948492c1a', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:14.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 40', cpf = '10000000040', phone = '11900000040', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '080a3db4-067b-4885-8f05-d8a948492c1a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '080a3db4-067b-4885-8f05-d8a948492c1a';

-- Teste Usuario 41 (teste.1770407690246.9634.41@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d0b89f80-55c5-4532-8819-71269f4d6200', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690246.9634.41@loadtest.com', '', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 41"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f03a7794-204f-48fb-88d5-9dab7c8d0847', 'd0b89f80-55c5-4532-8819-71269f4d6200', '{"sub":"d0b89f80-55c5-4532-8819-71269f4d6200","email":"teste.1770407690246.9634.41@loadtest.com","email_verified":true}', 'email', 'd0b89f80-55c5-4532-8819-71269f4d6200', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 41', cpf = '10000000041', phone = '11900000041', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd0b89f80-55c5-4532-8819-71269f4d6200';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd0b89f80-55c5-4532-8819-71269f4d6200';

-- Teste Usuario 51 (teste.1770407690254.2193.51@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('81bfb552-5448-45c9-ab36-eb35c0dca237', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690254.2193.51@loadtest.com', '', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 51"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a8a562a0-fb12-4f99-b9d0-cb83792b943b', '81bfb552-5448-45c9-ab36-eb35c0dca237', '{"sub":"81bfb552-5448-45c9-ab36-eb35c0dca237","email":"teste.1770407690254.2193.51@loadtest.com","email_verified":true}', 'email', '81bfb552-5448-45c9-ab36-eb35c0dca237', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 51', cpf = '10000000051', phone = '11900000051', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '81bfb552-5448-45c9-ab36-eb35c0dca237';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '81bfb552-5448-45c9-ab36-eb35c0dca237';

-- Teste Usuario 54 (teste.1770407690257.7651.54@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f87dfe90-1dd5-4227-a3ba-5934e1d1e60d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690257.7651.54@loadtest.com', '', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 54"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9aa1ce4a-a7f8-4392-bc71-1376d42ae5e4', 'f87dfe90-1dd5-4227-a3ba-5934e1d1e60d', '{"sub":"f87dfe90-1dd5-4227-a3ba-5934e1d1e60d","email":"teste.1770407690257.7651.54@loadtest.com","email_verified":true}', 'email', 'f87dfe90-1dd5-4227-a3ba-5934e1d1e60d', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:15.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 54', cpf = '10000000054', phone = '11900000054', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'f87dfe90-1dd5-4227-a3ba-5934e1d1e60d';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'f87dfe90-1dd5-4227-a3ba-5934e1d1e60d';

-- Teste Usuario 22 (teste.1770407690232.2707.22@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('abb590fe-3e59-4814-82e9-e8c9cca07b0c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690232.2707.22@loadtest.com', '', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 22"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('09502a47-f7ae-409b-b957-fab980190fde', 'abb590fe-3e59-4814-82e9-e8c9cca07b0c', '{"sub":"abb590fe-3e59-4814-82e9-e8c9cca07b0c","email":"teste.1770407690232.2707.22@loadtest.com","email_verified":true}', 'email', 'abb590fe-3e59-4814-82e9-e8c9cca07b0c', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 22', cpf = '10000000022', phone = '11900000022', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'abb590fe-3e59-4814-82e9-e8c9cca07b0c';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'abb590fe-3e59-4814-82e9-e8c9cca07b0c';

-- Teste Usuario 55 (teste.1770407690258.7258.55@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('325659fb-88b4-48e3-afbd-68d290427850', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690258.7258.55@loadtest.com', '', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 55"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5bf652a1-0370-41da-a881-2b6b22ee10e5', '325659fb-88b4-48e3-afbd-68d290427850', '{"sub":"325659fb-88b4-48e3-afbd-68d290427850","email":"teste.1770407690258.7258.55@loadtest.com","email_verified":true}', 'email', '325659fb-88b4-48e3-afbd-68d290427850', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:16.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 55', cpf = '10000000055', phone = '11900000055', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '325659fb-88b4-48e3-afbd-68d290427850';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '325659fb-88b4-48e3-afbd-68d290427850';

-- Teste Usuario 43 (teste.1770407690247.3088.43@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3d3bb611-f3ab-4b0d-95ad-dc66d53bae33', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690247.3088.43@loadtest.com', '', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 43"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ea8c1c8f-a876-4cf2-96b6-62dd3ba01072', '3d3bb611-f3ab-4b0d-95ad-dc66d53bae33', '{"sub":"3d3bb611-f3ab-4b0d-95ad-dc66d53bae33","email":"teste.1770407690247.3088.43@loadtest.com","email_verified":true}', 'email', '3d3bb611-f3ab-4b0d-95ad-dc66d53bae33', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 43', cpf = '10000000043', phone = '11900000043', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '3d3bb611-f3ab-4b0d-95ad-dc66d53bae33';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '3d3bb611-f3ab-4b0d-95ad-dc66d53bae33';

-- Teste Usuario 76 (teste.1770407690274.1180.76@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8df5b863-1275-485e-a44c-9922dd213245', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690274.1180.76@loadtest.com', '', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 76"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5ede9ac4-3af9-4b57-b28e-87589a5d659c', '8df5b863-1275-485e-a44c-9922dd213245', '{"sub":"8df5b863-1275-485e-a44c-9922dd213245","email":"teste.1770407690274.1180.76@loadtest.com","email_verified":true}', 'email', '8df5b863-1275-485e-a44c-9922dd213245', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:17.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 76', cpf = '10000000076', phone = '11900000076', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '8df5b863-1275-485e-a44c-9922dd213245';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '8df5b863-1275-485e-a44c-9922dd213245';

-- Teste Usuario 50 (teste.1770407690253.8130.50@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7203e593-8a57-451b-8def-e8d041c9f62c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690253.8130.50@loadtest.com', '', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 50"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('688c9a28-a5d6-4f10-ba88-53fc9f64beb5', '7203e593-8a57-451b-8def-e8d041c9f62c', '{"sub":"7203e593-8a57-451b-8def-e8d041c9f62c","email":"teste.1770407690253.8130.50@loadtest.com","email_verified":true}', 'email', '7203e593-8a57-451b-8def-e8d041c9f62c', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 50', cpf = '10000000050', phone = '11900000050', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '7203e593-8a57-451b-8def-e8d041c9f62c';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '7203e593-8a57-451b-8def-e8d041c9f62c';

-- Teste Usuario 46 (teste.1770407690250.8937.46@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('07e34ee5-854d-4fca-9e60-5ac05084de5a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690250.8937.46@loadtest.com', '', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 46"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c9dfda60-8655-4c3b-a789-a4ab83dd9618', '07e34ee5-854d-4fca-9e60-5ac05084de5a', '{"sub":"07e34ee5-854d-4fca-9e60-5ac05084de5a","email":"teste.1770407690250.8937.46@loadtest.com","email_verified":true}', 'email', '07e34ee5-854d-4fca-9e60-5ac05084de5a', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 46', cpf = '10000000046', phone = '11900000046', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '07e34ee5-854d-4fca-9e60-5ac05084de5a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '07e34ee5-854d-4fca-9e60-5ac05084de5a';

-- Teste Usuario 64 (teste.1770407690265.4490.64@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ecbb0bf3-7d6d-492f-8de2-322150cf7be2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690265.4490.64@loadtest.com', '', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 64"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a359fee1-b9b8-48be-ab5f-e28cf75dfc4e', 'ecbb0bf3-7d6d-492f-8de2-322150cf7be2', '{"sub":"ecbb0bf3-7d6d-492f-8de2-322150cf7be2","email":"teste.1770407690265.4490.64@loadtest.com","email_verified":true}', 'email', 'ecbb0bf3-7d6d-492f-8de2-322150cf7be2', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:18.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 64', cpf = '10000000064', phone = '11900000064', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ecbb0bf3-7d6d-492f-8de2-322150cf7be2';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ecbb0bf3-7d6d-492f-8de2-322150cf7be2';

-- Teste Usuario 44 (teste.1770407690248.2256.44@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c9f764fe-65e3-4d2c-8a9d-058216dcf286', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690248.2256.44@loadtest.com', '', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 44"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d839fcab-c91e-42d5-9ff4-71f03705e386', 'c9f764fe-65e3-4d2c-8a9d-058216dcf286', '{"sub":"c9f764fe-65e3-4d2c-8a9d-058216dcf286","email":"teste.1770407690248.2256.44@loadtest.com","email_verified":true}', 'email', 'c9f764fe-65e3-4d2c-8a9d-058216dcf286', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 44', cpf = '10000000044', phone = '11900000044', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c9f764fe-65e3-4d2c-8a9d-058216dcf286';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c9f764fe-65e3-4d2c-8a9d-058216dcf286';

-- Teste Usuario 84 (teste.1770407690281.7460.84@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('96ff7a0b-54c1-4997-a101-be1998970592', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690281.7460.84@loadtest.com', '', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 84"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('30fb63bc-5fe5-45b1-bef6-90543ce6b092', '96ff7a0b-54c1-4997-a101-be1998970592', '{"sub":"96ff7a0b-54c1-4997-a101-be1998970592","email":"teste.1770407690281.7460.84@loadtest.com","email_verified":true}', 'email', '96ff7a0b-54c1-4997-a101-be1998970592', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:19.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 84', cpf = '10000000084', phone = '11900000084', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '96ff7a0b-54c1-4997-a101-be1998970592';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '96ff7a0b-54c1-4997-a101-be1998970592';

-- Teste Usuario 86 (teste.1770407690283.8010.86@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1a0cfa3a-c77e-4452-b76d-ef34fcd96c10', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690283.8010.86@loadtest.com', '', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 86"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('73ce0821-9cf9-4bdc-98fe-43b8eb8f4a21', '1a0cfa3a-c77e-4452-b76d-ef34fcd96c10', '{"sub":"1a0cfa3a-c77e-4452-b76d-ef34fcd96c10","email":"teste.1770407690283.8010.86@loadtest.com","email_verified":true}', 'email', '1a0cfa3a-c77e-4452-b76d-ef34fcd96c10', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 86', cpf = '10000000086', phone = '11900000086', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1a0cfa3a-c77e-4452-b76d-ef34fcd96c10';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1a0cfa3a-c77e-4452-b76d-ef34fcd96c10';

-- Teste Usuario 77 (teste.1770407690275.4523.77@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('59b7e015-6a65-4773-95a9-d8cb9734ad34', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690275.4523.77@loadtest.com', '', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 77"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6f686c96-019a-4a2e-8cfb-85e3a5709987', '59b7e015-6a65-4773-95a9-d8cb9734ad34', '{"sub":"59b7e015-6a65-4773-95a9-d8cb9734ad34","email":"teste.1770407690275.4523.77@loadtest.com","email_verified":true}', 'email', '59b7e015-6a65-4773-95a9-d8cb9734ad34', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:20.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 77', cpf = '10000000077', phone = '11900000077', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '59b7e015-6a65-4773-95a9-d8cb9734ad34';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '59b7e015-6a65-4773-95a9-d8cb9734ad34';

-- Teste Usuario 53 (teste.1770407690257.5140.53@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0b662ed5-bced-4925-a85a-5bd157469fb7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690257.5140.53@loadtest.com', '', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 53"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('17d8593f-140d-4da1-91de-90c3cd02465a', '0b662ed5-bced-4925-a85a-5bd157469fb7', '{"sub":"0b662ed5-bced-4925-a85a-5bd157469fb7","email":"teste.1770407690257.5140.53@loadtest.com","email_verified":true}', 'email', '0b662ed5-bced-4925-a85a-5bd157469fb7', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 53', cpf = '10000000053', phone = '11900000053', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '0b662ed5-bced-4925-a85a-5bd157469fb7';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '0b662ed5-bced-4925-a85a-5bd157469fb7';

-- Teste Usuario 99 (teste.1770407690293.9610.99@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ce6301ce-217f-4c12-bea6-55c529a37bf7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690293.9610.99@loadtest.com', '', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 99"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('84db2675-3b8c-4659-9f58-7f46afbf1496', 'ce6301ce-217f-4c12-bea6-55c529a37bf7', '{"sub":"ce6301ce-217f-4c12-bea6-55c529a37bf7","email":"teste.1770407690293.9610.99@loadtest.com","email_verified":true}', 'email', 'ce6301ce-217f-4c12-bea6-55c529a37bf7', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:21.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 99', cpf = '10000000099', phone = '11900000099', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ce6301ce-217f-4c12-bea6-55c529a37bf7';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ce6301ce-217f-4c12-bea6-55c529a37bf7';

-- Teste Usuario 65 (teste.1770407690266.5394.65@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ad047540-4bc0-4745-807b-a09961bdf001', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690266.5394.65@loadtest.com', '', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 65"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('07a138b4-17f9-4d72-98a9-a14ed5d15a7a', 'ad047540-4bc0-4745-807b-a09961bdf001', '{"sub":"ad047540-4bc0-4745-807b-a09961bdf001","email":"teste.1770407690266.5394.65@loadtest.com","email_verified":true}', 'email', 'ad047540-4bc0-4745-807b-a09961bdf001', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 65', cpf = '10000000065', phone = '11900000065', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ad047540-4bc0-4745-807b-a09961bdf001';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ad047540-4bc0-4745-807b-a09961bdf001';

-- Teste Usuario 89 (teste.1770407690285.707.89@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('951e29e2-4524-40fb-b1ab-b7217693bc51', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690285.707.89@loadtest.com', '', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 89"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a954b125-92e2-4e78-8515-271ade53ceb2', '951e29e2-4524-40fb-b1ab-b7217693bc51', '{"sub":"951e29e2-4524-40fb-b1ab-b7217693bc51","email":"teste.1770407690285.707.89@loadtest.com","email_verified":true}', 'email', '951e29e2-4524-40fb-b1ab-b7217693bc51', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 89', cpf = '10000000089', phone = '11900000089', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '951e29e2-4524-40fb-b1ab-b7217693bc51';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '951e29e2-4524-40fb-b1ab-b7217693bc51';

-- Teste Usuario 57 (teste.1770407690259.3613.57@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2801fdcc-e2f5-4e43-a050-7553e7312910', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690259.3613.57@loadtest.com', '', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 57"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e820927d-cd19-4b4c-b75f-ea3aeb95e710', '2801fdcc-e2f5-4e43-a050-7553e7312910', '{"sub":"2801fdcc-e2f5-4e43-a050-7553e7312910","email":"teste.1770407690259.3613.57@loadtest.com","email_verified":true}', 'email', '2801fdcc-e2f5-4e43-a050-7553e7312910', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:22.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 57', cpf = '10000000057', phone = '11900000057', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '2801fdcc-e2f5-4e43-a050-7553e7312910';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '2801fdcc-e2f5-4e43-a050-7553e7312910';

-- Teste Usuario 32 (teste.1770407690239.8981.32@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5f8a4b2e-ad7f-44b0-a0e4-bed87f989e26', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690239.8981.32@loadtest.com', '', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 32"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('78e27416-ae48-4cc5-9d56-674475c035dd', '5f8a4b2e-ad7f-44b0-a0e4-bed87f989e26', '{"sub":"5f8a4b2e-ad7f-44b0-a0e4-bed87f989e26","email":"teste.1770407690239.8981.32@loadtest.com","email_verified":true}', 'email', '5f8a4b2e-ad7f-44b0-a0e4-bed87f989e26', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 32', cpf = '10000000032', phone = '11900000032', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '5f8a4b2e-ad7f-44b0-a0e4-bed87f989e26';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '5f8a4b2e-ad7f-44b0-a0e4-bed87f989e26';

-- Teste Usuario 69 (teste.1770407690269.2108.69@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fde3838e-bc1c-4db5-8d96-b717d6a8aaf9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690269.2108.69@loadtest.com', '', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 69"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9935b2d9-7746-4d4f-a0a4-5bfda2e9f96f', 'fde3838e-bc1c-4db5-8d96-b717d6a8aaf9', '{"sub":"fde3838e-bc1c-4db5-8d96-b717d6a8aaf9","email":"teste.1770407690269.2108.69@loadtest.com","email_verified":true}', 'email', 'fde3838e-bc1c-4db5-8d96-b717d6a8aaf9', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:23.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 69', cpf = '10000000069', phone = '11900000069', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'fde3838e-bc1c-4db5-8d96-b717d6a8aaf9';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'fde3838e-bc1c-4db5-8d96-b717d6a8aaf9';

-- Teste Usuario 66 (teste.1770407690266.1306.66@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e200ed47-7306-4990-b967-2c29073315cd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690266.1306.66@loadtest.com', '', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 66"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('160cd015-c6dc-411f-a1d7-ea1d0bb2974f', 'e200ed47-7306-4990-b967-2c29073315cd', '{"sub":"e200ed47-7306-4990-b967-2c29073315cd","email":"teste.1770407690266.1306.66@loadtest.com","email_verified":true}', 'email', 'e200ed47-7306-4990-b967-2c29073315cd', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 66', cpf = '10000000066', phone = '11900000066', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'e200ed47-7306-4990-b967-2c29073315cd';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'e200ed47-7306-4990-b967-2c29073315cd';

-- Teste Usuario 58 (teste.1770407690260.2867.58@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2139b0ab-6090-45e8-93f0-4f87e58ef8fe', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690260.2867.58@loadtest.com', '', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 58"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('41b7fc95-3962-4308-b876-db363852fdf3', '2139b0ab-6090-45e8-93f0-4f87e58ef8fe', '{"sub":"2139b0ab-6090-45e8-93f0-4f87e58ef8fe","email":"teste.1770407690260.2867.58@loadtest.com","email_verified":true}', 'email', '2139b0ab-6090-45e8-93f0-4f87e58ef8fe', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:24.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 58', cpf = '10000000058', phone = '11900000058', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '2139b0ab-6090-45e8-93f0-4f87e58ef8fe';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '2139b0ab-6090-45e8-93f0-4f87e58ef8fe';

-- Teste Usuario 73 (teste.1770407690272.7699.73@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ef22c362-018c-442d-8bbb-b8c063cf2e13', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690272.7699.73@loadtest.com', '', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 73"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a62997c7-388b-4a5a-b037-404a38f9765f', 'ef22c362-018c-442d-8bbb-b8c063cf2e13', '{"sub":"ef22c362-018c-442d-8bbb-b8c063cf2e13","email":"teste.1770407690272.7699.73@loadtest.com","email_verified":true}', 'email', 'ef22c362-018c-442d-8bbb-b8c063cf2e13', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 73', cpf = '10000000073', phone = '11900000073', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ef22c362-018c-442d-8bbb-b8c063cf2e13';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ef22c362-018c-442d-8bbb-b8c063cf2e13';

-- Teste Usuario 98 (teste.1770407690292.4846.98@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4780a2ae-55aa-4052-8304-c7451c2157a6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690292.4846.98@loadtest.com', '', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 98"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b37a2d94-35de-44ab-9043-4e1cc9578b25', '4780a2ae-55aa-4052-8304-c7451c2157a6', '{"sub":"4780a2ae-55aa-4052-8304-c7451c2157a6","email":"teste.1770407690292.4846.98@loadtest.com","email_verified":true}', 'email', '4780a2ae-55aa-4052-8304-c7451c2157a6', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:25.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 98', cpf = '10000000098', phone = '11900000098', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4780a2ae-55aa-4052-8304-c7451c2157a6';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4780a2ae-55aa-4052-8304-c7451c2157a6';

-- Teste Usuario 68 (teste.1770407690268.1461.68@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a6c5d631-97de-42b6-88f0-20bd126e48e9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690268.1461.68@loadtest.com', '', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 68"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4c925b24-4576-486b-b5cb-f15f36447c4c', 'a6c5d631-97de-42b6-88f0-20bd126e48e9', '{"sub":"a6c5d631-97de-42b6-88f0-20bd126e48e9","email":"teste.1770407690268.1461.68@loadtest.com","email_verified":true}', 'email', 'a6c5d631-97de-42b6-88f0-20bd126e48e9', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 68', cpf = '10000000068', phone = '11900000068', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a6c5d631-97de-42b6-88f0-20bd126e48e9';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a6c5d631-97de-42b6-88f0-20bd126e48e9';

-- Teste Usuario 56 (teste.1770407690259.896.56@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('44bd6193-37d5-44c0-8aa1-eede677880e5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690259.896.56@loadtest.com', '', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 56"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3aace528-15b5-4a27-b246-fc1b9da75bae', '44bd6193-37d5-44c0-8aa1-eede677880e5', '{"sub":"44bd6193-37d5-44c0-8aa1-eede677880e5","email":"teste.1770407690259.896.56@loadtest.com","email_verified":true}', 'email', '44bd6193-37d5-44c0-8aa1-eede677880e5', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 56', cpf = '10000000056', phone = '11900000056', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '44bd6193-37d5-44c0-8aa1-eede677880e5';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '44bd6193-37d5-44c0-8aa1-eede677880e5';

-- Teste Usuario 78 (teste.1770407690275.2336.78@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d8f85eda-8bc1-4ed1-a56f-fa0133d2129c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690275.2336.78@loadtest.com', '', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 78"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('98495b66-0742-477b-87e8-c47feb3f02c0', 'd8f85eda-8bc1-4ed1-a56f-fa0133d2129c', '{"sub":"d8f85eda-8bc1-4ed1-a56f-fa0133d2129c","email":"teste.1770407690275.2336.78@loadtest.com","email_verified":true}', 'email', 'd8f85eda-8bc1-4ed1-a56f-fa0133d2129c', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:26.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 78', cpf = '10000000078', phone = '11900000078', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd8f85eda-8bc1-4ed1-a56f-fa0133d2129c';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'd8f85eda-8bc1-4ed1-a56f-fa0133d2129c';

-- Teste Usuario 90 (teste.1770407690286.1329.90@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('de8f678a-83fb-4320-b06c-1e705bf4f7be', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690286.1329.90@loadtest.com', '', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 90"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('23f1149e-e40d-409a-b529-b96f3d130f60', 'de8f678a-83fb-4320-b06c-1e705bf4f7be', '{"sub":"de8f678a-83fb-4320-b06c-1e705bf4f7be","email":"teste.1770407690286.1329.90@loadtest.com","email_verified":true}', 'email', 'de8f678a-83fb-4320-b06c-1e705bf4f7be', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 90', cpf = '10000000090', phone = '11900000090', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'de8f678a-83fb-4320-b06c-1e705bf4f7be';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'de8f678a-83fb-4320-b06c-1e705bf4f7be';

-- Teste Usuario 70 (teste.1770407690269.3864.70@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0aad460e-7291-49e5-b77b-0360ed7cbcab', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690269.3864.70@loadtest.com', '', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 70"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a409a559-d6fe-485d-892f-73e773955e19', '0aad460e-7291-49e5-b77b-0360ed7cbcab', '{"sub":"0aad460e-7291-49e5-b77b-0360ed7cbcab","email":"teste.1770407690269.3864.70@loadtest.com","email_verified":true}', 'email', '0aad460e-7291-49e5-b77b-0360ed7cbcab', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:27.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 70', cpf = '10000000070', phone = '11900000070', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '0aad460e-7291-49e5-b77b-0360ed7cbcab';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '0aad460e-7291-49e5-b77b-0360ed7cbcab';

-- Teste Usuario 67 (teste.1770407690267.8922.67@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('eed3b1cf-3af1-4e72-8440-6c2569179391', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690267.8922.67@loadtest.com', '', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 67"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e1ffc8a6-1ada-4d42-9120-51720bbaef3a', 'eed3b1cf-3af1-4e72-8440-6c2569179391', '{"sub":"eed3b1cf-3af1-4e72-8440-6c2569179391","email":"teste.1770407690267.8922.67@loadtest.com","email_verified":true}', 'email', 'eed3b1cf-3af1-4e72-8440-6c2569179391', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 67', cpf = '10000000067', phone = '11900000067', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'eed3b1cf-3af1-4e72-8440-6c2569179391';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'eed3b1cf-3af1-4e72-8440-6c2569179391';

-- Teste Usuario 88 (teste.1770407690284.5400.88@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ef370f05-c61d-4a43-aa5d-69d386684fa5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690284.5400.88@loadtest.com', '', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 88"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1813aa88-4b86-4421-9961-6420d13a8e18', 'ef370f05-c61d-4a43-aa5d-69d386684fa5', '{"sub":"ef370f05-c61d-4a43-aa5d-69d386684fa5","email":"teste.1770407690284.5400.88@loadtest.com","email_verified":true}', 'email', 'ef370f05-c61d-4a43-aa5d-69d386684fa5', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:28.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 88', cpf = '10000000088', phone = '11900000088', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ef370f05-c61d-4a43-aa5d-69d386684fa5';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'ef370f05-c61d-4a43-aa5d-69d386684fa5';

-- Teste Usuario 87 (teste.1770407690284.3688.87@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b97e6cc0-b7c0-45f3-aaf7-afb38c00607c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690284.3688.87@loadtest.com', '', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 87"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('94feb9ea-e585-4d4f-83fc-029e8e4efe01', 'b97e6cc0-b7c0-45f3-aaf7-afb38c00607c', '{"sub":"b97e6cc0-b7c0-45f3-aaf7-afb38c00607c","email":"teste.1770407690284.3688.87@loadtest.com","email_verified":true}', 'email', 'b97e6cc0-b7c0-45f3-aaf7-afb38c00607c', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 87', cpf = '10000000087', phone = '11900000087', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'b97e6cc0-b7c0-45f3-aaf7-afb38c00607c';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'b97e6cc0-b7c0-45f3-aaf7-afb38c00607c';

-- Teste Usuario 92 (teste.1770407690288.1226.92@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('476b3c26-2ebd-4e80-b344-510696a0fcd1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690288.1226.92@loadtest.com', '', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 92"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('13f0d66e-3059-458f-a548-aaf0d812ab55', '476b3c26-2ebd-4e80-b344-510696a0fcd1', '{"sub":"476b3c26-2ebd-4e80-b344-510696a0fcd1","email":"teste.1770407690288.1226.92@loadtest.com","email_verified":true}', 'email', '476b3c26-2ebd-4e80-b344-510696a0fcd1', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:29.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 92', cpf = '10000000092', phone = '11900000092', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '476b3c26-2ebd-4e80-b344-510696a0fcd1';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '476b3c26-2ebd-4e80-b344-510696a0fcd1';

-- Teste Usuario 91 (teste.1770407690287.6472.91@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('74fb96fb-c3ca-42f7-84be-06467a16e89d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690287.6472.91@loadtest.com', '', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 91"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('870c58e6-fa6f-4d14-8804-c58233406339', '74fb96fb-c3ca-42f7-84be-06467a16e89d', '{"sub":"74fb96fb-c3ca-42f7-84be-06467a16e89d","email":"teste.1770407690287.6472.91@loadtest.com","email_verified":true}', 'email', '74fb96fb-c3ca-42f7-84be-06467a16e89d', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 91', cpf = '10000000091', phone = '11900000091', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '74fb96fb-c3ca-42f7-84be-06467a16e89d';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '74fb96fb-c3ca-42f7-84be-06467a16e89d';

-- Teste Usuario 74 (teste.1770407690272.6007.74@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a8c0cd9d-5412-40c8-902f-aab2b076b2c8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690272.6007.74@loadtest.com', '', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 74"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('15cf8f89-b1b8-4e31-8e73-405e49eb4331', 'a8c0cd9d-5412-40c8-902f-aab2b076b2c8', '{"sub":"a8c0cd9d-5412-40c8-902f-aab2b076b2c8","email":"teste.1770407690272.6007.74@loadtest.com","email_verified":true}', 'email', 'a8c0cd9d-5412-40c8-902f-aab2b076b2c8', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 74', cpf = '10000000074', phone = '11900000074', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a8c0cd9d-5412-40c8-902f-aab2b076b2c8';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a8c0cd9d-5412-40c8-902f-aab2b076b2c8';

-- Teste Usuario 81 (teste.1770407690278.7691.81@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9b9ff11d-68e3-4678-86a0-3642583973d0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690278.7691.81@loadtest.com', '', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 81"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1d0b7f75-b848-4ba9-8553-fdf1bae302fc', '9b9ff11d-68e3-4678-86a0-3642583973d0', '{"sub":"9b9ff11d-68e3-4678-86a0-3642583973d0","email":"teste.1770407690278.7691.81@loadtest.com","email_verified":true}', 'email', '9b9ff11d-68e3-4678-86a0-3642583973d0', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:30.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 81', cpf = '10000000081', phone = '11900000081', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9b9ff11d-68e3-4678-86a0-3642583973d0';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9b9ff11d-68e3-4678-86a0-3642583973d0';

-- Teste Usuario 75 (teste.1770407690273.133.75@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('19ce5538-8ff4-48f9-a45d-a84a8f03dcdd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690273.133.75@loadtest.com', '', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 75"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('198c71ec-6e59-4ed3-9249-0944edea5b13', '19ce5538-8ff4-48f9-a45d-a84a8f03dcdd', '{"sub":"19ce5538-8ff4-48f9-a45d-a84a8f03dcdd","email":"teste.1770407690273.133.75@loadtest.com","email_verified":true}', 'email', '19ce5538-8ff4-48f9-a45d-a84a8f03dcdd', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 75', cpf = '10000000075', phone = '11900000075', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '19ce5538-8ff4-48f9-a45d-a84a8f03dcdd';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '19ce5538-8ff4-48f9-a45d-a84a8f03dcdd';

-- Teste Usuario 80 (teste.1770407690277.315.80@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('926936ae-9c22-410e-a59b-b8f3c45baa1a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690277.315.80@loadtest.com', '', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 80"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('aea5c752-1aba-4946-a58d-8db5b314b725', '926936ae-9c22-410e-a59b-b8f3c45baa1a', '{"sub":"926936ae-9c22-410e-a59b-b8f3c45baa1a","email":"teste.1770407690277.315.80@loadtest.com","email_verified":true}', 'email', '926936ae-9c22-410e-a59b-b8f3c45baa1a', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:31.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 80', cpf = '10000000080', phone = '11900000080', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '926936ae-9c22-410e-a59b-b8f3c45baa1a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '926936ae-9c22-410e-a59b-b8f3c45baa1a';

-- Teste Usuario 72 (teste.1770407690271.6031.72@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a8e398af-1d04-4a80-9862-3a5220852c6b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690271.6031.72@loadtest.com', '', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 72"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d4c29a0c-c732-4288-bc51-570420d24a31', 'a8e398af-1d04-4a80-9862-3a5220852c6b', '{"sub":"a8e398af-1d04-4a80-9862-3a5220852c6b","email":"teste.1770407690271.6031.72@loadtest.com","email_verified":true}', 'email', 'a8e398af-1d04-4a80-9862-3a5220852c6b', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 72', cpf = '10000000072', phone = '11900000072', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a8e398af-1d04-4a80-9862-3a5220852c6b';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'a8e398af-1d04-4a80-9862-3a5220852c6b';

-- Teste Usuario 93 (teste.1770407690288.5286.93@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4a0a414e-25a9-47a1-9f56-1c69a56a80dd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690288.5286.93@loadtest.com', '', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 93"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('775ef483-7e9d-4f17-8654-219f4a6edf49', '4a0a414e-25a9-47a1-9f56-1c69a56a80dd', '{"sub":"4a0a414e-25a9-47a1-9f56-1c69a56a80dd","email":"teste.1770407690288.5286.93@loadtest.com","email_verified":true}', 'email', '4a0a414e-25a9-47a1-9f56-1c69a56a80dd', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:32.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 93', cpf = '10000000093', phone = '11900000093', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4a0a414e-25a9-47a1-9f56-1c69a56a80dd';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '4a0a414e-25a9-47a1-9f56-1c69a56a80dd';

-- Teste Usuario 61 (teste.1770407690263.6656.61@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c584cf4b-1848-4517-8928-e1732e16d35a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690263.6656.61@loadtest.com', '', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 61"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0068483d-07a5-4406-b1f8-52e46100dae0', 'c584cf4b-1848-4517-8928-e1732e16d35a', '{"sub":"c584cf4b-1848-4517-8928-e1732e16d35a","email":"teste.1770407690263.6656.61@loadtest.com","email_verified":true}', 'email', 'c584cf4b-1848-4517-8928-e1732e16d35a', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 61', cpf = '10000000061', phone = '11900000061', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c584cf4b-1848-4517-8928-e1732e16d35a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c584cf4b-1848-4517-8928-e1732e16d35a';

-- Teste Usuario 71 (teste.1770407690270.4469.71@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fe8af22a-7fc2-4df2-b675-e90938cdf79b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690270.4469.71@loadtest.com', '', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 71"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('35b989d1-e532-45fa-8c97-52182181ffd1', 'fe8af22a-7fc2-4df2-b675-e90938cdf79b', '{"sub":"fe8af22a-7fc2-4df2-b675-e90938cdf79b","email":"teste.1770407690270.4469.71@loadtest.com","email_verified":true}', 'email', 'fe8af22a-7fc2-4df2-b675-e90938cdf79b', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 71', cpf = '10000000071', phone = '11900000071', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'fe8af22a-7fc2-4df2-b675-e90938cdf79b';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'fe8af22a-7fc2-4df2-b675-e90938cdf79b';

-- Teste Usuario 100 (teste.1770407690293.7925.100@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('141817ec-bebe-401d-a1a5-d66a2a896599', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690293.7925.100@loadtest.com', '', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 100"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('513ebec6-37ed-46a5-b10c-3f26fdaac1f3', '141817ec-bebe-401d-a1a5-d66a2a896599', '{"sub":"141817ec-bebe-401d-a1a5-d66a2a896599","email":"teste.1770407690293.7925.100@loadtest.com","email_verified":true}', 'email', '141817ec-bebe-401d-a1a5-d66a2a896599', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:33.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 100', cpf = '10000000100', phone = '11900000100', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '141817ec-bebe-401d-a1a5-d66a2a896599';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '141817ec-bebe-401d-a1a5-d66a2a896599';

-- Teste Usuario 82 (teste.1770407690278.9123.82@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b4e3508d-20f1-4f0a-8b2c-e08a69d4811e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690278.9123.82@loadtest.com', '', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 82"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3cd1fdcf-66d4-4a40-ac52-4567339ac16e', 'b4e3508d-20f1-4f0a-8b2c-e08a69d4811e', '{"sub":"b4e3508d-20f1-4f0a-8b2c-e08a69d4811e","email":"teste.1770407690278.9123.82@loadtest.com","email_verified":true}', 'email', 'b4e3508d-20f1-4f0a-8b2c-e08a69d4811e', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 82', cpf = '10000000082', phone = '11900000082', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'b4e3508d-20f1-4f0a-8b2c-e08a69d4811e';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'b4e3508d-20f1-4f0a-8b2c-e08a69d4811e';

-- Teste Usuario 31 (teste.1770407690238.7458.31@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9bff0e4a-a512-4328-84f2-f77352e31a35', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690238.7458.31@loadtest.com', '', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 31"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dd3e30a9-8093-483b-a85d-602ab37b7c74', '9bff0e4a-a512-4328-84f2-f77352e31a35', '{"sub":"9bff0e4a-a512-4328-84f2-f77352e31a35","email":"teste.1770407690238.7458.31@loadtest.com","email_verified":true}', 'email', '9bff0e4a-a512-4328-84f2-f77352e31a35', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:34.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 31', cpf = '10000000031', phone = '11900000031', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9bff0e4a-a512-4328-84f2-f77352e31a35';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '9bff0e4a-a512-4328-84f2-f77352e31a35';

-- Teste Usuario 94 (teste.1770407690289.3187.94@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('96127c5c-3ed8-4ca3-901e-fa6859452cbd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690289.3187.94@loadtest.com', '', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 94"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4873adc0-3d11-4b5c-a129-814945c6eb84', '96127c5c-3ed8-4ca3-901e-fa6859452cbd', '{"sub":"96127c5c-3ed8-4ca3-901e-fa6859452cbd","email":"teste.1770407690289.3187.94@loadtest.com","email_verified":true}', 'email', '96127c5c-3ed8-4ca3-901e-fa6859452cbd', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 94', cpf = '10000000094', phone = '11900000094', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '96127c5c-3ed8-4ca3-901e-fa6859452cbd';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '96127c5c-3ed8-4ca3-901e-fa6859452cbd';

-- Teste Usuario 95 (teste.1770407690290.3492.95@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('30e03142-99fa-49a0-8b86-7913b022a92b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690290.3492.95@loadtest.com', '', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 95"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d3be4600-b964-425a-9e95-475570ecf99c', '30e03142-99fa-49a0-8b86-7913b022a92b', '{"sub":"30e03142-99fa-49a0-8b86-7913b022a92b","email":"teste.1770407690290.3492.95@loadtest.com","email_verified":true}', 'email', '30e03142-99fa-49a0-8b86-7913b022a92b', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:35.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 95', cpf = '10000000095', phone = '11900000095', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '30e03142-99fa-49a0-8b86-7913b022a92b';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '30e03142-99fa-49a0-8b86-7913b022a92b';

-- Teste Usuario 42 (teste.1770407690247.4761.42@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7f1540e0-13e0-4044-917f-6bac5f79574d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690247.4761.42@loadtest.com', '', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 42"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6a4efe52-240c-4643-9a51-970512b7ea35', '7f1540e0-13e0-4044-917f-6bac5f79574d', '{"sub":"7f1540e0-13e0-4044-917f-6bac5f79574d","email":"teste.1770407690247.4761.42@loadtest.com","email_verified":true}', 'email', '7f1540e0-13e0-4044-917f-6bac5f79574d', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 42', cpf = '10000000042', phone = '11900000042', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '7f1540e0-13e0-4044-917f-6bac5f79574d';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '7f1540e0-13e0-4044-917f-6bac5f79574d';

-- Teste Usuario 96 (teste.1770407690290.8948.96@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c2ba9e72-25af-490b-be86-2ac09782b93d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690290.8948.96@loadtest.com', '', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 96"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cbda67b7-8bbd-4e85-bcd6-83bd2d2e3632', 'c2ba9e72-25af-490b-be86-2ac09782b93d', '{"sub":"c2ba9e72-25af-490b-be86-2ac09782b93d","email":"teste.1770407690290.8948.96@loadtest.com","email_verified":true}', 'email', 'c2ba9e72-25af-490b-be86-2ac09782b93d', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:36.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 96', cpf = '10000000096', phone = '11900000096', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c2ba9e72-25af-490b-be86-2ac09782b93d';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c2ba9e72-25af-490b-be86-2ac09782b93d';

-- Teste Usuario 97 (teste.1770407690291.1591.97@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1841899d-201f-408a-b530-5bc0afa74c6a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690291.1591.97@loadtest.com', '', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 97"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6cd4383e-c661-4da9-898d-8590b14ef011', '1841899d-201f-408a-b530-5bc0afa74c6a', '{"sub":"1841899d-201f-408a-b530-5bc0afa74c6a","email":"teste.1770407690291.1591.97@loadtest.com","email_verified":true}', 'email', '1841899d-201f-408a-b530-5bc0afa74c6a', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 97', cpf = '10000000097', phone = '11900000097', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1841899d-201f-408a-b530-5bc0afa74c6a';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = '1841899d-201f-408a-b530-5bc0afa74c6a';

-- Teste Usuario 63 (teste.1770407690264.6182.63@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c38af540-cd58-45a4-a58e-80036873d134', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690264.6182.63@loadtest.com', '', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 63"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e7f50bd4-de81-41e8-81b8-77d18c41df4a', 'c38af540-cd58-45a4-a58e-80036873d134', '{"sub":"c38af540-cd58-45a4-a58e-80036873d134","email":"teste.1770407690264.6182.63@loadtest.com","email_verified":true}', 'email', 'c38af540-cd58-45a4-a58e-80036873d134', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 63', cpf = '10000000063', phone = '11900000063', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c38af540-cd58-45a4-a58e-80036873d134';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'c38af540-cd58-45a4-a58e-80036873d134';

-- Teste Usuario 85 (teste.1770407690282.2169.85@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('aa119293-760e-46d4-aeff-490a66989913', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690282.2169.85@loadtest.com', '', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 85"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('951b6e49-0366-44e9-98ad-991f205de4e3', 'aa119293-760e-46d4-aeff-490a66989913', '{"sub":"aa119293-760e-46d4-aeff-490a66989913","email":"teste.1770407690282.2169.85@loadtest.com","email_verified":true}', 'email', 'aa119293-760e-46d4-aeff-490a66989913', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:37.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 85', cpf = '10000000085', phone = '11900000085', company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'aa119293-760e-46d4-aeff-490a66989913';
UPDATE public.user_roles SET company_id = 'ad233833-52a6-4ec9-b0ab-1bbcf1b89f52' WHERE user_id = 'aa119293-760e-46d4-aeff-490a66989913';

-- Roberta Cantareira Cezar  (rcantareira@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bc65908c-e8a9-49fc-bf23-89e99d98cbb8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rcantareira@gmail.com', '', '2026-02-07T18:26:33.000Z', '2026-02-07T18:26:33.000Z', '2026-02-07T18:26:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Roberta Cantareira Cezar "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4367f877-376a-4fc3-838d-2ce933de07ed', 'bc65908c-e8a9-49fc-bf23-89e99d98cbb8', '{"sub":"bc65908c-e8a9-49fc-bf23-89e99d98cbb8","email":"rcantareira@gmail.com","email_verified":true}', 'email', 'bc65908c-e8a9-49fc-bf23-89e99d98cbb8', '2026-02-07T18:26:33.000Z', '2026-02-07T18:26:33.000Z', '2026-02-07T18:26:34.000Z');
UPDATE public.profiles SET name = 'Roberta Cantareira Cezar ', cpf = '28760277807', phone = '11998066070', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'bc65908c-e8a9-49fc-bf23-89e99d98cbb8';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = 'bc65908c-e8a9-49fc-bf23-89e99d98cbb8';

-- Bruna Silva  (brunarbsemijoias@com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('35ef7595-8c08-40f1-afe3-b16eb6d48412', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'brunarbsemijoias@com.br', '', '2026-02-09T21:59:14.000Z', '2026-02-09T21:59:14.000Z', '2026-02-09T21:59:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Bruna Silva "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8861e8c4-fdb5-424e-a77b-1ac98eff7a40', '35ef7595-8c08-40f1-afe3-b16eb6d48412', '{"sub":"35ef7595-8c08-40f1-afe3-b16eb6d48412","email":"brunarbsemijoias@com.br","email_verified":true}', 'email', '35ef7595-8c08-40f1-afe3-b16eb6d48412', '2026-02-09T21:59:14.000Z', '2026-02-09T21:59:14.000Z', '2026-02-09T21:59:14.000Z');
UPDATE public.profiles SET name = 'Bruna Silva ', cpf = '01551315670', phone = '31989795140', company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '35ef7595-8c08-40f1-afe3-b16eb6d48412';
UPDATE public.user_roles SET company_id = '568b7834-cbbc-4d4f-8f8d-b3a1f0dd3eee' WHERE user_id = '35ef7595-8c08-40f1-afe3-b16eb6d48412';

-- ========== TEST RESULTS ==========
-- Buscar ID (2025-11-07)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('f6338613-9f59-462d-ab6f-563d503bf971', '0f7cf7a3-cecd-43c3-9977-d77d247c0491', '{"D":21,"I":1,"S":0,"C":0}', '{"D":19,"I":15,"S":17,"C":0}', '{"O":61,"C":61,"E":38,"A":51,"N":25}', 22, '3c319f6c-1e85-4aee-987c-4ce3a78ef7ca', '{}', '2025-11-07T21:49:27.000Z');

-- Buscar ID (2025-11-07)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('f077ef31-56ac-48aa-8fa2-196b7ad70580', '0f7cf7a3-cecd-43c3-9977-d77d247c0491', '{"D":21,"I":1,"S":0,"C":0}', '{"D":19,"I":15,"S":17,"C":0}', '{"O":6,"C":10,"E":16,"A":17,"N":19}', 19, '3ecf8aff-c1c5-4afe-9b11-954c01a8445e', '{}', '2025-11-07T22:26:17.000Z');

-- Kaw Bicalho (2025-11-07)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('454fb643-a0a0-4cc6-b352-87adcc5dbfc3', 'a696585b-c272-4792-9f5a-9b3bd16faf66', '{"D":9,"I":0,"S":13,"C":0}', '{"D":17,"I":18,"S":10,"C":6}', '{"O":7,"C":18,"E":26,"A":17,"N":15}', 14, 'edf54ecb-0886-46a2-aec9-5c22420c1801', '{}', '2025-11-07T22:35:54.000Z');

-- Rodrigo Normandia (2025-11-07)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('2742cfa7-6c0f-4c17-b198-77c50f300c11', '80eea104-0ebe-4d84-9740-436bddbe7c65', '{"D":0,"I":1,"S":19,"C":1}', '{"D":21,"I":3,"S":17,"C":10}', '{"O":4,"C":18,"E":22,"A":15,"N":10}', 12, 'db546cd0-cb1b-4c87-96de-b0fdcc5aeb28', '{}', '2025-11-07T22:37:03.000Z');

-- Buscar ID (2025-11-08)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('0429312d-0ffe-4f36-848f-a8c7802ad78f', '0f7cf7a3-cecd-43c3-9977-d77d247c0491', '{"D":26,"I":16,"S":21,"C":16}', '{"D":62,"I":48,"S":33,"C":52}', '{"O":22,"C":11,"E":22,"A":10,"N":3}', 5, '94948908-0506-4fca-ba95-41840ea983d9', '{}', '2025-11-08T13:08:58.000Z');

-- Kaw Bicalho (2025-11-08)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('38828713-60a5-4cd6-a8d3-69855d7e9f3d', 'a696585b-c272-4792-9f5a-9b3bd16faf66', '{"D":27,"I":15,"S":21,"C":16}', '{"D":62,"I":42,"S":30,"C":55}', '{"O":15,"C":11,"E":18,"A":5,"N":8}', 9, '5a1e797b-89eb-4da3-a98b-3265a8944d16', '{}', '2025-11-08T15:16:56.000Z');

-- Jussara Rodrigues (2025-11-08)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('8ac0c570-c325-45ad-a6fe-c06f545db0a2', '7ba2b83e-8cc0-460f-bfd2-1a379869a08c', '{"D":24,"I":19,"S":24,"C":16}', '{"D":60,"I":58,"S":53,"C":39}', '{"O":19,"C":11,"E":22,"A":12,"N":5}', 6, '770f8727-8890-4da4-bf97-28736ec573f1', '{}', '2025-11-08T21:21:39.000Z');

-- Flávia Nascimento (2025-11-08)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b7d0903f-037b-439b-882d-206599138abe', 'd7b75313-d88e-4c41-b8cf-2a940b643b84', '{"D":12,"I":14,"S":33,"C":25}', '{"D":33,"I":42,"S":80,"C":52}', '{"O":7,"C":23,"E":11,"A":19,"N":15}', 16, 'b610aece-c9bf-459a-94e8-85a00ebf884e', '{}', '2025-11-08T21:55:24.000Z');

-- Rodrigo Teixeira (2025-11-08)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('31b8fa6b-bbe2-4218-83e8-235fe40519b2', '60f3ceef-3d79-4a74-a034-b3af82211952', '{"D":17,"I":15,"S":27,"C":20}', '{"D":86,"I":27,"S":10,"C":55}', '{"O":13,"C":16,"E":14,"A":14,"N":22}', 17, 'bf37c1f4-439b-45af-b2aa-3999d49d633e', '{}', '2025-11-08T23:33:53.000Z');

-- Buscar ID (2025-11-10)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('bb7b4345-a1a6-47fb-8f76-f61137c85b40', '0f7cf7a3-cecd-43c3-9977-d77d247c0491', '{"D":18,"I":4,"S":29,"C":29}', '{"D":55,"I":0,"S":40,"C":87}', '{"O":4,"C":27,"E":3,"A":2,"N":15}', 17, 'a46ab306-e6e4-49da-b7cd-33f717896ee3', '{}', '2025-11-10T15:22:52.000Z');

-- Fernando Jin (2025-11-12)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('77f6ce1c-02d7-4c12-8d9b-f7656646b6ca', 'eeadd660-9bad-4b87-aab1-bcf262d418d7', '{"D":27,"I":9,"S":23,"C":24}', '{"D":74,"I":18,"S":30,"C":74}', '{"O":13,"C":24,"E":14,"A":0,"N":5}', 9, 'db342f59-a7af-4c2a-8554-b3d417ed8fb7', '{}', '2025-11-12T02:49:30.000Z');

-- Andre Wandenkolken Afonso (2025-11-12)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('8b53c8e8-63f0-46ca-ba42-199a9658d270', 'f95dcfa5-06df-4ab7-9c48-f12c80d04da8', '{"D":10,"I":11,"S":35,"C":24}', '{"D":0,"I":36,"S":100,"C":65}', '{"O":9,"C":18,"E":5,"A":24,"N":20}', 20, '76a726e6-229b-4022-aeb0-bf6f3b1ee25f', '{}', '2025-11-12T02:50:13.000Z');

-- Anie Karenina (2025-11-12)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('ddd646c7-68fb-451e-ad63-5f64f3fa4c11', '7da6e83d-97f2-4f82-8dfe-742642267901', '{"D":20,"I":25,"S":25,"C":9}', '{"D":36,"I":79,"S":63,"C":6}', '{"O":19,"C":0,"E":26,"A":19,"N":15}', 14, '78cd06df-c950-4e54-b1cd-cdbc2eabb53d', '{}', '2025-11-12T03:04:18.000Z');

-- Daniel Gaia (2025-11-12)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('87a6dc62-88c7-4261-beed-107e83ea89ff', 'da971798-2501-45e6-9c0e-0b82fc49ff3c', '{"D":28,"I":16,"S":21,"C":20}', '{"D":93,"I":55,"S":13,"C":39}', '{"O":17,"C":21,"E":22,"A":3,"N":0}', 3, '7e5ab476-70b1-46b5-96d3-f4d6c2ec92bc', '{}', '2025-11-12T03:15:23.000Z');

-- Filipe Lopes (2025-11-12)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('36a1edfb-1493-4eea-9e90-c38a788c4be9', '5a216530-3da8-449b-a2f8-66ed599682a1', '{"D":26,"I":22,"S":21,"C":12}', '{"D":76,"I":55,"S":23,"C":35}', '{"O":15,"C":8,"E":27,"A":10,"N":7}', 8, 'bc8f5691-ee71-499e-b87e-79a672b2fe49', '{}', '2025-11-12T15:31:59.000Z');

-- Gabriel Andrade (2025-11-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a19a60c1-ebff-4dee-bb12-09680674a4ab', 'dce6e769-fc4c-4f6c-ac6b-16d37f157321', '{"D":16,"I":25,"S":27,"C":17}', '{"D":33,"I":58,"S":57,"C":58}', '{"O":17,"C":11,"E":26,"A":24,"N":12}', 11, '042a6384-4b1f-467c-9b6d-b0bed363dd86', '{}', '2025-11-15T21:22:08.000Z');

-- Henrique Hamerski (2025-11-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('982b2e46-a1bc-409f-9f63-b21c972773c6', 'c0a6636d-3dff-4b1a-8a89-655c8b182614', '{"D":21,"I":7,"S":26,"C":28}', '{"D":79,"I":36,"S":23,"C":55}', '{"O":11,"C":23,"E":10,"A":3,"N":14}', 15, '67c671ab-ab98-42e6-a841-c50c31e8a83e', '{}', '2025-11-15T21:22:43.000Z');

-- Buscar ID (2025-11-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('0ae15206-8e5e-49d6-a81d-b318b05e6e8d', '0f7cf7a3-cecd-43c3-9977-d77d247c0491', '{"D":27,"I":22,"S":21,"C":14}', '{"D":64,"I":64,"S":30,"C":35}', '{"O":13,"C":13,"E":26,"A":12,"N":8}', 9, 'edc658b0-036c-410c-a4ed-78f900f9e4b0', '{}', '2025-11-15T21:23:11.000Z');

-- Letícia Morelli (2025-11-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('94a172fb-5ef7-49a8-9366-5104bc25af50', 'a645d647-73c6-460b-acec-e95751b767b2', '{"D":10,"I":5,"S":33,"C":33}', '{"D":33,"I":15,"S":57,"C":87}', '{"O":6,"C":27,"E":0,"A":10,"N":25}', 25, '652b1701-53d7-43e3-8759-a223c59d7949', '{}', '2025-11-15T21:24:26.000Z');

-- Roberta Caldas Simões (2025-11-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d6a5d478-d7b1-40df-8aca-832647da6a40', '5456311d-64bf-4690-bf7a-f0295d133bd4', '{"D":26,"I":25,"S":23,"C":12}', '{"D":55,"I":58,"S":53,"C":45}', '{"O":19,"C":11,"E":32,"A":15,"N":2}', 6, '431660f1-5bdc-4fc7-976b-9031afb1bb9b', '{}', '2025-11-15T21:24:41.000Z');

-- Christiano Soares (2025-11-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b083149b-6dfc-4874-8f12-6348aa28e9fd', 'ba519c12-810e-465f-8b5a-c62420376889', '{"D":27,"I":23,"S":21,"C":16}', '{"D":57,"I":94,"S":53,"C":16}', '{"O":24,"C":15,"E":30,"A":15,"N":2}', 4, '87253a31-1c94-4768-9f70-c4a82bc07695', '{}', '2025-11-15T21:24:57.000Z');

-- Eva Lariss (2025-11-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('f0ce5848-465b-4498-b695-886c1329f0c3', '5891c86b-f0df-453d-ba2f-73ee9df30d4b', '{"D":24,"I":22,"S":24,"C":12}', '{"D":64,"I":52,"S":37,"C":29}', '{"O":11,"C":10,"E":23,"A":14,"N":10}', 10, 'ec1eab00-8ef6-4bea-9620-08a276952907', '{}', '2025-11-15T21:25:12.000Z');

-- Júlia Maia (2025-11-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e1cfa0b2-a4ca-4cc6-913d-80ecd331218d', 'a48b63bc-5784-4535-9b2f-1cc204419c1f', '{"D":12,"I":25,"S":31,"C":13}', '{"D":26,"I":52,"S":57,"C":58}', '{"O":6,"C":6,"E":23,"A":25,"N":25}', 21, 'c7e5aada-bbd8-435e-87d2-c0c79c7b240e', '{}', '2025-11-15T21:25:24.000Z');

-- LAURA DOMINGUES (2025-11-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('ec36c69f-6a71-463b-bc53-6aae8086eb9f', 'c6e199ed-6036-4df7-b108-0f52f79967a3', '{"D":20,"I":2,"S":29,"C":32}', '{"D":74,"I":18,"S":20,"C":68}', '{"O":0,"C":31,"E":4,"A":0,"N":12}', 17, '90aab758-157e-40da-8b66-0a9d7846412d', '{}', '2025-11-15T21:27:15.000Z');

-- Marcos Augusto Cândido (2025-11-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('fcae51ef-9e4e-45f5-9c57-53b8c2bd581a', 'd4c25ae6-7b63-464e-a644-dbae193b5588', '{"D":11,"I":12,"S":32,"C":25}', '{"D":40,"I":55,"S":67,"C":52}', '{"O":4,"C":21,"E":10,"A":15,"N":15}', 16, '2974cdf6-bcef-4c44-a77f-1e92b1743229', '{}', '2025-11-15T21:33:34.000Z');

-- Setor Financeiro Albanez e Maia Advogados (2025-11-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('c38d78b8-ac78-44ba-bfec-9e679e974773', 'adf2af6f-4c3d-4115-a601-19830be203b3', '{"D":20,"I":17,"S":27,"C":21}', '{"D":43,"I":48,"S":63,"C":61}', '{"O":7,"C":21,"E":21,"A":15,"N":12}', 10, 'd7a98ebf-a2da-4c79-93b7-2a566168235d', '{}', '2025-11-15T21:34:22.000Z');

-- Leonardo Rotela (2025-11-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a3cf4939-fcbd-4223-bacf-b6e4dab17c01', '75f1fd81-9b52-4b31-ab03-f0420a875bfd', '{"D":16,"I":14,"S":29,"C":25}', '{"D":48,"I":27,"S":50,"C":65}', '{"O":15,"C":23,"E":14,"A":15,"N":7}', 9, '11c6848b-9550-4448-8739-bf31ac4a83fc', '{}', '2025-11-15T21:37:45.000Z');

-- Ana Carolina Frescurato da Silva (2025-11-17)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('bf982c38-34f1-472f-844b-443cc4790d9a', '5d9ec5be-f9a0-4b81-a1ab-e546ab705be8', '{"D":60,"I":35,"S":81,"C":93}', '{"D":74,"I":18,"S":20,"C":71}', '{"O":56,"C":98,"E":37,"A":59,"N":75}', 63, 'bb2cb76b-7e5b-4277-9cd9-363891b88781', '{}', '2025-11-17T17:44:12.000Z');

-- Rodrigo Nascimento (2025-11-17)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('0cdac9bc-206d-47dd-8dda-34e62dc84b70', '253e2e3f-787f-454f-91d6-63e490909334', '{"D":87,"I":65,"S":55,"C":61}', '{"D":62,"I":45,"S":30,"C":55}', '{"O":98,"C":66,"E":75,"A":63,"N":56}', 43, 'ecb3c45c-d5aa-4aaa-a1c1-63d01bc570ac', '{}', '2025-11-17T17:51:11.000Z');

-- Eduardo Ponce (2025-11-21)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b553805f-c4e1-4ce5-8548-ffd5e68f4ac2', 'be2867ea-495a-4bc3-bada-334540c4a869', '{"D":37,"I":48,"S":99,"C":87}', '{"D":33,"I":42,"S":80,"C":52}', '{"O":56,"C":85,"E":40,"A":88,"N":88}', 74, 'ec5b4cb1-14ae-4aa5-bae3-c8eb0586d325', '{}', '2025-11-21T00:14:41.000Z');

-- Letícia Morelli (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('42be9fa0-761d-4a03-8aa5-c3050a809321', 'a645d647-73c6-460b-acec-e95751b767b2', '{"D":63,"I":41,"S":74,"C":97}', '{"D":52,"I":0,"S":47,"C":100}', '{"O":78,"C":97,"E":45,"A":58,"N":71}', 59, 'ed513d14-3d10-4f7f-bdb3-ee67baf4baa8', '{}', '2025-12-02T23:21:40.000Z');

-- Ulisses Samarone Pereira Coelho  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b5f24d6f-5b12-48b4-a143-de094a412cb3', 'fb1a55db-0dbc-4439-97c7-01dbb172d4db', '{"D":71,"I":98,"S":68,"C":43}', '{"D":55,"I":76,"S":53,"C":32}', '{"O":83,"C":53,"E":96,"A":93,"N":59}', 51, 'c8a85dc0-2a53-4c8d-8dcb-ab2e6b059ac7', '{}', '2025-12-02T23:22:15.000Z');

-- Guilherme Augusto de Melo Almeida (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('069fe685-6fcb-4b38-ae11-1102b4c651d1', '1933b24f-1615-41fe-a236-7a487a71455b', '{"D":57,"I":84,"S":73,"C":59}', '{"D":19,"I":76,"S":77,"C":29}', '{"O":91,"C":56,"E":82,"A":92,"N":73}', 53, 'ae90720e-b6fe-418b-8cb7-448031a6ac35', '{}', '2025-12-02T23:22:54.000Z');

-- Gabriel Junqueira (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('eb4d852d-d9aa-45a6-b49d-b86d14555760', '6a313c0a-f144-4d45-88a9-7c5991e2c86e', '{"D":67,"I":52,"S":76,"C":82}', '{"D":69,"I":39,"S":33,"C":65}', '{"O":65,"C":94,"E":56,"A":69,"N":64}', 47, '73d39a76-d886-4bdf-bb39-d4737dc34477', '{}', '2025-12-02T23:23:17.000Z');

-- Wadir Proença Simão (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('efebc022-7c99-406a-abd8-a0aab1a071a3', '7c06cf8e-37e4-4ad0-8aaa-f34b794c206e', '{"D":54,"I":36,"S":81,"C":100}', '{"D":33,"I":21,"S":67,"C":90}', '{"O":69,"C":100,"E":40,"A":64,"N":78}', 66, '737100c7-0a77-4926-a201-1d82441d31f0', '{}', '2025-12-02T23:24:36.000Z');

-- Renato Dias Godinho Junior (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('32b51287-8756-470c-b270-1db5a54634d3', 'a4d1456b-1d91-4b28-a91f-63df3ee176ea', '{"D":67,"I":65,"S":74,"C":67}', '{"D":55,"I":76,"S":53,"C":32}', '{"O":81,"C":73,"E":66,"A":83,"N":61}', 39, 'e770fb75-fa76-44a6-b631-92650de2220d', '{}', '2025-12-02T23:25:00.000Z');

-- Isis dos Santos Kroeff (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a0c34290-b490-4acd-9006-f3655d71bf2f', 'f5d1c05a-8121-430c-844d-8def02d973f8', '{"D":77,"I":65,"S":61,"C":68}', '{"D":81,"I":30,"S":20,"C":68}', '{"O":89,"C":76,"E":73,"A":66,"N":61}', 41, '2e80f909-ef38-4e66-9376-aeb3f6787293', '{}', '2025-12-02T23:25:19.000Z');

-- Aquilis Dictis Moreira Kilão (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('5590d1d4-59ee-41e9-8cc4-04f81280b119', '020ed065-fca5-4ff0-96de-60e47310bc0d', '{"D":85,"I":59,"S":61,"C":72}', '{"D":93,"I":55,"S":13,"C":39}', '{"O":91,"C":74,"E":71,"A":53,"N":59}', 44, 'fb45991f-95e8-4923-a902-e0c51f8642fa', '{}', '2025-12-02T23:25:25.000Z');

-- Lucas de Paulo Chaves (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('70b85f78-0ed2-4b72-bd4e-9c35fc999e07', '8e898ac1-f0ba-4868-a0f4-5f8fb207fea5', '{"D":39,"I":38,"S":98,"C":97}', '{"D":33,"I":21,"S":67,"C":90}', '{"O":46,"C":97,"E":37,"A":76,"N":81}', 72, '54484a67-2bc3-4656-96f9-c32569c1c7cf', '{}', '2025-12-02T23:25:30.000Z');

-- Marlucio Rodrigues da silva  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('85c66da0-e0f6-40f3-b9fe-8bbe2125c443', '52f25ede-65d4-4f0d-a681-884136bbe613', '{"D":93,"I":70,"S":52,"C":62}', '{"D":86,"I":61,"S":13,"C":26}', '{"O":91,"C":69,"E":82,"A":56,"N":51}', 43, 'b5b68ec0-f6d3-4001-ad50-8a4490d104a1', '{}', '2025-12-02T23:26:05.000Z');

-- Bruna Silva (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b5122807-1094-4da5-aab7-e673fdecb5f9', '87778b25-7cac-41fb-a9ef-32ef172a2dba', '{"D":79,"I":100,"S":61,"C":33}', '{"D":50,"I":100,"S":53,"C":3}', '{"O":83,"C":44,"E":100,"A":88,"N":59}', 55, '8ba88784-dfc5-4a93-825f-c11919ed0e21', '{}', '2025-12-02T23:26:47.000Z');

-- Ana Karla  Morais Goncalves (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('5d3c6b37-00cc-4d6a-aae4-e234e53c1486', '72924e46-2260-4783-8114-4f9e1c52b702', '{"D":88,"I":81,"S":58,"C":45}', '{"D":48,"I":48,"S":63,"C":52}', '{"O":81,"C":55,"E":92,"A":75,"N":54}', 46, '567e703c-ef95-4634-8bcd-4f3b81d94573', '{}', '2025-12-02T23:26:55.000Z');

-- Raquel Ferreira (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('f61906ff-65f6-4930-8a88-d07835deaf92', '709e5120-cb8a-43b5-9411-540e7ebc2520', '{"D":94,"I":79,"S":51,"C":57}', '{"D":79,"I":70,"S":20,"C":45}', '{"O":93,"C":73,"E":92,"A":68,"N":46}', 41, '6bd1e6d8-7008-458b-9794-848748c72530', '{}', '2025-12-02T23:27:31.000Z');

-- Joás Pessoa da Cruz (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('2f99b7de-bed8-4702-a228-2556e474a3a7', 'f7c0adcc-b720-4ebd-b01c-dad91d999830', '{"D":71,"I":48,"S":68,"C":95}', '{"D":64,"I":6,"S":37,"C":87}', '{"O":76,"C":100,"E":58,"A":54,"N":68}', 54, '892426d1-a1a9-44f7-929c-d34c5b8b6212', '{}', '2025-12-02T23:27:45.000Z');

-- Adriano dos Santos Boscatte  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e3c55115-5f4b-4de3-9698-fda6187f4437', '77914e82-ea17-4f92-8517-169a469fb5e1', '{"D":78,"I":58,"S":67,"C":68}', '{"D":74,"I":52,"S":23,"C":39}', '{"O":78,"C":71,"E":66,"A":58,"N":66}', 45, '57c45316-02ad-4305-a86c-63018fa90a75', '{}', '2025-12-02T23:27:47.000Z');

-- Alexandre Santos (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('782e9768-2ba5-4b07-acb9-8ac148c7645e', '100cef08-f201-4d2c-a8b4-8b72fbe5bf1d', '{"D":74,"I":91,"S":65,"C":47}', '{"D":60,"I":76,"S":50,"C":29}', '{"O":91,"C":55,"E":95,"A":86,"N":58}', 48, 'afe6c0db-87af-4ebd-8ca5-5dabe98eed96', '{}', '2025-12-02T23:28:12.000Z');

-- Débora Franciele goncalves  Drumond  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('dce1ab90-e744-46e9-9c7a-d3e303d6cc32', 'a09ca078-b45f-4f00-abf2-bc72429725a4', '{"D":74,"I":65,"S":67,"C":63}', '{"D":100,"I":48,"S":0,"C":52}', '{"O":80,"C":71,"E":68,"A":69,"N":66}', 43, '51692069-f2e8-47fc-b264-5d81270f0aa0', '{}', '2025-12-02T23:28:32.000Z');

-- João Augusto  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('c08b18c8-868a-4330-bb87-546a2da57760', 'bcaf7ba6-5a09-45fa-92da-cd1a200e6efe', '{"D":93,"I":68,"S":51,"C":55}', '{"D":86,"I":27,"S":10,"C":55}', '{"O":89,"C":65,"E":81,"A":53,"N":54}', 46, '2db1866a-f272-4ef1-9ab8-e157fb84106e', '{}', '2025-12-02T23:28:38.000Z');

-- FLAVIO OLIVEIRA IZAC (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('c64a8dd0-8e0b-42ee-a492-7550272b8155', 'bd782bae-4375-4f8c-81ec-dbc2fab48454', '{"D":87,"I":75,"S":58,"C":57}', '{"D":76,"I":39,"S":30,"C":55}', '{"O":80,"C":71,"E":84,"A":63,"N":56}', 44, 'dcb35bda-936f-439d-8bf5-717c8bec9c9d', '{}', '2025-12-02T23:28:39.000Z');

-- Jéssica Lisboa Maia (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('8218d800-b48b-426f-8ff4-5a1afbff6f48', '6f0a8c00-062c-4d5a-9f90-f72a6984dd84', '{"D":70,"I":84,"S":70,"C":53}', '{"D":55,"I":76,"S":40,"C":32}', '{"O":70,"C":61,"E":85,"A":86,"N":69}', 50, '787d90cd-0ddd-43e4-9c43-e21ad6188c9c', '{}', '2025-12-02T23:28:58.000Z');

-- Carlos Eduardo Machado de Almeida e Sousa (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('06dda0e3-1544-4694-8285-428eab07f5c1', 'af360b43-078e-4982-955c-d1fe3d50db77', '{"D":94,"I":70,"S":50,"C":63}', '{"D":100,"I":48,"S":0,"C":52}', '{"O":94,"C":74,"E":85,"A":59,"N":44}', 39, 'e7a594bd-f00e-44bf-93c6-49f925d6f573', '{}', '2025-12-02T23:29:31.000Z');

-- Nayara Campos  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('02515788-666b-44b6-877b-c2a0ae0058ab', '186d25fe-6bea-4e34-bd5a-b046ba1fb208', '{"D":76,"I":68,"S":64,"C":63}', '{"D":60,"I":52,"S":40,"C":35}', '{"O":78,"C":73,"E":74,"A":75,"N":61}', 41, '4c37da91-58a5-4f2b-9b6e-987465b08e08', '{}', '2025-12-02T23:29:45.000Z');

-- Breendon Costa (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('721c4e8b-e260-4b86-a525-5a47c26f3e85', '6ea1e59b-45d3-4a12-b410-9a8b6b69cf1c', '{"D":82,"I":80,"S":61,"C":58}', '{"D":64,"I":70,"S":40,"C":42}', '{"O":89,"C":69,"E":85,"A":81,"N":47}', 37, 'febca764-45f1-465c-b7e6-57e6bddbbe7d', '{}', '2025-12-02T23:30:03.000Z');

-- Camila  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e3174a03-4b24-401d-9af0-ea8bbb08a052', 'b80b1268-9bc5-4761-8372-eb7ce8670c5a', '{"D":95,"I":62,"S":55,"C":59}', '{"D":81,"I":27,"S":20,"C":71}', '{"O":76,"C":69,"E":78,"A":51,"N":47}', 41, 'cae66dc5-a8ad-4c10-a71a-e71d00ac6ca0', '{}', '2025-12-02T23:30:05.000Z');

-- Bruno Sbraletta (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('ac18c84a-584d-40ac-a383-1b3c2f1efaed', '4ba11c14-16e5-4f95-a03a-1b8f634faa56', '{"D":88,"I":79,"S":56,"C":55}', '{"D":88,"I":64,"S":23,"C":26}', '{"O":96,"C":66,"E":90,"A":75,"N":51}', 42, '0b314c39-b5ca-45ad-8161-7dce14d2cec3', '{}', '2025-12-02T23:30:15.000Z');

-- Joel Henrique de Souza Matos  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('8f9a7e35-62cc-47cd-bafd-7b8612e1b43a', 'd829258e-1851-4b17-853f-08112f340f1e', '{"D":59,"I":64,"S":79,"C":76}', '{"D":60,"I":36,"S":50,"C":55}', '{"O":78,"C":81,"E":63,"A":78,"N":66}', 46, '1cbe853f-b87c-4231-952b-7d70dcea3c68', '{}', '2025-12-02T23:30:17.000Z');

-- José Américo de Andrade Júnior (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('31c88c59-f685-4530-96d1-847c24a2f2b7', '9c9e672f-e1c4-407c-9529-bdf05a58039d', '{"D":93,"I":57,"S":51,"C":72}', '{"D":93,"I":36,"S":10,"C":55}', '{"O":94,"C":77,"E":75,"A":49,"N":58}', 48, 'bc74c39f-3b77-4dd4-bda8-d9e9ac46d6a0', '{}', '2025-12-02T23:30:23.000Z');

-- Hitalo Carvalho (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('7a441788-fc74-4308-a7cc-41fe3d4ec877', '109fa513-81c6-4f07-bb68-62585c5b5b0b', '{"D":82,"I":78,"S":61,"C":58}', '{"D":81,"I":48,"S":23,"C":52}', '{"O":83,"C":71,"E":85,"A":75,"N":53}', 40, '5aa7ae2e-aab8-473a-9203-480575925983', '{}', '2025-12-02T23:30:25.000Z');

-- Luísa Meneghetti Almeida Melo (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('1e1ddc0e-3db1-48b4-92ba-cd6d1cfdf9ef', '5d445a43-ff6f-4be8-a5f4-9cd1ce29d794', '{"D":57,"I":77,"S":79,"C":66}', '{"D":36,"I":58,"S":60,"C":48}', '{"O":67,"C":69,"E":74,"A":85,"N":80}', 55, '78715d9b-3f53-4dd0-9738-70c0c8e2693d', '{}', '2025-12-02T23:30:46.000Z');

-- Fausto Sebastião Izac (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('61c62e4c-6435-4ecc-9beb-3fe6c05b49df', '7720709b-be36-45c5-b7c5-8ff16d8e372e', '{"D":62,"I":51,"S":75,"C":87}', '{"D":50,"I":39,"S":47,"C":77}', '{"O":67,"C":90,"E":52,"A":66,"N":69}', 52, '00619638-b548-44e5-bd9e-d57d43f85e49', '{}', '2025-12-02T23:30:58.000Z');

-- ALYSSON VINICIUS LIMA GUIMARAES (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('2a55dad2-bb6a-46b1-b931-2c2bd3b64d0f', 'f2e6cfa0-1a6d-42b7-bb19-ba459a7aada9', '{"D":74,"I":67,"S":67,"C":62}', '{"D":71,"I":79,"S":33,"C":10}', '{"O":78,"C":68,"E":73,"A":73,"N":58}', 38, 'adfdd455-c025-4ecf-a383-332d5f63c976', '{}', '2025-12-02T23:30:58.000Z');

-- Emely Gaspar Teles (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('314453c8-2067-4d17-8584-83411f693c12', 'b9dbbeaf-6db0-49ec-b74f-8987cabf81e9', '{"D":71,"I":51,"S":64,"C":84}', '{"D":71,"I":18,"S":27,"C":84}', '{"O":81,"C":82,"E":56,"A":54,"N":73}', 53, '01570558-af4d-48ee-a607-32bc75bbdc65', '{}', '2025-12-02T23:31:21.000Z');

-- LEONARDO CORREA CAMARGO (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('43fc782c-cfc6-45cf-ba3c-d38f5c07913a', '3fbcd55d-9d47-4e3e-b1a6-cc303aed5a9d', '{"D":67,"I":56,"S":70,"C":76}', '{"D":48,"I":30,"S":37,"C":61}', '{"O":81,"C":77,"E":60,"A":69,"N":69}', 47, '5ef1a6c8-03c3-4fcd-be26-e230acaf95f8', '{}', '2025-12-02T23:31:35.000Z');

-- Carlo Eduardo Grimaldi  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('27372645-dc8d-47ff-a976-e8a74082b410', '67ad35fb-1c70-400b-86fd-deabcd585914', '{"D":82,"I":60,"S":57,"C":83}', '{"D":81,"I":30,"S":20,"C":68}', '{"O":91,"C":90,"E":71,"A":54,"N":61}', 46, '731fe2bd-e8b4-4d32-b3d2-4a3649d8a8af', '{}', '2025-12-02T23:31:53.000Z');

-- Gabriel Falci (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('31b33d3e-9067-4e79-a722-20cdb8131d46', 'bbdfdc2d-6ff1-4b70-9f4f-5f74b136b778', '{"D":59,"I":38,"S":80,"C":97}', '{"D":62,"I":27,"S":37,"C":77}', '{"O":69,"C":97,"E":42,"A":61,"N":71}', 60, 'fb8f049c-13f7-4e89-9558-14631ada6e2c', '{}', '2025-12-02T23:33:25.000Z');

-- Joao Victor Renault (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a314c0b0-f60c-4e44-9739-957dd707e09b', 'd7676920-9d95-44ad-bab6-4fd6dab3c831', '{"D":78,"I":60,"S":62,"C":72}', '{"D":67,"I":45,"S":40,"C":48}', '{"O":89,"C":79,"E":71,"A":63,"N":59}', 41, 'ad29b2f9-de36-4476-8a2c-8b772630c573', '{}', '2025-12-02T23:33:43.000Z');

-- RODRIGO CHEIRICATTI DE CARVALHO  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('2bdba5bc-d1b6-4166-a2cd-a50aecf77e5d', '85bf13eb-0833-40a2-9953-3deffc5fcda4', '{"D":93,"I":84,"S":51,"C":49}', '{"D":55,"I":55,"S":50,"C":48}', '{"O":91,"C":61,"E":97,"A":73,"N":47}', 44, 'aeb839c7-5bee-4843-ba36-c766b36621bd', '{}', '2025-12-02T23:33:57.000Z');

-- Augusto Cezar Oliveira Izac  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('bc58ecd5-3df3-42a8-a785-51caec3f6102', 'eac4ba19-05e7-43f6-abfd-c7e782b3cdac', '{"D":41,"I":44,"S":93,"C":88}', '{"D":40,"I":39,"S":63,"C":52}', '{"O":54,"C":87,"E":40,"A":76,"N":88}', 72, '941019e4-bc2c-46a7-a369-f590670b736c', '{}', '2025-12-02T23:34:03.000Z');

-- Vilson da Silva Mayrink (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('68ec9060-c29e-4d89-8f3e-b1eced7eefc3', '35c84f0e-a14e-457f-bb6f-5bfb12ae457b', '{"D":74,"I":84,"S":61,"C":62}', '{"D":67,"I":67,"S":20,"C":32}', '{"O":87,"C":68,"E":86,"A":81,"N":63}', 45, '7c8d9834-7695-41b6-93ff-f70c92e1c276', '{}', '2025-12-02T23:35:02.000Z');

-- Hellen Machado Ramos Xavier (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('f836765c-6d2f-477e-94af-da6105755e73', '1f698d37-9797-457f-bb05-e4b8f09eeced', '{"D":78,"I":69,"S":63,"C":55}', '{"D":55,"I":42,"S":43,"C":42}', '{"O":72,"C":61,"E":75,"A":69,"N":68}', 48, '01367a52-6842-485e-a1ac-701eabe42a35', '{}', '2025-12-02T23:36:17.000Z');

-- Lucas  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('0355d9ec-eadf-4d39-8b44-a54a7ec1d8fb', 'a598f57e-1c0d-4d31-9624-964478b15f27', '{"D":65,"I":81,"S":74,"C":53}', '{"D":43,"I":70,"S":73,"C":26}', '{"O":81,"C":56,"E":81,"A":92,"N":64}', 47, '516320f6-7068-47c2-9f41-43e471921e75', '{}', '2025-12-02T23:37:05.000Z');

-- Ana Lara Mendonça  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('4a8c4f71-7335-478e-bf6f-ff12d72809a4', 'bb0d84d0-6522-4232-b529-be7578cc7384', '{"D":62,"I":59,"S":74,"C":78}', '{"D":33,"I":36,"S":73,"C":65}', '{"O":69,"C":77,"E":63,"A":66,"N":75}', 51, '8bb2d109-4592-4c97-a2e8-f41e8409b394', '{}', '2025-12-02T23:37:53.000Z');

-- jose angelo de melo (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('fc6643cd-fbaf-4514-a1a2-41a3fab13715', 'fda63257-34fd-4daf-a368-869d6b3d40a0', '{"D":72,"I":80,"S":64,"C":58}', '{"D":45,"I":64,"S":60,"C":45}', '{"O":89,"C":60,"E":84,"A":76,"N":66}', 46, '92caa57b-56a0-4194-8af4-8db9eb80bba8', '{}', '2025-12-02T23:37:55.000Z');

-- BRENO FERREIRA DUARTE (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a8721ea4-31f8-48eb-a128-e62989924073', 'd2bae856-ee2e-4ec8-a923-2cb455820d53', '{"D":71,"I":79,"S":69,"C":62}', '{"D":81,"I":64,"S":23,"C":39}', '{"O":81,"C":74,"E":85,"A":83,"N":59}', 40, '62eac212-4415-49e5-9ff9-9649f4489654', '{}', '2025-12-02T23:38:18.000Z');

-- Letícia  (2025-12-02)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('6c0d3d06-d19f-4c69-a9a2-920f907192e0', '790211b4-6402-4a72-ba6a-9ba906e36a91', '{"D":78,"I":69,"S":58,"C":66}', '{"D":81,"I":70,"S":20,"C":42}', '{"O":94,"C":73,"E":77,"A":73,"N":61}', 42, '3594de18-e88a-4da7-af8e-5c19d158902a', '{}', '2025-12-02T23:38:54.000Z');

-- Samira Dias Ribeiro (2025-12-03)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('c72e0e3d-e300-4707-bc73-d9953f88b2e5', '1edd6bd5-d00b-4b85-b564-cfc38cddbbf0', '{"D":77,"I":85,"S":63,"C":58}', '{"D":62,"I":70,"S":40,"C":45}', '{"O":89,"C":65,"E":90,"A":80,"N":58}', 43, '69c934d9-7df8-4d0f-aa96-3d1871ff35b3', '{}', '2025-12-03T23:36:11.000Z');

-- Mayra Hitomi Abeki de Oliveira (2025-12-04)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('281ae2a6-fac4-4dc7-a79b-a5e1fe6e4957', '97875b1a-2d1d-4bb7-9e75-76d9ba668344', '{"D":61,"I":56,"S":74,"C":92}', '{"D":45,"I":27,"S":57,"C":77}', '{"O":76,"C":98,"E":60,"A":73,"N":66}', 51, 'be737ce8-39fb-415f-abc4-933bfd06b5fd', '{}', '2025-12-04T00:44:17.000Z');

-- Thais Elisa Barbian de Souza (2025-12-04)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('4c5190b8-a788-466b-86e8-1164ee3a2ca5', 'b080d8ca-3677-41d6-81f7-890fe9102a1f', '{"D":59,"I":56,"S":80,"C":83}', '{"D":38,"I":55,"S":70,"C":48}', '{"O":67,"C":87,"E":60,"A":75,"N":68}', 50, '4a584462-11f7-49df-a2e8-baf56db6e3a9', '{}', '2025-12-04T01:06:16.000Z');

-- Patricia de Oliveira e Silva (2025-12-04)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('632a49f3-cd14-43ee-9940-b06fb059661b', '9c3e6975-83e5-4e96-8994-aafacc04d9a8', '{"D":78,"I":75,"S":61,"C":58}', '{"D":48,"I":67,"S":60,"C":42}', '{"O":91,"C":66,"E":85,"A":75,"N":56}', 41, '59830d12-d84f-4383-99e2-0338eb0346d4', '{}', '2025-12-04T01:22:02.000Z');

-- Larissa Soares Rios (2025-12-04)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('c5599c5e-a8de-4621-ba8d-d9205c8a67ea', 'f25418e4-d0d0-4515-ab5e-a6b7b27c8fc1', '{"D":33,"I":44,"S":96,"C":97}', '{"D":14,"I":36,"S":77,"C":77}', '{"O":57,"C":90,"E":38,"A":85,"N":90}', 77, '0684f2a1-393b-4c42-b1e4-2cf592eb9ca4', '{}', '2025-12-04T20:46:59.000Z');

-- Anderson Bazilio Monte Rei (2025-12-04)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('294c1d25-191c-46d6-b029-858e580525dc', 'cb0e9777-8ac8-457f-b31c-e0ef98d3b444', '{"D":59,"I":58,"S":80,"C":80}', '{"D":74,"I":18,"S":30,"C":74}', '{"O":70,"C":84,"E":60,"A":69,"N":69}', 50, '64dbe0e9-331a-495a-836e-7efdc01c500f', '{}', '2025-12-04T21:22:00.000Z');

-- Claudio Moura Batitucci (2025-12-08)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('cf3ce57e-aa88-4553-956f-ef3cd236825f', '21cd6cfe-f48b-4cdc-a758-450af63642ea', '{"D":71,"I":68,"S":71,"C":66}', '{"D":52,"I":55,"S":53,"C":52}', '{"O":72,"C":73,"E":70,"A":76,"N":64}', 40, '391767cb-1695-4bcb-80b3-1877859cbd2c', '{}', '2025-12-08T14:04:59.000Z');

-- Ana Paula Souza Teixeira (2025-12-09)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('df7bd492-7a4f-4e94-8371-7c8865cc508a', '462b5eeb-71ab-48c1-8543-a4882085353c', '{"D":73,"I":78,"S":65,"C":64}', '{"D":62,"I":70,"S":40,"C":45}', '{"O":81,"C":71,"E":84,"A":76,"N":59}', 40, '146c4ac8-b94a-46de-9245-98e03f891992', '{}', '2025-12-09T22:36:20.000Z');

-- Ana luisa assis arrunategui (2025-12-09)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('ed3072b9-a936-4cbd-9c8c-54b355646433', '07b2b22e-146d-48e4-8bb5-033f8c527736', '{"D":88,"I":70,"S":60,"C":58}', '{"D":67,"I":67,"S":43,"C":32}', '{"O":78,"C":68,"E":84,"A":61,"N":56}', 43, '91927227-99f0-47f2-b040-ad20c59c3229', '{}', '2025-12-09T23:03:29.000Z');

-- Clayton Lisboa (2025-12-10)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b399da43-799c-4701-a943-409549a53b20', '7ee1d4d2-cea8-4764-8011-aa7e4645c7c1', '{"D":43,"I":51,"S":88,"C":86}', '{"D":29,"I":48,"S":80,"C":58}', '{"O":76,"C":81,"E":48,"A":81,"N":75}', 61, '25f5ce5e-1a5b-4f8b-a491-f7e05479c3b0', '{}', '2025-12-10T15:36:35.000Z');

-- Francis William Oliveira da Silva (2025-12-11)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d1a66d69-36fb-4a3c-b0ec-6424e29411dd', '4787fe4d-fc1a-47f1-93fb-59f3c1ad6706', '{"D":65,"I":48,"S":69,"C":95}', '{"D":50,"I":21,"S":47,"C":90}', '{"O":85,"C":95,"E":55,"A":66,"N":66}', 53, '28a32fe1-05c9-4f98-9edb-fed1bcdf651a', '{}', '2025-12-11T15:33:38.000Z');

-- Lucas dos Santos Vilas Boas (2025-12-12)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('18eac15d-37d6-4d7d-b4c4-f673f7832b50', 'c17a7da2-cc93-4c63-a8f3-6c56fc516c5b', '{"D":68,"I":86,"S":74,"C":47}', '{"D":36,"I":76,"S":70,"C":42}', '{"O":85,"C":52,"E":85,"A":93,"N":61}', 48, '67e8e1bd-d10e-476c-a933-3870fcff3baf', '{}', '2025-12-12T15:06:46.000Z');

-- Jordana Ferreira Vieira de Souza (2025-12-12)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('ad891e4e-82ab-460b-8821-4995a4b53a24', '309ef7e1-4e22-40f6-a7a5-c54ddccde030', '{"D":80,"I":67,"S":61,"C":63}', '{"D":55,"I":58,"S":50,"C":48}', '{"O":89,"C":71,"E":74,"A":73,"N":58}', 41, '399ff0a1-01a0-49de-a4ca-57bc04702e59', '{}', '2025-12-12T15:27:36.000Z');

-- Filippe Nilo Souza Leite (2025-12-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('aa9c5d32-f2fe-4af7-8250-df018d20525a', 'd115cc32-45f4-412d-a64c-191fddbd8cb7', '{"D":96,"I":60,"S":49,"C":76}', '{"D":69,"I":21,"S":30,"C":81}', '{"O":89,"C":85,"E":79,"A":46,"N":53}', 46, '69d5de46-c1fc-4f75-8692-49bdcfadafbf', '{}', '2025-12-15T15:29:03.000Z');

-- André Proença Doyle Oliva (2025-12-16)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('054c9495-3065-48f0-9b7a-1ca268d9f39b', '786759bc-3871-46ef-b327-69cc33680cc3', '{"D":94,"I":69,"S":48,"C":74}', '{"D":90,"I":58,"S":10,"C":48}', '{"O":100,"C":81,"E":85,"A":56,"N":47}', 41, '9b291b21-c909-4f6e-a04e-fa2bb64c2a88', '{}', '2025-12-16T07:16:51.000Z');

-- Rafael Guilherme de Sousa (2025-12-16)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('8598d143-3e9c-4a9a-982e-defaa4fefa26', '59850e2b-3c87-4435-b73c-7e6a0db185b5', '{"D":63,"I":47,"S":73,"C":97}', '{"D":50,"I":42,"S":50,"C":74}', '{"O":80,"C":97,"E":51,"A":59,"N":69}', 56, '9dedcf42-083f-4f90-8926-10435d21c2a2', '{}', '2025-12-16T16:17:34.000Z');

-- Alexsandra Rodrigues Matos (2025-12-18)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('8c8b08e3-0a1b-492b-9aa6-39b59a64b17f', '37732461-7afb-404f-841d-6c655cd269af', '{"D":94,"I":84,"S":50,"C":50}', '{"D":88,"I":58,"S":10,"C":52}', '{"O":93,"C":63,"E":96,"A":69,"N":47}', 44, 'ab00ba1d-d857-4392-87e5-e7488349619a', '{}', '2025-12-18T00:37:14.000Z');

-- Alexa Carvalho (2026-01-13)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e5ed0456-1dc8-4dee-806f-88dcf65a5f17', '0c56388b-110a-4a00-a0a5-4a57e9d5821d', '{"D":84,"I":69,"S":57,"C":72}', '{"D":81,"I":45,"S":20,"C":55}', '{"O":85,"C":81,"E":81,"A":59,"N":56}', 41, '32c6beb6-b685-4164-9559-c95766de2aa2', '{}', '2026-01-13T23:20:21.000Z');

-- Hylde Rosa (2026-01-14)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('242b4311-04c4-4555-9f03-a8e20feca1f3', 'f5917f28-6737-4da7-9128-ec67812b16db', '{"D":88,"I":69,"S":57,"C":64}', '{"D":81,"I":27,"S":20,"C":68}', '{"O":93,"C":77,"E":79,"A":63,"N":49}', 39, '39081447-2039-4ea6-9fd9-1b8af729c5d5', '{}', '2026-01-14T00:16:09.000Z');

-- Mayara Dias (2026-01-14)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('505573d6-b3f9-4a17-813f-b5eb438855e1', '87545455-0484-428f-af89-3530545ec859', '{"D":80,"I":70,"S":62,"C":63}', '{"D":83,"I":48,"S":20,"C":48}', '{"O":76,"C":77,"E":81,"A":73,"N":54}', 38, '87b3c2b4-1935-407f-a254-db9b6833a8ad', '{}', '2026-01-14T01:27:31.000Z');

-- Andre Wandenkolken Afonso (2026-01-14)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('0584fe11-4c1f-4a48-9f44-da94632b9a5b', 'f95dcfa5-06df-4ab7-9c48-f12c80d04da8', '{"D":54,"I":49,"S":81,"C":76}', '{"D":21,"I":21,"S":77,"C":77}', '{"O":76,"C":76,"E":47,"A":80,"N":80}', 59, '0ac30c98-2c61-4aa9-bffa-577513f68dc5', '{}', '2026-01-14T19:57:10.000Z');

-- Lidisay Sena (2026-01-15)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('bbb3b8f6-dbad-4ef8-b39a-df8e7be36ee1', 'aa93e5ae-89d9-4946-9420-7bc4278d0d32', '{"D":37,"I":46,"S":94,"C":88}', '{"D":14,"I":21,"S":77,"C":90}', '{"O":59,"C":81,"E":38,"A":85,"N":88}', 73, '5fde920b-220b-4d89-9944-3deb39caf509', '{}', '2026-01-15T22:20:10.000Z');

-- Erick Dantas (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('2349f47d-e3a0-4343-84b1-646b2df33d97', '8a3b9b6c-6342-4e63-8d08-ca9a0f32f91b', '{"D":80,"I":44,"S":64,"C":80}', '{"D":67,"I":24,"S":37,"C":71}', '{"O":81,"C":89,"E":55,"A":54,"N":53}', 44, '647dcdb9-6b16-4896-8f33-54de76220322', '{}', '2026-01-23T19:57:11.000Z');

-- walbert santos (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('bda99ffd-24c0-49c6-a21a-c5693b50e7e1', 'cb1c199f-ba1d-438d-afb3-8e5ae031cc2b', '{"D":73,"I":60,"S":73,"C":66}', '{"D":64,"I":48,"S":37,"C":58}', '{"O":78,"C":69,"E":67,"A":69,"N":64}', 43, '31da3e84-94cb-48bb-9950-29042edd9472', '{}', '2026-01-23T20:07:16.000Z');

-- Lara Leite Duarte Cocri (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a23b246b-a99a-405c-b205-4d97fde0211f', 'a7ead495-1c9d-47c9-ac28-d2fb643972c7', '{"D":56,"I":80,"S":76,"C":62}', '{"D":29,"I":64,"S":80,"C":48}', '{"O":83,"C":63,"E":78,"A":92,"N":68}', 49, 'e506ffbb-398d-42fb-9c09-c0396639bf7b', '{}', '2026-01-23T20:15:03.000Z');

-- Letícia Nunes (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('96d613c5-84bf-4763-a60b-5dbd2d6b77f5', '9c75a655-ca59-447e-bceb-898a027ca3b1', '{"D":38,"I":58,"S":95,"C":84}', '{"D":36,"I":33,"S":57,"C":68}', '{"O":52,"C":84,"E":49,"A":92,"N":86}', 69, 'a1f08bf2-f105-4c5d-8db0-f9794839de7d', '{}', '2026-01-23T20:24:48.000Z');

-- Adriana Oliveira da paz  (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('de5dd895-96ed-43f4-8f71-dc54407c22a5', 'fb02fbd4-d670-4539-bce3-2952804623b8', '{"D":76,"I":79,"S":64,"C":54}', '{"D":81,"I":52,"S":17,"C":29}', '{"O":85,"C":60,"E":82,"A":71,"N":64}', 46, 'e699fc48-fad2-4d36-b4a6-b231a0c8ddea', '{}', '2026-01-23T20:29:34.000Z');

-- GISLAYNE NUNES  (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('4b483787-68a7-4a95-ab45-289ab05b84b1', '357032a0-4399-4bfb-a9b1-9cde290e14f6', '{"D":84,"I":67,"S":61,"C":67}', '{"D":88,"I":64,"S":23,"C":26}', '{"O":80,"C":76,"E":79,"A":63,"N":53}', 39, 'e0245a8e-7f17-4672-be4d-ed84e29c4d82', '{}', '2026-01-23T20:31:12.000Z');

-- Djalma Neto  (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a35ed52e-666b-4b23-9f9f-9b9b7c2c3148', 'dd24126f-d378-4e02-a923-aca3e79c890f', '{"D":78,"I":64,"S":62,"C":76}', '{"D":62,"I":70,"S":43,"C":42}', '{"O":91,"C":85,"E":75,"A":68,"N":53}', 37, '29b3f3a2-b062-4382-8572-423007052965', '{}', '2026-01-23T20:35:26.000Z');

-- Sandra Cristina Araujo Silva (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('4bda419a-1e3c-419b-a4e0-6c8bf8ab9e6e', '45628319-f9b1-4aba-ab31-76651ceff33f', '{"D":72,"I":72,"S":68,"C":64}', '{"D":74,"I":61,"S":30,"C":45}', '{"O":74,"C":77,"E":74,"A":76,"N":61}', 39, '83913f2f-e041-4283-99e4-8c4a3daf4580', '{}', '2026-01-23T20:42:07.000Z');

-- Gustavo Oliveira dos Prazeres (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('458c9e94-bf70-4019-ae64-fb539ff3724f', '68b498f9-72c2-4389-94d2-26522fb71a97', '{"D":59,"I":78,"S":74,"C":68}', '{"D":26,"I":48,"S":70,"C":58}', '{"O":89,"C":74,"E":77,"A":92,"N":69}', 47, '5af251c2-699c-43cc-89e4-f5ef7f81710c', '{}', '2026-01-23T20:45:36.000Z');

-- Welton kellyson da Silva Alves (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('ca693cf4-c0dc-42c1-9cbf-8087e58ff0a7', 'e940269d-46f1-4b31-9810-d9b7e6076633', '{"D":71,"I":59,"S":69,"C":78}', '{"D":81,"I":27,"S":20,"C":68}', '{"O":76,"C":89,"E":64,"A":71,"N":59}', 41, '582d3219-81e8-4156-b491-6b724907a1a1', '{}', '2026-01-23T20:52:18.000Z');

-- Eduardo Luna (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('6cb0d21a-4a89-4fab-8210-49ee297d24fe', 'd3e17d0e-861c-4fb3-9a07-3c48e9d3533d', '{"D":61,"I":49,"S":79,"C":84}', '{"D":36,"I":58,"S":67,"C":58}', '{"O":70,"C":87,"E":56,"A":69,"N":69}', 53, 'c6685c8f-3e85-4c3d-93f5-1122767be700', '{}', '2026-01-23T21:04:20.000Z');

-- Lucas azevedo da silva  (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d81b92db-8f92-499a-be59-a9796150a8da', '5c9fa029-5bca-4a83-9b20-361b119045b8', '{"D":66,"I":49,"S":76,"C":87}', '{"D":90,"I":58,"S":10,"C":48}', '{"O":69,"C":95,"E":53,"A":63,"N":64}', 50, '1ef7fbfa-2724-4700-a427-54ba948e59b5', '{}', '2026-01-23T21:18:01.000Z');

-- Suelen Patricia Batista De Santana (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('67014d85-619f-4050-9b9a-5c7afe0fd69f', 'd3880e42-34c8-4043-90fc-34aeba4740c6', '{"D":70,"I":63,"S":73,"C":67}', '{"D":50,"I":45,"S":60,"C":48}', '{"O":65,"C":79,"E":70,"A":73,"N":59}', 38, 'dc8567d5-d77d-42f8-930f-b82be1ed22a4', '{}', '2026-01-23T21:26:09.000Z');

-- Leandro Victor Da Silva (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('09a9f4e1-9b49-408d-b9f7-2d9c754e7be7', '7b1abe1a-126a-4981-b8f6-a7310e534e81', '{"D":67,"I":53,"S":67,"C":89}', '{"D":52,"I":21,"S":50,"C":81}', '{"O":72,"C":97,"E":62,"A":59,"N":63}', 48, '73a373d7-96dd-487b-bc77-7fea43ce063e', '{}', '2026-01-23T22:32:11.000Z');

-- Surama Carvalho Pereira (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('82e875d6-8bb0-4787-8dc4-600abb748a1a', '4e128193-9aeb-4f3b-bd2f-c6bb3dd1170d', '{"D":30,"I":40,"S":100,"C":100}', '{"D":14,"I":36,"S":77,"C":77}', '{"O":54,"C":95,"E":32,"A":85,"N":92}', 81, 'd205a683-10d3-41ac-ae9e-9c8810497a32', '{}', '2026-01-23T23:03:51.000Z');

-- Rodrigo Normandia (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('51f3417f-293e-455a-8d74-90a4234aa302', '80eea104-0ebe-4d84-9740-436bddbe7c65', '{"D":93,"I":73,"S":50,"C":59}', '{"D":88,"I":58,"S":10,"C":52}', '{"O":91,"C":66,"E":85,"A":56,"N":51}', 44, '6b270ee6-ccbf-4bbf-b1a1-ca6445f21b5c', '{}', '2026-01-24T14:20:50.000Z');

-- Normandia teste (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('66420173-cdb0-4172-9ff9-30f42135d491', 'ccc296b6-8e68-4992-8e83-71bc0c652fdf', '{"D":93,"I":38,"S":58,"C":75}', '{"D":79,"I":15,"S":17,"C":61}', '{"O":69,"C":84,"E":56,"A":39,"N":56}', 50, '127bf174-1452-44a3-b7fa-7ed0855c11d3', '{}', '2026-01-24T14:23:41.000Z');

-- Eduardo Guietti (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('7de3b8fc-0212-4b2f-8b99-8b816362c13f', '7376eac9-6ca7-4e8b-a361-785787860177', '{"D":100,"I":75,"S":45,"C":58}', '{"D":67,"I":70,"S":43,"C":32}', '{"O":100,"C":68,"E":92,"A":56,"N":46}', 44, 'e8dd9d25-fa98-4205-973f-4e8a4c3c05f7', '{}', '2026-01-24T23:36:09.000Z');

-- Pedro Victor Silva Moraes (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('33fdacbf-fc6d-4509-b5e9-c900e1a819e9', '3681d6ff-00dd-486a-82a4-20e9bde7daf2', '{"D":43,"I":37,"S":89,"C":95}', '{"D":7,"I":27,"S":77,"C":77}', '{"O":59,"C":90,"E":34,"A":78,"N":86}', 73, 'be8e3b6f-4368-43da-9e7d-b487fc8edf37', '{}', '2026-01-24T23:36:34.000Z');

-- JULIANA COSTA CAMPOS (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('6aceb3d3-4c1b-41fa-94aa-beea5c612fef', '8db7cd7b-ffea-49f7-97d9-97d74412284d', '{"D":56,"I":65,"S":76,"C":78}', '{"D":62,"I":27,"S":37,"C":77}', '{"O":83,"C":79,"E":62,"A":80,"N":73}', 51, '600ed031-c7cd-46a0-80ce-7d5d56bc42f8', '{}', '2026-01-24T23:36:43.000Z');

-- Andreia Aparecida Rangel Santos (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('4d679f9f-cb5e-4501-86fb-9f1203e521c4', '28926187-b441-47dd-9b16-4ec129c24ad5', '{"D":77,"I":60,"S":61,"C":79}', '{"D":79,"I":33,"S":17,"C":77}', '{"O":91,"C":79,"E":66,"A":56,"N":64}', 45, '07011356-122f-4550-888f-253c7a9b5a38', '{}', '2026-01-24T23:37:52.000Z');

-- Luis Gildevam Rodrigues de Lima Junior (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3083762b-838e-4751-81fd-73823a9aac8a', '09fd25c9-d505-44dc-a353-90e64097b59e', '{"D":60,"I":74,"S":79,"C":67}', '{"D":50,"I":64,"S":63,"C":35}', '{"O":76,"C":71,"E":74,"A":90,"N":59}', 41, '39a340fa-bd7a-4be5-8c79-9218a57175e2', '{}', '2026-01-24T23:39:05.000Z');

-- Maria Helena Rocha (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('9652bf91-b1bd-4c15-ab43-6569a02b9a07', '0480243c-b8f1-49c4-97cf-9190abd41f2b', '{"D":72,"I":68,"S":68,"C":67}', '{"D":69,"I":67,"S":40,"C":35}', '{"O":80,"C":74,"E":71,"A":73,"N":66}', 41, 'd8a7aab4-2be5-4081-9a08-13c6e114071d', '{}', '2026-01-24T23:39:11.000Z');

-- Andreia Barreto (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b397ccbc-da03-4754-8598-e25bc9c0653d', 'fd3c8676-231e-4910-941f-7ca4fa0fda2f', '{"D":83,"I":80,"S":58,"C":58}', '{"D":81,"I":64,"S":23,"C":39}', '{"O":85,"C":69,"E":89,"A":71,"N":56}', 43, '18328b0d-bc10-4af6-8a63-126e51a434cc', '{}', '2026-01-24T23:39:13.000Z');

-- Amanda zahdi pessuti Turossi  (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e74b1d04-054f-4afa-bbe9-218608321b32', '376c6da1-abf3-4f11-867b-61dd3844d294', '{"D":73,"I":60,"S":67,"C":76}', '{"D":33,"I":39,"S":70,"C":74}', '{"O":87,"C":82,"E":64,"A":71,"N":58}', 40, '250fa3a4-f8ee-4240-a32b-266dc0f7f76e', '{}', '2026-01-24T23:39:38.000Z');

-- Ricardo Akiyo Minasse Tomita  (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('5419681c-e2d6-42c8-b570-de57427e83e4', 'dbc4126c-3393-43f8-8466-87a31bf40f23', '{"D":52,"I":59,"S":83,"C":76}', '{"D":57,"I":55,"S":50,"C":45}', '{"O":74,"C":74,"E":55,"A":81,"N":71}', 53, '34cad649-dbe4-4e21-97b7-ca4614e720db', '{}', '2026-01-24T23:40:36.000Z');

-- Gisele kelermam (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a82a005b-eacb-4267-8f69-e38781cb7423', '294e0268-ebfb-4398-80e6-c9bded18123b', '{"D":59,"I":59,"S":76,"C":83}', '{"D":50,"I":21,"S":47,"C":90}', '{"O":80,"C":85,"E":58,"A":76,"N":69}', 50, '2b6f2f36-299b-4d7f-a9d1-d8b171621119', '{}', '2026-01-24T23:40:47.000Z');

-- MARCO ANTONIO MARTINS DE OLIVEIRA JUNIOR (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3e5b1d55-f9fc-4e37-8279-c17cfd831496', '41810d44-bc73-4a56-9b70-4253634820e0', '{"D":48,"I":68,"S":81,"C":66}', '{"D":14,"I":61,"S":80,"C":35}', '{"O":70,"C":60,"E":62,"A":88,"N":95}', 66, 'e85c060e-eda2-440e-b36f-ae1f91ca0c7b', '{}', '2026-01-24T23:40:53.000Z');

-- Maria Eduarda Souza Branco (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('463fb3c3-13e5-4e51-a60a-000f8c8a7d22', '6c5c8288-c099-4f33-b723-98489a459aa9', '{"D":49,"I":64,"S":83,"C":74}', '{"D":45,"I":48,"S":40,"C":48}', '{"O":69,"C":74,"E":63,"A":92,"N":83}', 60, '7398652d-3d81-4d80-ad3b-f3086b8ba461', '{}', '2026-01-24T23:40:59.000Z');

-- ANDRE RODRIGUES MANGINI (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a583706c-4745-490b-b038-d4658653d9e4', 'd3fb4d68-ae06-4afc-a33d-44850a861a91', '{"D":95,"I":60,"S":51,"C":64}', '{"D":88,"I":64,"S":23,"C":26}', '{"O":91,"C":73,"E":77,"A":53,"N":49}', 43, 'fc795fd7-1a84-449c-939c-2571b7860b3d', '{}', '2026-01-24T23:41:00.000Z');

-- lilian ribeiro coelho (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d265f198-8237-41ee-8a43-45a15b400d27', '63de46ec-059c-4408-9701-b2e1f169d9d6', '{"D":60,"I":69,"S":76,"C":72}', '{"D":14,"I":39,"S":83,"C":74}', '{"O":80,"C":76,"E":66,"A":83,"N":81}', 53, 'b6e9bb30-e596-4c1b-8243-520898ea7caa', '{}', '2026-01-24T23:41:16.000Z');

-- Carina Reis de Mattos (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a19f8503-b0fc-46ab-a1fb-15a249c398f1', '5cae6e11-b6e4-42f4-9916-b26520645caf', '{"D":79,"I":65,"S":61,"C":70}', '{"D":64,"I":6,"S":37,"C":87}', '{"O":83,"C":79,"E":75,"A":69,"N":58}', 40, '8cda7239-2f4b-4cb3-8cf2-7cf8ceb42c93', '{}', '2026-01-24T23:41:33.000Z');

-- Rodrigo Fernandes da Silva (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('ef050154-7329-405d-acf1-9a5ffe829d2b', 'a4cea920-cb75-4f16-936d-9fcef8c94c1f', '{"D":82,"I":46,"S":57,"C":82}', '{"D":74,"I":21,"S":20,"C":71}', '{"O":91,"C":82,"E":56,"A":46,"N":59}', 48, '0c688798-6797-43be-9c26-a823648b63e7', '{}', '2026-01-24T23:41:38.000Z');

-- Maurina da silveira  (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b225af6b-cd3c-4483-b65f-4ff32f959c68', '3884ac3d-4f7b-411d-97a8-be2b61cbb87c', '{"D":93,"I":73,"S":60,"C":43}', '{"D":88,"I":64,"S":23,"C":26}', '{"O":78,"C":53,"E":82,"A":61,"N":53}', 46, '64516aa2-24de-45e8-846e-287d4ed31c47', '{}', '2026-01-24T23:41:53.000Z');

-- Kimberly Suellen Bueno (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('2f95e775-fcb7-4db0-8050-0dc78aa859c7', '86d75fad-84a4-4c15-820a-5c3d3a945775', '{"D":79,"I":60,"S":60,"C":70}', '{"D":69,"I":30,"S":30,"C":55}', '{"O":80,"C":77,"E":68,"A":56,"N":78}', 53, 'b989ce6c-bc40-480e-9d01-b976b2ab2c4d', '{}', '2026-01-24T23:42:01.000Z');

-- Mauricio Silva (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('385ff8f5-5964-46ce-bf58-10c8acba70e4', '88fa54fa-f33c-407c-ad9d-bf77d424c847', '{"D":57,"I":63,"S":82,"C":64}', '{"D":43,"I":55,"S":63,"C":32}', '{"O":70,"C":69,"E":63,"A":83,"N":66}', 47, 'c40ed461-f48d-4a02-92fa-1a13265c1631', '{}', '2026-01-24T23:42:38.000Z');

-- Renato Corrêa Magalhães de Paula (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('aa4d3fbc-fdcf-48d0-9915-6ad1ddfb7109', '908c263c-9533-4822-b44c-eeeacb55f535', '{"D":74,"I":72,"S":70,"C":59}', '{"D":62,"I":73,"S":53,"C":19}', '{"O":80,"C":63,"E":79,"A":76,"N":56}', 38, '2703647c-7fb0-4aee-86e4-4a8abc6ca1f6', '{}', '2026-01-24T23:43:16.000Z');

-- Maisa de A Forster Machado (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3718bb1e-5e1a-4c3e-876b-2a58cc124ea0', '8e442685-72ce-47c9-9de2-c20183652f31', '{"D":52,"I":67,"S":81,"C":75}', '{"D":17,"I":76,"S":83,"C":42}', '{"O":91,"C":69,"E":60,"A":93,"N":73}', 52, 'e7bdba82-a56a-4ea4-9b18-01e3f6fa6fae', '{}', '2026-01-24T23:44:10.000Z');

-- Fabio Oliveira (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('6862c314-e68a-4586-b6b4-9c38ea6f1dad', 'a0da46d5-c0d0-4710-b56f-3619b7d1bf6c', '{"D":72,"I":69,"S":65,"C":68}', '{"D":45,"I":48,"S":60,"C":58}', '{"O":91,"C":73,"E":74,"A":71,"N":69}', 43, 'ecd411d7-e1d7-4889-9ee6-d6a85882cbb0', '{}', '2026-01-24T23:44:16.000Z');

-- Larissa Almeida Silva (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e9e96034-eb68-4a70-b5ce-ca4bd37cb63d', 'cafb6907-0135-485b-aaff-024f0a53682c', '{"D":76,"I":57,"S":64,"C":80}', '{"D":67,"I":48,"S":40,"C":48}', '{"O":80,"C":87,"E":67,"A":61,"N":58}', 42, '27cc7d40-9749-40f8-ad2c-2d6cd0a67f6e', '{}', '2026-01-24T23:45:44.000Z');

-- Mayra Hitomi Abeki de Oliveira (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3a959a34-5216-48e6-b49c-5750097b12be', '97875b1a-2d1d-4bb7-9e75-76d9ba668344', '{"D":59,"I":49,"S":76,"C":88}', '{"D":45,"I":27,"S":57,"C":77}', '{"O":74,"C":92,"E":53,"A":71,"N":66}', 52, 'a040bb20-dcc8-473d-bbb4-12f2457e346d', '{}', '2026-01-24T23:46:40.000Z');

-- Ruiter Fi (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b5e213d4-e1d9-4ef1-b2ca-b0c39f19346b', 'bfd7e198-981f-4786-982c-1a6fe29f3f45', '{"D":98,"I":59,"S":49,"C":64}', '{"D":93,"I":36,"S":10,"C":58}', '{"O":83,"C":74,"E":73,"A":44,"N":56}', 48, 'da46829c-99e4-46ee-ac9a-24fb0ca1b966', '{}', '2026-01-24T23:48:41.000Z');

-- Marcela Malloy Dias  (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('2053aa60-65d6-4999-90ed-1c86498f62a4', 'b55d0215-1b0d-4bfd-a3a7-80690b68e8cc', '{"D":63,"I":86,"S":71,"C":45}', '{"D":14,"I":61,"S":80,"C":32}', '{"O":78,"C":50,"E":82,"A":93,"N":76}', 57, '9bc14cc4-2bef-4f5e-82ea-ac15f5399a4b', '{}', '2026-01-24T23:48:57.000Z');

-- ELIO OLA RIBEIRO (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('03409445-d4e0-40e3-a315-a170d4a5fbf9', '5d7c9600-d6ee-48bc-b63b-81a2a87ffcbd', '{"D":56,"I":44,"S":76,"C":97}', '{"D":50,"I":24,"S":47,"C":90}', '{"O":74,"C":97,"E":49,"A":68,"N":73}', 60, '65203483-d00e-4ffa-a67b-d23f47825659', '{}', '2026-01-24T23:49:21.000Z');

-- lilian ribeiro coelho (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('f82f1aef-21b9-4568-b8be-918d787ce3d0', '63de46ec-059c-4408-9701-b2e1f169d9d6', '{"D":48,"I":75,"S":85,"C":67}', '{"D":29,"I":64,"S":73,"C":39}', '{"O":65,"C":69,"E":67,"A":93,"N":93}', 67, '43157dd8-e95a-45eb-81ef-d4f836228f8c', '{}', '2026-01-24T23:49:24.000Z');

-- Isaac Gomes de Oliveira (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('74630e9d-3328-4ac9-b9e3-fdc4229bfd03', '694fab48-6123-4b21-aced-4aac0a21fc04', '{"D":37,"I":48,"S":94,"C":89}', '{"D":14,"I":30,"S":80,"C":71}', '{"O":65,"C":82,"E":40,"A":81,"N":90}', 74, '588b56d4-dbc7-4169-9db8-7f5b742933b4', '{}', '2026-01-24T23:49:27.000Z');

-- Alexandre Diniz César (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('f43f2d57-a84e-47a2-b1fb-a96088eb2820', '67941b9d-ecf2-4ad5-81e4-81a2ecb4bd76', '{"D":70,"I":52,"S":71,"C":86}', '{"D":76,"I":39,"S":30,"C":55}', '{"O":74,"C":89,"E":59,"A":63,"N":69}', 51, '069ac0b0-93c3-47c3-baab-9328f375f8d8', '{}', '2026-01-24T23:50:23.000Z');

-- Rafael Freitas (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e8964f5c-35e4-48af-b4cf-aef817fdd709', 'fa832f7b-05df-4a78-ae56-a5d4ef916561', '{"D":71,"I":53,"S":68,"C":87}', '{"D":71,"I":61,"S":33,"C":45}', '{"O":81,"C":92,"E":63,"A":59,"N":63}', 47, '83e03d0c-6a44-476b-a312-0c429347c030', '{}', '2026-01-24T23:51:13.000Z');

-- Marcelo Fernandes Franco (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a9a08457-0ba8-452b-8f5f-a1977eebc74a', '6df4eb13-17a8-4b4a-b168-cd77429d502d', '{"D":73,"I":53,"S":67,"C":88}', '{"D":83,"I":27,"S":17,"C":71}', '{"O":81,"C":90,"E":60,"A":53,"N":69}', 51, '521f4c76-52a4-4a7b-89f8-dda7b448dc58', '{}', '2026-01-24T23:52:53.000Z');

-- ESMIRNA DA COSTA VIANNA (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b6932369-5674-4493-a719-656cd4fad583', '8694a9f6-a456-4743-a8e5-0325cbe0c542', '{"D":48,"I":60,"S":85,"C":76}', '{"D":33,"I":21,"S":60,"C":81}', '{"O":70,"C":74,"E":53,"A":85,"N":95}', 68, '20f639f3-20ca-41ae-ae4a-4a59481f69ae', '{}', '2026-01-24T23:57:27.000Z');

-- Manoel Juarez de Alencar Souza Junior (2026-01-24)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('91491a89-b3ff-4da7-88f0-1b118e7c6ae5', 'd046f034-e491-4c66-8b12-d5f668903bfa', '{"D":49,"I":48,"S":89,"C":89}', '{"D":48,"I":30,"S":60,"C":68}', '{"O":57,"C":90,"E":47,"A":69,"N":80}', 64, 'c006f472-de53-4bf4-8e6e-f7c451221356', '{}', '2026-01-24T23:59:20.000Z');

-- Joao Ricardo Diniz Silva (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b38b71ce-8094-4432-bea4-c136ef179b44', 'c2472bee-fdc3-4509-80c7-4bb1aa45bfbe', '{"D":83,"I":63,"S":58,"C":80}', '{"D":88,"I":58,"S":10,"C":52}', '{"O":85,"C":89,"E":74,"A":58,"N":53}', 40, '4cb4ed25-30ad-46dd-be98-62d88d2d6a38', '{}', '2026-01-25T00:10:38.000Z');

-- Camila de Mattos Reis  (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('84b3acd9-6ce7-461c-a388-ae96ac06c5cc', '34aa768c-1c66-400a-9dfc-8651878f5ec3', '{"D":45,"I":57,"S":86,"C":86}', '{"D":14,"I":55,"S":83,"C":61}', '{"O":69,"C":84,"E":52,"A":85,"N":78}', 61, 'ddd32bdd-4142-4f01-ae67-be79d3701e0d', '{}', '2026-01-25T00:13:05.000Z');

-- Eliemar Bueno (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('bb80c928-2e78-4878-94d8-1771198a9fa8', '21e8ff62-8043-4aad-ad9d-ea76bfb85ca6', '{"D":78,"I":51,"S":64,"C":82}', '{"D":64,"I":42,"S":43,"C":52}', '{"O":78,"C":92,"E":62,"A":59,"N":54}', 42, '883f2729-6165-4fb6-8721-3e7e8affbf57', '{}', '2026-01-25T00:13:51.000Z');

-- Leandro Machado (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e13b5f53-5fc6-4318-ac49-d350af41f823', '8f6f7bcd-147b-4f4d-b6a3-7425a2f2582c', '{"D":66,"I":38,"S":67,"C":96}', '{"D":29,"I":3,"S":57,"C":84}', '{"O":87,"C":92,"E":44,"A":58,"N":71}', 59, 'ec4cbc74-e155-4d15-9f50-9884bea9a2bb', '{}', '2026-01-25T00:26:59.000Z');

-- Luiza Caldeira Sena Deschamps (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3a11fe07-4058-46c9-bd99-854d4e0d423a', '8ce98814-f707-4ddc-ba1c-ef44bd65063d', '{"D":32,"I":67,"S":98,"C":75}', '{"D":29,"I":64,"S":80,"C":45}', '{"O":67,"C":73,"E":56,"A":98,"N":86}', 71, '81fddf35-6253-4ff0-8c85-8a05623d8fac', '{}', '2026-01-25T00:44:56.000Z');

-- Brunna Soalheiro Campos  (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('746827d7-9bf3-4eb4-8fa8-b7ffe1ee7f23', '2e51a2a9-bdf2-4b28-a593-edcd590305be', '{"D":91,"I":74,"S":54,"C":57}', '{"D":93,"I":55,"S":13,"C":39}', '{"O":93,"C":66,"E":88,"A":59,"N":49}', 41, '3d1393f2-401b-4545-aa07-5d48100a3fe2', '{}', '2026-01-25T01:14:20.000Z');

-- JULIANA ARAUJO BOTELHO BETTINI (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('0f333ff2-2508-44d7-882c-30475e7f8808', '0daa0edc-f585-4e67-bdd7-8bba34530b05', '{"D":66,"I":79,"S":71,"C":59}', '{"D":43,"I":52,"S":73,"C":39}', '{"O":81,"C":65,"E":81,"A":86,"N":63}', 44, '7cc1a7ac-0197-4788-9de8-deb90c12a9ea', '{}', '2026-01-25T01:51:55.000Z');

-- Debora Oliveira Ramos (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3e1a5c44-fde5-408d-b07c-787db205e2b1', 'f19c82b3-81ec-4d5c-8c01-34b4e93c46ff', '{"D":51,"I":42,"S":87,"C":88}', '{"D":45,"I":27,"S":57,"C":77}', '{"O":61,"C":84,"E":44,"A":68,"N":78}', 63, 'f391b326-b2f6-4e99-b95b-c45c4ada692b', '{}', '2026-01-25T02:58:27.000Z');

-- JULIANA ARAUJO BOTELHO BETTINI (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('30c3a90d-aff9-40be-a8e9-df749515d12c', '0daa0edc-f585-4e67-bdd7-8bba34530b05', '{"D":78,"I":65,"S":62,"C":75}', '{"D":62,"I":48,"S":40,"C":61}', '{"O":81,"C":82,"E":75,"A":66,"N":61}', 42, '6c657732-5049-4200-bec9-2f9754574bb3', '{}', '2026-01-25T03:58:39.000Z');

-- Izabela Dutra (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('2eeb7380-afad-4893-8d04-9292d1849cb9', '3bd54002-cc52-4b7e-a529-89bb1d4493cf', '{"D":40,"I":53,"S":94,"C":86}', '{"D":29,"I":30,"S":70,"C":68}', '{"O":57,"C":85,"E":49,"A":86,"N":80}', 66, 'f14cc5a6-7328-4a16-8beb-1aa564c2cbc7', '{}', '2026-01-25T15:23:45.000Z');

-- EDMILSON ROSSI (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('59fa0c79-e688-4f85-8485-c45d2d2d88ac', '73cea33e-fc75-4a83-adf8-cf8414211deb', '{"D":98,"I":65,"S":51,"C":62}', '{"D":95,"I":58,"S":10,"C":39}', '{"O":91,"C":69,"E":78,"A":49,"N":54}', 46, '1b7bac00-fd6e-47fe-be60-dd23f5714893', '{}', '2026-01-25T15:29:07.000Z');

-- Normandia teste (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('9fd03651-ed42-43ed-b0ac-c4f47e1738ea', 'ccc296b6-8e68-4992-8e83-71bc0c652fdf', '{"D":94,"I":78,"S":51,"C":59}', '{"D":93,"I":36,"S":10,"C":55}', '{"O":76,"C":74,"E":92,"A":61,"N":53}', 45, '7c3e9e74-755a-4098-bb3f-debb0cd09653', '{}', '2026-01-25T15:31:35.000Z');

-- Alexsandra Matos Teste (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('14e61dad-4291-43fd-a579-5240dddd62f6', 'faf7c808-eca6-4faf-a64e-6ee1954b714d', '{"D":70,"I":58,"S":68,"C":83}', '{"D":33,"I":18,"S":60,"C":81}', '{"O":78,"C":84,"E":67,"A":64,"N":64}', 46, 'b8edc60e-cbca-4b84-9bf6-e3088ed25440', '{}', '2026-01-25T15:32:09.000Z');

-- Rogério Caetano (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d8589d02-fd05-450b-a83c-315b930e1f25', '266b4311-2702-43b5-93dd-880249dc919d', '{"D":77,"I":59,"S":58,"C":84}', '{"D":67,"I":39,"S":27,"C":77}', '{"O":93,"C":87,"E":68,"A":58,"N":59}', 44, '3386ec71-8277-41e8-91ba-032d183fb990', '{}', '2026-01-25T15:34:36.000Z');

-- Heitor Francisco Costa Xavier (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('25dfb816-f3a4-4b8b-9b4d-753df17764d6', '1698bd08-75d2-4767-a7a7-cc7282ff3e8e', '{"D":67,"I":73,"S":70,"C":58}', '{"D":19,"I":48,"S":80,"C":52}', '{"O":78,"C":63,"E":75,"A":83,"N":64}', 43, 'b370667f-1bed-41db-bc1a-950a16522ffd', '{}', '2026-01-25T15:37:14.000Z');

-- Pedro Márcio Pinto de Oliveira (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('cbcc905f-a2ea-4b7b-a5b6-72e5ec7a82b7', '2aa8a601-5cf0-4aaa-a507-f8b55de62cf3', '{"D":83,"I":70,"S":61,"C":63}', '{"D":71,"I":39,"S":30,"C":65}', '{"O":89,"C":76,"E":77,"A":71,"N":53}', 39, '9bd26f34-1dee-4ec1-9d22-caf5f134dcf2', '{}', '2026-01-25T15:38:17.000Z');

-- GETULIO AIRES (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('f0681df9-689b-41de-a763-ee28bb9ba211', '69b26a0a-6129-4c87-b0a0-bfebb1b44822', '{"D":51,"I":63,"S":77,"C":82}', '{"D":43,"I":48,"S":50,"C":61}', '{"O":83,"C":82,"E":58,"A":83,"N":81}', 58, '597233ea-cf2e-422b-b8cc-1468add62d75', '{}', '2026-01-25T16:22:06.000Z');

-- José Welinton da Silva  (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('43356864-4cef-409b-bff7-d6ce6a71dd4f', '90d542b8-e008-475b-86cf-8f0a4d7307da', '{"D":83,"I":73,"S":60,"C":62}', '{"D":64,"I":67,"S":40,"C":42}', '{"O":87,"C":71,"E":84,"A":71,"N":53}', 39, '701d2a16-c373-4b1b-bcca-e3068900643a', '{}', '2026-01-25T16:24:29.000Z');

-- Jocemar Martins Calado (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('4c9ab3f0-f11b-4aaa-9e6c-ac240649a193', 'bb5e022f-821c-4eb3-a46f-fc12e0fca028', '{"D":82,"I":70,"S":60,"C":66}', '{"D":71,"I":42,"S":30,"C":61}', '{"O":94,"C":74,"E":81,"A":69,"N":53}', 38, 'd9ad674c-57e4-4125-9476-41d09dc74104', '{}', '2026-01-25T16:52:46.000Z');

-- Julia Bertello (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('70501377-8ede-49c5-927c-f1a228b48034', 'e01b3564-fec0-434c-8a08-c6553eb67d45', '{"D":52,"I":59,"S":83,"C":71}', '{"D":21,"I":70,"S":80,"C":32}', '{"O":70,"C":73,"E":58,"A":92,"N":76}', 55, '224ad85e-9ab1-4f99-afcb-d28aa489eefd', '{}', '2026-01-25T17:02:05.000Z');

-- Fabio Marques Ferreira (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3ca527bd-8b33-4b6b-a942-84f4a8d23033', '4dcd560d-73ae-4c67-a6c2-06a6f7b2da2c', '{"D":62,"I":54,"S":77,"C":71}', '{"D":83,"I":27,"S":17,"C":68}', '{"O":74,"C":74,"E":58,"A":68,"N":76}', 53, '5a764099-843e-4ea4-a883-bd532281eee2', '{}', '2026-01-25T17:47:48.000Z');

-- VALDEIR PEREIRA DOS SANTOS (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('1672c5f3-c824-4226-89e9-772876ed6b9f', '4829012e-90c3-4b14-875e-4acd61a6b569', '{"D":63,"I":74,"S":76,"C":63}', '{"D":83,"I":64,"S":23,"C":35}', '{"O":80,"C":69,"E":75,"A":85,"N":71}', 47, '9527f200-4fc9-4af7-88a9-1a5d0d028a0e', '{}', '2026-01-25T18:53:36.000Z');

-- GLADYS SYLVIA COSTA TOLEDANO CORREIA LIMA (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d38c08d3-4444-44a0-b50c-a03fee031803', 'bc7658f0-33ec-485b-a626-12757e23c56d', '{"D":79,"I":79,"S":65,"C":49}', '{"D":48,"I":67,"S":60,"C":42}', '{"O":87,"C":58,"E":85,"A":85,"N":54}', 42, 'bdd4e6e0-43ce-4c20-9d21-47086474cdd3', '{}', '2026-01-25T18:59:02.000Z');

-- Fernanda Arceno (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('479315ea-c556-4976-9f99-8894dbdb7707', '57cc967c-6a5f-4463-a4a3-1326e53c01ae', '{"D":63,"I":53,"S":75,"C":76}', '{"D":55,"I":52,"S":37,"C":52}', '{"O":72,"C":76,"E":53,"A":71,"N":81}', 56, '89ca6e12-c664-4099-9188-40abb8142fa4', '{}', '2026-01-25T19:39:33.000Z');

-- Alessandra Oliveira (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('4482c36b-4a3c-42ab-acc9-d61098bbe823', '9a98d7ba-0282-4607-91c7-6ef7cfcf537e', '{"D":49,"I":74,"S":82,"C":58}', '{"D":40,"I":58,"S":50,"C":35}', '{"O":69,"C":55,"E":67,"A":86,"N":98}', 69, '1488509b-1984-4124-b3c2-552eeeb5b3dd', '{}', '2026-01-25T19:43:01.000Z');

-- CARLA MARIANA RODRIGUES DA SILVA (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d9b2f17a-7871-46ef-b2e6-33a7c3e9e305', '42585758-a17b-414c-8343-699b3550ba6b', '{"D":61,"I":60,"S":77,"C":80}', '{"D":64,"I":61,"S":43,"C":39}', '{"O":70,"C":85,"E":62,"A":71,"N":68}', 48, '34aedf20-b8c6-4fba-be7e-be17c80d4c1d', '{}', '2026-01-25T20:06:46.000Z');

-- Michelle Aline Pereira do Vale Sanros (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('45d90b4a-5d6d-4b7d-b7e6-b5e5c4a3ab0a', '6939a06b-ac3a-494c-b5a5-5b42ee0ea65c', '{"D":65,"I":58,"S":70,"C":80}', '{"D":50,"I":39,"S":47,"C":77}', '{"O":74,"C":81,"E":62,"A":66,"N":81}', 55, 'bf903755-75c0-4429-bec7-96280408f670', '{}', '2026-01-25T20:08:32.000Z');

-- Paola Cristina Leal Colli (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('5101dafd-42ed-42ce-9c9e-b881fa59ea7c', '1af2e0bc-7cbd-4c24-a129-32e18bd20ad1', '{"D":74,"I":68,"S":65,"C":59}', '{"D":81,"I":55,"S":23,"C":26}', '{"O":85,"C":60,"E":74,"A":66,"N":78}', 51, '28d4701c-c8e4-4a2d-8f00-da4148872bc9', '{}', '2026-01-25T20:17:29.000Z');

-- GISELLE APARECIDA DA SILVA LAGE (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('69755643-2478-46ba-b609-78f4fbf4092a', '761aae85-192f-4bc9-92e6-10d8306ece5e', '{"D":62,"I":43,"S":79,"C":87}', '{"D":43,"I":45,"S":47,"C":65}', '{"O":56,"C":94,"E":48,"A":63,"N":78}', 60, '6f49ab29-f43a-4611-924a-2999e0a7bd5f', '{}', '2026-01-25T20:26:47.000Z');

-- Maria Sueli Ribeiro da Silva  (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('45a6568a-6574-4747-9f2b-c9e8bb03e8da', 'fe5b87ac-a9b6-4b31-8f34-4f64fdcd3472', '{"D":55,"I":58,"S":80,"C":76}', '{"D":10,"I":64,"S":90,"C":48}', '{"O":83,"C":74,"E":53,"A":85,"N":71}', 51, '256cfcf3-a528-428e-af69-4daa9acc3f9a', '{}', '2026-01-25T21:38:33.000Z');

-- Viviane Noronha (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d6acf5d3-1efc-42ae-bce0-8c6ce7df321a', '6b1f02fa-a53d-4aa0-b5f6-7bc6e816aabf', '{"D":93,"I":68,"S":49,"C":63}', '{"D":74,"I":36,"S":27,"C":65}', '{"O":100,"C":74,"E":81,"A":58,"N":51}', 43, '1a947fe4-b0d7-416e-928d-6c92ef8186ea', '{}', '2026-01-25T22:03:45.000Z');

-- Savana Danuza Zamai  (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3f1a4dfb-a52a-4101-8299-55009cfa33c8', 'a45e8bd7-70fb-4ad0-8613-63485c45da8c', '{"D":65,"I":57,"S":77,"C":68}', '{"D":43,"I":33,"S":60,"C":55}', '{"O":65,"C":71,"E":59,"A":75,"N":63}', 44, 'd42b1e81-8961-4ebf-a68f-f81f81c207c3', '{}', '2026-01-25T22:29:19.000Z');

-- Carlos Eduardo Montenegro da Silva (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('2e934422-045f-4925-9420-08ec5215b8ec', '41110640-209b-4133-b45c-96bc716c6f66', '{"D":32,"I":60,"S":99,"C":71}', '{"D":14,"I":64,"S":80,"C":35}', '{"O":67,"C":61,"E":48,"A":100,"N":92}', 74, '371d8493-2f85-4d5e-b5a7-653200bfbb6b', '{}', '2026-01-25T22:34:24.000Z');

-- Gabriela Mariana Dauer Rodrigues (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('12bd8a51-dc9a-4d1f-932c-785093478240', '42ef1700-8989-4057-b5c8-9f81a34af7c2', '{"D":56,"I":62,"S":75,"C":75}', '{"D":14,"I":39,"S":83,"C":74}', '{"O":78,"C":73,"E":58,"A":71,"N":90}', 61, '8351b591-aa8b-429c-82a5-a47062a0c9af', '{}', '2026-01-25T22:39:57.000Z');

-- Ketlen Machado (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('1839e26c-1994-4b61-a573-0fee03079713', '73a38d43-ad79-42b0-8f6e-745f20ffa210', '{"D":91,"I":78,"S":55,"C":53}', '{"D":79,"I":48,"S":20,"C":61}', '{"O":85,"C":68,"E":89,"A":71,"N":49}', 42, '97d05ea6-7d48-4fb1-b584-fa0ac11ce01f', '{}', '2026-01-25T22:52:57.000Z');

-- ADRIANA COELHO VIDAL (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('325581b8-b7e5-4eea-a664-ca6dac7495bf', '3dd19c06-0038-4ba1-ae4a-0d5119668b8d', '{"D":54,"I":70,"S":86,"C":63}', '{"D":50,"I":82,"S":63,"C":19}', '{"O":69,"C":69,"E":66,"A":83,"N":81}', 58, '9028a76d-1a4a-44a2-9b3e-97aaf2ff4be4', '{}', '2026-01-25T22:59:34.000Z');

-- AMILTON GUEDES SOARES FREITAS (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('4cc3cc79-37bf-4b20-9688-c4f0343f4202', 'a5537963-d26c-4f76-bcca-b9a07a890194', '{"D":55,"I":65,"S":80,"C":72}', '{"D":38,"I":61,"S":47,"C":45}', '{"O":65,"C":74,"E":60,"A":85,"N":85}', 58, 'd8ecedfc-e93d-44be-98a3-fee34752feee', '{}', '2026-01-25T23:00:14.000Z');

-- Claudio Luciano Martire  (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('55d3f97e-a5ff-45bb-a0ee-0b0019451984', '57b64a16-910b-4b68-8e09-666bae9b1e3f', '{"D":54,"I":73,"S":82,"C":71}', '{"D":64,"I":67,"S":40,"C":42}', '{"O":70,"C":77,"E":74,"A":86,"N":71}', 51, 'b4d376f8-e5ad-4233-adc4-445688bb7e7b', '{}', '2026-01-25T23:12:07.000Z');

-- HERON GUATIELLO (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d03e1170-aa43-42c0-8634-c29c1ea701a4', '8e441f29-fa22-4386-812a-27a9734cddc2', '{"D":62,"I":54,"S":73,"C":80}', '{"D":43,"I":42,"S":60,"C":68}', '{"O":74,"C":82,"E":55,"A":71,"N":75}', 53, '0f4d0679-ca61-472f-965f-b982e7c615e4', '{}', '2026-01-25T23:13:38.000Z');

-- Izabela Ferreira Loredo (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('9a540029-1d9b-4bfb-a67e-03c56ae869d4', '5b045217-45d0-42a1-ac31-6e067af8fcd5', '{"D":84,"I":94,"S":58,"C":43}', '{"D":79,"I":70,"S":20,"C":45}', '{"O":89,"C":56,"E":100,"A":85,"N":53}', 48, '628c32fa-d53d-4d0f-b079-8ba3112fa232', '{}', '2026-01-25T23:15:54.000Z');

-- WANDERLEY ALMEIDA DOS REIS JUNIOR (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a96fc1c0-1731-4dc9-b813-09802e0b9b8a', 'b7015ef2-5ca1-4c7b-9488-f84bf514c76d', '{"D":70,"I":65,"S":71,"C":61}', '{"D":36,"I":79,"S":63,"C":6}', '{"O":83,"C":60,"E":70,"A":78,"N":68}', 44, '73e9cf14-b671-444c-a1fa-90bc094f93f0', '{}', '2026-01-25T23:23:15.000Z');

-- Marianna Rezende Costa (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('ee769fa6-5649-4065-af79-06ced96793e2', '79812f83-0984-4dc2-b502-36f544dd47f7', '{"D":37,"I":49,"S":96,"C":80}', '{"D":10,"I":48,"S":77,"C":58}', '{"O":56,"C":73,"E":41,"A":85,"N":100}', 79, '9129e377-2bb4-4555-9d8a-229be610bb84', '{}', '2026-01-25T23:24:41.000Z');

-- WANDERLEY ALMEIDA DOS REIS JUNIOR (2026-01-25)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e931b820-8364-47c5-bc4a-964e130c1f91', 'b7015ef2-5ca1-4c7b-9488-f84bf514c76d', '{"D":67,"I":60,"S":76,"C":72}', '{"D":52,"I":39,"S":63,"C":45}', '{"O":74,"C":77,"E":63,"A":76,"N":66}', 44, 'cbdece0d-b67f-4656-b4c0-53a78c3ffe5c', '{}', '2026-01-25T23:36:12.000Z');

-- Ariane Roberta Santiago Freitas (2026-01-26)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('0542c76e-0e1b-43ca-8090-0d1bd2387fe4', 'c3b54dbe-65df-4c7a-a8a8-8ec2fbbe69be', '{"D":45,"I":57,"S":81,"C":71}', '{"D":7,"I":27,"S":77,"C":77}', '{"O":81,"C":63,"E":48,"A":90,"N":95}', 68, '866ddcdf-fef4-4ba9-a8fc-754cf474f0fc', '{}', '2026-01-26T00:03:31.000Z');

-- Rafael Victor de Oliveira (2026-01-26)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('dc8b6e3b-6e90-4236-88ac-1f548acf73d6', 'ce4904cc-6feb-4c57-9c78-49f9095c6126', '{"D":76,"I":57,"S":64,"C":76}', '{"D":83,"I":52,"S":20,"C":52}', '{"O":83,"C":81,"E":63,"A":54,"N":61}', 43, '988ce954-6da9-47da-b4b2-45aad67e6676', '{}', '2026-01-26T01:56:56.000Z');

-- Christiano Soares (2026-01-26)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('ef1f2f4a-dfb0-4895-9e21-ba5631246ff5', 'ba519c12-810e-465f-8b5a-c62420376889', '{"D":50,"I":67,"S":82,"C":78}', '{"D":52,"I":64,"S":60,"C":32}', '{"O":80,"C":81,"E":64,"A":88,"N":71}', 53, '07f4f302-5d44-4931-b13b-7a7585e4a3c9', '{}', '2026-01-26T14:57:42.000Z');

-- Priscila Soares  (2026-01-27)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('34bcacb4-217e-4282-90be-ffd4549a2900', '3c95f351-be74-4b06-8fd9-c892d2bc04ef', '{"D":70,"I":72,"S":65,"C":72}', '{"D":55,"I":61,"S":53,"C":45}', '{"O":87,"C":76,"E":77,"A":75,"N":64}', 41, '0f3fcf43-33c6-49e3-a323-f8b4a0a8dd1b', '{}', '2026-01-27T16:46:01.000Z');

-- Patrícia do Carmo Rezende Tomé (2026-01-27)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e0c5bd4d-3b04-4d3e-b33b-32e5913720b2', '868b19ec-50c4-4739-9fce-24cde71de86b', '{"D":46,"I":60,"S":88,"C":74}', '{"D":26,"I":52,"S":67,"C":39}', '{"O":67,"C":71,"E":51,"A":86,"N":92}', 68, '51cc0d7a-f8f1-4747-a674-35a415d7ede8', '{}', '2026-01-27T17:45:46.000Z');

-- GIANCARLO DAL MULIN (2026-01-28)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a92efde4-4457-4e96-8c4e-a7b2e55ab1cc', 'c1f8fe80-3973-44c6-ad01-4a7b4c968126', '{"D":74,"I":63,"S":69,"C":70}', '{"D":60,"I":55,"S":53,"C":39}', '{"O":74,"C":77,"E":68,"A":61,"N":66}', 43, '344592e0-e74d-41d5-9668-c84d2aa060bd', '{}', '2026-01-28T23:06:21.000Z');

-- FRANKY LUCIO VALERIO BARBOSA (2026-01-28)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('4fe9d3bf-7845-4475-a7cc-3385986ccf08', '1c8c5994-6fd5-448b-9b11-2b98548628e6', '{"D":57,"I":53,"S":79,"C":88}', '{"D":48,"I":39,"S":60,"C":58}', '{"O":76,"C":94,"E":56,"A":80,"N":66}', 51, 'e410564e-47c1-4aa5-9a6e-429b98285fbb', '{}', '2026-01-28T23:12:53.000Z');

-- Grace Kelly dos Passos  (2026-01-28)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('5699a074-1528-4638-b05d-f8e18874cc0d', 'd06ae83e-fa21-4cfd-b131-7c8e683efdd7', '{"D":71,"I":49,"S":65,"C":87}', '{"D":48,"I":9,"S":57,"C":87}', '{"O":78,"C":87,"E":59,"A":58,"N":69}', 52, 'a46fd72c-5c0c-4674-ad30-2aca5edb5511', '{}', '2026-01-28T23:26:33.000Z');

-- Thalia de jesus da hora da silva  (2026-01-29)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e40cab4f-a4ce-4a39-947e-b91921fa734c', 'ed18b059-2236-4d6f-b081-6d27c1bf3068', '{"D":66,"I":63,"S":77,"C":67}', '{"D":38,"I":58,"S":73,"C":48}', '{"O":65,"C":77,"E":67,"A":78,"N":58}', 39, 'e57805a9-c272-4025-94d9-88ef03f156da', '{}', '2026-01-29T01:42:31.000Z');

-- DJESMI TOMÉ (2026-01-29)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('53e5686f-8dfd-46c3-8795-4e7f6860745c', '9ebdfa95-88ef-465c-9388-5c6dc2a57ad9', '{"D":71,"I":62,"S":68,"C":71}', '{"D":60,"I":55,"S":53,"C":39}', '{"O":87,"C":74,"E":67,"A":66,"N":66}', 43, 'bfe2a352-2ab5-43ad-8dbc-b562ab901661', '{}', '2026-01-29T21:10:00.000Z');

-- MARCELA MARTINS DE OLIVEIRA (2026-02-01)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('daa57891-1262-4560-9189-cb3a68ec8be5', 'de8fe340-5aad-4822-a667-30a2a1ac4156', '{"D":71,"I":75,"S":69,"C":61}', '{"D":55,"I":76,"S":53,"C":32}', '{"O":80,"C":69,"E":79,"A":83,"N":66}', 44, '37db89d3-714c-4478-9a79-b37309e8ae66', '{}', '2026-02-01T22:08:13.000Z');

-- Normandia (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b4c1fac7-00a9-4707-b9ae-9a75707b6d77', '84b1fe65-fd39-4b66-a5e9-9fa762f619e6', '{"D":71,"I":75,"S":67,"C":51}', '{"D":38,"I":94,"S":63,"C":16}', '{"O":85,"C":58,"E":77,"A":83,"N":75}', 52, '9127c598-20de-4020-8206-52069128143e', '{}', '2026-02-06T22:42:46.000Z');

-- Teste Usuario 1 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('969dbaeb-a3bb-4730-8759-6182bdb9cc43', '185bfe3e-9e62-462a-aeb7-29fdb864e206', '{"D":72,"I":68,"S":70,"C":64}', '{"D":76,"I":76,"S":33,"C":26}', '{"O":74,"C":73,"E":71,"A":78,"N":61}', 39, 'e16a8f7f-5bad-4017-8d8a-001a7fcb77d2', '{}', '2026-02-06T22:52:13.000Z');

-- Teste Usuario 65 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('8642b4b7-0d5e-4e7c-9018-ce5f4c532414', '0626a25f-fcda-4a5b-9e75-a862e7d77627', '{"D":65,"I":69,"S":75,"C":64}', '{"D":50,"I":30,"S":47,"C":65}', '{"O":76,"C":74,"E":68,"A":78,"N":71}', 46, '58462eac-fecd-4372-a78b-309b4e938308', '{}', '2026-02-06T22:52:13.000Z');

-- Teste Usuario 59 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b31140f0-63cf-479c-9679-f731cd483e3c', 'c6b42192-f4eb-4aa3-a30e-9ba19b501951', '{"D":68,"I":75,"S":70,"C":59}', '{"D":57,"I":39,"S":47,"C":65}', '{"O":78,"C":68,"E":74,"A":80,"N":76}', 50, '48c32862-50d7-4c4e-8d7b-20798e0d7092', '{}', '2026-02-06T22:52:13.000Z');

-- Teste Usuario 3 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('57550b30-7503-4bc0-a57f-b341103241d0', '1b9fcc3b-7b28-4c51-9699-4ebe42658e8c', '{"D":56,"I":59,"S":79,"C":72}', '{"D":40,"I":27,"S":47,"C":81}', '{"O":63,"C":77,"E":56,"A":76,"N":88}', 60, 'edecea95-392a-4bcc-adc3-cdfce167905d', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 4 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('677ef7b5-a8d3-45e9-9cf8-aaa640741574', '06e6a752-d682-4394-b7ae-9a83fd100f94', '{"D":61,"I":51,"S":73,"C":87}', '{"D":38,"I":33,"S":60,"C":61}', '{"O":69,"C":90,"E":52,"A":68,"N":78}', 58, '78fafbba-f49b-4ee6-be35-ea5e8a584dcf', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 55 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('2cbaaa31-1255-4470-be2d-b9ae11b6e99c', '325659fb-88b4-48e3-afbd-68d290427850', '{"D":72,"I":70,"S":71,"C":62}', '{"D":83,"I":67,"S":23,"C":32}', '{"O":70,"C":76,"E":77,"A":76,"N":66}', 43, 'c9d4fd49-50e2-4085-980c-eadd89cc6f8b', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 37 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('095288d9-bcb8-45be-a335-47e452d9cf3f', '2d562173-1039-4bcd-b973-ddd3f2547cec', '{"D":62,"I":60,"S":75,"C":72}', '{"D":33,"I":42,"S":67,"C":52}', '{"O":70,"C":79,"E":59,"A":78,"N":71}', 48, '48046728-bd51-4077-8066-94d801cb0d1d', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 2 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e54316fd-4365-4e19-b187-1f6ac9e743bd', 'a930c3b7-c9ca-4095-b640-4628a305d608', '{"D":59,"I":65,"S":80,"C":66}', '{"D":33,"I":42,"S":67,"C":52}', '{"O":69,"C":69,"E":63,"A":86,"N":73}', 50, '7a4a6302-1328-4e14-9b96-97e8495ce784', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 26 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('fb064d54-ad3a-4a53-8d49-a7ce8168a86e', '4864b7ce-552e-4aea-867e-ee4481f0423a', '{"D":66,"I":62,"S":73,"C":66}', '{"D":60,"I":33,"S":40,"C":52}', '{"O":76,"C":73,"E":64,"A":71,"N":75}', 48, '639fe77e-ace5-4e50-8d54-7748aabaf2c4', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 15 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('0c939b91-da2b-4636-8521-8727c3a0808e', 'b38abf89-f140-417d-8cce-3fa61c06dd76', '{"D":82,"I":65,"S":61,"C":71}', '{"D":81,"I":61,"S":20,"C":32}', '{"O":85,"C":76,"E":73,"A":56,"N":63}', 44, '8fc35efd-43a9-4fde-b675-13651664d705', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 35 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('bbd9c109-1c14-4c2c-b1b3-15512bf83c90', 'c6a70ee6-114b-4c52-8ec8-75b56cccae5f', '{"D":46,"I":69,"S":87,"C":64}', '{"D":26,"I":42,"S":67,"C":65}', '{"O":67,"C":68,"E":62,"A":95,"N":85}', 63, 'eac6089b-ab10-4e10-9e7d-085a86ede4d2', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 43 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3fc04910-2c08-43b6-9490-42fd6a89e1b3', '3d3bb611-f3ab-4b0d-95ad-dc66d53bae33', '{"D":79,"I":72,"S":67,"C":61}', '{"D":40,"I":73,"S":70,"C":32}', '{"O":76,"C":68,"E":81,"A":73,"N":58}', 40, '7371fdaf-14c3-4288-a9d0-d9b4d9e464d8', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 79 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a5c0e93f-8830-487b-8242-db118fe5437e', '51761dbe-6d5e-4d09-a840-41cf037b7376', '{"D":54,"I":51,"S":79,"C":78}', '{"D":36,"I":64,"S":63,"C":23}', '{"O":69,"C":76,"E":49,"A":73,"N":83}', 60, '5366eaed-33f3-49f4-8ed9-4db877f26381', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 6 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('24006704-ade7-4e47-b477-91ba3eb7f4f1', '1ebcd88e-590e-4792-af48-6dd7098daa7e', '{"D":59,"I":65,"S":77,"C":71}', '{"D":40,"I":39,"S":50,"C":52}', '{"O":61,"C":73,"E":63,"A":78,"N":85}', 56, 'f97ed20a-2263-4ab6-a44c-f74fa573b2d9', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 7 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('9ebc2790-8025-45a1-96ff-25b1ef628c44', '97629cd0-c538-45d0-b2f2-7fa6479d0149', '{"D":67,"I":38,"S":75,"C":87}', '{"D":60,"I":18,"S":37,"C":71}', '{"O":65,"C":87,"E":45,"A":56,"N":75}', 59, '54ff7751-c787-415d-a42b-f36e3c0d289d', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 38 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('87f4eb5b-db27-432d-bb73-92201a26471d', 'ba0369db-224e-4c7e-a6af-2bc109b6e33d', '{"D":73,"I":85,"S":67,"C":54}', '{"D":55,"I":76,"S":40,"C":32}', '{"O":81,"C":60,"E":88,"A":86,"N":68}', 50, '4c160c1b-da94-451d-95aa-d3c64cbb39d6', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 16 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('2033f815-bf83-49a7-b490-47de7151e7b3', 'adf04198-31cc-4360-9bf1-1e8165baf1f7', '{"D":61,"I":57,"S":79,"C":79}', '{"D":60,"I":48,"S":43,"C":61}', '{"O":61,"C":85,"E":59,"A":71,"N":76}', 54, '32c1fd84-f0a7-4c1d-be7c-8a9f566cd6a8', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 76 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('80859157-2c8f-4ce2-a9db-decc63448c59', '8df5b863-1275-485e-a44c-9922dd213245', '{"D":70,"I":74,"S":76,"C":55}', '{"D":50,"I":100,"S":53,"C":3}', '{"O":59,"C":68,"E":77,"A":85,"N":64}', 45, '7e65ffd5-924d-4135-be10-b5cad7fa1987', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 9 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b7c8ca83-ecf3-49ee-be33-fe5e3ca23540', '885dfa03-58c5-44e5-a11e-926e6a98fbd0', '{"D":72,"I":67,"S":64,"C":67}', '{"D":62,"I":55,"S":37,"C":35}', '{"O":80,"C":65,"E":73,"A":66,"N":80}', 50, 'be38b623-35ce-4f50-a093-d01ba084ef73', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 17 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('ef8bba5e-b466-4592-b3c0-5d7d891eb3f9', 'fcc522f8-8c8a-400e-830f-d4897251d5ac', '{"D":67,"I":70,"S":71,"C":62}', '{"D":55,"I":33,"S":47,"C":71}', '{"O":78,"C":66,"E":71,"A":73,"N":75}', 48, '890f4e6a-ff5d-4065-a07e-51fd7baa31eb', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 8 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('bd466273-a639-4f82-ba8a-531f489b5934', '3452d9cc-41c6-46b4-b502-0464cd789285', '{"D":57,"I":60,"S":80,"C":75}', '{"D":52,"I":52,"S":53,"C":52}', '{"O":69,"C":77,"E":62,"A":80,"N":71}', 50, 'fcf84679-0436-4278-b20c-0bbf9af7f333', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 23 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('2144698d-3b85-4124-996d-aef159a6588c', '6ef53b8d-57a7-4a19-a07f-5d6d1da59300', '{"D":57,"I":65,"S":75,"C":71}', '{"D":50,"I":24,"S":40,"C":55}', '{"O":67,"C":74,"E":67,"A":76,"N":76}', 51, 'a32e88b5-af06-43ab-a7ea-e97dfaca0649', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 5 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('667eba5f-2c4f-47da-a4af-cb16b069197a', '44a4d7f2-966f-4da3-b29e-555e66e93bac', '{"D":68,"I":68,"S":75,"C":61}', '{"D":64,"I":61,"S":43,"C":39}', '{"O":76,"C":68,"E":68,"A":75,"N":63}', 42, 'd95d7317-64a0-4aa9-b195-f453d2dc5619', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 11 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('7daaa4ec-5369-4632-b8f2-93dcfc08dd27', 'bf478d63-9372-4d53-a538-7bbb3dcbe010', '{"D":73,"I":64,"S":70,"C":70}', '{"D":71,"I":36,"S":27,"C":68}', '{"O":70,"C":79,"E":67,"A":68,"N":69}', 44, '96c33fbb-06bb-458f-a38b-ac8538f24ac2', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 13 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d330ad69-2d1c-433f-a5ff-fb01d725949d', '1244b92c-8272-4b24-a761-c704afbb9e7d', '{"D":56,"I":63,"S":80,"C":68}', '{"D":10,"I":27,"S":90,"C":68}', '{"O":63,"C":69,"E":60,"A":78,"N":86}', 59, '63582263-f1f9-41d4-bfbb-fca896a8ebb5', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 14 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('c4b9c00a-d73d-4b16-84c6-b8b352b4c474', 'a071a373-7f2d-46c9-9781-68d637b1683c', '{"D":46,"I":48,"S":89,"C":91}', '{"D":31,"I":21,"S":57,"C":90}', '{"O":61,"C":90,"E":42,"A":75,"N":92}', 72, 'ec3a8ac0-f536-4193-8aa7-cd5c32a9f047', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 50 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a601ef58-9494-47db-8466-59ad8d42b5a8', '7203e593-8a57-451b-8def-e8d041c9f62c', '{"D":62,"I":67,"S":68,"C":75}', '{"D":43,"I":52,"S":37,"C":58}', '{"O":81,"C":71,"E":67,"A":73,"N":83}', 54, '5859d8ed-c22a-4851-a02d-d2aab6431e81', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 12 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('00ee9b24-e9cf-4270-bf94-5598a432b2af', '57424ef5-6e94-47c7-b4dd-c990dafac6b9', '{"D":61,"I":79,"S":74,"C":51}', '{"D":38,"I":73,"S":50,"C":29}', '{"O":81,"C":55,"E":71,"A":90,"N":85}', 60, '810861d8-f5ee-4f9c-908f-2a51bcc016f8', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 1 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('03feca37-b73a-4ecd-beff-653c6314027b', '4c8fa2cc-1814-469a-b859-d30fec5789a4', '{"D":70,"I":74,"S":69,"C":66}', '{"D":74,"I":58,"S":27,"C":52}', '{"O":72,"C":69,"E":77,"A":76,"N":69}', 44, '3e4fb4e4-cb87-4fac-aa05-b17e0483f157', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 10 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('dfbd75bc-bbeb-4e1c-9543-deea53c26240', '47ed1d9f-17d8-49c1-ab2a-625903b19881', '{"D":71,"I":49,"S":67,"C":87}', '{"D":50,"I":30,"S":57,"C":68}', '{"O":78,"C":90,"E":60,"A":59,"N":68}', 52, '4f752503-7f03-40f8-927b-ff9501496397', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 24 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('74371700-08f3-4625-a4b8-085cd981b689', 'bc6fd430-976f-4989-a65f-01720fdecd75', '{"D":56,"I":58,"S":82,"C":75}', '{"D":40,"I":58,"S":60,"C":42}', '{"O":69,"C":79,"E":59,"A":81,"N":78}', 56, 'c0a4f3d9-bd66-4955-b35a-a131d10b57c4', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 18 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('f4d1398e-aeeb-4f73-b81b-5da818a8de13', '21a20fb5-f6ae-484f-b6f4-c43baf1dfedb', '{"D":72,"I":68,"S":64,"C":68}', '{"D":45,"I":9,"S":50,"C":81}', '{"O":85,"C":68,"E":74,"A":64,"N":75}', 47, '0bd496fe-65a3-4298-8763-1e6713ae1466', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 21 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('688e5b27-b06b-43d5-9bd5-8c93384e66ac', 'eb8311e1-c842-4076-8dd2-15ec96574e3e', '{"D":61,"I":72,"S":76,"C":63}', '{"D":24,"I":52,"S":80,"C":42}', '{"O":69,"C":68,"E":70,"A":81,"N":69}', 46, '4434571b-d113-4e8d-9b4c-81b3d2e92c76', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 30 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('dedbde56-70dd-43da-a037-0f413b4f99f9', 'f134fc1a-f2c0-442a-82c4-f104adc12ae3', '{"D":50,"I":53,"S":88,"C":72}', '{"D":36,"I":55,"S":60,"C":55}', '{"O":54,"C":69,"E":49,"A":76,"N":85}', 63, 'aa3a1245-209a-4daa-a1e6-dfd0654fc493', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 29 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('5737af97-bbab-45f0-96cf-cfc59d33ae1d', '41678193-c974-43cb-b18d-a3ac86611862', '{"D":68,"I":74,"S":67,"C":61}', '{"D":62,"I":76,"S":30,"C":19}', '{"O":78,"C":63,"E":75,"A":78,"N":71}', 46, 'bc889d3f-32b5-4a02-9b1c-1a0e99e95686', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 33 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('5fd63dec-03a4-4db5-8a95-e2fe4130b461', '03e2f1ec-0bbd-4545-817a-5c1604935876', '{"D":76,"I":73,"S":68,"C":58}', '{"D":62,"I":64,"S":40,"C":48}', '{"O":80,"C":65,"E":77,"A":76,"N":68}', 46, '9dffdb95-acc5-4556-8275-a295adb2fcdc', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 25 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a28f0a0a-69dc-4fed-8492-70204f5072aa', '6aac75ee-e2df-4885-b96c-fe13116ed8ac', '{"D":61,"I":56,"S":73,"C":67}', '{"D":38,"I":15,"S":50,"C":68}', '{"O":76,"C":69,"E":58,"A":73,"N":80}', 53, 'c6dd2c13-7e9a-43b8-99cf-4554d00baff1', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 19 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e121003b-aa92-4d00-b17f-c62bad1d495e', '852b851a-0ed3-42ea-b4d5-1fe7f26de1ce', '{"D":61,"I":62,"S":73,"C":74}', '{"D":38,"I":79,"S":50,"C":29}', '{"O":80,"C":73,"E":63,"A":75,"N":73}', 49, '20b33359-c8e2-485e-9128-f64c3e7da500', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 46 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d73b5026-3701-4cfc-8c09-73c9cbf0a4c9', '07e34ee5-854d-4fca-9e60-5ac05084de5a', '{"D":71,"I":64,"S":65,"C":68}', '{"D":71,"I":24,"S":17,"C":77}', '{"O":89,"C":69,"E":64,"A":64,"N":76}', 48, 'fb0a39c2-4955-4d61-bbbc-925262d38c7c', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 34 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e5bb07d5-81a6-4bfb-a660-292e47248e80', '5c2343a8-0169-4071-990b-d4a44e170431', '{"D":71,"I":72,"S":65,"C":64}', '{"D":60,"I":58,"S":47,"C":45}', '{"O":85,"C":68,"E":74,"A":78,"N":68}', 44, '9d6aca1a-acdf-41e7-9a7a-031072e558bd', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 20 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('85bb3624-3805-4f07-b37a-e785549eda73', 'b33e278c-00c0-44d0-9df6-f66b5d4c486d', '{"D":63,"I":75,"S":75,"C":62}', '{"D":55,"I":58,"S":50,"C":52}', '{"O":63,"C":68,"E":75,"A":85,"N":80}', 53, '88ee1b98-32cd-4f95-b8be-104817a53900', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 27 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('49fafaa2-d6fe-47a1-a4ab-5c5c4da4d9dc', '43b115bd-7252-40d4-a6e9-26fd5ee8beb8', '{"D":56,"I":70,"S":80,"C":66}', '{"D":29,"I":39,"S":80,"C":58}', '{"O":70,"C":74,"E":67,"A":86,"N":68}', 48, '5765f0cb-a984-46c9-88b3-b788bfdb2a43', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 59 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('72e26fa2-6308-4122-98da-77587871fcb6', 'd9e419ca-b006-458f-9d24-5c03f3141073', '{"D":79,"I":58,"S":61,"C":72}', '{"D":60,"I":33,"S":40,"C":77}', '{"O":91,"C":77,"E":64,"A":66,"N":61}', 43, '2860bb16-a8e7-4746-9604-ddab9205e6dd', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 47 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e01a2a6b-6071-4293-9945-4ce6643df062', 'bbf9db02-ae2d-4030-b449-5fd1202a0fc6', '{"D":71,"I":80,"S":73,"C":54}', '{"D":45,"I":88,"S":50,"C":29}', '{"O":70,"C":61,"E":79,"A":83,"N":73}', 51, '3678e7f1-f293-4932-8a5a-540f92196ba2', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 36 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('24527d53-e87f-441b-a62a-52b604febffa', '458adcc0-fc7d-4eab-8034-77d45978c1c6', '{"D":49,"I":70,"S":87,"C":66}', '{"D":29,"I":67,"S":67,"C":45}', '{"O":56,"C":69,"E":64,"A":95,"N":90}', 65, '106a5bb1-6eb6-47a2-979f-d316f20a82b3', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 28 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('6d6a117f-2e51-4281-8cf8-834eaeec47fd', '42ab47e7-fae7-4db6-a3ef-4bfb324a0be2', '{"D":56,"I":59,"S":77,"C":76}', '{"D":52,"I":58,"S":30,"C":48}', '{"O":76,"C":76,"E":59,"A":75,"N":80}', 56, 'e80f5b10-7863-4d50-924d-f4c36911d0a8', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 39 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('dc46bf14-29d7-420d-89c8-997f6c261acd', '0071b282-d549-45b2-90ac-7c96c6b1eda9', '{"D":67,"I":60,"S":71,"C":71}', '{"D":48,"I":3,"S":47,"C":84}', '{"O":76,"C":77,"E":66,"A":83,"N":73}', 47, 'cd7da972-6f36-496c-ab35-e958706edd2e', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 52 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3c11a873-b6bf-44e7-ac2c-3a574762b1f9', 'd464505e-75ea-4404-82d3-63c8fb05a5d4', '{"D":57,"I":60,"S":77,"C":76}', '{"D":52,"I":39,"S":30,"C":61}', '{"O":70,"C":76,"E":59,"A":75,"N":78}', 54, '01851d31-a5dc-4078-8233-b98880fe418d', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 60 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b4edac0d-9c1c-449e-b38b-dd5b9be585bb', 'ec7b70d7-7f5a-4694-9ac3-b556e81db039', '{"D":67,"I":62,"S":68,"C":76}', '{"D":57,"I":15,"S":50,"C":74}', '{"O":85,"C":77,"E":66,"A":64,"N":75}', 49, '3b93aa8c-5766-4b95-84db-d36f83983656', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 45 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('65c4bfb0-e6bc-4f83-80d9-6a33386767b0', 'dd057469-b161-4ba5-bf0e-4a74118e971b', '{"D":63,"I":56,"S":73,"C":79}', '{"D":57,"I":18,"S":27,"C":71}', '{"O":80,"C":77,"E":56,"A":68,"N":85}', 58, '6ff93ac6-f0db-4949-a4dc-ffdbfd202feb', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 49 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('782cd072-2e2b-41c5-8411-542210d76976', '56652bfe-7962-426b-88ea-d44fb9288bb2', '{"D":57,"I":78,"S":79,"C":61}', '{"D":45,"I":82,"S":50,"C":29}', '{"O":76,"C":60,"E":74,"A":93,"N":85}', 59, '4f7544dd-8f1f-4b1d-9c45-0a17581bfa39', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 64 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('95c2b62a-ea8b-4a13-bc36-d0beca12ea54', 'ecbb0bf3-7d6d-492f-8de2-322150cf7be2', '{"D":79,"I":81,"S":62,"C":50}', '{"D":57,"I":73,"S":50,"C":35}', '{"O":83,"C":58,"E":84,"A":76,"N":64}', 49, '7c67938b-8dfc-47bc-9554-c20fc046b2d7', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 83 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('dfe84500-75da-40f5-8b1a-06583de6c4e5', 'a28015ea-6ac7-4d50-81ff-b5b3ae1f7c72', '{"D":66,"I":62,"S":69,"C":70}', '{"D":45,"I":9,"S":37,"C":84}', '{"O":76,"C":73,"E":62,"A":75,"N":85}', 53, '884e5edd-3fe7-4f31-9fc9-085964f381f9', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 48 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('6d9d18d9-920c-42da-b9e2-172bdcd70997', 'c19d3e72-87e8-4957-b9da-61be9a214818', '{"D":68,"I":62,"S":74,"C":70}', '{"D":74,"I":64,"S":30,"C":45}', '{"O":65,"C":74,"E":66,"A":66,"N":75}', 48, '9586669b-bde9-4ecc-a2f0-520453bda3b2', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 62 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('eda788f6-dd19-416b-8f1b-55ec1e461bf9', '22cdd2b6-b277-4151-802d-417860536577', '{"D":54,"I":70,"S":77,"C":70}', '{"D":76,"I":52,"S":33,"C":39}', '{"O":78,"C":73,"E":67,"A":81,"N":83}', 57, '3758eed0-2fd5-447d-b126-349df53d92d2', '{}', '2026-02-06T22:55:21.000Z');

-- Teste Usuario 40 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a58d4331-7291-47a4-a150-646264c2785b', '080a3db4-067b-4885-8f05-d8a948492c1a', '{"D":85,"I":69,"S":58,"C":63}', '{"D":69,"I":82,"S":33,"C":13}', '{"O":78,"C":69,"E":78,"A":63,"N":63}', 46, '13eb5a4c-bf24-465d-9887-e8bf158713d7', '{}', '2026-02-06T22:55:22.000Z');

-- Teste Usuario 41 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('71fdd27a-8048-41c1-9c5c-27143bcd54d4', 'd0b89f80-55c5-4532-8819-71269f4d6200', '{"D":76,"I":58,"S":65,"C":80}', '{"D":52,"I":3,"S":37,"C":94}', '{"O":70,"C":89,"E":67,"A":61,"N":63}', 45, '17ab9161-b9b6-4f29-b4cb-5d1c6ce29709', '{}', '2026-02-06T22:55:22.000Z');

-- Teste Usuario 51 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e7d18bad-a10a-426b-b8b8-92d76f4a0a4e', '81bfb552-5448-45c9-ab36-eb35c0dca237', '{"D":68,"I":64,"S":74,"C":70}', '{"D":79,"I":58,"S":30,"C":35}', '{"O":61,"C":77,"E":71,"A":69,"N":68}', 44, '6e4aab5c-3380-4528-88aa-be7c4aeac72a', '{}', '2026-02-06T22:55:22.000Z');

-- Teste Usuario 54 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('c1f5fb3b-ae17-4f80-871b-e9094239c292', 'f87dfe90-1dd5-4227-a3ba-5934e1d1e60d', '{"D":54,"I":52,"S":81,"C":72}', '{"D":33,"I":21,"S":57,"C":61}', '{"O":74,"C":66,"E":51,"A":76,"N":78}', 57, '81091bda-b8c1-4046-8545-836ec3c0172d', '{}', '2026-02-06T22:55:22.000Z');

-- Teste Usuario 22 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3803ee18-21b1-4b50-9a53-ebaec4d3b4c6', 'abb590fe-3e59-4814-82e9-e8c9cca07b0c', '{"D":44,"I":62,"S":87,"C":79}', '{"D":33,"I":58,"S":57,"C":58}', '{"O":63,"C":77,"E":59,"A":88,"N":92}', 68, 'd0c48322-41fa-4d16-b66a-a9bcb8b00668', '{}', '2026-02-06T22:55:22.000Z');

-- Teste Usuario 44 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('c7b6210f-cbdd-4d5d-bb30-660a281cee2e', 'c9f764fe-65e3-4d2c-8a9d-058216dcf286', '{"D":57,"I":62,"S":79,"C":71}', '{"D":33,"I":36,"S":70,"C":48}', '{"O":70,"C":74,"E":60,"A":81,"N":71}', 49, '3c8e17b2-73e4-4dd8-b4b1-a53ba3a9b4bc', '{}', '2026-02-06T22:55:22.000Z');

-- Teste Usuario 84 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('f855f782-4520-4967-91ca-ff1101b314ee', '96ff7a0b-54c1-4997-a101-be1998970592', '{"D":72,"I":54,"S":67,"C":75}', '{"D":81,"I":55,"S":17,"C":39}', '{"O":74,"C":77,"E":56,"A":59,"N":73}', 50, 'ff90376c-339e-44a3-aab9-028424059f97', '{}', '2026-02-06T22:55:22.000Z');

-- Teste Usuario 86 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b4e24576-69b1-48c6-be75-4da81e05d777', '1a0cfa3a-c77e-4452-b76d-ef34fcd96c10', '{"D":56,"I":65,"S":82,"C":59}', '{"D":40,"I":76,"S":53,"C":19}', '{"O":70,"C":65,"E":62,"A":85,"N":80}', 56, '10540c90-551f-4102-913a-b6dcd5a44575', '{}', '2026-02-06T22:55:22.000Z');

-- Teste Usuario 77 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('6b56741a-c03a-4f27-9d2e-972b200e765c', '59b7e015-6a65-4773-95a9-d8cb9734ad34', '{"D":54,"I":70,"S":80,"C":66}', '{"D":43,"I":55,"S":63,"C":32}', '{"O":76,"C":69,"E":67,"A":88,"N":75}', 52, '382b336b-1c73-41a2-b11f-e26c15979a89', '{}', '2026-02-06T22:55:22.000Z');

-- Teste Usuario 53 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('7db5654a-a1f2-4ee1-99a9-87cfc1ddb6cc', '0b662ed5-bced-4925-a85a-5bd157469fb7', '{"D":67,"I":54,"S":70,"C":71}', '{"D":29,"I":9,"S":67,"C":87}', '{"O":69,"C":74,"E":59,"A":66,"N":78}', 52, 'c029c666-3b14-4e74-857a-005bc9ed7f81', '{}', '2026-02-06T22:55:23.000Z');

-- Teste Usuario 99 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3ba729c1-e156-4dde-b973-551221b107ba', 'ce6301ce-217f-4c12-bea6-55c529a37bf7', '{"D":55,"I":56,"S":86,"C":80}', '{"D":31,"I":48,"S":70,"C":48}', '{"O":70,"C":82,"E":56,"A":81,"N":76}', 57, 'efcefabf-8327-4c2f-ae21-6e4dfbb5f82a', '{}', '2026-02-06T22:55:23.000Z');

-- Teste Usuario 65 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e60fbaab-0019-4efc-b7e7-f26e6a7ee714', 'ad047540-4bc0-4745-807b-a09961bdf001', '{"D":85,"I":64,"S":63,"C":58}', '{"D":62,"I":52,"S":50,"C":39}', '{"O":81,"C":69,"E":75,"A":69,"N":58}', 43, '96b17e60-88e8-4891-b95e-821c2c58ce4d', '{}', '2026-02-06T22:55:23.000Z');

-- Teste Usuario 89 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('22a43cd8-8fb2-40c2-882d-ac625f84a5d5', '951e29e2-4524-40fb-b1ab-b7217693bc51', '{"D":76,"I":79,"S":68,"C":47}', '{"D":55,"I":42,"S":57,"C":42}', '{"O":81,"C":58,"E":81,"A":83,"N":66}', 50, 'a788d89a-d991-4c17-802f-343dfb8748a0', '{}', '2026-02-06T22:55:23.000Z');

-- Teste Usuario 57 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('a72e6516-bde9-4fdd-88d4-3b8446209937', '2801fdcc-e2f5-4e43-a050-7553e7312910', '{"D":59,"I":62,"S":80,"C":68}', '{"D":38,"I":33,"S":63,"C":58}', '{"O":61,"C":74,"E":63,"A":73,"N":73}', 50, '9d0e5895-eb5a-4dc0-86f5-07918008d9b0', '{}', '2026-02-06T22:55:23.000Z');

-- Teste Usuario 32 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b7736f6e-172d-4564-897c-d2ff2dc59078', '5f8a4b2e-ad7f-44b0-a0e4-bed87f989e26', '{"D":76,"I":69,"S":69,"C":68}', '{"D":64,"I":70,"S":40,"C":42}', '{"O":70,"C":74,"E":77,"A":75,"N":66}', 42, 'e9bc64a0-8f9b-437c-9cdf-dd9529f10ba0', '{}', '2026-02-06T22:55:23.000Z');

-- Teste Usuario 69 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e9fc4a22-0bdd-458b-a7c4-a8609249d8a2', 'fde3838e-bc1c-4db5-8d96-b717d6a8aaf9', '{"D":61,"I":69,"S":75,"C":66}', '{"D":31,"I":64,"S":60,"C":35}', '{"O":65,"C":68,"E":70,"A":76,"N":80}', 52, 'c4c46986-f57c-4a32-9bb6-c4d01d343257', '{}', '2026-02-06T22:55:23.000Z');

-- Teste Usuario 66 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b6b9b2d8-0420-4b53-9844-7c66bedd5112', 'e200ed47-7306-4990-b967-2c29073315cd', '{"D":65,"I":65,"S":68,"C":63}', '{"D":71,"I":48,"S":20,"C":39}', '{"O":83,"C":61,"E":66,"A":68,"N":76}', 47, 'aa87ea54-a273-4c47-a5fa-81dc868075a6', '{}', '2026-02-06T22:55:24.000Z');

-- Teste Usuario 58 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('f0ab2add-1ac5-432f-b01c-32b2e8d08c24', '2139b0ab-6090-45e8-93f0-4f87e58ef8fe', '{"D":57,"I":58,"S":80,"C":74}', '{"D":60,"I":58,"S":43,"C":32}', '{"O":69,"C":77,"E":55,"A":71,"N":83}', 58, '39e6a6b9-e5be-4778-bb10-70e9bffe62f3', '{}', '2026-02-06T22:55:24.000Z');

-- Teste Usuario 73 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('4966cef3-e6a4-40a7-9e6c-116dfd8d0d82', 'ef22c362-018c-442d-8bbb-b8c063cf2e13', '{"D":50,"I":57,"S":85,"C":86}', '{"D":50,"I":24,"S":57,"C":71}', '{"O":63,"C":89,"E":55,"A":81,"N":83}', 63, 'e74afd84-64e7-4db0-98ca-d6b12bd5192b', '{}', '2026-02-06T22:55:25.000Z');

-- Teste Usuario 98 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('96c741a4-9755-4758-9fa1-60e01e110a20', '4780a2ae-55aa-4052-8304-c7451c2157a6', '{"D":67,"I":63,"S":77,"C":72}', '{"D":71,"I":42,"S":30,"C":61}', '{"O":57,"C":87,"E":67,"A":73,"N":75}', 49, 'b741a142-c0df-4854-83af-055ecdaad804', '{}', '2026-02-06T22:55:25.000Z');

-- Teste Usuario 68 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('18ef7368-5c4b-4eed-89ac-02438a4047d2', 'a6c5d631-97de-42b6-88f0-20bd126e48e9', '{"D":66,"I":67,"S":71,"C":54}', '{"D":33,"I":36,"S":60,"C":45}', '{"O":80,"C":53,"E":64,"A":78,"N":78}', 52, '9ee1efa8-5b69-4ce3-8fcf-e96931a5ab8c', '{}', '2026-02-06T22:55:25.000Z');

-- Teste Usuario 56 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('87774cdf-0d7a-45dd-a650-f93626cb9021', '44bd6193-37d5-44c0-8aa1-eede677880e5', '{"D":57,"I":67,"S":79,"C":61}', '{"D":50,"I":82,"S":63,"C":19}', '{"O":76,"C":65,"E":66,"A":88,"N":78}', 53, 'd7f88749-65b8-45d7-8f71-6bc42887de25', '{}', '2026-02-06T22:55:26.000Z');

-- Teste Usuario 78 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d30dd4ec-d620-4315-8502-dece0e74ccb0', 'd8f85eda-8bc1-4ed1-a56f-fa0133d2129c', '{"D":54,"I":67,"S":76,"C":71}', '{"D":36,"I":42,"S":57,"C":42}', '{"O":70,"C":71,"E":63,"A":81,"N":92}', 62, '8f03fb2a-1783-4316-8eb4-8b34f987b778', '{}', '2026-02-06T22:55:26.000Z');

-- Teste Usuario 90 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('1751c8b7-6d04-4c87-b91b-3af216607c2b', 'de8f678a-83fb-4320-b06c-1e705bf4f7be', '{"D":72,"I":43,"S":68,"C":88}', '{"D":62,"I":24,"S":40,"C":74}', '{"O":72,"C":92,"E":52,"A":51,"N":63}', 51, '0f99bd41-9f3c-478c-bb54-66272a779c64', '{}', '2026-02-06T22:55:27.000Z');

-- Teste Usuario 70 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('01a1e2df-1d6c-4a2a-9223-f654cea66692', '0aad460e-7291-49e5-b77b-0360ed7cbcab', '{"D":50,"I":54,"S":81,"C":80}', '{"D":48,"I":24,"S":47,"C":68}', '{"O":69,"C":74,"E":51,"A":69,"N":88}', 64, '15fa4ec0-399b-4218-bdf1-1d42d1943adc', '{}', '2026-02-06T22:55:27.000Z');

-- Teste Usuario 67 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('32a5131c-244f-4368-aa60-4d5b45325e9f', 'eed3b1cf-3af1-4e72-8440-6c2569179391', '{"D":70,"I":58,"S":74,"C":76}', '{"D":43,"I":6,"S":60,"C":87}', '{"O":65,"C":82,"E":64,"A":61,"N":71}', 48, 'e32f35b6-74be-4065-bb15-a98d58cbb69c', '{}', '2026-02-06T22:55:28.000Z');

-- Teste Usuario 88 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('3bbc0cdb-8d7f-489a-a6a2-ea590b67fd7f', 'ef370f05-c61d-4a43-aa5d-69d386684fa5', '{"D":65,"I":60,"S":71,"C":76}', '{"D":19,"I":39,"S":67,"C":65}', '{"O":65,"C":79,"E":63,"A":71,"N":80}', 53, '4a6409b3-3364-431d-bf32-890a821f3da8', '{}', '2026-02-06T22:55:28.000Z');

-- Teste Usuario 87 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('e2f9cfb4-0f7b-4e2c-9611-5e1838b2bc8d', 'b97e6cc0-b7c0-45f3-aaf7-afb38c00607c', '{"D":66,"I":53,"S":77,"C":78}', '{"D":57,"I":42,"S":47,"C":61}', '{"O":69,"C":85,"E":55,"A":64,"N":73}', 52, '0e3e6272-6691-45cf-ab50-f95fc524e227', '{}', '2026-02-06T22:55:29.000Z');

-- Teste Usuario 92 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('feef8a06-0a3e-4a73-9740-9d34353696c7', '476b3c26-2ebd-4e80-b344-510696a0fcd1', '{"D":73,"I":67,"S":65,"C":66}', '{"D":55,"I":18,"S":30,"C":71}', '{"O":78,"C":68,"E":73,"A":64,"N":64}', 41, 'e76f1fef-b1f6-4313-811d-42198e0b0847', '{}', '2026-02-06T22:55:29.000Z');

-- Teste Usuario 91 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('6ec803d5-8ef2-4848-8ff2-d2fc157bea0e', '74fb96fb-c3ca-42f7-84be-06467a16e89d', '{"D":50,"I":49,"S":82,"C":82}', '{"D":33,"I":52,"S":63,"C":55}', '{"O":67,"C":74,"E":48,"A":68,"N":85}', 64, '958f201d-036b-4262-bbb2-fd70c9a684af', '{}', '2026-02-06T22:55:29.000Z');

-- Teste Usuario 74 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('1db0017f-1ef1-4321-bdd5-e6dcc41df2cc', 'a8c0cd9d-5412-40c8-902f-aab2b076b2c8', '{"D":52,"I":62,"S":82,"C":76}', '{"D":33,"I":79,"S":70,"C":23}', '{"O":65,"C":79,"E":60,"A":85,"N":81}', 58, '8351d322-b020-4cea-b333-9d9add527b48', '{}', '2026-02-06T22:55:30.000Z');

-- Teste Usuario 81 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('c0c25f9d-0a6b-47b7-8ac3-69534ab513da', '9b9ff11d-68e3-4678-86a0-3642583973d0', '{"D":68,"I":60,"S":74,"C":71}', '{"D":48,"I":48,"S":53,"C":45}', '{"O":72,"C":77,"E":63,"A":71,"N":80}', 52, '79b93e40-77ca-4f9f-a7dc-78036124b72e', '{}', '2026-02-06T22:55:30.000Z');

-- Teste Usuario 75 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('81302362-e985-405f-8536-720ace40befc', '19ce5538-8ff4-48f9-a45d-a84a8f03dcdd', '{"D":67,"I":74,"S":73,"C":64}', '{"D":38,"I":73,"S":73,"C":35}', '{"O":65,"C":77,"E":75,"A":85,"N":69}', 45, '18e457db-0855-4cd6-8871-cf5f7590652a', '{}', '2026-02-06T22:55:31.000Z');

-- Teste Usuario 80 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('f9a76332-36ee-492c-b4b7-eff46f8b08ae', '926936ae-9c22-410e-a59b-b8f3c45baa1a', '{"D":74,"I":58,"S":62,"C":71}', '{"D":81,"I":33,"S":10,"C":65}', '{"O":80,"C":71,"E":63,"A":51,"N":73}', 49, '59dba7e6-968f-48b9-9859-155f024b25a2', '{}', '2026-02-06T22:55:31.000Z');

-- Teste Usuario 72 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('9a12f4fe-7b63-4a0e-a7e2-485e5f852451', 'a8e398af-1d04-4a80-9862-3a5220852c6b', '{"D":56,"I":74,"S":77,"C":57}', '{"D":26,"I":70,"S":70,"C":19}', '{"O":80,"C":60,"E":70,"A":90,"N":80}', 56, '8acbf63a-8cc1-4ac5-9141-7f0b527274f3', '{}', '2026-02-06T22:55:32.000Z');

-- Teste Usuario 93 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('259debb8-7951-4863-be6f-7123681ea992', '4a0a414e-25a9-47a1-9f56-1c69a56a80dd', '{"D":70,"I":69,"S":68,"C":55}', '{"D":48,"I":61,"S":40,"C":35}', '{"O":81,"C":56,"E":71,"A":78,"N":71}', 47, '505c0113-cc58-4d5c-a517-cb21fe8b4b64', '{}', '2026-02-06T22:55:32.000Z');

-- Teste Usuario 61 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('49c0ceee-ca53-443b-91d6-3b540d824e3c', 'c584cf4b-1848-4517-8928-e1732e16d35a', '{"D":72,"I":77,"S":69,"C":55}', '{"D":67,"I":64,"S":43,"C":32}', '{"O":78,"C":65,"E":78,"A":80,"N":63}', 44, 'd256fce8-646a-465d-940b-2d1fc07436a9', '{}', '2026-02-06T22:55:33.000Z');

-- Teste Usuario 71 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('c686d68b-1355-4d2b-a6e2-11fa1be3c412', 'fe8af22a-7fc2-4df2-b675-e90938cdf79b', '{"D":65,"I":78,"S":69,"C":66}', '{"D":69,"I":45,"S":27,"C":71}', '{"O":76,"C":74,"E":79,"A":80,"N":75}', 49, '65c69300-bdf2-4fa8-b949-5b2a55954b9a', '{}', '2026-02-06T22:55:33.000Z');

-- Teste Usuario 100 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('d4891e47-9992-4b3d-b4be-a7194cc05cfa', '141817ec-bebe-401d-a1a5-d66a2a896599', '{"D":60,"I":68,"S":79,"C":68}', '{"D":50,"I":61,"S":60,"C":39}', '{"O":67,"C":74,"E":68,"A":85,"N":71}', 48, 'b868bdd1-b7c6-43f9-880e-b7570adac623', '{}', '2026-02-06T22:55:33.000Z');

-- Teste Usuario 82 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('63ea70e0-facb-4a7d-a877-401cc0cc8b5d', 'b4e3508d-20f1-4f0a-8b2c-e08a69d4811e', '{"D":68,"I":73,"S":70,"C":61}', '{"D":29,"I":48,"S":60,"C":48}', '{"O":78,"C":66,"E":74,"A":88,"N":75}', 49, 'd2656e53-7415-472c-b0e0-89beab434ac6', '{}', '2026-02-06T22:55:34.000Z');

-- Teste Usuario 31 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('6628419b-d298-458e-b42d-def702422bf6', '9bff0e4a-a512-4328-84f2-f77352e31a35', '{"D":61,"I":60,"S":76,"C":74}', '{"D":43,"I":55,"S":63,"C":35}', '{"O":69,"C":74,"E":58,"A":78,"N":85}', 57, '134bc732-cb17-44dc-a9c8-8d7a52c5d505', '{}', '2026-02-06T22:55:34.000Z');

-- Teste Usuario 94 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('85165f5c-4298-451a-81bc-2cedb6847b9d', '96127c5c-3ed8-4ca3-901e-fa6859452cbd', '{"D":57,"I":60,"S":82,"C":68}', '{"D":43,"I":70,"S":43,"C":42}', '{"O":56,"C":71,"E":60,"A":78,"N":83}', 58, 'd3d11a50-ac74-4ad1-aa08-f52c57c022f2', '{}', '2026-02-06T22:55:35.000Z');

-- Teste Usuario 95 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('b6bbcce1-94f3-4096-9843-82f520481b39', '30e03142-99fa-49a0-8b86-7913b022a92b', '{"D":59,"I":58,"S":77,"C":75}', '{"D":19,"I":36,"S":77,"C":68}', '{"O":72,"C":74,"E":58,"A":76,"N":71}', 50, '846d8d76-6dbc-4be7-be32-8f9036520651', '{}', '2026-02-06T22:55:35.000Z');

-- Teste Usuario 42 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('c2800957-9469-455d-909c-afd4e3d5c197', '7f1540e0-13e0-4044-917f-6bac5f79574d', '{"D":65,"I":60,"S":77,"C":72}', '{"D":76,"I":39,"S":30,"C":55}', '{"O":56,"C":79,"E":66,"A":69,"N":73}', 49, '9e43411e-743e-479c-a733-16079ae73863', '{}', '2026-02-06T22:55:36.000Z');

-- Teste Usuario 96 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('cc161a1a-3b88-4209-80ae-60b09647cb43', 'c2ba9e72-25af-490b-be86-2ac09782b93d', '{"D":76,"I":56,"S":65,"C":74}', '{"D":64,"I":30,"S":30,"C":65}', '{"O":70,"C":81,"E":64,"A":64,"N":69}', 48, 'c294005c-74a2-4abd-85bd-54166aec4c5b', '{}', '2026-02-06T22:55:36.000Z');

-- Teste Usuario 97 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('9419601b-27ed-49f4-a3af-45eb00bb3335', '1841899d-201f-408a-b530-5bc0afa74c6a', '{"D":70,"I":69,"S":73,"C":66}', '{"D":57,"I":76,"S":53,"C":29}', '{"O":78,"C":74,"E":71,"A":76,"N":71}', 45, '6a386a22-e249-4e90-b639-c0382a63f29e', '{}', '2026-02-06T22:55:36.000Z');

-- Teste Usuario 63 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('5965c9c0-d178-44ea-a372-fd94a2899cda', 'c38af540-cd58-45a4-a58e-80036873d134', '{"D":66,"I":78,"S":73,"C":51}', '{"D":50,"I":58,"S":53,"C":32}', '{"O":74,"C":55,"E":78,"A":86,"N":76}', 54, 'e0398879-af04-4695-8bf3-1f2c55cf084b', '{}', '2026-02-06T22:55:37.000Z');

-- Teste Usuario 85 (2026-02-06)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('83c2c1bf-ac9f-4756-8fc8-74e4f7595a49', 'aa119293-760e-46d4-aeff-490a66989913', '{"D":54,"I":64,"S":81,"C":67}', '{"D":31,"I":45,"S":60,"C":45}', '{"O":76,"C":69,"E":60,"A":86,"N":75}', 53, 'f01822c7-5e01-40bf-aa7b-09ca06a7140d', '{}', '2026-02-06T22:55:37.000Z');

-- ============================================
-- Done! Companies: 29, Departments: 26, Users: 493, Results: 306
-- ============================================