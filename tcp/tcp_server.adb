with Ada.Text_IO;
with Ada.IO_Exceptions;
with Ada.Streams; use Ada.Streams;

with GNAT.Sockets; use GNAT.Sockets;

procedure TCP_Server is
  Receiver   : Socket_Type;
  Connection : Socket_Type;
  Client     : Sock_Addr_Type;
  Channel    : Stream_Access;

  Data      : Stream_Element_Array(1 .. 512);
  Last : Stream_Element_Offset;
  Server_Data  : constant String := "Hello message from server.";
  Send_Data : Stream_Element_Array(1 .. Server_Data'Length);
  Stream_Offset : Stream_Element_Count;

begin
  Create_Socket(Receiver, Family_Inet, Socket_Stream);
  Set_Socket_Option(Receiver, Socket_Level, (Reuse_Address, True));
  Bind_Socket(Receiver, (Family_Inet, Inet_Addr("127.0.0.1"), 50000));
  Listen_Socket(Receiver);

  Ada.Text_IO.Put_Line(" .. TCP Server Started .. ");

  for I in 1..Server_Data'Length loop
    Stream_Offset := Stream_Element_Offset(I);
    Send_Data(Stream_Offset) := Stream_Element'Val(Character'Pos(Server_Data(I)));
  end loop;

  loop
    Accept_Socket(Receiver, Connection, Client);
    Ada.Text_IO.Put_Line("Client connected from:" & Image(Client));
    Channel := Stream(Connection);

    begin
      loop
        -- Receiving from client.
        Receive_Socket(Connection, Data, Last);
        for I in 1 .. Last loop
           Ada.Text_IO.Put(Character'Val(Data(I)));
        end loop;
       Ada.Text_IO.New_Line;

       -- Sending to client.
       Send_Socket(Connection, Send_Data, Last);
      end loop;
    exception
      when Ada.IO_Exceptions.End_Error => null;
      when Socket_Error => Ada.Text_IO.Put_Line("Socket Error Exception.");
    end;

    Close_Socket(Connection);
    Ada.Text_IO.Put_Line("Socket closed.");
  end loop;
end TCP_Server;
