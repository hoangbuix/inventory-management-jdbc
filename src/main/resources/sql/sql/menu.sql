use
    inventory_management;

insert into menu(parent_id, url, name, order_index)
values (0, '/product', 'Sáº£n pháº©m', 1),
       (0, '/stock', 'Kho', 2),
       (0, '/management', 'Quáº£n lÃ½', 3),

       (1, '/product-info/list', 'Danh sÃ¡ch sáº£n pháº©m', 2),
       (1, '/category/list', 'Danh sÃ¡ch category', 1),
       (1, '/category/edit', 'Sá»­a', -1),
       (1, '/category/view', 'Xem', -1),
       (1, '/category/add', 'ThÃªm má»›i', -1),
       (1, '/category/save', 'LÆ°u', -1),
       (1, '/category/delete', 'XoÃ¡', -1),

       (1, '/product-info/edit', 'Sá»­a', -1),
       (1, '/product-info/view', 'Xem', -1),
       (1, '/product-info/add', 'ThÃªm má»›i', -1),
       (1, '/product-info/save', 'LÆ°u', -1),
       (1, '/product-info/delete', 'XoÃ¡', -1),

       (2, '/goods-recept/list', 'Danh sÃ¡ch nháº­p kho', 1),
       (2, '/goods-issue/list', 'Danh sÃ¡ch xuáº¥t kho', 2),
       (2, '/product-in-stock/list', 'Sáº£n pháº©m trong kho', 3),
       (2, '/history/list', 'Lá»‹ch sá»­ kho', 4),

       (3, '/user/list', 'Danh sÃ¡ch user', 1),
       (3, '/menu/list', 'Danh sÃ¡ch menu', 3),
       (3, '/role/list', 'Danh sÃ¡ch quyá»�n', 2),
       (3, '/user/save', 'Save', -1),
       (3, '/user/edit', 'Edit', -1),
       (3, '/user/view', 'View', -1),
       (3, '/user/add', 'Add', -1),
       (3, '/role/save', 'Save', -1),
       (3, '/role/edit', 'Edit', -1),
       (3, '/role/view', 'View', -1),
       (3, '/role/add', 'Add', -1)