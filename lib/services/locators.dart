import 'package:gallery_with_rest_api/data_access/gallery_entry_data_handler.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => GalleryItemDataHandler());
}