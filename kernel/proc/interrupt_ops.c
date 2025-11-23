void
push_off(void)
{
  int old = intr_get();

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(get_current_cpu()->noff == 0)
    get_current_cpu()->intena = old;
  get_current_cpu()->noff += 1;
}

void
pop_off(void)
{
  struct cpu *c = get_current_cpu();
  if(intr_get())
    panic("pop_off - interruptible");
  if(c->noff < 1)
    panic("pop_off");
  c->noff -= 1;
  if(c->noff == 0 && c->intena)
    intr_on();
}