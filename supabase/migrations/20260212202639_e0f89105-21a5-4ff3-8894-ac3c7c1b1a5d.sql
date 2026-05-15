
-- Create hr_conversations table
CREATE TABLE public.hr_conversations (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  title TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

ALTER TABLE public.hr_conversations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own conversations"
  ON public.hr_conversations FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own conversations"
  ON public.hr_conversations FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own conversations"
  ON public.hr_conversations FOR DELETE
  USING (auth.uid() = user_id);

-- Create hr_messages table
CREATE TABLE public.hr_messages (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  conversation_id UUID NOT NULL REFERENCES public.hr_conversations(id) ON DELETE CASCADE,
  role TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

ALTER TABLE public.hr_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own messages"
  ON public.hr_messages FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.hr_conversations
    WHERE id = hr_messages.conversation_id AND user_id = auth.uid()
  ));

CREATE POLICY "Users can insert own messages"
  ON public.hr_messages FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM public.hr_conversations
    WHERE id = hr_messages.conversation_id AND user_id = auth.uid()
  ));

CREATE POLICY "Users can delete own messages"
  ON public.hr_messages FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM public.hr_conversations
    WHERE id = hr_messages.conversation_id AND user_id = auth.uid()
  ));
