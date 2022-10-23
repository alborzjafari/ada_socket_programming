with Ada.Text_IO; use Ada.Text_IO;
with Ada.Streams; use Ada.Streams;
with Ada.IO_Exceptions;

with GNAT.Sockets; use GNAT.Sockets;

procedure UDP_Server is
  Socket : Socket_Type;
  Address : Sock_Addr_Type := (Family_Inet, Inet_Addr("127.0.0.1"), 50000);
  Client_Address : Sock_Addr_Type;
  Data : Stream_Element_Array(1 .. 512);
  Msg  : constant String := "Hello message from server.";
  Send_Data : Stream_Element_Array(1 .. Msg'Length);
  Last : Stream_Element_Offset;
  Stream_Offset : Stream_Element_Count;

begin
  Create_Socket(Socket, Family_Inet, Socket_Datagram);
  Set_Socket_Option(Socket, Socket_Level, (Reuse_Address, True));
  Bind_Socket(Socket, Address);

  Put_Line(".. UDP Server Started ..");

  -- Create a message buffer for sending to client.
  for I in 1..Msg'Length loop
    Stream_Offset := Stream_Element_Offset(I);
    Send_Data(Stream_Offset) := Stream_Element'Val(Character'Pos(Msg(I)));
  end loop;

  begin
    loop
      -- Receiving from client.
      Receive_Socket(Socket, Data, Last, Client_Address);
      for I in 1 .. Last loop
         Ada.Text_IO.Put(Character'Val(Data(I)));
      end loop;
     Ada.Text_IO.New_Line;

     -- Sending to client.
     Send_Socket(Socket, Send_Data, Last, Client_Address);
    end loop;
  exception
    when Ada.IO_Exceptions.End_Error => null;
    when Socket_Error => Ada.Text_IO.Put_Line("Socket Error Exception.");
  end;
end UDP_Server;
