import 'package:flutter/material.dart';

import '../models/booking.dart';
import 'booking_api_provider.dart';

class BookingRepository {
  final BookingProvider _bookingProvider = BookingProvider();
  Future<Booking> getBookingById(int id) => _bookingProvider.getBookingById(id);
  Future<void> deleteBooking(int bookingId) => _bookingProvider.deleteBooking(bookingId);
  Future<void> book(int workspaceId,int userId,DateTimeRange dateTimeRange, List<int> guestsIds) => _bookingProvider.book(workspaceId,userId,dateTimeRange,guestsIds);
  //Future<List<Booking>> getBookingsByUserId(int id) => _bookingProvider.getBookingByUserId(id);
  Future<List<DateTimeRange>> getBookingWindows(int id, DateTime date) => _bookingProvider.getBookingWindows(id, date);
}
