function printfunction()
  local c = {Funcs()}
  for k,v in pairs(c) do
    print(k,v)
  end
end

print("-------------------------------------------------------------")
print("START")
print("-------------------------------------------------------------")
print(Vars())
print("-------------------------------------------------------------")

print(Funcs())
print("-------------------------------------------------------------")

print(showsource(1,5,"test.cpp"))
print("-------------------------------------------------------------")

a={showsource(1,5,"test.cpp")}
for k,v in pairs(a) do
  print(k,v)
end
print("-------------------------------------------------------------")

b={Vars()}
for k,v in pairs(b) do
  print(k,v)
end
print("-------------------------------------------------------------")

print("today is:")
print("-------------------------------------------------------------")

print(os.date())
print("-------------------------------------------------------------")

text=hijackmain()
print(text)
print("-------------------------------------------------------------")

printfunction()
print("-------------------------------------------------------------")
print("THE END")
print("-------------------------------------------------------------")
