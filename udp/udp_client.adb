with Ada.Text_IO;
with Ada.Streams; use Ada.Streams;

with GNAT.Sockets; use GNAT.Sockets;

procedure UDP_Client is
  Address       : Sock_Addr_Type := (Family_Inet, Inet_Addr("127.0.0.1"),
                                     50000);
  Socket        : GNAT.Sockets.Socket_Type;
  Recv_Buffer   : Stream_Element_Array(1 .. 512);
  Msg   : constant String := "Hello message from client.";
  Send_Data     : Stream_Element_Array(1 .. Msg'Length);
  Stream_Offset : Stream_Element_Count;
  Last          : Stream_Element_Offset;

begin
  Create_Socket(Socket, Family_Inet, Socket_Datagram);
  Connect_Socket(Socket, Address);

  for I in 1..Msg'Length loop
    Stream_Offset := Stream_Element_Offset(I);
    Send_Data(Stream_Offset) := Stream_Element'Val(Character'Pos(Msg(I)));
  end loop;

  -- Send to server.
  Send_Socket(Socket, Send_Data, Last);
  Ada.Text_IO.Put_Line("Sent Bytes :" & Last'Img);

  -- Receive from server.
  Receive_Socket(Socket, Recv_Buffer, Last);
  for I in 1 .. Last loop
     Ada.Text_IO.Put (Character'Val(Recv_Buffer(I)));
  end loop;

  Close_Socket(Socket);
end UDP_Client;
