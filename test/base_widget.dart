import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:ecommerce_pragma/commons/state/car_items_provider.dart';
import 'package:ecommerce_pragma/commons/state/nav_bar_index_provider.dart';
import 'package:ecommerce_pragma/core/localization/app_localizations.dart';
import 'package:ecommerce_pragma/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pragma_design_system/pragma_design_system.dart';
import 'package:reading_api_data_dart/core/error/failure.dart';
import 'package:reading_api_data_dart/domain/entities/product_entities/product.dart';
import 'package:reading_api_data_dart/domain/repositories/products_repository.dart';
import 'package:reading_api_data_dart/domain/usecases/product/product.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/product_state.dart';
import 'package:reading_api_data_dart/presentation/state/notifier/products_notifier.dart';

/// Utilidad para montar un widget dentro de un [ProviderScope] durante los tests.
class BaseWidget {
  /// Crea una instancia con el [child] y la lista de [overrides].
  BaseWidget({
    required this.child,
    required this.overrides,
    this.shouldPumpAndSettle = true,
  });

  /// Widget que se desea probar.
  final Widget child;

  /// Overrides de Riverpod.
  final List<Override> overrides;

  /// Indica si se debe llamar a `pumpAndSettle`.
  final bool shouldPumpAndSettle;

  /// Monta el widget en el [WidgetTester] configurado.
  Future<void> mount(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(home: child),
      ),
    );
    if (shouldPumpAndSettle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }
}

/// Mock básico de [ProductItem].
class MockProductItem extends ProductItem {
  /// Crea un producto simulado.
  MockProductItem()
    : super(id: 1, title: 'Producto', price: '10.0', imageUrl: '', rating: 0.0);
}

/// Factoría para generar instancias de [ProductItem] en tests.
class ProductItemMock {
  /// Crea un [ProductItem] con valores por defecto.
  static ProductItem create({
    int id = 1,
    String title = 'Producto Test',
    String price = '10.0',
    String description = 'Descripción de prueba',
    String category = 'Categoría Test',
    String image = '',
    int amount = 1,
  }) {
    return ProductItem(
      id: id,
      title: title,
      price: price,
      imageUrl: image,
      rating: 100,
      amount: amount,
    );
  }

  /// Crea una lista de productos con ids consecutivos.
  static List<ProductItem> createList({int count = 3, int startId = 1}) {
    return List.generate(
      count,
      (index) => create(
        id: startId + index,
        title: 'Producto $index',
        price: ((index + 1) * 10.0).toString(),
      ),
    );
  }

  /// Crea un producto con la cantidad especificada.
  static ProductItem createWithAmount({
    int id = 1,
    String title = 'Producto Test',
    String price = '10.0',
    int amount = 2,
  }) {
    return create(id: id, title: title, price: price, amount: amount);
  }
}

/// Mock del presentador de autenticación.
class MockAuthPresenter extends Mock implements AuthPresenter {}

/// Fake genérico de [BuildContext].
class FakeBuildContext extends Fake implements BuildContext {}

/// Implementación falsa de [AppLocalizations] para pruebas.
class FakeAppLocalizations extends AppLocalizations {
  /// Crea localizaciones con idioma español.
  FakeAppLocalizations() : super(const Locale('es'));

  @override
  Map<String, dynamic> get localizedStrings => {
    'app_title': 'Aplicación Básica',
    'auth_page': {
      'logoPath': 'assets/img/logo.png',
      'loginTitle': 'Ecommerce Pragma',
      'registerTitle': 'Únete a nuestra comunidad',
      'loginConfig': {
        'title': 'Bienvenido de nuevo',
        'subtitle': 'Ingresa tus credenciales',
        'emailLabel': 'Correo',
        'emailHint': 'usuario@correo.com',
        'passwordLabel': 'Clave',
        'passwordHint': 'Tu contraseña segura',
        'forgotPasswordText': 'Recuperar acceso',
        'buttonLabel': 'Iniciar sesión',
        'minPasswordLength': 8,
        'emailRequired': 'El correo no puede estar vacío',
        'emailInvalid': 'Formato de correo incorrecto',
        'passwordRequired': 'Debes ingresar tu contraseña',
        'passwordTooShort': 'La contraseña es demasiado corta',
      },
      'socialButtons': [
        {
          'indexId': 1,
          'label': 'Continuar con Google',
          'icon': 'google',
          'onPressed': 'googleLogin',
        },
        {
          'indexId': 2,
          'label': 'Continuar con Google',
          'icon': 'apple',
          'onPressed': 'googleLogin',
        },
      ],
      'registerConfig': {
        'title': 'Crea tu cuenta',
        'subtitle': 'Regístrate para continuar',
        'nameLabel': 'Nombre y apellido',
        'nameHint': 'Ejemplo: Jhony Rentería',
        'emailLabel': 'Correo',
        'emailHint': 'usuario@correo.com',
        'passwordLabel': 'Contraseña',
        'passwordHint': 'Mínimo 8 caracteres',
        'confirmPasswordLabel': 'Repetir contraseña',
        'confirmPasswordHint': 'Confirma tu contraseña',
        'buttonLabel': 'Registrarme ahora',
        'minPasswordLength': 8,
        'nameRequired': 'El nombre es obligatorio',
        'emailRequired': 'El correo es obligatorio',
        'emailInvalid': 'Formato de correo inválido',
      },
    },
    'dashboard': {
      'menuWidget': {'item1': 'Inicio', 'item2': 'Carro', 'item3': 'Perfil'},
      'productsWidget': {
        'title': 'Inicio',
        'emptyImagePath': 'assets/img/empty.png',
        'banner': {
          'imageUrl': 'https://picsum.photos/800/300',
          'title': 'Ofertas de la Semana',
          'subtitle': 'Hasta 10% de descuento en electrónicos',
        },
        'sections': [
          {'title': 'Ofertas relámpago', 'products': [], 'grid': true},
          {'title': 'Recomendados para ti', 'grid': true, 'products': []},
        ],
      },
      'cartWidget': {
        'title': 'Carrito de Compras',
        'products': [],
        'summary': {'subtotal': 0, 'shipping': 0, 'taxes': 10, 'total': 0},
        'checkoutLabel': 'Pagar ahora',
        'continueLabel': 'Seguir explorando',
      },
      'profileWidget': {
        'user': {
          'name': '',
          'email': '',
          'avatarUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmsZOshpHHXGSv16ekVAjfw_VfBn0eJrMazg&s',
        },
        'orders': [],
        'settings': [
          <String, dynamic>{
            'icon': 'lock_outline',
            'title': 'Cambiar contraseña',
            'onTap': '',
          },
          <String, dynamic>{
            'icon': 'notifications_outlined',
            'title': 'Notificaciones',
            'onTap': '',
          },
          <String, dynamic>{
            'icon': 'help_outline',
            'title': 'Ayuda y soporte',
            'onTap': '',
          },
        ],
        'onLogout': '',
      },
    },
    'paymentWidget': {
      'title': 'Confirmar compra',
      'buttonLabel': 'Finalizar pedido',
      'onCheckoutComplete': '',
      'orderSummary': {
        'orderId': 'ALDF782302570',
        'orderDate': '',
        'orderStatus': 'Confirmacion',
        'products': [],
        'subtotal': '0',
        'shipping': '0',
        'discount': '-\$0',
        'total': '0',
      },
      'shippingConfig': {
        'title': 'Dirección de envío',
        'fields': {
          'name': {
            'label': 'Nombre completo',
            'hint': 'Ej. Juan Pérez',
            'required': true,
          },
          'address': {'label': 'Dirección', 'hint': 'Ej. Calle 56 #84 - 33'},
          'city': {'label': 'Ciudad', 'hint': 'Ej. Cali'},
          'zip': {'label': 'Código postal', 'hint': 'Ej. 760001'},
          'phone': {'label': 'Teléfono', 'hint': '+57 314 723 1734'},
        },
        'shippingMethods': [
          {'label': 'Estándar', 'subtitle': '3-5 días hábiles'},
          {'label': 'Exprés', 'subtitle': '1-2 días hábiles'},
          {'label': 'Internacional', 'subtitle': '5-10 días hábiles'},
        ],
        'submitLabel': 'Confirmar direccion',
      },
      'paymentConfig': {
        'title': 'Métodos de pago',
        'methods': [
          {
            'label': 'Tarjeta de crédito',
            'iconPath': 'assets/icons/png/visa.png',
          },
          {
            'label': 'Nequi / Daviplata',
            'iconPath': 'assets/icons/png/visa.png',
          },
          {
            'label': 'Pago contra entrega',
            'iconPath': 'assets/icons/png/visa.png',
          },
        ],
      },
      'alertMessage': {
        'confirmError': 'Por favor confirma tu dirección de envío...',
        'selectPayment': 'Selecciona un método de pago...',
        'orderOk': '¡Pedido realizado con éxito!',
        'addressOk': 'Ok, dirección confirmada',
      },
    },
  };
}

/// Mock del notifier de productos del dashboard (no extendido).
class MockProductsNotifier extends Mock implements ProductsNotifier {}

/// Fake para manejar el estado del índice de la barra inferior.
class FakeNavBarIndexNotifier extends NavBarIndexNotifier {
  /// Crea el fake con un índice inicial.
  FakeNavBarIndexNotifier({int initialIndex = 0}) : super() {
    state = initialIndex;
  }

  /// Último valor establecido a través de [setValue].
  int? lastSetValue;

  /// Permite setear el índice inicial sin guardar interacciones.
  void setInitialIndex(int value) {
    state = value;
    lastSetValue = null;
  }

  @override
  void setValue(int newValue) {
    lastSetValue = newValue;
    super.setValue(newValue);
  }
}

/// Fake del notifier de items en el carrito.
class FakeCarItemsNotifier extends CarItemsNotifier {
  /// Crea el fake opcionalmente con items iniciales.
  FakeCarItemsNotifier({Set<ProductItem>? initialItems}) : super() {
    state =
        initialItems ??
        {
          ProductItemMock.create(title: 'Producto 1', amount: 2),
          ProductItemMock.create(id: 2, title: 'Producto 2', price: '20.0'),
        };
  }
}

/// Fake de la entidad [Product].
class FakeProduct extends Fake implements Product {}

/// Notifier de productos para controlar el estado en tests.
class FakeProductsNotifier extends ProductsNotifier {
  /// Crea el fake con repositorio simulado.
  FakeProductsNotifier()
    : super(
        getProducts: GetProductsUseCase(_FakeProductsRepository()),
        getProductById: GetProductByIdUseCase(_FakeProductsRepository()),
        createProduct: CreateProductUseCase(_FakeProductsRepository()),
      );

  /// Indica si se invocó [loadAllProducts].
  bool loadAllProductsCalled = false;

  @override
  Future<List<Product>?> loadAllProducts() async {
    loadAllProductsCalled = true;
    return null;
  }

  @override
  Future<Product?> loadProductById(int id) async {
    return null;
  }

  /// Permite forzar un estado específico.
  void emitState(ProductsState newState) {
    state = newState;
  }
}

/// Repositorio falso para pruebas.
class _FakeProductsRepository implements ProductsRepository {
  @override
  Future<Either<Failure, Product>> createProduct(Map<String, dynamic> product) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Product>> getProductById(int productId) {
    throw UnimplementedError();
  }
}

/// Crea una lista de productos de dominio simulados.
List<Product> createFakeProducts({int count = 1}) {
  return List.generate(
    count,
    (index) => Product(
      id: index + 1,
      title: 'Producto ${index + 1}',
      price: 10.0 + index,
      description: 'Descripción ${index + 1}',
      category: 'Categoría ${index + 1}',
      image: 'https://picsum.photos/id/${index + 1}/200/300',
    ),
  );
}

/// [HttpOverrides] para interceptar peticiones de imágenes en tests.
class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _TestHttpClient();
}

class _TestHttpClient extends Fake implements HttpClient {
  bool _autoUncompress = true;

  @override
  bool get autoUncompress => _autoUncompress;

  @override
  set autoUncompress(bool value) {
    _autoUncompress = value;
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _TestHttpClientRequest();
}

class _TestHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _TestHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _TestHttpClientResponse();
}

class _TestHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _transparentImageData.length;

  @override
  bool get isRedirect => false;

  @override
  bool get persistentConnection => false;

  @override
  String get reasonPhrase => 'OK';

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  HttpHeaders get headers => _TestHttpHeaders();

  @override
  X509Certificate? get certificate => null;

  @override
  List<Cookie> get cookies => const [];

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final stream = Stream<List<int>>.fromIterable(<List<int>>[
      _transparentImageData,
    ]);
    return stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class _TestHttpHeaders extends Fake implements HttpHeaders {}

final Uint8List _transparentImageData = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

class TestCarItemsNotifier extends CarItemsNotifier {
  TestCarItemsNotifier() {
    state = {ProductItemMock.create()};
  }

  bool resetCalled = false;

  @override
  void reset() {
    resetCalled = true;
    super.reset();
  }
}
