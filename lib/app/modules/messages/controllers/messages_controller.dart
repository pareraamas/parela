import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parela/app/data/models/message_model.dart';

class MessagesController extends GetxController {
  final conversations = <ConversationModel>[].obs;
  final messages = <MessageModel>[].obs;
  late ConversationModel activeConversation;
  final messageInput = TextEditingController();
  final isTyping = false.obs;

  static final _mockConversations = [
    ConversationModel(
      id: 'c001',
      sellerName: 'Toko Cantik Beauty',
      sellerInitial: 'T',
      avatarColor: 0xFFD4548A,
      lastMessage: 'Barang sudah dikirim ya kak 📦',
      time: '10:23',
      isRead: false,
      unreadCount: 2,
      isOnline: true,
    ),
    ConversationModel(
      id: 'c002',
      sellerName: 'Beauty Store Official',
      sellerInitial: 'B',
      avatarColor: 0xFF6C63FF,
      lastMessage: 'Terima kasih sudah berbelanja!',
      time: 'Kemarin',
      isRead: true,
      unreadCount: 0,
      isOnline: false,
    ),
    ConversationModel(
      id: 'c003',
      sellerName: 'Glow Skincare',
      sellerInitial: 'G',
      avatarColor: 0xFF4ECDC4,
      lastMessage: 'Untuk kulit sensitif bisa dipakai kak 😊',
      time: 'Kemarin',
      isRead: false,
      unreadCount: 1,
      isOnline: true,
    ),
    ConversationModel(
      id: 'c004',
      sellerName: 'Makeup By Nadia',
      sellerInitial: 'M',
      avatarColor: 0xFFFF9800,
      lastMessage: 'Stok warna rose habis kak, mau warna lain?',
      time: 'Senin',
      isRead: true,
      unreadCount: 0,
      isOnline: false,
    ),
    ConversationModel(
      id: 'c005',
      sellerName: 'Wardah Official Store',
      sellerInitial: 'W',
      avatarColor: 0xFF4CAF50,
      lastMessage: 'Promo buy 2 get 1 berlaku sampai akhir bulan!',
      time: '12 Jun',
      isRead: true,
      unreadCount: 0,
      isOnline: true,
    ),
    ConversationModel(
      id: 'c006',
      sellerName: 'NARS Indonesia',
      sellerInitial: 'N',
      avatarColor: 0xFF2196F3,
      lastMessage: 'Pesanan anda sedang diproses',
      time: '10 Jun',
      isRead: true,
      unreadCount: 0,
      isOnline: false,
    ),
  ];

  static final _mockMessages = {
    'c001': [
      MessageModel(id: 'm1', text: 'Halo kak, ada yang bisa dibantu? 😊', time: '10:00', isMe: false),
      MessageModel(id: 'm2', text: 'Halo, saya mau tanya stok lipstik shade 05 masih ada?', time: '10:02', isMe: true, isRead: true),
      MessageModel(id: 'm3', text: 'Masih ada kak! Ada 3 pcs lagi 😊', time: '10:03', isMe: false),
      MessageModel(id: 'm4', text: 'Oke saya order ya', time: '10:04', isMe: true, isRead: true),
      MessageModel(id: 'm5', text: 'Siap kak! Pesanan sudah diterima ya, kami proses segera', time: '10:05', isMe: false),
      MessageModel(id: 'm6', text: 'Barang sudah dikirim ya kak 📦', time: '10:23', isMe: false),
    ],
    'c002': [
      MessageModel(id: 'm1', text: 'Pesanan anda dengan nomor ORD-20240525 sudah kami terima', time: '09:00', isMe: false),
      MessageModel(id: 'm2', text: 'Oke terima kasih', time: '09:05', isMe: true, isRead: true),
      MessageModel(id: 'm3', text: 'Terima kasih sudah berbelanja!', time: '09:06', isMe: false),
    ],
    'c003': [
      MessageModel(id: 'm1', text: 'Kak, serum ini cocok untuk kulit sensitif gak ya?', time: '14:00', isMe: true, isRead: true),
      MessageModel(id: 'm2', text: 'Untuk kulit sensitif bisa dipakai kak 😊', time: '14:15', isMe: false),
    ],
    'c004': [
      MessageModel(id: 'm1', text: 'Masih ada shade rose gak?', time: 'Senin', isMe: true, isRead: true),
      MessageModel(id: 'm2', text: 'Stok warna rose habis kak, mau warna lain?', time: 'Senin', isMe: false),
    ],
    'c005': [
      MessageModel(id: 'm1', text: 'Ada promo apa bulan ini kak?', time: '12 Jun', isMe: true, isRead: true),
      MessageModel(id: 'm2', text: 'Promo buy 2 get 1 berlaku sampai akhir bulan!', time: '12 Jun', isMe: false),
    ],
    'c006': [
      MessageModel(id: 'm1', text: 'Kapan pesanan saya diproses?', time: '10 Jun', isMe: true, isRead: true),
      MessageModel(id: 'm2', text: 'Pesanan anda sedang diproses', time: '10 Jun', isMe: false),
    ],
  };

  @override
  void onInit() {
    super.onInit();
    conversations.assignAll(_mockConversations);
  }

  int get totalUnread => conversations.fold(0, (sum, c) => sum + c.unreadCount);

  void openChat(ConversationModel conversation) {
    activeConversation = conversation;
    final msgs = _mockMessages[conversation.id] ?? [];
    messages.assignAll(msgs);
    conversation.isRead = true;
    conversations.refresh();
  }

  void sendMessage() {
    final text = messageInput.text.trim();
    if (text.isEmpty) return;
    messages.add(MessageModel(
      id: 'm${messages.length + 1}',
      text: text,
      time: 'Sekarang',
      isMe: true,
      isRead: false,
    ));
    messageInput.clear();
    isTyping.value = false;
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(MessageModel(
        id: 'm${messages.length + 1}',
        text: 'Terima kasih pesannya, kami akan segera membalas 😊',
        time: 'Sekarang',
        isMe: false,
      ));
    });
  }

  @override
  void onClose() {
    messageInput.dispose();
    super.onClose();
  }
}
