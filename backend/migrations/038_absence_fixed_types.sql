-- Ausências passa a ser só o pedido prévio de saída (justificativa com atestado vai pelo
-- banco de horas). Ficam 3 tipos fixos, todos com aprovação do RH. Os tipos removidos não
-- tinham pedido; se algum tiver, o FK RESTRICT faz esta migração falhar em vez de perder dado.

UPDATE public.absence_types SET name = 'Ida ao médico' WHERE name = 'Atestado Médico';

INSERT INTO public.absence_types (company_id, name, color, requires_approval)
SELECT c.company_id, f.name, f.color, true
  FROM (SELECT DISTINCT company_id FROM public.absence_types) c
 CROSS JOIN (VALUES ('Ida ao médico', '#f59e0b'), ('Saída pessoal', '#8b5cf6'), ('Outro', '#6b7280')) AS f(name, color)
 WHERE NOT EXISTS (
       SELECT 1 FROM public.absence_types t WHERE t.company_id = c.company_id AND t.name = f.name);

UPDATE public.absence_types SET requires_approval = true;

DELETE FROM public.absence_types WHERE name NOT IN ('Ida ao médico', 'Saída pessoal', 'Outro');
