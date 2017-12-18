input_data = ["THE LIST OF INSTRUCTIONS"]

class Instructions:
  def __init__(self):
    self.instruction_set = {"set":self.set,
                        "add":self.add,
                        "mul":self.mul,
                        "mod":self.mod,
                        "snd":self.snd,
                        "rcv":self.rcv,
                        "jgz":self.jgz}

  def param_to_int(self, obj, param):
    try:
      param = int(param)
    except ValueError:
      param = obj.registers[param]

    return param

  def set(self, obj, params):
    register = params[0]
    modifier = self.param_to_int(obj, params[1])

    obj.registers[register] = modifier
    return

  def add(self, obj, params):
    register = params[0]
    modifier = self.param_to_int(obj, params[1])

    obj.registers[register] += modifier
    return

  def mul(self, obj, params):
    register = params[0]
    modifier = self.param_to_int(obj, params[1])

    obj.registers[register] *= modifier
    return

  def mod(self, obj, params):
    register = params[0]
    modifier = self.param_to_int(obj, params[1])

    obj.registers[register] = obj.registers[register] % modifier
    return

  def snd(self, obj, params):
    obj.counter += 1
    value = self.param_to_int(obj, params[0])

    obj.output.append(value)
    return
  def rcv(self, obj, params):
    value = obj.get_next_value_from_queue()
    register = params[0]

    if value:
      obj.registers[register] = value
      obj.locked = False
    else:
      obj.locked = True
    return
  def jgz(self, obj, params):
    condition = self.param_to_int(obj, params[0])
    jump_value = self.param_to_int(obj, params[1])

    if condition > 0:
      obj.position += (jump_value - 1)
    return


class Program:
    def __init__(self, p_id, registers, input_queue, output_queue):
        self.registers = registers.copy()
        self.counter = 0
        self.position = 0
        self.locked = False
        self.registers["p"] = p_id
        self.queue = input_queue
        self.output = output_queue

    def get_next_value_from_queue(self):
      if self.queue:
        return self.queue.pop(0)
      else:
        return False


    def execute_next(self, list_of_instructions):
      if(self.position > len(list_of_instructions)):
        self.locked = True
        return

      instructions = Instructions()
      instruction = list_of_instructions[self.position]["command"]    
      params = list_of_instructions[self.position]["params"]

      if instruction in instructions.instruction_set:
        instructions.instruction_set[instruction](self, params)
      else:
        return

      if self.locked:
        return
      else:
        self.position += 1

      return

def prepare_instructions(input_data):
  list_of_instructions = {}

  for index, instruction in enumerate(input_data):
    instruction = instruction.split()
    command = instruction.pop(0)

    list_of_instructions[index] = {"command":command, 
                            "params":instruction}

  return list_of_instructions

def get_registers(list_of_instructions):
  registers = {}

  for instruction in list_of_instructions.items():
    for param in instruction[1]["params"]:
      try:
        int(param)
      except ValueError:
        if param not in registers:
          registers[param] = 0

  return registers

list_of_instructions = prepare_instructions(input_data)
registers = get_registers(list_of_instructions)

queue_a = []
queue_b = []

prog0 = Program(0, registers, queue_a, queue_b)
prog1 = Program(1, registers, queue_b, queue_a)

iterations = 0
while True:
  iterations += 1

  prog0.execute_next(list_of_instructions)
  prog1.execute_next(list_of_instructions)

  if(prog0.locked and prog1.locked):
    print("LOCKED AT ITERATION: " + str(iterations))
    break

print("Sent from prog1: " + str(prog1.counter))