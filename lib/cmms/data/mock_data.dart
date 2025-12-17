import 'dart:convert';
import 'dart:math';

class MockWorkingInstructionService {
  static Future<Map<String, dynamic>> getWorkingInstructions() async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      "status": "success",
      "message": "Data retrieved successfully",
      "data": [
        {
          "id": "a0928b46-7517-4727-83aa-5edb3821ab69",
          "code": "DI-INJ-000001",
          "name": "Cooling Water Pipes & Connectors Inspection",
          "type": "DI",
          "schema":
              "[{\"stepIndex\":1,\"items\":[{\"id\":\"di001\",\"type\":\"label\",\"text\":\"Inspect all cooling water pipes and connectors on Injection machines for leakage, corrosion and tight connection\",\"heading\":\"h3\",\"bold\":true}]}]",
          "updated_at": "2025-12-05 08:15:22",
          "frequency": "Daily",
          "unit_type": "",
          "unit_value": "",
          "category": "INJ",
        },
        {
          "id": "1a554f34-9d24-44e2-a394-59ca352aa6a1",
          "code": "DI-MOLD-000002",
          "name": "Mold Parting Line Venting Check",
          "type": "DI",
          "schema":
              "[{\"stepIndex\":1,\"items\":[{\"id\":\"di002\",\"type\":\"label\",\"text\":\"Check mold parting line venting holes – Must be clean and not blocked by plastic residue\",\"heading\":\"h3\",\"bold\":true}]}]",
          "updated_at": "2025-12-05 07:30:11",
          "frequency": "Daily",
          "unit_type": "",
          "unit_value": "",
          "category": "MOLD",
        },
        {
          "id": "25f13955-190f-4106-8c0f-89f87cec385f",
          "code": "ML1-TUFT-000003",
          "name": "Tufting Copper Wire Tensile Strength Inspection",
          "type": "ML1",
          "schema":
              "[{\"stepIndex\":1,\"items\":[{\"id\":\"ml1-001\",\"type\":\"label\",\"text\":\"Inspect copper wire condition: cracks, necking, or deformation. Replace if tensile force < 85% of original\",\"heading\":\"h3\",\"bold\":true}]}]",
          "updated_at": "2025-12-03 14:20:05",
          "frequency": "Unit",
          "unit_type": "cycle",
          "unit_value": "5000000",
          "category": "TUFT",
        },
        {
          "id": "b7d3e8f1-2c9a-4f6b-9d1e-8a3f7c6b5e4d",
          "code": "ML2-BLISTER-000004",
          "name": "Blister Machine Filter Cleaning & Replacement",
          "type": "ML2",
          "schema":
              "[{\"stepIndex\":1,\"items\":[{\"id\":\"ml2-001\",\"type\":\"label\",\"text\":\"Clean or replace air intake filter on blister machines VP14005 & VP14008. Record pressure drop before/after\",\"heading\":\"h3\",\"bold\":true}]}]",
          "updated_at": "2025-12-02 09:45:33",
          "frequency": "Unit",
          "unit_type": "hour",
          "unit_value": "4000",
          "category": "BLISTER",
        },
        {
          "id": "c9e4a7d2-5f1b-4d8c-3e2f-9b6g8d7c6f5e",
          "code": "ML3-COMPRESSOR-000005",
          "name": "Compressor Oil Analysis & Full Replacement",
          "type": "ML3",
          "schema":
              "[{\"stepIndex\":1,\"items\":[{\"id\":\"ml3-001\",\"type\":\"label\",\"text\":\"Take oil sample for lab analysis. Full oil & oil filter replacement for Atlas Copco compressors\",\"heading\":\"h3\",\"bold\":true}]}]",
          "updated_at": "2025-11-28 10:10:10",
          "frequency": "Unit",
          "unit_type": "hour",
          "unit_value": "8000",
          "category": "TUFT",
        },
        {
          "id": "d4f7b9e3-6g2c-5e9d-4f3g-0c7h9e8d7g6f",
          "code": "DI-CHILLER-000006",
          "name": "Chiller & Cooling Tower Water Level and Fan Check",
          "type": "DI",
          "schema":
              "[{\"stepIndex\":1,\"items\":[{\"id\":\"di006\",\"type\":\"label\",\"text\":\"Check water level in cooling tower, clean strainers, verify all cooling fans are running normally\",\"heading\":\"h3\",\"bold\":true}]}]",
          "updated_at": "2025-12-05 06:55:00",
          "frequency": "Daily",
          "unit_type": "",
          "unit_value": "",
          "category": "CHILLER",
        },
        {
          "id": "e5g8c0f4-7h3d-6f0e-5g4h-1d8i0f9e8h7g",
          "code": "ML2-PACKING-000007",
          "name": "Packing Scale Calibration (4-head weigher)",
          "type": "ML2",
          "schema":
              "[{\"stepIndex\":1,\"items\":[{\"id\":\"ml2-007\",\"type\":\"label\",\"text\":\"Perform calibration using certified 100g & 500g weights. Tolerance: ±0.5g\",\"heading\":\"h3\",\"bold\":true}]}]",
          "updated_at": "2025-12-01 13:22:44",
          "frequency": "Unit",
          "unit_type": "month",
          "unit_value": "6",
          "category": "PACKING",
        },
        {
          "id": "f6h9d1g5-8i4e-7g1f-6h5i-2e9j1g0f9i8h",
          "code": "DI-ENDROUND-000008",
          "name": "End-Rounding Blade Sharpness Inspection",
          "type": "DI",
          "schema":
              "[{\"stepIndex\":1,\"items\":[{\"id\":\"di008\",\"type\":\"label\",\"text\":\"Inspect end-rounding blade wear. Replace if edge radius > 0.3mm or visible chipping\",\"heading\":\"h3\",\"bold\":true}]}]",
          "updated_at": "2025-12-05 07:10:15",
          "frequency": "Daily",
          "unit_type": "",
          "unit_value": "",
          "category": "TUFT",
        },
        {
          "id": "g7i0e2h6-9j5f-8h2g-7i6j-3f0k2h1g0j9i",
          "code": "ML1-TUFT-000009",
          "name": "Main Shaft Lubrication – Tufting Machines",
          "type": "ML1",
          "schema":
              "[{\"stepIndex\":1,\"items\":[{\"id\":\"ml1-009\",\"type\":\"label\",\"text\":\"Apply Klüber Isoflex NBU 15 grease to main shaft bearings on all tufting machines\",\"heading\":\"h3\",\"bold\":true}]}]",
          "updated_at": "2025-12-04 11:05:30",
          "frequency": "Unit",
          "unit_type": "hour",
          "unit_value": "2000",
          "category": "TUFT",
        },
        {
          "id": "h8j1f3i7-0k6g-9i3h-8j7k-4g1l3i2h1k0j",
          "code": "ML2-INJ-000010",
          "name": "Injection Hopper & Dryer Cleaning",
          "type": "ML2",
          "schema":
              "[{\"stepIndex\":1,\"items\":[{\"id\":\"ml2-010\",\"type\":\"label\",\"text\":\"Deep clean material hopper and desiccant dryer on all injection machines. Remove residual plastic and dust\",\"heading\":\"h3\",\"bold\":true}]}]",
          "updated_at": "2025-12-02 14:30:00",
          "frequency": "Weekly",
          "unit_type": "",
          "unit_value": "",
          "category": "INJ",
        },
      ],
      "total_items": 52,
      "total_pages": 6,
      "total_in_all_page": 52,
    };
  }
}

class MockEquipmentService {
  static Future<Map<String, dynamic>> getEquipments({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
    String? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock raw data
    final List<Map<String, dynamic>> allData = List.generate(50, (i) {
      return {
        "uuid": "uuid-$i",
        "machine_id": "MC-${1000 + i}",
        "family": ["Family A", "Family B", "Family C"][i % 3],
        "model": "Model ${i + 1}",
        "cavity": "${(i % 4) + 1}",
        "manufacturer": "Maker ${i % 5}",
        "manufacturing_date": "2024-01-${(i % 28) + 1}",
        "history_count": Random().nextInt(200),
        "unit": "pcs",
        "category": ["VD", "VT", "AC"][i % 3],
      };
    });

    // Apply search
    List<Map<String, dynamic>> filtered = [...allData];
    if (search != null && search.isNotEmpty) {
      filtered = filtered
          .where(
            (e) =>
                e["machine_id"].toLowerCase().contains(search.toLowerCase()) ||
                e["family"].toLowerCase().contains(search.toLowerCase()),
          )
          .toList();
    }

    // Filter category
    if (category != null && category.isNotEmpty && category != "All") {
      filtered = filtered.where((e) => e["category"] == category).toList();
    }

    // Filter status (mock)
    if (status != null && status.isNotEmpty && status != "All") {
      filtered = filtered.where((e) {
        final mockStatus = [
          "Active",
          "Inactive",
          "Maintenance",
        ][e["uuid"].hashCode % 3];
        return mockStatus == status;
      }).toList();
    }

    // Pagination
    int totalItems = filtered.length;
    int totalPages = (totalItems / limit).ceil();
    int start = (page - 1) * limit;
    int end = min(start + limit, filtered.length);

    final pageData = (start < filtered.length)
        ? filtered.sublist(start, end)
        : [];

    return {
      "status": "success",
      "message": "Mock equipment loaded",
      "data": pageData,
      "total_items": totalItems,
      "total_pages": totalPages,
      "total_in_all_page": totalItems,
    };
  }
}

const mockInspectionJson = {
  "status": "success",
  "date": "2025-12-01",
  "data": [
    {
      "equipment_id": "837db74f-178e-499b-b6e8-5c8bd0feb388",
      "machine_id": "TGN001_IN",
      "model": null,
      "cavity": null,
      "count_done": 2,
      "count_pending": 3,
      "category_name": "TGN",
      "history_count": "1599",
      "manufacturing_date": "0000-00-00",
      "unit": "h",
      "manufacturer": null,
      "status": "incomplete",
      "inspectors": "",
      "inspected_date": "2025-11-27 11:48:36",
    },
    {
      "equipment_id": "837db74f-178e-499b-b6e8-5c8bd0feb314",
      "machine_id": "TGN001_TA",
      "model": null,
      "cavity": null,
      "count_done": 1,
      "count_pending": 5,
      "category_name": "TGN",
      "history_count": "1599",
      "manufacturing_date": "0000-00-00",
      "unit": "h",
      "manufacturer": null,
      "status": "incomplete",
      "inspectors": "",
      "inspected_date": "2025-11-27 11:48:36",
    },
    {
      "equipment_id": "837db74f-178e-499b-b6e8-5c8bd0feb303",
      "machine_id": "TGN001_BS",
      "model": null,
      "cavity": null,
      "count_done": 0,
      "count_pending": 3,
      "category_name": "TGN",
      "history_count": "1599",
      "manufacturing_date": "0000-00-00",
      "unit": "h",
      "manufacturer": null,
      "status": "completed",
      "inspectors": "",
      "inspected_date": "2025-11-27 11:48:36",
    },
    {
      "equipment_id": "837db74f-178e-499b-b6e8-5c8bd0feb113",
      "machine_id": "TGN001_TA",
      "model": null,
      "cavity": null,
      "count_done": 4,
      "count_pending": 5,
      "category_name": "TGN",
      "history_count": "1599",
      "manufacturing_date": "0000-00-00",
      "unit": "h",
      "manufacturer": null,
      "status": "completed",
      "inspectors": "",
      "inspected_date": "2025-11-27 11:48:36",
    },
    {
      "equipment_id": "837db74f-178e-499b-b6e8-5c8bd0feb092",
      "machine_id": "TGN002_BS",
      "model": null,
      "cavity": null,
      "count_done": 6,
      "count_pending": 8,
      "category_name": "TGN",
      "history_count": "1599",
      "manufacturing_date": "0000-00-00",
      "unit": "h",
      "manufacturer": null,
      "status": "completed",
      "inspectors": "",
      "inspected_date": "2025-11-27 11:48:36",
    },
  ],
};
const mockEquipmentDetailJson = {
  "status": "success",
  "data": [
    {
      "code": "DI-INJ-000001",
      "wi_id": "e7a4b49f-a444-4134-9f6e-c0163b7cee9c",
      "content": "Inspect cooling water pipes and connectors for leakage",
      "inspected_date": null,
      "date_start": "2025-12-05 00:00:00",
      "status": "done",
      "result": null,
      "inspector_id": null,
      "inspector_name": null,
    },
    {
      "code": "DI-MOLD-000002",
      "wi_id": "f8b5c5a0-b555-4245-af7f-d1274c8dff0d",
      "content": "Check mold parting line venting holes – must be clean",
      "inspected_date": null,
      "date_start": "2025-12-05 00:00:00",
      "status": "done",
      "result": null,
      "inspector_id": null,
      "inspector_name": null,
    },
    {
      "code": "DI-TUFT-000003",
      "wi_id": "g9c6d6b1-c666-4346-bf8g-e2385d9egg1e",
      "content": "Inspect tufting copper wire condition and tension",
      "inspected_date": null,
      "date_start": "2025-12-04 00:00:00",
      "status": "done",
      "result": null,
      "inspector_id": null,
      "inspector_name": null,
    },
    {
      "code": "ML1-BLISTER-000004",
      "wi_id": "h0d7e7c2-d777-4447-cf9h-f3496eaff22f",
      "content": "Clean air intake filter on blister machines",
      "inspected_date": null,
      "date_start": "2025-12-01 00:00:00",
      "status": "done",
      "result": null,
      "inspector_id": null,
      "inspector_name": null,
    },
    {
      "code": "DI-CHILLER-000005",
      "wi_id": "i1e8f8d3-e888-4548-dfai-g45a7f0gh33g",
      "content": "Check cooling tower water level and fan operation",
      "inspected_date": null,
      "date_start": "2025-12-05 00:00:00",
      "status": null,
      "result": null,
      "inspector_id": null,
      "inspector_name": null,
    },
    {
      "code": "ML2-PACKING-000006",
      "wi_id": "j2f9g9e4-f999-4649-egbj-h56b8g1hi44h",
      "content": "Calibrate 4-head packing scale (±0.5g tolerance)",
      "inspected_date": null,
      "date_start": "2025-12-01 00:00:00",
      "status": null,
      "result": null,
      "inspector_id": null,
      "inspector_name": null,
    },
    {
      "code": "DI-ENDROUND-000007",
      "wi_id": "k3g0h0f5-g000-4740-fhck-i67c9h2ij55i",
      "content": "Inspect end-rounding blade sharpness and wear",
      "inspected_date": null,
      "date_start": "2025-12-05 00:00:00",
      "status": null,
      "result": null,
      "inspector_id": null,
      "inspector_name": null,
    },
    {
      "code": "ML3-COMPRESSOR-000008",
      "wi_id": "l4h1i1g6-h111-4841-gidl-j78d0i3jk66j",
      "content": "Compressor oil analysis and full replacement",
      "inspected_date": null,
      "date_start": "2025-11-20 00:00:00",
      "status": null,
      "result": null,
      "inspector_id": null,
      "inspector_name": null,
    },
    {
      "code": "DI-INJ-000009",
      "wi_id": "m5i2j2h7-i222-4942-hjem-k89e1j4kl77k",
      "content": "Clean material hopper and dryer on injection machines",
      "inspected_date": null,
      "date_start": "2025-12-02 00:00:00",
      "status": null,
      "result": null,
      "inspector_id": null,
      "inspector_name": null,
    },
    {
      "code": "ML1-TUFT-000010",
      "wi_id": "n6j3k3i8-j333-4043-ikfn-l90f2k5lm88l",
      "content": "Lubricate main shaft bearings on tufting machines",
      "inspected_date": null,
      "date_start": "2025-12-03 00:00:00",
      "status": null,
      "result": null,
      "inspector_id": null,
      "inspector_name": null,
    },
  ],
};
const mockFormJson = {
  "status": "success",
  "message": "Lấy dữ liệu thành công",
  "data": [
    {
      "uuid": "e7a4b49f-a444-4134-9f6e-c0163b7cee9c",
      "wi_id": "a0928b46-7517-4727-83aa-5edb3821ab69",
      "code": "DI-AC-000008",
      "name": "Water connectors and water pipes",
      "type": "Daily Inspection",

      // ★★★★★ NHIỀU STEP ★★★★★
      "schema": """
      [
        {
          "stepIndex": 1,
          "items": [
            {
              "id": "label001",
              "type": "label",
              "text": "General Information",
              "heading": "h2",
              "bold": true,
              "italic": false,
              "underline": false
            },
            {
              "id": "yesno001",
              "type": "yesno",
              "question": "Is the machine operating normally?",
              "default": null
            }
          ]
        },
        {
          "stepIndex": 2,
          "items": [
            {
              "id": "label002",
              "type": "label",
              "text": "Select inspection options",
              "heading": "h3",
              "bold": false,
              "italic": false,
              "underline": false
            },
            {
              "id": "single001",
              "type": "single",
              "question": "Oil level status",
              "options": ["Good", "Low", "Needs refill"],
              "default": null
            }
          ]
        },
        {
          "stepIndex": 3,
          "items": [
            {
              "id": "multi001",
              "type": "multiple",
              "question": "Which issues did you find?",
              "options": ["Leak", "Noise", "Vibration", "Heat"],
              "default": []
            },
            {
              "id": "staticImg001",
              "type": "staticImage",
              "url": "https://picsum.photos/300/200"
            }
          ]
        }
      ]
      """,

      "category_id": "3bdb2847-2ad1-4eb7-b263-fde581aeebd3",
      "equipment_id": "837db74f-178e-499b-b6e8-5c8bd0feb388",
      "status": null,
      "result": null,
      "date_start": "2025-11-06 00:00:00",
      "inspected_date": null,
      "inspector_id": null,
      "created_by": null,
      "updated_by": null,
      "deleted_by": null,
      "created_at": "2025-11-06 08:10:22",
      "updated_at": "2025-11-06 08:10:22",
      "deleted_at": null,
    },
  ],
};
const mockMaintenanceJson = {
  "status": "success",
  "date": "2025-12-05",
  "data": [
    {
      "uuid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "machine_id": "VI01043",
      "model": "Haitian MA1600",
      "cavity": "16",
      "manufacturer": "Haitian",
      "manufacturing_date": "2019-06-15",
      "history_count": "892104",
      "unit": "shot",
      "daily_rate": "2400",
      "category_name": "Blister",
      "category_id": "002ab1c3-b86e-49fc-98fd-3393b420bd73",
      "created_by": "EMP0123",
      "updated_by": "EMP0123",
      "deleted_by": null,
      "created_at": "2025-11-20 08:15:33",
      "updated_at": "2025-12-04 14:22:10",
      "deleted_at": null,
      "total": "6",
      "done": "4",
      "status": "done",
      "inspectors": "Nguyen Van An, Tran Thi Lan",
      "inspected_date": "2025-12-04 16:45:00",
    },
    {
      "uuid": "b2c3d4e5-f6g7-8901-bcde-f2345678901a",
      "machine_id": "VT02044",
      "model": "Zahoransky C40",
      "cavity": "26",
      "manufacturer": "Zahoransky",
      "manufacturing_date": "2021-03-22",
      "history_count": "2036179",
      "unit": "pcs",
      "daily_rate": "22000",
      "category_name": "Tufting",
      "category_id": "113cd5e6-f7g8-9012-cdef-3456789012bc",
      "created_by": "EMP0456",
      "updated_by": null,
      "deleted_by": null,
      "created_at": "2025-12-01 09:10:25",
      "updated_at": "2025-12-01 09:10:25",
      "deleted_at": null,
      "total": "8",
      "done": "0",
      "status": "pending",
      "inspectors": null,
      "inspected_date": null,
    },
    {
      "uuid": "c3d4e5f6-g7h8-9012-cdef-4567890123cd",
      "machine_id": "CH-CT-001",
      "model": "Liangchi LBC-150",
      "cavity": null,
      "manufacturer": "Liangchi",
      "manufacturing_date": "2018-11-10",
      "history_count": "48720",
      "unit": "h",
      "daily_rate": "24",
      "category_name": "Mold",
      "category_id": "224de6f7-g8h9-0123-def0-4567890123de",
      "created_by": "EMP0789",
      "updated_by": "EMP0789",
      "deleted_by": null,
      "created_at": "2025-11-15 07:30:00",
      "updated_at": "2025-12-03 11:20:45",
      "deleted_at": null,
      "total": "3",
      "done": "3",
      "status": "pending",
      "inspectors": "Le Van Minh",
      "inspected_date": "2025-12-03 10:55:12",
    },
    {
      "uuid": "d4e5f6g7-h8i9-0123-def0-5678901234ef",
      "machine_id": "CP-AC-002",
      "model": "Atlas Copco GA160",
      "cavity": null,
      "manufacturer": "Atlas Copco",
      "manufacturing_date": "2020-08-05",
      "history_count": "15840",
      "unit": "h",
      "daily_rate": "24",
      "category_name": "Mold",
      "category_id": "335ef7g8-h9i0-1234-ef01-5678901234ef",
      "created_by": "EMP1011",
      "updated_by": null,
      "deleted_by": null,
      "created_at": "2025-11-01 13:45:00",
      "updated_at": "2025-11-01 13:45:00",
      "deleted_at": null,
      "total": "5",
      "done": "0",
      "status": "done",
      "inspectors": null,
      "inspected_date": null,
    },
    {
      "uuid": "e5f6g7h8-i9j0-1234-ef01-6789012345fg",
      "machine_id": "BL-VP14005",
      "model": "Uhlmann B1880",
      "cavity": "4",
      "manufacturer": "Uhlmann",
      "manufacturing_date": "2022-05-18",
      "history_count": "374330",
      "unit": "pcs",
      "daily_rate": "4800",
      "category_name": "Blister",
      "category_id": "446fg8h9-i0j1-2345-f012-6789012345fg",
      "created_by": "EMP1213",
      "updated_by": "EMP1213",
      "deleted_by": null,
      "created_at": "2025-12-02 10:20:18",
      "updated_at": "2025-12-04 15:33:40",
      "deleted_at": null,
      "total": "4",
      "done": "2",
      "status": "done",
      "inspectors": "Pham Thi Huong, Hoang Van Duc",
      "inspected_date": "2025-12-04 14:50:22",
    },
    {
      "uuid": "f6g7h8i9-j0k1-2345-f012-7890123456gh",
      "machine_id": "TY2024-007",
      "model": "Custom Mold",
      "cavity": "16",
      "manufacturer": "In-house",
      "manufacturing_date": "2024-07-10",
      "history_count": "483712",
      "unit": "shot",
      "daily_rate": "1800",
      "category_name": "Mold",
      "category_id": "557gh9i0-j1k2-3456-0123-7890123456gh",
      "created_by": "EMP1415",
      "updated_by": null,
      "deleted_by": null,
      "created_at": "2025-10-25 11:11:11",
      "updated_at": "2025-10-25 11:11:11",
      "deleted_at": null,
      "total": "7",
      "done": "0",
      "status": "pending",
      "inspectors": null,
      "inspected_date": null,
    },
  ],
};
const mockMaintenanceDetailJson = {
  "status": "success",
  "date": "2025-12-05",
  "data": [
    {
      "uuid": "96fbc31c-1e21-4503-b628-88e2a4670501",
      "wi_id": "4b32bdcb-2a77-43b9-adea-aea32e8ed6d9",
      "equipment_id": "5a106201-4856-4358-badb-0aaae21ae1c2",
      "code": "ML0015",
      "name": "Clean screw & barrel + check heater bands",
      "type": "Maintenance Level 1",
      "schema":
          "[{\"stepIndex\":1,\"isVisible\":true,\"preparation\":true,\"items\":[{\"id\":\"lbl001\",\"type\":\"label\",\"text\":\"Screw & Barrel Cleaning\",\"heading\":\"h3\",\"bold\":true},{\"id\":\"yn001\",\"type\":\"yesno\",\"question\":\"Is screw and barrel cleaned thoroughly?\"}]},{\"stepIndex\":2,\"isVisible\":true,\"preparation\":false,\"items\":[{\"id\":\"yn002\",\"type\":\"yesno\",\"question\":\"Are all heater bands functioning and properly tightened?\"},{\"id\":\"lbl002\",\"type\":\"label\",\"text\":\"Record heater band resistance values\",\"heading\":\"h4\",\"bold\":false}]}]",
      "category_id": "0bbb36f4-8356-4a82-bb53-972f7252f5a0",
      "frequency": "Unit",
      "unit_value": "19000",
      "unit_type": "shot",
      "status": "pending",
      "result": "pass",
      "times": "1",
      "count_target": "95000",
      "date_start": "2025-12-01 08:00:00",
      "inspected_date": "2025-12-04 14:30:22",
      "inspector_id": "EMP0231",
      "created_by": "EMP0123",
      "updated_by": "EMP0231",
      "deleted_by": null,
      "created_at": "2025-10-29 14:31:52",
      "updated_at": "2025-12-04 14:31:00",
      "deleted_at": null,
      "username": "Nguyen Van An",
    },
    {
      "uuid": "a7g8h9i0-2j3k-4l5m-6n7o-8p9q0r1s2t3u",
      "wi_id": "5c43cecd-3b88-44ca-befb-bfb43f9fe7ea",
      "equipment_id": "5a106201-4856-4358-badb-0aaae21ae1c2",
      "code": "ML020022",
      "name": "Main shaft bearing lubrication & alignment check",
      "type": "Maintenance Level 2",
      "schema":
          "[{\"stepIndex\":1,\"isVisible\":true,\"preparation\":true,\"items\":[{\"id\":\"lbl101\",\"type\":\"label\",\"text\":\"Main Shaft Lubrication\",\"heading\":\"h3\",\"bold\":true},{\"id\":\"yn101\",\"type\":\"yesno\",\"question\":\"Applied Klüber Isoflex NBU 15 to all main shaft bearings?\"}]},{\"stepIndex\":2,\"isVisible\":true,\"preparation\":false,\"items\":[{\"id\":\"yn102\",\"type\":\"yesno\",\"question\":\"Shaft runout within 0.02mm?\"},{\"id\":\"yn103\",\"type\":\"yesno\",\"question\":\"No abnormal noise during manual rotation?\"},{\"id\":\"lbl102\",\"type\":\"label\",\"text\":\"Record grease quantity used\",\"heading\":\"h4\",\"bold\":false}]}]",
      "category_id": "0bbb36f4-8356-4a82-bb53-972f7252f5a0",
      "frequency": "Unit",
      "unit_value": "400000",
      "unit_type": "pcs",
      "status": "done",
      "result": null,
      "times": "1",
      "count_target": "2000000",
      "date_start": "2025-12-03 09:00:00",
      "inspected_date": null,
      "inspector_id": "EMP0456",
      "created_by": "EMP0345",
      "updated_by": "EMP0456",
      "deleted_by": null,
      "created_at": "2025-11-10 10:15:30",
      "updated_at": "2025-12-03 09:05:00",
      "deleted_at": null,
      "username": "Tran Van Minh",
    },
    {
      "uuid": "b8h9i0j1-3k4l-5m6n-7o8p-9q0r1s2t3u4v",
      "wi_id": "6d54dfde-4c99-55db-cgfc-cgc54g0gf8fb",
      "equipment_id": "5a106201-4856-4358-badb-0aaae21ae1c2",
      "code": "ML03008",
      "name": "Compressor oil analysis & full replacement",
      "type": "Maintenance Level 3",
      "schema":
          "[{\"stepIndex\":1,\"isVisible\":true,\"preparation\":true,\"items\":[{\"id\":\"lbl201\",\"type\":\"label\",\"text\":\"Oil Analysis & Replacement\",\"heading\":\"h3\",\"bold\":true},{\"id\":\"yn201\",\"type\":\"yesno\",\"question\":\"Oil sample taken and sent to lab?\"}]},{\"stepIndex\":2,\"isVisible\":true,\"preparation\":false,\"items\":[{\"id\":\"yn202\",\"type\":\"yesno\",\"question\":\"Oil and oil filter fully replaced?\"},{\"id\":\"yn203\",\"type\":\"yesno\",\"question\":\"Oil separator element replaced?\"},{\"id\":\"lbl202\",\"type\":\"label\",\"text\":\"Record new oil batch number\",\"heading\":\"h4\",\"bold\":false}]}]",
      "category_id": "0bbb36f4-8356-4a82-bb53-972f7252f5a0",
      "frequency": "Unit",
      "unit_value": "8000",
      "unit_type": "h",
      "status": "pending",
      "result": null,
      "times": "1",
      "count_target": "24000",
      "date_start": "2025-11-28 00:00:00",
      "inspected_date": null,
      "inspector_id": null,
      "created_by": "EMP0789",
      "updated_by": null,
      "deleted_by": null,
      "created_at": "2025-11-01 13:20:00",
      "updated_at": "2025-11-01 13:20:00",
      "deleted_at": null,
      "username": null,
    },
    {
      "uuid": "c9i0j1k2-4l5m-6n7o-8p9q-0r1s2t3u4v5w",
      "wi_id": "7e65efdf-5d00-66ec-dhgd-dhd65h1hg9gc",
      "equipment_id": "5a106201-4856-4358-badb-0aaae21ae1c2",
      "code": "ML020031",
      "name": "Blister forming heater calibration",
      "type": "Maintenance Level 2",
      "schema":
          "[{\"stepIndex\":1,\"isVisible\":true,\"preparation\":true,\"items\":[{\"id\":\"lbl301\",\"type\":\"label\",\"text\":\"Forming Heater Calibration\",\"heading\":\"h3\",\"bold\":true},{\"id\":\"yn301\",\"type\":\"yesno\",\"question\":\"All forming heaters calibrated to ±2°C?\"}]},{\"stepIndex\":2,\"isVisible\":true,\"preparation\":false,\"items\":[{\"id\":\"yn302\",\"type\":\"yesno\",\"question\":\"Sealing temperature within specification?\"},{\"id\":\"lbl302\",\"type\":\"label\",\"text\":\"Record calibration certificate number\",\"heading\":\"h4\",\"bold\":false}]}]",
      "category_id": "0bbb36f4-8356-4a82-bb53-972f7252f5a0",
      "frequency": "Unit",
      "unit_value": "6",
      "unit_type": "month",
      "status": "pending",
      "result": null,
      "times": "1",
      "count_target": "6",
      "date_start": "2025-11-01 00:00:00",
      "inspected_date": null,
      "inspector_id": null,
      "created_by": "EMP1011",
      "updated_by": null,
      "deleted_by": null,
      "created_at": "2025-10-15 09:45:00",
      "updated_at": "2025-10-15 09:45:00",
      "deleted_at": null,
      "username": null,
    },
  ],
};
const mockOverdueJson = {
  "data": [
    {
      "uuid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "machine_id": "VI01043",
      "model": "Haitian MA1600",
      "cavity": "16",
      "total_overdue": "12",
    },
    {
      "uuid": "b2c3d4e5-f6g7-8901-bcde-f2345678901a",
      "machine_id": "VT02051",
      "model": "Zahoransky C40",
      "cavity": "26",
      "total_overdue": "9",
    },
    {
      "uuid": "c3d4e5f6-g7h8-9012-cdef-4567890123cd",
      "machine_id": "CP-AC-002",
      "model": "Atlas Copco GA160",
      "cavity": null,
      "total_overdue": "7",
    },
    {
      "uuid": "d4e5f6g7-h8i9-0123-def0-5678901234ef",
      "machine_id": "CH-CT-001",
      "model": "Liangchi LBC-150",
      "cavity": null,
      "total_overdue": "5",
    },
    {
      "uuid": "e5f6g7h8-i9j0-1234-ef01-6789012345fg",
      "machine_id": "BL-VP14005",
      "model": "Uhlmann B1880",
      "cavity": "4",
      "total_overdue": "4",
    },
    {
      "uuid": "f6g7h8i9-j0k1-2345-f012-7890123456gh",
      "machine_id": "TY2024-007",
      "model": "Custom Mold",
      "cavity": "16",
      "total_overdue": "3",
    },
    {
      "uuid": "g7h8i9j0-k1l2-3456-0123-8901234567hi",
      "machine_id": "VT02008",
      "model": "Zahoransky C40",
      "cavity": "12",
      "total_overdue": "2",
    },
    {
      "uuid": "h8i9j0k1-l2m3-4567-1234-9012345678ij",
      "machine_id": "PK-SCALE-01",
      "model": "Ishida CCW-RV",
      "cavity": "4",
      "total_overdue": "1",
    },
  ],
};
const mockOverdueDetailJson = {
  "data": [
    {
      "code": "ML01-0015",
      "description": "Clean screw & barrel + check heater bands",
      "type": "Maintenance Level 1",
      "date_start": "2025-11-20 08:00:00",
      "schema":
          "[{\"stepIndex\":1,\"isVisible\":true,\"preparation\":true,\"items\":[{\"id\":\"inj001\",\"type\":\"label\",\"text\":\"Screw & Barrel Cleaning\",\"heading\":\"h3\",\"bold\":true},{\"id\":\"yn001\",\"type\":\"yesno\",\"question\":\"Has the screw and barrel been cleaned thoroughly?\"}]},{\"stepIndex\":2,\"isVisible\":true,\"preparation\":false,\"items\":[{\"id\":\"yn002\",\"type\":\"yesno\",\"question\":\"Are all heater bands tight and functioning?\"},{\"id\":\"yn003\",\"type\":\"yesno\",\"question\":\"No abnormal temperature deviation?\"}]}]",
      "uuid": "96fbc31c-1e21-4503-b628-88e2a4670501",
    },
    {
      "code": "ML02-0022",
      "description": "Main shaft bearing lubrication & alignment check",
      "type": "Maintenance Level 2",
      "date_start": "2025-11-28 09:00:00",
      "schema":
          "[{\"stepIndex\":1,\"isVisible\":true,\"preparation\":true,\"items\":[{\"id\":\"tuft001\",\"type\":\"label\",\"text\":\"Main Shaft Lubrication\",\"heading\":\"h3\",\"bold\":true},{\"id\":\"yn101\",\"type\":\"yesno\",\"question\":\"Applied Klüber Isoflex NBU 15 to all bearings?\"}]},{\"stepIndex\":2,\"isVisible\":true,\"preparation\":false,\"items\":[{\"id\":\"yn102\",\"type\":\"yesno\",\"question\":\"Shaft runout ≤ 0.02mm?\"},{\"id\":\"yn103\",\"type\":\"yesno\",\"question\":\"No vibration or abnormal noise during rotation?\"}]}]",
      "uuid": "a7g8h9i0-2j3k-4l5m-6n7o-8p9q0r1s2t3u",
    },
    {
      "code": "ML03-0008",
      "description": "Compressor oil analysis & full replacement",
      "type": "Maintenance Level 3",
      "date_start": "2025-11-15 00:00:00",
      "schema":
          "[{\"stepIndex\":1,\"isVisible\":true,\"preparation\":true,\"items\":[{\"id\":\"comp001\",\"type\":\"label\",\"text\":\"Oil Analysis & Replacement\",\"heading\":\"h3\",\"bold\":true},{\"id\":\"yn201\",\"type\":\"yesno\",\"question\":\"Oil sample taken and sent to lab?\"}]},{\"stepIndex\":2,\"isVisible\":true,\"preparation\":false,\"items\":[{\"id\":\"yn202\",\"type\":\"yesno\",\"question\":\"Oil, oil filter and separator replaced?\"},{\"id\":\"yn203\",\"type\":\"yesno\",\"question\":\"Oil level correct after startup?\"}]}]",
      "uuid": "c9i0j1k2-4l5m-6n7o-8p9q-0r1s2t3u4v5w",
    },
    {
      "code": "ML02-0031",
      "description": "Blister forming heater calibration",
      "type": "Maintenance Level 2",
      "date_start": "2025-11-01 00:00:00",
      "schema":
          "[{\"stepIndex\":1,\"isVisible\":true,\"preparation\":true,\"items\":[{\"id\":\"blist001\",\"type\":\"label\",\"text\":\"Forming Heater Calibration\",\"heading\":\"h3\",\"bold\":true},{\"id\":\"yn301\",\"type\":\"yesno\",\"question\":\"All forming heaters calibrated to ±2°C?\"}]},{\"stepIndex\":2,\"isVisible\":true,\"preparation\":false,\"items\":[{\"id\":\"yn302\",\"type\":\"yesno\",\"question\":\"Sealing temperature stable within spec?\"},{\"id\":\"yn303\",\"type\":\"yesno\",\"question\":\"Calibration certificate updated?\"}]}]",
      "uuid": "d0j1k2l3-5m6n-7o8p-9q0r-1s2t3u4v5w6x",
    },
    {
      "code": "ML01-0009",
      "description": "Mold parting line & venting cleaning",
      "type": "Maintenance Level 1",
      "date_start": "2025-11-25 07:30:00",
      "schema":
          "[{\"stepIndex\":1,\"isVisible\":true,\"preparation\":true,\"items\":[{\"id\":\"mold001\",\"type\":\"label\",\"text\":\"Mold Venting Maintenance\",\"heading\":\"h3\",\"bold\":true},{\"id\":\"yn401\",\"type\":\"yesno\",\"question\":\"All parting line vents cleaned and free from plastic residue?\"}]},{\"stepIndex\":2,\"isVisible\":true,\"preparation\":false,\"items\":[{\"id\":\"yn402\",\"type\":\"yesno\",\"question\":\"No blocked vents found?\"},{\"id\":\"yn403\",\"type\":\"yesno\",\"question\":\"Air blow test performed on all vents?\"}]}]",
      "uuid": "e1k2l3m4-6n7o-8p9q-0r1s-2t3u4v5w6x7y",
    },
    {
      "code": "ML03-0005",
      "description": "Cooling tower fan motor bearing replacement",
      "type": "Maintenance Level 3",
      "date_start": "2025-10-30 00:00:00",
      "schema":
          "[{\"stepIndex\":1,\"isVisible\":true,\"preparation\":true,\"items\":[{\"id\":\"chill001\",\"type\":\"label\",\"text\":\"Fan Motor Overhaul\",\"heading\":\"h3\",\"bold\":true},{\"id\":\"yn501\",\"type\":\"yesno\",\"question\":\"Fan motor bearings replaced with new SKF units?\"}]},{\"stepIndex\":2,\"isVisible\":true,\"preparation\":false,\"items\":[{\"id\":\"yn502\",\"type\":\"yesno\",\"question\":\"Vibration level after startup < 2.5 mm/s?\"},{\"id\":\"yn503\",\"type\":\"yesno\",\"question\":\"Motor current within nameplate rating?\"}]}]",
      "uuid": "f2l3m4n5-7o8p-9q0r-1s2t-3u4v5w6x7y8z",
    },
    {
      "code": "ML02-0007",
      "description": "4-head scale calibration and cleaning",
      "type": "Maintenance Level 2",
      "date_start": "2025-11-10 00:00:00",
      "schema":
          "[{\"stepIndex\":1,\"isVisible\":true,\"preparation\":true,\"items\":[{\"id\":\"pack001\",\"type\":\"label\",\"text\":\"Scale Calibration\",\"heading\":\"h3\",\"bold\":true},{\"id\":\"yn601\",\"type\":\"yesno\",\"question\":\"Calibrated using certified 100g & 500g weights?\"}]},{\"stepIndex\":2,\"isVisible\":true,\"preparation\":false,\"items\":[{\"id\":\"yn602\",\"type\":\"yesno\",\"question\":\"All 4 heads accuracy within ±0.5g?\"},{\"id\":\"yn603\",\"type\":\"yesno\",\"question\":\"Load cells cleaned and free from debris?\"}]}]",
      "uuid": "g3m4n5o6-8p9q-0r1s-2t3u-4v5w6x7y8z9a",
    },
  ],
};
const _fakeJwtPayload = {
  "sub": "12345",
  "username": "admin",
  "role": "admin",
  "exp": 1893456000, // năm 2030
};

String generateMockJwt() {
  final header = base64Url.encode(utf8.encode(jsonEncode({"alg": "HS256"})));
  final payload = base64Url.encode(utf8.encode(jsonEncode(_fakeJwtPayload)));
  const signature = "mocksignature";
  return "$header.$payload.$signature";
}

const mockLoginResponse = {
  "accessToken": "MOCK WILL BE REPLACED",
  "refreshToken": "MOCK_REFRESH",
  "message": "Login success (mock)",
};
