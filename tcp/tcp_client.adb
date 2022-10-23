with Ada.Text_IO;
with Ada.Streams; use Ada.Streams;

with GNAT.Sockets; use GNAT.Sockets;

procedure TCP_Client is
  Address : GNAT.Sockets.Sock_Addr_Type := (GNAT.Sockets.Family_Inet,
                                            GNAT.Sockets.Inet_Addr("127.0.0.1"),
                                            50000);
  Socket  : GNAT.Sockets.Socket_Type;
  Recv_Buffer : Stream_Element_Array(1 .. 512);

  Client_Data  : constant String := "Hello message from client.";
  Send_Data : Stream_Element_Array(1 .. Client_Data'Length);
  Stream_Offset : Stream_Element_Count;

  Last : Stream_Element_Offset;
  Connection_Status   : GNAT.Sockets.Selector_Status;

begin
  GNAT.Sockets.Create_Socket(Socket);
  Connect_Socket(Socket, Address, Timeout => 1.0, Status => Connection_Status);

  for I in 1..Client_Data'Length loop
    Stream_Offset := Stream_Element_Offset(I);
    Send_Data(Stream_Offset) := Stream_Element'Val(Character'Pos(Client_Data(I)));
  end loop;

  -- Send to server.
  Send_Socket(Socket, Send_Data, Last);
  Ada.Text_IO.Put_Line("Sent Bytes :" & Last'Img);
  Ada.Text_IO.Put_Line("Status :" & Connection_Status'Img);

  -- Receive from server.
  Receive_Socket(Socket, Recv_Buffer, Last);
  for I in 1 .. Last loop
     Ada.Text_IO.Put (Character'Val(Recv_Buffer(I)));
  end loop;

  Close_Socket(Socket);
end TCP_Client;
